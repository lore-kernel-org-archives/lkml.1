Return-Path: <linux-kernel-owner+w=401wt.eu-S1752884AbYKSWUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbYKSWUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 17:20:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbYKSWU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 17:20:26 -0500
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:59067 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbYKSWUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 17:20:24 -0500
Message-ID: <49249121.6050304@freemail.hu>
Date: Wed, 19 Nov 2008 23:20:17 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: "Zhang, Rui" <rui.zhang@intel.com>, linux-acpi@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: AE_ERROR, ACPI thermal trip point state changed
References: <47B328AA.1000800@freemail.hu> <47B3F147.7000704@freemail.hu>	<47CF96E2.9020302@freemail.hu>	<1204757373.10256.179.camel@acpi-hp-zz.sh.intel.com>	<823A93EED437D048963A3697DB0E35DE0129BB78@pdsmsx414.ccr.corp.intel.com>	<47D0E694.5050102@freemail.hu>	<1204874686.10256.185.camel@acpi-hp-zz.sh.intel.com>	<47D24341.5070908@freemail.hu>	<1205113940.10256.191.camel@acpi-hp-zz.sh.intel.com>	<48ABDF1E.3010101@freemail.hu> <8763pwypf5.fsf@basil.nowhere.org>
In-Reply-To: <8763pwypf5.fsf@basil.nowhere.org>
Content-Type: multipart/mixed;
 boundary="------------070706010702010005010203"
X-DCC-mail.t-online.hu-Metrics: mail01d.mail.t-online.hu 32720; Body=4 Fuz1=4
	Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070706010702010005010203
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

Andi Kleen wrote:
> Németh Márton <nm127@freemail.hu> writes:
>> As of 2.6.27-rc3 the patch is still not included in the mainstream. I
>> hope that this patch was not forgotten completely.
> 
> It's already in Linus' tree, will be in rc4.

I compiled and tried 2.6.28-rc5. In the dmesg I get the following message:

[   63.589603] ACPI Exception (thermal-0538): AE_ERROR, ACPI thermal trip point state changed
[   63.589669] Please send acpidump to linux-acpi@vger.kernel.org
[   63.589805]  [20080926]

The original patch still applies for 2.6.28-rc5 (with some offsets). This patch
is not included in 2.6.28-rc5, yet. The "AE_ERROR..." message does not appear
any more if I apply the patch. I attached this original patch for easier reference.

Regards,

	Márton Németh



--------------070706010702010005010203
Content-Type: text/plain;
 name="thermal-fix"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="thermal-fix"

dGhlcm1hbCBmaXh1cCBmb3IgYnJva2VuIEJJT1Mgd2hpY2ggaGFzIGludmFsaWQgdHJpcCBw
b2ludHMuCgpBQ1BJIHRoZXJtYWwgZHJpdmVyIG9ubHkgcmUtZXZhbHVhdGUgdmFsaWQgdHJp
cCBwb2ludHMuCkZvciB0aGUgYnJva2VuIEJJT1Mgc2hvdyBpbgpodHRwOi8vYnVnemlsbGEu
a2VybmVsLm9yZy9zaG93X2J1Zy5jZ2k/aWQ9ODU0NAp0aGUgYWN0aXZlWzBdIGlzIHNldCB0
byBpbnZhbGlkIGF0IGJvb3QgdGltZQphbmQgaXQgd2lsbCBub3QgYmUgcmUtZXZhbHVhdGVk
IGFnYWluLgpXZSBjYW4gc3RpbGwgZ2V0IGEgd2FybmluZyBtZXNzYWdlIGF0IGJvb3QgdGlt
ZS4KCmh0dHA6Ly9tYXJjLmluZm8vP2w9bGludXgta2VybmVsJm09MTIwNDk2MjIyNjI5OTgz
Jnc9MgoKU2lnbmVkLW9mZi1ieTogWmhhbmcgUnVpPHJ1aS56aGFuZ0BpbnRlbC5jb20+Ci0t
LQogZHJpdmVycy9hY3BpL3RoZXJtYWwuYyB8ICAgMTYgKysrKysrKysrKysrLS0tLQogMSBm
aWxlIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pCgpJbmRleDog
bGludXgtMi42L2RyaXZlcnMvYWNwaS90aGVybWFsLmMKPT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGlu
dXgtMi42Lm9yaWcvZHJpdmVycy9hY3BpL3RoZXJtYWwuYworKysgbGludXgtMi42L2RyaXZl
cnMvYWNwaS90aGVybWFsLmMKQEAgLTQwMSw3ICs0MDEsOCBAQCBzdGF0aWMgaW50IGFjcGlf
dGhlcm1hbF90cmlwc191cGRhdGUoc3RyCiAJfQogCiAJLyogUGFzc2l2ZSAob3B0aW9uYWwp
ICovCi0JaWYgKGZsYWcgJiBBQ1BJX1RSSVBTX1BBU1NJVkUpIHsKKwlpZiAoKChmbGFnICYg
QUNQSV9UUklQU19QQVNTSVZFKSAmJiB0ei0+dHJpcHMucGFzc2l2ZS5mbGFncy52YWxpZCkg
fHwKKwkJKGZsYWcgPT0gQUNQSV9UUklQU19JTklUKSkgewogCQl2YWxpZCA9IHR6LT50cmlw
cy5wYXNzaXZlLmZsYWdzLnZhbGlkOwogCQlpZiAocHN2ID09IC0xKSB7CiAJCQlzdGF0dXMg
PSBBRV9TVVBQT1JUOwpAQCAtNDQwLDggKzQ0MSwxMSBAQCBzdGF0aWMgaW50IGFjcGlfdGhl
cm1hbF90cmlwc191cGRhdGUoc3RyCiAJCW1lbXNldCgmZGV2aWNlcywgMCwgc2l6ZW9mKHN0
cnVjdCBhY3BpX2hhbmRsZV9saXN0KSk7CiAJCXN0YXR1cyA9IGFjcGlfZXZhbHVhdGVfcmVm
ZXJlbmNlKHR6LT5kZXZpY2UtPmhhbmRsZSwgIl9QU0wiLAogCQkJCQkJCU5VTEwsICZkZXZp
Y2VzKTsKLQkJaWYgKEFDUElfRkFJTFVSRShzdGF0dXMpKQorCQlpZiAoQUNQSV9GQUlMVVJF
KHN0YXR1cykpIHsKKwkJCXByaW50ayhLRVJOX1dBUk5JTkcgUFJFRklYCisJCQkJIkludmFs
aWQgcGFzc2l2ZSB0aHJlc2hvbGRcbiIpOwogCQkJdHotPnRyaXBzLnBhc3NpdmUuZmxhZ3Mu
dmFsaWQgPSAwOworCQl9CiAJCWVsc2UKIAkJCXR6LT50cmlwcy5wYXNzaXZlLmZsYWdzLnZh
bGlkID0gMTsKIApAQCAtNDY1LDcgKzQ2OSw4IEBAIHN0YXRpYyBpbnQgYWNwaV90aGVybWFs
X3RyaXBzX3VwZGF0ZShzdHIKIAkJaWYgKGFjdCA9PSAtMSkKIAkJCWJyZWFrOyAvKiBkaXNh
YmxlIGFsbCBhY3RpdmUgdHJpcCBwb2ludHMgKi8KIAotCQlpZiAoZmxhZyAmIEFDUElfVFJJ
UFNfQUNUSVZFKSB7CisJCWlmICgoZmxhZyA9PSBBQ1BJX1RSSVBTX0lOSVQpIHx8ICgoZmxh
ZyAmIEFDUElfVFJJUFNfQUNUSVZFKSAmJgorCQkJdHotPnRyaXBzLmFjdGl2ZVtpXS5mbGFn
cy52YWxpZCkpIHsKIAkJCXN0YXR1cyA9IGFjcGlfZXZhbHVhdGVfaW50ZWdlcih0ei0+ZGV2
aWNlLT5oYW5kbGUsCiAJCQkJbmFtZSwgTlVMTCwgJnR6LT50cmlwcy5hY3RpdmVbaV0udGVt
cGVyYXR1cmUpOwogCQkJaWYgKEFDUElfRkFJTFVSRShzdGF0dXMpKSB7CkBAIC00OTcsOCAr
NTAyLDExIEBAIHN0YXRpYyBpbnQgYWNwaV90aGVybWFsX3RyaXBzX3VwZGF0ZShzdHIKIAkJ
CW1lbXNldCgmZGV2aWNlcywgMCwgc2l6ZW9mKHN0cnVjdCBhY3BpX2hhbmRsZV9saXN0KSk7
CiAJCQlzdGF0dXMgPSBhY3BpX2V2YWx1YXRlX3JlZmVyZW5jZSh0ei0+ZGV2aWNlLT5oYW5k
bGUsCiAJCQkJCQluYW1lLCBOVUxMLCAmZGV2aWNlcyk7Ci0JCQlpZiAoQUNQSV9GQUlMVVJF
KHN0YXR1cykpCisJCQlpZiAoQUNQSV9GQUlMVVJFKHN0YXR1cykpIHsKKwkJCQlwcmludGso
S0VSTl9XQVJOSU5HIFBSRUZJWAorCQkJCQkiSW52YWxpZCBhY3RpdmUlZCB0aHJlc2hvbGRc
biIsIGkpOwogCQkJCXR6LT50cmlwcy5hY3RpdmVbaV0uZmxhZ3MudmFsaWQgPSAwOworCQkJ
fQogCQkJZWxzZQogCQkJCXR6LT50cmlwcy5hY3RpdmVbaV0uZmxhZ3MudmFsaWQgPSAxOwog
Cg==
--------------070706010702010005010203--
