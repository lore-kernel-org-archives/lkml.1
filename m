Return-Path: <linux-kernel-owner+w=401wt.eu-S1754814AbYKYBAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbYKYBAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 20:00:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754707AbYKYAz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 19:55:29 -0500
Received: from smtp.movial.fi ([62.236.91.34]:57390 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754198AbYKYAzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 19:55:17 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Subject: [PATCH 20/20] [MTD] Make init_sbc82xx_flash function static
Date: Tue, 25 Nov 2008 02:55:11 +0200
Message-Id: <1227574511-23879-21-git-send-email-dmitri.vorobiev@movial.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
References: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function init_sbc82xx_flash is needlessly defined global in
drivers/mtd/maps/wr_sbc82xx_flash.c, and this patch makes it static.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
---
 drivers/mtd/maps/wr_sbc82xx_flash.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/maps/wr_sbc82xx_flash.c b/drivers/mtd/maps/wr_sbc82xx_flash.c
index 413b0cf..933a2b6 100644
--- a/drivers/mtd/maps/wr_sbc82xx_flash.c
+++ b/drivers/mtd/maps/wr_sbc82xx_flash.c
@@ -74,7 +74,7 @@ do {								\
 	}							\
 } while (0);
 
-int __init init_sbc82xx_flash(void)
+static int __init init_sbc82xx_flash(void)
 {
 	volatile memctl_cpm2_t *mc = &cpm2_immr->im_memctl;
 	int bigflash;
-- 
1.5.3

