Return-Path: <linux-kernel-owner+w=401wt.eu-S1030814AbXCNJYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030814AbXCNJYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:24:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030790AbXCNJSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:18:53 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60487 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030764AbXCNJSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:18:50 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 6/17] sparc: nr_free_pages() is unsigned long
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org
Message-Id: <E1HRPdC-0003S1-0h@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 14 Mar 2007 09:18:50 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/sparc/mm/init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/sparc/mm/init.c b/arch/sparc/mm/init.c
index c85ddf3..a532922 100644
--- a/arch/sparc/mm/init.c
+++ b/arch/sparc/mm/init.c
@@ -75,7 +75,7 @@ void show_mem(void)
 	printk("Free swap:       %6ldkB\n",
 	       nr_swap_pages << (PAGE_SHIFT-10));
 	printk("%ld pages of RAM\n", totalram_pages);
-	printk("%d free pages\n", nr_free_pages());
+	printk("%ld free pages\n", nr_free_pages());
 #if 0 /* undefined pgtable_cache_size, pgd_cache_size */
 	printk("%ld pages in page table cache\n",pgtable_cache_size);
 #ifndef CONFIG_SMP
-- 
1.5.0-rc2.GIT


