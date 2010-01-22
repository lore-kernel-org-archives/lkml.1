Return-Path: <linux-kernel-owner+w=401wt.eu-S1753927Ab0AVEz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab0AVEz4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 23:55:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636Ab0AVEzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 23:55:01 -0500
Received: from mail.perches.com ([173.55.12.10]:1354 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066Ab0AVExB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 23:53:01 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 20/24] drivers/block/floppy.c: Move leading && and || to preceding line
Date: Thu, 21 Jan 2010 20:52:50 -0800
Message-Id: <c229618c860089d2f83426cc843d2e90276dd287.1264133863.git.joe@perches.com>
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
index ab62fa8..5e3286d 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -639,8 +639,8 @@ static const char *timeout_message;
 static void is_alive(const char *message)
 {
 	/* this routine checks whether the floppy driver is "alive" */
-	if (test_bit(0, &fdc_busy) && command_status < 2
-	    && !timer_pending(&fd_timeout)) {
+	if (test_bit(0, &fdc_busy) && command_status < 2 &&
+	    !timer_pending(&fd_timeout)) {
 		DPRINT("timeout handler died: %s\n", message);
 	}
 }
@@ -1769,8 +1769,8 @@ irqreturn_t floppy_interrupt(int irq, void *dev_id)
 			if (do_print)
 				print_result("sensei", inr);
 			max_sensei--;
-		} while ((ST0 & 0x83) != UNIT(current_drive) && inr == 2
-			 && max_sensei);
+		} while ((ST0 & 0x83) != UNIT(current_drive) &&
+			 inr == 2 && max_sensei);
 	}
 	if (!handler) {
 		FDCS->reset = 1;
-- 
1.6.6.rc0.57.gad7a

