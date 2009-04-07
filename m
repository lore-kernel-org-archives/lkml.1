Return-Path: <linux-kernel-owner+w=401wt.eu-S1758437AbZDGQKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437AbZDGQKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 12:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758122AbZDGQKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 12:10:11 -0400
Received: from verein.lst.de ([213.95.11.210]:51281 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757047AbZDGQKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 12:10:09 -0400
Date: Tue, 7 Apr 2009 18:10:06 +0200
From: Christoph Hellwig <hch@lst.de>
To: jack@suse.cz
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] quota: remove obsolete comments in fs/quota/Makefile
Message-ID: <20090407161006.GC11384@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of useless comments and the equally useless obj-y
initialization.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/quota/Makefile
===================================================================
--- linux-2.6.orig/fs/quota/Makefile	2009-04-05 17:50:41.785445246 +0200
+++ linux-2.6/fs/quota/Makefile	2009-04-05 17:50:49.686570459 +0200
@@ -1,12 +1,3 @@
-#
-# Makefile for the Linux filesystems.
-#
-# 14 Sep 2000, Christoph Hellwig <hch@infradead.org>
-# Rewritten to use lists instead of if-statements.
-#
-
-obj-y :=
-
 obj-$(CONFIG_QUOTA)		+= dquot.o
 obj-$(CONFIG_QFMT_V1)		+= quota_v1.o
 obj-$(CONFIG_QFMT_V2)		+= quota_v2.o
