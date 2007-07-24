Return-Path: <linux-kernel-owner+w=401wt.eu-S1765433AbXGXMkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765433AbXGXMkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 08:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758357AbXGXMkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 08:40:11 -0400
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:60259 "EHLO
	aeryn.fluff.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758310AbXGXMkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 08:40:10 -0400
Date: Tue, 24 Jul 2007 13:40:04 +0100
From: Ben Dooks <ben@fluff.org>
To: rtc-linux@googlegroups.com, a.zummo@towertech.it,
       linux-kernel@vger.kernel.org
Subject: [PATCH] s3c2410: fixup after arch moves
Message-ID: <20070724124004.GA2499@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fixup the changes from moving around the arch
support for s3c24xx based systems.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

diff -urpN -X linux-2.6.22-git16-moves1/Documentation/dontdiff linux-2.6.22-git16-moves1/drivers/rtc/rtc-s3c.c linux-2.6.22-git16-moves1-fixups-split-moves2-fixup/drivers/rtc/rtc-s3c.c
--- linux-2.6.22-git16-moves1/drivers/rtc/rtc-s3c.c	2007-07-09 23:36:20.000000000 +0100
+++ linux-2.6.22-git16-moves1-fixups-split-moves2-fixup/drivers/rtc/rtc-s3c.c	2007-07-22 13:49:00.000000000 +0100
@@ -29,7 +29,7 @@
 
 #include <asm/mach/time.h>
 
-#include <asm/arch/regs-rtc.h>
+#include <asm/plat-s3c/regs-rtc.h>
 
 /* I have yet to find an S3C implementation with more than one
  * of these rtc blocks in */

