Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbXIXHSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbXIXHSx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 03:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750890AbXIXHSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 03:18:46 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:40645 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbXIXHSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 03:18:45 -0400
Date: Mon, 24 Sep 2007 11:18:26 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, devel@openvz.org
Subject: [PATCH] Move kasprintf.o to obj-y
Message-ID: <20070924071826.GA6757@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Modular puppyvisor started giving linking errors

	  MODPOST 1 modules
	ERROR: "kasprintf" [drivers/lguest/lg.ko] undefined!

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 lib/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/Makefile
+++ b/lib/Makefile
@@ -2,7 +2,7 @@
 # Makefile for some libs needed in the kernel.
 #
 
-lib-y := ctype.o string.o vsprintf.o kasprintf.o cmdline.o \
+lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 rbtree.o radix-tree.o dump_stack.o \
 	 idr.o int_sqrt.o bitmap.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o argv_split.o
@@ -13,7 +13,7 @@ lib-$(CONFIG_SMP) += cpumask.o
 lib-y	+= kobject.o kref.o kobject_uevent.o klist.o
 
 obj-y += div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
-	 bust_spinlocks.o hexdump.o
+	 bust_spinlocks.o hexdump.o kasprintf.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG

