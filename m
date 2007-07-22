Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbXGVAuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbXGVAuL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 20:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757568AbXGVAtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 20:49:39 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:18518 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131AbXGVAti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 20:49:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type;
        b=n4baIz5XrN9dFv8VyZkw7DJTun1n1ZgIPVoncYDUu9i0x01iwt5dSrZ7fS9Rc6OMFNBYbBgL+fW2cLsUtVav16bozGc3f7gzV3CSrTYtkgGK0GnW5b8UJFpc+qn8mO9P+NrqhxjYqoBDCt4X3bmZvAofA7+89wzDPFT4bTaPZ/o=
Message-ID: <86802c440707211749r1c41c73ay5d5573cfe4a1b13c@mail.gmail.com>
Date: Sat, 21 Jul 2007 17:49:33 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>
Subject: [PATCH 2/3] x86_64: use core id bits for apicid_to_node initialization
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_141652_11526440.1185065373324"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_141652_11526440.1185065373324
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

[PATCH 2/3] x86_64: use core id bits for apicid_to_node initialization

We shoud use core id bits instead of max cores, in case later with AMD
downcores Quad core Opteron.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

 k8topology.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

------=_Part_141652_11526440.1185065373324
Content-Type: text/x-patch; name=2.patch; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f4etsr50
Content-Disposition: attachment; filename="2.patch"

CmRpZmYgLS1naXQgYS9hcmNoL3g4Nl82NC9tbS9rOHRvcG9sb2d5LmMgYi9hcmNoL3g4Nl82NC9t
bS9rOHRvcG9sb2d5LmMKaW5kZXggZjk4M2M3NS4uZDEwOGY5NiAxMDA2NDQKLS0tIGEvYXJjaC94
ODZfNjQvbW0vazh0b3BvbG9neS5jCisrKyBiL2FyY2gveDg2XzY0L21tL2s4dG9wb2xvZ3kuYwpA
QCAtNDksNyArNDksOSBAQCBpbnQgX19pbml0IGs4X3NjYW5fbm9kZXModW5zaWduZWQgbG9uZyBz
dGFydCwgdW5zaWduZWQgbG9uZyBlbmQpCiAJaW50IGZvdW5kID0gMDsKIAl1MzIgcmVnOwogCXVu
c2lnbmVkIG51bW5vZGVzOwotCXVuc2lnbmVkIGR1YWxjb3JlID0gMDsKKwl1bnNpZ25lZCBjb3Jl
czsKKwl1bnNpZ25lZCBiaXRzOworCWludCBqOwogCiAJaWYgKCFlYXJseV9wY2lfYWxsb3dlZCgp
KQogCQlyZXR1cm4gLTE7CkBAIC03Myw4ICs3NSw2IEBAIGludCBfX2luaXQgazhfc2Nhbl9ub2Rl
cyh1bnNpZ25lZCBsb25nIHN0YXJ0LCB1bnNpZ25lZCBsb25nIGVuZCkKIAkJdW5zaWduZWQgbG9u
ZyBiYXNlLGxpbWl0OyAKIAkJdTMyIG5vZGVpZDsKIAkJCi0JCS8qIFVuZGVmaW5lZCBiZWZvcmUg
RSBzdGVwcGluZywgYnV0IGhvcGVmdWxseSAwICovCi0JCWR1YWxjb3JlIHw9ICgocmVhZF9wY2lf
Y29uZmlnKDAsIG5iLCAzLCAweGU4KSA+PiAxMikgJiAzKSA9PSAxOwogCQliYXNlID0gcmVhZF9w
Y2lfY29uZmlnKDAsIG5iLCAxLCAweDQwICsgaSo4KTsKIAkJbGltaXQgPSByZWFkX3BjaV9jb25m
aWcoMCwgbmIsIDEsIDB4NDQgKyBpKjgpOwogCkBAIC0xNjcsMTEgKzE2NywxNSBAQCBpbnQgX19p
bml0IGs4X3NjYW5fbm9kZXModW5zaWduZWQgbG9uZyBzdGFydCwgdW5zaWduZWQgbG9uZyBlbmQp
CiAJfSAKIAlwcmludGsoS0VSTl9JTkZPICJVc2luZyBub2RlIGhhc2ggc2hpZnQgb2YgJWRcbiIs
IG1lbW5vZGVfc2hpZnQpOyAKIAorCS8qIHVzZSB0aGUgY29yZWlkIGJpdHMgZnJvbSBlYXJseV9p
ZGVudGlmeV9jcHUgKi8KKyAgICAgICAgYml0cyA9IGJvb3RfY3B1X2RhdGEueDg2X2NvcmVpZF9i
aXRzOworCWNvcmVzID0gKDE8PGJpdHMpOworCiAJZm9yIChpID0gMDsgaSA8IDg7IGkrKykgewog
CQlpZiAobm9kZXNbaV0uc3RhcnQgIT0gbm9kZXNbaV0uZW5kKSB7IAogCQkJbm9kZWlkID0gbm9k
ZWlkc1tpXTsKLQkJCWFwaWNpZF90b19ub2RlW25vZGVpZCA8PCBkdWFsY29yZV0gPSBpOwotCQkJ
YXBpY2lkX3RvX25vZGVbKG5vZGVpZCA8PCBkdWFsY29yZSkgKyBkdWFsY29yZV0gPSBpOworCQkJ
Zm9yIChqID0gMDsgaiA8IGNvcmVzOyBqKyspCisJCQkJYXBpY2lkX3RvX25vZGVbKG5vZGVpZCA8
PCBiaXRzKSArIGpdID0gaTsKIAkJCXNldHVwX25vZGVfYm9vdG1lbShpLCBub2Rlc1tpXS5zdGFy
dCwgbm9kZXNbaV0uZW5kKTsgCiAJCX0gCiAJfQo=
------=_Part_141652_11526440.1185065373324--
