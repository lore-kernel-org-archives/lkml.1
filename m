Return-Path: <linux-kernel-owner+w=401wt.eu-S1756374AbYCMTNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374AbYCMTNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 15:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbYCMTNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 15:13:25 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:45463 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbYCMTNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 15:13:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=Ke46DueUyu25vPHGWleW2jhp+qmUHvtjLRaN2CiRDRHi9DZTNHc2NQGNMAf9KAgWVCoP9NsnAY4Vgb0hFThDhQxOrJPHzD6Dx2b5ga6NLXLNyo+PTicZ2+iV+u+c4giDvIDzcpDfPJ0W4hWj9eF9Hz5i0q0B6KXRyLfnfMOih5U=
Message-ID: <86802c440803131213i4e19002an859a3f3ffb109727@mail.gmail.com>
Date: Thu, 13 Mar 2008 12:13:23 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>
Subject: [PATCH] x86_64: free_bootmem should take phy
Cc: clameter@sgi.com, linux-kernel@vger.kernel.org, ak@suse.de,
       y-goto@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_12195_15248129.1205435603117"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_12195_15248129.1205435603117
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline



------=_Part_12195_15248129.1205435603117
Content-Type: text/x-patch; name=x86_numa_64_free_use_phys.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fdrp8mc00
Content-Disposition: attachment; filename=x86_numa_64_free_use_phys.patch

W1BBVENIXSB4ODZfNjQ6IGZyZWVfYm9vdG1lbSBzaG91bGQgdGFrZSBwaHlzCgpzbyB1c2Ugbm9k
ZWRhdGFfcGh5cyBkaXJlY3RseS4KClNpZ25lZC1vZmYtYnk6IFlpbmdoYWkgTHUgPHlobHUua2Vy
bmVsQGdtYWlsLmNvbT4KCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9tbS9udW1hXzY0LmMgYi9hcmNo
L3g4Ni9tbS9udW1hXzY0LmMKaW5kZXggMGM5YjJiZC4uMTgyNjdhMCAxMDA2NDQKLS0tIGEvYXJj
aC94ODYvbW0vbnVtYV82NC5jCisrKyBiL2FyY2gveDg2L21tL251bWFfNjQuYwpAQCAtMjIxLDgg
KzIyMSw3IEBAIHZvaWQgX19pbml0IHNldHVwX25vZGVfYm9vdG1lbShpbnQgbm9kZWlkLCB1bnNp
Z25lZCBsb25nIHN0YXJ0LAogCQkJCSBib290bWFwX3BhZ2VzPDxQQUdFX1NISUZULCBQQUdFX1NJ
WkUpOwogCWlmIChib290bWFwID09IE5VTEwpICB7CiAJCWlmIChub2RlZGF0YV9waHlzIDwgc3Rh
cnQgfHwgbm9kZWRhdGFfcGh5cyA+PSBlbmQpCi0JCQlmcmVlX2Jvb3RtZW0oKHVuc2lnbmVkIGxv
bmcpbm9kZV9kYXRhW25vZGVpZF0sCi0JCQkJICAgICBwZ2RhdF9zaXplKTsKKwkJCWZyZWVfYm9v
dG1lbShub2RlZGF0YV9waHlzLCBwZ2RhdF9zaXplKTsKIAkJbm9kZV9kYXRhW25vZGVpZF0gPSBO
VUxMOwogCQlyZXR1cm47CiAJfQo=
------=_Part_12195_15248129.1205435603117--
