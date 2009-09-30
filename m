Return-Path: <linux-kernel-owner+w=401wt.eu-S1755273AbZI3TqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbZI3TqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 15:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755169AbZI3TqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 15:46:23 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37118 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070AbZI3TqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 15:46:22 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 4/7] spi-imx: setup mode_bits we can handle
Date: Wed, 30 Sep 2009 21:43:31 +0200
Message-Id: <1254339814-21506-4-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1254339814-21506-3-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20090930194211.GB1881@pengutronix.de>
 <1254339814-21506-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1254339814-21506-2-git-send-email-u.kleine-koenig@pengutronix.de>
 <1254339814-21506-3-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/spi/spi_imx.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/spi_imx.c b/drivers/spi/spi_imx.c
index b91a5a8..84dd4f3 100644
--- a/drivers/spi/spi_imx.c
+++ b/drivers/spi/spi_imx.c
@@ -545,6 +545,7 @@ static int __init spi_imx_probe(struct platform_device *pdev)
 	spi_imx->bitbang.txrx_bufs = spi_imx_transfer;
 	spi_imx->bitbang.master->setup = spi_imx_setup;
 	spi_imx->bitbang.master->cleanup = spi_imx_cleanup;
+	spi_imx->bitbang.master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH;
 
 	init_completion(&spi_imx->xfer_done);
 
-- 
1.6.4.3

