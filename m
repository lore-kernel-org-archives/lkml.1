Return-Path: <linux-kernel-owner+w=401wt.eu-S1765511AbXG2PWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765511AbXG2PWu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765684AbXG2PD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 11:03:58 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47964 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765361AbXG2PD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 11:03:57 -0400
Date: Sun, 29 Jul 2007 17:03:34 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] mm/: remove unused exports
Message-ID: <20070729150334.GH16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the following unused EXPORT_SYMBOL's:
- migrate.c: migrate_page
- mmap.c: get_unmapped_area
- nommu.c: get_unmapped_area

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

This patch has been sent on:
- 13 Jul 2007

 mm/migrate.c |    1 -
 mm/mmap.c    |    2 --
 mm/nommu.c   |    2 --
 3 files changed, 5 deletions(-)

--- linux-2.6.22-rc6-mm1/mm/migrate.c.old	2007-07-12 03:15:05.000000000 +0200
+++ linux-2.6.22-rc6-mm1/mm/migrate.c	2007-07-12 03:15:15.000000000 +0200
@@ -426,7 +426,6 @@
 	migrate_page_copy(newpage, page);
 	return 0;
 }
-EXPORT_SYMBOL(migrate_page);
 
 #ifdef CONFIG_BLOCK
 /*
--- linux-2.6.22-rc6-mm1/mm/mmap.c.old	2007-07-12 03:20:19.000000000 +0200
+++ linux-2.6.22-rc6-mm1/mm/mmap.c	2007-07-12 03:20:33.000000000 +0200
@@ -1408,8 +1408,6 @@
 	return addr;
 }
 
-EXPORT_SYMBOL(get_unmapped_area);
-
 /* Look up the first VMA which satisfies  addr < vm_end,  NULL if none. */
 struct vm_area_struct * find_vma(struct mm_struct * mm, unsigned long addr)
 {
--- linux-2.6.22-rc6-mm1/mm/nommu.c.old	2007-07-12 03:20:41.000000000 +0200
+++ linux-2.6.22-rc6-mm1/mm/nommu.c	2007-07-12 03:20:57.000000000 +0200
@@ -1232,3 +1232,2 @@
 }
-EXPORT_SYMBOL(get_unmapped_area);



