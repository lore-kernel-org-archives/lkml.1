Return-Path: <linux-kernel-owner+w=401wt.eu-S1753779AbYCJQhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbYCJQhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 12:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750992AbYCJQhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 12:37:03 -0400
Received: from mail.atmel.fr ([81.80.104.162]:55499 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbYCJQhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 12:37:01 -0400
Message-ID: <47D5639A.3090609@atmel.com>
Date: Mon, 10 Mar 2008 17:36:42 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: linux-fbdev-devel@lists.sourceforge.net,
       Linux Kernel list <linux-kernel@vger.kernel.org>
CC: ARM Linux Mailing List <linux-arm-kernel@lists.arm.linux.org.uk>,
       Andrew Victor <linux@maxim.org.za>,
       Sedji GAOUAOU <sedji.gaouaou@atmel.com>,
       Patrice VILCHEZ <patrice.vilchez@atmel.com>
Subject: [PATCH] atmel_lcdfb: adjust fifo size for at91sam9rl
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AT91SAM9RL soc has a 2048 bytes deep FIFO, like AT91SAM9263.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---

--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -30,7 +30,7 @@
 #define ATMEL_LCDC_CVAL_DEFAULT		0xc8
 #define ATMEL_LCDC_DMA_BURST_LEN	8
 
-#if defined(CONFIG_ARCH_AT91SAM9263)
+#if defined(CONFIG_ARCH_AT91SAM9263) || defined(CONFIG_ARCH_AT91SAM9RL)
 #define ATMEL_LCDC_FIFO_SIZE		2048
 #else
 #define ATMEL_LCDC_FIFO_SIZE		512

