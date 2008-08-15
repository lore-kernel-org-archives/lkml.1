Return-Path: <linux-kernel-owner+w=401wt.eu-S1757935AbYHOIer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935AbYHOIer (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 04:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753850AbYHOIeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 04:34:36 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:23647 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197AbYHOIeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 04:34:36 -0400
X-IronPort-AV: E=Sophos;i="4.32,214,1217822400"; 
   d="scan'208";a="58086231"
From: Bryan Wu <cooloney@kernel.org>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/1] MTD Maps: make uclinux mapping driver depend on MTD_RAM since it only probes that
Date: Fri, 15 Aug 2008 16:26:07 +0800
Message-Id: <1218788767-8916-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
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
index df8e00b..50bb046 100644
--- a/drivers/mtd/maps/Kconfig
+++ b/drivers/mtd/maps/Kconfig
@@ -522,7 +522,7 @@ config MTD_BFIN_ASYNC
 
 config MTD_UCLINUX
 	tristate "Generic uClinux RAM/ROM filesystem support"
-	depends on MTD_PARTITIONS && !MMU
+	depends on MTD_PARTITIONS && MTD_RAM && !MMU
 	help
 	  Map driver to support image based filesystems for uClinux.
 
-- 
1.5.6
