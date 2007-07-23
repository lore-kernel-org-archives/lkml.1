Return-Path: <linux-kernel-owner+w=401wt.eu-S936466AbXGWVF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936466AbXGWVF6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 17:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762992AbXGWVFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 17:05:49 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:26327 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762067AbXGWVFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 17:05:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type;
        b=sf4RzwKj9Zp9l/zTlRCsOZQduPpgclGJ47C4/59e7I1lixvPEWHOMX3hVqAuiau5+PZ26Zp/T/VWunNwtKCgprYNfBamL9f3f5eESBULpfLIkB+hbynqkb2aK5wEm5NhEZA7bIimVdRBsgwir/OPoWTkGvnMiqotEUu9fVM0Lx0=
Message-ID: <8b67d60707231405l514c1b87t6ad3f8890f5d83ba@mail.gmail.com>
Date: Mon, 23 Jul 2007 22:05:46 +0100
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: lethal@linux-sh.org
Subject: [PATCH] Fix Dreamcast DMA issues
Cc: linux-kernel@vger.kernel.org, adrian@mcmen.demon.co.uk
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_136619_7242320.1185224746911"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_136619_7242320.1185224746911
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

The current SH DMA API is somewhat broken, not correctly matching
virtual channel to the correct SH DMAC. This wasn't noticeable when
using g2 DMA for the sound driver - one channel 0 is as good as any
other! - but caused the pvr2 driver to fail.

This patch fixes the pvr2 problem and consequently fixes the sound
driver to ensure it continues to function.

Signed-off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>

------=_Part_136619_7242320.1185224746911
Content-Type: text/x-patch; name="dreamcast-dma-patch.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="dreamcast-dma-patch.diff"
X-Attachment-Id: f_f4hg6w6i

ZGlmZiAtLWdpdCBhL2FyY2gvc2gvZHJpdmVycy9kbWEvZG1hLWFwaS5jIGIvYXJjaC9zaC9kcml2
ZXJzL2RtYS9kbWEtYXBpLmMKaW5kZXggY2Y4ZTExOS4uNzZlZDgxNiAxMDA2NDQKLS0tIGEvYXJj
aC9zaC9kcml2ZXJzL2RtYS9kbWEtYXBpLmMKKysrIGIvYXJjaC9zaC9kcml2ZXJzL2RtYS9kbWEt
YXBpLmMKQEAgLTMxLDggKzMxLDggQEAgc3RydWN0IGRtYV9pbmZvICpnZXRfZG1hX2luZm8odW5z
aWduZWQgaW50IGNoYW4pCiAJICogdGhlIGNoYW5uZWwgaXMuCiAJICovCiAJbGlzdF9mb3JfZWFj
aF9lbnRyeShpbmZvLCAmcmVnaXN0ZXJlZF9kbWFjX2xpc3QsIGxpc3QpIHsKLQkJaWYgKChjaGFu
IDwgIGluZm8tPmZpcnN0X2NoYW5uZWxfbnIpIHx8Ci0JCSAgICAoY2hhbiA+PSBpbmZvLT5maXJz
dF9jaGFubmVsX25yICsgaW5mby0+bnJfY2hhbm5lbHMpKQorCQlpZiAoKGNoYW4gPCAgaW5mby0+
Zmlyc3RfdmNoYW5uZWxfbnIpIHx8CisJCSAgICAoY2hhbiA+PSBpbmZvLT5maXJzdF92Y2hhbm5l
bF9uciArIGluZm8tPm5yX2NoYW5uZWxzKSkKIAkJCWNvbnRpbnVlOwogCiAJCXJldHVybiBpbmZv
OwpAQCAtODIsNyArODIsNyBAQCBzdHJ1Y3QgZG1hX2NoYW5uZWwgKmdldF9kbWFfY2hhbm5lbCh1
bnNpZ25lZCBpbnQgY2hhbikKIAogCWZvciAoaSA9IDA7IGkgPCBpbmZvLT5ucl9jaGFubmVsczsg
aSsrKSB7CiAJCWNoYW5uZWwgPSAmaW5mby0+Y2hhbm5lbHNbaV07Ci0JCWlmIChjaGFubmVsLT5j
aGFuID09IGNoYW4pCisJCWlmIChjaGFubmVsLT52Y2hhbiA9PSBjaGFuKQogCQkJcmV0dXJuIGNo
YW5uZWw7CiAJfQogCkBAIC0zNjksNiArMzY5LDcgQEAgaW50IHJlZ2lzdGVyX2RtYWMoc3RydWN0
IGRtYV9pbmZvICppbmZvKQogCX0KIAogCXRvdGFsX2NoYW5uZWxzID0gZ2V0X25yX2NoYW5uZWxz
KCk7CisJaW5mby0+Zmlyc3RfdmNoYW5uZWxfbnIgPSB0b3RhbF9jaGFubmVsczsKIAlmb3IgKGkg
PSAwOyBpIDwgaW5mby0+bnJfY2hhbm5lbHM7IGkrKykgewogCQlzdHJ1Y3QgZG1hX2NoYW5uZWwg
KmNoYW4gPSAmaW5mby0+Y2hhbm5lbHNbaV07CiAKZGlmZiAtLWdpdCBhL2luY2x1ZGUvYXNtLXNo
L2RtYS5oIGIvaW5jbHVkZS9hc20tc2gvZG1hLmgKaW5kZXggNjAzNGQ0YS4uNGM3NWI3MCAxMDA2
NDQKLS0tIGEvaW5jbHVkZS9hc20tc2gvZG1hLmgKKysrIGIvaW5jbHVkZS9hc20tc2gvZG1hLmgK
QEAgLTExMSw2ICsxMTEsNyBAQCBzdHJ1Y3QgZG1hX2luZm8gewogCiAJc3RydWN0IGxpc3RfaGVh
ZCBsaXN0OwogCWludCBmaXJzdF9jaGFubmVsX25yOworCWludCBmaXJzdF92Y2hhbm5lbF9ucjsK
IH07CiAKIHN0cnVjdCBkbWFfY2hhbl9jYXBzIHsKZGlmZiAtLWdpdCBhL3NvdW5kL3NoL2FpY2Eu
aCBiL3NvdW5kL3NoL2FpY2EuaAppbmRleCA4YzExZTNkLi5kMDk4YmFhIDEwMDY0NAotLS0gYS9z
b3VuZC9zaC9haWNhLmgKKysrIGIvc291bmQvc2gvYWljYS5oCkBAIC01Miw3ICs1Miw3IEBACiAj
ZGVmaW5lIEFJQ0FfQ0hBTk5FTDFfT0ZGU0VUIDB4MjEwMDAKICNkZWZpbmUgQ0hBTk5FTF9PRkZT
RVQgMHgxMDAwMAogCi0jZGVmaW5lIEFJQ0FfRE1BX0NIQU5ORUwgMAorI2RlZmluZSBBSUNBX0RN
QV9DSEFOTkVMIDUKICNkZWZpbmUgQUlDQV9ETUFfTU9ERSA1CiAKICNkZWZpbmUgU05EX0FJQ0Ff
RFJJVkVSICJBSUNBIgo=
------=_Part_136619_7242320.1185224746911--
