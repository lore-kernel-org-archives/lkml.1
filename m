Return-Path: <linux-kernel-owner+w=401wt.eu-S1764961AbXGKPCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764961AbXGKPCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 11:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761197AbXGKPCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 11:02:14 -0400
Received: from mba.ocn.ne.jp ([122.1.175.29]:63191 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759723AbXGKPCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 11:02:13 -0400
Date: Thu, 12 Jul 2007 00:03:05 +0900 (JST)
Message-Id: <20070712.000305.115642664.anemo@mba.ocn.ne.jp>
To: a.zummo@towertech.it
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Subject: [PATCH] rtc: Do not return void value.
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes these sparse warnings:

drivers/rtc/rtc-ds1742.c:265:2: warning: returning void-valued expression
drivers/rtc/rtc-ds1553.c:409:2: warning: returning void-valued expression

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
diff --git a/drivers/rtc/rtc-ds1553.c b/drivers/rtc/rtc-ds1553.c
index afa64c7..b9ba29a 100644
--- a/drivers/rtc/rtc-ds1553.c
+++ b/drivers/rtc/rtc-ds1553.c
@@ -406,7 +406,7 @@ static __init int ds1553_init(void)
 
 static __exit void ds1553_exit(void)
 {
-	return platform_driver_unregister(&ds1553_rtc_driver);
+	platform_driver_unregister(&ds1553_rtc_driver);
 }
 
 module_init(ds1553_init);
diff --git a/drivers/rtc/rtc-ds1742.c b/drivers/rtc/rtc-ds1742.c
index d68288b..f578ed1 100644
--- a/drivers/rtc/rtc-ds1742.c
+++ b/drivers/rtc/rtc-ds1742.c
@@ -262,7 +262,7 @@ static __init int ds1742_init(void)
 
 static __exit void ds1742_exit(void)
 {
-	return platform_driver_unregister(&ds1742_rtc_driver);
+	platform_driver_unregister(&ds1742_rtc_driver);
 }
 
 module_init(ds1742_init);
