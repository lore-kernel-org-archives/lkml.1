Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbYKRITX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbYKRITX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 03:19:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbYKRIRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 03:17:05 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:18386 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbYKRIQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 03:16:59 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62691575"
From: Bryan Wu <cooloney@kernel.org>
To: broonie@sirena.org.uk, tiwai@suse.de
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>, Cliff Cai <cliff.cai@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 6/8] ASoC: Blackfin: do not force TWI bus for ssm2602 codec
Date: Tue, 18 Nov 2008 16:18:20 +0800
Message-Id: <1226996302-10234-7-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1226996302-10234-1-git-send-email-cooloney@kernel.org>
References: <1226996302-10234-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Cc: Cliff Cai <cliff.cai@analog.com>
Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 sound/soc/blackfin/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/sound/soc/blackfin/Kconfig b/sound/soc/blackfin/Kconfig
index 43d89fc..f0fd235 100644
--- a/sound/soc/blackfin/Kconfig
+++ b/sound/soc/blackfin/Kconfig
@@ -13,7 +13,6 @@ config SND_BF5XX_SOC_SSM2602
 	select SND_BF5XX_SOC_I2S
 	select SND_SOC_SSM2602
 	select I2C
-	select I2C_BLACKFIN_TWI
 	help
 	  Say Y if you want to add support for SoC audio on BF527-EZKIT.
 
-- 
1.5.6.3
