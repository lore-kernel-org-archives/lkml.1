Return-Path: <linux-kernel-owner+w=401wt.eu-S932390AbXE1In1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390AbXE1In1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 04:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761360AbXE1Ig6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 04:36:58 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:7605 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760136AbXE1Igh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 04:36:37 -0400
X-IronPort-AV: i="4.14,586,1170651600"; 
   d="scan'208"; a="31069474:sNHT19728247"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: [PATCH 18/20] Blackfin SPI driver: tweak spi cleanup function to match newer kernel changes
Date: Mon, 28 May 2007 16:37:53 +0800
Message-Id: <11803414821951-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.2
In-Reply-To: <11803414753217-git-send-email-bryan.wu@analog.com>
References: <11803414753217-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/spi/spi_bfin5xx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 7d2d9ec..a2d4884 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -1082,7 +1082,7 @@ static int setup(struct spi_device *spi)
  */
 static void cleanup(struct spi_device *spi)
 {
-	struct chip_data *chip = spi_get_ctldata((struct spi_device *)spi);
+	struct chip_data *chip = spi_get_ctldata(spi);
 
 	kfree(chip);
 }
-- 
1.5.2
