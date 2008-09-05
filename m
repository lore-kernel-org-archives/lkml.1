Return-Path: <linux-kernel-owner+w=401wt.eu-S1753893AbYIEKWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbYIEKWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 06:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbYIEKVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 06:21:30 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:51198 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbYIEKV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 06:21:28 -0400
X-IronPort-AV: E=Sophos;i="4.32,320,1217822400"; 
   d="scan'208";a="74640981"
From: Bryan Wu <cooloney@kernel.org>
To: broonie@sirena.org.uk
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Cliff Cai <cliff.cai@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/9] ASoC: add Blackfin build options to Kconfig and Makefile of sound soc framework
Date: Fri,  5 Sep 2008 18:21:34 +0800
Message-Id: <1220610102-7716-2-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1220610102-7716-1-git-send-email-cooloney@kernel.org>
References: <1220610102-7716-1-git-send-email-cooloney@kernel.org>
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
