Return-Path: <linux-kernel-owner+w=401wt.eu-S1761301AbZALWwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761301AbZALWwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:52:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757877AbZALWgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:36:07 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44947 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757532AbZALWgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:36:05 -0500
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>,
       trivial@kernel.org
Date: Mon, 12 Jan 2009 23:35:48 +0100
Message-Id: <1231799750-21060-3-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <alpine.LNX.1.10.0901122314361.5377@jikos.suse.cz>
References: <alpine.LNX.1.10.0901122314361.5377@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ukl@pengutronix.de
Subject: [PATCH] fix typo "varaible" -> "variable"
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>

This patch was created by

	git grep -l '[vV]araible' | xargs -r -t perl -p -i -e 's/\b([Vv]ar)ai(bles?)\b/$1ia$2/g'

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
Cc: trivial@kernel.org
---
 drivers/input/mouse/gpio_mouse.c |    2 +-
 drivers/net/skfp/h/hwmtm.h       |    2 +-
 drivers/net/wan/farsync.c        |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/input/mouse/gpio_mouse.c b/drivers/input/mouse/gpio_mouse.c
index 72cf5e3..703bc95 100644
--- a/drivers/input/mouse/gpio_mouse.c
+++ b/drivers/input/mouse/gpio_mouse.c
@@ -18,7 +18,7 @@
 
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
index 48a2c9d..38bc9c1 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -69,7 +69,7 @@ MODULE_LICENSE("GPL");
 #endif
 
 /*
- * Modules parameters and associated varaibles
+ * Modules parameters and associated variables
  */
 static int fst_txq_low = FST_LOW_WATER_MARK;
 static int fst_txq_high = FST_HIGH_WATER_MARK;
-- 
1.5.6.5

