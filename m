Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbYHHKKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbYHHKKl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 06:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbYHHKK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 06:10:26 -0400
Received: from mailtp.via.com.tw ([61.66.243.2]:15139 "EHLO mailtp.via.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756048AbYHHKKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 06:10:25 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: [PATCH 2/13 v2] viafb: Makefile, Kconfig
Date: Fri, 8 Aug 2008 18:10:22 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB8078B698E@exchtp03.taipei.via.com.tw>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/13 v2] viafb: Makefile, Kconfig
Thread-Index: Acj5PvfsLV7b4RxbSMmI3locCb7zIw==
From: <JosephChan@via.com.tw>
To: <JosephChan@via.com.tw>, <linux-fbdev-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>
Cc: <akpm@linux-foundation.org>, <geert@linux-m68k.org>
X-OriginalArrivalTime: 08 Aug 2008 10:10:23.0293 (UTC) FILETIME=[F886C6D0:01C8F93E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m78ABFdq019407

Modified drivers/video/Makefile and drivers/video/Kconfig files of 2.6.27-rc2 kernel.

Signed-off-by: Joseph Chan <josephchan@via.com.tw>

diff -Nurp a/drivers/video/Makefile b/drivers/video/Makefile
--- a/drivers/video/Makefile	2008-08-05 16:59:14.000000000 +0800
+++ b/drivers/video/Makefile	2008-08-05 16:58:56.000000000 +0800
@@ -43,6 +43,7 @@ obj-$(CONFIG_FB_ATY)		  += aty/ macmodes
 obj-$(CONFIG_FB_ATY128)		  += aty/ macmodes.o
 obj-$(CONFIG_FB_RADEON)		  += aty/
 obj-$(CONFIG_FB_SIS)		  += sis/
+obj-$(CONFIG_FB_VIA)		  += via/
 obj-$(CONFIG_FB_KYRO)             += kyro/
 obj-$(CONFIG_FB_SAVAGE)		  += savage/
 obj-$(CONFIG_FB_GEODE)		  += geode/
diff -Nurp a/drivers/video/Kconfig b/drivers/video/Kconfig
--- a/drivers/video/Kconfig	2008-08-05 16:59:16.000000000 +0800
+++ b/drivers/video/Kconfig	2008-08-05 16:58:48.000000000 +0800
@@ -1498,6 +1498,24 @@ config FB_SIS_315
 	  (315/H/PRO, 55x, 650, 651, 740, 330, 661, 741, 760, 761) as well
 	  as XGI V3XT, V5, V8 and Z7.
 
+config FB_VIA
+       tristate "VIA UniChrome (Pro) and Chrome9 display support"
+       depends on FB && PCI
+       select FB_CFB_FILLRECT
+       select FB_CFB_COPYAREA
+       select FB_CFB_IMAGEBLIT
+       select FB_SOFT_CURSOR
+       select I2C_ALGOBIT
+       select I2C
+       help
+	  This is the frame buffer device driver for Graphics chips of VIA 
+	  UniChrome (Pro) Family (CLE266,PM800/CN400,P4M800CE/P4M800Pro/
+	  CN700/VN800,CX700/VX700,P4M890) and Chrome9 Family (K8M890,CN896
+ 	  /P4M900,VX800)
+	  Say Y if you have a VIA UniChrome graphics board.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called viafb.
 config FB_NEOMAGIC
 	tristate "NeoMagic display support"
 	depends on FB && PCI
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
