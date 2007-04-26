Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbXDZFHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbXDZFHp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 01:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754712AbXDZFHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 01:07:45 -0400
Received: from mo30.po.2iij.NET ([210.128.50.53]:13293 "EHLO mo30.po.2iij.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717AbXDZFHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 01:07:44 -0400
Date: Thu, 26 Apr 2007 14:07:33 +0900
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: yoichi_yuasa@tripeaks.co.jp,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] rename TANBAC TB0219 config
Message-Id: <20070426140733.2f8165c7.yoichi_yuasa@tripeaks.co.jp>
Organization: TriPeaks Corporation
X-Mailer: Sylpheed version 1.0.4 (GTK+ 1.2.10; i386-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This patch has renamed config of TANBAC TB0219 GPIO support.
It changed to an appropriate name. 

Yoichi

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

diff -pruN -X generic/Documentation/dontdiff generic-orig/drivers/char/Kconfig generic/drivers/char/Kconfig
--- generic-orig/drivers/char/Kconfig	2007-04-26 13:45:27.225157000 +0900
+++ generic/drivers/char/Kconfig	2007-04-26 13:58:56.663743750 +0900
@@ -905,8 +905,8 @@ config SONYPI
 	  To compile this driver as a module, choose M here: the
 	  module will be called sonypi.
 
-config TANBAC_TB0219
-	tristate "TANBAC TB0219 base board support"
+config GPIO_TB0219
+	tristate "TANBAC TB0219 GPIO support"
 	depends on TANBAC_TB022X
 	select GPIO_VR41XX
 
diff -pruN -X generic/Documentation/dontdiff generic-orig/drivers/char/Makefile generic/drivers/char/Makefile
--- generic-orig/drivers/char/Makefile	2007-04-26 13:45:27.345164500 +0900
+++ generic/drivers/char/Makefile	2007-04-26 13:43:30.361853500 +0900
@@ -91,7 +91,7 @@ obj-$(CONFIG_PC8736x_GPIO)	+= pc8736x_gp
 obj-$(CONFIG_NSC_GPIO)		+= nsc_gpio.o
 obj-$(CONFIG_CS5535_GPIO)	+= cs5535_gpio.o
 obj-$(CONFIG_GPIO_VR41XX)	+= vr41xx_giu.o
-obj-$(CONFIG_TANBAC_TB0219)	+= tb0219.o
+obj-$(CONFIG_GPIO_TB0219)	+= tb0219.o
 obj-$(CONFIG_TELCLOCK)		+= tlclk.o
 
 obj-$(CONFIG_WATCHDOG)		+= watchdog/
