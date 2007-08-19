Return-Path: <linux-kernel-owner+w=401wt.eu-S1756868AbXHSNbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868AbXHSNbg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 09:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753673AbXHSNbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 09:31:16 -0400
Received: from mba.ocn.ne.jp ([122.1.175.29]:58865 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755937AbXHSNbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 09:31:14 -0400
Date: Sun, 19 Aug 2007 22:32:30 +0900 (JST)
Message-Id: <20070819.223230.51861058.anemo@mba.ocn.ne.jp>
To: a.zummo@towertech.it
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
       dbrownell@users.sourceforge.net
Subject: [PATCH] rtc: Make rtc-ds1553 driver hotplug-aware (take 3)
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The rtc-ds1553 platform driver name doesn't match its module name,
which might prevent it from properly hotplugging.  This driver has no
in-tree users.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
The "take 2" of this patch was just a typo-fix ("1553" vs. "1742").

diff --git a/drivers/rtc/rtc-ds1553.c b/drivers/rtc/rtc-ds1553.c
index 46da571..a4bcb34 100644
--- a/drivers/rtc/rtc-ds1553.c
+++ b/drivers/rtc/rtc-ds1553.c
@@ -395,7 +395,7 @@ static struct platform_driver ds1553_rtc_driver = {
 	.probe		= ds1553_rtc_probe,
 	.remove		= __devexit_p(ds1553_rtc_remove),
 	.driver		= {
-		.name	= "ds1553",
+		.name	= "rtc-ds1553",
 		.owner	= THIS_MODULE,
 	},
 };
