Return-Path: <linux-kernel-owner+w=401wt.eu-S1755617AbXLBMBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617AbXLBMBj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 07:01:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbXLBMBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 07:01:01 -0500
Received: from elvis.franken.de ([193.175.24.41]:58704 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412AbXLBMBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 07:01:00 -0500
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
cc: akpm@linux-foundation.org
Subject: [PATCH] CHAR: Use SGI_HAS_DS1286 for SGI_DS1286 depends
Message-Id: <20071202115536.56627C2EB6@solo.franken.de>
Date: Sun,  2 Dec 2007 12:55:36 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use SGI_HAS_DS1286 for SGI_DS1286 depends

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---

Please apply for 2.6.25.

 drivers/char/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index a509b8d..06271e8 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -777,7 +777,7 @@ config JS_RTC
 
 config SGI_DS1286
 	tristate "SGI DS1286 RTC support"
-	depends on SGI_IP22
+	depends on SGI_HAS_DS1286
 	help
 	  If you say Y here and create a character special file /dev/rtc with
 	  major number 10 and minor number 135 using mknod ("man mknod"), you
