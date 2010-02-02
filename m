Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab0BBHYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:24:20 -0500
Received: from mail.perches.com ([173.55.12.10]:1766 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755345Ab0BBHWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:22:22 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org
Subject: [PATCH 02/10] drivers/ata: Fix continuation line formats
Date: Mon,  1 Feb 2010 23:22:08 -0800
Message-Id: <12d39ac4f14bfe82a02b4ee246d183b48988fe12.1265095094.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1265095093.git.joe@perches.com>
References: <cover.1265095093.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

String constants that are continued on subsequent lines with \
are not good.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/ata/pata_at91.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/pata_at91.c b/drivers/ata/pata_at91.c
index 41c94b1..d222c0d 100644
--- a/drivers/ata/pata_at91.c
+++ b/drivers/ata/pata_at91.c
@@ -153,8 +153,8 @@ static void pata_at91_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	/* Compute ATA timing and set it to SMC */
 	ret = ata_timing_compute(adev, adev->pio_mode, &timing, 1000, 0);
 	if (ret) {
-		dev_warn(ap->dev, "Failed to compute ATA timing %d, \
-				set PIO_0 timing\n", ret);
+		dev_warn(ap->dev, "Failed to compute ATA timing %d, set PIO_0 timing\n",
+			 ret);
 		set_smc_timing(ap->dev, info, &initial_timing);
 	} else {
 		set_smc_timing(ap->dev, info, &timing);
-- 
1.6.6.rc0.57.gad7a

