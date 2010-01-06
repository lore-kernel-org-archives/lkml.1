Return-Path: <linux-kernel-owner+w=401wt.eu-S933025Ab0AFXGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025Ab0AFXGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 18:06:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932989Ab0AFXGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 18:06:04 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:64150 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932958Ab0AFXGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 18:06:00 -0500
From: Stefan Weil <weil@mail.berlios.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Dave Young <hidave.darkstar@gmail.com>,
       Matthew Garrett <mjg@redhat.com>,
       "David S . Miller" <davem@davemloft.net>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: Stefan Weil <weil@mail.berlios.de>
Subject: [PATCH] Fix spelling in log messages
Date: Thu,  7 Jan 2010 00:05:37 +0100
Message-Id: <1262819137-16775-1-git-send-email-weil@mail.berlios.de>
X-Mailer: git-send-email 1.6.5
X-Provags-ID: V01U2FsdGVkX1/Xdq1++QVm8JxWk0QyUfjjkwGNEkHuTlMJwFh
 AOYxg93T9krbO6OnV0rhLYEp4ad9H+3NWEt2e5RKoIiRqwOjaG
 ppVpe6JayV4vHYu/35L2R0x6C7ytJNPP4qJz9HmxV5C8shHuxR
 Wgg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace platfrom -> platform.

Signed-off-by: Stefan Weil <weil@mail.berlios.de>
---
 drivers/input/serio/i8042.c |    2 +-
 drivers/net/davinci_emac.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index d84a36e..33f3541 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -430,7 +430,7 @@ static bool i8042_filter(unsigned char data, unsigned char str,
 	}
 
 	if (i8042_platform_filter && i8042_platform_filter(data, str, serio)) {
-		dbg("Filtered out by platfrom filter\n");
+		dbg("Filtered out by platform filter\n");
 		return true;
 	}
 
diff --git a/drivers/net/davinci_emac.c b/drivers/net/davinci_emac.c
index 107bc5f..4741ade 100644
--- a/drivers/net/davinci_emac.c
+++ b/drivers/net/davinci_emac.c
@@ -2652,7 +2652,7 @@ static int __devinit davinci_emac_probe(struct platform_device *pdev)
 
 	pdata = pdev->dev.platform_data;
 	if (!pdata) {
-		printk(KERN_ERR "DaVinci EMAC: No platfrom data\n");
+		printk(KERN_ERR "DaVinci EMAC: No platform data\n");
 		return -ENODEV;
 	}
 
-- 
1.5.6.5

