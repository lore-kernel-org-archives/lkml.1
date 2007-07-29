Return-Path: <linux-kernel-owner+w=401wt.eu-S934303AbXG2PTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934303AbXG2PTp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765205AbXG2PDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 11:03:39 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47945 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765022AbXG2PDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 11:03:15 -0400
Date: Sun, 29 Jul 2007 17:02:51 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] arch/i386/mm/discontig.c: make some variables static
Message-ID: <20070729150250.GB16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes some needlessly global variables static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

This patch has been sent on:
- 6 Jul 2007

 arch/i386/mm/discontig.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- linux-2.6.22-rc6-mm1/arch/i386/mm/discontig.c.old	2007-07-05 15:59:32.000000000 +0200
+++ linux-2.6.22-rc6-mm1/arch/i386/mm/discontig.c	2007-07-05 16:02:47.000000000 +0200
@@ -103,14 +103,14 @@
 
 #define LARGE_PAGE_BYTES (PTRS_PER_PTE * PAGE_SIZE)
 
-unsigned long node_remap_start_pfn[MAX_NUMNODES];
+static unsigned long node_remap_start_pfn[MAX_NUMNODES];
 unsigned long node_remap_size[MAX_NUMNODES];
-unsigned long node_remap_offset[MAX_NUMNODES];
-void *node_remap_start_vaddr[MAX_NUMNODES];
+static unsigned long node_remap_offset[MAX_NUMNODES];
+static void *node_remap_start_vaddr[MAX_NUMNODES];
 void set_pmd_pfn(unsigned long vaddr, unsigned long pfn, pgprot_t flags);
 
-void *node_remap_end_vaddr[MAX_NUMNODES];
-void *node_remap_alloc_vaddr[MAX_NUMNODES];
+static void *node_remap_end_vaddr[MAX_NUMNODES];
+static void *node_remap_alloc_vaddr[MAX_NUMNODES];
 static unsigned long kva_start_pfn;
 static unsigned long kva_pages;
 /*

