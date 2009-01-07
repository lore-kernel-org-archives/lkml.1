Return-Path: <linux-kernel-owner+w=401wt.eu-S1760124AbZAGQmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760124AbZAGQmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 11:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753766AbZAGQl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 11:41:29 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:25149 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758575AbZAGQl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 11:41:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=e/Ao98hz0+rTwrsI/zNPuH3pzsdiTi/OrPQwT8uEoNu6wJOkwLNwMfJCWKIWUstFKY
         1++X5hFB79v3inYXVCfh9AN6qdMSj8YnXhBpYOp24cXxMETN4CrCKUmviOSgTN/W2B8+
         2OGYPDlJj72I5zN3LpOfd1eoVR03W4Dccjzeg=
From: Bryan Wu <cooloney@kernel.org>
To: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 3/3] Blackfin NFC Driver: drop pointless casts with set_dma_callback()
Date: Thu,  8 Jan 2009 00:41:59 +0800
Message-Id: <1231346519-28603-4-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1231346519-28603-1-git-send-email-cooloney@kernel.org>
References: <1231346519-28603-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/mtd/nand/bf5xx_nand.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/bf5xx_nand.c b/drivers/mtd/nand/bf5xx_nand.c
index 520314d..4c2a67c 100644
--- a/drivers/mtd/nand/bf5xx_nand.c
+++ b/drivers/mtd/nand/bf5xx_nand.c
@@ -572,7 +572,7 @@ static int bf5xx_nand_dma_init(struct bf5xx_nand_info *info)
 	SSYNC();
 #endif
 
-	set_dma_callback(CH_NFC, (void *) bf5xx_nand_dma_irq, (void *) info);
+	set_dma_callback(CH_NFC, bf5xx_nand_dma_irq, info);
 
 	/* Turn off the DMA channel first */
 	disable_dma(CH_NFC);
-- 
1.5.6

