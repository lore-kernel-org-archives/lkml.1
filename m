Return-Path: <linux-kernel-owner+w=401wt.eu-S932755AbYCDT2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932755AbYCDT2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 14:28:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760874AbYCDT2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 14:28:10 -0500
Received: from el-out-1112.google.com ([209.85.162.179]:14028 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759536AbYCDT2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 14:28:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=Wl2XjEGkfz45HUeaFCuJe1Od4n7ZuGKhw1ox8+Sqk4LLibP4zNEZ9vBuDKe7pSvHvwF0QMt3F7FVGfXCNfqB3YfkbKNeCV0BylpAYaOf3420YTglvOpfCcVadAphe/xBSfeBLUOLI9YP+mHJ7RNiN+HnlOU3rcOwzogIyWF7haA=
Message-ID: <86802c440803041128g16a2cf8chdf8c87f5f24742a1@mail.gmail.com>
Date: Tue, 4 Mar 2008 11:28:06 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] ACPI: Unneccessary to scan the PCI bus already scanned.
Cc: "Greg KH" <gregkh@suse.de>, "Muli Ben-Yehuda" <muli@il.ibm.com>,
       "Zhao Yakui" <yakui.zhao@intel.com>, lenb@kernel.org,
       linux-acpi@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440803031057m7802a00cnd158da03c4bb507@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_15807_18964770.1204658886619"
References: <1204525186.4080.11.camel@yakui_zhao.sh.intel.com>
	 <20080303073214.GA5934@elte.hu>
	 <86802c440803030006m1879838awc238f07bc98ed43e@mail.gmail.com>
	 <86802c440803030030p4ff9cec5tdb25d1cdc131d377@mail.gmail.com>
	 <86802c440803030201i684f31c1m97fb3f1f1927d4f4@mail.gmail.com>
	 <20080303101040.GG18281@elte.hu>
	 <86802c440803030233s1b0cc0a6nbed683ee3d4fac63@mail.gmail.com>
	 <20080303111124.GA27348@elte.hu>
	 <86802c440803031057m7802a00cnd158da03c4bb507@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_15807_18964770.1204658886619
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I updated Yakui's patch, so it could be applied after x86.git#testing

Please check it

YH

------=_Part_15807_18964770.1204658886619
Content-Type: text/x-patch; name=acpi_scan_root_after.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fdev3ov10
Content-Disposition: attachment; filename=acpi_scan_root_after.patch

RnJvbSA6IFpoYW8gWWFrdWkgPHlha3VpLnpoYW9AaW50ZWwuY29tPgoKW1BBVENIXSBVbm5lY2Nl
c3NhcnkgdG8gc2NhbiB0aGUgUENJIGJ1cyBhbHJlYWR5IHNjYW5uZWQgdjIKCmh0dHA6Ly9idWd6
aWxsYS5rZXJuZWwub3JnL3Nob3dfYnVnLmNnaT9pZD0xMDEyNAoKY29tbWl0IDA4ZjFjMTkyYzNj
MzI3OTcwNjhiZmU5NzczOGJhYmIzMjk1YmJmNDIKQXV0aG9yOiBNdWxpIEJlbi1ZZWh1ZGEgPG11
bGlAaWwuaWJtLmNvbT4KRGF0ZTogICBTdW4gSnVsIDIyIDAwOjIzOjM5IDIwMDcgKzAzMDAKCiAg
IHg4Ni02NDogaW50cm9kdWNlIHN0cnVjdCBwY2lfc3lzZGF0YSB0byBmYWNpbGl0YXRlIHNoYXJp
bmcgb2YgLT5zeXNkYXRhCgogICBUaGlzIHBhdGNoIGludHJvZHVjZXMgc3RydWN0IHBjaV9zeXNk
YXRhIHRvIHg4NiBhbmQgeDg2LTY0LCBhbmQKICAgY29udmVydHMgdGhlIGV4aXN0aW5nIHR3byB1
c2VycyAoTlVNQSwgQ2FsZ2FyeSkgdG8gdXNlIGl0LgoKICAgVGhpcyBsYXlzIHRoZSBncm91bmR3
b3JrIGZvciBoYXZpbmcgb3RoZXIgdXNlcnMgb2Ygc3lzZGF0YSwgc3VjaCBhcwogICB0aGUgUENJ
IGRvbWFpbnMgd29yay4KCiAgIFRoZSBDYWxnYXJ5IGJpdHMgYXJlIHRlc3RlZCwgdGhlIE5VTUEg
Yml0cyBqdXN0IGxvb2sgb2suCgp0aGF0IHJlcGxhY2UgcGNpYmlvc19zY2FuX3Jvb3QgYnkgcGNp
X3NjYW5fYnVzX3BhcmVudGVkLi4uCgpidXQgaW4gcGNpYmlvc19zY2FuX3Jvb3Qgd2UgaGF2ZSBj
aGVjayBhYm91dCBzY2FubmVkIGJ1cwoKWWluZ2hhaSBtYWtlIGl0IGNhbiBiZSBhcHBsaWVkIGFm
dGVyIHBhdGNoZXMgaW4geDg2LmdpdCN0ZXNpbmcKClNpZ25lZC1vZmYtYnk6IFpoYW8gWWFrdWkg
PHlha3VpLnpoYW9AaW50ZWwuY29tPgpTaWduZWQtb2ZmLWJ5OiBMaSBTaGFvaHVhIDxzaGFvaHVh
LmxpQGludGVsLmNvbT4KU2lnbmVkLW9mZi1ieTogWWluZ2hhaSBMdSA8eWhsdS5rZXJuZWxAZ21h
aWwuY29tPgoKZGlmZiAtLWdpdCBhL2FyY2gveDg2L3BjaS9hY3BpLmMgYi9hcmNoL3g4Ni9wY2kv
YWNwaS5jCmluZGV4IDJjMWE2NTEuLjdlMmJmZTMgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L3BjaS9h
Y3BpLmMKKysrIGIvYXJjaC94ODYvcGNpL2FjcGkuYwpAQCAtMjEzLDMzICsyMTMsMzggQEAgc3Ry
dWN0IHBjaV9idXMgKiBfX2RldmluaXQgcGNpX2FjcGlfc2Nhbl9yb290KHN0cnVjdCBhY3BpX2Rl
dmljZSAqZGV2aWNlLCBpbnQgZG8KIAkJc2V0X21wX2J1c190b19ub2RlKGJ1c251bSwgbm9kZSk7
CiAJZWxzZQogCQlub2RlID0gZ2V0X21wX2J1c190b19ub2RlKGJ1c251bSk7Ci0KLQlpZiAobm9k
ZSAhPSAtMSAmJiAhbm9kZV9vbmxpbmUobm9kZSkpCi0JCW5vZGUgPSAtMTsKICNlbmRpZgogCi0J
LyogQWxsb2NhdGUgcGVyLXJvb3QtYnVzIChub3QgcGVyIGJ1cykgYXJjaC1zcGVjaWZpYyBkYXRh
LgotCSAqIFRPRE86IGxlYWs7IHRoaXMgbWVtb3J5IGlzIG5ldmVyIGZyZWVkLgotCSAqIEl0J3Mg
YXJndWFibGUgd2hldGhlciBpdCdzIHdvcnRoIHRoZSB0cm91YmxlIHRvIGNhcmUuCi0JICovCi0J
c2QgPSBremFsbG9jKHNpemVvZigqc2QpLCBHRlBfS0VSTkVMKTsKLQlpZiAoIXNkKSB7Ci0JCXBy
aW50ayhLRVJOX0VSUiAiUENJOiBPT00sIG5vdCBwcm9iaW5nIFBDSSBidXMgJTAyeFxuIiwgYnVz
bnVtKTsKLQkJcmV0dXJuIE5VTEw7Ci0JfQorCWJ1cyA9IHBjaV9maW5kX2J1cyhkb21haW4sIGJ1
c251bSk7CisJaWYgKGJ1cykgeworCQkvKiBhbHJlYWR5IHNjYW5uZWQgPyovCisJCXNkID0gYnVz
LT5zeXNkYXRhOworCQlzZC0+bm9kZSA9IG5vZGU7CisJfSBlbHNlIHsKKwkJLyogQWxsb2NhdGUg
cGVyLXJvb3QtYnVzIChub3QgcGVyIGJ1cykgYXJjaC1zcGVjaWZpYyBkYXRhLgorCQkgKiBUT0RP
OiBsZWFrOyB0aGlzIG1lbW9yeSBpcyBuZXZlciBmcmVlZC4KKwkJICogSXQncyBhcmd1YWJsZSB3
aGV0aGVyIGl0J3Mgd29ydGggdGhlIHRyb3VibGUgdG8gY2FyZS4KKwkJICovCisJCXNkID0ga3ph
bGxvYyhzaXplb2YoKnNkKSwgR0ZQX0tFUk5FTCk7CisJCWlmICghc2QpIHsKKwkJCXByaW50ayhL
RVJOX0VSUiAiUENJOiBPT00sIG5vdCBwcm9iaW5nIFBDSSBidXMgJTAyeFxuIiwKKwkJCQkgYnVz
bnVtKTsKKwkJCXJldHVybiBOVUxMOworCQl9CiAKLQlzZC0+ZG9tYWluID0gZG9tYWluOwotCXNk
LT5ub2RlID0gbm9kZTsKKwkJc2QtPmRvbWFpbiA9IGRvbWFpbjsKKwkJc2QtPm5vZGUgPSBub2Rl
OwogCi0JYnVzID0gcGNpX3NjYW5fYnVzX3BhcmVudGVkKE5VTEwsIGJ1c251bSwgJnBjaV9yb290
X29wcywgc2QpOwotCWlmICghYnVzKQotCQlrZnJlZShzZCk7CisJCWJ1cyA9IHBjaV9zY2FuX2J1
c19wYXJlbnRlZChOVUxMLCBidXNudW0sICZwY2lfcm9vdF9vcHMsIHNkKTsKKwkJaWYgKCFidXMp
CisJCQlrZnJlZShzZCk7CisJfQogCiAjaWZkZWYgQ09ORklHX0FDUElfTlVNQQogCWlmIChidXMp
IHsKIAkJaWYgKHB4bSA+PSAwKSB7CiAJCQlwcmludGsoS0VSTl9ERUJVRyAiYnVzICUwMnggLT4g
cHhtICVkIC0+IG5vZGUgJWRcbiIsCi0JCQkJYnVzbnVtLCBweG0sIHNkLT5ub2RlKTsKKwkJCQli
dXNudW0sIHB4bSwgbm9kZSk7CiAJCX0KIAl9CiAjZW5kaWYK
------=_Part_15807_18964770.1204658886619--
