Return-Path: <linux-kernel-owner+w=401wt.eu-S1754464AbZBNVQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbZBNVQk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 16:16:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754372AbZBNVOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 16:14:22 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:52585 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505AbZBNVOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 16:14:20 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 09/43] drivers/net/r6040.c: fix sparse warning: Using plain
	integer as NULL pointer
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 14 Feb 2009 22:14:04 +0100
Message-ID: <20090214211400.23489.24726.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warnings:
  drivers/net/r6040.c:487:31: warning: Using plain integer as NULL pointer
  drivers/net/r6040.c:492:31: warning: Using plain integer as NULL pointer

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/net/r6040.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/r6040.c b/drivers/net/r6040.c
index 3c27a7b..9c95ebe 100644
--- a/drivers/net/r6040.c
+++ b/drivers/net/r6040.c
@@ -484,12 +484,12 @@ static int r6040_close(struct net_device *dev)
 	/* Free Descriptor memory */
 	if (lp->rx_ring) {
 		pci_free_consistent(pdev, RX_DESC_SIZE, lp->rx_ring, lp->rx_ring_dma);
-		lp->rx_ring = 0;
+		lp->rx_ring = NULL;
 	}
 
 	if (lp->tx_ring) {
 		pci_free_consistent(pdev, TX_DESC_SIZE, lp->tx_ring, lp->tx_ring_dma);
-		lp->tx_ring = 0;
+		lp->tx_ring = NULL;
 	}
 
 	return 0;

