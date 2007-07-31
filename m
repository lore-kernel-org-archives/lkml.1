Return-Path: <linux-kernel-owner+w=401wt.eu-S934936AbXGaWFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934936AbXGaWFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 18:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761468AbXGaWFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 18:05:25 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2452 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758625AbXGaWFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 18:05:24 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 72] drivers/mmc/core/sdio_bus.c: kmalloc + memset conversion to kzalloc
Date: Wed, 1 Aug 2007 00:05:24 +0200
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
Message-Id: <200708010005.25352.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/mmc/core/sdio_bus.c | 5528 -> 5483 (-45 bytes)
 drivers/mmc/core/sdio_bus.o | 70044 -> 69876 (-168 bytes)

 drivers/mmc/core/sdio_bus.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/mmc/core/sdio_bus.c	2007-07-26 13:07:43.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/mmc/core/sdio_bus.c	2007-07-30 00:22:42.000000000 +0200
@@ -203,12 +203,10 @@ struct sdio_func *sdio_alloc_func(struct
 {
 	struct sdio_func *func;

-	func = kmalloc(sizeof(struct sdio_func), GFP_KERNEL);
+	func = kzalloc(sizeof(struct sdio_func), GFP_KERNEL);
 	if (!func)
 		return ERR_PTR(-ENOMEM);

-	memset(func, 0, sizeof(struct sdio_func));
-
 	func->card = card;

 	device_initialize(&func->dev);
