Return-Path: <linux-kernel-owner+w=401wt.eu-S965778AbXDCMuD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965778AbXDCMuD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 08:50:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965881AbXDCMuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 08:50:01 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:52647 "EHLO
	outbound3-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965778AbXDCMuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 08:50:00 -0400
X-BigFish: VP
X-Server-Uuid: 519AC16A-9632-469E-B354-112C592D09E8
Message-ID: <46124D66.7030309@amd.com>
Date: Tue, 03 Apr 2007 14:49:42 +0200
From: "Joachim Deguara" <joachim.deguara@amd.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: discuss@x86-64.org, "Langsdorf, Mark" <mark.langsdorf@amd.com>,
       linux-kernel@vger.kernel.org,
       "Nagendra, Bhavana" <bhavana.nagendra@amd.com>
Subject: [PATCH] i386 mce check capability
X-OriginalArrivalTime: 03 Apr 2007 12:49:48.0488 (UTC)
 FILETIME=[902CF480:01C775EE]
X-WSS-ID: 6A0C92FB2X04488422-01-01
Content-Type: multipart/mixed;
 boundary=------------090806060603000703000502
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090806060603000703000502
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit

Currently the i386 architecture checks the family for mce capability and this removes that and uses the CPUID information.  Tested on a K8 revE and a family10h processor.

-Joachim

--------------090806060603000703000502
Content-Type: text/x-patch;
 name=i386_mce_check_capability.patch
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename=i386_mce_check_capability.patch

VGhpcyBlbGltaW5hdGVzIGNoZWNraW5nIG9mIGEgc2V0IEFNRCBwcm9jZXNvciBmYW1pbHkg
aWYgbWNlIGlzIAphbGxvd2VkIGFuZCByZWxpZXMgb24gdGhlIGluZm9ybWF0aW9uIGJlaW5n
IGluIENQVUlELgoKU2lnbmVkLW9mZi1ieTogSm9hY2hpbSBEZWd1YXJhIDxqb2FjaGltLmRl
Z3VhcmFAYW1kLmNvbT4KCkluZGV4OiAyLjYtbGludXMtZ2l0L2FyY2gvaTM4Ni9rZXJuZWwv
Y3B1L21jaGVjay9tY2UuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSAyLjYtbGludXMtZ2l0Lm9yaWcv
YXJjaC9pMzg2L2tlcm5lbC9jcHUvbWNoZWNrL21jZS5jCisrKyAyLjYtbGludXMtZ2l0L2Fy
Y2gvaTM4Ni9rZXJuZWwvY3B1L21jaGVjay9tY2UuYwpAQCAtMzgsOCArMzgsNyBAQCB2b2lk
IG1jaGVja19pbml0KHN0cnVjdCBjcHVpbmZvX3g4NiAqYykKIAogCXN3aXRjaCAoYy0+eDg2
X3ZlbmRvcikgewogCQljYXNlIFg4Nl9WRU5ET1JfQU1EOgotCQkJaWYgKGMtPng4Nj09NiB8
fCBjLT54ODY9PTE1KQotCQkJCWFtZF9tY2hlY2tfaW5pdChjKTsKKwkJCWFtZF9tY2hlY2tf
aW5pdChjKTsKIAkJCWJyZWFrOwogCiAJCWNhc2UgWDg2X1ZFTkRPUl9JTlRFTDoKSW5kZXg6
IDIuNi1saW51cy1naXQvYXJjaC9pMzg2L2tlcm5lbC9jcHUvbWNoZWNrL2s3LmMKPT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PQotLS0gMi42LWxpbnVzLWdpdC5vcmlnL2FyY2gvaTM4Ni9rZXJuZWwvY3B1L21j
aGVjay9rNy5jCisrKyAyLjYtbGludXMtZ2l0L2FyY2gvaTM4Ni9rZXJuZWwvY3B1L21jaGVj
ay9rNy5jCkBAIC03NSw2ICs3NSw5IEBAIHZvaWQgYW1kX21jaGVja19pbml0KHN0cnVjdCBj
cHVpbmZvX3g4NiAKIAltYWNoaW5lX2NoZWNrX3ZlY3RvciA9IGs3X21hY2hpbmVfY2hlY2s7
CiAJd21iKCk7CiAKKwlpZiAoIWNwdV9oYXMoYywgWDg2X0ZFQVRVUkVfTUNFKSkKKwkJcmV0
dXJuOworCiAJcHJpbnRrIChLRVJOX0lORk8gIkludGVsIG1hY2hpbmUgY2hlY2sgYXJjaGl0
ZWN0dXJlIHN1cHBvcnRlZC5cbiIpOwogCXJkbXNyIChNU1JfSUEzMl9NQ0dfQ0FQLCBsLCBo
KTsKIAlpZiAobCAmICgxPDw4KSkJLyogQ29udHJvbCByZWdpc3RlciBwcmVzZW50ID8gKi8K

--------------090806060603000703000502--


