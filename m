Return-Path: <linux-kernel-owner+w=401wt.eu-S1755161AbYFTLHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbYFTLHd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 07:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbYFTLHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 07:07:24 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:57902 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751821AbYFTLHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 07:07:24 -0400
Subject: MMC: correct card drivers MODULE_LICENSE() statements
Message-Id: <20080620110702.706950986@fluff.org.uk>
User-Agent: quilt/0.46-1
From: ben@fluff.org.uk
To: linux-kernel@vger.kernel.org
Cc: drzeus-mmc@drzeus.cx, Nicolas Pitre <nico@cam.org>,
       Ben Dooks <ben-linux@fluff.org>
Content-Disposition: inline; filename=simtec/sdmmc-card-license-updates.patch
Date: Fri, 20 Jun 2008 12:07:02 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both the mmc_test and sdio_uart drivers' headers show that
they are licenses under GPL version 2, but the MODULE_LICENSE
statements say "GPL". Change the licensing statement to better
reflect their licensing.

CC: Nicolas Pitre <nico@cam.org>
Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc6-sdmmc3/drivers/mmc/card/mmc_test.c
===================================================================
--- linux-2.6.26-rc6-sdmmc3.orig/drivers/mmc/card/mmc_test.c	2008-06-20 12:03:32.000000000 +0100
+++ linux-2.6.26-rc6-sdmmc3/drivers/mmc/card/mmc_test.c	2008-06-20 12:03:38.000000000 +0100
@@ -893,6 +893,6 @@ static void __exit mmc_test_exit(void)
 module_init(mmc_test_init);
 module_exit(mmc_test_exit);
 
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("Multimedia Card (MMC) host test driver");
 MODULE_AUTHOR("Pierre Ossman");
Index: linux-2.6.26-rc6-sdmmc3/drivers/mmc/card/sdio_uart.c
===================================================================
--- linux-2.6.26-rc6-sdmmc3.orig/drivers/mmc/card/sdio_uart.c	2008-06-20 12:02:57.000000000 +0100
+++ linux-2.6.26-rc6-sdmmc3/drivers/mmc/card/sdio_uart.c	2008-06-20 12:03:06.000000000 +0100
@@ -1155,4 +1155,4 @@ module_init(sdio_uart_init);
 module_exit(sdio_uart_exit);
 
 MODULE_AUTHOR("Nicolas Pitre");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
