Return-Path: <linux-kernel-owner+w=401wt.eu-S1755532AbZCFHwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbZCFHwo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 02:52:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbZCFHv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 02:51:26 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:34196 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbZCFHvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 02:51:24 -0500
X-IronPort-AV: E=Sophos;i="4.38,313,1233550800"; 
   d="scan'208";a="83886315"
From: Bryan Wu <cooloney@kernel.org>
To: broonie@opensource.wolfsonmicro.com
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 5/5] ASoC: Blackfin: fix typo in MUTE definition
Date: Fri,  6 Mar 2009 15:53:30 +0800
Message-Id: <1236326010-683-6-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1236326010-683-1-git-send-email-cooloney@kernel.org>
References: <1236326010-683-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Reported-by: Rob Maris <maris.rob@vdi.de>
Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 sound/soc/codecs/ad73311.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/ad73311.h b/sound/soc/codecs/ad73311.h
index 507ce0c..569573d 100644
--- a/sound/soc/codecs/ad73311.h
+++ b/sound/soc/codecs/ad73311.h
@@ -70,7 +70,7 @@
 #define REGD_IGS(x)		(x & 0x7)
 #define REGD_RMOD		(1 << 3)
 #define REGD_OGS(x)		((x & 0x7) << 4)
-#define REGD_MUTE		(x << 7)
+#define REGD_MUTE		(1 << 7)
 
 /* Control register E */
 #define CTRL_REG_E	(4 << 8)
-- 
1.5.6.3
