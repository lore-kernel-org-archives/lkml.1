Return-Path: <linux-kernel-owner+w=401wt.eu-S1761212AbXKBRVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761212AbXKBRVy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 13:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755429AbXKBRVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 13:21:47 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:48708 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756616AbXKBRVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 13:21:46 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 02 Nov 2007 22:50:56 +0530
Message-Id: <20071102172056.14261.39829.sendpatchset@balbir-laptop>
Subject: [PATCH] Remove unused code from mm/tiny-shmem.c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



This code in mm/tiny-shmem.c is under #if 0, do we really need it? This
patch removes it.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 mm/tiny-shmem.c |   12 ------------
 1 file changed, 12 deletions(-)

diff -puN mm/tiny-shmem.c~remove-unused-code mm/tiny-shmem.c
--- linux-2.6-latest/mm/tiny-shmem.c~remove-unused-code	2007-11-02 22:43:12.000000000 +0530
+++ linux-2.6-latest-balbir/mm/tiny-shmem.c	2007-11-02 22:43:30.000000000 +0530
@@ -121,18 +121,6 @@ int shmem_unuse(swp_entry_t entry, struc
 	return 0;
 }
 
-#if 0
-int shmem_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	file_accessed(file);
-#ifndef CONFIG_MMU
-	return ramfs_nommu_mmap(file, vma);
-#else
-	return 0;
-#endif
-}
-#endif  /*  0  */
-
 #ifndef CONFIG_MMU
 unsigned long shmem_get_unmapped_area(struct file *file,
 				      unsigned long addr,
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
