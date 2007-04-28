Return-Path: <linux-kernel-owner+w=401wt.eu-S1161001AbXD1TUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161001AbXD1TUF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 15:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030772AbXD1TTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 15:19:53 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37497 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030490AbXD1TTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 15:19:34 -0400
Date: Sat, 28 Apr 2007 21:19:45 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org,
       =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
Subject: [2.6 patch] block2mtd_paramline[] mustn't be __initdata
Message-ID: <20070428191945.GQ3468@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

block2mtd_paramline[] is used in the non-__init block2mtd_setup()

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-By: Jörn Engel <joern@lazybastard.org>

---

This patch has been sent on:
- 25 Mar 2007

--- linux-2.6.21-rc4-mm1/drivers/mtd/devices/block2mtd.c.old	2007-03-25 15:56:10.000000000 +0200
+++ linux-2.6.21-rc4-mm1/drivers/mtd/devices/block2mtd.c	2007-03-25 15:56:31.000000000 +0200
@@ -423,7 +423,7 @@
 
 #ifndef MODULE
 static int block2mtd_init_called = 0;
-static __initdata char block2mtd_paramline[80 + 12]; /* 80 for device, 12 for erase size */
+static char block2mtd_paramline[80 + 12]; /* 80 for device, 12 for erase size */
 #endif
 
 

