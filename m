Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153Ab0CJJ5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 04:57:34 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35111 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369Ab0CJJ5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 04:57:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=bxBnoUMr2v1Q926n6Zui3O87vRmCnDBdtOf/eh5iz2PvUCtlwPadSLAmwDkvD616Vc
         sParjBhDbCx1OPRGhq9+JomM9SPGdJ0XxL9fTXOSHRUO6Rv3M3yKtT3TkzSFcA++TgTP
         cP44m9A0nCBEADhQjgUGmcInOc3INpmOJ3OQc=
From: Tomas Dabasinskas <tomas.it@gmail.com>
To: gregkh@suse.de, jarod@redhat.com, abraham.manu@gmail.com, davilla@4pi.com,
       tomas.it@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: crystalhd: fixed white spaces and brace coding in crystalhd_hw.c This is a patch to the crystalhd_hw.c file that fixes up a white space and brace warnings found by the checkpatch.pl tool Signed-off-by: Tomas Dabasinskas <tomas.it@gmail.com>
Date: Wed, 10 Mar 2010 19:51:01 +1000
Message-Id: <1268214661-12992-1-git-send-email-tomas.it@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/crystalhd/crystalhd_hw.c |   29 ++++++++++++-----------------
 1 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/crystalhd/crystalhd_hw.c b/drivers/staging/crystalhd/crystalhd_hw.c
index 01819d3..772da05 100644
--- a/drivers/staging/crystalhd/crystalhd_hw.c
+++ b/drivers/staging/crystalhd/crystalhd_hw.c
@@ -431,7 +431,7 @@ static void crystalhd_hw_delete_ioqs(struct crystalhd_hw *hw)
 	if (!hw)
 		return;
 
-	BCMLOG(BCMLOG_DBG, "Deleting IOQs \n");
+	BCMLOG(BCMLOG_DBG, "Deleting IOQs\n");
 	crystalhd_hw_delete_ioq(hw->adp, hw->tx_actq);
 	crystalhd_hw_delete_ioq(hw->adp, hw->tx_freeq);
 	crystalhd_hw_delete_ioq(hw->adp, hw->rx_actq);
@@ -569,7 +569,7 @@ static bool crystalhd_tx_list0_handler(struct crystalhd_hw *hw, uint32_t err_sts
 	if (!(err_sts & err_mask))
 		return false;
 
-	BCMLOG_ERR("Error on Tx-L0 %x \n", err_sts);
+	BCMLOG_ERR("Error on Tx-L0 %x\n", err_sts);
 
 	tmp = err_mask;
 
@@ -601,7 +601,7 @@ static bool crystalhd_tx_list1_handler(struct crystalhd_hw *hw, uint32_t err_sts
 	if (!(err_sts & err_mask))
 		return false;
 
-	BCMLOG_ERR("Error on Tx-L1 %x \n", err_sts);
+	BCMLOG_ERR("Error on Tx-L1 %x\n", err_sts);
 
 	tmp = err_mask;
 
@@ -634,9 +634,9 @@ static void crystalhd_tx_isr(struct crystalhd_hw *hw, uint32_t int_sts)
 					   BC_STS_SUCCESS);
 
 	if (!(int_sts & (INTR_INTR_STATUS_L0_TX_DMA_ERR_INTR_MASK |
-			 INTR_INTR_STATUS_L1_TX_DMA_ERR_INTR_MASK))) {
-			 /* No error mask set.. */
-			 return;
+			INTR_INTR_STATUS_L1_TX_DMA_ERR_INTR_MASK))) {
+			/* No error mask set.. */
+			return;
 	}
 
 	/* Handle Tx errors. */
@@ -1133,33 +1133,29 @@ static void crystalhd_stop_rx_dma_engine(struct crystalhd_hw *hw)
 		if (l0y) {
 			l0y = crystalhd_reg_rd(hw->adp, MISC1_Y_RX_FIRST_DESC_L_ADDR_LIST0);
 			l0y &= DMA_START_BIT;
-			if (!l0y) {
+			if (!l0y)
 				hw->rx_list_sts[0] &= ~rx_waiting_y_intr;
-			}
 		}
 
 		if (l1y) {
 			l1y = crystalhd_reg_rd(hw->adp, MISC1_Y_RX_FIRST_DESC_L_ADDR_LIST1);
 			l1y &= DMA_START_BIT;
-			if (!l1y) {
+			if (!l1y)
 				hw->rx_list_sts[1] &= ~rx_waiting_y_intr;
-			}
 		}
 
 		if (l0uv) {
 			l0uv = crystalhd_reg_rd(hw->adp, MISC1_UV_RX_FIRST_DESC_L_ADDR_LIST0);
 			l0uv &= DMA_START_BIT;
-			if (!l0uv) {
+			if (!l0uv)
 				hw->rx_list_sts[0] &= ~rx_waiting_uv_intr;
-			}
 		}
 
 		if (l1uv) {
 			l1uv = crystalhd_reg_rd(hw->adp, MISC1_UV_RX_FIRST_DESC_L_ADDR_LIST1);
 			l1uv &= DMA_START_BIT;
-			if (!l1uv) {
+			if (!l1uv)
 				hw->rx_list_sts[1] &= ~rx_waiting_uv_intr;
-			}
 		}
 		msleep_interruptible(100);
 		count--;
@@ -1431,9 +1427,8 @@ static bool crystalhd_rx_list1_handler(struct crystalhd_hw *hw, uint32_t int_sts
 
 	/* UV1 - DMA */
 	tmp = uv_err_sts & GET_UV1_ERR_MSK;
-	if (int_sts & INTR_INTR_STATUS_L1_UV_RX_DMA_DONE_INTR_MASK) {
+	if (int_sts & INTR_INTR_STATUS_L1_UV_RX_DMA_DONE_INTR_MASK)
 		hw->rx_list_sts[1] &= ~rx_waiting_uv_intr;
-	}
 
 	if (uv_err_sts & MISC1_UV_RX_ERROR_STATUS_RX_L1_UNDERRUN_ERROR_MASK) {
 		hw->rx_list_sts[1] &= ~rx_waiting_uv_intr;
@@ -1739,7 +1734,7 @@ BC_STATUS crystalhd_do_fw_cmd(struct crystalhd_hw *hw, BC_FW_CMD *fw_cmd)
 	res_buff = fw_cmd->rsp;
 
 	if (!cmd_buff || !res_buff) {
-		BCMLOG_ERR("Invalid Parameters for F/W Command \n");
+		BCMLOG_ERR("Invalid Parameters for F/W Command\n");
 		return BC_STS_INV_ARG;
 	}
 
-- 
1.6.3.3

