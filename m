Return-Path: <linux-kernel-owner+w=401wt.eu-S1762524AbXKNS6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762524AbXKNS6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 13:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756321AbXKNS6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 13:58:13 -0500
Received: from cantor.suse.de ([195.135.220.2]:60252 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbXKNS6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 13:58:11 -0500
Subject: patch uml-fix-kernel-vs-libc-symbols-clash.patch queued to -stable tree
To: jdike@addtoit.com, akpm@linux-foundation.org, gregkh@suse.de,
       jdike@linux.intel.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org,
       user-mode-linux-devel@lists.sourceforge.net
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@suse.de>
Date: Wed, 14 Nov 2007 10:58:00 -0800
In-Reply-To: <20071101195326.GA8888@c2.user-mode-linux.org>
Message-Id: <20071114185809.114D614540D0@imap.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that we have just queued up the patch titled

     Subject: UML - Fix kernel vs libc symbols clash

to the 2.6.23-stable tree.  Its filename is

     uml-fix-kernel-vs-libc-symbols-clash.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From stable-bounces@linux.kernel.org Thu Nov  1 12:54:06 2007
From: Jeff Dike <jdike@addtoit.com>
Date: Thu, 1 Nov 2007 15:53:26 -0400
Subject: UML - Fix kernel vs libc symbols clash
To: stable@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Message-ID: <20071101195326.GA8888@c2.user-mode-linux.org>
Content-Disposition: inline


From: Jeff Dike <jdike@addtoit.com>

commit 818f6ef407b448cef63294b9d0f6f8a2af9cb817 in mainline.

uml: fix an IPV6 libc vs kernel symbol clash

On some systems, with IPV6 configured, there is a clash between the kernel's
in6addr_any and the one in libc.

This is handled in the usual (gross) way of defining the kernel symbol out of
the way on the gcc command line.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/um/Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -60,7 +60,8 @@ SYS_DIR		:= $(ARCH_DIR)/include/sysdep-$
 
 CFLAGS += $(CFLAGS-y) -D__arch_um__ -DSUBARCH=\"$(SUBARCH)\"	\
 	$(ARCH_INCLUDE) $(MODE_INCLUDE) -Dvmap=kernel_vmap	\
-	-Din6addr_loopback=kernel_in6addr_loopback
+	-Din6addr_loopback=kernel_in6addr_loopback \
+	-Din6addr_any=kernel_in6addr_any
 
 AFLAGS += $(ARCH_INCLUDE)
 


Patches currently in stable-queue which might be from jdike@addtoit.com are

queue-2.6.23/uml-stop-using-libc-asm-page.h.patch
queue-2.6.23/uml-fix-kernel-vs-libc-symbols-clash.patch
queue-2.6.23/uml-stop-using-libc-asm-user.h.patch
