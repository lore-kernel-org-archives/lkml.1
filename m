Return-Path: <linux-kernel-owner+w=401wt.eu-S1763435AbXGEXZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763435AbXGEXZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 19:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762854AbXGEXWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 19:22:54 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:52145 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762346AbXGEXWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 19:22:53 -0400
Date: Fri, 6 Jul 2007 01:23:22 +0200
From: Adrian Bunk <bunk@stusta.de>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] arch/i386/mm/discontig.c: make some variables static
Message-ID: <20070705232322.GC3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes some needlessly global variables static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

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

