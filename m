Return-Path: <linux-kernel-owner+w=401wt.eu-S1753491AbYDNOZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbYDNOZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760985AbYDNOVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:21:36 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:41984 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761619AbYDNOVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:21:35 -0400
Date: Mon, 14 Apr 2008 17:20:30 +0300
From: Adrian Bunk <bunk@kernel.org>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] mtd/chips/cfi_cmdset_0020.c: make a function static
Message-ID: <20080414142030.GT6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global cfi_staa_erase_varsize() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
071e1e3116928c1625f475a0fba2f96ee897a95c diff --git a/drivers/mtd/chips/cfi_cmdset_0020.c b/drivers/mtd/chips/cfi_cmdset_0020.c
index 492e2ab..356939b 100644
--- a/drivers/mtd/chips/cfi_cmdset_0020.c
+++ b/drivers/mtd/chips/cfi_cmdset_0020.c
@@ -893,7 +893,8 @@ retry:
 	return ret;
 }
 
-int cfi_staa_erase_varsize(struct mtd_info *mtd, struct erase_info *instr)
+static int cfi_staa_erase_varsize(struct mtd_info *mtd,
+				  struct erase_info *instr)
 {	struct map_info *map = mtd->priv;
 	struct cfi_private *cfi = map->fldrv_priv;
 	unsigned long adr, len;

