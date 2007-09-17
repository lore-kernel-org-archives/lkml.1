Return-Path: <linux-kernel-owner+w=401wt.eu-S1757244AbXIQUWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244AbXIQUWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 16:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755886AbXIQUWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 16:22:10 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:56810 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582AbXIQUWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 16:22:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type;
        b=OTS6TOinMfrnkQpYMrxMwuqDI/Z0lpD1esZ1NW87Zx5CTZ11samCn8MUUqljyo1WJROA/VoxYDE3SOoE69dDnQocsBrTCLQtTIRnOP0mvxGlEsCMLT5fDzqOx2OKY+aA96/ug7mZVi+ZGKC98xeOT9tnhMKgHUSsnz04d2w3ZgE=
Message-ID: <43e72e890709171322x76ab6b70xd29bf97e3643c553@mail.gmail.com>
Date: Mon, 17 Sep 2007 16:22:07 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: [PATCH] Clarify pci_iomap() usage for MMIO-only devices
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_15876_26305641.1190060527274"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_15876_26305641.1190060527274
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This patch updates the pci_iomap() kernel-doc to make it clarify the
case when read*()/write*() can be called over ioread*/iowrite*(). When
driver writers read this documenation sometimes it is assumed you just
*need* to use ioread*()/iorwrite*(). We have an exception so lets just
clarify this is not true for the exception.

 lib/iomap.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>

  Luis

------=_Part_15876_26305641.1190060527274
Content-Type: text/x-patch; name="pci_iomap-doc-clarification.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="pci_iomap-doc-clarification.diff"
X-Attachment-Id: f_f6pfahct

ZGlmZiAtLWdpdCBhL2xpYi9pb21hcC5jIGIvbGliL2lvbWFwLmMKaW5kZXggODY0ZjJlYy4uMzM2
NTFmOCAxMDA2NDQKLS0tIGEvbGliL2lvbWFwLmMKKysrIGIvbGliL2lvbWFwLmMKQEAgLTI0Nyw5
ICsyNDcsMTQgQEAgRVhQT1JUX1NZTUJPTChpb3BvcnRfdW5tYXApOwogICogQG1heGxlbjogbGVu
Z3RoIG9mIHRoZSBtZW1vcnkgdG8gbWFwCiAgKgogICogVXNpbmcgdGhpcyBmdW5jdGlvbiB5b3Ug
d2lsbCBnZXQgYSBfX2lvbWVtIGFkZHJlc3MgdG8geW91ciBkZXZpY2UgQkFSLgotICogWW91IGNh
biBhY2Nlc3MgaXQgdXNpbmcgaW9yZWFkKigpIGFuZCBpb3dyaXRlKigpLiBUaGVzZSBmdW5jdGlv
bnMgaGlkZQotICogdGhlIGRldGFpbHMgaWYgdGhpcyBpcyBhIE1NSU8gb3IgUElPIGFkZHJlc3Mg
c3BhY2UgYW5kIHdpbGwganVzdCBkbyB3aGF0Ci0gKiB5b3UgZXhwZWN0IGZyb20gdGhlbSBpbiB0
aGUgY29ycmVjdCB3YXkuCisgKiBJZiB5b3UgdXNlIHBjaV9pb21hcCgpIGl0IGlzIHJlY29tbWVu
ZGVkIHlvdSB1c2UgaW9yZWFkKigpIGFuZCBpb3dyaXRlKigpLiBJZgorICogeW91ciBkZXZpY2Ug
aXMgTU1JTy1vbmx5IGFuZCBhcyBsb25nIGFzIGZ1dHVyZSBhcmNoaXRlY3R1cmVzIGRvbid0IGJy
ZWFrIHRoZQorICogYXNzdW1wdGlvbiB0aGF0IHBjaW9faW9tYXAoKS1yZXR1cm5lZCBjb29raWUg
Y2FuIGJlIHVzZWQgYnkgcmVhZCooKS93cml0ZSooKQorICogdGhlbiB5b3UgY2FuIHVzZSByZWFk
KigpL3dyaXRlKigpIGluc3RlYWQuIFRoZSBpb3JlYWQqKCkgYW5kIGlvd3JpdGUqKCkgCisgKiBm
dW5jdGlvbnMgaGlkZSB0aGUgZGV0YWlscyBpZiB0aGlzIGlzIGEgTU1JTyBvciBQSU8gYWRkcmVz
cyBzcGFjZSBhbmQgd2lsbAorICoganVzdCBkbyB3aGF0IHlvdSBleHBlY3QgZnJvbSB0aGVtIGlu
IHRoZSBjb3JyZWN0IHdheS4gRHJpdmVycyBmb3IgTU1JTy1vbmx5IAorICogZGV2aWNlcyB3b3Vs
ZCB1c2UgdGhpcyBvbmx5IHRvIHNhdmUgdGhlbXNlbHZlcyBmcm9tIGhhdmluZyB0byBjYWxsIAor
ICogJnBjaV9yZXNvdXJjZV9zdGFydCgpLgogICoKICAqIEBtYXhsZW4gc3BlY2lmaWVzIHRoZSBt
YXhpbXVtIGxlbmd0aCB0byBtYXAuIElmIHlvdSB3YW50IHRvIGdldCBhY2Nlc3MgdG8KICAqIHRo
ZSBjb21wbGV0ZSBCQVIgd2l0aG91dCBjaGVja2luZyBmb3IgaXRzIGxlbmd0aCBmaXJzdCwgcGFz
cyAlMCBoZXJlLgo=
------=_Part_15876_26305641.1190060527274--
