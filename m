Return-Path: <linux-kernel-owner+w=401wt.eu-S1758545AbYFVVia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545AbYFVVia (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 17:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756005AbYFVVh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 17:37:29 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:57838 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755904AbYFVVh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 17:37:28 -0400
Message-Id: <20080622213722.846643932@fluff.org.uk>
References: <20080622213648.343882522@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Sun, 22 Jun 2008 22:36:51 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.arm.linux.org.uk, wim@iguana.be,
       Ben Dooks <ben-linux@fluff.org>
Subject: [patch 3/3] WATCHDOG: Fix s3c2410_wdt driver coding style issues
Content-Disposition: inline; filename=simtec/simtec-drivers-s3c2410-wdt-cleanup2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixup coding style issues in the s3c2410_wdt driver.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc5-quilt1/drivers/watchdog/s3c2410_wdt.c
===================================================================
--- linux-2.6.26-rc5-quilt1.orig/drivers/watchdog/s3c2410_wdt.c	2008-06-07 23:12:18.000000000 +0100
+++ linux-2.6.26-rc5-quilt1/drivers/watchdog/s3c2410_wdt.c	2008-06-07 23:14:31.000000000 +0100
@@ -199,7 +199,7 @@ static int s3c2410wdt_set_heartbeat(int 
 
 static int s3c2410wdt_open(struct inode *inode, struct file *file)
 {
-	if(down_trylock(&open_lock))
+	if (down_trylock(&open_lock))
 		return -EBUSY;
 
 	if (nowayout)
@@ -237,7 +237,7 @@ static ssize_t s3c2410wdt_write(struct f
 	/*
 	 *	Refresh the timer.
 	 */
-	if(len) {
+	if (len) {
 		if (!nowayout) {
 			size_t i;
 
@@ -256,6 +256,7 @@ static ssize_t s3c2410wdt_write(struct f
 
 		s3c2410wdt_keepalive();
 	}
+
 	return len;
 }
 
@@ -356,7 +357,7 @@ static int s3c2410wdt_probe(struct platf
 		return -ENOENT;
 	}
 
-	size = (res->end-res->start)+1;
+	size = (res->end - res->start) + 1;
 	wdt_mem = request_mem_region(res->start, size, pdev->name);
 	if (wdt_mem == NULL) {
 		dev_err(dev, "failed to get memory region\n");

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
