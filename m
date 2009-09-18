Return-Path: <linux-kernel-owner+w=401wt.eu-S1758666AbZIRUpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666AbZIRUpU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 16:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758654AbZIRUpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 16:45:15 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44604 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758622AbZIRUpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 16:45:08 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Wolfram Sang <w.sang@pengutronix.de>
Date: Fri, 18 Sep 2009 22:44:45 +0200
Message-Id: <1253306686-20616-4-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253306686-20616-1-git-send-email-w.sang@pengutronix.de>
References: <1253306686-20616-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: w.sang@pengutronix.de
Subject: [PATCH 3/4] regulator/lp3971: drop unnecessary initialization
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/regulator/lp3971.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/lp3971.c b/drivers/regulator/lp3971.c
index a61018a..7803a32 100644
--- a/drivers/regulator/lp3971.c
+++ b/drivers/regulator/lp3971.c
@@ -541,7 +541,7 @@ static struct i2c_driver lp3971_i2c_driver = {
 
 static int __init lp3971_module_init(void)
 {
-	int ret = -ENODEV;
+	int ret;
 
 	ret = i2c_add_driver(&lp3971_i2c_driver);
 	if (ret != 0)
-- 
1.6.3.3

