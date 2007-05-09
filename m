Return-Path: <linux-kernel-owner+w=401wt.eu-S1757121AbXEIMAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121AbXEIMAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 08:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757142AbXEIL7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 07:59:55 -0400
Received: from p2020-adsah02tachib-acca.tokyo.ocn.ne.jp ([219.161.11.20]:60864
	"EHLO eggplant.ddo.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757126AbXEIL7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 07:59:53 -0400
Message-ID: <1657.192.168.1.10.1178711992.squirrel@eggplant.ddo.jp>
Date: Wed, 9 May 2007 20:59:52 +0900 (JST)
Subject: [PATCH 2/3] rtc:rtc-rs5c313.c : rtc_time value are fixed.
From: "kogiidena" <kogiidena@eggplant.ddo.jp>
To: linux-kernel@vger.kernel.org
Reply-To: kogiidena@eggplant.ddo.jp
User-Agent: SquirrelMail/1.4.5
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
References: 
In-Reply-To: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch is a patch that corrects an initial value of suruct rtc_
time.
please apply.

Signed-off-by: kogiidena <kogiidena@eggplant.ddo.jp>
---
diff -urpN OLD/drivers/rtc/rtc-rs5c313.c NEW/drivers/rtc/rtc-rs5c313.c
--- OLD/drivers/rtc/rtc-rs5c313.c	2007-05-08 19:42:05.000000000 +0900
+++ NEW/drivers/rtc/rtc-rs5c313.c	2007-05-08 19:46:40.000000000 +0900
@@ -331,7 +331,8 @@ static void rs5c313_check_xstp_bit(void)

 		memset(&tm, 0, sizeof(struct rtc_time));
 		tm.tm_mday 	= 1;
-		tm.tm_mon 	= 1;
+		tm.tm_mon 	= 1 - 1;
+		tm.tm_year 	= 2000 - 1900;

 		rs5c313_rtc_set_time(NULL, &tm);
 		printk(KERN_ERR "RICHO RS5C313: invalid value, resetting to "





