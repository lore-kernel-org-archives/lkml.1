Return-Path: <linux-kernel-owner+w=401wt.eu-S1754671AbYK1UJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbYK1UJs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 15:09:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbYK1UJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 15:09:37 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:16427 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbYK1UJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 15:09:36 -0500
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Cc: trivial@kernel.org
Date: Fri, 28 Nov 2008 17:11:47 +0100
Subject: [PATCH] rtc-stk17ta8: fix sparse warning
From: Hannes Eder <hannes@hanneseder.net>
Message-ID: <49304ffd.09a1660a.30b3.ffffc7a7@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warning:

  drivers/rtc/rtc-stk17ta8.c:403:2: warning: returning void-valued expression

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/rtc/rtc-stk17ta8.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-stk17ta8.c b/drivers/rtc/rtc-stk17ta8.c
index f4cd46e..549990f 100644
--- a/drivers/rtc/rtc-stk17ta8.c
+++ b/drivers/rtc/rtc-stk17ta8.c
@@ -400,7 +400,7 @@ static __init int stk17ta8_init(void)
 
 static __exit void stk17ta8_exit(void)
 {
-	return platform_driver_unregister(&stk17ta8_rtc_driver);
+	platform_driver_unregister(&stk17ta8_rtc_driver);
 }
 
 module_init(stk17ta8_init);
-- 
1.5.6.3

