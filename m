Return-Path: <linux-kernel-owner+w=401wt.eu-S1751357AbXCYO7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357AbXCYO7M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 10:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbXCYO6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 10:58:45 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:34033 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751357AbXCYO6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 10:58:01 -0400
Date: Sun, 25 Mar 2007 16:58:05 +0200
From: Adrian Bunk <bunk@stusta.de>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] block2mtd_paramline[] mustn't be __initdata
Message-ID: <20070325145805.GH16477@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

block2mtd_paramline[] is used in the non-__init block2mtd_setup()

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.21-rc4-mm1/drivers/mtd/devices/block2mtd.c.old	2007-03-25 15:56:10.000000000 +0200
+++ linux-2.6.21-rc4-mm1/drivers/mtd/devices/block2mtd.c	2007-03-25 15:56:31.000000000 +0200
@@ -423,7 +423,7 @@
 
 #ifndef MODULE
 static int block2mtd_init_called = 0;
-static __initdata char block2mtd_paramline[80 + 12]; /* 80 for device, 12 for erase size */
+static char block2mtd_paramline[80 + 12]; /* 80 for device, 12 for erase size */
 #endif
 
 

