Return-Path: <linux-kernel-owner+w=401wt.eu-S1765233AbXG2PEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765233AbXG2PEx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764365AbXG2O60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 10:58:26 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47810 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763930AbXG2O6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 10:58:25 -0400
Date: Sun, 29 Jul 2007 16:58:02 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] mm/page_alloc.c: make code static
Message-ID: <20070729145802.GT16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes needlessly global code static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.23-rc1-mm1/mm/page_alloc.c.old	2007-07-26 15:09:24.000000000 +0200
+++ linux-2.6.23-rc1-mm1/mm/page_alloc.c	2007-07-26 15:11:16.000000000 +0200
@@ -142,7 +142,7 @@
   static unsigned long __meminitdata node_boundary_end_pfn[MAX_NUMNODES];
 #endif /* CONFIG_MEMORY_HOTPLUG_RESERVE */
   unsigned long __initdata required_kernelcore;
-  unsigned long __initdata required_movablecore;
+  static unsigned long __initdata required_movablecore;
   unsigned long __meminitdata zone_movable_pfn[MAX_NUMNODES];
 
   /* movable_zone is the "real" zone pages in ZONE_MOVABLE are taken from */
@@ -3686,7 +3686,7 @@
 	return max_pfn;
 }
 
-unsigned long __init early_calculate_totalpages(void)
+static unsigned long __init early_calculate_totalpages(void)
 {
 	int i;
 	unsigned long totalpages = 0;

