Return-Path: <linux-kernel-owner+w=401wt.eu-S1753155Ab0AVExV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab0AVExV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 23:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505Ab0AVExN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 23:53:13 -0500
Received: from mail.perches.com ([173.55.12.10]:1369 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753155Ab0AVExC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 23:53:02 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 24/24] drivers/block/floppy.c: Remove unnecessary return and braces
Date: Thu, 21 Jan 2010 20:52:54 -0800
Message-Id: <d0556fd2419da3e7811c71509126838c5bf9aa6f.1264133864.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1264133863.git.joe@perches.com>
References: <cover.1264133863.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index fd56b26..c917320 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -1796,10 +1796,8 @@ static void recalibrate_floppy(void)
 	debugt("recalibrate floppy:");
 	do_floppy = recal_interrupt;
 	output_byte(FD_RECALIBRATE);
-	if (output_byte(UNIT(current_drive)) < 0) {
+	if (output_byte(UNIT(current_drive)) < 0)
 		reset_fdc();
-		return;
-	}
 }
 
 /*
-- 
1.6.6.rc0.57.gad7a

