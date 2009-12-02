Return-Path: <linux-kernel-owner+w=401wt.eu-S1753586AbZLBGH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbZLBGH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 01:07:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752907AbZLBGH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 01:07:56 -0500
Received: from mail.perches.com ([173.55.12.10]:1242 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946AbZLBGHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 01:07:50 -0500
From: Joe Perches <joe@perches.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 13/13] drivers/block/floppy.c: Remove unnecessary return and braces
Date: Tue,  1 Dec 2009 22:07:53 -0800
Message-Id: <21a2d5c6fb68a645cf2cfde9dceb487411d23f54.1259733457.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1259733456.git.joe@perches.com>
References: <cover.1259733456.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 7c33f61..3c36302 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -2321,10 +2321,8 @@ static void recalibrate_floppy(void)
 	debugt("recalibrate floppy:");
 	do_floppy = recal_interrupt;
 	output_byte(FD_RECALIBRATE);
-	if (UNIT(current_drive) < 0) {
+	if (UNIT(current_drive) < 0)
 		reset_fdc();
-		return;
-	}
 }
 
 /*
-- 
1.6.6.rc0.57.gad7a

