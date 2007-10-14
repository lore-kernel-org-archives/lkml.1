Return-Path: <linux-kernel-owner+w=401wt.eu-S1762894AbXJNSeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762894AbXJNSeu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 14:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761986AbXJNSed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 14:34:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47908 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761790AbXJNSec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 14:34:32 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] synclink_gt endianness annotations
Cc: linux-kernel@vger.kernel.org, paulkf@microgate.com
Message-Id: <E1Ih8II-00040y-5c@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 14 Oct 2007 19:34:30 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/char/synclink_gt.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/synclink_gt.c b/drivers/char/synclink_gt.c
index 2f97d2f..64e835f 100644
--- a/drivers/char/synclink_gt.c
+++ b/drivers/char/synclink_gt.c
@@ -206,10 +206,10 @@ static void flush_cond_wait(struct cond_wait **head);
  */
 struct slgt_desc
 {
-	unsigned short count;
-	unsigned short status;
-	unsigned int pbuf;  /* physical address of data buffer */
-	unsigned int next;  /* physical address of next descriptor */
+	__le16 count;
+	__le16 status;
+	__le32 pbuf;  /* physical address of data buffer */
+	__le32 next;  /* physical address of next descriptor */
 
 	/* driver book keeping */
 	char *buf;          /* virtual  address of data buffer */
-- 
1.5.3.GIT


