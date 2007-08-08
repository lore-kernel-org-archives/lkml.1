Return-Path: <linux-kernel-owner+w=401wt.eu-S932187AbXHHKEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187AbXHHKEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 06:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762107AbXHHKCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 06:02:20 -0400
Received: from mail.atmel.fr ([81.80.104.162]:33597 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761568AbXHHKCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 06:02:19 -0400
Message-ID: <46B99488.4000908@rfo.atmel.com>
Date: Wed, 08 Aug 2007 12:01:44 +0200
From: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Organization: atmel
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
CC: Andrew Victor <andrew@sanpeople.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: [PATCH] mmc: at91_mci: remove whitespace at the end of lines
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some cleanup with whitespace/tab at the end of lines.

Signed-off-by: Nicolas Ferre <nicolas.ferre@rfo.atmel.com> 
---

Index: b/drivers/mmc/host/at91_mci.c
===================================================================
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -83,7 +83,7 @@
 
 #define AT91_MCI_ERRORS	(AT91_MCI_RINDE | AT91_MCI_RDIRE | AT91_MCI_RCRCE	\
 		| AT91_MCI_RENDE | AT91_MCI_RTOE | AT91_MCI_DCRCE		\
-		| AT91_MCI_DTOE | AT91_MCI_OVRE | AT91_MCI_UNRE)			
+		| AT91_MCI_DTOE | AT91_MCI_OVRE | AT91_MCI_UNRE)
 
 #define at91_mci_read(host, reg)	__raw_readl((host)->baseaddr + (reg))
 #define at91_mci_write(host, reg, val)	__raw_writel((val), (host)->baseaddr + (reg))
@@ -676,15 +676,15 @@ static irqreturn_t at91_mci_irq(int irq,
 
 	int_status = at91_mci_read(host, AT91_MCI_SR);
 	int_mask = at91_mci_read(host, AT91_MCI_IMR);
-	
+
 	pr_debug("MCI irq: status = %08X, %08X, %08X\n", int_status, int_mask,
 		int_status & int_mask);
-	
+
 	int_status = int_status & int_mask;
 
 	if (int_status & AT91_MCI_ERRORS) {
 		completed = 1;
-		
+
 		if (int_status & AT91_MCI_UNRE)
 			pr_debug("MMC: Underrun error\n");
 		if (int_status & AT91_MCI_OVRE)

