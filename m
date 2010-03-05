Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab0CEOls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 09:41:48 -0500
Received: from iron1.emtelworld.com ([196.192.81.95]:23719 "EHLO
	iron1.emtelworld.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab0CEOlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 09:41:47 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAB+ekEvEwFEh/2dsb2JhbACbRXOoQ41mhH0EgxI
From: Michael Tate <michael.tate@wanadoo.fr>
To: gregkh@suse.de, alan@linux.intel.com, o.hartmann@telovital.com,
       michael.tate@wanadoo.fr
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] staging:et131x:et131x_isr.c Fix coding style issues. This patch fixes line length and brace coding style issues raised by checkpatch.pl Signed-off-by: Michael Tate <michael.tate@wanadoo.fr>
Date: Fri,  5 Mar 2010 18:30:56 +0400
Message-Id: <1267799456-5949-1-git-send-email-michael.tate@wanadoo.fr>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/et131x/et131x_isr.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/et131x/et131x_isr.c b/drivers/staging/et131x/et131x_isr.c
index f6d452d..8669b6d 100644
--- a/drivers/staging/et131x/et131x_isr.c
+++ b/drivers/staging/et131x/et131x_isr.c
@@ -238,14 +238,12 @@ void et131x_isr_handler(struct work_struct *work)
 	 * exit.
 	 */
 	/* Handle all the completed Transmit interrupts */
-	if (status & ET_INTR_TXDMA_ISR) {
+	if (status & ET_INTR_TXDMA_ISR)
 		et131x_handle_send_interrupt(etdev);
-	}
 
 	/* Handle all the completed Receives interrupts */
-	if (status & ET_INTR_RXDMA_XFR_DONE) {
+	if (status & ET_INTR_RXDMA_XFR_DONE)
 		et131x_handle_recv_interrupt(etdev);
-	}
 
 	status &= 0xffffffd7;
 
@@ -263,7 +261,8 @@ void et131x_isr_handler(struct work_struct *work)
 		}
 
 		/* Handle Free Buffer Ring 0 and 1 Low interrupt */
-		if (status & (ET_INTR_RXDMA_FB_R0_LOW | ET_INTR_RXDMA_FB_R1_LOW)) {
+		if (status &
+			(ET_INTR_RXDMA_FB_R0_LOW | ET_INTR_RXDMA_FB_R1_LOW)) {
 			/*
 			 * This indicates the number of unused buffers in
 			 * RXDMA free buffer ring 0 is <= the limit you
-- 
1.6.3.3

