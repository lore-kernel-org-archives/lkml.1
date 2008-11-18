Return-Path: <linux-kernel-owner+w=401wt.eu-S1752438AbYKRG7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbYKRG7A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 01:59:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751058AbYKRG6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 01:58:53 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:15805 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbYKRG6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 01:58:52 -0500
X-IronPort-AV: E=Sophos;i="4.33,623,1220241600"; 
   d="scan'208";a="62688204"
From: Bryan Wu <cooloney@kernel.org>
To: a.zummo@towertech.it, rtc-linux@googlegroups.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH] genrtc: disable genrtc on Blackfin systems
Date: Tue, 18 Nov 2008 15:00:15 +0800
Message-Id: <1226991615-30268-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/char/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 43d6ba8..a92a60a 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -814,7 +814,7 @@ config JS_RTC
 
 config GEN_RTC
 	tristate "Generic /dev/rtc emulation"
-	depends on RTC!=y && !IA64 && !ARM && !M32R && !MIPS && !SPARC && !FRV && !S390 && !SUPERH && !AVR32
+	depends on RTC!=y && !IA64 && !ARM && !M32R && !MIPS && !SPARC && !FRV && !S390 && !SUPERH && !AVR32 && !BLACKFIN
 	---help---
 	  If you say Y here and create a character special file /dev/rtc with
 	  major number 10 and minor number 135 using mknod ("man mknod"), you
-- 
1.5.6.3
