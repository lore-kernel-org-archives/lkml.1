Return-Path: <linux-kernel-owner+w=401wt.eu-S1758599AbYFDNjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599AbYFDNjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 09:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbYFDNjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 09:39:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33025 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbYFDNjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 09:39:09 -0400
From: Jean Delvare <jdelvare@suse.de>
Organization: SuSE Linux
To: Wim Van Sebroeck <wim@iguana.be>
Subject: [PATCH] watchdog: Strip stray space in log message
Date: Wed, 4 Jun 2008 15:38:53 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806041538.53326.jdelvare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Strip a stray space in log messages of 3 watchdog drivers.
(And fold these long lines to make checkpatch.pl happy.)

Signed-off-by: Jean Delvare <jdelvare@suse.de>
---
This patch was already sent on:
 * 2008-01-19

 drivers/watchdog/mpcore_wdt.c |    3 ++-
 drivers/watchdog/softdog.c    |    3 ++-
 drivers/watchdog/txx9wdt.c    |    2 +-
 3 files changed, 5 insertions(+), 3 deletions(-)

--- linux-2.6.26-rc4.orig/drivers/watchdog/mpcore_wdt.c	2008-06-03 10:55:01.000000000 +0200
+++ linux-2.6.26-rc4/drivers/watchdog/mpcore_wdt.c	2008-06-03 10:57:25.000000000 +0200
@@ -405,7 +405,8 @@ static struct platform_driver mpcore_wdt
 	},
 };
 
-static char banner[] __initdata = KERN_INFO "MPcore Watchdog Timer: 0.1. mpcore_noboot=%d mpcore_margin=%d sec (nowayout= %d)\n";
+static char banner[] __initdata = KERN_INFO "MPcore Watchdog Timer: 0.1. "
+	"mpcore_noboot=%d mpcore_margin=%d sec (nowayout=%d)\n";
 
 static int __init mpcore_wdt_init(void)
 {
--- linux-2.6.26-rc4.orig/drivers/watchdog/softdog.c	2008-06-03 10:55:01.000000000 +0200
+++ linux-2.6.26-rc4/drivers/watchdog/softdog.c	2008-06-03 10:57:25.000000000 +0200
@@ -262,7 +262,8 @@ static struct notifier_block softdog_not
 	.notifier_call	= softdog_notify_sys,
 };
 
-static char banner[] __initdata = KERN_INFO "Software Watchdog Timer: 0.07 initialized. soft_noboot=%d soft_margin=%d sec (nowayout= %d)\n";
+static char banner[] __initdata = KERN_INFO "Software Watchdog Timer: 0.07 "
+	"initialized. soft_noboot=%d soft_margin=%d sec (nowayout=%d)\n";
 
 static int __init watchdog_init(void)
 {
--- linux-2.6.26-rc4.orig/drivers/watchdog/txx9wdt.c	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.26-rc4/drivers/watchdog/txx9wdt.c	2008-06-04 15:25:34.000000000 +0200
@@ -227,7 +227,7 @@ static int __init txx9wdt_probe(struct p
 	}
 
 	printk(KERN_INFO "Hardware Watchdog Timer for TXx9: "
-	       "timeout=%d sec (max %ld) (nowayout= %d)\n",
+	       "timeout=%d sec (max %ld) (nowayout=%d)\n",
 	       timeout, WD_MAX_TIMEOUT, nowayout);
 
 	return 0;

-- 
Jean Delvare
Suse L3
