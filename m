Return-Path: <linux-kernel-owner+w=401wt.eu-S1755986AbZG2RFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbZG2RFN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 13:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755964AbZG2RFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 13:05:11 -0400
Received: from ru.mvista.com ([213.79.90.228]:28670 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755941AbZG2RFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 13:05:09 -0400
Date: Wed, 29 Jul 2009 21:05:07 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       David Woodhouse <dwmw2@infradead.org>,
       Grant Likely <grant.likely@secretlab.ca>,
       Jean Delvare <khali@linux-fr.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       linuxppc-dev@ozlabs.org
Subject: [PATCH 3/7] of: Remove "stm,m25p40" alias
Message-ID: <20090729170507.GC4803@oksana.dev.rtsoft.ru>
References: <20090729170345.GA26787@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090729170345.GA26787@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The alias isn't needed any longer since the m25p80 driver converted
to the module device table matching.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/of/base.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 69f85c0..ddf224d 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -447,7 +447,6 @@ struct of_modalias_table {
 static struct of_modalias_table of_modalias_table[] = {
 	{ "fsl,mcu-mpc8349emitx", "mcu-mpc8349emitx" },
 	{ "mmc-spi-slot", "mmc_spi" },
-	{ "stm,m25p40", "m25p80" },
 };
 
 /**
-- 
1.6.3.3

