Return-Path: <linux-kernel-owner+w=401wt.eu-S1752706AbYHRIZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbYHRIZK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 04:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751074AbYHRIY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 04:24:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:54765 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbYHRIY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 04:24:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,227,1217833200"; 
   d="scan'208";a="430029659"
Subject: [PATCH] ftrace: fix incorrect comment style of
	__ftrace_enabled_save()
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 18 Aug 2008 16:24:56 +0800
Message-Id: <1219047896.5663.57.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes incorrect comment style of __ftrace_enabled_save().

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 include/linux/ftrace.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -98,9 +98,11 @@ static inline void tracer_disable(void)
 #endif
 }
 
-/* Ftrace disable/restore without lock. Some synchronization mechanism
+/*
+ * Ftrace disable/restore without lock. Some synchronization mechanism
  * must be used to prevent ftrace_enabled to be changed between
- * disable/restore. */
+ * disable/restore.
+ */
 static inline int __ftrace_enabled_save(void)
 {
 #ifdef CONFIG_FTRACE


