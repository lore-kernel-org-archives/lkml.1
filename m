Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbYCMSxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbYCMSxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 14:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbYCMSxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 14:53:34 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:27435 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494AbYCMSxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 14:53:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=Yl60awNZ5119N7vtuFIEjKFbLFaAdEmt89W81Mqr+O3ffnMA9DzgZ1bZdwPuJ7Eag/GVJ7WbG1Wi1JX2SW6f+t2aEljdRE8JHb/UdSrtHbf0U/Gj7vul4gySlH6xZYqHsKxMQkDeHwrRhHn7PNZEs1d8PTTluitDDhA1fWCO2Rw=
Message-ID: <86802c440803131153m325c9e04h43bfd25b667a5c04@mail.gmail.com>
Date: Thu, 13 Mar 2008 11:53:31 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: [PATCH] mm: make free_bootmem to loop bdata_list
Cc: mingo@elte.hu, clameter@sgi.com, linux-kernel@vger.kernel.org,
       "Andi Kleen" <ak@suse.de>, "Yasunori Goto" <y-goto@jp.fujitsu.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_12115_438549.1205434411198"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_12115_438549.1205434411198
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

[PATCH] mm: make free_bootmem to loop bdata_list

        [PATCH] mm: fix boundary checking in free_bootmem_core

make the free_bootmem_core could handle out of range case. we could use
bdata_list to make sure the range can be freed for sure.

so next time, we don't need to loop online nodes and could use
free_bootmem directly.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

------=_Part_12115_438549.1205434411198
Content-Type: text/x-patch; name=free_bootmem_loop_x.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fdrojpdt0
Content-Disposition: attachment; filename=free_bootmem_loop_x.patch

SW5kZXg6IGxpbnV4LTIuNi9tbS9ib290bWVtLmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9y
aWcvbW0vYm9vdG1lbS5jCisrKyBsaW51eC0yLjYvbW0vYm9vdG1lbS5jCkBAIC00MjcsNyArNDM4
LDkgQEAgaW50IF9faW5pdCByZXNlcnZlX2Jvb3RtZW0odW5zaWduZWQgbG9uZwogCiB2b2lkIF9f
aW5pdCBmcmVlX2Jvb3RtZW0odW5zaWduZWQgbG9uZyBhZGRyLCB1bnNpZ25lZCBsb25nIHNpemUp
CiB7Ci0JZnJlZV9ib290bWVtX2NvcmUoTk9ERV9EQVRBKDApLT5iZGF0YSwgYWRkciwgc2l6ZSk7
CisJYm9vdG1lbV9kYXRhX3QgKmJkYXRhOworCWxpc3RfZm9yX2VhY2hfZW50cnkoYmRhdGEsICZi
ZGF0YV9saXN0LCBsaXN0KQorCQlmcmVlX2Jvb3RtZW1fY29yZShiZGF0YSwgYWRkciwgc2l6ZSk7
CiB9CiAKIHVuc2lnbmVkIGxvbmcgX19pbml0IGZyZWVfYWxsX2Jvb3RtZW0odm9pZCkK
------=_Part_12115_438549.1205434411198--
