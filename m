Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbZCFHwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbZCFHwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 02:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbZCFHv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 02:51:26 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:5018 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbZCFHvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 02:51:24 -0500
X-IronPort-AV: E=Sophos;i="4.38,313,1233550800"; 
   d="scan'208";a="83886314"
From: Bryan Wu <cooloney@kernel.org>
To: broonie@opensource.wolfsonmicro.com
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 3/5] ASoC: Blackfin: move gpio_err behind the define that is only user of it
Date: Fri,  6 Mar 2009 15:53:28 +0800
Message-Id: <1236326010-683-4-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1236326010-683-1-git-send-email-cooloney@kernel.org>
References: <1236326010-683-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 sound/soc/blackfin/bf5xx-ac97.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/blackfin/bf5xx-ac97.c b/sound/soc/blackfin/bf5xx-ac97.c
index 5885702..8a935f2 100644
--- a/sound/soc/blackfin/bf5xx-ac97.c
+++ b/sound/soc/blackfin/bf5xx-ac97.c
@@ -357,8 +357,8 @@ sport_config_err:
 sport_err:
 #ifdef CONFIG_SND_BF5XX_HAVE_COLD_RESET
 	gpio_free(CONFIG_SND_BF5XX_RESET_GPIO_NUM);
-#endif
 gpio_err:
+#endif
 	peripheral_free_list(sport_req[sport_num]);
 peripheral_err:
 	free_page((unsigned long)cmd_count);
-- 
1.5.6.3
