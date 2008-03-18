Return-Path: <linux-kernel-owner+w=401wt.eu-S938078AbYCSVm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938078AbYCSVm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758272AbYCSULH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:11:07 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:9978 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764347AbYCSULG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:11:06 -0400
Message-ID: <86802c440803181102i5175c12cw7c41b3f68de38f04@mail.gmail.com>
Date: Tue, 18 Mar 2008 11:02:39 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Glauber Costa" <glommer@gmail.com>
Subject: [PATCH] x86: change pci_direct_conf1 back not static
Cc: "Linux Kernel ML" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_21487_29874923.1205863359865"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_21487_29874923.1205863359865
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline



------=_Part_21487_29874923.1205863359865
Content-Type: text/x-patch; name=pci_direct_conf1.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fdyrybl80
Content-Disposition: attachment; filename=pci_direct_conf1.patch

W1BBVENIXSB4ODY6IGNoYW5nZSBwY2lfZGlyZWN0X2NvbmYxIGJhY2sgbm90IHN0YXRpYwoKR2xh
dWJlciBDb3N0YSA8Z2xvbW1lckBnbWFpbC5jb20+IHBvaW50ZWQgb3V0CgogICAgY29tbWl0IDUx
M2Y0ODRkZmU1Y2JiNTNlNzNlZjE3Mjk3MDNlNzAzMGU3OTk0ODcKCiAgICB4ODYgcGNpOiByZW1v
dmUgY2hlY2tpbmcgdHlwZSBmb3IgbW1jb25maWcgcHJvYmUgdjIKCmJyb2tlIHRoZSBWSVNXLgoK
cmVtb3ZlIHRoZSBzdGF0aWMgaW4gZGVjbGFyYXRpb24uCgpTaWduZWQtb2ZmLWJ5OiBZaW5naGFp
IEx1IDx5aGx1Lmtlcm5lbEBnbWFpbC5jb20+CgpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvcGNpL2Rp
cmVjdC5jIGIvYXJjaC94ODYvcGNpL2RpcmVjdC5jCmluZGV4IDczOWNlMjYuLjIxZDFlMGUgMTAw
NjQ0Ci0tLSBhL2FyY2gveDg2L3BjaS9kaXJlY3QuYworKysgYi9hcmNoL3g4Ni9wY2kvZGlyZWN0
LmMKQEAgLTc2LDcgKzc2LDcgQEAgc3RhdGljIGludCBwY2lfY29uZjFfd3JpdGUodW5zaWduZWQg
aW50IHNlZywgdW5zaWduZWQgaW50IGJ1cywKIAogI3VuZGVmIFBDSV9DT05GMV9BRERSRVNTCiAK
LXN0YXRpYyBzdHJ1Y3QgcGNpX3Jhd19vcHMgcGNpX2RpcmVjdF9jb25mMSA9IHsKK3N0cnVjdCBw
Y2lfcmF3X29wcyBwY2lfZGlyZWN0X2NvbmYxID0gewogCS5yZWFkID0JCXBjaV9jb25mMV9yZWFk
LAogCS53cml0ZSA9CXBjaV9jb25mMV93cml0ZSwKIH07CmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9w
Y2kvcGNpLmggYi9hcmNoL3g4Ni9wY2kvcGNpLmgKaW5kZXggZDM0NTY2MS4uYzlmYjYzNyAxMDA2
NDQKLS0tIGEvYXJjaC94ODYvcGNpL3BjaS5oCisrKyBiL2FyY2gveDg2L3BjaS9wY2kuaApAQCAt
OTUsNiArOTUsOCBAQCBzdHJ1Y3QgcGNpX3Jhd19vcHMgewogZXh0ZXJuIHN0cnVjdCBwY2lfcmF3
X29wcyAqcmF3X3BjaV9vcHM7CiBleHRlcm4gc3RydWN0IHBjaV9yYXdfb3BzICpyYXdfcGNpX2V4
dF9vcHM7CiAKK2V4dGVybiBzdHJ1Y3QgcGNpX3Jhd19vcHMgcGNpX2RpcmVjdF9jb25mMTsKKwog
ZXh0ZXJuIGludCBwY2lfZGlyZWN0X3Byb2JlKHZvaWQpOwogZXh0ZXJuIHZvaWQgcGNpX2RpcmVj
dF9pbml0KGludCB0eXBlKTsKIGV4dGVybiB2b2lkIHBjaV9wY2Jpb3NfaW5pdCh2b2lkKTsK
------=_Part_21487_29874923.1205863359865--
