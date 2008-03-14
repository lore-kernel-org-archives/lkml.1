Return-Path: <linux-kernel-owner+w=401wt.eu-S1756646AbYCNGBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646AbYCNGBR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 02:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbYCNGBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 02:01:05 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:48003 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbYCNGBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 02:01:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=jlgcO9oZEupuAM9T2eY7Z/HSZ4vVU1CnvA4nAhpTuZ35dBxcsXhiIvaeiAfEmXMLIGQlJKZk9reXBYV7+9GFRbi5t2yguEuGT3rmxesQ2nLAx6olFSo3uGZb9bSoRxjcg4HoF0v+zZ36kdC1f4QPZhpMMNy6nYhal+Tm/PE2Ahs=
Message-ID: <86802c440803132301x561b941epcbbec0fddefc2ea0@mail.gmail.com>
Date: Thu, 13 Mar 2008 23:01:03 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86_64: do not reserve ramdisk two times
Cc: "kernel list" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_13796_29777332.1205474463641"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_13796_29777332.1205474463641
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline



------=_Part_13796_29777332.1205474463641
Content-Type: text/x-patch; name=do_not_reserve_ramdisk_second_time.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fdsce67u0
Content-Disposition: attachment;
 filename=do_not_reserve_ramdisk_second_time.patch

W1BBVENIXSB4ODZfNjQ6IGRvIG5vdCByZXNlcnZlIHJhbWRpc2sgdHdvIHRpbWVzCgpyYW1kaXNr
IGlzIHJlc2VydmVkIHZpYSByZXNlcnZlX2Vhcmx5IGluIHg4Nl82NF9zdGFydF9rZXJuZWwsCmxh
dGVyIGVhcmx5X3Jlc190b19ib290bWVtKCkgd2lsbCBjb252ZXJ0IHRvIHJlc2VydmF0aW9uIGlu
IGJvb3RtZW0uCgpzbyBkb24ndCBuZWVkIHRvIHJlc2VydmUgdGhhdCBhZ2Fpbi4KClNpZ25lZC1v
ZmYtYnk6IFlpbmdoYWkgTHUgPHlobHUua2VybmVsQGdtYWlsLmNvbT4KCmRpZmYgLS1naXQgYS9h
cmNoL3g4Ni9rZXJuZWwvaGVhZDY0LmMgYi9hcmNoL3g4Ni9rZXJuZWwvaGVhZDY0LmMKaW5kZXgg
NDhiZTc2Yy4uZTcwODQzZCAxMDA2NDQKLS0tIGEvYXJjaC94ODYva2VybmVsL2hlYWQ2NC5jCisr
KyBiL2FyY2gveDg2L2tlcm5lbC9oZWFkNjQuYwpAQCAtMTQ2LDYgKzE0Niw3IEBAIHZvaWQgX19p
bml0IHg4Nl82NF9zdGFydF9rZXJuZWwoY2hhciAqIHJlYWxfbW9kZV9kYXRhKQogCiAJcmVzZXJ2
ZV9lYXJseShfX3BhX3N5bWJvbCgmX3RleHQpLCBfX3BhX3N5bWJvbCgmX2VuZCksICJURVhUIERB
VEEgQlNTIik7CiAKKyNpZmRlZiBDT05GSUdfQkxLX0RFVl9JTklUUkQKIAkvKiBSZXNlcnZlIElO
SVRSRCAqLwogCWlmIChib290X3BhcmFtcy5oZHIudHlwZV9vZl9sb2FkZXIgJiYgYm9vdF9wYXJh
bXMuaGRyLnJhbWRpc2tfaW1hZ2UpIHsKIAkJdW5zaWduZWQgbG9uZyByYW1kaXNrX2ltYWdlID0g
Ym9vdF9wYXJhbXMuaGRyLnJhbWRpc2tfaW1hZ2U7CkBAIC0xNTMsNiArMTU0LDcgQEAgdm9pZCBf
X2luaXQgeDg2XzY0X3N0YXJ0X2tlcm5lbChjaGFyICogcmVhbF9tb2RlX2RhdGEpCiAJCXVuc2ln
bmVkIGxvbmcgcmFtZGlza19lbmQgICA9IHJhbWRpc2tfaW1hZ2UgKyByYW1kaXNrX3NpemU7CiAJ
CXJlc2VydmVfZWFybHkocmFtZGlza19pbWFnZSwgcmFtZGlza19lbmQsICJSQU1ESVNLIik7CiAJ
fQorI2VuZGlmCiAKIAlyZXNlcnZlX2ViZGFfcmVnaW9uKCk7CiAKZGlmZiAtLWdpdCBhL2FyY2gv
eDg2L2tlcm5lbC9zZXR1cF82NC5jIGIvYXJjaC94ODYva2VybmVsL3NldHVwXzY0LmMKaW5kZXgg
MDg5Y2UxMC4uNWRiYjNjMSAxMDA2NDQKLS0tIGEvYXJjaC94ODYva2VybmVsL3NldHVwXzY0LmMK
KysrIGIvYXJjaC94ODYva2VybmVsL3NldHVwXzY0LmMKQEAgLTQyNSwxMSArNDI1LDE0IEBAIHZv
aWQgX19pbml0IHNldHVwX2FyY2goY2hhciAqKmNtZGxpbmVfcCkKIAkJdW5zaWduZWQgbG9uZyBl
bmRfb2ZfbWVtICAgID0gZW5kX3BmbiA8PCBQQUdFX1NISUZUOwogCiAJCWlmIChyYW1kaXNrX2Vu
ZCA8PSBlbmRfb2ZfbWVtKSB7Ci0JCQlyZXNlcnZlX2Jvb3RtZW1fZ2VuZXJpYyhyYW1kaXNrX2lt
YWdlLCByYW1kaXNrX3NpemUpOworCQkJLyoKKwkJCSAqIGRvbid0IG5lZWQgdG8gcmVzZXJ2ZSBh
Z2FpbiwgYWxyZWFkeSByZXNlcnZlZCBlYXJseQorCQkJICogaW4geDg2XzY0X3N0YXJ0X2tlcm5l
bCwgYW5kIGVhcmx5X3Jlc190b19ib290bWVtCisJCQkgKiBjb252ZXJ0IHRoYXQgdG8gcmVzZXJ2
ZWQgaW4gYm9vdG1lZW0KKwkJCSAqLwogCQkJaW5pdHJkX3N0YXJ0ID0gcmFtZGlza19pbWFnZSAr
IFBBR0VfT0ZGU0VUOwogCQkJaW5pdHJkX2VuZCA9IGluaXRyZF9zdGFydCtyYW1kaXNrX3NpemU7
CiAJCX0gZWxzZSB7Ci0JCQkvKiBBc3N1bWVzIGV2ZXJ5dGhpbmcgb24gbm9kZSAwICovCiAJCQlm
cmVlX2Jvb3RtZW0ocmFtZGlza19pbWFnZSwgcmFtZGlza19zaXplKTsKIAkJCXByaW50ayhLRVJO
X0VSUiAiaW5pdHJkIGV4dGVuZHMgYmV5b25kIGVuZCBvZiBtZW1vcnkgIgogCQkJICAgICAgICIo
MHglMDhseCA+IDB4JTA4bHgpXG5kaXNhYmxpbmcgaW5pdHJkXG4iLAo=
------=_Part_13796_29777332.1205474463641--
