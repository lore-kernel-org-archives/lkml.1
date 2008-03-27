Return-Path: <linux-kernel-owner+w=401wt.eu-S1758420AbYCZK3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758420AbYCZK3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 06:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757837AbYCZK2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 06:28:33 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:51352 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243AbYCZK2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 06:28:32 -0400
X-IronPort-AV: E=Sophos;i="4.25,557,1199682000"; 
   d="scan'208";a="50790837"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Cc: Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/3] Blackfin SPI driver: fix breakage cause by overzealous line wrapping and only pass in 1 format string
Date: Wed, 26 Mar 2008 18:28:30 -0700
Message-Id: <1206581312-25869-2-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/spi/spi_bfin5xx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index d853fce..c93c9d6 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -713,8 +713,8 @@ static void pump_transfers(unsigned long data)
 	} else {
 		drv_data->len = transfer->len;
 	}
-	dev_dbg(&drv_data->pdev->dev, "transfer: ",
-		"drv_data->write is %p, chip->write is %p, null_wr is %p\n",
+	dev_dbg(&drv_data->pdev->dev,
+		"transfer: drv_data->write is %p, chip->write is %p, null_wr is %p\n",
 		drv_data->write, chip->write, null_writer);
 
 	/* speed and width has been set on per message */
-- 
1.5.4.3
