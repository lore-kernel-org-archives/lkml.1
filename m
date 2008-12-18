Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753047AbYLRKp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbYLRKp1 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 05:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbYLRKos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 05:44:48 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35873 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751662AbYLRKor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 05:44:47 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 4/6] mfd: Handle missing WM8350 platform data
Date: Thu, 18 Dec 2008 10:44:42 +0000
Message-Id: <1229597084-12727-4-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1229597084-12727-3-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20081218104301.GA12649@rakim.wolfsonmicro.main>
 <1229597084-12727-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1229597084-12727-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1229597084-12727-3-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8350-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index fa505ac..03af3b1 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -1350,7 +1350,7 @@ int wm8350_device_init(struct wm8350 *wm8350, int irq,
 		return ret;
 	}
 
-	if (pdata->init) {
+	if (pdata && pdata->init) {
 		ret = pdata->init(wm8350);
 		if (ret != 0) {
 			dev_err(wm8350->dev, "Platform init() failed: %d\n",
-- 
1.5.6.5

