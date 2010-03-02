Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab0CBQXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 11:23:43 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:42157 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753297Ab0CBQXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 11:23:42 -0500
Message-ID: <1267547013.4b8d3b8596461@imp.free.fr>
Date: Tue, 02 Mar 2010 17:23:33 +0100
From: castet.matthieu@free.fr
To: Siarhei Liakh <sliakh.lkml@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [tip:x86/mm] x86, mm: NX protection for kernel data
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-MOQ12675470136bbbeeac0829a81a9899786cbaa306e8"
User-Agent: Internet Messaging Program (IMP) 3.2.8
X-Originating-IP: 93.1.149.109
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message is in MIME format.

---MOQ12675470136bbbeeac0829a81a9899786cbaa306e8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit



> At this point I need some help and guidance on how to track down what
> exactly happens there, as I am not very familiar with what goes into
> .data and why are we trying to execute it.
Can't you add debug printk in the fault handler before any exception processing

Something like that.

Matthieu


---MOQ12675470136bbbeeac0829a81a9899786cbaa306e8
Content-Type: text/x-diff; name="test.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="test.diff"

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L21tL2ZhdWx0LmMgYi9hcmNoL3g4Ni9tbS9mYXVsdC5jCmlu
ZGV4IGY2Mjc3NzkuLjU3OGJhNTIgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L21tL2ZhdWx0LmMKKysr
IGIvYXJjaC94ODYvbW0vZmF1bHQuYwpAQCAtNjI5LDYgKzYyOSw4IEBAIG5vX2NvbnRleHQoc3Ry
dWN0IHB0X3JlZ3MgKnJlZ3MsIHVuc2lnbmVkIGxvbmcgZXJyb3JfY29kZSwKIAl1bnNpZ25lZCBs
b25nIGZsYWdzOwogCWludCBzaWc7CiAKKwlpZiAoZXJyb3JfY29kZSAmIFBGX0lOU1RSKQorCQlw
cmludGsoImV4ZWMgb24gTlhcbiIpOwogCS8qIEFyZSB3ZSBwcmVwYXJlZCB0byBoYW5kbGUgdGhp
cyBrZXJuZWwgZmF1bHQ/ICovCiAJaWYgKGZpeHVwX2V4Y2VwdGlvbihyZWdzKSkKIAkJcmV0dXJu
Owo=

---MOQ12675470136bbbeeac0829a81a9899786cbaa306e8--
