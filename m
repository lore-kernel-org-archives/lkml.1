Return-Path: <linux-kernel-owner+w=401wt.eu-S940561AbXGSTav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940561AbXGSTav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 15:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932492AbXGSTal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 15:30:41 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:34168 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106AbXGSTak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 15:30:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type;
        b=U7RvIseu9NvCIG358ZEMPutYYABpOJJVfta+gn932p+uSfkFE5cRm54yz/ojdA4KklDHQX53vhIAAKOmv5b/K2jAEoM+4o7lMrEGtqbJOE5wnL9j3+sTRw0LTzMhU2NSsLJYhL8SN3ySU+5+ZV6UIamDmYGCKd5zV1RSRomyD84=
Message-ID: <92a12cdb0707191230g216feaf2ied3e95bacf4dd572@mail.gmail.com>
Date: Thu, 19 Jul 2007 20:30:34 +0100
From: "Adrian McMenamin" <adrianmcmenamin@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix DMA on Dreamcast
Cc: lethal@users.sourceforge.net
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_112503_3856110.1184873434552"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_112503_3856110.1184873434552
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I think my first attempt to post this may have got lost in space somewhere.

Signed-off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>

------=_Part_112503_3856110.1184873434552
Content-Type: text/x-patch; name="dma-patch.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="dma-patch.diff"
X-Attachment-Id: f_f4bn0wdd

ZGlmZiAtLWdpdCBhL2FyY2gvc2gvZHJpdmVycy9kbWEvZG1hLWFwaS5jIGIvYXJjaC9zaC9kcml2
ZXJzL2RtYS9kbWEtYXBpLmMKaW5kZXggY2Y4ZTExOS4uMGM5YjNiYyAxMDA2NDQKLS0tIGEvYXJj
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
aGFuID09IGNoYW4pCisJCWlmIChjaGFubmVsLT5jaGFuID09IChjaGFuIC0gaW5mby0+Zmlyc3Rf
dmNoYW5uZWxfbnIpKQogCQkJcmV0dXJuIGNoYW5uZWw7CiAJfQogCkBAIC0xODMsNiArMTgzLDcg
QEAgaW50IGRtYWNfc2VhcmNoX2ZyZWVfY2hhbm5lbChjb25zdCBjaGFyICpkZXZfaWQpCiAJCQly
ZXR1cm4gcmVzdWx0OwogCiAJCWF0b21pY19zZXQoJmNoYW5uZWwtPmJ1c3ksIDEpOworCiAJCXJl
dHVybiBjaGFubmVsLT5jaGFuOwogCX0KIApAQCAtMTk0LDcgKzE5NSw2IEBAIGludCByZXF1ZXN0
X2RtYSh1bnNpZ25lZCBpbnQgY2hhbiwgY29uc3QgY2hhciAqZGV2X2lkKQogCXN0cnVjdCBkbWFf
Y2hhbm5lbCAqY2hhbm5lbCA9IHsgMCB9OwogCXN0cnVjdCBkbWFfaW5mbyAqaW5mbyA9IGdldF9k
bWFfaW5mbyhjaGFuKTsKIAlpbnQgcmVzdWx0OwotCiAJY2hhbm5lbCA9IGdldF9kbWFfY2hhbm5l
bChjaGFuKTsKIAlpZiAoYXRvbWljX3hjaGcoJmNoYW5uZWwtPmJ1c3ksIDEpKQogCQlyZXR1cm4g
LUVCVVNZOwpAQCAtMzY5LDYgKzM2OSw3IEBAIGludCByZWdpc3Rlcl9kbWFjKHN0cnVjdCBkbWFf
aW5mbyAqaW5mbykKIAl9CiAKIAl0b3RhbF9jaGFubmVscyA9IGdldF9ucl9jaGFubmVscygpOwor
CWluZm8tPmZpcnN0X3ZjaGFubmVsX25yID0gdG90YWxfY2hhbm5lbHM7CiAJZm9yIChpID0gMDsg
aSA8IGluZm8tPm5yX2NoYW5uZWxzOyBpKyspIHsKIAkJc3RydWN0IGRtYV9jaGFubmVsICpjaGFu
ID0gJmluZm8tPmNoYW5uZWxzW2ldOwogCkBAIC0zODcsNyArMzg4LDcgQEAgaW50IHJlZ2lzdGVy
X2RtYWMoc3RydWN0IGRtYV9pbmZvICppbmZvKQogCX0KIAogCWxpc3RfYWRkKCZpbmZvLT5saXN0
LCAmcmVnaXN0ZXJlZF9kbWFjX2xpc3QpOwotCisJCiAJcmV0dXJuIDA7CiB9CiBFWFBPUlRfU1lN
Qk9MKHJlZ2lzdGVyX2RtYWMpOwpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9hc20tc2gvZG1hLmggYi9p
bmNsdWRlL2FzbS1zaC9kbWEuaAppbmRleCA2MDM0ZDRhLi40Yzc1YjcwIDEwMDY0NAotLS0gYS9p
bmNsdWRlL2FzbS1zaC9kbWEuaAorKysgYi9pbmNsdWRlL2FzbS1zaC9kbWEuaApAQCAtMTExLDYg
KzExMSw3IEBAIHN0cnVjdCBkbWFfaW5mbyB7CiAKIAlzdHJ1Y3QgbGlzdF9oZWFkIGxpc3Q7CiAJ
aW50IGZpcnN0X2NoYW5uZWxfbnI7CisJaW50IGZpcnN0X3ZjaGFubmVsX25yOwogfTsKIAogc3Ry
dWN0IGRtYV9jaGFuX2NhcHMgewo=
------=_Part_112503_3856110.1184873434552--
