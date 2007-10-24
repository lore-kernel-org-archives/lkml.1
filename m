Return-Path: <linux-kernel-owner+w=401wt.eu-S1763982AbXJXQnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763982AbXJXQnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759455AbXJXQZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:25:54 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:60969 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760018AbXJXQZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:25:39 -0400
Date: Wed, 24 Oct 2007 18:26:07 +0200
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] mm/: remove unused exports
Message-ID: <20071024162607.GF30533@stusta.de>
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
- 27 Aug 2007
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



