Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965AbZCLQYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbZCLQYv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 12:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757490AbZCLQX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 12:23:27 -0400
Received: from smtp.nokia.com ([192.100.122.230]:25222 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757451AbZCLQXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 12:23:24 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       David Brownell <david-b@pacbell.net>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>, lkml <linux-kernel@vger.kernel.org>
Date: Thu, 12 Mar 2009 18:23:33 +0200
Message-Id: <20090312162333.19421.71337.sendpatchset@ahunter-laptop>
In-Reply-To: <20090312162252.19421.34019.sendpatchset@ahunter-laptop>
References: <20090312162252.19421.34019.sendpatchset@ahunter-laptop>
Subject: [PATCH 6/10] OMAP: HSMMC: Do not prefix slot name
X-OriginalArrivalTime: 12 Mar 2009 16:23:08.0513 (UTC) FILETIME=[D4768510:01C9A32E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From b75cdf95103d5a76966bd505d9b945c47613613d Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@nokia.com>
Date: Fri, 30 Jan 2009 10:59:31 +0200
Subject: [PATCH] OMAP: HSMMC: Do not prefix slot name

Allow slot_name to be the same as the other OMAP
driver, by removing the redundant "slot:" prefix.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 drivers/mmc/host/omap_hsmmc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index f3e4e0f..7a9ca4f 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -216,7 +216,7 @@ mmc_omap_show_slot_name(struct device *dev, struct device_attribute *attr,
 	struct mmc_omap_host *host = mmc_priv(mmc);
 	struct omap_mmc_slot_data slot = host->pdata->slots[host->slot_id];
 
-	return sprintf(buf, "slot:%s\n", slot.name);
+	return sprintf(buf, "%s\n", slot.name);
 }
 
 static DEVICE_ATTR(slot_name, S_IRUGO, mmc_omap_show_slot_name, NULL);
-- 
1.5.6.3

