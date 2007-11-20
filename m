Return-Path: <linux-kernel-owner+w=401wt.eu-S1761010AbXKTCCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761010AbXKTCCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 21:02:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757894AbXKTBu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:50:27 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2144 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757856AbXKTBtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:49:46 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Alessandro Zummo <a.zummo@towertech.it>,
       Paul Gortmaker <p_gortmaker@yahoo.com>, linux-kernel@vger.kernel.org,
       rtc-linux@googlegroups.com
Subject: [PATCH 38/59] drivers/rtc: Add missing "space"
Date: Mon, 19 Nov 2007 17:48:30 -0800
Message-Id: <1195523331-15303-39-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.6.728.gea559
In-Reply-To: <1195523331-15303-38-git-send-email-joe@perches.com>
References: 1234567
 <1195523331-15303-1-git-send-email-joe@perches.com>
 <1195523331-15303-2-git-send-email-joe@perches.com>
 <1195523331-15303-3-git-send-email-joe@perches.com>
 <1195523331-15303-4-git-send-email-joe@perches.com>
 <1195523331-15303-5-git-send-email-joe@perches.com>
 <1195523331-15303-6-git-send-email-joe@perches.com>
 <1195523331-15303-7-git-send-email-joe@perches.com>
 <1195523331-15303-8-git-send-email-joe@perches.com>
 <1195523331-15303-9-git-send-email-joe@perches.com>
 <1195523331-15303-10-git-send-email-joe@perches.com>
 <1195523331-15303-11-git-send-email-joe@perches.com>
 <1195523331-15303-12-git-send-email-joe@perches.com>
 <1195523331-15303-13-git-send-email-joe@perches.com>
 <1195523331-15303-14-git-send-email-joe@perches.com>
 <1195523331-15303-15-git-send-email-joe@perches.com>
 <1195523331-15303-16-git-send-email-joe@perches.com>
 <1195523331-15303-17-git-send-email-joe@perches.com>
 <1195523331-15303-18-git-send-email-joe@perches.com>
 <1195523331-15303-19-git-send-email-joe@perches.com>
 <1195523331-15303-20-git-send-email-joe@perches.com>
 <1195523331-15303-21-git-send-email-joe@perches.com>
 <1195523331-15303-22-git-send-email-joe@perches.com>
 <1195523331-15303-23-git-send-email-joe@perches.com>
 <1195523331-15303-24-git-send-email-joe@perches.com>
 <1195523331-15303-25-git-send-email-joe@perches.com>
 <1195523331-15303-26-git-send-email-joe@perches.com>
 <1195523331-15303-27-git-send-email-joe@perches.com>
 <1195523331-15303-28-git-send-email-joe@perches.com>
 <1195523331-15303-29-git-send-email-joe@perches.com>
 <1195523331-15303-30-git-send-email-joe@perches.com>
 <1195523331-15303-31-git-send-email-joe@perches.com>
 <1195523331-15303-32-git-send-email-joe@perches.com>
 <1195523331-15303-33-git-send-email-joe@perches.com>
 <1195523331-15303-34-git-send-email-joe@perches.com>
 <1195523331-15303-35-git-send-email-joe@perches.com>
 <1195523331-15303-36-git-send-email-joe@perches.com>
 <1195523331-15303-37-git-send-email-joe@perches.com>
 <1195523331-15303-38-git-send-email-joe@perches.com>
Message-Id: <d04f5b45e26dfc3ae3e8f69f01e3a20738f14b32.1195454435.git.joe@perches.com>
In-Reply-To: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/rtc/rtc-v3020.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-v3020.c b/drivers/rtc/rtc-v3020.c
index a6b5729..0e7a15d 100644
--- a/drivers/rtc/rtc-v3020.c
+++ b/drivers/rtc/rtc-v3020.c
@@ -200,7 +200,7 @@ static int rtc_probe(struct platform_device *pdev)
 	 * are all disabled */
 	v3020_set_reg(chip, V3020_STATUS_0, 0x0);
 
-	dev_info(&pdev->dev, "Chip available at physical address 0x%llx,"
+	dev_info(&pdev->dev, "Chip available at physical address 0x%llx, "
 		"data connected to D%d\n",
 		(unsigned long long)pdev->resource[0].start,
 		chip->leftshift);
-- 
1.5.3.5.652.gf192c

