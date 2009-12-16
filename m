Return-Path: <linux-kernel-owner+w=401wt.eu-S934746AbZLPINH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934746AbZLPINH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 03:13:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761789AbZLPILn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 03:11:43 -0500
Received: from mail.perches.com ([173.55.12.10]:1207 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761755AbZLPIJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 03:09:16 -0500
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 11/14] kernel.h: Remove uses of NORET_TYPE
Date: Wed, 16 Dec 2009 00:09:10 -0800
Message-Id: <73b0225d8caf0322fb61c83dee7026c1b989464e.1260949674.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1260949674.git.joe@perches.com>
References: <cover.1260949674.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's useless
Replaced with extern just for consistency

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/kernel.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 5c97b73..e079744 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -126,14 +126,14 @@ static inline void might_fault(void)
 
 extern struct atomic_notifier_head panic_notifier_list;
 extern long (*panic_blink)(long time);
-NORET_TYPE void panic(const char *fmt, ...)
+extern void panic(const char *fmt, ...)
 	__attribute__ ((noreturn, format (printf, 1, 2))) __cold;
 extern void oops_enter(void);
 extern void oops_exit(void);
 extern int oops_may_print(void);
-NORET_TYPE void do_exit(long code)
+extern void do_exit(long code)
 	__attribute__ ((noreturn));
-NORET_TYPE void complete_and_exit(struct completion *comp, long code)
+extern void complete_and_exit(struct completion *comp, long code)
 	__attribute__ ((noreturn));
 
 /*
-- 
1.6.6.rc0.57.gad7a

