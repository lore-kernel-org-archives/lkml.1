Return-Path: <linux-kernel-owner+w=401wt.eu-S1753824Ab0AVEyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab0AVEyc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 23:54:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285Ab0AVExH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 23:53:07 -0500
Received: from mail.perches.com ([173.55.12.10]:1360 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922Ab0AVExA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 23:53:00 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 12/24] drivers/block/floppy.c: Remove a few spaces from function casts
Date: Thu, 21 Jan 2010 20:52:42 -0800
Message-Id: <8aa086bfe7272831f35583694e33d69795464d94.1264133863.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1264133863.git.joe@perches.com>
References: <cover.1264133863.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index d93fc9d..24a4a22 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -632,7 +632,7 @@ static inline void set_debugt(void) { }
 static inline void debugt(const char *message) { }
 #endif /* DEBUGT */
 
-typedef void (*timeout_fn) (unsigned long);
+typedef void (*timeout_fn)(unsigned long);
 static DEFINE_TIMER(fd_timeout, floppy_shutdown, 0, 0);
 
 static const char *timeout_message;
@@ -1036,7 +1036,7 @@ static void fd_watchdog(void)
 		reset_fdc();
 	} else {
 		del_timer(&fd_timer);
-		fd_timer.function = (timeout_fn) fd_watchdog;
+		fd_timer.function = (timeout_fn)fd_watchdog;
 		fd_timer.expires = jiffies + HZ / 10;
 		add_timer(&fd_timer);
 	}
@@ -1534,9 +1534,9 @@ static void setup_rw_floppy(void)
 		 */
 		if (time_after(ready_date, jiffies + DP->select_delay)) {
 			ready_date -= DP->select_delay;
-			function = (timeout_fn) floppy_start;
+			function = (timeout_fn)floppy_start;
 		} else
-			function = (timeout_fn) setup_rw_floppy;
+			function = (timeout_fn)setup_rw_floppy;
 
 		/* wait until the floppy is spinning fast enough */
 		if (fd_wait_for_completion(ready_date, function))
-- 
1.6.6.rc0.57.gad7a

