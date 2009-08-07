Return-Path: <linux-kernel-owner+w=401wt.eu-S1752207AbZHHPZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbZHHPZx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 11:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbZHHPZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 11:25:52 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42813 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbZHHPZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 11:25:52 -0400
Date: Fri, 7 Aug 2009 20:09:22 +0200
From: Pavel Machek <pavel@ucw.cz>
To: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.miao@marvell.com,
       utx@penguin.cz, Russell King <rmk@arm.linux.org.uk>
Subject: spitz: fix touchscreen max presure
Message-ID: <20090807180922.GE1728@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This fixes max_pressure for spitz's touchscreen, and is requirement
for getting reasonable pressure numbers from touchscreen driver.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff -ur arm.ofic/mach-pxa/spitz.c arm/mach-pxa/spitz.c
--- a/arch/arm/mach-pxa/spitz.c	2009-07-15 01:39:13.000000000 +0200
+++ b/arch/arm/mach-pxa/spitz.c	2009-07-15 10:23:25.000000000 +0200
@@ -296,6 +296,7 @@
 	.vref_delay_usecs	= 100,
 	.x_plate_ohms		= 419,
 	.y_plate_ohms		= 486,
+	.pressure_max		= 1024,
 	.gpio_pendown		= SPITZ_GPIO_TP_INT,
 	.wait_for_sync		= spitz_wait_for_hsync,
 };

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
