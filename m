Return-Path: <linux-kernel-owner+w=401wt.eu-S1756840AbZGPNnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbZGPNnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 09:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756609AbZGPNnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 09:43:06 -0400
Received: from mga14.intel.com ([143.182.124.37]:51599 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756590AbZGPNnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 09:43:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,411,1243839600"; 
   d="scan'208";a="165709650"
Date: Thu, 16 Jul 2009 21:42:57 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Trivial Patch Monkey <trivial@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH] power: trivial comment fixes
Message-ID: <20090716134257.GA22163@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 kernel/power/snapshot.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux.orig/kernel/power/snapshot.c
+++ linux/kernel/power/snapshot.c
@@ -233,7 +233,7 @@ static void *chain_alloc(struct chain_al
 
 #define BM_END_OF_MAP	(~0UL)
 
-#define BM_BITS_PER_BLOCK	(PAGE_SIZE << 3)
+#define BM_BITS_PER_BLOCK	(PAGE_SIZE * BITS_PER_BYTE)
 
 struct bm_block {
 	struct list_head hook;	/* hook into a list of bitmap blocks */
@@ -275,7 +275,7 @@ static void memory_bm_free(struct memory
 
 /**
  *	create_bm_block_list - create a list of block bitmap objects
- *	@nr_blocks - number of blocks to allocate
+ *	@pages - number of pages to track
  *	@list - list to put the allocated blocks into
  *	@ca - chain allocator to be used for allocating memory
  */
