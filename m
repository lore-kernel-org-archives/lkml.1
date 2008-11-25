Return-Path: <linux-kernel-owner+w=401wt.eu-S1754306AbYKYAzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbYKYAzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 19:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbYKYAzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 19:55:16 -0500
Received: from smtp.movial.fi ([62.236.91.34]:57328 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059AbYKYAzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 19:55:14 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Subject: [PATCH 04/20] [MTD] Make init_dbox2_flash static
Date: Tue, 25 Nov 2008 02:54:55 +0200
Message-Id: <1227574511-23879-5-git-send-email-dmitri.vorobiev@movial.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
References: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol init_dbox2_flash is not used outside of the file
drivers/mtd/maps/dbox2-flash.c, so make it static.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
---
 drivers/mtd/maps/dbox2-flash.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/maps/dbox2-flash.c b/drivers/mtd/maps/dbox2-flash.c
index e115667..cfacfa6 100644
--- a/drivers/mtd/maps/dbox2-flash.c
+++ b/drivers/mtd/maps/dbox2-flash.c
@@ -69,7 +69,7 @@ struct map_info dbox2_flash_map = {
 	.phys		= WINDOW_ADDR,
 };
 
-int __init init_dbox2_flash(void)
+static int __init init_dbox2_flash(void)
 {
        	printk(KERN_NOTICE "D-Box 2 flash driver (size->0x%X mem->0x%X)\n", WINDOW_SIZE, WINDOW_ADDR);
 	dbox2_flash_map.virt = ioremap(WINDOW_ADDR, WINDOW_SIZE);
-- 
1.5.3

