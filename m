Return-Path: <linux-kernel-owner+w=401wt.eu-S1752968AbYKRIR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbYKRIR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 03:17:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbYKRIQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 03:16:58 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:5659 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbYKRIQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 03:16:57 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62691570"
From: Bryan Wu <cooloney@kernel.org>
To: broonie@sirena.org.uk, tiwai@suse.de
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/8] ASoC: Blackfin: updates Kconfig for SPORT
Date: Tue, 18 Nov 2008 16:18:15 +0800
Message-Id: <1226996302-10234-2-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1226996302-10234-1-git-send-email-cooloney@kernel.org>
References: <1226996302-10234-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

tweak SPORT range for non-BF54x so we get proper behavior for BF52x parts

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 sound/soc/blackfin/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/blackfin/Kconfig b/sound/soc/blackfin/Kconfig
index dc00620..3fce187 100644
--- a/sound/soc/blackfin/Kconfig
+++ b/sound/soc/blackfin/Kconfig
@@ -80,7 +80,7 @@ config SND_BF5XX_SPORT_NUM
 	int "Set a SPORT for Sound chip"
 	depends on (SND_BF5XX_I2S || SND_BF5XX_AC97)
 	range 0 3 if BF54x
-	range 0 1 if (BF53x || BF561)
+	range 0 1 if !BF54x
 	default 0
 	help
 	  Set the correct SPORT for sound chip.
-- 
1.5.6.3
