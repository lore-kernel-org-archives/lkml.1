Return-Path: <linux-kernel-owner+w=401wt.eu-S1946664AbXBIQoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946664AbXBIQoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946646AbXBIQjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:39:22 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51699 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946649AbXBIQjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:39:06 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] offsetof is size_t
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1HFYm9-0006oI-Mi@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 09 Feb 2007 16:39:05 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/macintosh/rack-meter.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/macintosh/rack-meter.c b/drivers/macintosh/rack-meter.c
index 5ed41fe..f83fad2 100644
--- a/drivers/macintosh/rack-meter.c
+++ b/drivers/macintosh/rack-meter.c
@@ -171,11 +171,11 @@ static void rackmeter_setup_dbdma(struct rackmeter *rm)
 	/* Make sure dbdma is reset */
 	DBDMA_DO_RESET(rm->dma_regs);
 
-	pr_debug("rackmeter: mark offset=0x%lx\n",
+	pr_debug("rackmeter: mark offset=0x%zx\n",
 		 offsetof(struct rackmeter_dma, mark));
-	pr_debug("rackmeter: buf1 offset=0x%lx\n",
+	pr_debug("rackmeter: buf1 offset=0x%zx\n",
 		 offsetof(struct rackmeter_dma, buf1));
-	pr_debug("rackmeter: buf2 offset=0x%lx\n",
+	pr_debug("rackmeter: buf2 offset=0x%zx\n",
 		 offsetof(struct rackmeter_dma, buf2));
 
 	/* Prepare 4 dbdma commands for the 2 buffers */
-- 
1.5.0-rc2.GIT


