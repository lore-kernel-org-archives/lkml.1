Return-Path: <linux-kernel-owner+w=401wt.eu-S1763285AbXGUS76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763285AbXGUS76 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 14:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762510AbXGUS7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 14:59:23 -0400
Received: from dev.gentooexperimental.org ([81.93.240.53]:43801 "EHLO
	dev.gentooexperimental.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762393AbXGUS7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 14:59:22 -0400
From: Charlie Shepherd <masterdriverz@gentoo.org>
To: linux-kernel@vger.kernel.org, trivial@kernel.org,
       torvalds@linux-foundation.org
Cc: Charlie Shepherd <masterdriverz@gentoo.org>
Subject: [PATCH] Remove unused variable 'start'.
Date: Sat, 21 Jul 2007 20:26:47 +0200
Message-Id: <11850424083434-git-send-email-masterdriverz@gentoo.org>
X-Mailer: git-send-email 1.5.2.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Charlie Shepherd <masterdriverz@gentoo.org>
---
 mm/vmalloc.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 3cee76a..5e7daea 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -72,7 +72,6 @@ void unmap_kernel_range(unsigned long addr, unsigned long size)
 {
 	pgd_t *pgd;
 	unsigned long next;
-	unsigned long start = addr;
 	unsigned long end = addr + size;
 
 	BUG_ON(addr >= end);
@@ -84,7 +83,7 @@ void unmap_kernel_range(unsigned long addr, unsigned long size)
 			continue;
 		vunmap_pud_range(pgd, addr, next);
 	} while (pgd++, addr = next, addr != end);
-	flush_tlb_kernel_range(start, end);
+	flush_tlb_kernel_range(addr, end);
 }
 
 static void unmap_vm_area(struct vm_struct *area)
-- 
1.5.2.2

