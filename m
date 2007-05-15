Return-Path: <linux-kernel-owner+w=401wt.eu-S1760899AbXEOREi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760899AbXEOREi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 13:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758054AbXEOREb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 13:04:31 -0400
Received: from ee.oulu.fi ([130.231.61.23]:52867 "EHLO ee.oulu.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757934AbXEOREa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 13:04:30 -0400
X-Greylist: delayed 1946 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 May 2007 13:04:30 EDT
Date: Tue, 15 May 2007 19:23:14 +0300
From: Pekka Pietikainen <pp@ee.oulu.fi>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trivial@kernel.org
Subject: Re: [PATCH] Pekka Pietikainen goes UTF-8
Message-ID: <20070515162314.GA10965@ee.oulu.fi>
References: <4647A52A.8000709@post.pl> <4647A868.4070201@post.pl> <46486EAE.3060009@s5r6.in-berlin.de> <Pine.LNX.4.61.0705141947390.9570@yvahk01.tjqt.qr> <tkrat.0d89f95b66d8bb2c@s5r6.in-berlin.de> <Pine.LNX.4.61.0705142209090.9570@yvahk01.tjqt.qr> <20070514202509.GA1515@stusta.de> <Pine.LNX.4.61.0705142235320.9570@yvahk01.tjqt.qr> <20070514204107.GB1515@stusta.de> <Pine.LNX.4.61.0705142258120.9570@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.61.0705142258120.9570@yvahk01.tjqt.qr>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since everyone else is doing it, why not me as well. Looks like I had
a nice retro 7-bit a-umlaut in the tree from ten years ago too! 
(That was back when ISO 8859-1 didn't work universally...).
I hope my mailer is setup correctly for this, 
http://www.ee.oulu.fi/~pp/pp-goes-utf8.patch has the same in 
case something in the middle munges up the utf-8.

Signed-off-by: Pekka Pietikäinen <pp@ee.oulu.fi>

--- linux-2.6.21/arch/m68k/sun3/config.c~	2007-05-15 19:01:45.000000000 +0300
+++ linux-2.6.21/arch/m68k/sun3/config.c	2007-05-15 19:01:45.000000000 +0300
@@ -1,7 +1,7 @@
 /*
  *  linux/arch/m68k/sun3/config.c
  *
- *  Copyright (C) 1996,1997 Pekka Pietik{inen
+ *  Copyright (C) 1996,1997 Pekka Pietikäinen
  *
  * This file is subject to the terms and conditions of the GNU General Public
  * License.  See the file COPYING in the main directory of this archive
--- linux-2.6.21/drivers/media/video/msp3400-driver.c~	2007-05-15 19:04:10.000000000 +0300
+++ linux-2.6.21/drivers/media/video/msp3400-driver.c	2007-05-15 19:04:10.000000000 +0300
@@ -22,7 +22,7 @@
  *
  *  NICAM (B/G, L , used in UK, Scandinavia, Spain and France)
  *      should work, with autodetect. Support for NICAM was added by
- *      Pekka Pietikainen <pp@netppl.fi>
+ *      Pekka Pietikäinen <pp@ee.oulu.fi>
  *
  * TODO:
  *   - better SAT support
--- linux-2.6.21/drivers/net/wireless/bcm43xx/bcm43xx_dma.c~	2007-05-15 19:05:36.000000000 +0300
+++ linux-2.6.21/drivers/net/wireless/bcm43xx/bcm43xx_dma.c	2007-05-15 19:05:36.000000000 +0300
@@ -8,7 +8,7 @@
 
   Some code in this file is derived from the b44.c driver
   Copyright (C) 2002 David S. Miller
-  Copyright (C) Pekka Pietikainen
+  Copyright (C) Pekka Pietikäinen
 
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
--- linux-2.6.21/drivers/net/b44.c~	2007-05-15 19:18:39.000000000 +0300
+++ linux-2.6.21/drivers/net/b44.c	2007-05-15 19:18:24.000000000 +0300
@@ -1,7 +1,7 @@
 /* b44.c: Broadcom 4400 device driver.
  *
  * Copyright (C) 2002 David S. Miller (davem@redhat.com)
- * Fixed by Pekka Pietikainen (pp@ee.oulu.fi)
+ * Copyright (C) 2004 Pekka Pietikäinen (pp@ee.oulu.fi)
  * Copyright (C) 2006 Broadcom Corporation.
  *
  * Distribute under GPL.
@@ -86,7 +86,7 @@
 static char version[] __devinitdata =
 	DRV_MODULE_NAME ".c:v" DRV_MODULE_VERSION " (" DRV_MODULE_RELDATE ")\n";
 
-MODULE_AUTHOR("Florian Schirmer, Pekka Pietikainen, David S. Miller");
+MODULE_AUTHOR("Florian Schirmer, Pekka Pietikäinen, David S. Miller");
 MODULE_DESCRIPTION("Broadcom 4400 10/100 PCI ethernet driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_MODULE_VERSION);
