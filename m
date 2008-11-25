Return-Path: <linux-kernel-owner+w=401wt.eu-S1755008AbYKYAz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008AbYKYAz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 19:55:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754211AbYKYAzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 19:55:17 -0500
Received: from smtp.movial.fi ([62.236.91.34]:57314 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754048AbYKYAzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 19:55:14 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Subject: [PATCH 03/20] [MTD] Make init_flagadm function static
Date: Tue, 25 Nov 2008 02:54:54 +0200
Message-Id: <1227574511-23879-4-git-send-email-dmitri.vorobiev@movial.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
References: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The module init function init_flagadm does not need to be global,
so add the needed keyword to drivers/mtd/maps/cfi_flagadm.c.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
---
 drivers/mtd/maps/cfi_flagadm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/maps/cfi_flagadm.c b/drivers/mtd/maps/cfi_flagadm.c
index 0ecc3f6..b4ed816 100644
--- a/drivers/mtd/maps/cfi_flagadm.c
+++ b/drivers/mtd/maps/cfi_flagadm.c
@@ -88,7 +88,7 @@ struct mtd_partition flagadm_parts[] = {
 
 static struct mtd_info *mymtd;
 
-int __init init_flagadm(void)
+static int __init init_flagadm(void)
 {
 	printk(KERN_NOTICE "FlagaDM flash device: %x at %x\n",
 			FLASH_SIZE, FLASH_PHYS_ADDR);
-- 
1.5.3

