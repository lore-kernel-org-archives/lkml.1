Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbYEZNnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbYEZNnA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 09:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbYEZNmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 09:42:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54451 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751863AbYEZNmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 09:42:07 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Rodolfo Giometti <giometti@enneenne.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/4] wm97xx-core: Report a phys for WM97xx touchscreens
Date: Mon, 26 May 2008 14:42:00 +0100
Message-Id: <1211809323-4742-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

phys is displayed in diagnostic output like that from evbug so ensure
that it is set to something.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/input/touchscreen/wm97xx-core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/input/touchscreen/wm97xx-core.c b/drivers/input/touchscreen/wm97xx-core.c
index e9c7ea4..ba6fb28 100644
--- a/drivers/input/touchscreen/wm97xx-core.c
+++ b/drivers/input/touchscreen/wm97xx-core.c
@@ -616,6 +616,7 @@ static int wm97xx_probe(struct device *dev)
 
 	/* set up touch configuration */
 	wm->input_dev->name = "wm97xx touchscreen";
+	wm->input_dev->phys = "wm97xx";
 	wm->input_dev->open = wm97xx_ts_input_open;
 	wm->input_dev->close = wm97xx_ts_input_close;
 	set_bit(EV_ABS, wm->input_dev->evbit);
-- 
1.5.5.1

