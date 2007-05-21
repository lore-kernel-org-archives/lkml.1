Return-Path: <linux-kernel-owner+w=401wt.eu-S1763165AbXEUKNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763165AbXEUKNB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:13:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761653AbXEUKJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:09:24 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:23653 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756582AbXEUKJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:09:13 -0400
X-IronPort-AV: i="4.14,560,1170651600"; 
   d="scan'208"; a="30505448:sNHT22313697"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Sonic Zhang <sonic.zhang@analog.com>, Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 26/32] Blackfin arch: Change NO_ACCESS_CHECK to ACCESS_CHECK
Date: Mon, 21 May 2007 18:09:34 +0800
Message-Id: <11797421882159-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1179742180228-git-send-email-bryan.wu@analog.com>
References: <1179742180228-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 include/asm-blackfin/uaccess.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-blackfin/uaccess.h b/include/asm-blackfin/uaccess.h
index bfcb679..2233f8f 100644
--- a/include/asm-blackfin/uaccess.h
+++ b/include/asm-blackfin/uaccess.h
@@ -14,7 +14,7 @@
 #include <linux/string.h>
 
 #include <asm/segment.h>
-#ifndef CONFIG_NO_ACCESS_CHECK
+#ifdef CONFIG_ACCESS_CHECK
 # include <asm/bfin-global.h>
 #endif
 
@@ -56,7 +56,7 @@ static inline int is_in_rom(unsigned long addr)
  * get_fs() == KERNEL_DS, checking is bypassed.
  */
 
-#ifdef CONFIG_NO_ACCESS_CHECK
+#ifndef CONFIG_ACCESS_CHECK
 static inline int _access_ok(unsigned long addr, unsigned long size) { return 1; }
 #else
 #ifdef CONFIG_ACCESS_OK_L1
-- 
1.5.1.2
