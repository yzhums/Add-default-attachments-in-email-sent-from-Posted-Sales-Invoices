codeunit 50113 SendEmailHandler
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document-Mailing", OnBeforeEmailFileInternal, '', false, false)]
    local procedure OnBeforeEmailFileInternal(var TempEmailItem: Record "Email Item" temporary; var PostedDocNo: Code[20])
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        DocAttach: Record "Document Attachment";
        TempBlob: Codeunit "Temp Blob";
        DocumentOutStream: OutStream;
        DocumentInStream: InStream;
    begin
        if SalesInvoiceHeader.Get(PostedDocNo) then begin
            DocAttach.SetRange("Table ID", Database::"Sales Invoice Header");
            DocAttach.SetRange("No.", SalesInvoiceHeader."No.");
            if DocAttach.FindSet() then
                repeat
                    if DocAttach."Document Reference ID".HasValue then begin
                        TempBlob.CreateOutStream(DocumentOutStream);
                        DocAttach."Document Reference ID".ExportStream(DocumentOutStream);
                        TempBlob.CreateInStream(DocumentInStream);
                        TempEmailItem.AddAttachment(DocumentInStream, DocAttach."File Name");
                    end;
                until DocAttach.Next() = 0;
        end;
    end;
}
