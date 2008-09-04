Return-Path: <linux-kernel-owner+w=401wt.eu-S1757556AbYIDIWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556AbYIDIWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 04:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754922AbYIDIV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 04:21:57 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:30867 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbYIDIVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 04:21:55 -0400
X-IronPort-AV: E=Sophos;i="4.32,320,1217822400"; 
   d="scan'208";a="59017791"
From: Bryan Wu <cooloney@kernel.org>
To: broonie@opensource.wolfsonmicro.com
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Cliff Cai <cliff.cai@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/9] ASoC: add Blackfin build options to Kconfig and Makefile of sound soc framework
Date: Thu,  4 Sep 2008 16:22:00 +0800
Message-Id: <1220516528-20301-2-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1220516528-20301-1-git-send-email-cooloney@kernel.org>
References: <1220516528-20301-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Cai <cliff.cai@analog.com>

Signed-off-by: Cliff Cai <cliff.cai@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 sound/soc/Kconfig  |    2 +-
 sound/soc/Makefile |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/Kconfig b/sound/soc/Kconfig
index f743530..0adbc92 100644
--- a/sound/soc/Kconfig
+++ b/sound/soc/Kconfig
@@ -31,7 +31,7 @@ source "sound/soc/sh/Kconfig"
 source "sound/soc/fsl/Kconfig"
 source "sound/soc/davinci/Kconfig"
 source "sound/soc/omap/Kconfig"
-
+source "sound/soc/blackfin/Kconfig"
 # Supported codecs
 source "sound/soc/codecs/Kconfig"
 
diff --git a/sound/soc/Makefile b/sound/soc/Makefile
index 933a66d..d849349 100644
--- a/sound/soc/Makefile
+++ b/sound/soc/Makefile
@@ -2,4 +2,4 @@ snd-soc-core-objs := soc-core.o soc-dapm.o
 
 obj-$(CONFIG_SND_SOC)	+= snd-soc-core.o
 obj-$(CONFIG_SND_SOC)	+= codecs/ at32/ at91/ pxa/ s3c24xx/ sh/ fsl/ davinci/
-obj-$(CONFIG_SND_SOC)	+= omap/ au1x/
+obj-$(CONFIG_SND_SOC)	+= omap/ au1x/ blackfin/
-- 
1.5.6
