Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbZKJJMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbZKJJMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 04:12:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754159AbZKJJM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 04:12:28 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34858 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593AbZKJJM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 04:12:26 -0500
From: Luotao Fu <l.fu@pengutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: spi-devel-general@lists.sourceforge.net,
       David Brownell <dbrownell@users.sourceforge.net>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       l.fu@pengutronix.de
Subject: [PATCH 2/3] mpc52xx_spi: add missing mode_bits definition
Date: Tue, 10 Nov 2009 10:12:08 +0100
Message-Id: <1257844329-20687-3-git-send-email-l.fu@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1257844329-20687-2-git-send-email-l.fu@pengutronix.de>
References: <1257844329-20687-1-git-send-email-l.fu@pengutronix.de>
 <1257844329-20687-2-git-send-email-l.fu@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
---
 drivers/spi/mpc52xx_spi.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/mpc52xx_spi.c b/drivers/spi/mpc52xx_spi.c
index 5b036f2..79ba678 100644
--- a/drivers/spi/mpc52xx_spi.c
+++ b/drivers/spi/mpc52xx_spi.c
@@ -430,6 +430,8 @@ static int __devinit mpc52xx_spi_probe(struct of_device *op,
 	master->num_chipselect = 1;
 	master->setup = mpc52xx_spi_setup;
 	master->transfer = mpc52xx_spi_transfer;
+	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH | SPI_LSB_FIRST;
+
 	dev_set_drvdata(&op->dev, master);
 
 	ms = spi_master_get_devdata(master);
-- 
1.6.5.2

