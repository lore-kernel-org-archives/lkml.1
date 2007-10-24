Return-Path: <linux-kernel-owner+w=401wt.eu-S1753282AbXJXPQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbXJXPQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 11:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646AbXJXPQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 11:16:03 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:62696 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbXJXPQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 11:16:01 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.24-rc1] EXPORT_SYMBOL(__set_page_dirty_no_writeback);
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <200710250015.FFG17175.LSHOMOFVJFOFtQ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Thu, 25 Oct 2007 00:15:55 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I think __set_page_dirty_no_writeback should be exported so that
tmpfs-like filesystems can use it.

Signed-off-by: Tetsuo Handa  <penguin-kernel@I-love.SAKURA.ne.jp>

---
 mm/page-writeback.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/mm/page-writeback.c
===================================================================
--- linux-2.6.orig/mm/page-writeback.c	2007-10-25 00:04:46.000000000 +0900
+++ linux-2.6/mm/page-writeback.c	2007-10-25 00:05:45.000000000 +0900
@@ -975,6 +975,7 @@
 		SetPageDirty(page);
 	return 0;
 }
+EXPORT_SYMBOL(__set_page_dirty_no_writeback);
 
 /*
  * For address_spaces which do not use buffers.  Just tag the page as dirty in

