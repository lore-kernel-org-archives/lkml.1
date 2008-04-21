Return-Path: <linux-kernel-owner+w=401wt.eu-S1760261AbYDUNtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760261AbYDUNtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754398AbYDUNtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:49:09 -0400
Received: from mail.atmel.fr ([81.80.104.162]:53585 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624AbYDUNtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:49:06 -0400
Message-ID: <480C9B40.20109@atmel.com>
Date: Mon, 21 Apr 2008 15:48:48 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: ARM Linux Mailing List <linux-arm-kernel@lists.arm.linux.org.uk>,
       Andrew Victor <linux@maxim.org.za>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: AT91: at91sam9263_devices typo
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

at91sam9263_devices mci typo

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Andrew, should I send it directly to the patch system or 
will you integrate it in your tree ?

--- a/arch/arm/mach-at91/at91sam9263_devices.c
+++ b/arch/arm/mach-at91/at91sam9263_devices.c
@@ -308,7 +308,7 @@
 		}
 
 		mmc0_data = *data;
-		at91_clock_associate("mci0_clk", &at91sam9263_mmc1_device.dev, "mci_clk");
+		at91_clock_associate("mci0_clk", &at91sam9263_mmc0_device.dev, "mci_clk");
 		platform_device_register(&at91sam9263_mmc0_device);
 	} else {			/* MCI1 */
 		/* CLK */



