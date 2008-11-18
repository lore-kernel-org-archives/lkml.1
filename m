Return-Path: <linux-kernel-owner+w=401wt.eu-S1751946AbYKRHcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbYKRHcj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 02:32:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbYKRHby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 02:31:54 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:10625 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbYKRHbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 02:31:52 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62689567"
From: Bryan Wu <cooloney@kernel.org>
To: dwmw2@infradead.org, linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 2/2] mtd/maps: bfin-async mtd driver needs complex mappings
Date: Tue, 18 Nov 2008 15:33:17 +0800
Message-Id: <1226993597-31998-3-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1226993597-31998-1-git-send-email-cooloney@kernel.org>
References: <1226993597-31998-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/mtd/maps/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
index 5ea1693..db68e70 100644
--- a/drivers/mtd/maps/Kconfig
+++ b/drivers/mtd/maps/Kconfig
@@ -480,7 +480,7 @@ config MTD_PCMCIA_ANONYMOUS
 
 config MTD_BFIN_ASYNC
 	tristate "Blackfin BF533-STAMP Flash Chip Support"
-	depends on BFIN533_STAMP && MTD_CFI
+	depends on BFIN533_STAMP && MTD_CFI && MTD_COMPLEX_MAPPINGS
 	select MTD_PARTITIONS
 	default y
 	help
-- 
1.5.6.3
