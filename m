Return-Path: <linux-kernel-owner+w=401wt.eu-S1753627AbZK3OBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbZK3OBx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 09:01:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548AbZK3OBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 09:01:53 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39016 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753490AbZK3OBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 09:01:52 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2.6.32] regulator: Initialise wm831x structure pointor for ISINK driver
Date: Mon, 30 Nov 2009 14:01:56 +0000
Message-Id: <1259589716-14007-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The version that made it into mainline missed the initialisation of the
chip handle.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm831x-isink.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/wm831x-isink.c b/drivers/regulator/wm831x-isink.c
index 1d8d987..4885700 100644
--- a/drivers/regulator/wm831x-isink.c
+++ b/drivers/regulator/wm831x-isink.c
@@ -167,6 +167,8 @@ static __devinit int wm831x_isink_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	isink->wm831x = wm831x;
+
 	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
 	if (res == NULL) {
 		dev_err(&pdev->dev, "No I/O resource\n");
-- 
1.6.5.3

