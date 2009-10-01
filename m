Return-Path: <linux-kernel-owner+w=401wt.eu-S932668AbZJAO2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668AbZJAO2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 10:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932655AbZJAO2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 10:28:08 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44407 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932654AbZJAO2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 10:28:07 -0400
From: Hemant Pedanekar <hemantp@ti.com>
To: dwmw2@infradead.org, dbrownell@users.sourceforge.net,
       akpm@linux-foundation.org, Artem.Bityutskiy@nokia.com,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Cc: davinci-linux-open-source@linux.davincidsp.com, hemantp@ti.com
Subject: [PATCH] mtd: nand: davinci: fix to use mask_ale from pdata
Date: Thu,  1 Oct 2009 19:55:06 +0530
Message-Id: <1254407106-19390-1-git-send-email-hemantp@ti.com>
X-Mailer: git-send-email 1.6.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct typo to use mask_ale from platform data when set to non-zero.

Signed-off-by: Hemant Pedanekar <hemantp@ti.com>
---
 drivers/mtd/nand/davinci_nand.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
index 0fad648..20b04a2 100644
--- a/drivers/mtd/nand/davinci_nand.c
+++ b/drivers/mtd/nand/davinci_nand.c
@@ -571,7 +571,7 @@ static int __init nand_davinci_probe(struct platform_device *pdev)
 	info->mask_chipsel	= pdata->mask_chipsel;
 
 	/* use nandboot-capable ALE/CLE masks by default */
-	info->mask_ale		= pdata->mask_cle ? : MASK_ALE;
+	info->mask_ale		= pdata->mask_ale ? : MASK_ALE;
 	info->mask_cle		= pdata->mask_cle ? : MASK_CLE;
 
 	/* Set address of hardware control function */
-- 
1.6.2.4

