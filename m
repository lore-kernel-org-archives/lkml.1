Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543AbZEHNxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbZEHNxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 09:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbZEHNx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 09:53:27 -0400
Received: from gate.crashing.org ([63.228.1.57]:54017 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481AbZEHNx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 09:53:27 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: pierre@ossman.eu
Cc: avorontsov@ru.mvista.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] mmc: Add fsl,esdhc as a valid compatible to bind against
Date: Fri,  8 May 2009 08:52:49 -0500
Message-Id: <1241790769-3843-1-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We plan to use fsl,esdhc going forward as the base compatible so update
the driver to bind against it.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 drivers/mmc/host/sdhci-of.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/sdhci-of.c b/drivers/mmc/host/sdhci-of.c
index 3ff4ac3..09cc597 100644
--- a/drivers/mmc/host/sdhci-of.c
+++ b/drivers/mmc/host/sdhci-of.c
@@ -277,6 +277,7 @@ static int __devexit sdhci_of_remove(struct of_device *ofdev)
 static const struct of_device_id sdhci_of_match[] = {
 	{ .compatible = "fsl,mpc8379-esdhc", .data = &sdhci_esdhc, },
 	{ .compatible = "fsl,mpc8536-esdhc", .data = &sdhci_esdhc, },
+	{ .compatible = "fsl,esdhc", .data = &sdhci_esdhc, },
 	{ .compatible = "generic-sdhci", },
 	{},
 };
-- 
1.6.0.6

