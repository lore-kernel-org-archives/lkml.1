Return-Path: <linux-kernel-owner+w=401wt.eu-S932142AbZKMKmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142AbZKMKmY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 05:42:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932112AbZKMKmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 05:42:21 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50072 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756259AbZKMKmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 05:42:17 -0500
From: Luotao Fu <l.fu@pengutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: spi-devel-general@lists.sourceforge.net,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Luotao Fu <l.fu@pengutronix.de>
Subject: [PATCH 2/3] [V2] mpc52xx_spi: add missing mode_bits definition
Date: Fri, 13 Nov 2009 11:41:16 +0100
Message-Id: <1258108877-25435-3-git-send-email-l.fu@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1258108877-25435-2-git-send-email-l.fu@pengutronix.de>
References: <1257844329-20687-1-git-send-email-l.fu@pengutronix.de>
 <1258108877-25435-1-git-send-email-l.fu@pengutronix.de>
 <1258108877-25435-2-git-send-email-l.fu@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V2 changes:
* remove CS_HIGH mode

Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/spi/mpc52xx_spi.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/mpc52xx_spi.c b/drivers/spi/mpc52xx_spi.c
index 2322250..64862cf 100644
--- a/drivers/spi/mpc52xx_spi.c
+++ b/drivers/spi/mpc52xx_spi.c
@@ -430,6 +430,8 @@ static int __devinit mpc52xx_spi_probe(struct of_device *op,
 	master->num_chipselect = 1;
 	master->setup = mpc52xx_spi_setup;
 	master->transfer = mpc52xx_spi_transfer;
+	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_LSB_FIRST;
+
 	dev_set_drvdata(&op->dev, master);
 
 	ms = spi_master_get_devdata(master);
-- 
1.6.5.2

