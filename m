Return-Path: <linux-kernel-owner+w=401wt.eu-S1763266AbXERWjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763266AbXERWjq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 18:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755721AbXERWjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 18:39:40 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3830 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755487AbXERWjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 18:39:39 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Victor <andrew@sanpeople.com>
Subject: [PATCH] arm: at91_adc parenthesis balance
Date: Sat, 19 May 2007 00:39:36 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705190039.37767.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	Trivial unbalanced parenthesis macro fix.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

diff -upr linux-2.6.22-rc1-mm1-a/include/asm-arm/arch-at91/at91_adc.h linux-2.6.22-rc1-mm1-b/include/asm-arm/arch-at91/at91_adc.h
--- linux-2.6.22-rc1-mm1-a/include/asm-arm/arch-at91/at91_adc.h	2007-05-16 17:54:07.000000000 +0200
+++ linux-2.6.22-rc1-mm1-b/include/asm-arm/arch-at91/at91_adc.h	2007-05-18 23:49:49.000000000 +0200
@@ -55,7 +55,7 @@
 #define AT91_ADC_IDR		0x28		/* Interrupt Disable Register */
 #define AT91_ADC_IMR		0x2C		/* Interrupt Mask Register */
 
-#define AT91_ADC_CHR(n)		(0x30 + ((n) * 4)	/* Channel Data Register N */
+#define AT91_ADC_CHR(n)		(0x30 + ((n) * 4))	/* Channel Data Register N */
 #define		AT91_ADC_DATA		(0x3ff)
 
 #endif
