Return-Path: <linux-kernel-owner+w=401wt.eu-S1760629AbZFWP5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760629AbZFWP5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759297AbZFWP5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:57:11 -0400
Received: from mail.atmel.fr ([81.80.104.162]:45004 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757654AbZFWP5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:57:10 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-usb@vger.kernel.org, avictor.za@gmail.com
Cc: linux-kernel@vger.kernel.org, david-b@pacbell.net,
       haavard.skinnemoen@atmel.com, patrice.vilchez@atmel.com,
       linux-arm-kernel@lists.arm.linux.org.uk, nicolas.ferre@atmel.com
Subject: [PATCH 1/3 v3] at91/USB: Add USB gadget driver selection for at91sam9g45 series
Date: Tue, 23 Jun 2009 18:58:35 +0200
Message-Id: <1245776317-7134-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <200906190045.16496.david-b@pacbell.net>
References: <200906190045.16496.david-b@pacbell.net>
Message-Id: <6af1745bf0de30efbd68addd05c2670311c7743a.1245775871.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add gadget USB drivers for at91sam9g45 series. Those SOC include
high speed USB interfaces.
The gadget driver is the already available atmel_usba_udc.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
v2 -> v3: split patch to:
- gadget
- ohci
- ehci

 drivers/usb/gadget/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 080bb1e..9beea52 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -124,7 +124,7 @@ choice
 
 config USB_GADGET_AT91
 	boolean "Atmel AT91 USB Device Port"
-	depends on ARCH_AT91 && !ARCH_AT91SAM9RL && !ARCH_AT91CAP9
+	depends on ARCH_AT91 && !ARCH_AT91SAM9RL && !ARCH_AT91CAP9 && !ARCH_AT91SAM9G45
 	select USB_GADGET_SELECTED
 	help
 	   Many Atmel AT91 processors (such as the AT91RM2000) have a
@@ -143,7 +143,7 @@ config USB_AT91
 config USB_GADGET_ATMEL_USBA
 	boolean "Atmel USBA"
 	select USB_GADGET_DUALSPEED
-	depends on AVR32 || ARCH_AT91CAP9 || ARCH_AT91SAM9RL
+	depends on AVR32 || ARCH_AT91CAP9 || ARCH_AT91SAM9RL || ARCH_AT91SAM9G45
 	help
 	  USBA is the integrated high-speed USB Device controller on
 	  the AT32AP700x, some AT91SAM9 and AT91CAP9 processors from Atmel.
-- 
1.5.3.7

