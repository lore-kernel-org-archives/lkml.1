Return-Path: <linux-kernel-owner+w=401wt.eu-S934219AbYBMVmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934219AbYBMVmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:42:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760394AbYBMVaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:30:46 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:50820 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761006AbYBMVan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:30:43 -0500
Date: Wed, 13 Feb 2008 23:30:27 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Matt Mackall <mpm@selenic.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make swap_pte_to_pagemap_entry() static
Message-ID: <20080213213027.GE3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global swap_pte_to_pagemap_entry() 
static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
a4b8dad3d2a846220277c79db64230b9e81bf99f diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index ae4d3f2..6afde39 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -571,7 +571,7 @@ static int pagemap_pte_hole(unsigned long start, unsigned long end,
 	return err;
 }
 
-u64 swap_pte_to_pagemap_entry(pte_t pte)
+static u64 swap_pte_to_pagemap_entry(pte_t pte)
 {
 	swp_entry_t e = pte_to_swp_entry(pte);
 	return PM_SWAP | swp_type(e) | (swp_offset(e) << MAX_SWAPFILES_SHIFT);

