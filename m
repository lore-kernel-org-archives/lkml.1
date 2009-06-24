Return-Path: <linux-kernel-owner+w=401wt.eu-S1759745AbZFXVk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759745AbZFXVk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 17:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbZFXVkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 17:40:46 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:47976 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522AbZFXVkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 17:40:46 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: linux-kernel@vger.kernel.org
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org, linux@maxim.org.za,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH 2/2] Fix typo s/parititions/partitions/
Date: Wed, 24 Jun 2009 18:40:46 -0300
Message-Id: <1245879646-10338-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/mtd/nand/atmel_nand.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
index 2802992..20c828b 100644
--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -534,7 +534,7 @@ static int __init atmel_nand_probe(struct platform_device *pdev)
 							 &num_partitions);
 
 	if ((!partitions) || (num_partitions == 0)) {
-		printk(KERN_ERR "atmel_nand: No parititions defined, or unsupported device.\n");
+		printk(KERN_ERR "atmel_nand: No partitions defined, or unsupported device.\n");
 		res = ENXIO;
 		goto err_no_partitions;
 	}
-- 
1.6.3

