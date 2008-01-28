Return-Path: <linux-kernel-owner+w=401wt.eu-S1762474AbYA1TLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762474AbYA1TLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 14:11:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761760AbYA1TJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 14:09:45 -0500
Received: from smtp.nokia.com ([192.100.122.233]:23415 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762021AbYA1TJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:09:43 -0500
Message-ID: <479E27DE.2060003@indt.org.br>
Date: Mon, 28 Jan 2008 15:07:10 -0400
From: Carlos Aguiar <carlos.aguiar@indt.org.br>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 02/18] MMC: OMAP: Remove extra divisor increase
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jan 2008 19:08:56.0321 (UTC) FILETIME=[3ADDCF10:01C861E1]
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
index 9374163..9b32110 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -937,7 +937,6 @@ static int mmc_omap_calc_divisor(struct mmc_host *mmc, struct mmc_ios *ios)
 
 	if (dsor > 250)
 		dsor = 250;
-	dsor++;
 
 	if (ios->bus_width == MMC_BUS_WIDTH_4)
 		dsor |= 1 << 15;
-- 1.5.3.GIT

