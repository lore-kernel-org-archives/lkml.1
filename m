Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbXIQDYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbXIQDYf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 23:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbXIQDYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 23:24:25 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:14926 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbXIQDYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 23:24:24 -0400
X-IronPort-AV: i="4.20,262,1186372800"; 
   d="scan'208"; a="51588334:sNHT32141375"
Subject: [PATCH] Blackfin EMAC driver: add a select for the PHYLIB of this
	driver
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Robin Getz <rgetz@blackfin.uclinux.org>, jeff@garzik.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <200709162251.01558.rgetz@blackfin.uclinux.org>
References: <1189911475.9901.8.camel@roc-laptop>
	 <200709162251.01558.rgetz@blackfin.uclinux.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Mon, 17 Sep 2007 11:20:20 +0800
Message-Id: <1189999220.7800.4.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 17 Sep 2007 03:24:21.0561 (UTC) FILETIME=[3D22FA90:01C7F8DA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since we are adding requirement for the PHYLIB for this driver, there should be a select for that

Cc: Robin Getz <robin.getz@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/net/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 5b9e17b..5eef224 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -843,6 +843,8 @@ config BFIN_MAC
 	tristate "Blackfin 536/537 on-chip mac support"
 	depends on NET_ETHERNET && (BF537 || BF536) && (!BF537_PORT_H)
 	select CRC32
+	select MII
+	select PHYLIB
 	select BFIN_MAC_USE_L1 if DMA_UNCACHED_NONE
 	help
 	  This is the driver for blackfin on-chip mac device. Say Y if you want it
-- 
1.5.2

