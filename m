Return-Path: <linux-kernel-owner+w=401wt.eu-S1752831AbYKRIS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbYKRIS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 03:18:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbYKRIRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 03:17:04 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:5659 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbYKRIQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 03:16:59 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62691576"
From: Bryan Wu <cooloney@kernel.org>
To: broonie@sirena.org.uk, tiwai@suse.de
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>, Cliff Cai <cliff.cai@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 8/8] ASoC: Blackfin: always set a default value for that GPIO range
Date: Tue, 18 Nov 2008 16:18:22 +0800
Message-Id: <1226996302-10234-9-git-send-email-cooloney@kernel.org>
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
 sound/soc/blackfin/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/soc/blackfin/Kconfig b/sound/soc/blackfin/Kconfig
index f0fd235..e162cbb 100644
--- a/sound/soc/blackfin/Kconfig
+++ b/sound/soc/blackfin/Kconfig
@@ -104,5 +104,6 @@ config SND_BF5XX_RESET_GPIO_NUM
 	range 0 159
 	default 19 if BFIN548_EZKIT
 	default 5 if BFIN537_STAMP
+	default 0
 	help
 	  Set the correct GPIO for RESET the sound chip.
-- 
1.5.6.3
