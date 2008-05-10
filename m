Return-Path: <linux-kernel-owner+w=401wt.eu-S1758564AbYEJBHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564AbYEJBHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 21:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbYEJBHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 21:07:31 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64904 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752208AbYEJBH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 21:07:28 -0400
Date: Sat, 10 May 2008 02:04:59 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Alessandro Zummo <a.zummo@towertech.it>, Alexander Bigga <ab@mycable.de>,
       Andrew Morton <akpm@linux-foundation.org>
cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [PATCH] RTC: M41T80: Include <linux/kernel.h> for printk()
Message-ID: <Pine.LNX.4.55.0805100201450.10552@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 The driver uses printk(), but does not include <linux/kernel.h> -- add
it.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 By request of I2C maintainers I have made it a separate patch.  It should 
be obvious.  Please apply.

  Maciej

patch-2.6.26-rc1-20080505-m41t80-kernel-h-15
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/drivers/rtc/rtc-m41t80.c linux-2.6.26-rc1-20080505/drivers/rtc/rtc-m41t80.c
--- linux-2.6.26-rc1-20080505.macro/drivers/rtc/rtc-m41t80.c	2008-05-05 02:55:40.000000000 +0000
+++ linux-2.6.26-rc1-20080505/drivers/rtc/rtc-m41t80.c	2008-05-10 00:59:33.000000000 +0000
@@ -15,6 +15,7 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/i2c.h>
