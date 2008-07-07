Return-Path: <linux-kernel-owner+w=401wt.eu-S1758047AbYGGV0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047AbYGGV0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 17:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756305AbYGGV0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 17:26:36 -0400
Received: from mail.queued.net ([207.210.101.209]:4756 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756246AbYGGV0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 17:26:35 -0400
Date: Mon, 7 Jul 2008 17:25:56 -0400
From: Andres Salomon <dilinger@queued.net>
To: drzeus-sdhci@drzeus.cx
Cc: sdhci-devel@list.drzeus.cx, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mmc: OLPC: update vdd/powerup quirk comment
Message-ID: <20080707172556.0a504c31@fred>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre,

Here are patches for two minor things that I had noticed while poking
around your -next branch.  Thanks for cleaning up that merge mess!




This comment update got lost in the great floo^Wmerge.  As Pierre
pointed out, no one knows what 'CaFe' is.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/mmc/host/sdhci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index cc11e63..267b0dd 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -978,7 +978,7 @@ static void sdhci_set_power(struct sdhci_host *host, unsigned short power)
 	}
 
 	/*
-	 * At least the CaFe chip gets confused if we set the voltage
+	 * At least the Marvell CaFe chip gets confused if we set the voltage
 	 * and set turn on power at the same time, so set the voltage first.
 	 */
 	if ((host->quirks & SDHCI_QUIRK_NO_SIMULT_VDD_AND_POWER))
-- 
1.5.5.3

