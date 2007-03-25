Return-Path: <linux-kernel-owner+w=401wt.eu-S1753514AbXCYWlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbXCYWlr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 18:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbXCYWlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 18:41:47 -0400
Received: from queue03-winn.ispmail.ntl.com ([81.103.221.57]:22263 "EHLO
	queue03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753514AbXCYWlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 18:41:46 -0400
X-Greylist: delayed 1053 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Mar 2007 18:41:45 EDT
From: Daniel Drake <dsd@gentoo.org>
To: drzeus-mmc@drzeus.cx
Cc: linux-kernel@vger.kernel.org
Cc: oakad@yahoo.com
Subject: [PATCH] tifm_sd: add missing \n
Message-Id: <20070325222414.C16C57B409F@zog.reactivated.net>
Date: Sun, 25 Mar 2007 23:24:14 +0100 (BST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Noticed this in user logs.

Signed-off-by: Daniel Drake <dsd@gentoo.org>

Index: linux/drivers/mmc/tifm_sd.c
===================================================================
--- linux.orig/drivers/mmc/tifm_sd.c
+++ linux/drivers/mmc/tifm_sd.c
@@ -676,7 +676,7 @@ static void tifm_sd_abort(unsigned long 
 	struct tifm_sd *host = (struct tifm_sd*)data;
 
 	printk(KERN_ERR DRIVER_NAME
-	       ": card failed to respond for a long period of time");
+	       ": card failed to respond for a long period of time\n");
 
 	tifm_sd_terminate(host);
 	tifm_eject(host->dev);
