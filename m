Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378Ab0CKU1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 15:27:41 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:9294 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153Ab0CKU1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 15:27:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=RRdQhGqDuRlIoLfHp1tYm5S9OzSDb9ubZd4+iIJbvOC+1az2kytVUqDH95il+ShFpp
         KEUWe+EvXru12H4ucv41s8ExP65wX58X3kUhALUlY+SZdYFN2anC7Nn1WaeLMEYDhjvi
         ikYeS4Fof+FVsQOxluE2qD87ko5caUW2aj+Ro=
Subject: [PATCH] Staging: crystalhd: fix brace and whitespace coding style
 issue in crystalhd_hw.c
From: Niklas Gottschalk <gottschalk.niklas@googlemail.com>
To: linux-kernel@vger.kernel.org, gregkh@suse.de, jarod@redhat.com,
       abraham.manu@gmail.com, davilla@4pi.com, devel@driverdev.osuosl.org
Content-Type: text/plain
Date: Thu, 11 Mar 2010 21:15:43 +0100
Message-Id: <1268338543.19171.3.camel@GentooBox>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 33c0dbc048046e0666926de47a74d8870e3d4099 Mon Sep 17 00:00:00 2001
From: coach <coach@GentooBox.(none)>
Date: Thu, 11 Mar 2010 20:42:18 +0100
Subject: [PATCH] Staging: crystalhd: fix brace and whitespace coding style issue in crystalhd_hw.c
 This is a patch to the crystalhd_hw.c file that fixes up some brace and whitespace warnings found by the checkpatch.pl tool
 Signed-off-by: Niklas Gottschalk <gottschalk.niklas@googlemail.com>

---
 drivers/staging/crystalhd/crystalhd_hw.c |   23 +++++++++--------------
 1 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/crystalhd/crystalhd_hw.c b/drivers/staging/crystalhd/crystalhd_hw.c
index 01819d3..d5c79d5 100644
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
1.6.4.4



