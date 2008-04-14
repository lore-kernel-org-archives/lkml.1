Return-Path: <linux-kernel-owner+w=401wt.eu-S1761243AbYDNO0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761243AbYDNO0N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761012AbYDNOVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:21:46 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:41992 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761669AbYDNOVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:21:45 -0400
Date: Mon, 14 Apr 2008 17:20:40 +0300
From: Adrian Bunk <bunk@kernel.org>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] mtd: make struct rfd_ftl_tr static
Message-ID: <20080414142040.GW6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global struct rfd_ftl_tr static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
99d1a83588268cd6d7e5fd43e29fa470cdc8f525 diff --git a/drivers/mtd/rfd_ftl.c b/drivers/mtd/rfd_ftl.c
index 823fba4..c84e454 100644
--- a/drivers/mtd/rfd_ftl.c
+++ b/drivers/mtd/rfd_ftl.c
@@ -823,7 +823,7 @@ static void rfd_ftl_remove_dev(struct mtd_blktrans_dev *dev)
 	kfree(part);
 }
 
-struct mtd_blktrans_ops rfd_ftl_tr = {
+static struct mtd_blktrans_ops rfd_ftl_tr = {
 	.name		= "rfd",
 	.major		= RFD_FTL_MAJOR,
 	.part_bits	= PART_BITS,

