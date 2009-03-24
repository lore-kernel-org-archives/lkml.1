Return-Path: <linux-kernel-owner+w=401wt.eu-S1757614AbZCXKG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614AbZCXKG2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 06:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbZCXKGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 06:06:19 -0400
Received: from relay.atmel.no ([80.232.32.139]:62780 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678AbZCXKGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 06:06:19 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, kernel@avr32linux.org,
       linux-kernel@vger.kernel.org,
       Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH] atmel-mci: fix sdc_reg typo
Date: Tue, 24 Mar 2009 11:06:06 +0100
Message-Id: <1237889166-17760-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>

This fixes a bug when setting the sdc_reg for 4-bit bus width
transactions.

Signed-off-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 drivers/mmc/host/atmel-mci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 2b1196e..cab1ddb 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -812,7 +812,7 @@ static void atmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		slot->sdc_reg |= MCI_SDCBUS_1BIT;
 		break;
 	case MMC_BUS_WIDTH_4:
-		slot->sdc_reg = MCI_SDCBUS_4BIT;
+		slot->sdc_reg |= MCI_SDCBUS_4BIT;
 		break;
 	}
 
-- 
1.6.0.4

