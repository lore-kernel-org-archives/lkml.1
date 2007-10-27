Return-Path: <linux-kernel-owner+w=401wt.eu-S1756107AbXJ0Pcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbXJ0Pcy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 11:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751743AbXJ0Pcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 11:32:46 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:48660 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbXJ0Pcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 11:32:46 -0400
Message-ID: <47235A1B.7000400@tiscali.nl>
Date: Sat, 27 Oct 2007 17:32:43 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix 'and' typo in drivers/block/paride/pt.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix 'and' typo (PT_WRITE_OK is defined 2)

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/block/paride/pt.c b/drivers/block/paride/pt.c
index 9f4e67e..b91accf 100644
--- a/drivers/block/paride/pt.c
+++ b/drivers/block/paride/pt.c
@@ -664,7 +664,7 @@ static int pt_open(struct inode *inode, struct file *file)
 		goto out;
 
 	err = -EROFS;
-	if ((!tape->flags & PT_WRITE_OK) && (file->f_mode & 2))
+	if ((!(tape->flags & PT_WRITE_OK)) && (file->f_mode & 2))
 		goto out;
 
 	if (!(iminor(inode) & 128))
