Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbYEJQqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbYEJQqe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 12:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbYEJQq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 12:46:27 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:42611 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbYEJQq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 12:46:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=rkZ9vbUgWmVQA/WIpSRHkOIsBfZe8cZ9UwGBZjg2BvjRG0BV3QtmL027BuApnsGC2kk6saIFjnIGnzxz9IK9qcfPen0zR+faLHn90QNXIJ+vpnfVDv8HSpklsmAffaQy2CKZyNYknm+yDoNWLs7HITPttKXSP3LzILrMWFrmDDw=
Message-ID: <6101e8c40805100946m53f27b7ekd049093d7eb9dd96@mail.gmail.com>
Date: Sat, 10 May 2008 18:46:20 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [OP] v2.6.22.24-op1
Cc: "Li Zefan" <lizf@cn.fujitsu.com>, "Zhao Yakui" <yakui.zhao@intel.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Len Brown" <len.brown@intel.com>, "Al Viro" <viro@zeniv.linux.org.uk>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_4023_28644792.1210437980309"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_4023_28644792.1210437980309
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I announced the v2.6.22.24-op1 "stable" kernel.

  gitweb:          http://repo.or.cz/w/linux-2.6.22.y-op.git
  git-tree:        git://repo.or.cz/linux-2.6.22.y-op.git
  patches-gitweb : http://repo.or.cz/w/linux-2.6.22.y-op-patches.git
  tar-bz2: http://students.zipernowsky.hu/~oliverp/kernel-stable/v2.6.22.24-op1.tar.bz2
  patch: http://students.zipernowsky.hu/~oliverp/kernel-stable/patch-v2.6.22.24-op1.bz2
  incr-patch: http://students.zipernowsky.hu/~oliverp/kernel-stable/incr/patch-v2.6.22.23-op1-v2.6.22.24-op1.bz2
  chlog:  http://students.zipernowsky.hu/~oliverp/kernel-stable/chlog-v2.6.22.24-op1

---

Al Viro (1):
      Fix dnotify/close race

Li Zefan (1):
      ACPI: check a return value correctly in acpi_power_get_context()

Oliver Pinter (1):
      v2.6.22.24-op1

---

 Makefile             |    2 +-
 drivers/acpi/power.c |    2 +-
 fs/dnotify.c         |   11 +++++++++++
 3 files changed, 13 insertions(+), 2 deletions(-)

-- 
Thanks,
Oliver

---

------=_Part_4023_28644792.1210437980309
Content-Type: text/x-diff; name=patch-v2.6.22.23-op1-v2.6.22.24-op1
Content-Transfer-Encoding: base64
X-Attachment-Id: file0
Content-Disposition: attachment;
 filename=patch-v2.6.22.23-op1-v2.6.22.24-op1

ZGlmZiAtLWdpdCBhL01ha2VmaWxlIGIvTWFrZWZpbGUKaW5kZXggZDAwMTk1OS4uMmE2OWI5YiAx
MDA2NDQKLS0tIGEvTWFrZWZpbGUKKysrIGIvTWFrZWZpbGUKQEAgLTEsNyArMSw3IEBACiBWRVJT
SU9OID0gMgogUEFUQ0hMRVZFTCA9IDYKIFNVQkxFVkVMID0gMjIKLUVYVFJBVkVSU0lPTiA9IC4y
My1vcDEKK0VYVFJBVkVSU0lPTiA9IC4yNC1vcDEKIE5BTUUgPSBIb2x5IERhbmNpbmcgTWFuYXRl
ZXMsIEJhdG1hbiEKIAogIyAqRE9DVU1FTlRBVElPTioKZGlmZiAtLWdpdCBhL2RyaXZlcnMvYWNw
aS9wb3dlci5jIGIvZHJpdmVycy9hY3BpL3Bvd2VyLmMKaW5kZXggNGZmZWNkMS4uZDI5NWVkMSAx
MDA2NDQKLS0tIGEvZHJpdmVycy9hY3BpL3Bvd2VyLmMKKysrIGIvZHJpdmVycy9hY3BpL3Bvd2Vy
LmMKQEAgLTExNiw3ICsxMTYsNyBAQCBhY3BpX3Bvd2VyX2dldF9jb250ZXh0KGFjcGlfaGFuZGxl
IGhhbmRsZSwKIAl9CiAKIAkqcmVzb3VyY2UgPSBhY3BpX2RyaXZlcl9kYXRhKGRldmljZSk7Ci0J
aWYgKCFyZXNvdXJjZSkKKwlpZiAoISpyZXNvdXJjZSkKIAkJcmV0dXJuIC1FTk9ERVY7CiAKIAly
ZXR1cm4gMDsKZGlmZiAtLWdpdCBhL2ZzL2Rub3RpZnkuYyBiL2ZzL2Rub3RpZnkuYwppbmRleCA5
MzY0MDlmLi45MWI5NzUzIDEwMDY0NAotLS0gYS9mcy9kbm90aWZ5LmMKKysrIGIvZnMvZG5vdGlm
eS5jCkBAIC0yMCw2ICsyMCw3IEBACiAjaW5jbHVkZSA8bGludXgvaW5pdC5oPgogI2luY2x1ZGUg
PGxpbnV4L3NwaW5sb2NrLmg+CiAjaW5jbHVkZSA8bGludXgvc2xhYi5oPgorI2luY2x1ZGUgPGxp
bnV4L2ZpbGUuaD4KIAogaW50IGRpcl9ub3RpZnlfZW5hYmxlIF9fcmVhZF9tb3N0bHkgPSAxOwog
CkBAIC02Niw2ICs2Nyw3IEBAIGludCBmY250bF9kaXJub3RpZnkoaW50IGZkLCBzdHJ1Y3QgZmls
ZSAqZmlscCwgdW5zaWduZWQgbG9uZyBhcmcpCiAJc3RydWN0IGRub3RpZnlfc3RydWN0ICoqcHJl
djsKIAlzdHJ1Y3QgaW5vZGUgKmlub2RlOwogCWZsX293bmVyX3QgaWQgPSBjdXJyZW50LT5maWxl
czsKKwlzdHJ1Y3QgZmlsZSAqZjsKIAlpbnQgZXJyb3IgPSAwOwogCiAJaWYgKChhcmcgJiB+RE5f
TVVMVElTSE9UKSA9PSAwKSB7CkBAIC05Miw2ICs5NCwxNSBAQCBpbnQgZmNudGxfZGlybm90aWZ5
KGludCBmZCwgc3RydWN0IGZpbGUgKmZpbHAsIHVuc2lnbmVkIGxvbmcgYXJnKQogCQlwcmV2ID0g
Jm9kbi0+ZG5fbmV4dDsKIAl9CiAKKwlyY3VfcmVhZF9sb2NrKCk7CisJZiA9IGZjaGVjayhmZCk7
CisJcmN1X3JlYWRfdW5sb2NrKCk7CisJLyogd2UnZCBsb3N0IHRoZSByYWNlIHdpdGggY2xvc2Uo
KSwgc29kIG9mZiBzaWxlbnRseSAqLworCS8qIG5vdGUgdGhhdCBpbm9kZS0+aV9sb2NrIHByZXZl
bnRzIHJlb3JkZXJpbmcgcHJvYmxlbXMKKwkgKiBiZXR3ZWVuIGFjY2Vzc2VzIHRvIGRlc2NyaXB0
b3IgdGFibGUgYW5kIC0+aV9kbm90aWZ5ICovCisJaWYgKGYgIT0gZmlscCkKKwkJZ290byBvdXRf
ZnJlZTsKKwogCWVycm9yID0gX19mX3NldG93bihmaWxwLCB0YXNrX3BpZChjdXJyZW50KSwgUElE
VFlQRV9QSUQsIDApOwogCWlmIChlcnJvcikKIAkJZ290byBvdXRfZnJlZTsK
------=_Part_4023_28644792.1210437980309--
