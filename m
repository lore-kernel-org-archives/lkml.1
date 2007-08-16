Return-Path: <linux-kernel-owner+w=401wt.eu-S932821AbXHPQF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932821AbXHPQF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 12:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765647AbXHPQFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 12:05:23 -0400
Received: from mba.ocn.ne.jp ([122.1.175.29]:53989 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765532AbXHPQFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 12:05:22 -0400
Date: Fri, 17 Aug 2007 01:06:38 +0900 (JST)
Message-Id: <20070817.010638.24337787.anemo@mba.ocn.ne.jp>
To: a.zummo@towertech.it
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
       dbrownell@users.sourceforge.net
Subject: [PATCH] rtc: Make rtc-ds1742 driver hotplug-aware
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
diff --git a/drivers/rtc/rtc-ds1742.c b/drivers/rtc/rtc-ds1742.c
index b2e5481..4bd22dc 100644
--- a/drivers/rtc/rtc-ds1742.c
+++ b/drivers/rtc/rtc-ds1742.c
@@ -273,3 +273,4 @@ MODULE_AUTHOR("Atsushi Nemoto <anemo@mba.ocn.ne.jp>");
 MODULE_DESCRIPTION("Dallas DS1742 RTC driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
+MODULE_ALIAS("ds1742");
