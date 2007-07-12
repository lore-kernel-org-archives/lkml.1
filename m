Return-Path: <linux-kernel-owner+w=401wt.eu-S932889AbXGLXza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932889AbXGLXza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 19:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbXGLXzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 19:55:18 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:59656 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752791AbXGLXzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 19:55:17 -0400
Date: Fri, 13 Jul 2007 01:55:51 +0200
From: Adrian Bunk <bunk@stusta.de>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] mm/: remove unused exports
Message-ID: <20070712235551.GT3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the following unused EXPORT_SYMBOL's:
- migrate.c: migrate_page
- mm/mmap.c: get_unmapped_area
- mm/mmap.c: get_unmapped_area

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

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
@@ -1232,8 +1232,6 @@
 	return get_area(file, addr, len, pgoff, flags);
 }
 
-EXPORT_SYMBOL(get_unmapped_area);
-
 /*
  * Check that a process has enough memory to allocate a new virtual
  * mapping. 0 means there is enough memory for the allocation to

