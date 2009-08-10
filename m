Return-Path: <linux-kernel-owner+w=401wt.eu-S1752153AbZHJHIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbZHJHIF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 03:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbZHJHIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 03:08:04 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:43498 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbZHJHIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 03:08:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=sarkCzAG506RnmS/CqXhX0jT5Q9gdqV1FUJLcBLM4N4/kXiMMLlGFKhrwvVsDzZLbA
         K0MjUUsVS2boK7R1p4m3bSb8Db+TgQhCQlDqnQZ3zI6Ra0Jv2NOWpDUvYsCHr9XLKPw0
         k4mw1XGf7b7CIAtyA0gKLE4Z2Cz0z6TpXjvM4=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: linux-mips@linux-mips.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Cc: Nicolas Thill <nico@openwrt.org>, Ralf Baechle <ralf@linux-mips.org>,
       Enrik Berkhan <Enrik.Berkhan@akk.org>,
       Wu Zhangjin <wuzhangjin@gmail.com>
Subject: [PATCH] MIPS: AR7: fix wrong including path of rt7.h in ar7_wdt.c
Date: Mon, 10 Aug 2009 15:07:54 +0800
Message-Id: <1249888074-20784-1-git-send-email-wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 drivers/watchdog/ar7_wdt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/ar7_wdt.c b/drivers/watchdog/ar7_wdt.c
index 3fe9742..ec48e12 100644
--- a/drivers/watchdog/ar7_wdt.c
+++ b/drivers/watchdog/ar7_wdt.c
@@ -37,7 +37,7 @@
 #include <linux/uaccess.h>
 
 #include <asm/addrspace.h>
-#include <asm/ar7/ar7.h>
+#include <ar7.h>
 
 #define DRVNAME "ar7_wdt"
 #define LONGNAME "TI AR7 Watchdog Timer"
-- 
1.6.2.1

