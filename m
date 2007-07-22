Return-Path: <linux-kernel-owner+w=401wt.eu-S1756208AbXGVE5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbXGVE5X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 00:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbXGVE5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 00:57:10 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:45531 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbXGVE5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 00:57:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type;
        b=HZgDM5F6WRxhXKsQ2IZm+SntRVlKEItsUsa+5kw8x03/NeiLhOi8ffB46AWBSy+85SfZKX+QSQ0XReU+FgM7kxqZjv89p3Yq2N6la4bHyPZSGAd9S0EmI7lZDAu98D9x8ScLwNq8vCchdqt2RFAsDZU2zAVBdL/fs54nNzUcza8=
Message-ID: <86802c440707212157kbe46ffbk2483880b187eaa9f@mail.gmail.com>
Date: Sat, 21 Jul 2007 21:57:08 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>
Subject: [PATCH 2/3] x86_64: use core id bits for apicid_to_node initialization v2
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_143113_7196464.1185080228424"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_143113_7196464.1185080228424
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Please check the updated version to current tree.

[PATCH 2/3] x86_64: use core id bits for apicid_to_node initialization

We shoud use core id bits instead of max cores, in case later with AMD
downcores Quad core Opteron.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

------=_Part_143113_7196464.1185080228424
Content-Type: text/x-patch; name=2x.patch; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f4f2tbxv
Content-Disposition: attachment; filename="2x.patch"

ZGlmZiAtLWdpdCBhL2FyY2gveDg2XzY0L21tL2s4dG9wb2xvZ3kuYyBiL2FyY2gveDg2XzY0L21t
L2s4dG9wb2xvZ3kuYwppbmRleCBhOTYwMDZmLi43Y2JkNThhIDEwMDY0NAotLS0gYS9hcmNoL3g4
Nl82NC9tbS9rOHRvcG9sb2d5LmMKKysrIGIvYXJjaC94ODZfNjQvbW0vazh0b3BvbG9neS5jCkBA
IC00NCwxMiArNDQsMTQgQEAgaW50IF9faW5pdCBrOF9zY2FuX25vZGVzKHVuc2lnbmVkIGxvbmcg
c3RhcnQsIHVuc2lnbmVkIGxvbmcgZW5kKQogeyAKIAl1bnNpZ25lZCBsb25nIHByZXZiYXNlOwog
CXN0cnVjdCBib290bm9kZSBub2Rlc1s4XTsKLQlpbnQgbm9kZWlkLCBpLCBqLCBuYjsKKwlpbnQg
bm9kZWlkLCBpLCBuYjsKIAl1bnNpZ25lZCBjaGFyIG5vZGVpZHNbOF07CiAJaW50IGZvdW5kID0g
MDsKIAl1MzIgcmVnOwogCXVuc2lnbmVkIG51bW5vZGVzOwotCXVuc2lnbmVkIG51bV9jb3JlczsK
Kwl1bnNpZ25lZCBjb3JlczsKKwl1bnNpZ25lZCBiaXRzOworCWludCBqOwogCiAJaWYgKCFlYXJs
eV9wY2lfYWxsb3dlZCgpKQogCQlyZXR1cm4gLTE7CkBAIC02MCw5ICs2Miw2IEBAIGludCBfX2lu
aXQgazhfc2Nhbl9ub2Rlcyh1bnNpZ25lZCBsb25nIHN0YXJ0LCB1bnNpZ25lZCBsb25nIGVuZCkK
IAogCXByaW50ayhLRVJOX0lORk8gIlNjYW5uaW5nIE5VTUEgdG9wb2xvZ3kgaW4gTm9ydGhicmlk
Z2UgJWRcbiIsIG5iKTsgCiAKLQludW1fY29yZXMgPSAoY3B1aWRfZWN4KDB4ODAwMDAwMDgpICYg
MHhmZikgKyAxOwotCXByaW50ayhLRVJOX0lORk8gIkNQVSBoYXMgJWQgbnVtX2NvcmVzXG4iLCBu
dW1fY29yZXMpOwotCiAJcmVnID0gcmVhZF9wY2lfY29uZmlnKDAsIG5iLCAwLCAweDYwKTsgCiAJ
bnVtbm9kZXMgPSAoKHJlZyA+PiA0KSAmIDB4RikgKyAxOwogCWlmIChudW1ub2RlcyA8PSAxKQpA
QCAtMTY4LDExICsxNjcsMTUgQEAgaW50IF9faW5pdCBrOF9zY2FuX25vZGVzKHVuc2lnbmVkIGxv
bmcgc3RhcnQsIHVuc2lnbmVkIGxvbmcgZW5kKQogCX0gCiAJcHJpbnRrKEtFUk5fSU5GTyAiVXNp
bmcgbm9kZSBoYXNoIHNoaWZ0IG9mICVkXG4iLCBtZW1ub2RlX3NoaWZ0KTsgCiAKKwkvKiB1c2Ug
dGhlIGNvcmVpZCBiaXRzIGZyb20gZWFybHlfaWRlbnRpZnlfY3B1ICovCisJYml0cyA9IGJvb3Rf
Y3B1X2RhdGEueDg2X2NvcmVpZF9iaXRzOworCWNvcmVzID0gKDE8PGJpdHMpOworCiAJZm9yIChp
ID0gMDsgaSA8IDg7IGkrKykgewogCQlpZiAobm9kZXNbaV0uc3RhcnQgIT0gbm9kZXNbaV0uZW5k
KSB7IAogCQkJbm9kZWlkID0gbm9kZWlkc1tpXTsKLQkJCWZvciAoaiA9IDA7IGogPCBudW1fY29y
ZXM7IGorKykKLQkJCQlhcGljaWRfdG9fbm9kZVsobm9kZWlkICogbnVtX2NvcmVzKSArIGpdID0g
aTsKKwkJCWZvciAoaiA9IDA7IGogPCBjb3JlczsgaisrKQorCQkJCWFwaWNpZF90b19ub2RlWyhu
b2RlaWQgPDwgYml0cykgKyBqXSA9IGk7CiAJCQlzZXR1cF9ub2RlX2Jvb3RtZW0oaSwgbm9kZXNb
aV0uc3RhcnQsIG5vZGVzW2ldLmVuZCk7IAogCQl9IAogCX0K
------=_Part_143113_7196464.1185080228424--
