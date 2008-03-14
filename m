Return-Path: <linux-kernel-owner+w=401wt.eu-S1758737AbYCNTjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737AbYCNTjt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 15:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753937AbYCNTjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 15:39:14 -0400
Received: from smtp.nokia.com ([192.100.122.230]:50389 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbYCNTjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 15:39:12 -0400
Message-ID: <47DAD3A5.3020303@indt.org.br>
Date: Fri, 14 Mar 2008 15:36:05 -0400
From: Carlos Aguiar <carlos.aguiar@indt.org.br>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 02/18] MMC: OMAP: Remove extra divisor increase
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Mar 2008 19:38:45.0805 (UTC) FILETIME=[047BE5D0:01C8860B]
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

