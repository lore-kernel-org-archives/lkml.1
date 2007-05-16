Return-Path: <linux-kernel-owner+w=401wt.eu-S1762846AbXEPQrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762846AbXEPQrY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 12:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757714AbXEPQrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 12:47:16 -0400
Received: from ee.oulu.fi ([130.231.61.23]:34454 "EHLO ee.oulu.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757358AbXEPQrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 12:47:15 -0400
Date: Wed, 16 May 2007 19:38:18 +0300
From: Pekka Pietikainen <pp@ee.oulu.fi>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trivial@kernel.org
Subject: Re: [PATCH] Pekka Pietikainen goes UTF-8 (try #2)
Message-ID: <20070516163818.GA3834@ee.oulu.fi>
References: <46486EAE.3060009@s5r6.in-berlin.de> <Pine.LNX.4.61.0705141947390.9570@yvahk01.tjqt.qr> <tkrat.0d89f95b66d8bb2c@s5r6.in-berlin.de> <Pine.LNX.4.61.0705142209090.9570@yvahk01.tjqt.qr> <20070514202509.GA1515@stusta.de> <Pine.LNX.4.61.0705142235320.9570@yvahk01.tjqt.qr> <20070514204107.GB1515@stusta.de> <Pine.LNX.4.61.0705142258120.9570@yvahk01.tjqt.qr> <20070515162314.GA10965@ee.oulu.fi> <464A9F2E.5020801@zytor.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <464A9F2E.5020801@zytor.com>
User-Agent: Mutt/1.4.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, May 15, 2007 at 11:05:34PM -0700, H. Peter Anvin wrote:
> Pekka Pietikainen wrote:
> > Since everyone else is doing it, why not me as well. Looks like I had
> > a nice retro 7-bit a-umlaut in the tree from ten years ago too! 
> > (That was back when ISO 8859-1 didn't work universally...).
> > I hope my mailer is setup correctly for this, 
> > http://www.ee.oulu.fi/~pp/pp-goes-utf8.patch has the same in 
> > case something in the middle munges up the utf-8.
> 
> Your message came through tagged as iso-8859-1.
I noticed. Reconfigured mutt, tested the change, then sent out the email
from an unrestarted mutt. Shame on me :-( .

I wonder how much hassle these kinds of patches will cause when the UTF-8
chars they introduce start occasionally showing up in the diff -u context.
Somehow I think the world might not be ready yet (maybe in 5 years or so
I'll dare start using umlauts in email headers :D ). Oh well :-)

Since I'm polluting the list already, might as well take the opportunity
to resubmit :)

Signed-off-by: Pekka Pietikäinen <pp@ee.oulu.fi>                                

--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="pp-goes-utf8.patch"
Content-Transfer-Encoding: 8bit

--- linux-2.6.21/arch/m68k/sun3/config.c~	2007-05-15 19:01:45.000000000 +0300
+++ linux-2.6.21/arch/m68k/sun3/config.c	2007-05-15 19:01:45.000000000 +0300
@@ -1,7 +1,7 @@
 /*
  *  linux/arch/m68k/sun3/config.c
  *
- *  Copyright (C) 1996,1997 Pekka Pietik{inen
+ *  Copyright (C) 1996,1997 Pekka PietikÃ¤inen
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
+ *      Pekka PietikÃ¤inen <pp@ee.oulu.fi>
  *
  * TODO:
  *   - better SAT support
--- linux-2.6.21/drivers/net/wireless/bcm43xx/bcm43xx_dma.c~	2007-05-15 19:05:36.000000000 +0300
+++ linux-2.6.21/drivers/net/wireless/bcm43xx/bcm43xx_dma.c	2007-05-15 19:05:36.000000000 +0300
@@ -8,7 +8,7 @@
 
   Some code in this file is derived from the b44.c driver
   Copyright (C) 2002 David S. Miller
-  Copyright (C) Pekka Pietikainen
+  Copyright (C) Pekka PietikÃ¤inen
 
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
--- linux-2.6.21/drivers/net/b44.c~	2007-05-15 19:18:39.000000000 +0300
+++ linux-2.6.21/drivers/net/b44.c	2007-05-15 19:18:24.000000000 +0300
@@ -1,7 +1,7 @@
 /* b44.c: Broadcom 4400 device driver.
  *
  * Copyright (C) 2002 David S. Miller (davem@redhat.com)
- * Fixed by Pekka Pietikainen (pp@ee.oulu.fi)
+ * Copyright (C) 2004 Pekka PietikÃ¤inen (pp@ee.oulu.fi)
  * Copyright (C) 2006 Broadcom Corporation.
  *
  * Distribute under GPL.
@@ -86,7 +86,7 @@
 static char version[] __devinitdata =
 	DRV_MODULE_NAME ".c:v" DRV_MODULE_VERSION " (" DRV_MODULE_RELDATE ")\n";
 
-MODULE_AUTHOR("Florian Schirmer, Pekka Pietikainen, David S. Miller");
+MODULE_AUTHOR("Florian Schirmer, Pekka PietikÃ¤inen, David S. Miller");
 MODULE_DESCRIPTION("Broadcom 4400 10/100 PCI ethernet driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_MODULE_VERSION);

--wRRV7LY7NUeQGEoC--
