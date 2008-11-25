Return-Path: <linux-kernel-owner+w=401wt.eu-S1755109AbYKYBBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109AbYKYBBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 20:01:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754738AbYKYAzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 19:55:32 -0500
Received: from smtp.movial.fi ([62.236.91.34]:57374 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152AbYKYAzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 19:55:15 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Subject: [PATCH 10/20] [MTD] Make init_mbx function static
Date: Tue, 25 Nov 2008 02:55:01 +0200
Message-Id: <1227574511-23879-11-git-send-email-dmitri.vorobiev@movial.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
References: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function init_mbx can become static, because it is not used
outside the file drivers/mtd/maps/mbx860.c. This patch adds the
needed keyword.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
---
 drivers/mtd/maps/mbx860.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/maps/mbx860.c b/drivers/mtd/maps/mbx860.c
index 706f673..0eb5a7c 100644
--- a/drivers/mtd/maps/mbx860.c
+++ b/drivers/mtd/maps/mbx860.c
@@ -55,7 +55,7 @@ struct map_info mbx_map = {
 	.bankwidth = 4,
 };
 
-int __init init_mbx(void)
+static int __init init_mbx(void)
 {
 	printk(KERN_NOTICE "Motorola MBX flash device: 0x%x at 0x%x\n", WINDOW_SIZE*4, WINDOW_ADDR);
 	mbx_map.virt = ioremap(WINDOW_ADDR, WINDOW_SIZE * 4);
-- 
1.5.3

