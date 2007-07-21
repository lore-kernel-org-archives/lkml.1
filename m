Return-Path: <linux-kernel-owner+w=401wt.eu-S933430AbXGUH4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933430AbXGUH4Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 03:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757260AbXGUH4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 03:56:16 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:4765 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171AbXGUH4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 03:56:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type;
        b=tgIvaL16aklnlRnUwpjBLatnPsTRNOp7k5uqUBfmfrycmLLfUGIeBRdz8EgzVrsuqbOJASzgLrIKLLeq+C1+z6A07jqd1Y2S8Ek5w1O0VqenVcsYLm9Fo7rdIbOzasej629DDxDXkr94zmbWOHKx/rhkHpF1rmoD/ycbMChE2Mo=
Message-ID: <86802c440707210056s745d44f1jc6437064741299eb@mail.gmail.com>
Date: Sat, 21 Jul 2007 00:56:15 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>
Subject: [PATCH] x86_64: use apic core id bits for core nums
Cc: joachim.deguara@amd.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_136928_4170142.1185004575223"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_136928_4170142.1185004575223
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

please check my version, we should use core id bits instead.

it should replace
[PATCH for review] [37/48] x86_64: make k8topology multi-core aware

YH

[PATCH] x86_64: use apic core id bits for core nums

we need to use apic core id bits to get core num and use that get apic_to_node
correctly.
it will work with quad core downcores cpus.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

------=_Part_136928_4170142.1185004575223
Content-Type: text/x-patch; name=k8_core.diff; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f4dtqi9u
Content-Disposition: attachment; filename="k8_core.diff"

ZGlmZiAtLWdpdCBhL2FyY2gveDg2XzY0L21tL2s4dG9wb2xvZ3kuYyBiL2FyY2gveDg2XzY0L21t
L2s4dG9wb2xvZ3kuYwppbmRleCBmOTgzYzc1Li4zZThlNDdmIDEwMDY0NAotLS0gYS9hcmNoL3g4
Nl82NC9tbS9rOHRvcG9sb2d5LmMKKysrIGIvYXJjaC94ODZfNjQvbW0vazh0b3BvbG9neS5jCkBA
IC00OSw3ICs0OSwxMCBAQCBpbnQgX19pbml0IGs4X3NjYW5fbm9kZXModW5zaWduZWQgbG9uZyBz
dGFydCwgdW5zaWduZWQgbG9uZyBlbmQpCiAJaW50IGZvdW5kID0gMDsKIAl1MzIgcmVnOwogCXVu
c2lnbmVkIG51bW5vZGVzOwotCXVuc2lnbmVkIGR1YWxjb3JlID0gMDsKKwl1bnNpZ25lZCBjb3Jl
czsKKwl1MzIgZWN4OworCXVuc2lnbmVkIGJpdHM7CisJaW50IGo7CiAKIAlpZiAoIWVhcmx5X3Bj
aV9hbGxvd2VkKCkpCiAJCXJldHVybiAtMTsKQEAgLTY3LDE0ICs3MCwyNiBAQCBpbnQgX19pbml0
IGs4X3NjYW5fbm9kZXModW5zaWduZWQgbG9uZyBzdGFydCwgdW5zaWduZWQgbG9uZyBlbmQpCiAK
IAlwcmludGsoS0VSTl9JTkZPICJOdW1iZXIgb2Ygbm9kZXMgJWRcbiIsIG51bW5vZGVzKTsKIAor
ICAgICAgICBlY3ggPSBjcHVpZF9lY3goMHg4MDAwMDAwOCk7CisgICAgICAgIGNvcmVzID0gKGVj
eCAmIDB4ZmYpICsgMTsKKworICAgICAgICAvKiBDUFUgdGVsbGluZyB1cyB0aGUgY29yZSBpZCBi
aXRzIHNoaWZ0PyAqLworICAgICAgICBiaXRzID0gKGVjeCA+PiAxMikgJiAweEY7CisKKyAgICAg
ICAgLyogT3RoZXJ3aXNlIHJlY29tcHV0ZSAqLworICAgICAgICBpZiAoYml0cyA9PSAwKSB7Cisg
ICAgICAgICAgICAgICAgd2hpbGUgKCgxIDw8IGJpdHMpIDwgY29yZXMpCisgICAgICAgICAgICAg
ICAgICAgICAgICBiaXRzKys7CisgICAgICAgIH0KKworCWNvcmVzID0gKDE8PGJpdHMpOworCiAJ
bWVtc2V0KCZub2RlcywwLHNpemVvZihub2RlcykpOyAKIAlwcmV2YmFzZSA9IDA7CiAJZm9yIChp
ID0gMDsgaSA8IDg7IGkrKykgeyAKIAkJdW5zaWduZWQgbG9uZyBiYXNlLGxpbWl0OyAKIAkJdTMy
IG5vZGVpZDsKIAkJCi0JCS8qIFVuZGVmaW5lZCBiZWZvcmUgRSBzdGVwcGluZywgYnV0IGhvcGVm
dWxseSAwICovCi0JCWR1YWxjb3JlIHw9ICgocmVhZF9wY2lfY29uZmlnKDAsIG5iLCAzLCAweGU4
KSA+PiAxMikgJiAzKSA9PSAxOwogCQliYXNlID0gcmVhZF9wY2lfY29uZmlnKDAsIG5iLCAxLCAw
eDQwICsgaSo4KTsKIAkJbGltaXQgPSByZWFkX3BjaV9jb25maWcoMCwgbmIsIDEsIDB4NDQgKyBp
KjgpOwogCkBAIC0xNzAsOCArMTg1LDggQEAgaW50IF9faW5pdCBrOF9zY2FuX25vZGVzKHVuc2ln
bmVkIGxvbmcgc3RhcnQsIHVuc2lnbmVkIGxvbmcgZW5kKQogCWZvciAoaSA9IDA7IGkgPCA4OyBp
KyspIHsKIAkJaWYgKG5vZGVzW2ldLnN0YXJ0ICE9IG5vZGVzW2ldLmVuZCkgeyAKIAkJCW5vZGVp
ZCA9IG5vZGVpZHNbaV07Ci0JCQlhcGljaWRfdG9fbm9kZVtub2RlaWQgPDwgZHVhbGNvcmVdID0g
aTsKLQkJCWFwaWNpZF90b19ub2RlWyhub2RlaWQgPDwgZHVhbGNvcmUpICsgZHVhbGNvcmVdID0g
aTsKKwkJCWZvciAoaiA9IDA7IGogPCBjb3JlczsgaisrKQorCQkJCWFwaWNpZF90b19ub2RlWyhu
b2RlaWQgPDwgYml0cykgKyBqXSA9IGk7CiAJCQlzZXR1cF9ub2RlX2Jvb3RtZW0oaSwgbm9kZXNb
aV0uc3RhcnQsIG5vZGVzW2ldLmVuZCk7IAogCQl9IAogCX0K
------=_Part_136928_4170142.1185004575223--
