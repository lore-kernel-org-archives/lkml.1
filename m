Return-Path: <linux-kernel-owner+w=401wt.eu-S1753146AbZLBGHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146AbZLBGHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 01:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753064AbZLBGHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 01:07:51 -0500
Received: from mail.perches.com ([173.55.12.10]:1218 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870AbZLBGHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 01:07:50 -0500
From: Joe Perches <joe@perches.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 08/13] drivers/block/floppy.c: Move leading && and || to preceding line
Date: Tue,  1 Dec 2009 22:07:48 -0800
Message-Id: <346d3c976b2c5cf1f8de5cf3f965f5463d4792c6.1259733457.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1259733456.git.joe@perches.com>
References: <cover.1259733456.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 90352f6..96b1b21 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -1163,8 +1163,8 @@ static const char *timeout_message;
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
@@ -2296,8 +2296,8 @@ irqreturn_t floppy_interrupt(int irq, void *dev_id)
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

