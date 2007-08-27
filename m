Return-Path: <linux-kernel-owner+w=401wt.eu-S933420AbXH0Vfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933420AbXH0Vfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765377AbXH0V2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:28:30 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:58840 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765372AbXH0V22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:28:28 -0400
Date: Mon, 27 Aug 2007 23:28:28 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] mm/: remove unused exports
Message-ID: <20070827212828.GZ4121@stusta.de>
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

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 14 Aug 2007
- 29 Jul 2007
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



