Return-Path: <linux-kernel-owner+w=401wt.eu-S1758310AbXGXM2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310AbXGXM2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 08:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756569AbXGXM2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 08:28:06 -0400
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:60195 "EHLO
	aeryn.fluff.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810AbXGXM2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 08:28:03 -0400
Date: Tue, 24 Jul 2007 13:28:01 +0100
From: Ben Dooks <ben@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: wim@iguana.be
Subject: [PATCH] s3c2410_wdt: fixup after arch include moves
Message-ID: <20070724122801.GA25243@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fixup the s3c2410 watchdog driver after moving some
of the arch specific includes it has been relying on.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

diff -urpN -X linux-2.6.22-git16-moves1/Documentation/dontdiff linux-2.6.22-git16-moves1/drivers/char/watchdog/s3c2410_wdt.c linux-2.6.22-git16-moves1-fixups-split-moves2-fixup/drivers/char/watchdog/s3c2410_wdt.c
--- linux-2.6.22-git16-moves1/drivers/char/watchdog/s3c2410_wdt.c	2007-07-21 15:13:27.000000000 +0100
+++ linux-2.6.22-git16-moves1-fixups-split-moves2-fixup/drivers/char/watchdog/s3c2410_wdt.c	2007-07-22 13:49:14.000000000 +0100
@@ -52,10 +52,10 @@
 
 #include <asm/arch/map.h>
 
-#undef S3C24XX_VA_WATCHDOG
-#define S3C24XX_VA_WATCHDOG (0)
+#undef S3C_VA_WATCHDOG
+#define S3C_VA_WATCHDOG (0)
 
-#include <asm/arch/regs-watchdog.h>
+#include <asm/plat-s3c/regs-watchdog.h>
 
 #define PFX "s3c2410-wdt: "
 
