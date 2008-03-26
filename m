Return-Path: <linux-kernel-owner+w=401wt.eu-S1760417AbYCZUN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760417AbYCZUN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 16:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757442AbYCZUMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 16:12:37 -0400
Received: from smtp.nokia.com ([192.100.105.134]:62245 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbYCZUM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 16:12:29 -0400
Message-ID: <47EAAD4D.1020708@indt.org.br>
Date: Wed, 26 Mar 2008 16:08:45 -0400
From: Carlos Aguiar <carlos.aguiar@indt.org.br>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: ext Pierre Ossman <drzeus-list@drzeus.cx>
CC: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 02/18] MMC: OMAP: Remove extra divisor increase
References: <47DAD39C.90405@indt.org.br> <20080324132631.1e0d2125@mjolnir.drzeus.cx>
In-Reply-To: <20080324132631.1e0d2125@mjolnir.drzeus.cx>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Mar 2008 20:11:28.0030 (UTC) FILETIME=[9304ABE0:01C88F7D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

As noted by Kyungmin Park, the divisor calculation has
an unnecessary increase.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
---
 drivers/mmc/host/omap.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index eb7175a..d02f67b 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -931,7 +931,6 @@ static int mmc_omap_calc_divisor(struct mmc_host *mmc, struct mmc_ios *ios)
 
 	if (dsor > 250)
 		dsor = 250;
-	dsor++;
 
 	if (ios->bus_width == MMC_BUS_WIDTH_4)
 		dsor |= 1 << 15;
-- 1.5.3.GIT

