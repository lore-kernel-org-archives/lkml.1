Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbYEZNmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbYEZNmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 09:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbYEZNmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 09:42:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54452 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750984AbYEZNmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 09:42:07 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Rodolfo Giometti <giometti@enneenne.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/4] wm97xx-core: Fix driver name
Date: Mon, 26 May 2008 14:42:01 +0100
Message-Id: <1211809323-4742-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1211809323-4742-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1211809323-4742-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix driver name - thanks to Guennadi Liakhovetski <g.liakhovetski@gmx.de> for
reporting this.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/input/touchscreen/wm97xx-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/touchscreen/wm97xx-core.c b/drivers/input/touchscreen/wm97xx-core.c
index ba6fb28..8a00918 100644
--- a/drivers/input/touchscreen/wm97xx-core.c
+++ b/drivers/input/touchscreen/wm97xx-core.c
@@ -802,7 +802,7 @@ void wm97xx_unregister_mach_ops(struct wm97xx *wm)
 EXPORT_SYMBOL_GPL(wm97xx_unregister_mach_ops);
 
 static struct device_driver wm97xx_driver = {
-	.name =		"ac97",
+	.name =		"wm97xx-ts",
 	.bus =		&ac97_bus_type,
 	.owner =	THIS_MODULE,
 	.probe =	wm97xx_probe,
-- 
1.5.5.1

