Return-Path: <linux-kernel-owner+w=401wt.eu-S1756960AbZCTNwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960AbZCTNwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 09:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbZCTNwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 09:52:00 -0400
Received: from smtp.nokia.com ([192.100.122.230]:48330 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679AbZCTNv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 09:51:59 -0400
From: Jani Nikula <ext-jani.1.nikula@nokia.com>
To: david-b@pacbell.net
Cc: linux-kernel@vger.kernel.org, juha.yrjola@solidboot.com,
       ext-jani.1.nikula@nokia.com
Subject: [RFC PATCH 3/3] GPIO-SWITCH: Kconfig and Makefile
Date: Fri, 20 Mar 2009 15:50:50 +0200
Message-Id: <2ab625459b0f92ce635c7065f32c7abc3a2c85d3.1237555607.git.ext-jani.1.nikula@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <c2a7291982d37847ef8670c7deeb8e95663d0ae2.1237555607.git.ext-jani.1.nikula@nokia.com>
References: <1237557050-13742-1-git-send-email-ext-jani.1.nikula@nokia.com>
 <0240a0c7d8fd8419ba1665f678978b0fa4c1a257.1237555607.git.ext-jani.1.nikula@nokia.com>
 <c2a7291982d37847ef8670c7deeb8e95663d0ae2.1237555607.git.ext-jani.1.nikula@nokia.com>
In-Reply-To: <0240a0c7d8fd8419ba1665f678978b0fa4c1a257.1237555607.git.ext-jani.1.nikula@nokia.com>
References: <0240a0c7d8fd8419ba1665f678978b0fa4c1a257.1237555607.git.ext-jani.1.nikula@nokia.com>
X-OriginalArrivalTime: 20 Mar 2009 13:51:49.0000 (UTC) FILETIME=[03F4C880:01C9A963]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new CONFIG_GPIO_SWITCH.

Signed-off-by: Jani Nikula <ext-jani.1.nikula@nokia.com>
---
 drivers/gpio/Kconfig  |   10 ++++++++++
 drivers/gpio/Makefile |    2 ++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 3d25654..a24b16e 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -63,6 +63,16 @@ config GPIO_SYSFS
 	  Kernel drivers may also request that a particular GPIO be
 	  exported to userspace; this can be useful when debugging.
 
+config GPIO_SWITCH
+	tristate "GPIO switch support"
+	depends on GPIO_SYSFS
+        default n
+        help
+          Say Y, if you want to have support for reporting of GPIO
+          switches (e.g. cover switches) via sysfs.
+
+	  If unsure, say N.
+
 # put expanders in the right section, in alphabetical order
 
 comment "Memory mapped GPIO expanders:"
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 49ac64e..02eaee8 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -12,3 +12,5 @@ obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
 obj-$(CONFIG_GPIO_TWL4030)	+= twl4030-gpio.o
 obj-$(CONFIG_GPIO_XILINX)	+= xilinx_gpio.o
 obj-$(CONFIG_GPIO_BT8XX)	+= bt8xxgpio.o
+
+obj-$(CONFIG_GPIO_SWITCH)	+= gpio-switch.o
-- 
1.6.0.4

