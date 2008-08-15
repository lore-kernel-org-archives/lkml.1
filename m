Return-Path: <linux-kernel-owner+w=401wt.eu-S1758421AbYHOJM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758421AbYHOJM2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 05:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754350AbYHOJL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 05:11:27 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:52441 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbYHOJLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 05:11:25 -0400
X-IronPort-AV: E=Sophos;i="4.32,214,1217822400"; 
   d="scan'208";a="58087369"
From: Bryan Wu <cooloney@kernel.org>
To: a.zummo@towertech.it, rtc-linux@googlegroups.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Graf Yang <graf.yang@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 3/4] Blackfin RTC Driver: BF561 not have on-chip RTC
Date: Fri, 15 Aug 2008 17:01:19 +0800
Message-Id: <1218790880-12477-4-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1218790880-12477-1-git-send-email-cooloney@kernel.org>
References: <1218790880-12477-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/rtc/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 90ab738..9a9755c 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -561,7 +561,7 @@ config RTC_DRV_AT91SAM9_GPBR
 
 config RTC_DRV_BFIN
 	tristate "Blackfin On-Chip RTC"
-	depends on BLACKFIN
+	depends on BLACKFIN && !BF561
 	help
 	  If you say yes here you will get support for the
 	  Blackfin On-Chip Real Time Clock.
-- 
1.5.6
