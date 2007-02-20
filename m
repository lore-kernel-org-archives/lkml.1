Return-Path: <linux-kernel-owner+w=401wt.eu-S965606AbXBTAIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965606AbXBTAIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:08:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbXBTAIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:08:23 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:36119 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750933AbXBTAHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:07:48 -0500
Date: Tue, 20 Feb 2007 01:07:47 +0100
From: Adrian Bunk <bunk@stusta.de>
To: David Chinner <dgc@sgi.com>
Cc: xfs-masters@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make xfs_buftarg_list static again
Message-ID: <20070220000747.GC13958@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

xfs_buftarg_list became global for no good reason.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.20-mm2/fs/xfs/linux-2.6/xfs_buf.c.old	2007-02-18 22:55:40.000000000 +0100
+++ linux-2.6.20-mm2/fs/xfs/linux-2.6/xfs_buf.c	2007-02-18 22:56:08.000000000 +0100
@@ -1424,7 +1424,7 @@
 /*
  *	buftarg list for delwrite queue processing
  */
-LIST_HEAD(xfs_buftarg_list);
+static LIST_HEAD(xfs_buftarg_list);
 static DEFINE_SPINLOCK(xfs_buftarg_lock);
 
 STATIC void

