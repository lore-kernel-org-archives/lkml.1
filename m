Return-Path: <linux-kernel-owner+w=401wt.eu-S934861AbXGaWHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934861AbXGaWHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 18:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763548AbXGaWHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 18:07:04 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2459 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760811AbXGaWHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 18:07:01 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 73] drivers/parport/share.c: kmalloc + memset conversion to kzalloc
Date: Wed, 1 Aug 2007 00:07:02 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708010007.03181.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/parport/share.c | 29584 -> 29542 (-42 bytes)
 drivers/parport/share.o | 117775 -> 117795 (+20 bytes)

 drivers/parport/share.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/parport/share.c	2007-07-26 13:07:44.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/parport/share.c	2007-07-30 00:14:05.000000000 +0200
@@ -282,14 +282,13 @@ struct parport *parport_register_port(un
 	int device;
 	char *name;

-	tmp = kmalloc(sizeof(struct parport), GFP_KERNEL);
+	tmp = kzalloc(sizeof(struct parport), GFP_KERNEL);
 	if (!tmp) {
 		printk(KERN_WARNING "parport: memory squeeze\n");
 		return NULL;
 	}

 	/* Init our structure */
- 	memset(tmp, 0, sizeof(struct parport));
 	tmp->base = base;
 	tmp->irq = irq;
 	tmp->dma = dma;
