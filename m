Return-Path: <linux-kernel-owner+w=401wt.eu-S1758463AbYEPQvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758463AbYEPQvO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 12:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbYEPQu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 12:50:57 -0400
Received: from rtsoft2.corbina.net ([85.21.88.2]:34076 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with SMTP id S1752737AbYEPQu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 12:50:56 -0400
Date: Fri, 16 May 2008 20:50:52 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Kumar Gala <galak@kernel.crashing.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Jochen Friedrich <jochen@scram.de>, Timur Tabi <timur@freescale.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       spi-devel-general@lists.sourceforge.net
Subject: [PATCH 1/4] [SPI] [POWERPC] spi_mpc83xx: handles Freescale MPC8610
	as well
Message-ID: <20080516165052.GA24196@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this patch we'll able to select spi_mpc83xx driver on the MPC86xx
processors.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---

This patch is on top of Jochen's patch (
http://patchwork.ozlabs.org/linuxppc/patch?id=18261)
that fixes SPI on MPC8610.

 drivers/spi/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 66ec5d8..094c237 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -125,7 +125,7 @@ config SPI_MPC52xx_PSC
 
 config SPI_MPC83xx
 	tristate "Freescale MPC83xx/QUICC Engine SPI controller"
-	depends on SPI_MASTER && (PPC_83xx || QUICC_ENGINE) && EXPERIMENTAL
+	depends on SPI_MASTER && (PPC_83xx || QUICC_ENGINE || PPC_86xx) && EXPERIMENTAL
 	help
 	  This enables using the Freescale MPC83xx and QUICC Engine SPI
 	  controllers in master mode.
-- 
1.5.5.1

