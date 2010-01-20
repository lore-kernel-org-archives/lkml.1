Return-Path: <linux-kernel-owner+w=401wt.eu-S1752616Ab0ATJrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab0ATJrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 04:47:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448Ab0ATJrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 04:47:22 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:39493 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab0ATJrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 04:47:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=UVFQ00X2ehDymdJQaMqWW2fRh78YbPCaIyEfySHuIl2iR2Wbd+03ZTmodb2/2D3dCm
         kC2DeMgujLqrs8TiphLe1UGKiyHHZ9hRCR8NgYWmze/102asRG5Yp7+pR91YYJNLb0ii
         xvl0j+5W+CQL+946baFa93u+66N6rUn5n9AJQ=
Subject: [PATCH] spi: spi_imx: add device information to debug.
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: spi-devel-list <spi-devel-general@lists.sourceforge.net>
Cc: Grant Likely <grant.likely@secretlab.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Sascha linux-arm <s.hauer@pengutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jan 2010 10:47:14 +0100
Message-ID: <1263980834.3083.18.camel@realization>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!
I already sent this patch to the linux-arm-kernel mailing list,
but not cc you.
In reference to:
http://thread.gmane.org/gmane.linux.ports.arm.kernel/71119

Patch below:
this patch apply to  linus .33-rc4 
---------------------------------------------------------------
Not an heavy fix, but good when debugging multiple spi channels.

Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/spi/spi_imx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi_imx.c b/drivers/spi/spi_imx.c
index 89c22ef..18bbfa3 100644
--- a/drivers/spi/spi_imx.c
+++ b/drivers/spi/spi_imx.c
@@ -466,7 +466,7 @@ static int spi_imx_setup(struct spi_device *spi)
        struct spi_imx_data *spi_imx = spi_master_get_devdata(spi->master);
        int gpio = spi_imx->chipselect[spi->chip_select];
 
-       pr_debug("%s: mode %d, %u bpw, %d hz\n", __func__,
+       dev_dbg(&spi->dev, "%s: mode %d, %u bpw, %d hz\n", __func__,
                 spi->mode, spi->bits_per_word, spi->max_speed_hz);
 
        if (gpio >= 0)
-- 
1.6.3.3


