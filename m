Return-Path: <linux-kernel-owner+w=401wt.eu-S1755657AbYKYA62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbYKYA62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 19:58:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754604AbYKYAzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 19:55:24 -0500
Received: from smtp.movial.fi ([62.236.91.34]:57378 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171AbYKYAzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 19:55:16 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Subject: [PATCH 14/20] [MTD] Make init_rpxlite function static
Date: Tue, 25 Nov 2008 02:55:05 +0200
Message-Id: <1227574511-23879-15-git-send-email-dmitri.vorobiev@movial.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
References: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function init_rpxlite, which is not used outside of
drivers/mtd/maps/rpxlite.c, can become static. Add the
needed keyword.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
---
 drivers/mtd/maps/rpxlite.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/maps/rpxlite.c b/drivers/mtd/maps/rpxlite.c
index 14d90ed..3e3ef53 100644
--- a/drivers/mtd/maps/rpxlite.c
+++ b/drivers/mtd/maps/rpxlite.c
@@ -23,7 +23,7 @@ static struct map_info rpxlite_map = {
 	.phys = WINDOW_ADDR,
 };
 
-int __init init_rpxlite(void)
+static int __init init_rpxlite(void)
 {
 	printk(KERN_NOTICE "RPX Lite or CLLF flash device: %x at %x\n", WINDOW_SIZE*4, WINDOW_ADDR);
 	rpxlite_map.virt = ioremap(WINDOW_ADDR, WINDOW_SIZE * 4);
-- 
1.5.3

