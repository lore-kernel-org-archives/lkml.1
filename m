Return-Path: <linux-kernel-owner+w=401wt.eu-S1765522AbXEUKTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765522AbXEUKTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762007AbXEUKJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:09:49 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:27800 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759951AbXEUKJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:09:22 -0400
X-IronPort-AV: i="4.14,560,1170651600"; 
   d="scan'208"; a="39510302:sNHT20230980"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 14/32] Blackfin arch: make sure we declare the revid functions as pure (since they are)
Date: Mon, 21 May 2007 18:09:22 +0800
Message-Id: <1179742185706-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1179742180228-git-send-email-bryan.wu@analog.com>
References: <1179742180228-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 include/asm-blackfin/processor.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-blackfin/processor.h b/include/asm-blackfin/processor.h
index 0336ff1..aba2b30 100644
--- a/include/asm-blackfin/processor.h
+++ b/include/asm-blackfin/processor.h
@@ -104,13 +104,13 @@ unsigned long get_wchan(struct task_struct *p);
 #define cpu_relax()    	barrier()
 
 /* Get the Silicon Revision of the chip */
-static inline uint32_t bfin_revid(void)
+static inline __attribute_pure__ uint32_t bfin_revid(void)
 {
 	/* stored in the upper 4 bits */
 	return bfin_read_CHIPID() >> 28;
 }
 
-static inline uint32_t bfin_compiled_revid(void)
+static inline __attribute_pure__ uint32_t bfin_compiled_revid(void)
 {
 #if defined(CONFIG_BF_REV_0_0)
 	return 0;
-- 
1.5.1.2
