Return-Path: <linux-kernel-owner+w=401wt.eu-S1758576AbZDFNQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576AbZDFNQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 09:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754995AbZDFNQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 09:16:04 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:49575 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649AbZDFNQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 09:16:03 -0400
Date: Mon, 6 Apr 2009 15:15:55 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kalle Valo <kalle.valo@nokia.com>, Greg Kroah-Hartman <gregkh@suse.de>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: STLC45XX should depend on GENERIC_HARDIRQS
Message-ID: <Pine.LNX.4.64.0904061515001.13923@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

m68k allmodconfig:
| drivers/staging/stlc45xx/stlc45xx.c: In function 'stlc45xx_probe':
| drivers/staging/stlc45xx/stlc45xx.c:2456: error: implicit declaration of function 'set_irq_type'
| make[6]: *** [drivers/staging/stlc45xx/stlc45xx.o] Error 1

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/staging/stlc45xx/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/stlc45xx/Kconfig b/drivers/staging/stlc45xx/Kconfig
index 8d3f46f..947fb75 100644
--- a/drivers/staging/stlc45xx/Kconfig
+++ b/drivers/staging/stlc45xx/Kconfig
@@ -1,6 +1,6 @@
 config STLC45XX
 	tristate "stlc4550/4560 support"
-	depends on MAC80211 && WLAN_80211 && SPI_MASTER
+	depends on MAC80211 && WLAN_80211 && SPI_MASTER && GENERIC_HARDIRQS
 	---help---
 	  This is a driver for stlc4550 and stlc4560 chipsets.
 
-- 
1.6.2.1

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
