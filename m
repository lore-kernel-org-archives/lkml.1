Return-Path: <linux-kernel-owner+w=401wt.eu-S935093AbXGaV6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935093AbXGaV6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935017AbXGaV6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:58:37 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2101 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935010AbXGaV6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:58:35 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 69] drivers/net/sb1250-mac.c: kmalloc + memset conversion to kcalloc
Date: Tue, 31 Jul 2007 23:58:36 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       jgarzik@pobox.com, netdev@vger.kernel.org
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707312358.36567.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/net/sb1250-mac.c | 76286 -> 76199 (-87 bytes)

 drivers/net/sb1250-mac.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/net/sb1250-mac.c	2007-07-26 13:07:43.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/net/sb1250-mac.c	2007-07-31 13:46:10.000000000 +0200
@@ -779,10 +779,8 @@ static void sbdma_initctx(sbmacdma_t *d,
 	 * And context table
 	 */

-	d->sbdma_ctxtable = (struct sk_buff **)
-		kmalloc(d->sbdma_maxdescr*sizeof(struct sk_buff *), GFP_KERNEL);
-
-	memset(d->sbdma_ctxtable,0,d->sbdma_maxdescr*sizeof(struct sk_buff *));
+	d->sbdma_ctxtable = kcalloc(d->sbdma_maxdescr,
+				    sizeof(struct sk_buff *), GFP_KERNEL);

 #ifdef CONFIG_SBMAC_COALESCE
 	/*
