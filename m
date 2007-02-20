Return-Path: <linux-kernel-owner+w=401wt.eu-S1030305AbXBTRH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030305AbXBTRH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 12:07:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030299AbXBTRH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 12:07:26 -0500
Received: from [81.2.110.250] ([81.2.110.250]:37059 "EHLO lxorguk.ukuu.org.uk"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030309AbXBTRHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 12:07:24 -0500
Date: Tue, 20 Feb 2007 18:08:57 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: jgarzik@pobox.com, linux-kernel@vger.kernel.org
Subject: [PATCH] net: remove a collection of unneeded #undef REALLY_SLOW_IO
 stuff
Message-ID: <20070220180857.2ec18fb8@localhost.localdomain>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/drivers/net/de600.c linux-2.6.20-mm2/drivers/net/de600.c
--- linux.vanilla-2.6.20-mm2/drivers/net/de600.c	2007-02-20 12:32:34.000000000 +0000
+++ linux-2.6.20-mm2/drivers/net/de600.c	2007-02-20 14:00:46.000000000 +0000
@@ -38,12 +38,6 @@
 /* Add more time here if your adapter won't work OK: */
 #define DE600_SLOW_DOWN	udelay(delay_time)
 
- /*
- * If you still have trouble reading/writing to the adapter,
- * modify the following "#define": (see <asm/io.h> for more info)
-#define REALLY_SLOW_IO
- */
-
 /* use 0 for production, 1 for verification, >2 for debug */
 #ifdef DE600_DEBUG
 #define PRINTK(x) if (de600_debug >= 2) printk x
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/drivers/net/ni52.c linux-2.6.20-mm2/drivers/net/ni52.c
--- linux.vanilla-2.6.20-mm2/drivers/net/ni52.c	2007-02-20 12:32:34.000000000 +0000
+++ linux-2.6.20-mm2/drivers/net/ni52.c	2007-02-20 14:00:46.000000000 +0000
@@ -104,8 +104,6 @@
 static int rfdadd;	/* rfdadd=1 may be better for 8K MEM cards */
 static int fifo=0x8;	/* don't change */
 
-/* #define REALLY_SLOW_IO */
-
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/drivers/net/skfp/cfm.c linux-2.6.20-mm2/drivers/net/skfp/cfm.c
--- linux.vanilla-2.6.20-mm2/drivers/net/skfp/cfm.c	2007-01-31 14:04:44.000000000 +0000
+++ linux-2.6.20-mm2/drivers/net/skfp/cfm.c	2007-02-20 14:00:46.000000000 +0000
@@ -73,7 +73,7 @@
 /*
  * map from state to downstream port type
  */
-static const u_char cf_to_ptype[] = {
+static const unsigned char cf_to_ptype[] = {
 	TNONE,TNONE,TNONE,TNONE,TNONE,
 	TNONE,TB,TB,TS,
 	TA,TB,TS,TB
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/drivers/net/sun3_82586.c linux-2.6.20-mm2/drivers/net/sun3_82586.c
--- linux.vanilla-2.6.20-mm2/drivers/net/sun3_82586.c	2007-01-31 14:04:44.000000000 +0000
+++ linux-2.6.20-mm2/drivers/net/sun3_82586.c	2007-02-20 14:00:46.000000000 +0000
@@ -28,8 +28,6 @@
 static int rfdadd = 0; /* rfdadd=1 may be better for 8K MEM cards */
 static int fifo=0x8;	/* don't change */
 
-/* #define REALLY_SLOW_IO */
-
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/drivers/net/wan/cosa.c linux-2.6.20-mm2/drivers/net/wan/cosa.c
--- linux.vanilla-2.6.20-mm2/drivers/net/wan/cosa.c	2007-02-20 13:38:03.000000000 +0000
+++ linux-2.6.20-mm2/drivers/net/wan/cosa.c	2007-02-20 14:00:46.000000000 +0000
@@ -94,7 +94,6 @@
 #include <linux/device.h>
 
 #undef COSA_SLOW_IO	/* for testing purposes only */
-#undef REALLY_SLOW_IO
 
 #include <asm/io.h>
 #include <asm/dma.h>
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/drivers/net/wireless/wl3501_cs.c linux-2.6.20-mm2/drivers/net/wireless/wl3501_cs.c
--- linux.vanilla-2.6.20-mm2/drivers/net/wireless/wl3501_cs.c	2007-02-20 12:32:35.000000000 +0000
+++ linux-2.6.20-mm2/drivers/net/wireless/wl3501_cs.c	2007-02-20 14:01:02.000000000 +0000
@@ -26,7 +26,6 @@
  * Tested with Planet AP in 2.5.73-bk, 216 Kbytes/s in Infrastructure mode
  * with a SMP machine (dual pentium 100), using pktgen, 432 pps (pkt_size = 60)
  */
-#undef REALLY_SLOW_IO	/* most systems can safely undef this */
 
 #include <linux/delay.h>
 #include <linux/types.h>
