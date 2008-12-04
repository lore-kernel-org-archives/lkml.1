Return-Path: <linux-kernel-owner+w=401wt.eu-S1756787AbYLDRV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787AbYLDRV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:21:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbYLDRVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:21:21 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:47173 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbYLDRVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:21:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=N8Zs7Z9AWd9CX7ttRLGvZ2PL2nlE19Tos0ErO9mzquTA2HYyLvkPfcuHea3olJy2SP
         YAGS/Phus5KKSF0/uBtni2InMOD/ljjBeXRsQw9mcbGS/YJz2lhdBGDL9HAEXhkugq2q
         4cendbPcHM1NtRyaxNnvHS9RhWXzTK3+Lsy98=
Message-ID: <87a5b0800812040921i420c2076vbfcfa8ab456ecb0d@mail.gmail.com>
Date: Thu, 4 Dec 2008 17:21:18 +0000
From: "Will Newton" <will.newton@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] 8250: Add back missing space from banner printk.
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_8598_26917008.1228411278494"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_8598_26917008.1228411278494
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

A space went missing from the printk output at port initialization time,
add it back so the output is more readable.

Signed-off-by: Will Newton <will.newton@gmail.com>
---
 drivers/serial/8250.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 303272a..ffa6c72 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -3018,7 +3018,7 @@ static int __init serial8250_init(void)
 	if (nr_uarts > UART_NR)
 		nr_uarts = UART_NR;

-	printk(KERN_INFO "Serial: 8250/16550 driver"
+	printk(KERN_INFO "Serial: 8250/16550 driver "
 		"%d ports, IRQ sharing %sabled\n", nr_uarts,
 		share_irqs ? "en" : "dis");

-- 
1.5.5.2

------=_Part_8598_26917008.1228411278494
Content-Type: text/x-patch;
 name=0001-8250-Add-back-missing-space-from-banner-printk.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_foboc08u0
Content-Disposition: attachment;
 filename=0001-8250-Add-back-missing-space-from-banner-printk.patch

RnJvbSA4ZTA1YmEwM2NhYTMzNjdlNDY2OGQwNTFkOTdhOWRjY2E3ZWVhMDc2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBXaWxsIE5ld3RvbiA8d2lsbC5uZXd0b25AZ21haWwuY29tPgpE
YXRlOiBUaHUsIDQgRGVjIDIwMDggMTc6MTg6MjAgKzAwMDAKU3ViamVjdDogW1BBVENIXSA4MjUw
OiBBZGQgYmFjayBtaXNzaW5nIHNwYWNlIGZyb20gYmFubmVyIHByaW50ay4KCkEgc3BhY2Ugd2Vu
dCBtaXNzaW5nIGZyb20gdGhlIHByaW50ayBvdXRwdXQgYXQgcG9ydCBpbml0aWFsaXphdGlvbiB0
aW1lLAphZGQgaXQgYmFjayBzbyB0aGUgb3V0cHV0IGlzIG1vcmUgcmVhZGFibGUuCgpTaWduZWQt
b2ZmLWJ5OiBXaWxsIE5ld3RvbiA8d2lsbC5uZXd0b25AZ21haWwuY29tPgotLS0KIGRyaXZlcnMv
c2VyaWFsLzgyNTAuYyB8ICAgIDIgKy0KIDEgZmlsZXMgY2hhbmdlZCwgMSBpbnNlcnRpb25zKCsp
LCAxIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2VyaWFsLzgyNTAuYyBiL2Ry
aXZlcnMvc2VyaWFsLzgyNTAuYwppbmRleCAzMDMyNzJhLi5mZmE2YzcyIDEwMDY0NAotLS0gYS9k
cml2ZXJzL3NlcmlhbC84MjUwLmMKKysrIGIvZHJpdmVycy9zZXJpYWwvODI1MC5jCkBAIC0zMDE4
LDcgKzMwMTgsNyBAQCBzdGF0aWMgaW50IF9faW5pdCBzZXJpYWw4MjUwX2luaXQodm9pZCkKIAlp
ZiAobnJfdWFydHMgPiBVQVJUX05SKQogCQlucl91YXJ0cyA9IFVBUlRfTlI7CiAKLQlwcmludGso
S0VSTl9JTkZPICJTZXJpYWw6IDgyNTAvMTY1NTAgZHJpdmVyIgorCXByaW50ayhLRVJOX0lORk8g
IlNlcmlhbDogODI1MC8xNjU1MCBkcml2ZXIgIgogCQkiJWQgcG9ydHMsIElSUSBzaGFyaW5nICVz
YWJsZWRcbiIsIG5yX3VhcnRzLAogCQlzaGFyZV9pcnFzID8gImVuIiA6ICJkaXMiKTsKIAotLSAK
MS41LjUuMgoK
------=_Part_8598_26917008.1228411278494--
