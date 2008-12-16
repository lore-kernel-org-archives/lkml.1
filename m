Return-Path: <linux-kernel-owner+w=401wt.eu-S1753548AbYLPLlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbYLPLlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 06:41:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757911AbYLPLlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 06:41:18 -0500
Received: from exchtp08.via.com.tw ([61.66.243.7]:5281 "EHLO
	exchtp08.via.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757905AbYLPLlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 06:41:17 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: [Patch 1/3] via-sdmmc: Makefile, Kconfig
Date: Tue, 16 Dec 2008 19:41:16 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB808520F3A@exchtp03.taipei.via.com.tw>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Patch 1/3] via-sdmmc: Makefile, Kconfig
Thread-Index: AclfczRZsvrrHaJZRYKcXb7KJGWXIA==
From: <JosephChan@via.com.tw>
To: <linux-kernel@vger.kernel.org>
Cc: <JosephChan@via.com.tw>
X-OriginalArrivalTime: 16 Dec 2008 11:41:16.0908 (UTC) FILETIME=[34D5E2C0:01C95F73]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id mBGBfui3028820

Modified Makefile and Kconfig for kernel 2.6.28-rc8

BRs,
Joseph Chan


Signed-off-by: Joseph Chan <josephchan@via.com.tw>

--- a/drivers/mmc/host/Kconfig	2008-12-13 00:29:01.000000000 +0800
+++ b/drivers/mmc/host/Kconfig	2008-12-13 01:50:30.000000000 +0800
@@ -165,6 +165,18 @@
 
 	  If unsure, or if your system has no SPI master driver, say N.
 
+config MMC_VIA_SDMMC
+	tristate "VIA SD/MMC Card Reader driver"
+	depends on PCI
+	help
+	  This selects the VIA SD/MMC Card Reader driver, say Y or M here.
+	  VIA provides one multi-functional card reader which integrated into
+	  some motherboards manufactured by VIA.This card reader supports
+	  SD/SDHC/MMC.
+
+	  If unsure, say N.
+
+
 config MMC_S3C
 	tristate "Samsung S3C SD/MMC Card Interface support"
 	depends on ARCH_S3C2410
--- a/drivers/mmc/host/Makefile	2008-12-13 00:32:08.000000000 +0800
+++ b/drivers/mmc/host/Makefile	2008-12-13 00:33:07.000000000 +0800
@@ -20,6 +20,7 @@
 obj-$(CONFIG_MMC_TIFM_SD)	+= tifm_sd.o
 obj-$(CONFIG_MMC_SPI)		+= mmc_spi.o
 obj-$(CONFIG_MMC_S3C)   	+= s3cmci.o
+obj-$(CONFIG_MMC_VIA_SDMMC)   	+= via-sdmmc.o
 obj-$(CONFIG_MMC_SDRICOH_CS)	+= sdricoh_cs.o
 obj-$(CONFIG_MMC_TMIO)		+= tmio_mmc.o
 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
