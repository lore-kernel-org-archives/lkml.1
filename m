Return-Path: <linux-kernel-owner+w=401wt.eu-S1945908AbXDCUVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945908AbXDCUVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 16:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422695AbXDCUVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 16:21:16 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:51291 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945898AbXDCUVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 16:21:14 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 03 Apr 2007 13:21:11 -0700
Subject: [patch 3/5] new fds fixes for 2.6.21-rc5.mm4 - signalfd include files diet ...
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.27063.1175631672.3>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Removes a few unneeded include files from the signalfd code.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide



Index: linux-2.6.21-rc5.mm4/fs/signalfd.c
===================================================================
--- linux-2.6.21-rc5.mm4.orig/fs/signalfd.c	2007-04-03 13:17:25.000000000 -0700
+++ linux-2.6.21-rc5.mm4/fs/signalfd.c	2007-04-03 13:17:36.000000000 -0700
@@ -15,19 +15,15 @@
 
 #include <linux/file.h>
 #include <linux/poll.h>
-#include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/fs.h>
-#include <linux/mount.h>
-#include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/signal.h>
 #include <linux/list.h>
 #include <linux/anon_inodes.h>
 #include <linux/signalfd.h>
 
-#include <asm/uaccess.h>
-
 struct signalfd_ctx {
 	struct list_head lnk;
 	wait_queue_head_t wqh;

