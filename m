Return-Path: <linux-kernel-owner+w=401wt.eu-S934743AbZLPIMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934743AbZLPIMS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 03:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761775AbZLPILp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 03:11:45 -0500
Received: from mail.perches.com ([173.55.12.10]:1206 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761754AbZLPIJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 03:09:16 -0500
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 09/14] kernel.h: Don't use NORET_AND just use noreturn, instead
Date: Wed, 16 Dec 2009 00:09:08 -0800
Message-Id: <0d7489e6b52210d5f972ad80570c059b63124c2a.1260949674.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1260949674.git.joe@perches.com>
References: <cover.1260949674.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/kernel.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 97c80c7..3b796b9 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -127,7 +127,7 @@ static inline void might_fault(void)
 extern struct atomic_notifier_head panic_notifier_list;
 extern long (*panic_blink)(long time);
 NORET_TYPE void panic(const char *fmt, ...)
-	__attribute__ ((NORET_AND format (printf, 1, 2))) __cold;
+	__attribute__ ((noreturn, format (printf, 1, 2))) __cold;
 extern void oops_enter(void);
 extern void oops_exit(void);
 extern int oops_may_print(void);
-- 
1.6.6.rc0.57.gad7a

