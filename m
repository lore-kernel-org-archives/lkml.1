Return-Path: <linux-kernel-owner+w=401wt.eu-S1759472AbXKRKSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759472AbXKRKSr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 05:18:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755996AbXKRKPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 05:15:38 -0500
Received: from asia.telenet-ops.be ([195.130.137.74]:58537 "EHLO
	asia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbXKRKPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 05:15:19 -0500
Message-Id: <20071118101449.342008023@mail.of.borg>
References: <20071118101336.330321764@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 18 Nov 2007 11:13:48 +0100
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Finn Thain <fthain@telegraphics.com.au>
Subject: [patch 12/13] mac68k: add nubus card definitions and a typo fix
Content-Disposition: inline; filename=mac68k-add-nubus-card-definitions-and-a-typo-fix.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

Add some new card definitions and fix a typo (from Eugen Paiuc).

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 include/linux/nubus.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/include/linux/nubus.h
+++ b/include/linux/nubus.h
@@ -132,10 +132,12 @@ enum nubus_drhw {
 	NUBUS_DRHW_RDIUS_DCGX     = 0x027C, /* Radius DirectColor/GX */
 	NUBUS_DRHW_RDIUS_PC8      = 0x0291, /* Radius PrecisionColor 8 */
 	NUBUS_DRHW_LAPIS_PCS8     = 0x0292, /* Lapis ProColorServer 8 */
-	NUBUS_DRHW_RASTER_24LXI   = 0x02A0, /* RasterOps 8/24 XLi */
+	NUBUS_DRHW_RASTER_24XLI   = 0x02A0, /* RasterOps 8/24 XLi */
 	NUBUS_DRHW_RASTER_PBPGT   = 0x02A5, /* RasterOps PaintBoard Prism GT */
 	NUBUS_DRHW_EMACH_FSX      = 0x02AE, /* E-Machines Futura SX */
+	NUBUS_DRHW_RASTER_24XLTV  = 0x02B7, /* RasterOps 24XLTV */
 	NUBUS_DRHW_SMAC_THUND24   = 0x02CB, /* SuperMac Thunder/24 */
+	NUBUS_DRHW_SMAC_THUNDLGHT = 0x03D9, /* SuperMac ThunderLight */
 	NUBUS_DRHW_RDIUS_PC24XP   = 0x0406, /* Radius PrecisionColor 24Xp */
 	NUBUS_DRHW_RDIUS_PC24X    = 0x040A, /* Radius PrecisionColor 24X */
 	NUBUS_DRHW_RDIUS_PC8XJ    = 0x040B, /* Radius PrecisionColor 8XJ */

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

