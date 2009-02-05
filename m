Return-Path: <linux-kernel-owner+w=401wt.eu-S1758640AbZBEIZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640AbZBEIZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 03:25:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757095AbZBEIZC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 03:25:02 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:64357 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756662AbZBEIZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 03:25:00 -0500
X-IronPort-AV: E=Sophos;i="4.37,384,1231131600"; 
   d="scan'208";a="82346616"
From: Bryan Wu <cooloney@kernel.org>
To: dwmw2@infradead.org
Cc: inux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 2/3] mtd/maps: blackfin async flash maps: bfin-async mtd driver needs complex mappings
Date: Thu,  5 Feb 2009 16:26:50 +0800
Message-Id: <1233822411-10210-3-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1233822411-10210-1-git-send-email-cooloney@kernel.org>
References: <1233822411-10210-1-git-send-email-cooloney@kernel.org>
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
index 0225cbb..043d50f 100644
--- a/drivers/mtd/maps/Kconfig
+++ b/drivers/mtd/maps/Kconfig
@@ -491,7 +491,7 @@ config MTD_PCMCIA_ANONYMOUS
 
 config MTD_BFIN_ASYNC
 	tristate "Blackfin BF533-STAMP Flash Chip Support"
-	depends on BFIN533_STAMP && MTD_CFI
+	depends on BFIN533_STAMP && MTD_CFI && MTD_COMPLEX_MAPPINGS
 	select MTD_PARTITIONS
 	default y
 	help
-- 
1.5.6.3
