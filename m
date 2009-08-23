Return-Path: <linux-kernel-owner+w=401wt.eu-S934107AbZHWNcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934107AbZHWNcA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 09:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934039AbZHWNb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 09:31:56 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:49789 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934102AbZHWNbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 09:31:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Lg0itiPMJ8AHxCpGekrRxIByJ6Xf7YsjywmaLry0qrB0aCEeBEFPDDcr+6Zg3U6DG7
         5zRXW5hH+9kZZkw4OrqX3Yc5keURepA022Het9k8b2BbnZeS0bFBJZ6ogPJWZfmguNFh
         rpp7k0LUAhJ1YLy3kzWaLS4Nlck5UrHIasptw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Date: Sun, 23 Aug 2009 15:32:20 +0200
Message-Id: <20090823133220.17784.86223.sendpatchset@localhost.localdomain>
In-Reply-To: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
References: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
Subject: [PATCH 33/33] Staging: remove no longer needed rt3070 driver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: remove no longer needed rt3070 driver

rt2870 handles now all rt2870/rt3070 chipsets.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/Kconfig                        |    2 -
 drivers/staging/Makefile                       |    1 
 drivers/staging/rt3070/2870_main_dev.c         |    1 
 drivers/staging/rt3070/Kconfig                 |    6 ---
 drivers/staging/rt3070/Makefile                |   43 -------------------------
 drivers/staging/rt3070/action.h                |    1 
 drivers/staging/rt3070/aironet.h               |    1 
 drivers/staging/rt3070/ap.h                    |    1 
 drivers/staging/rt3070/chlist.h                |    1 
 drivers/staging/rt3070/common/2870_rtmp_init.c |    1 
 drivers/staging/rt3070/common/action.c         |    1 
 drivers/staging/rt3070/common/ba_action.c      |    1 
 drivers/staging/rt3070/common/cmm_data.c       |    1 
 drivers/staging/rt3070/common/cmm_data_2870.c  |    1 
 drivers/staging/rt3070/common/cmm_info.c       |    1 
 drivers/staging/rt3070/common/cmm_sanity.c     |    1 
 drivers/staging/rt3070/common/cmm_sync.c       |    1 
 drivers/staging/rt3070/common/cmm_wpa.c        |    1 
 drivers/staging/rt3070/common/dfs.c            |    1 
 drivers/staging/rt3070/common/eeprom.c         |    1 
 drivers/staging/rt3070/common/md5.c            |    1 
 drivers/staging/rt3070/common/mlme.c           |    1 
 drivers/staging/rt3070/common/rtmp_init.c      |    1 
 drivers/staging/rt3070/common/rtmp_tkip.c      |    1 
 drivers/staging/rt3070/common/rtmp_wep.c       |    1 
 drivers/staging/rt3070/common/rtusb_bulk.c     |    1 
 drivers/staging/rt3070/common/rtusb_data.c     |    1 
 drivers/staging/rt3070/common/rtusb_io.c       |    1 
 drivers/staging/rt3070/common/spectrum.c       |    1 
 drivers/staging/rt3070/dfs.h                   |    1 
 drivers/staging/rt3070/md5.h                   |    1 
 drivers/staging/rt3070/mlme.h                  |    1 
 drivers/staging/rt3070/oid.h                   |    1 
 drivers/staging/rt3070/rt2870.h                |    1 
 drivers/staging/rt3070/rt28xx.h                |    1 
 drivers/staging/rt3070/rt_config.h             |    1 
 drivers/staging/rt3070/rt_linux.c              |    1 
 drivers/staging/rt3070/rt_linux.h              |    1 
 drivers/staging/rt3070/rt_main_dev.c           |    1 
 drivers/staging/rt3070/rt_profile.c            |    1 
 drivers/staging/rt3070/rtmp.h                  |    1 
 drivers/staging/rt3070/rtmp_ckipmic.h          |    1 
 drivers/staging/rt3070/rtmp_def.h              |    1 
 drivers/staging/rt3070/rtmp_type.h             |    1 
 drivers/staging/rt3070/spectrum.h              |    1 
 drivers/staging/rt3070/spectrum_def.h          |    1 
 drivers/staging/rt3070/sta/aironet.c           |    1 
 drivers/staging/rt3070/sta/assoc.c             |    1 
 drivers/staging/rt3070/sta/auth.c              |    1 
 drivers/staging/rt3070/sta/auth_rsp.c          |    1 
 drivers/staging/rt3070/sta/connect.c           |    2 -
 drivers/staging/rt3070/sta/rtmp_data.c         |    1 
 drivers/staging/rt3070/sta/sanity.c            |    1 
 drivers/staging/rt3070/sta/sync.c              |    1 
 drivers/staging/rt3070/sta/wpa.c               |    1 
 drivers/staging/rt3070/sta_ioctl.c             |    1 
 drivers/staging/rt3070/wpa.h                   |    1 
 57 files changed, 106 deletions(-)

Index: b/drivers/staging/Kconfig
===================================================================
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -73,8 +73,6 @@ source "drivers/staging/rt2860/Kconfig"
 
 source "drivers/staging/rt2870/Kconfig"
 
-source "drivers/staging/rt3070/Kconfig"
-
 source "drivers/staging/rt3090/Kconfig"
 
 source "drivers/staging/comedi/Kconfig"
Index: b/drivers/staging/Makefile
===================================================================
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -19,7 +19,6 @@ obj-$(CONFIG_AGNX)		+= agnx/
 obj-$(CONFIG_OTUS)		+= otus/
 obj-$(CONFIG_RT2860)		+= rt2860/
 obj-$(CONFIG_RT2870)		+= rt2870/
-obj-$(CONFIG_RT3070)		+= rt3070/
 obj-$(CONFIG_RT3090)		+= rt3090/
 obj-$(CONFIG_COMEDI)		+= comedi/
 obj-$(CONFIG_ASUS_OLED)		+= asus_oled/
Index: b/drivers/staging/rt3070/2870_main_dev.c
===================================================================
--- a/drivers/staging/rt3070/2870_main_dev.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../rt2870/2870_main_dev.c"
Index: b/drivers/staging/rt3070/Kconfig
===================================================================
--- a/drivers/staging/rt3070/Kconfig
+++ /dev/null
@@ -1,6 +0,0 @@
-config RT3070
-	tristate "Ralink 3070 wireless support"
-	depends on USB && X86 && WLAN_80211 && !RT2870
-	---help---
-	  This is an experimental driver for the Ralink 3070 wireless chip.
-
Index: b/drivers/staging/rt3070/Makefile
===================================================================
--- a/drivers/staging/rt3070/Makefile
+++ /dev/null
@@ -1,43 +0,0 @@
-obj-$(CONFIG_RT3070)	+= rt3070sta.o
-
-# TODO: all of these should be removed
-EXTRA_CFLAGS += -DLINUX -DAGGREGATION_SUPPORT -DPIGGYBACK_SUPPORT -DWMM_SUPPORT
-EXTRA_CFLAGS += -DRT2870 -DRT30xx -DRT3070
-EXTRA_CFLAGS += -DDBG
-
-rt3070sta-objs :=		\
-	common/md5.o		\
-	common/mlme.o		\
-	common/rtmp_wep.o	\
-	common/action.o		\
-	common/cmm_data.o	\
-	common/rtmp_init.o	\
-	common/rtmp_tkip.o	\
-	common/cmm_sync.o	\
-	common/eeprom.o		\
-	common/cmm_sanity.o	\
-	common/cmm_info.o	\
-	common/cmm_wpa.o	\
-	common/dfs.o		\
-	common/spectrum.o	\
-	sta/assoc.o		\
-	sta/aironet.o		\
-	sta/auth.o		\
-	sta/auth_rsp.o		\
-	sta/sync.o		\
-	sta/sanity.o		\
-	sta/rtmp_data.o		\
-	sta/connect.o		\
-	sta/wpa.o		\
-	rt_linux.o		\
-	rt_profile.o		\
-	rt_main_dev.o		\
-	sta_ioctl.o		\
-	common/ba_action.o	\
-	2870_main_dev.o		\
-	common/2870_rtmp_init.o	\
-	common/rtusb_io.o	\
-	common/rtusb_bulk.o	\
-	common/rtusb_data.o	\
-	common/cmm_data_2870.o
-
Index: b/drivers/staging/rt3070/action.h
===================================================================
--- a/drivers/staging/rt3070/action.h
+++ /dev/null
@@ -1 +0,0 @@
-#include "../rt2870/common/action.h"
Index: b/drivers/staging/rt3070/aironet.h
===================================================================
--- a/drivers/staging/rt3070/aironet.h
+++ /dev/null
@@ -1 +0,0 @@
-#include "../rt2870/aironet.h"
Index: b/drivers/staging/rt3070/ap.h
===================================================================
--- a/drivers/staging/rt3070/ap.h
+++ /dev/null
@@ -1 +0,0 @@
-#include "../rt2870/ap.h"
Index: b/drivers/staging/rt3070/chlist.h
===================================================================
--- a/drivers/staging/rt3070/chlist.h
+++ /dev/null
@@ -1 +0,0 @@
-#include "../rt2870/chlist.h"
Index: b/drivers/staging/rt3070/common/2870_rtmp_init.c
===================================================================
--- a/drivers/staging/rt3070/common/2870_rtmp_init.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../rt2870/common/2870_rtmp_init.c"
Index: b/drivers/staging/rt3070/common/action.c
===================================================================
--- a/drivers/staging/rt3070/common/action.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../rt2870/common/action.c"
Index: b/drivers/staging/rt3070/common/ba_action.c
===================================================================
--- a/drivers/staging/rt3070/common/ba_action.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../rt2870/common/ba_action.c"
Index: b/drivers/staging/rt3070/common/cmm_data.c
===================================================================
--- a/drivers/staging/rt3070/common/cmm_data.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../rt2870/common/cmm_data.c"
Index: b/drivers/staging/rt3070/common/cmm_data_2870.c
===================================================================
--- a/drivers/staging/rt3070/common/cmm_data_2870.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../rt2870/common/cmm_data_2870.c"
Index: b/drivers/staging/rt3070/common/cmm_info.c
===================================================================
--- a/drivers/staging/rt3070/common/cmm_info.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../rt2870/common/cmm_info.c"
Index: b/drivers/staging/rt3070/common/cmm_sanity.c
===================================================================
--- a/drivers/staging/rt3070/common/cmm_sanity.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../rt2870/common/cmm_sanity.c"
Index: b/drivers/staging/rt3070/common/cmm_sync.c
===================================================================
--- a/drivers/staging/rt3070/common/cmm_sync.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../rt2870/common/cmm_sync.c"
Index: b/drivers/staging/rt3070/common/cmm_wpa.c
===================================================================
--- a/drivers/staging/rt3070/common/cmm_wpa.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../rt2870/common/cmm_wpa.c"
Index: b/drivers/staging/rt3070/common/dfs.c
===================================================================
--- a/drivers/staging/rt3070/common/dfs.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../rt2870/common/dfs.c"
Index: b/drivers/staging/rt3070/common/eeprom.c
===================================================================
--- a/drivers/staging/rt3070/common/eeprom.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../rt2870/common/eeprom.c"
Index: b/drivers/staging/rt3070/common/md5.c
===================================================================
--- a/drivers/staging/rt3070/common/md5.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../rt2870/common/md5.c"
Index: b/drivers/staging/rt3070/common/mlme.c
===================================================================
--- a/drivers/staging/rt3070/common/mlme.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../rt2870/common/mlme.c"
Index: b/drivers/staging/rt3070/common/rtmp_init.c
===================================================================
--- a/drivers/staging/rt3070/common/rtmp_init.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../rt2870/common/rtmp_init.c"
Index: b/drivers/staging/rt3070/common/rtmp_tkip.c
===================================================================
--- a/drivers/staging/rt3070/common/rtmp_tkip.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../rt2870/common/rtmp_tkip.c"
Index: b/drivers/staging/rt3070/common/rtmp_wep.c
===================================================================
--- a/drivers/staging/rt3070/common/rtmp_wep.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../rt2870/common/rtmp_wep.c"
Index: b/drivers/staging/rt3070/common/rtusb_bulk.c
===================================================================
--- a/drivers/staging/rt3070/common/rtusb_bulk.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../rt2870/common/rtusb_bulk.c"
Index: b/drivers/staging/rt3070/common/rtusb_data.c
===================================================================
--- a/drivers/staging/rt3070/common/rtusb_data.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../rt2870/common/rtusb_data.c"
Index: b/drivers/staging/rt3070/common/rtusb_io.c
===================================================================
--- a/drivers/staging/rt3070/common/rtusb_io.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../rt2870/common/rtusb_io.c"
Index: b/drivers/staging/rt3070/common/spectrum.c
===================================================================
--- a/drivers/staging/rt3070/common/spectrum.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../rt2870/common/spectrum.c"
Index: b/drivers/staging/rt3070/dfs.h
===================================================================
--- a/drivers/staging/rt3070/dfs.h
+++ /dev/null
@@ -1 +0,0 @@
-#include "../rt2870/dfs.h"
Index: b/drivers/staging/rt3070/md5.h
===================================================================
--- a/drivers/staging/rt3070/md5.h
+++ /dev/null
@@ -1 +0,0 @@
-#include "../rt2870/md5.h"
Index: b/drivers/staging/rt3070/mlme.h
===================================================================
--- a/drivers/staging/rt3070/mlme.h
+++ /dev/null
@@ -1 +0,0 @@
-#include "../rt2870/mlme.h"
Index: b/drivers/staging/rt3070/oid.h
===================================================================
--- a/drivers/staging/rt3070/oid.h
+++ /dev/null
@@ -1 +0,0 @@
-#include "../rt2870/oid.h"
Index: b/drivers/staging/rt3070/rt2870.h
===================================================================
--- a/drivers/staging/rt3070/rt2870.h
+++ /dev/null
@@ -1 +0,0 @@
-#include "../rt2870/rt2870.h"
Index: b/drivers/staging/rt3070/rt28xx.h
===================================================================
--- a/drivers/staging/rt3070/rt28xx.h
+++ /dev/null
@@ -1 +0,0 @@
-#include "../rt2870/rt28xx.h"
Index: b/drivers/staging/rt3070/rt_config.h
===================================================================
--- a/drivers/staging/rt3070/rt_config.h
+++ /dev/null
@@ -1 +0,0 @@
-#include "../rt2870/rt_config.h"
Index: b/drivers/staging/rt3070/rt_linux.c
===================================================================
--- a/drivers/staging/rt3070/rt_linux.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../rt2870/rt_linux.c"
Index: b/drivers/staging/rt3070/rt_linux.h
===================================================================
--- a/drivers/staging/rt3070/rt_linux.h
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../rt2870/rt_linux.h"
Index: b/drivers/staging/rt3070/rt_main_dev.c
===================================================================
--- a/drivers/staging/rt3070/rt_main_dev.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../rt2870/rt_main_dev.c"
Index: b/drivers/staging/rt3070/rt_profile.c
===================================================================
--- a/drivers/staging/rt3070/rt_profile.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../rt2870/rt_profile.c"
Index: b/drivers/staging/rt3070/rtmp.h
===================================================================
--- a/drivers/staging/rt3070/rtmp.h
+++ /dev/null
@@ -1 +0,0 @@
-#include "../rt2870/rtmp.h"
Index: b/drivers/staging/rt3070/rtmp_ckipmic.h
===================================================================
--- a/drivers/staging/rt3070/rtmp_ckipmic.h
+++ /dev/null
@@ -1 +0,0 @@
-#include "../rt2870/rtmp_ckipmic.h"
Index: b/drivers/staging/rt3070/rtmp_def.h
===================================================================
--- a/drivers/staging/rt3070/rtmp_def.h
+++ /dev/null
@@ -1 +0,0 @@
-#include "../rt2870/rtmp_def.h"
Index: b/drivers/staging/rt3070/rtmp_type.h
===================================================================
--- a/drivers/staging/rt3070/rtmp_type.h
+++ /dev/null
@@ -1 +0,0 @@
-#include "../rt2870/rtmp_type.h"
Index: b/drivers/staging/rt3070/spectrum.h
===================================================================
--- a/drivers/staging/rt3070/spectrum.h
+++ /dev/null
@@ -1 +0,0 @@
-#include "../rt2870/spectrum.h"
Index: b/drivers/staging/rt3070/spectrum_def.h
===================================================================
--- a/drivers/staging/rt3070/spectrum_def.h
+++ /dev/null
@@ -1 +0,0 @@
-#include "../rt2870/spectrum_def.h"
Index: b/drivers/staging/rt3070/sta/aironet.c
===================================================================
--- a/drivers/staging/rt3070/sta/aironet.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../rt2870/sta/aironet.c"
Index: b/drivers/staging/rt3070/sta/assoc.c
===================================================================
--- a/drivers/staging/rt3070/sta/assoc.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../rt2870/sta/assoc.c"
Index: b/drivers/staging/rt3070/sta/auth.c
===================================================================
--- a/drivers/staging/rt3070/sta/auth.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../rt2870/sta/auth.c"
Index: b/drivers/staging/rt3070/sta/auth_rsp.c
===================================================================
--- a/drivers/staging/rt3070/sta/auth_rsp.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../rt2870/sta/auth_rsp.c"
Index: b/drivers/staging/rt3070/sta/connect.c
===================================================================
--- a/drivers/staging/rt3070/sta/connect.c
+++ /dev/null
@@ -1,2 +0,0 @@
-#include "../../rt2870/sta/connect.c"
-
Index: b/drivers/staging/rt3070/sta/rtmp_data.c
===================================================================
--- a/drivers/staging/rt3070/sta/rtmp_data.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../rt2870/sta/rtmp_data.c"
Index: b/drivers/staging/rt3070/sta/sanity.c
===================================================================
--- a/drivers/staging/rt3070/sta/sanity.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../rt2870/sta/sanity.c"
Index: b/drivers/staging/rt3070/sta/sync.c
===================================================================
--- a/drivers/staging/rt3070/sta/sync.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../rt2870/sta/sync.c"
Index: b/drivers/staging/rt3070/sta/wpa.c
===================================================================
--- a/drivers/staging/rt3070/sta/wpa.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../rt2870/sta/wpa.c"
Index: b/drivers/staging/rt3070/sta_ioctl.c
===================================================================
--- a/drivers/staging/rt3070/sta_ioctl.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../rt2870/sta_ioctl.c"
Index: b/drivers/staging/rt3070/wpa.h
===================================================================
--- a/drivers/staging/rt3070/wpa.h
+++ /dev/null
@@ -1 +0,0 @@
-#include "../rt2870/wpa.h"
