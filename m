Return-Path: <linux-kernel-owner+w=401wt.eu-S1758169AbZAGN1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169AbZAGN1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 08:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756764AbZAGN1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 08:27:06 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:33033 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757929AbZAGN1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 08:27:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=pIOKMGG0UHCDHC4/60YeugpWy4I5RkBNGZbnQL6MaQ9JJix3fjk9mDiKDoPOJHYD6f
         0sNvOI+2lw7ZRIOoWWTAyt/qLm2iuT7ExULguUkLHlLohfmvXoPSI2e2pFr8Xjxtj+Oq
         wNGANg1mXg23Ho9LnI4kLQkp6s6P0OggKHoHM=
Message-ID: <3f9a31f40901070527y31fcccc9n5b3d52faa58e359e@mail.gmail.com>
Date: Wed, 7 Jan 2009 18:57:04 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "Andy Whitcroft" <apw@canonical.com>
Subject: Re: scripts/checkpatch.pl : undefined value as an ARRAY reference
Cc: davej@redhat.com, "Ingo Molnar" <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20090107130742.GD2520@shadowen.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_86995_14555390.1231334824282"
References: <3f9a31f40901070454x678f75d2xee2a6de04a940321@mail.gmail.com>
	 <20090107130742.GD2520@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_86995_14555390.1231334824282
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, Jan 7, 2009 at 6:37 PM, Andy Whitcroft <apw@canonical.com> wrote:
> On Wed, Jan 07, 2009 at 06:24:55PM +0530, Jaswinder Singh Rajput wrote:
>> Hello Andy,
>>
>> On -tip git I am getting this error:
>>
>> $ ./scripts/checkpatch.pl 000*
>> Can't use an undefined value as an ARRAY reference at
>> ./scripts/checkpatch.pl line 451.
>>
>> But earlier it was working great. Is this a feature or a bug.
>
> That looks wrong indeed.  Assuming that is the same version I have here
> then that is a bug in the #else preprocessor handling.  Could you send
> me the specific patch which is throwing this error.
>

./scripts/checkpatch.pl
0007-x86-smp.h-move-boot_cpu_id-declartion-to-cpu.h.patch
Can't use an undefined value as an ARRAY reference at
./scripts/checkpatch.pl line 453.

I am attaching this file you can also save this file from LKML

--
JSR

------=_Part_86995_14555390.1231334824282
Content-Type: application/octet-stream;
 name=0007-x86-smp.h-move-boot_cpu_id-declartion-to-cpu.h.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fpo0vsoy0
Content-Disposition: attachment;
 filename=0007-x86-smp.h-move-boot_cpu_id-declartion-to-cpu.h.patch

RnJvbSAxMWQzOWI0ZDRhZWE0NWJkNjgwMTMzNTc3ZWY2NjJhNzhmMTMyYWRkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKYXN3aW5kZXIgU2luZ2ggPGphc3dpbmRlckBodC5zYXRuYW0+
CkRhdGU6IFdlZCwgNyBKYW4gMjAwOSAxNjozNDo0MCArMDUzMApTdWJqZWN0OiBbUEFUQ0hdIHg4
Njogc21wLmggbW92ZSBib290X2NwdV9pZCBkZWNsYXJ0aW9uIHRvIGNwdS5oCgpJbXBhY3Q6IGNs
ZWFudXAsIG1vdmluZyBOT04tU01QIHN0dWZmIGZyb20gc21wLmgKClNpZ25lZC1vZmYtYnk6IEph
c3dpbmRlciBTaW5naCBSYWpwdXQgPGphc3dpbmRlcnJhanB1dEBnbWFpbC5jb20+Ci0tLQogYXJj
aC94ODYvaW5jbHVkZS9hc20vY3B1LmggICB8ICAgIDcgKysrKysrKwogYXJjaC94ODYvaW5jbHVk
ZS9hc20vc21wLmggICB8ICAgIDYgLS0tLS0tCiBhcmNoL3g4Ni9rZXJuZWwvY3B1L2NvbW1vbi5j
IHwgICAgMiArLQogYXJjaC94ODYva2VybmVsL2lvX2FwaWMuYyAgICB8ICAgIDEgKwogZHJpdmVy
cy9wY2kvaW50cl9yZW1hcHBpbmcuYyB8ICAgIDEgKwogNSBmaWxlcyBjaGFuZ2VkLCAxMCBpbnNl
cnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUv
YXNtL2NwdS5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vY3B1LmgKaW5kZXggODllZGFmYi4uZjAz
YjIzZSAxMDA2NDQKLS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20vY3B1LmgKKysrIGIvYXJjaC94
ODYvaW5jbHVkZS9hc20vY3B1LmgKQEAgLTMxLDQgKzMxLDExIEBAIGV4dGVybiB2b2lkIGFyY2hf
dW5yZWdpc3Rlcl9jcHUoaW50KTsKICNlbmRpZgogCiBERUNMQVJFX1BFUl9DUFUoaW50LCBjcHVf
c3RhdGUpOworCisjaWZkZWYgQ09ORklHX1g4Nl9IQVNfQk9PVF9DUFVfSUQKK2V4dGVybiB1bnNp
Z25lZCBjaGFyIGJvb3RfY3B1X2lkOworI2Vsc2UKKyNkZWZpbmUgYm9vdF9jcHVfaWQJCQkJMAor
I2VuZGlmCisKICNlbmRpZiAvKiBfQVNNX1g4Nl9DUFVfSCAqLwpkaWZmIC0tZ2l0IGEvYXJjaC94
ODYvaW5jbHVkZS9hc20vc21wLmggYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9zbXAuaAppbmRleCAx
MzZmMWM3Li4xOTYzZTI3IDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9zbXAuaAor
KysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9zbXAuaApAQCAtMjM4LDExICsyMzgsNSBAQCBzdGF0
aWMgaW5saW5lIGludCBoYXJkX3NtcF9wcm9jZXNzb3JfaWQodm9pZCkKIAogI2VuZGlmIC8qIENP
TkZJR19YODZfTE9DQUxfQVBJQyAqLwogCi0jaWZkZWYgQ09ORklHX1g4Nl9IQVNfQk9PVF9DUFVf
SUQKLWV4dGVybiB1bnNpZ25lZCBjaGFyIGJvb3RfY3B1X2lkOwotI2Vsc2UKLSNkZWZpbmUgYm9v
dF9jcHVfaWQJMAotI2VuZGlmCi0KICNlbmRpZiAvKiBfX0FTU0VNQkxZX18gKi8KICNlbmRpZiAv
KiBfQVNNX1g4Nl9TTVBfSCAqLwpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL2NwdS9jb21t
b24uYyBiL2FyY2gveDg2L2tlcm5lbC9jcHUvY29tbW9uLmMKaW5kZXggNjY3ZTVkNS4uNjkzZjNi
OSAxMDA2NDQKLS0tIGEvYXJjaC94ODYva2VybmVsL2NwdS9jb21tb24uYworKysgYi9hcmNoL3g4
Ni9rZXJuZWwvY3B1L2NvbW1vbi5jCkBAIC0yMSw3ICsyMSw3IEBACiAjaW5jbHVkZSA8YXNtL3Bh
dC5oPgogI2luY2x1ZGUgPGFzbS9hc20uaD4KICNpbmNsdWRlIDxhc20vbnVtYS5oPgotI2luY2x1
ZGUgPGFzbS9zbXAuaD4KKyNpbmNsdWRlIDxhc20vY3B1Lmg+CiAjaWZkZWYgQ09ORklHX1g4Nl9M
T0NBTF9BUElDCiAjaW5jbHVkZSA8YXNtL21wc3BlYy5oPgogI2luY2x1ZGUgPGFzbS9hcGljLmg+
CmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvaW9fYXBpYy5jIGIvYXJjaC94ODYva2VybmVs
L2lvX2FwaWMuYwppbmRleCAxYzRhMTMwLi4xMDljOTFkIDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9r
ZXJuZWwvaW9fYXBpYy5jCisrKyBiL2FyY2gveDg2L2tlcm5lbC9pb19hcGljLmMKQEAgLTQ2LDYg
KzQ2LDcgQEAKICNpbmNsdWRlIDxhc20vaWRsZS5oPgogI2luY2x1ZGUgPGFzbS9pby5oPgogI2lu
Y2x1ZGUgPGFzbS9zbXAuaD4KKyNpbmNsdWRlIDxhc20vY3B1Lmg+CiAjaW5jbHVkZSA8YXNtL2Rl
c2MuaD4KICNpbmNsdWRlIDxhc20vcHJvdG8uaD4KICNpbmNsdWRlIDxhc20vYWNwaS5oPgpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9wY2kvaW50cl9yZW1hcHBpbmcuYyBiL2RyaXZlcnMvcGNpL2ludHJf
cmVtYXBwaW5nLmMKaW5kZXggZjc4MzcxYi4uNWE1Nzc1MyAxMDA2NDQKLS0tIGEvZHJpdmVycy9w
Y2kvaW50cl9yZW1hcHBpbmcuYworKysgYi9kcml2ZXJzL3BjaS9pbnRyX3JlbWFwcGluZy5jCkBA
IC02LDYgKzYsNyBAQAogI2luY2x1ZGUgPGxpbnV4L2lycS5oPgogI2luY2x1ZGUgPGFzbS9pb19h
cGljLmg+CiAjaW5jbHVkZSA8YXNtL3NtcC5oPgorI2luY2x1ZGUgPGFzbS9jcHUuaD4KICNpbmNs
dWRlIDxsaW51eC9pbnRlbC1pb21tdS5oPgogI2luY2x1ZGUgImludHJfcmVtYXBwaW5nLmgiCiAK
LS0gCjEuNi4wLjYKCg==
------=_Part_86995_14555390.1231334824282--
