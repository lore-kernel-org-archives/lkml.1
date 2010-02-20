Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453Ab0BTAML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 19:12:11 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:8053 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab0BTAMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 19:12:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=auY7qK3dEj7LMpOmNmXR9mCUm4/vqb0LuP6JF88dydAdKnAbbzeVLc+aBN8RVhUeIJ
         1uugTRTX6L7pfk8FcfwKWDp+7ZRzC5lGn026RMpHVTFCRR7ccXYqQFZR2hxCEap/8oTe
         iukGDfyq2ocsdlw+DCzXzanmPQYW9z2kN8SmU=
Message-ID: <4B7F2AA8.3010302@gmail.com>
Date: Sat, 20 Feb 2010 01:19:52 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linus.walleij@stericsson.com
Subject: [PATCH] ARM: misplaced parentheses?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The parentheses appear misplaced.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Correct?

diff --git a/arch/arm/mach-u300/gpio.c b/arch/arm/mach-u300/gpio.c
index 0b35826..5f61fd4 100644
--- a/arch/arm/mach-u300/gpio.c
+++ b/arch/arm/mach-u300/gpio.c
@@ -546,7 +546,7 @@ static void gpio_set_initial_values(void)
 	for (i = 0; i < U300_GPIO_MAX; i++) {
 		val = 0;
 		for (j = 0; j < 8; j++)
-			val |= (u32)((u300_gpio_config[i][j].pull_up == DISABLE_PULL_UP)) << j;
+			val |= (u32)((u300_gpio_config[i][j].pull_up == DISABLE_PULL_UP) << j);
 		local_irq_save(flags);
 		writel(val, virtbase + U300_GPIO_PXPER + i * U300_GPIO_PORTX_SPACING);
 		local_irq_restore(flags);
