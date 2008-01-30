Return-Path: <linux-kernel-owner+w=401wt.eu-S1757957AbYA3JTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957AbYA3JTF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 04:19:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754229AbYA3JSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 04:18:24 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:52801 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbYA3JSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 04:18:22 -0500
X-IronPort-AV: E=Sophos;i="4.25,276,1199682000"; 
   d="scan'208";a="61204118"
From: Bryan Wu <bryan.wu@analog.com>
To: dwmw2@infradead.org, linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 2/3] [MTD/NAND] Blackfin NFC driver: Fix bug - remove wrong operation in PM function of the BF54x NFC driver
Date: Wed, 30 Jan 2008 17:18:17 +0800
Message-Id: <1201684698-26936-3-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1201684698-26936-1-git-send-email-bryan.wu@analog.com>
References: <1201684698-26936-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no suspend/resume operation in NFC driver at all, currently.

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/mtd/nand/bf5xx_nand.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/bf5xx_nand.c b/drivers/mtd/nand/bf5xx_nand.c
index 542850c..2fe9678 100644
--- a/drivers/mtd/nand/bf5xx_nand.c
+++ b/drivers/mtd/nand/bf5xx_nand.c
@@ -760,9 +760,6 @@ static int bf5xx_nand_resume(struct platform_device *dev)
 {
 	struct bf5xx_nand_info *info = platform_get_drvdata(dev);
 
-	if (info)
-		bf5xx_nand_hw_init(info);
-
 	return 0;
 }
 
-- 
1.5.3.4
