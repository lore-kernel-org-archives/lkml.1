Return-Path: <linux-kernel-owner+w=401wt.eu-S1753477AbXJZT0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbXJZT0I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 15:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760046AbXJZTZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 15:25:53 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:52771 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761327AbXJZTZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 15:25:52 -0400
Date: Fri, 26 Oct 2007 15:25:49 -0400
From: Jeff Dike <jdike@addtoit.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: [RFC PATCH 2/2] Add pagemap.h include to swap.h
Message-ID: <20071026192549.GA9219@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Include linux/pagemap.h in linux/swap.h and remove the comment saying
that it's not possible.

---
 include/linux/swap.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.17/include/linux/swap.h
===================================================================
--- linux-2.6.17.orig/include/linux/swap.h	2007-10-24 10:05:09.000000000 -0400
+++ linux-2.6.17/include/linux/swap.h	2007-10-25 22:59:29.000000000 -0400
@@ -6,6 +6,7 @@
 #include <linux/mmzone.h>
 #include <linux/list.h>
 #include <linux/sched.h>
+#include <linux/pagemap.h>
 
 #include <asm/atomic.h>
 #include <asm/page.h>
@@ -282,8 +283,7 @@ static inline void disable_swap_token(vo
 
 #define si_swapinfo(val) \
 	do { (val)->freeswap = (val)->totalswap = 0; } while (0)
-/* only sparc can not include linux/pagemap.h in this file
- * so leave page_cache_release and release_pages undeclared... */
+
 #define free_page_and_swap_cache(page) \
 	page_cache_release(page)
 #define free_pages_and_swap_cache(pages, nr) \
