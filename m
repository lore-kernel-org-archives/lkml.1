Return-Path: <linux-kernel-owner+w=401wt.eu-S1759720AbXKZQyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759720AbXKZQyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 11:54:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757471AbXKZQyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 11:54:31 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:47803 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758828AbXKZQyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 11:54:31 -0500
Date: Mon, 26 Nov 2007 17:50:34 +0100 (MET)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: reiserfs-dev@namesys.com
Cc: linux-kernel@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20071126163835.24343.91831.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH] [REISERFS]: Complement va_start() with va_end().
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Complement va_start() with va_end().

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Compile-tested on i386 with allyesconfig and allmodconfig.
BTW, the nested if()'s (lines above) may look better if unnested.


diff --git a/fs/reiserfs/prints.c b/fs/reiserfs/prints.c
index 5e7388b..740bb8c 100644
--- a/fs/reiserfs/prints.c
+++ b/fs/reiserfs/prints.c
@@ -575,6 +575,8 @@ void print_block(struct buffer_head *bh, ...)	//int print_mode, int first, int l
 					printk
 					    ("Block %llu contains unformatted data\n",
 					     (unsigned long long)bh->b_blocknr);
+
+	va_end(args);
 }
 
 static char print_tb_buf[2048];
