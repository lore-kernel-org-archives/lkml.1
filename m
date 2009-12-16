Return-Path: <linux-kernel-owner+w=401wt.eu-S1761776AbZLPILL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761776AbZLPILL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 03:11:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934694AbZLPIKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 03:10:45 -0500
Received: from mail.perches.com ([173.55.12.10]:1211 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761769AbZLPIJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 03:09:17 -0500
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 14/14] kernel/exit.c and kernel/panic.c: Remove unused NORET_TYPE
Date: Wed, 16 Dec 2009 00:09:13 -0800
Message-Id: <29e53e769a3f0b38ea8347b95c8947d3f50ab4c6.1260949674.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1260949674.git.joe@perches.com>
References: <cover.1260949674.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the functions match the prototypes in <linux/kernel.h>
It's defined to nothing and useless

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/exit.c  |    4 ++--
 kernel/panic.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 5962d7c..ebb485c 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -886,7 +886,7 @@ static void check_stack_usage(void)
 static inline void check_stack_usage(void) {}
 #endif
 
-NORET_TYPE void do_exit(long code)
+void do_exit(long code)
 {
 	struct task_struct *tsk = current;
 	int group_dead;
@@ -1029,7 +1029,7 @@ NORET_TYPE void do_exit(long code)
 
 EXPORT_SYMBOL_GPL(do_exit);
 
-NORET_TYPE void complete_and_exit(struct completion *comp, long code)
+void complete_and_exit(struct completion *comp, long code)
 {
 	if (comp)
 		complete(comp);
diff --git a/kernel/panic.c b/kernel/panic.c
index 96b45d0..08d24b2 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -52,7 +52,7 @@ EXPORT_SYMBOL(panic_blink);
  *
  *	This function never returns.
  */
-NORET_TYPE void panic(const char * fmt, ...)
+void panic(const char * fmt, ...)
 {
 	static char buf[1024];
 	va_list args;
-- 
1.6.6.rc0.57.gad7a

