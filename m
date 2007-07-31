Return-Path: <linux-kernel-owner+w=401wt.eu-S1755140AbXGaRAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140AbXGaRAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 13:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751393AbXGaRAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 13:00:01 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2253 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbXGaRAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 13:00:00 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 05] drivers/mmc/core/bus.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 18:59:59 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       drzeus-mmc@drzeus.cx
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311900.00143.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/mmc/core/bus.c | 5663 -> 5619 (-44 bytes)
 drivers/mmc/core/bus.o | 70899 -> 70731 (-168 bytes)

 drivers/mmc/core/bus.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/mmc/core/bus.c	2007-07-26 13:07:43.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/mmc/core/bus.c	2007-07-30 00:23:02.000000000 +0200
@@ -206,12 +206,10 @@ struct mmc_card *mmc_alloc_card(struct m
 {
 	struct mmc_card *card;

-	card = kmalloc(sizeof(struct mmc_card), GFP_KERNEL);
+	card = kzalloc(sizeof(struct mmc_card), GFP_KERNEL);
 	if (!card)
 		return ERR_PTR(-ENOMEM);

-	memset(card, 0, sizeof(struct mmc_card));
-
 	card->host = host;

 	device_initialize(&card->dev);
