Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803AbZAJJCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbZAJJCd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 04:02:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbZAJJCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 04:02:18 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:30526 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbZAJJCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 04:02:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type;
        b=MRjdm4Kvurn+wJRQgoOsQAMRpvOiGEM+wGIK45DZHAVNYiKI4riBTp/YJ/h1X+OoSN
         Lxf+HgUqIuqWy0m9uW30Atmj/N2AEeKivtUHm2Z+P3Lj4P4Db7sEl8FaYo24DllF0fyC
         Nk4IFmfojjBl1qD8kjgSg1drC0RRp5Pov4X8w=
Message-ID: <3f9a31f40901100102q79a24dcbiaeaf4bf97d7c02a3@mail.gmail.com>
Date: Sat, 10 Jan 2009 14:32:15 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "x86 maintainers" <x86@kernel.org>,
       "Mike Travis" <travis@sgi.com>, "Rusty Russell" <rusty@rustcorp.com.au>,
       "Jack Steiner" <steiner@sgi.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PULL -tip] x86: smp.h move cpumask related things to cpumask.h
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_258800_30675958.1231578135497"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_258800_30675958.1231578135497
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

The following changes since commit 22e34e5f3362464f1095bc028fc5df945663cd0a:
  Ingo Molnar (1):
        manual merge of out-of-tree

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git
master

Jaswinder Singh Rajput (4):
      x86: smp.h move cpu_callin_mask and cpu_callin_map declartion to cpumask.h
      x86: smp.h move cpu_callout_mask and cpu_callout_map declartion
to cpumask.h
      x86: smp.h move cpu_initialized_mask and cpu_initialized
declartion to cpumask.h
      x86: smp.h move cpu_sibling_setup_mask and cpu_sibling_setup_map
declartion to cpumask.h

 arch/x86/include/asm/cpumask.h |   28 ++++++++++++++++++++++++++++
 arch/x86/include/asm/smp.h     |   22 +---------------------
 arch/x86/kernel/cpu/common.c   |    1 +
 arch/x86/kernel/setup_percpu.c |    1 +
 4 files changed, 31 insertions(+), 21 deletions(-)
 create mode 100644 arch/x86/include/asm/cpumask.h

Thanks
--
JSR

------=_Part_258800_30675958.1231578135497
Content-Type: application/octet-stream; name=git-pull-cpumask.diff
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fps1rr8q0
Content-Disposition: attachment; filename=git-pull-cpumask.diff

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL2NwdW1hc2suaCBiL2FyY2gveDg2L2lu
Y2x1ZGUvYXNtL2NwdW1hc2suaApuZXcgZmlsZSBtb2RlIDEwMDY0NAppbmRleCAwMDAwMDAwLi4y
NmM2ZGFkCi0tLSAvZGV2L251bGwKKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vY3B1bWFzay5o
CkBAIC0wLDAgKzEsMjggQEAKKyNpZm5kZWYgX0FTTV9YODZfQ1BVTUFTS19ICisjZGVmaW5lIF9B
U01fWDg2X0NQVU1BU0tfSAorI2lmbmRlZiBfX0FTU0VNQkxZX18KKyNpbmNsdWRlIDxsaW51eC9j
cHVtYXNrLmg+CisKKyNpZmRlZiBDT05GSUdfWDg2XzY0CisKK2V4dGVybiBjcHVtYXNrX3Zhcl90
IGNwdV9jYWxsaW5fbWFzazsKK2V4dGVybiBjcHVtYXNrX3Zhcl90IGNwdV9jYWxsb3V0X21hc2s7
CitleHRlcm4gY3B1bWFza192YXJfdCBjcHVfaW5pdGlhbGl6ZWRfbWFzazsKK2V4dGVybiBjcHVt
YXNrX3Zhcl90IGNwdV9zaWJsaW5nX3NldHVwX21hc2s7CisKKyNlbHNlIC8qIENPTkZJR19YODZf
MzIgKi8KKworZXh0ZXJuIGNwdW1hc2tfdCBjcHVfY2FsbGluX21hcDsKK2V4dGVybiBjcHVtYXNr
X3QgY3B1X2NhbGxvdXRfbWFwOworZXh0ZXJuIGNwdW1hc2tfdCBjcHVfaW5pdGlhbGl6ZWQ7Citl
eHRlcm4gY3B1bWFza190IGNwdV9zaWJsaW5nX3NldHVwX21hcDsKKworI2RlZmluZSBjcHVfY2Fs
bGluX21hc2sJCSgoc3RydWN0IGNwdW1hc2sgKikmY3B1X2NhbGxpbl9tYXApCisjZGVmaW5lIGNw
dV9jYWxsb3V0X21hc2sJKChzdHJ1Y3QgY3B1bWFzayAqKSZjcHVfY2FsbG91dF9tYXApCisjZGVm
aW5lIGNwdV9pbml0aWFsaXplZF9tYXNrCSgoc3RydWN0IGNwdW1hc2sgKikmY3B1X2luaXRpYWxp
emVkKQorI2RlZmluZSBjcHVfc2libGluZ19zZXR1cF9tYXNrCSgoc3RydWN0IGNwdW1hc2sgKikm
Y3B1X3NpYmxpbmdfc2V0dXBfbWFwKQorCisjZW5kaWYgLyogQ09ORklHX1g4Nl8zMiAqLworCisj
ZW5kaWYgLyogX19BU1NFTUJMWV9fICovCisjZW5kaWYgLyogX0FTTV9YODZfQ1BVTUFTS19IICov
CmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9zbXAuaCBiL2FyY2gveDg2L2luY2x1
ZGUvYXNtL3NtcC5oCmluZGV4IDE5NjNlMjcuLmE4Y2VhN2IgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2
L2luY2x1ZGUvYXNtL3NtcC5oCisrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3NtcC5oCkBAIC0x
NywyNyArMTcsNyBAQAogI2VuZGlmCiAjaW5jbHVkZSA8YXNtL3BkYS5oPgogI2luY2x1ZGUgPGFz
bS90aHJlYWRfaW5mby5oPgotCi0jaWZkZWYgQ09ORklHX1g4Nl82NAotCi1leHRlcm4gY3B1bWFz
a192YXJfdCBjcHVfY2FsbGluX21hc2s7Ci1leHRlcm4gY3B1bWFza192YXJfdCBjcHVfY2FsbG91
dF9tYXNrOwotZXh0ZXJuIGNwdW1hc2tfdmFyX3QgY3B1X2luaXRpYWxpemVkX21hc2s7Ci1leHRl
cm4gY3B1bWFza192YXJfdCBjcHVfc2libGluZ19zZXR1cF9tYXNrOwotCi0jZWxzZSAvKiBDT05G
SUdfWDg2XzMyICovCi0KLWV4dGVybiBjcHVtYXNrX3QgY3B1X2NhbGxpbl9tYXA7Ci1leHRlcm4g
Y3B1bWFza190IGNwdV9jYWxsb3V0X21hcDsKLWV4dGVybiBjcHVtYXNrX3QgY3B1X2luaXRpYWxp
emVkOwotZXh0ZXJuIGNwdW1hc2tfdCBjcHVfc2libGluZ19zZXR1cF9tYXA7Ci0KLSNkZWZpbmUg
Y3B1X2NhbGxpbl9tYXNrCQkoKHN0cnVjdCBjcHVtYXNrICopJmNwdV9jYWxsaW5fbWFwKQotI2Rl
ZmluZSBjcHVfY2FsbG91dF9tYXNrCSgoc3RydWN0IGNwdW1hc2sgKikmY3B1X2NhbGxvdXRfbWFw
KQotI2RlZmluZSBjcHVfaW5pdGlhbGl6ZWRfbWFzawkoKHN0cnVjdCBjcHVtYXNrICopJmNwdV9p
bml0aWFsaXplZCkKLSNkZWZpbmUgY3B1X3NpYmxpbmdfc2V0dXBfbWFzawkoKHN0cnVjdCBjcHVt
YXNrICopJmNwdV9zaWJsaW5nX3NldHVwX21hcCkKLQotI2VuZGlmIC8qIENPTkZJR19YODZfMzIg
Ki8KKyNpbmNsdWRlIDxhc20vY3B1bWFzay5oPgogCiBleHRlcm4gaW50IF9fY3B1aW5pdCBnZXRf
bG9jYWxfcGRhKGludCBjcHUpOwogCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L2Nv
bW1vbi5jIGIvYXJjaC94ODYva2VybmVsL2NwdS9jb21tb24uYwppbmRleCBmYjkzNWFmLi43OGY4
NWY3IDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L2NvbW1vbi5jCisrKyBiL2FyY2gv
eDg2L2tlcm5lbC9jcHUvY29tbW9uLmMKQEAgLTIzLDYgKzIzLDcgQEAKICNpbmNsdWRlIDxhc20v
bnVtYS5oPgogI2luY2x1ZGUgPGFzbS9zbXAuaD4KICNpbmNsdWRlIDxhc20vY3B1Lmg+CisjaW5j
bHVkZSA8YXNtL2NwdW1hc2suaD4KICNpZmRlZiBDT05GSUdfWDg2X0xPQ0FMX0FQSUMKICNpbmNs
dWRlIDxhc20vbXBzcGVjLmg+CiAjaW5jbHVkZSA8YXNtL2FwaWMuaD4KZGlmZiAtLWdpdCBhL2Fy
Y2gveDg2L2tlcm5lbC9zZXR1cF9wZXJjcHUuYyBiL2FyY2gveDg2L2tlcm5lbC9zZXR1cF9wZXJj
cHUuYwppbmRleCA1NWM0NjA3Li5iZjYzZGU3IDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9rZXJuZWwv
c2V0dXBfcGVyY3B1LmMKKysrIGIvYXJjaC94ODYva2VybmVsL3NldHVwX3BlcmNwdS5jCkBAIC0x
Myw2ICsxMyw3IEBACiAjaW5jbHVkZSA8YXNtL21wc3BlYy5oPgogI2luY2x1ZGUgPGFzbS9hcGlj
ZGVmLmg+CiAjaW5jbHVkZSA8YXNtL2hpZ2htZW0uaD4KKyNpbmNsdWRlIDxhc20vY3B1bWFzay5o
PgogCiAjaWZkZWYgQ09ORklHX1g4Nl9MT0NBTF9BUElDCiB1bnNpZ25lZCBpbnQgbnVtX3Byb2Nl
c3NvcnM7Cg==
------=_Part_258800_30675958.1231578135497--
