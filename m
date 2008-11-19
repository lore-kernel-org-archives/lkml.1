Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbYKSOGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbYKSOGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 09:06:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbYKSOG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 09:06:29 -0500
Received: from mo32.po.2iij.NET ([210.128.50.17]:2563 "EHLO mo32.po.2iij.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217AbYKSOG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 09:06:28 -0500
Date: Wed, 19 Nov 2008 23:06:19 +0900
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: yoichi_yuasa@tripeaks.co.jp,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] led: fix Cobalt Raq LED dependency
Message-Id: <20081119230619.546af573.yoichi_yuasa@tripeaks.co.jp>
Organization: TriPeaks Corporation
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cobalt Raq LEDs require LEDS_CLASS=y.

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

diff -pruN -X /home/yuasa/Memo/dontdiff linux-orig/drivers/leds/Kconfig linux/drivers/leds/Kconfig
--- linux-orig/drivers/leds/Kconfig	2008-11-10 10:13:15.609846727 +0900
+++ linux/drivers/leds/Kconfig	2008-11-10 11:22:43.602680128 +0900
@@ -77,7 +77,7 @@ config LEDS_COBALT_QUBE
 
 config LEDS_COBALT_RAQ
 	bool "LED Support for the Cobalt Raq series"
-	depends on LEDS_CLASS && MIPS_COBALT
+	depends on LEDS_CLASS=y && MIPS_COBALT
 	select LEDS_TRIGGERS
 	help
 	  This option enables support for the Cobalt Raq series LEDs.
