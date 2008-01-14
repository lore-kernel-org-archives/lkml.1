Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209AbYANTEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbYANTEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 14:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbYANTEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 14:04:45 -0500
Received: from ts.adaptec.com ([162.62.93.58]:33966 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbYANTEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 14:04:44 -0500
From: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
CC: "'linux-kernel'" <linux-kernel@vger.kernel.org>,
       "'James Bottomley'" <James.Bottomley@HansenPartnership.com>,
       "'jschopp@austin.ibm.com'" <jschopp@austin.ibm.com>,
       "'apw@shadowen.org'" <apw@shadowen.org>,
       "'rdunlap@xenotime.net'" <rdunlap@xenotime.net>,
       "'FUJITA Tomonori'" <tomof@acm.org>,
       "'fujita.tomonori@lab.ntt.co.jp'" <fujita.tomonori@lab.ntt.co.jp>
Date: Mon, 14 Jan 2008 11:04:40 -0800
Subject: RE: Checkpatch.pl failure
Thread-Topic: Checkpatch.pl failure
Thread-Index: AchWxWAtcLUk6BpzTgCbmySgJ/lVMwAFyvdQ
Message-ID: <532ABFBDAAC3A34EB12EBA6CEC2838F438AEACC7@ADPE2K703.adaptec.com>
References: <1200325734.3159.1.camel@localhost.localdomain>
In-Reply-To: <1200325734.3159.1.camel@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: multipart/mixed;
	boundary="_002_532ABFBDAAC3A34EB12EBA6CEC2838F438AEACC7ADPE2K703adapte_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F438AEACC7ADPE2K703adapte_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Suppress one of the bogus checkpatch.pl error, the side-effect of the error=
 highlighted that this constant should be replaced by an existing manifest.=
 checkpatch.pl needs to be corrected to accept the comment style to deal wi=
th the other cases should they ever be touched by future patches. This is a=
 tangled set of coat hangers, tug on one and never know how complicated of =
a mess might follow!

This attached patch is against current scsi-misc-2.6.

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's hand=
ling of patch attachments, use the attachment, not the inline patch.

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

 drivers/scsi/dpt_i2o.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -ru a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
--- a/drivers/scsi/dpt_i2o.c    2008-01-14 13:39:11.086600955 -0500
+++ b/drivers/scsi/dpt_i2o.c    2008-01-14 13:41:44.813246497 -0500
@@ -2296,7 +2296,7 @@

                // copy over the request sense data if it was a check
                // condition status
-               if (dev_status =3D=3D 0x02 /*CHECK_CONDITION*/) {
+               if (dev_status =3D=3D SAM_STAT_CHECK_CONDITION) {
                        u32 len =3D min(SCSI_SENSE_BUFFERSIZE, 40);
                        // Copy over the sense data
                        memcpy_fromio(cmd->sense_buffer, (reply+28) , len);

This geek joke brought to you by -- Mark Salyzyn

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of
> James Bottomley
> Sent: Monday, January 14, 2008 10:49 AM
> To: rdunlap@xenotime.net; apw@shadowen.org; jschopp@austin.ibm.com
> Cc: linux-kernel
> Subject: Checkpatch.pl failure
>
> This error:
>
> ERROR: no space before that close parenthesis ')'
> #501: FILE: drivers/scsi/dpt_i2o.c:2299:
> +               if (dev_status =3D=3D 0x02 /*CHECK_CONDITION*/) {
>
> Is definitely wrong.  I think it's stripped the comments so now the if
> looks to have a space before the bracket, but stylistically the
> complaint it has errored out for is wrong.
>
> James

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F438AEACC7ADPE2K703adapte_
Content-Type: application/octet-stream; name="dpt_i2o_CHECK_CONDITION.patch"
Content-Description: dpt_i2o_CHECK_CONDITION.patch
Content-Disposition: attachment; filename="dpt_i2o_CHECK_CONDITION.patch";
	size=525; creation-date="Mon, 14 Jan 2008 10:44:10 GMT";
	modification-date="Mon, 14 Jan 2008 10:44:10 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvZHB0X2kyby5jIGIvZHJpdmVycy9zY3NpL2RwdF9pMm8u
YwotLS0gYS9kcml2ZXJzL3Njc2kvZHB0X2kyby5jCTIwMDgtMDEtMTQgMTM6Mzk6MTEuMDg2NjAw
OTU1IC0wNTAwCisrKyBiL2RyaXZlcnMvc2NzaS9kcHRfaTJvLmMJMjAwOC0wMS0xNCAxMzo0MTo0
NC44MTMyNDY0OTcgLTA1MDAKQEAgLTIyOTYsNyArMjI5Niw3IEBACiAKIAkJLy8gY29weSBvdmVy
IHRoZSByZXF1ZXN0IHNlbnNlIGRhdGEgaWYgaXQgd2FzIGEgY2hlY2sKIAkJLy8gY29uZGl0aW9u
IHN0YXR1cwotCQlpZiAoZGV2X3N0YXR1cyA9PSAweDAyIC8qQ0hFQ0tfQ09ORElUSU9OKi8pIHsK
KwkJaWYgKGRldl9zdGF0dXMgPT0gU0FNX1NUQVRfQ0hFQ0tfQ09ORElUSU9OKSB7CiAJCQl1MzIg
bGVuID0gbWluKFNDU0lfU0VOU0VfQlVGRkVSU0laRSwgNDApOwogCQkJLy8gQ29weSBvdmVyIHRo
ZSBzZW5zZSBkYXRhCiAJCQltZW1jcHlfZnJvbWlvKGNtZC0+c2Vuc2VfYnVmZmVyLCAocmVwbHkr
MjgpICwgbGVuKTsK

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F438AEACC7ADPE2K703adapte_--
