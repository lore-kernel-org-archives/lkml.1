Return-Path: <linux-kernel-owner+w=401wt.eu-S932553AbXHPQFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553AbXHPQFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 12:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761807AbXHPQFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 12:05:13 -0400
Received: from mba.ocn.ne.jp ([122.1.175.29]:53579 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759288AbXHPQFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 12:05:11 -0400
Date: Fri, 17 Aug 2007 01:06:27 +0900 (JST)
Message-Id: <20070817.010627.110331225.anemo@mba.ocn.ne.jp>
To: a.zummo@towertech.it
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
       dbrownell@users.sourceforge.net
Subject: [PATCH] rtc: Make rtc-ds1553 driver hotplug-aware
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add an MODULE_ALIAS() to make this platform driver hotplug-aware.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
diff --git a/drivers/rtc/rtc-ds1553.c b/drivers/rtc/rtc-ds1553.c
index 46da571..e932024 100644
--- a/drivers/rtc/rtc-ds1553.c
+++ b/drivers/rtc/rtc-ds1553.c
@@ -417,3 +417,4 @@ MODULE_AUTHOR("Atsushi Nemoto <anemo@mba.ocn.ne.jp>");
 MODULE_DESCRIPTION("Dallas DS1553 RTC driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
+MODULE_ALIAS("ds1742");
