Return-Path: <linux-kernel-owner+w=401wt.eu-S932998Ab0AFXAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932998Ab0AFXAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 18:00:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932813Ab0AFXAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 18:00:41 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:53853 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932990Ab0AFXAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 18:00:40 -0500
From: Stefan Weil <weil@mail.berlios.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Anton Vorontsov <cbouatmailru@gmail.com>,
       Mike Rapoport <mike@compulab.co.il>, linux-kernel@vger.kernel.org
Cc: Stefan Weil <weil@mail.berlios.de>
Subject: [PATCH] da9030_battery: Fix spelling in comment
Date: Thu,  7 Jan 2010 00:00:23 +0100
Message-Id: <1262818823-16532-1-git-send-email-weil@mail.berlios.de>
X-Mailer: git-send-email 1.6.5
X-Provags-ID: V01U2FsdGVkX19B9j8sDYQfcbdIr5VlEUqPkJttqcCqs95xICJ
 mwaWOXMNDnthl46Wpkwhf9matOYtJ6Qac2RlHlniFF49UY7iVz
 MzCVdzRzf4cMW4lfwjDf+D1+n+lKywPwytn+7huUOhqSkenbUU
 28A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

platfrom -> platform
monotor -> monitor

Signed-off-by: Stefan Weil <weil@mail.berlios.de>
---
 drivers/power/da9030_battery.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/power/da9030_battery.c b/drivers/power/da9030_battery.c
index 3364198..a2e71f7 100644
--- a/drivers/power/da9030_battery.c
+++ b/drivers/power/da9030_battery.c
@@ -509,7 +509,7 @@ static int da9030_battery_probe(struct platform_device *pdev)
 
 	charger->master = pdev->dev.parent;
 
-	/* 10 seconds between monotor runs unless platfrom defines other
+	/* 10 seconds between monitor runs unless platform defines other
 	   interval */
 	charger->interval = msecs_to_jiffies(
 		(pdata->batmon_interval ? : 10) * 1000);
-- 
1.5.6.5

