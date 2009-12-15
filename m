Return-Path: <linux-kernel-owner+w=401wt.eu-S1760307AbZLOVAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760307AbZLOVAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 16:00:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758179AbZLOVAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 16:00:16 -0500
Received: from georges.telenet-ops.be ([195.130.137.68]:55330 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150AbZLOVAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 16:00:15 -0500
Date: Tue, 15 Dec 2009 22:00:02 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@linux.intel.com>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] mfd: MFD_WM831X should depend on GENERIC_HARDIRQS
Message-ID: <alpine.DEB.2.00.0912152157330.27772@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e2def3261a58e9c0e56b710b2020858df010a2c1 Mon Sep 17 00:00:00 2001
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 15 Dec 2009 21:49:57 +0100
Subject: [PATCH] mfd: MFD_WM831X should depend on GENERIC_HARDIRQS

commit 5fb4d38b19d95a5f980f0a10adba798f5b92128c ("mfd: Move WM831x to generic
IRQ") didn't take into account that genirq support depends on GENERIC_HARDIRQS.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/mfd/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 8782978..5863d14 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -197,7 +197,7 @@ config MFD_WM8400
 config MFD_WM831X
 	bool "Support Wolfson Microelectronics WM831x/2x PMICs"
 	select MFD_CORE
-	depends on I2C=y
+	depends on I2C=y && GENERIC_HARDIRQS
 	help
 	  Support for the Wolfson Microelecronics WM831x and WM832x PMICs.
 	  This driver provides common support for accessing the device,
-- 
1.6.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
