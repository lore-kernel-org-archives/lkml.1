Return-Path: <linux-kernel-owner+w=401wt.eu-S1765415AbXEUKSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765415AbXEUKSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757113AbXEUKJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:09:46 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:33581 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757223AbXEUKJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:09:21 -0400
X-IronPort-AV: i="4.14,560,1170651600"; 
   d="scan'208"; a="39510298:sNHT26339978"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 10/32] Blackfin arch: GPIO fix some defines
Date: Mon, 21 May 2007 18:09:18 +0800
Message-Id: <11797421841035-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1179742180228-git-send-email-bryan.wu@analog.com>
References: <1179742180228-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 include/asm-blackfin/gpio.h |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/asm-blackfin/gpio.h b/include/asm-blackfin/gpio.h
index d16fe3c..aa0d550 100644
--- a/include/asm-blackfin/gpio.h
+++ b/include/asm-blackfin/gpio.h
@@ -148,10 +148,6 @@
 
 #ifdef BF537_FAMILY
 #define MAX_BLACKFIN_GPIOS 48
-#define PORT_F 0
-#define PORT_G 1
-#define PORT_H 2
-#define PORT_J 3
 
 #define	GPIO_PF0	0
 #define	GPIO_PF1	1
@@ -202,13 +198,17 @@
 #define	GPIO_PH14      	46
 #define	GPIO_PH15      	47
 
+#define PORT_F GPIO_PF0
+#define PORT_G GPIO_PG0
+#define PORT_H GPIO_PH0
+
 #endif
 
 #ifdef BF561_FAMILY
 #define MAX_BLACKFIN_GPIOS 48
-#define PORT_FIO0 0
-#define PORT_FIO1 1
-#define PORT_FIO2 2
+#define PORT_FIO0 GPIO_0
+#define PORT_FIO1 GPIO_16
+#define PORT_FIO2 GPIO_32
 #endif
 
 #ifndef __ASSEMBLY__
-- 
1.5.1.2
