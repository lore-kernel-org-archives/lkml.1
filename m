Return-Path: <linux-kernel-owner+w=401wt.eu-S1753762AbYKRHy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbYKRHy7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 02:54:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbYKRHva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 02:51:30 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:57358 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbYKRHv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 02:51:26 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62690400"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 11/16] Blackfin SPI Driver: remove duplicated MAX_SPI_SSEL and remove unnecessary array size
Date: Tue, 18 Nov 2008 15:52:35 +0800
Message-Id: <1226994760-4301-12-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1226994760-4301-1-git-send-email-cooloney@kernel.org>
References: <1226994760-4301-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/spi/spi_bfin5xx.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 4343a92..fba77c2 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -198,8 +198,6 @@ static void cs_deactive(struct driver_data *drv_data, struct chip_data *chip)
 		udelay(chip->cs_chg_udelay);
 }
 
-#define MAX_SPI_SSEL	7
-
 /* stop controller and re-config current chip*/
 static void restore_state(struct driver_data *drv_data)
 {
@@ -997,7 +995,7 @@ static int transfer(struct spi_device *spi, struct spi_message *msg)
 
 #define MAX_SPI_SSEL	7
 
-static u16 ssel[3][MAX_SPI_SSEL] = {
+static u16 ssel[][MAX_SPI_SSEL] = {
 	{P_SPI0_SSEL1, P_SPI0_SSEL2, P_SPI0_SSEL3,
 	P_SPI0_SSEL4, P_SPI0_SSEL5,
 	P_SPI0_SSEL6, P_SPI0_SSEL7},
-- 
1.5.6.3
