Return-Path: <linux-kernel-owner+w=401wt.eu-S1761470AbXISPoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761470AbXISPoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 11:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753012AbXISPnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 11:43:40 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:41619 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760740AbXISPng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 11:43:36 -0400
X-IronPort-AV: i="4.20,274,1186372800"; 
   d="scan'208"; a="51816367:sNHT245052563"
Subject: [PATCH 4/4] Blackfin EMAC driver: add a select for the PHYLIB of
	this driver
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Robin Getz <robin.getz@analog.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Wed, 19 Sep 2007 23:37:41 +0800
Message-Id: <1190216261.15707.31.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 19 Sep 2007 15:37:49.0492 (UTC) FILETIME=[08BBD740:01C7FAD3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Since we are adding requirement for the PHYLIB for this driver, there should be a select for that

Cc: Robin Getz <robin.getz@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/net/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index fd284a9..ebba92d 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -838,6 +838,8 @@ config BFIN_MAC
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

