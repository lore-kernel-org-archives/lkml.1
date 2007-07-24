Return-Path: <linux-kernel-owner+w=401wt.eu-S1760515AbXGXPyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760515AbXGXPyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 11:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbXGXPyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 11:54:39 -0400
Received: from gw.goop.org ([64.81.55.164]:57452 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856AbXGXPyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 11:54:38 -0400
Message-ID: <46A6208B.6070505@goop.org>
Date: Tue, 24 Jul 2007 08:53:47 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen: xen/page.h compile fix
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix:
linux/include/xen/page.h: In function mfn_pte:
linux/include/xen/page.h:149: error: __supported_pte_mask undeclared (first use in this function)
linux/include/xen/page.h:149: error: (Each undeclared identifier is reported only once
linux/include/xen/page.h:149: error: for each function it appears in.)

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 include/xen/page.h |    1 +
 1 file changed, 1 insertion(+)

===================================================================
--- a/include/xen/page.h
+++ b/include/xen/page.h
@@ -4,6 +4,7 @@
 #include <linux/pfn.h>
 
 #include <asm/uaccess.h>
+#include <asm/pgtable.h>
 
 #include <xen/features.h>
 


