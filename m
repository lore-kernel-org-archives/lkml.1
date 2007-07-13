Return-Path: <linux-kernel-owner+w=401wt.eu-S934035AbXGMALp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934035AbXGMALp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 20:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758031AbXGMALf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 20:11:35 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:59670 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754476AbXGMALe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 20:11:34 -0400
Date: Fri, 13 Jul 2007 02:12:08 +0200
From: Adrian Bunk <bunk@stusta.de>
To: jgarzik@pobox.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Donoghue <john.donoghue@ieee.org>
Subject: [2.6 patch] EP93XX_ETH must select MII
Message-ID: <20070713001208.GX3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Donoghue <john.donoghue@ieee.org>

CONFIG_EP93XX_ETH=y, CONFIG_MII=n results in an obvious link error.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.20.2.orig/drivers/net/arm/Kconfig	2007-03-09 22:32:46.000000000 -0500
+++ linux-2.6.20.2/drivers/net/arm/Kconfig	2007-03-09 22:50:43.000000000 -0500
@@ -43,6 +43,7 @@
 config EP93XX_ETH
 	tristate "EP93xx Ethernet support"
 	depends on ARM && ARCH_EP93XX
+	select MII
 	help
 	  This is a driver for the ethernet hardware included in EP93xx CPUs.
 	  Say Y if you are building a kernel for EP93xx based devices.

