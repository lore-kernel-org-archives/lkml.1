Return-Path: <linux-kernel-owner+w=401wt.eu-S932143AbXGaRx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143AbXGaRx0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 13:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbXGaRxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 13:53:18 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1531 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742AbXGaRxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 13:53:17 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 29] drivers/mmc/core/host.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 19:53:16 +0200
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
Message-Id: <200707311953.17224.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/mmc/core/host.c | 3509 -> 3457 (-52 bytes)
 drivers/mmc/core/host.o | 92400 -> 92136 (-264 bytes)

 drivers/mmc/core/host.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/mmc/core/host.c	2007-07-26 13:07:43.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/mmc/core/host.c	2007-07-30 00:22:12.000000000 +0200
@@ -58,12 +58,10 @@ struct mmc_host *mmc_alloc_host(int extr
 {
 	struct mmc_host *host;

-	host = kmalloc(sizeof(struct mmc_host) + extra, GFP_KERNEL);
+	host = kzalloc(sizeof(struct mmc_host) + extra, GFP_KERNEL);
 	if (!host)
 		return NULL;

-	memset(host, 0, sizeof(struct mmc_host) + extra);
-
 	host->parent = dev;
 	host->class_dev.parent = dev;
 	host->class_dev.class = &mmc_host_class;
