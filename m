Return-Path: <linux-kernel-owner+w=401wt.eu-S1765556AbXHHJ6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765556AbXHHJ6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 05:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760921AbXHHJ6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 05:58:20 -0400
Received: from mail.atmel.fr ([81.80.104.162]:61028 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759571AbXHHJ6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 05:58:18 -0400
Message-ID: <46B9926B.3090707@rfo.atmel.com>
Date: Wed, 08 Aug 2007 11:52:43 +0200
From: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Organization: atmel
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
CC: =?windows-1252?Q?=3F=3F?= <wux@landicorp.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: [PATCH] mmc: at91_mci: add multiwrite cap
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Xuan <wux@landicorp.com>

Add multiwrite support capability.

Signed-off-by: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
---
One liner

Has been in Andrew Victor's patchset for a long time.

Index: b/drivers/mmc/host/at91_mci.c
===================================================================
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -836,7 +836,7 @@ static int __init at91_mci_probe(struct 
 	mmc->f_min = 375000;
 	mmc->f_max = 25000000;
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
-	mmc->caps = MMC_CAP_BYTEBLOCK;
+	mmc->caps = MMC_CAP_BYTEBLOCK | MMC_CAP_MULTIWRITE;
 
 	mmc->max_blk_size = 4095;
 	mmc->max_blk_count = mmc->max_req_size;


