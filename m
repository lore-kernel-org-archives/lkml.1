Return-Path: <linux-kernel-owner+w=401wt.eu-S966242AbXDDBfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966242AbXDDBfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 21:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966247AbXDDBfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 21:35:10 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:51372 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966242AbXDDBfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 21:35:08 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 03 Apr 2007 18:35:06 -0700
Subject: [patch 1/3] epoll cleanups - epoll include diet ...
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.19972.1175650506.1>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove some unneeded include files from epoll code.


Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide



Index: linux-2.6.21-rc5.mm4/fs/eventpoll.c
===================================================================
--- linux-2.6.21-rc5.mm4.orig/fs/eventpoll.c	2007-04-03 17:59:54.000000000 -0700
+++ linux-2.6.21-rc5.mm4/fs/eventpoll.c	2007-04-03 18:33:30.000000000 -0700
@@ -1,6 +1,6 @@
 /*
- *  fs/eventpoll.c ( Efficent event polling implementation )
- *  Copyright (C) 2001,...,2006	 Davide Libenzi
+ *  fs/eventpoll.c (Efficent event notification implementation)
+ *  Copyright (C) 2001,...,2007	 Davide Libenzi
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -17,30 +17,21 @@
 #include <linux/sched.h>
 #include <linux/fs.h>
 #include <linux/file.h>
-#include <linux/signal.h>
 #include <linux/errno.h>
-#include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/poll.h>
 #include <linux/string.h>
 #include <linux/list.h>
 #include <linux/hash.h>
 #include <linux/spinlock.h>
-#include <linux/syscalls.h>
 #include <linux/rwsem.h>
 #include <linux/rbtree.h>
 #include <linux/wait.h>
 #include <linux/eventpoll.h>
-#include <linux/mount.h>
-#include <linux/bitops.h>
 #include <linux/mutex.h>
 #include <linux/anon_inodes.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
-#include <asm/io.h>
-#include <asm/mman.h>
 #include <asm/atomic.h>
-#include <asm/semaphore.h>
 
 
 /*

