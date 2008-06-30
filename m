Return-Path: <linux-kernel-owner+w=401wt.eu-S1758233AbYF3GeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233AbYF3GeL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 02:34:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbYF3Gd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 02:33:57 -0400
Received: from mailtp.via.com.tw ([61.66.243.2]:52710 "EHLO mailtp.via.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408AbYF3Gd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 02:33:56 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: [PATCH 2/13] viafb: Makefile, Kconfig
Date: Mon, 30 Jun 2008 14:33:54 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB8074E7716@exchtp03.taipei.via.com.tw>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/13] viafb: Makefile, Kconfig
Thread-Index: Acjae0SEUHEIcRkrTfeWKJTHxhRRNQ==
From: <JosephChan@via.com.tw>
To: <JosephChan@via.com.tw>, <linux-fbdev-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>
Cc: <akpm@linux-foundation.org>, <geert@linux-m68k.org>
X-OriginalArrivalTime: 30 Jun 2008 06:33:55.0060 (UTC) FILETIME=[44D37340:01C8DA7B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m5U6YEfq018026

Modified drivers/video/Makefile and drivers/video/Kconfig files of 2.6.26-rc8 kernel.

Signed-off-by: Joseph Chan <josephchan@via.com.tw>

diff -Nur a/drivers/video/Kconfig b/drivers/video/Kconfig
--- a/drivers/video/Kconfig	2008-06-30 09:54:30.000000000 +0800
+++ b/drivers/video/Kconfig	2008-06-30 09:55:20.000000000 +0800
@@ -1498,6 +1498,23 @@
 	  (315/H/PRO, 55x, 650, 651, 740, 330, 661, 741, 760, 761) as well
 	  as XGI V3XT, V5, V8 and Z7.
 
+config FB_VIA
+       tristate "VIA UniChrome (Pro) and Chrome9 display support"
+       depends on FB && PCI
+       select FB_CFB_FILLRECT
+       select FB_CFB_COPYAREA
+       select FB_CFB_IMAGEBLIT
+       select FB_SOFT_CURSOR
+       help
+	  This is the frame buffer device driver for Graphics chips of VIA 
+	  UniChrome (Pro) Family (CLE266,PM800/CN400,P4M800CE/P4M800Pro/
+	  CN700/VN800,CX700/VX700,P4M890) and Chrome9 Family (K8M890,CN896
+ 	  /P4M900,VX800)
+	  Say Y if you have a VIA UniChrome graphics board.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called viafb.
+
 config FB_NEOMAGIC
 	tristate "NeoMagic display support"
 	depends on FB && PCI
diff -Nur a/drivers/video/Makefile b/drivers/video/Makefile
--- a/drivers/video/Makefile	2008-06-30 09:53:16.000000000 +0800
+++ b/drivers/video/Makefile	2008-06-30 09:55:24.000000000 +0800
@@ -43,6 +43,7 @@
 obj-$(CONFIG_FB_ATY128)		  += aty/ macmodes.o
 obj-$(CONFIG_FB_RADEON)		  += aty/
 obj-$(CONFIG_FB_SIS)		  += sis/
+obj-$(CONFIG_FB_VIA)		  += via/
 obj-$(CONFIG_FB_KYRO)             += kyro/
 obj-$(CONFIG_FB_SAVAGE)		  += savage/
 obj-$(CONFIG_FB_GEODE)		  += geode/
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
