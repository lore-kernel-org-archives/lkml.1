Return-Path: <linux-kernel-owner+w=401wt.eu-S935012AbXLQTnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935012AbXLQTnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:43:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758060AbXLQTby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:31:54 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2995 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761158AbXLQTbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:31:45 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mike Miller <mike.miller@hp.com>, iss_storagedev@hp.com
Subject: [PATCH] drivers/block/: Spelling fixes
Date: Mon, 17 Dec 2007 11:30:29 -0800
Message-Id: <1197919875-5288-30-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918890.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/cciss_scsi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index 63ee6c0..55178e9 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -1453,7 +1453,7 @@ static int cciss_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 	rc = sendcmd(CCISS_RESET_MSG, ctlr, NULL, 0, 2, 0, 0, 
 		(unsigned char *) &cmd_in_trouble->Header.LUN.LunAddrBytes[0], 
 		TYPE_MSG);
-	/* sendcmd turned off interrputs on the board, turn 'em back on. */
+	/* sendcmd turned off interrupts on the board, turn 'em back on. */
 	(*c)->access.set_intr_mask(*c, CCISS_INTR_ON);
 	if (rc == 0)
 		return SUCCESS;
@@ -1483,7 +1483,7 @@ static int  cciss_eh_abort_handler(struct scsi_cmnd *scsicmd)
 		0, 2, 0, 0, 
 		(unsigned char *) &cmd_to_abort->Header.LUN.LunAddrBytes[0], 
 		TYPE_MSG);
-	/* sendcmd turned off interrputs on the board, turn 'em back on. */
+	/* sendcmd turned off interrupts on the board, turn 'em back on. */
 	(*c)->access.set_intr_mask(*c, CCISS_INTR_ON);
 	if (rc == 0)
 		return SUCCESS;
-- 
1.5.3.7.949.g2221a6

