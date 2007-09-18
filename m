Return-Path: <linux-kernel-owner+w=401wt.eu-S1760881AbXIRQ6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760881AbXIRQ6l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 12:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760776AbXIRQ61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 12:58:27 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:38049 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760750AbXIRQ60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 12:58:26 -0400
Message-ID: <e6c711510709180958j41265e87kd5126b7d5e832c0e@mail.gmail.com>
Date: Tue, 18 Sep 2007 09:58:25 -0700
From: "Ed Swierk" <eswierk@arastra.com>
To: netdev@vger.kernel.org
Subject: [PATCH] forcedeth: power down phy when interface is down
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_6479_21969355.1190134705313"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_6479_21969355.1190134705313
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Bring the physical link down when the interface is down, by placing
the PHY in power-down state. This mirrors the behavior of other
drivers including e1000 and tg3.

Signed-off-by: Ed Swierk <eswierk@arastra.com>

------=_Part_6479_21969355.1190134705313
Content-Type: application/octet-stream;
 name="forcedeth-phy-power-down.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="forcedeth-phy-power-down.patch"
X-Attachment-Id: f_f6qned3j

QnJpbmcgdGhlIHBoeXNpY2FsIGxpbmsgZG93biB3aGVuIHRoZSBpbnRlcmZhY2UgaXMgZG93biwg
YnkgcGxhY2luZyB0aGUgUEhZCmluIHBvd2VyLWRvd24gc3RhdGUuICBUaGlzIG1pcnJvcnMgdGhl
IGJlaGF2aW9yIG9mIG90aGVyIGRyaXZlcnMgaW5jbHVkaW5nCmUxMDAwIGFuZCB0ZzMuCgpTaWdu
ZWQtb2ZmLWJ5OiBFZCBTd2llcmsgPGVzd2llcmtAYXJhc3RyYS5jb20+CgpJbmRleDogbGludXgt
Mi42LjIyLjYvZHJpdmVycy9uZXQvZm9yY2VkZXRoLmMKPT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42
LjIyLjYub3JpZy9kcml2ZXJzL25ldC9mb3JjZWRldGguYworKysgbGludXgtMi42LjIyLjYvZHJp
dmVycy9uZXQvZm9yY2VkZXRoLmMKQEAgLTEzMDcsOSArMTMwNyw5IEBAIHN0YXRpYyBpbnQgcGh5
X2luaXQoc3RydWN0IG5ldF9kZXZpY2UgKmQKIAkvKiBzb21lIHBoeXMgY2xlYXIgb3V0IHBhdXNl
IGFkdmVydGlzbWVudCBvbiByZXNldCwgc2V0IGl0IGJhY2sgKi8KIAltaWlfcncoZGV2LCBucC0+
cGh5YWRkciwgTUlJX0FEVkVSVElTRSwgcmVnKTsKIAotCS8qIHJlc3RhcnQgYXV0byBuZWdvdGlh
dGlvbiAqLworCS8qIHJlc3RhcnQgYXV0byBuZWdvdGlhdGlvbiwgcG93ZXIgZG93biBwaHkgKi8K
IAltaWlfY29udHJvbCA9IG1paV9ydyhkZXYsIG5wLT5waHlhZGRyLCBNSUlfQk1DUiwgTUlJX1JF
QUQpOwotCW1paV9jb250cm9sIHw9IChCTUNSX0FOUkVTVEFSVCB8IEJNQ1JfQU5FTkFCTEUpOwor
CW1paV9jb250cm9sIHw9IChCTUNSX0FOUkVTVEFSVCB8IEJNQ1JfQU5FTkFCTEUgfCBCTUNSX1BE
T1dOKTsKIAlpZiAobWlpX3J3KGRldiwgbnAtPnBoeWFkZHIsIE1JSV9CTUNSLCBtaWlfY29udHJv
bCkpIHsKIAkJcmV0dXJuIFBIWV9FUlJPUjsKIAl9CkBAIC00NzkyLDYgKzQ3OTIsMTAgQEAgc3Rh
dGljIGludCBudl9vcGVuKHN0cnVjdCBuZXRfZGV2aWNlICpkZQogCiAJZHByaW50ayhLRVJOX0RF
QlVHICJudl9vcGVuOiBiZWdpblxuIik7CiAKKwkvKiBwb3dlciB1cCBwaHkgKi8KKwltaWlfcnco
ZGV2LCBucC0+cGh5YWRkciwgTUlJX0JNQ1IsCisJICAgICAgIG1paV9ydyhkZXYsIG5wLT5waHlh
ZGRyLCBNSUlfQk1DUiwgTUlJX1JFQUQpICYgfkJNQ1JfUERPV04pOworCiAJLyogZXJhc2UgcHJl
dmlvdXMgbWlzY29uZmlndXJhdGlvbiAqLwogCWlmIChucC0+ZHJpdmVyX2RhdGEgJiBERVZfSEFT
X1BPV0VSX0NOVFJMKQogCQludl9tYWNfcmVzZXQoZGV2KTsKQEAgLTQ5NzIsNiArNDk3NiwxMCBA
QCBzdGF0aWMgaW50IG52X2Nsb3NlKHN0cnVjdCBuZXRfZGV2aWNlICpkCiAJCW52X3N0YXJ0X3J4
KGRldik7CiAJfQogCisJLyogcG93ZXIgZG93biBwaHkgKi8KKwltaWlfcncoZGV2LCBucC0+cGh5
YWRkciwgTUlJX0JNQ1IsCisJICAgICAgIG1paV9ydyhkZXYsIG5wLT5waHlhZGRyLCBNSUlfQk1D
UiwgTUlJX1JFQUQpIHwgQk1DUl9QRE9XTik7CisKIAkvKiBGSVhNRTogcG93ZXIgZG93biBuaWMg
Ki8KIAogCXJldHVybiAwOwo=
------=_Part_6479_21969355.1190134705313--
