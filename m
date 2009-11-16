Return-Path: <linux-kernel-owner+w=401wt.eu-S1751622AbZKPO5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622AbZKPO5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 09:57:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbZKPO5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 09:57:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:58699 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbZKPO5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 09:57:09 -0500
Date: Mon, 16 Nov 2009 08:57:12 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH] staging: rtl8187se: Rename staging driver to avoid name
 conflict with mainline driver
Message-ID: <4b016848.3j3kclbqZ4ylyZGU%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that active development has begun on a mainline version of
a driver for the RTL8187SE that should be called rtl8187se, there
is a conflict with the driver in staging with the same name.

To solve the conflict, rename the driver in staging to rtl8187se_stage.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/staging/Makefile
===================================================================
--- wireless-testing.orig/drivers/staging/Makefile
+++ wireless-testing/drivers/staging/Makefile
@@ -20,7 +20,7 @@ obj-$(CONFIG_COMEDI)		+= comedi/
 obj-$(CONFIG_ASUS_OLED)		+= asus_oled/
 obj-$(CONFIG_PANEL)		+= panel/
 obj-$(CONFIG_ALTERA_PCIE_CHDMA)	+= altpciechdma/
-obj-$(CONFIG_RTL8187SE)		+= rtl8187se/
+obj-$(CONFIG_RTL8187SE_STAGE)	+= rtl8187se/
 obj-$(CONFIG_RTL8192SU)		+= rtl8192su/
 obj-$(CONFIG_RTL8192E)		+= rtl8192e/
 obj-$(CONFIG_INPUT_MIMIO)	+= mimio/
Index: wireless-testing/drivers/staging/rtl8187se/Kconfig
===================================================================
--- wireless-testing.orig/drivers/staging/rtl8187se/Kconfig
+++ wireless-testing/drivers/staging/rtl8187se/Kconfig
@@ -1,4 +1,4 @@
-config RTL8187SE
+config RTL8187SE_STAGE
 	tristate "RealTek RTL8187SE Wireless LAN NIC driver"
 	depends on PCI && WLAN
 	select WIRELESS_EXT
Index: wireless-testing/drivers/staging/rtl8187se/Makefile
===================================================================
--- wireless-testing.orig/drivers/staging/rtl8187se/Makefile
+++ wireless-testing/drivers/staging/rtl8187se/Makefile
@@ -16,7 +16,7 @@ EXTRA_CFLAGS += -DENABLE_LPS
 
 #EXTRA_CFLAGS += -mhard-float -DCONFIG_FORCE_HARD_FLOAT=y
 
-rtl8187se-objs :=			\
+rtl8187se_stage-objs :=			\
 		r8180_core.o		\
 		r8180_93cx6.o		\
 		r8180_wx.o		\
@@ -35,5 +35,5 @@ rtl8187se-objs :=			\
 		ieee80211/ieee80211_crypt_ccmp.o	\
 		ieee80211/ieee80211_crypt_wep.o
 
-obj-$(CONFIG_RTL8187SE)	+= rtl8187se.o
+obj-$(CONFIG_RTL8187SE_STAGE)	+= rtl8187se_stage.o
 
