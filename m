Return-Path: <linux-kernel-owner+w=401wt.eu-S1755756AbYEKByo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756AbYEKByo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 21:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbYEKByh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 21:54:37 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64923 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753493AbYEKByg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 21:54:36 -0400
Date: Sun, 11 May 2008 02:54:11 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Alessandro Zummo <a.zummo@towertech.it>, Alexander Bigga <ab@mycable.de>,
       Andrew Morton <akpm@linux-foundation.org>
cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [PATCH] RTC: M41T80: Use pr_info() as appropriate
Message-ID: <Pine.LNX.4.55.0805110250570.18978@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Replace printk(KERN_INFO ...) calls with appropriate pr_info(...) 
equivalents.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 By request of I2C maintainers I have made it a separate patch.  It should 
be obvious.  Please apply.

  Maciej

patch-2.6.26-rc1-20080505-m41t80-pr_info-15
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/drivers/rtc/rtc-m41t80.c linux-2.6.26-rc1-20080505/drivers/rtc/rtc-m41t80.c
--- linux-2.6.26-rc1-20080505.macro/drivers/rtc/rtc-m41t80.c	2008-05-05 02:55:40.000000000 +0000
+++ linux-2.6.26-rc1-20080505/drivers/rtc/rtc-m41t80.c	2008-05-10 03:35:55.000000000 +0000
@@ -629,14 +629,12 @@ static int wdt_ioctl(struct inode *inode
 			return -EFAULT;
 
 		if (rv & WDIOS_DISABLECARD) {
-			printk(KERN_INFO
-			       "rtc-m41t80: disable watchdog\n");
+			pr_info("rtc-m41t80: disable watchdog\n");
 			wdt_disable();
 		}
 
 		if (rv & WDIOS_ENABLECARD) {
-			printk(KERN_INFO
-			       "rtc-m41t80: enable watchdog\n");
+			pr_info("rtc-m41t80: enable watchdog\n");
 			wdt_ping();
 		}
 
