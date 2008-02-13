Return-Path: <linux-kernel-owner+w=401wt.eu-S933738AbYBMVjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933738AbYBMVjf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763569AbYBMVa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:30:29 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:55696 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763527AbYBMVa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:30:26 -0500
Date: Wed, 13 Feb 2008 23:30:10 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Mart Raudsepp <mart.raudsepp@artecdesign.ee>,
       David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make mtd/nand/cs553x_nand.c:part_probes[] static
Message-ID: <20080213213010.GX3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global part_probes[] static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
054adb5b7a0d1ebaef61192ccf78df37aec42270 diff --git a/drivers/mtd/nand/cs553x_nand.c b/drivers/mtd/nand/cs553x_nand.c
index 8dab696..3370a80 100644
--- a/drivers/mtd/nand/cs553x_nand.c
+++ b/drivers/mtd/nand/cs553x_nand.c
@@ -279,7 +279,7 @@ static int is_geode(void)
 
 
 #ifdef CONFIG_MTD_PARTITIONS
-const char *part_probes[] = { "cmdlinepart", NULL };
+static const char *part_probes[] = { "cmdlinepart", NULL };
 #endif
 
 

