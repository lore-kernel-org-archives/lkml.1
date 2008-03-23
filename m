Return-Path: <linux-kernel-owner+w=401wt.eu-S1765785AbYCWJCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765785AbYCWJCo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 05:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760268AbYCWIMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:12:12 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2361 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760145AbYCWILt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:49 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 126/148] include/asm-x86/termios.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:41 -0700
Message-Id: <1206259443-13210-127-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/termios.h |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/asm-x86/termios.h b/include/asm-x86/termios.h
index f729563..7cff8bf 100644
--- a/include/asm-x86/termios.h
+++ b/include/asm-x86/termios.h
@@ -54,10 +54,11 @@ struct termio {
 /*
  * Translate a "termio" structure into a "termios". Ugh.
  */
-#define SET_LOW_TERMIOS_BITS(termios, termio, x) { \
-	unsigned short __tmp; \
-	get_user(__tmp,&(termio)->x); \
-	*(unsigned short *) &(termios)->x = __tmp; \
+#define SET_LOW_TERMIOS_BITS(termios, termio, x)		\
+{								\
+	unsigned short __tmp;					\
+	get_user(__tmp, &(termio)->x);				\
+	*(unsigned short *)&(termios)->x = __tmp;		\
 }
 
 static inline int user_termio_to_kernel_termios(struct ktermios *termios,
-- 
1.5.4.rc2

