Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbXLDVbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbXLDVbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbXLDVbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:31:01 -0500
Received: from cantor.suse.de ([195.135.220.2]:49266 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922AbXLDVbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:31:00 -0500
Date: Tue, 4 Dec 2007 15:30:14 +0100
From: Andi Kleen <ak@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Remove unused arguments in zone_init_free_lists()
Message-ID: <20071204143014.GH11764@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As subject says.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/mm/page_alloc.c
===================================================================
--- linux.orig/mm/page_alloc.c
+++ linux-hack/mm/page_alloc.c
@@ -2561,8 +2561,7 @@ void __meminit memmap_init_zone(unsigned
 	}
 }
 
-static void __meminit zone_init_free_lists(struct pglist_data *pgdat,
-				struct zone *zone, unsigned long size)
+static void __meminit zone_init_free_lists(struct zone *zone)
 {
 	int order, t;
 	for_each_migratetype_order(order, t) {
@@ -2841,7 +2840,7 @@ __meminit int init_currently_empty_zone(
 
 	memmap_init(size, pgdat->node_id, zone_idx(zone), zone_start_pfn);
 
-	zone_init_free_lists(pgdat, zone, zone->spanned_pages);
+	zone_init_free_lists(zone);
 
 	return 0;
 }
