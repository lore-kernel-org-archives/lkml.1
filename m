Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849AbXKZHqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbXKZHqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 02:46:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbXKZHqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 02:46:44 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:26395 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbXKZHqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 02:46:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type;
        b=wbjYAuJss92fy91VatbHrFGXyZ5DECELkiEBHIlVikt3RSiRqhMsQIXpltNIIHdWppm/YMJm32TP7VHtOLaIJPtn/b9G1z8N6DqgIEgFLvDHPqV97hns+Hr3+YJbrE7XgMlcB23SI2MiLr97Xg9WXmj+WYIxEu/J2fzmyzOt8CM=
Message-ID: <aa79d98a0711252346m583b652bocf72e11077da352e@mail.gmail.com>
Date: Mon, 26 Nov 2007 10:46:42 +0300
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: PPCML <linuxppc-dev@ozlabs.org>
Subject: [PATCH] PPC: CELLEB - fix potential NULL pointer dereference
Cc: LKML <linux-kernel@vger.kernel.org>, "Paul Mackerras" <paulus@samba.org>,
       "Olof Johansson" <olof@lixom.net>,
       "Kumar Gala" <galak@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_3151_30274450.1196063202969"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_3151_30274450.1196063202969
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This patch adds checking for NULL value returned to prevent possible
NULL pointer dereference.
Also two unneeded 'return' are removed.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
Any comments are welcome.

------=_Part_3151_30274450.1196063202969
Content-Type: text/plain; name=ppc-celleb-fix-null.diff
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f9gozfgx
Content-Disposition: attachment; filename=ppc-celleb-fix-null.diff

IGFyY2gvcG93ZXJwYy9wbGF0Zm9ybXMvY2VsbGViL3BjaS5jIHwgICAyMyArKysrKysrKysrKysr
KysrKysrKy0tLQogMSBmaWxlcyBjaGFuZ2VkLCAyMCBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL2FyY2gvcG93ZXJwYy9wbGF0Zm9ybXMvY2VsbGViL3BjaS5jIGIv
YXJjaC9wb3dlcnBjL3BsYXRmb3Jtcy9jZWxsZWIvcGNpLmMKaW5kZXggNmJjMzJmZC4uOWI4YmIw
MSAxMDA2NDQKLS0tIGEvYXJjaC9wb3dlcnBjL3BsYXRmb3Jtcy9jZWxsZWIvcGNpLmMKKysrIGIv
YXJjaC9wb3dlcnBjL3BsYXRmb3Jtcy9jZWxsZWIvcGNpLmMKQEAgLTEzOCw4ICsxMzgsNiBAQCBz
dGF0aWMgdm9pZCBjZWxsZWJfY29uZmlnX3JlYWRfZmFrZSh1bnNpZ25lZCBjaGFyICpjb25maWcs
IGludCB3aGVyZSwKIAkJKnZhbCA9IGNlbGxlYl9mYWtlX2NvbmZpZ19yZWFkbChwKTsKIAkJYnJl
YWs7CiAJfQotCi0JcmV0dXJuOwogfQogCiBzdGF0aWMgdm9pZCBjZWxsZWJfY29uZmlnX3dyaXRl
X2Zha2UodW5zaWduZWQgY2hhciAqY29uZmlnLCBpbnQgd2hlcmUsCkBAIC0xNTgsNyArMTU2LDYg
QEAgc3RhdGljIHZvaWQgY2VsbGViX2NvbmZpZ193cml0ZV9mYWtlKHVuc2lnbmVkIGNoYXIgKmNv
bmZpZywgaW50IHdoZXJlLAogCQljZWxsZWJfZmFrZV9jb25maWdfd3JpdGVsKHZhbCwgcCk7CiAJ
CWJyZWFrOwogCX0KLQlyZXR1cm47CiB9CiAKIHN0YXRpYyBpbnQgY2VsbGViX2Zha2VfcGNpX3Jl
YWRfY29uZmlnKHN0cnVjdCBwY2lfYnVzICpidXMsCkBAIC0zNDgsOSArMzQ1LDI1IEBAIHN0YXRp
YyBpbnQgX19pbml0IGNlbGxlYl9zZXR1cF9mYWtlX3BjaV9kZXZpY2Uoc3RydWN0IGRldmljZV9u
b2RlICpub2RlLAogCXByX2RlYnVnKCJQQ0k6IHJlcyBhc3NpZ25lZCAweCUwMTZseFxuIiwgKHVu
c2lnbmVkIGxvbmcpKnJlcyk7CiAKIAl3aTAgPSBvZl9nZXRfcHJvcGVydHkobm9kZSwgImRldmlj
ZS1pZCIsIE5VTEwpOworCWlmICh1bmxpa2VseSgoIXdpMCkpKSB7CisJCXByaW50ayhLRVJOX0VS
UiAiUENJOiBkZXZpY2UtaWQgbm90IGZvdW5kLlxuIik7CisJCWdvdG8gZXJyb3I7CisJfQogCXdp
MSA9IG9mX2dldF9wcm9wZXJ0eShub2RlLCAidmVuZG9yLWlkIiwgTlVMTCk7CisJaWYgKHVubGlr
ZWx5KCghd2kxKSkpIHsKKwkJcHJpbnRrKEtFUk5fRVJSICJQQ0k6IHZlbmRvci1pZCBub3QgZm91
bmQuXG4iKTsKKwkJZ290byBlcnJvcjsKKwl9CiAJd2kyID0gb2ZfZ2V0X3Byb3BlcnR5KG5vZGUs
ICJjbGFzcy1jb2RlIiwgTlVMTCk7CisJaWYgKHVubGlrZWx5KCghd2kyKSkpIHsKKwkJcHJpbnRr
KEtFUk5fRVJSICJQQ0k6IGNsYXNzLWNvZGUgbm90IGZvdW5kLlxuIik7CisJCWdvdG8gZXJyb3I7
CisJfQogCXdpMyA9IG9mX2dldF9wcm9wZXJ0eShub2RlLCAicmV2aXNpb24taWQiLCBOVUxMKTsK
KwlpZiAodW5saWtlbHkoKCF3aTMpKSkgeworCQlwcmludGsoS0VSTl9FUlIgIlBDSTogcmV2aXNp
b24taWQgbm90IGZvdW5kLlxuIik7CisJCWdvdG8gZXJyb3I7CisJfQogCiAJY2VsbGViX2NvbmZp
Z193cml0ZV9mYWtlKCpjb25maWcsIFBDSV9ERVZJQ0VfSUQsIDIsIHdpMFswXSAmIDB4ZmZmZik7
CiAJY2VsbGViX2NvbmZpZ193cml0ZV9mYWtlKCpjb25maWcsIFBDSV9WRU5ET1JfSUQsIDIsIHdp
MVswXSAmIDB4ZmZmZik7CkBAIC0zNzIsNiArMzg1LDEwIEBAIHN0YXRpYyBpbnQgX19pbml0IGNl
bGxlYl9zZXR1cF9mYWtlX3BjaV9kZXZpY2Uoc3RydWN0IGRldmljZV9ub2RlICpub2RlLAogCWNl
bGxlYl9zZXR1cF9wY2lfYmFzZV9hZGRycyhob3NlLCBkZXZubywgZm4sIG51bV9iYXNlX2FkZHIp
OwogCiAJbGkgPSBvZl9nZXRfcHJvcGVydHkobm9kZSwgImludGVycnVwdHMiLCAmcmxlbik7CisJ
aWYgKCFsaSkgeworCQlwcmludGsoS0VSTl9FUlIgIlBDSTogaW50ZXJydXB0cyBub3QgZm91bmQu
XG4iKTsKKwkJZ290byBlcnJvcjsKKwl9CiAJdmFsID0gbGlbMF07CiAJY2VsbGViX2NvbmZpZ193
cml0ZV9mYWtlKCpjb25maWcsIFBDSV9JTlRFUlJVUFRfUElOLCAxLCAxKTsKIAljZWxsZWJfY29u
ZmlnX3dyaXRlX2Zha2UoKmNvbmZpZywgUENJX0lOVEVSUlVQVF9MSU5FLCAxLCB2YWwpOwo=
------=_Part_3151_30274450.1196063202969--
