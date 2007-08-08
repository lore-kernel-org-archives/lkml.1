Return-Path: <linux-kernel-owner+w=401wt.eu-S936128AbXHHDgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936128AbXHHDgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 23:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933113AbXHHDft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 23:35:49 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:18048 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932449AbXHHDfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 23:35:48 -0400
X-IronPort-AV: i="4.19,233,1183348800"; 
   d="scan'208"; a="47739375:sNHT21159474"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Cc: dbrownell@users.sourceforge.net, Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 07/12] Blackfin arch: bug fixing, add missing BF533_FAMILY GPIO_PFx definition
Date: Wed,  8 Aug 2007 11:35:32 +0800
Message-Id: <11865441402489-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.2
In-Reply-To: <11865441373719-git-send-email-bryan.wu@analog.com>
References: <11865441373719-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 include/asm-blackfin/gpio.h |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/include/asm-blackfin/gpio.h b/include/asm-blackfin/gpio.h
index e714363..dd203cd 100644
--- a/include/asm-blackfin/gpio.h
+++ b/include/asm-blackfin/gpio.h
@@ -144,6 +144,24 @@
 
 #ifdef BF533_FAMILY
 #define MAX_BLACKFIN_GPIOS 16
+
+#define	GPIO_PF0	0
+#define	GPIO_PF1	1
+#define	GPIO_PF2	2
+#define	GPIO_PF3	3
+#define	GPIO_PF4	4
+#define	GPIO_PF5	5
+#define	GPIO_PF6	6
+#define	GPIO_PF7	7
+#define	GPIO_PF8	8
+#define	GPIO_PF9	9
+#define	GPIO_PF10	10
+#define	GPIO_PF11	11
+#define	GPIO_PF12	12
+#define	GPIO_PF13	13
+#define	GPIO_PF14	14
+#define	GPIO_PF15	15
+
 #endif
 
 #ifdef BF537_FAMILY
-- 
1.5.2
