Return-Path: <linux-kernel-owner+w=401wt.eu-S1756649AbZAHOVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbZAHOVB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 09:21:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759922AbZAHOUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 09:20:49 -0500
Received: from rv-out-0506.google.com ([209.85.198.238]:23997 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759892AbZAHOUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 09:20:48 -0500
Message-ID: <28fa9c5e0901080620g7f4707daxbffc9bf798581882@mail.gmail.com>
Date: Thu, 8 Jan 2009 22:20:44 +0800
From: "Eugene Teo" <eugeneteo@kernel.org>
To: "Niels de Vos" <niels.devos@wincor-nixdorf.com>
Subject: Re: [PATCH] IB: check for memory allocation failure [v2]
Cc: linux-kernel@vger.kernel.org, rolandd@cisco.com, sean.hefty@intel.com,
       hal.rosenstock@gmail.com
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_71419_881177.1231424444454"
X-Google-Sender-Auth: a3fda828f3ccce2c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_71419_881177.1231424444454
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thu, Jan 8, 2009 at 10:05 PM, Niels de Vos
<niels.devos@wincor-nixdorf.com> wrote:
> Hi Eugene,
>
> please see below.

Thanks for reviewing. Here's an updated patch:

Fix error-path NULL deref in c2_register_device().

Signed-off-by: Eugene Teo <eugeneteo@kernel.org>
---
 drivers/infiniband/hw/amso1100/c2_provider.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

------=_Part_71419_881177.1231424444454
Content-Type: application/octet-stream; name=patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fppia5z41
Content-Disposition: attachment; filename=patch

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5maW5pYmFuZC9ody9hbXNvMTEwMC9jMl9wcm92aWRlci5j
IGIvZHJpdmVycy9pbmZpbmliYW5kL2h3L2Ftc28xMTAwL2MyX3Byb3ZpZGVyLmMKaW5kZXggNTEx
OWQ2NS4uMTgyZTRiNyAxMDA2NDQKLS0tIGEvZHJpdmVycy9pbmZpbmliYW5kL2h3L2Ftc28xMTAw
L2MyX3Byb3ZpZGVyLmMKKysrIGIvZHJpdmVycy9pbmZpbmliYW5kL2h3L2Ftc28xMTAwL2MyX3By
b3ZpZGVyLmMKQEAgLTc4MCwxMSArNzgwLDExIEBAIGludCBjMl9yZWdpc3Rlcl9kZXZpY2Uoc3Ry
dWN0IGMyX2RldiAqZGV2KQogCS8qIFJlZ2lzdGVyIHBzZXVkbyBuZXR3b3JrIGRldmljZSAqLwog
CWRldi0+cHNldWRvX25ldGRldiA9IGMyX3BzZXVkb19uZXRkZXZfaW5pdChkZXYpOwogCWlmICgh
ZGV2LT5wc2V1ZG9fbmV0ZGV2KQotCQlnb3RvIG91dDM7CisJCWdvdG8gb3V0NDsKIAogCXJldCA9
IHJlZ2lzdGVyX25ldGRldihkZXYtPnBzZXVkb19uZXRkZXYpOwogCWlmIChyZXQpCi0JCWdvdG8g
b3V0MjsKKwkJZ290byBvdXQzOwogCiAJcHJfZGVidWcoIiVzOiV1XG4iLCBfX2Z1bmNfXywgX19M
SU5FX18pOwogCXN0cmxjcHkoZGV2LT5pYmRldi5uYW1lLCAiYW1zbyVkIiwgSUJfREVWSUNFX05B
TUVfTUFYKTsKQEAgLTg1MSw2ICs4NTEsMTAgQEAgaW50IGMyX3JlZ2lzdGVyX2RldmljZShzdHJ1
Y3QgYzJfZGV2ICpkZXYpCiAJZGV2LT5pYmRldi5wb3N0X3JlY3YgPSBjMl9wb3N0X3JlY2VpdmU7
CiAKIAlkZXYtPmliZGV2Lml3Y20gPSBrbWFsbG9jKHNpemVvZigqZGV2LT5pYmRldi5pd2NtKSwg
R0ZQX0tFUk5FTCk7CisJaWYgKCFkZXYtPmliZGV2Lml3Y20pIHsKKwkJcmV0ID0gLUVOT01FTTsK
KwkJZ290byBvdXQyOworCX0KIAlkZXYtPmliZGV2Lml3Y20tPmFkZF9yZWYgPSBjMl9hZGRfcmVm
OwogCWRldi0+aWJkZXYuaXdjbS0+cmVtX3JlZiA9IGMyX3JlbV9yZWY7CiAJZGV2LT5pYmRldi5p
d2NtLT5nZXRfcXAgPSBjMl9nZXRfcXA7CkBAIC04NzAsMTUgKzg3NCwxNyBAQCBpbnQgYzJfcmVn
aXN0ZXJfZGV2aWNlKHN0cnVjdCBjMl9kZXYgKmRldikKIAkJaWYgKHJldCkKIAkJCWdvdG8gb3V0
MDsKIAl9Ci0JZ290byBvdXQzOworCWdvdG8gb3V0NDsKIAogb3V0MDoKIAlpYl91bnJlZ2lzdGVy
X2RldmljZSgmZGV2LT5pYmRldik7CiBvdXQxOgotCXVucmVnaXN0ZXJfbmV0ZGV2KGRldi0+cHNl
dWRvX25ldGRldik7CisJa2ZyZWUoZGV2LT5pYmRldi5pd2NtKTsKIG91dDI6Ci0JZnJlZV9uZXRk
ZXYoZGV2LT5wc2V1ZG9fbmV0ZGV2KTsKKwl1bnJlZ2lzdGVyX25ldGRldihkZXYtPnBzZXVkb19u
ZXRkZXYpOwogb3V0MzoKKwlmcmVlX25ldGRldihkZXYtPnBzZXVkb19uZXRkZXYpOworb3V0NDoK
IAlwcl9kZWJ1ZygiJXM6JXUgcmV0PSVkXG4iLCBfX2Z1bmNfXywgX19MSU5FX18sIHJldCk7CiAJ
cmV0dXJuIHJldDsKIH0KQEAgLTg4OSw0ICs4OTUsNSBAQCB2b2lkIGMyX3VucmVnaXN0ZXJfZGV2
aWNlKHN0cnVjdCBjMl9kZXYgKmRldikKIAl1bnJlZ2lzdGVyX25ldGRldihkZXYtPnBzZXVkb19u
ZXRkZXYpOwogCWZyZWVfbmV0ZGV2KGRldi0+cHNldWRvX25ldGRldik7CiAJaWJfdW5yZWdpc3Rl
cl9kZXZpY2UoJmRldi0+aWJkZXYpOworCWtmcmVlKGRldi0+aWJkZXYuaXdjbSk7CiB9Cg==
------=_Part_71419_881177.1231424444454--
