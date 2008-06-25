Return-Path: <linux-kernel-owner+w=401wt.eu-S1757647AbYFYNXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647AbYFYNXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 09:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755995AbYFYNXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 09:23:06 -0400
Received: from mail28.messagelabs.com ([216.82.249.131]:36316 "EHLO
	mail28.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942AbYFYNXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 09:23:04 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-13.tower-28.messagelabs.com!1214400182!18843113!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
To: <linux-kernel@vger.kernel.org>
CC: <trivial@kernel.org>
Subject: [PATCH] fix typo "varaible" -> "variable"
Date: Wed, 25 Jun 2008 15:22:59 +0200
Message-ID: <1214400179-7085-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
X-Mailer: git-send-email 1.5.6
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 25 Jun 2008 13:22:59.0577 (UTC) FILETIME=[966EC690:01C8D6C6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch was created by

	git grep -l '[vV]araible' | xargs -r -t perl -p -i -e 's/\b([Vv]ar)ai(bles?)\b/$1ia$2/g'

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
---
 drivers/input/mouse/gpio_mouse.c |    2 +-
 drivers/net/skfp/h/hwmtm.h       |    2 +-
 drivers/net/wan/farsync.c        |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/input/mouse/gpio_mouse.c b/drivers/input/mouse/gpio_mouse.c
index 3392901..f8095a0 100644
--- a/drivers/input/mouse/gpio_mouse.c
+++ b/drivers/input/mouse/gpio_mouse.c
@@ -19,7 +19,7 @@
 
 /*
  * Timer function which is run every scan_ms ms when the device is opened.
- * The dev input varaible is set to the the input_dev pointer.
+ * The dev input variable is set to the the input_dev pointer.
  */
 static void gpio_mouse_scan(struct input_polled_dev *dev)
 {
diff --git a/drivers/net/skfp/h/hwmtm.h b/drivers/net/skfp/h/hwmtm.h
index 1a606d4..e1a7e5f 100644
--- a/drivers/net/skfp/h/hwmtm.h
+++ b/drivers/net/skfp/h/hwmtm.h
@@ -145,7 +145,7 @@ struct hw_modul {
 	int	leave_isr ;		/* leave fddi_isr immedeately if set */
 	int	isr_flag ;		/* set, when HWM is entered from isr */
 	/*
-	 * varaibles for the current transmit frame
+	 * variables for the current transmit frame
 	 */
 	struct s_smt_tx_queue *tx_p ;	/* pointer to the transmit queue */
 	u_long	tx_descr ;		/* tx descriptor for FORMAC+ */
diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index 547368e..f624615 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -72,7 +72,7 @@ MODULE_LICENSE("GPL");
 #endif
 
 /*
- * Modules parameters and associated varaibles
+ * Modules parameters and associated variables
  */
 static int fst_txq_low = FST_LOW_WATER_MARK;
 static int fst_txq_high = FST_HIGH_WATER_MARK;
-- 
1.5.6

