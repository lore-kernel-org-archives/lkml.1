Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab0CGHng (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 02:43:36 -0500
Received: from iron1.emtelworld.com ([196.192.81.95]:23424 "EHLO
	iron1.emtelworld.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab0CGHne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 02:43:34 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAMDlkkvEwFEi/2dsb2JhbACbSXOpa4xShHgEgxI
From: Michael Tate <michael.tate@wanadoo.fr>
To: gregkh@suse.de, alan@linux.intel.com, o.hartmann@telovital.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Michael Tate <michael.tate@wanadoo.fr>
Subject: [PATCH 5/5] staging: et131x: et1310_rx: Fix coding style issues from checkpatch.pl
Date: Sun,  7 Mar 2010 11:42:40 +0400
Message-Id: <1267947760-4564-1-git-send-email-michael.tate@wanadoo.fr>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes 14 errors and 1 warning from checkpatch.pl
Spaces replaced by tabs (14 errors).
Single statement brace style (1 warning).
Multiple long lines and other warnings not resolved.

Signed-off-by: Michael Tate <michael.tate@wanadoo.fr>
---
 drivers/staging/et131x/et1310_rx.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/et131x/et1310_rx.c b/drivers/staging/et131x/et1310_rx.c
index 81c1a74..6491b5d 100644
--- a/drivers/staging/et131x/et1310_rx.c
+++ b/drivers/staging/et131x/et1310_rx.c
@@ -842,9 +842,8 @@ PMP_RFD nic_rx_pkts(struct et131x_adapter *etdev)
 	       &etdev->regs->rxdma.psr_full_offset);
 
 #ifndef USE_FBR0
-	if (rindex != 1) {
+	if (rindex != 1)
 		return NULL;
-	}
 #endif
 
 #ifdef USE_FBR0
@@ -1076,20 +1075,21 @@ void et131x_handle_recv_interrupt(struct et131x_adapter *etdev)
 
 static inline u32 bump_fbr(u32 *fbr, u32 limit)
 {
-        u32 v = *fbr;
-        v++;
-        /* This works for all cases where limit < 1024. The 1023 case
-           works because 1023++ is 1024 which means the if condition is not
-           taken but the carry of the bit into the wrap bit toggles the wrap
-           value correctly */
-        if ((v & ET_DMA10_MASK) > limit) {
-                v &= ~ET_DMA10_MASK;
-                v ^= ET_DMA10_WRAP;
-        }
-        /* For the 1023 case */
-        v &= (ET_DMA10_MASK|ET_DMA10_WRAP);
-        *fbr = v;
-        return v;
+	u32 v = *fbr;
+	v++;
+	/* This works for all cases where limit < 1024. The 1023 case
+	 * works because 1023++ is 1024 which means the if condition is not
+	 * taken but the carry of the bit into the wrap bit toggles the wrap
+	 * value correctly
+	 */
+	if ((v & ET_DMA10_MASK) > limit) {
+		v &= ~ET_DMA10_MASK;
+		v ^= ET_DMA10_WRAP;
+	}
+	/* For the 1023 case */
+	v &= (ET_DMA10_MASK|ET_DMA10_WRAP);
+	*fbr = v;
+	return v;
 }
 
 /**
-- 
1.6.3.3

