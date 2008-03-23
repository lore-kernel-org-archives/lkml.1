Return-Path: <linux-kernel-owner+w=401wt.eu-S933895AbYCWJAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933895AbYCWJAp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 05:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760109AbYCWIMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:12:06 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2354 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760163AbYCWILq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:46 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 049/148] include/asm-x86/ioctls.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:24 -0700
Message-Id: <1206259443-13210-50-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/ioctls.h |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/asm-x86/ioctls.h b/include/asm-x86/ioctls.h
index 93c894d..c0c338b 100644
--- a/include/asm-x86/ioctls.h
+++ b/include/asm-x86/ioctls.h
@@ -47,12 +47,13 @@
 #define TIOCSBRK	0x5427  /* BSD compatibility */
 #define TIOCCBRK	0x5428  /* BSD compatibility */
 #define TIOCGSID	0x5429  /* Return the session ID of FD */
-#define TCGETS2		_IOR('T',0x2A, struct termios2)
-#define TCSETS2		_IOW('T',0x2B, struct termios2)
-#define TCSETSW2	_IOW('T',0x2C, struct termios2)
-#define TCSETSF2	_IOW('T',0x2D, struct termios2)
-#define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
-#define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
+#define TCGETS2		_IOR('T', 0x2A, struct termios2)
+#define TCSETS2		_IOW('T', 0x2B, struct termios2)
+#define TCSETSW2	_IOW('T', 0x2C, struct termios2)
+#define TCSETSF2	_IOW('T', 0x2D, struct termios2)
+#define TIOCGPTN	_IOR('T', 0x30, unsigned int)
+				/* Get Pty Number (of pty-mux device) */
+#define TIOCSPTLCK	_IOW('T', 0x31, int)  /* Lock/unlock Pty */
 
 #define FIONCLEX	0x5450
 #define FIOCLEX		0x5451
-- 
1.5.4.rc2

