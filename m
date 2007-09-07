Return-Path: <linux-kernel-owner+w=401wt.eu-S965760AbXIGNGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965760AbXIGNGb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 09:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965395AbXIGNGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 09:06:00 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:63247 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965378AbXIGNF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 09:05:59 -0400
Message-Id: <20070907130457.318201748@mai.lab.toulouse-stg.fr.ibm.com>
References: <20070907130138.070393261@mai.lab.toulouse-stg.fr.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 07 Sep 2007 15:01:39 +0200
From: dlezcano@fr.ibm.com
To: linux-kernel@vger.kernel.org
Subject: [GIT][patch 1/1] Fix some Kconfigs on net-2.6.24
Content-Disposition: inline; filename=2.6-git-fix-Kconfig.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Lezcano <dlezcano@fr.ibm.com>

Three fixes for Kconfigs.

Signed-off-by: Daniel Lezcano <dlezcano@fr.ibm.com>

---
 drivers/input/misc/Kconfig |    2 +-
 drivers/leds/Kconfig       |    2 +-
 drivers/telephony/Kconfig  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

Index: net-2.6.24/drivers/input/misc/Kconfig
===================================================================
--- net-2.6.24.orig/drivers/input/misc/Kconfig
+++ net-2.6.24/drivers/input/misc/Kconfig
@@ -152,7 +152,7 @@
 
 config INPUT_YEALINK
 	tristate "Yealink usb-p1k voip phone"
-	depends EXPERIMENTAL
+	depends on EXPERIMENTAL
 	depends on USB_ARCH_HAS_HCD
 	select USB
 	help
Index: net-2.6.24/drivers/leds/Kconfig
===================================================================
--- net-2.6.24.orig/drivers/leds/Kconfig
+++ net-2.6.24/drivers/leds/Kconfig
@@ -83,7 +83,7 @@
 
 config LEDS_H1940
 	tristate "LED Support for iPAQ H1940 device"
-	depends LEDS_CLASS && ARCH_H1940
+	depends on LEDS_CLASS && ARCH_H1940
 	help
 	  This option enables support for the LEDs on the h1940.
 
Index: net-2.6.24/drivers/telephony/Kconfig
===================================================================
--- net-2.6.24.orig/drivers/telephony/Kconfig
+++ net-2.6.24/drivers/telephony/Kconfig
@@ -19,7 +19,7 @@
 
 config PHONE_IXJ
 	tristate "QuickNet Internet LineJack/PhoneJack support"
-	depends ISA || PCI
+	depends on ISA || PCI
 	---help---
 	  Say M if you have a telephony card manufactured by Quicknet
 	  Technologies, Inc.  These include the Internet PhoneJACK and

-- 
