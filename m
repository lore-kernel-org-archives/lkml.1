Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab0CFLER (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 06:04:17 -0500
Received: from iron1.emtelworld.com ([196.192.81.95]:17713 "EHLO
	iron1.emtelworld.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab0CFLEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 06:04:16 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAG7FkUvEwFEh/2dsb2JhbACbS3OnXY0ihHgEgxI
From: Michael Tate <michael.tate@wanadoo.fr>
To: gregkh@suse.de, alan@linux.intel.com, o.hartmann@telovital.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Michael Tate <michael.tate@wanadoo.fr>
Subject: [PATCH 2/2] staging: et131x: Fix brace coding style issues.
Date: Sat,  6 Mar 2010 15:03:57 +0400
Message-Id: <1267873437-10245-1-git-send-email-michael.tate@wanadoo.fr>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This revised patch fixes 2 brace coding style issues reported by checkpatch.pl
One warning line > 80 chars not resolved on maintainers advice.

Signed-off-by: Michael Tate <michael.tate@wanadoo.fr>
---
 drivers/staging/et131x/et131x_isr.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/et131x/et131x_isr.c b/drivers/staging/et131x/et131x_isr.c
index f6d452d..336c192 100644
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
 
-- 
1.6.3.3

