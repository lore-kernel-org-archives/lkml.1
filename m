Return-Path: <linux-kernel-owner+w=401wt.eu-S1759163AbZBEKGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759163AbZBEKGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 05:06:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757210AbZBEKFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 05:05:47 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:29526 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009AbZBEKFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 05:05:43 -0500
X-IronPort-AV: E=Sophos;i="4.37,384,1231131600"; 
   d="scan'208";a="82351962"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 2/5] Blackfin SPI Driver: add comment about full duplex dma according to David Brownell
Date: Thu,  5 Feb 2009 18:07:30 +0800
Message-Id: <1233828453-13311-3-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1233828453-13311-1-git-send-email-cooloney@kernel.org>
References: <1233828453-13311-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/spi/spi_bfin5xx.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 74c5bb9..ce24d5e 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -766,9 +766,10 @@ static void bfin_spi_pump_transfers(unsigned long data)
 		width, transfer->len);
 
 	/*
-	 * Try to map dma buffer and do a dma transfer if
-	 * successful use different way to r/w according to
-	 * drv_data->cur_chip->enable_dma
+	 * Try to map dma buffer and do a dma transfer.  If successful use,
+	 * different way to r/w according to the enable_dma settings and if
+	 * we are not doing a full duplex transfer (since the hardware does
+	 * not support full duplex DMA transfers).
 	 */
 	if (!full_duplex && drv_data->cur_chip->enable_dma
 				&& drv_data->len > 6) {
-- 
1.5.6.3
