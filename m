Return-Path: <linux-kernel-owner+w=401wt.eu-S965584AbXIGNZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965584AbXIGNZs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 09:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965393AbXIGNZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 09:25:40 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:5432 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965391AbXIGNZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 09:25:39 -0400
Message-Id: <20070907132416.536059702@mai.lab.toulouse-stg.fr.ibm.com>
References: <20070907131929.158477442@mai.lab.toulouse-stg.fr.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 07 Sep 2007 15:19:30 +0200
From: dlezcano@fr.ibm.com
To: linux-kernel@vger.kernel.org
Subject: [GIT - resend][patch 1/1] Fix typos in Kconfig
Content-Disposition: inline; filename=2.6-git-fix-Kconfig.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Lezcano <dlezcano@fr.ibm.com>

Signed-off-by: Daniel Lezcano <dlezcano@fr.ibm.com>

---
 drivers/input/misc/Kconfig |    2 +-
 drivers/leds/Kconfig       |    2 +-
 drivers/telephony/Kconfig  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

Index: 2.6-git/drivers/input/misc/Kconfig
===================================================================
--- 2.6-git.orig/drivers/input/misc/Kconfig
+++ 2.6-git/drivers/input/misc/Kconfig
@@ -152,7 +152,7 @@
 
 config INPUT_YEALINK
 	tristate "Yealink usb-p1k voip phone"
-	depends EXPERIMENTAL
+	depends on EXPERIMENTAL
 	depends on USB_ARCH_HAS_HCD
 	select USB
 	help
Index: 2.6-git/drivers/leds/Kconfig
===================================================================
--- 2.6-git.orig/drivers/leds/Kconfig
+++ 2.6-git/drivers/leds/Kconfig
@@ -83,7 +83,7 @@
 
 config LEDS_H1940
 	tristate "LED Support for iPAQ H1940 device"
-	depends LEDS_CLASS && ARCH_H1940
+	depends on LEDS_CLASS && ARCH_H1940
 	help
 	  This option enables support for the LEDs on the h1940.
 
Index: 2.6-git/drivers/telephony/Kconfig
===================================================================
--- 2.6-git.orig/drivers/telephony/Kconfig
+++ 2.6-git/drivers/telephony/Kconfig
@@ -19,7 +19,7 @@
 
 config PHONE_IXJ
 	tristate "QuickNet Internet LineJack/PhoneJack support"
-	depends ISA || PCI
+	depends on ISA || PCI
 	---help---
 	  Say M if you have a telephony card manufactured by Quicknet
 	  Technologies, Inc.  These include the Internet PhoneJACK and

-- 
