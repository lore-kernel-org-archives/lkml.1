Return-Path: <linux-kernel-owner+w=401wt.eu-S1763157AbXLNPRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763157AbXLNPRr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 10:17:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759321AbXLNPR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 10:17:28 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:59122 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758866AbXLNPR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 10:17:26 -0500
Date: Fri, 14 Dec 2007 17:17:25 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: alan@redhat.com, viro@zeniv.linux.org.uk, hch@infradead.org,
       peterz@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: [RFC/PATCH 5/8] revoke: add to makefile V7
Message-ID: <Pine.LNX.4.64.0712141716550.28689@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Add fs/revoke.c and fs/revoked_inode.c to build when CONFIG_MMU is enabled.

Cc: Alan Cox <alan@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 fs/Makefile |    1 +
 1 file changed, 1 insertion(+)

Index: 2.6/fs/Makefile
===================================================================
--- 2.6.orig/fs/Makefile	2007-11-23 09:58:11.000000000 +0200
+++ 2.6/fs/Makefile	2007-12-14 16:40:57.000000000 +0200
@@ -19,6 +19,7 @@ else
 obj-y +=	no-block.o
 endif
 
+obj-$(CONFIG_MMU)		+= revoke.o revoked_inode.o
 obj-$(CONFIG_INOTIFY)		+= inotify.o
 obj-$(CONFIG_INOTIFY_USER)	+= inotify_user.o
 obj-$(CONFIG_EPOLL)		+= eventpoll.o
