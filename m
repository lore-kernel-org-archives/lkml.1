Return-Path: <linux-kernel-owner+w=401wt.eu-S1765102AbXIUU4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765102AbXIUU4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763450AbXIUUpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:45:30 -0400
Received: from ns2.suse.de ([195.135.220.15]:33028 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761674AbXIUUpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:45:19 -0400
From: Andi Kleen <ak@suse.de>
References: <200709211044.901175000@suse.de>
In-Reply-To: <200709211044.901175000@suse.de>
To: bunk@stusta.de, ak@suse.de, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [35/45] i386: make some variables static
Message-Id: <20070921204518.15BC914EFF@wotan.suse.de>
Date: Fri, 21 Sep 2007 22:45:18 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Adrian Bunk <bunk@stusta.de>

This patch makes some needlessly global variables static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/mm/discontig.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux/arch/i386/mm/discontig.c
===================================================================
--- linux.orig/arch/i386/mm/discontig.c
+++ linux/arch/i386/mm/discontig.c
@@ -103,14 +103,14 @@ extern unsigned long highend_pfn, highst
 
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
