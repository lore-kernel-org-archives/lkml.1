Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbYAQJJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbYAQJJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 04:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbYAQJJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 04:09:08 -0500
Received: from mail.atmel.fr ([81.80.104.162]:50037 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283AbYAQJJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 04:09:06 -0500
Message-ID: <478F1AFC.40404@atmel.com>
Date: Thu, 17 Jan 2008 10:08:12 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>
CC: Andrew Victor <linux@maxim.org.za>, David Brownell <david-b@pacbell.net>
Subject: [PATCH] AT91: correct at91sam9263ek LCD power gpio pin
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrects GPIO pin assignment for the LCD power control (PCI)

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/board-sam9263ek.c     |    4 ++--

--- a/arch/arm/mach-at91/board-sam9263ek.c
+++ b/arch/arm/mach-at91/board-sam9263ek.c
@@ -243,9 +243,9 @@ static struct fb_monspecs at91fb_default
 static void at91_lcdc_power_control(int on)
 {
 	if (on)
-		at91_set_gpio_value(AT91_PIN_PD12, 0);	/* power up */
+		at91_set_gpio_value(AT91_PIN_PA30, 1);	/* power up */
 	else
-		at91_set_gpio_value(AT91_PIN_PD12, 1);	/* power down */
+		at91_set_gpio_value(AT91_PIN_PA30, 0);	/* power down */
 }
 
 /* Driver datas */

