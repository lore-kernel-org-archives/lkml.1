Return-Path: <linux-kernel-owner+w=401wt.eu-S934011AbXCVQKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934011AbXCVQKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 12:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934103AbXCVQKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 12:10:11 -0400
Received: from [198.99.130.12] ([198.99.130.12]:53378 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S934102AbXCVQJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 12:09:50 -0400
Date: Thu, 22 Mar 2007 12:06:48 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [ PATCH 6/7 ] UML - Remove user_util.h
Message-ID: <20070322160648.GA7022@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

user_util.h isn't needed any more, so delete it and remove all
includes of it.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/drivers/chan_kern.c              |    1 
 arch/um/drivers/chan_user.c              |    1 
 arch/um/drivers/cow_sys.h                |    1 
 arch/um/drivers/daemon_user.c            |    1 
 arch/um/drivers/fd.c                     |    1 
 arch/um/drivers/harddog_user.c           |    1 
 arch/um/drivers/line.c                   |    1 
 arch/um/drivers/mcast_user.c             |    1 
 arch/um/drivers/mconsole_kern.c          |    1 
 arch/um/drivers/mconsole_user.c          |    1 
 arch/um/drivers/mmapper_kern.c           |    1 
 arch/um/drivers/net_kern.c               |    1 
 arch/um/drivers/net_user.c               |    1 
 arch/um/drivers/port_user.c              |    1 
 arch/um/drivers/pty.c                    |    1 
 arch/um/drivers/slip_user.c              |    1 
 arch/um/drivers/slirp_user.c             |    1 
 arch/um/drivers/ssl.c                    |    1 
 arch/um/drivers/stdio_console.c          |    1 
 arch/um/drivers/tty.c                    |    1 
 arch/um/drivers/ubd_kern.c               |    1 
 arch/um/drivers/ubd_user.c               |    1 
 arch/um/drivers/xterm.c                  |    1 
 arch/um/include/user_util.h              |   32 -------------------------------
 arch/um/kernel/exec.c                    |    1 
 arch/um/kernel/init_task.c               |    1 
 arch/um/kernel/initrd.c                  |    1 
 arch/um/kernel/irq.c                     |    1 
 arch/um/kernel/ksyms.c                   |    1 
 arch/um/kernel/mem.c                     |    1 
 arch/um/kernel/physmem.c                 |    1 
 arch/um/kernel/process.c                 |    1 
 arch/um/kernel/reboot.c                  |    1 
 arch/um/kernel/signal.c                  |    1 
 arch/um/kernel/skas/process.c            |    1 
 arch/um/kernel/skas/tlb.c                |    1 
 arch/um/kernel/smp.c                     |    1 
 arch/um/kernel/syscall.c                 |    1 
 arch/um/kernel/sysrq.c                   |    1 
 arch/um/kernel/time.c                    |    1 
 arch/um/kernel/tlb.c                     |    1 
 arch/um/kernel/trap.c                    |    1 
 arch/um/kernel/tt/exec_kern.c            |    1 
 arch/um/kernel/tt/exec_user.c            |    1 
 arch/um/kernel/tt/gdb.c                  |    1 
 arch/um/kernel/tt/mem.c                  |    1 
 arch/um/kernel/tt/mem_user.c             |    1 
 arch/um/kernel/tt/process_kern.c         |    1 
 arch/um/kernel/tt/ptproxy/proxy.c        |    1 
 arch/um/kernel/tt/ptproxy/ptrace.c       |    1 
 arch/um/kernel/tt/ptproxy/sysdep.c       |    1 
 arch/um/kernel/tt/ptproxy/wait.c         |    1 
 arch/um/kernel/tt/syscall_user.c         |    1 
 arch/um/kernel/tt/tlb.c                  |    1 
 arch/um/kernel/tt/tracer.c               |    1 
 arch/um/kernel/tt/trap_user.c            |    1 
 arch/um/kernel/tt/uaccess_user.c         |    1 
 arch/um/kernel/um_arch.c                 |    1 
 arch/um/os-Linux/drivers/ethertap_user.c |    1 
 arch/um/os-Linux/drivers/tuntap_user.c   |    1 
 arch/um/os-Linux/file.c                  |    1 
 arch/um/os-Linux/helper.c                |    1 
 arch/um/os-Linux/irq.c                   |    1 
 arch/um/os-Linux/main.c                  |    1 
 arch/um/os-Linux/mem.c                   |    1 
 arch/um/os-Linux/process.c               |    1 
 arch/um/os-Linux/sigio.c                 |    1 
 arch/um/os-Linux/signal.c                |    1 
 arch/um/os-Linux/skas/mem.c              |    1 
 arch/um/os-Linux/skas/process.c          |    1 
 arch/um/os-Linux/skas/trap.c             |    1 
 arch/um/os-Linux/start_up.c              |    1 
 arch/um/os-Linux/sys-i386/tls.c          |    1 
 arch/um/os-Linux/time.c                  |    1 
 arch/um/os-Linux/trap.c                  |    1 
 arch/um/os-Linux/tt.c                    |    1 
 arch/um/os-Linux/util.c                  |    1 
 arch/um/sys-i386/bugs.c                  |    1 
 arch/um/sys-i386/ptrace_user.c           |    1 
 arch/um/sys-ppc/sigcontext.c             |    1 
 80 files changed, 111 deletions(-)

Index: linux-2.6.21-mm/arch/um/drivers/chan_kern.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/chan_kern.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/chan_kern.c	2007-03-21 17:30:34.000000000 -0400
@@ -12,7 +12,6 @@
 #include <linux/tty_flip.h>
 #include <asm/irq.h>
 #include "chan_kern.h"
-#include "user_util.h"
 #include "kern.h"
 #include "irq_user.h"
 #include "sigio.h"
Index: linux-2.6.21-mm/arch/um/drivers/chan_user.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/chan_user.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/chan_user.c	2007-03-21 17:30:34.000000000 -0400
@@ -14,7 +14,6 @@
 #include <sys/ioctl.h>
 #include <sys/socket.h>
 #include "kern_util.h"
-#include "user_util.h"
 #include "chan_user.h"
 #include "user.h"
 #include "os.h"
Index: linux-2.6.21-mm/arch/um/drivers/cow_sys.h
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/cow_sys.h	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/cow_sys.h	2007-03-21 17:30:34.000000000 -0400
@@ -2,7 +2,6 @@
 #define __COW_SYS_H__
 
 #include "kern_util.h"
-#include "user_util.h"
 #include "os.h"
 #include "user.h"
 #include "um_malloc.h"
Index: linux-2.6.21-mm/arch/um/drivers/daemon_user.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/daemon_user.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/daemon_user.c	2007-03-21 17:30:34.000000000 -0400
@@ -14,7 +14,6 @@
 #include "net_user.h"
 #include "daemon.h"
 #include "kern_util.h"
-#include "user_util.h"
 #include "user.h"
 #include "os.h"
 #include "um_malloc.h"
Index: linux-2.6.21-mm/arch/um/drivers/fd.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/fd.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/fd.c	2007-03-21 17:30:34.000000000 -0400
@@ -9,7 +9,6 @@
 #include <termios.h>
 #include <errno.h>
 #include "user.h"
-#include "user_util.h"
 #include "chan_user.h"
 #include "os.h"
 #include "um_malloc.h"
Index: linux-2.6.21-mm/arch/um/drivers/harddog_user.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/harddog_user.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/harddog_user.c	2007-03-21 17:30:34.000000000 -0400
@@ -6,7 +6,6 @@
 #include <stdio.h>
 #include <unistd.h>
 #include <errno.h>
-#include "user_util.h"
 #include "user.h"
 #include "mconsole.h"
 #include "os.h"
Index: linux-2.6.21-mm/arch/um/drivers/line.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/line.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/line.c	2007-03-21 17:30:34.000000000 -0400
@@ -13,7 +13,6 @@
 #include "irq_user.h"
 #include "line.h"
 #include "kern.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "os.h"
 #include "irq_kern.h"
Index: linux-2.6.21-mm/arch/um/drivers/mcast_user.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/mcast_user.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/mcast_user.c	2007-03-21 17:30:34.000000000 -0400
@@ -20,7 +20,6 @@
 #include "net_user.h"
 #include "mcast.h"
 #include "kern_util.h"
-#include "user_util.h"
 #include "user.h"
 #include "os.h"
 #include "um_malloc.h"
Index: linux-2.6.21-mm/arch/um/drivers/mconsole_kern.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/mconsole_kern.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/mconsole_kern.c	2007-03-21 17:30:34.000000000 -0400
@@ -25,7 +25,6 @@
 #include "linux/console.h"
 #include "asm/irq.h"
 #include "asm/uaccess.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "kern.h"
 #include "mconsole.h"
Index: linux-2.6.21-mm/arch/um/drivers/mconsole_user.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/mconsole_user.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/mconsole_user.c	2007-03-21 17:30:34.000000000 -0400
@@ -17,7 +17,6 @@
 #include "sysdep/ptrace.h"
 #include "mconsole.h"
 #include "os.h"
-#include "user_util.h"
 
 static struct mconsole_command commands[] = {
 	/* With uts namespaces, uts information becomes process-specific, so
Index: linux-2.6.21-mm/arch/um/drivers/mmapper_kern.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/mmapper_kern.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/mmapper_kern.c	2007-03-21 17:30:34.000000000 -0400
@@ -15,7 +15,6 @@
 #include <linux/miscdevice.h>
 #include <asm/uaccess.h>
 #include "mem_user.h"
-#include "user_util.h"
  
 /* These are set in mmapper_init, which is called at boot time */
 static unsigned long mmapper_size;
Index: linux-2.6.21-mm/arch/um/drivers/net_kern.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/net_kern.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/net_kern.c	2007-03-21 17:30:34.000000000 -0400
@@ -21,7 +21,6 @@
 #include "linux/ethtool.h"
 #include "linux/platform_device.h"
 #include "asm/uaccess.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "net_kern.h"
 #include "net_user.h"
Index: linux-2.6.21-mm/arch/um/drivers/net_user.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/net_user.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/net_user.c	2007-03-21 17:30:34.000000000 -0400
@@ -14,7 +14,6 @@
 #include <sys/wait.h>
 #include <sys/time.h>
 #include "user.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "net_user.h"
 #include "os.h"
Index: linux-2.6.21-mm/arch/um/drivers/port_user.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/port_user.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/port_user.c	2007-03-21 17:30:34.000000000 -0400
@@ -13,7 +13,6 @@
 #include <sys/socket.h>
 #include <sys/un.h>
 #include <netinet/in.h>
-#include "user_util.h"
 #include "kern_util.h"
 #include "user.h"
 #include "chan_user.h"
Index: linux-2.6.21-mm/arch/um/drivers/pty.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/pty.c	2007-03-21 17:29:56.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/pty.c	2007-03-21 17:30:34.000000000 -0400
@@ -11,7 +11,6 @@
 #include <termios.h>
 #include "chan_user.h"
 #include "user.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "os.h"
 #include "um_malloc.h"
Index: linux-2.6.21-mm/arch/um/drivers/slip_user.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/slip_user.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/slip_user.c	2007-03-21 17:30:34.000000000 -0400
@@ -8,7 +8,6 @@
 #include <sys/termios.h>
 #include <sys/wait.h>
 #include <sys/signal.h>
-#include "user_util.h"
 #include "kern_util.h"
 #include "user.h"
 #include "net_user.h"
Index: linux-2.6.21-mm/arch/um/drivers/slirp_user.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/slirp_user.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/slirp_user.c	2007-03-21 17:30:34.000000000 -0400
@@ -7,7 +7,6 @@
 #include <errno.h>
 #include <sys/wait.h>
 #include <sys/signal.h>
-#include "user_util.h"
 #include "kern_util.h"
 #include "user.h"
 #include "net_user.h"
Index: linux-2.6.21-mm/arch/um/drivers/ssl.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/ssl.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/ssl.c	2007-03-21 17:30:34.000000000 -0400
@@ -15,7 +15,6 @@
 #include "line.h"
 #include "ssl.h"
 #include "chan_kern.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "kern.h"
 #include "init.h"
Index: linux-2.6.21-mm/arch/um/drivers/stdio_console.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/stdio_console.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/stdio_console.c	2007-03-21 17:30:34.000000000 -0400
@@ -22,7 +22,6 @@
 #include "stdio_console.h"
 #include "line.h"
 #include "chan_kern.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "irq_user.h"
 #include "mconsole_kern.h"
Index: linux-2.6.21-mm/arch/um/drivers/tty.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/tty.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/tty.c	2007-03-21 17:30:34.000000000 -0400
@@ -8,7 +8,6 @@
 #include <errno.h>
 #include <unistd.h>
 #include "chan_user.h"
-#include "user_util.h"
 #include "user.h"
 #include "os.h"
 #include "um_malloc.h"
Index: linux-2.6.21-mm/arch/um/drivers/ubd_kern.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/ubd_kern.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/ubd_kern.c	2007-03-21 17:30:34.000000000 -0400
@@ -39,7 +39,6 @@
 #include "asm/irq.h"
 #include "asm/types.h"
 #include "asm/tlbflush.h"
-#include "user_util.h"
 #include "mem_user.h"
 #include "kern_util.h"
 #include "kern.h"
Index: linux-2.6.21-mm/arch/um/drivers/ubd_user.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/ubd_user.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/ubd_user.c	2007-03-21 17:30:34.000000000 -0400
@@ -16,7 +16,6 @@
 #include <sys/mman.h>
 #include <sys/param.h>
 #include "asm/types.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "user.h"
 #include "ubd_user.h"
Index: linux-2.6.21-mm/arch/um/drivers/xterm.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/xterm.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/xterm.c	2007-03-21 17:30:34.000000000 -0400
@@ -14,7 +14,6 @@
 #include <sys/socket.h>
 #include "kern_util.h"
 #include "chan_user.h"
-#include "user_util.h"
 #include "user.h"
 #include "os.h"
 #include "xterm.h"
Index: linux-2.6.21-mm/arch/um/include/user_util.h
===================================================================
--- linux-2.6.21-mm.orig/arch/um/include/user_util.h	2007-03-21 17:30:25.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,29 +0,0 @@
-/*
- * Copyright (C) 2000, 2001, 2002 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#ifndef __USER_UTIL_H__
-#define __USER_UTIL_H__
-
-#include "sysdep/ptrace.h"
-
-extern int mode_tt;
-
-extern int grantpt(int __fd);
-extern int unlockpt(int __fd);
-
-extern void *add_signal_handler(int sig, void (*handler)(int));
-extern void input_cb(void (*proc)(void *), void *arg, int arg_len);
-extern int switcheroo(int fd, int prot, void *from, void *to, int size);
-extern void do_exec(int old_pid, int new_pid);
-extern void tracer_panic(char *msg, ...)
-	__attribute__ ((format (printf, 1, 2)));
-extern int detach(int pid, int sig);
-extern int attach(int pid);
-extern void kill_child_dead(int pid);
-extern int cont(int pid);
-extern void check_sigio(void);
-extern int raw(int fd);
-
-#endif
Index: linux-2.6.21-mm/arch/um/kernel/exec.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/exec.c	2007-03-21 17:29:21.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/exec.c	2007-03-21 17:30:34.000000000 -0400
@@ -10,7 +10,6 @@
 #include "asm/pgtable.h"
 #include "asm/tlbflush.h"
 #include "asm/uaccess.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "as-layout.h"
 #include "mem_user.h"
Index: linux-2.6.21-mm/arch/um/kernel/init_task.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/init_task.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/init_task.c	2007-03-21 17:30:34.000000000 -0400
@@ -10,7 +10,6 @@
 #include "linux/mqueue.h"
 #include "asm/uaccess.h"
 #include "asm/pgtable.h"
-#include "user_util.h"
 #include "mem_user.h"
 #include "os.h"
 
Index: linux-2.6.21-mm/arch/um/kernel/initrd.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/initrd.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/initrd.c	2007-03-21 17:30:34.000000000 -0400
@@ -7,7 +7,6 @@
 #include "linux/bootmem.h"
 #include "linux/initrd.h"
 #include "asm/types.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "initrd.h"
 #include "init.h"
Index: linux-2.6.21-mm/arch/um/kernel/irq.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/irq.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/irq.c	2007-03-21 17:30:34.000000000 -0400
@@ -25,7 +25,6 @@
 #include "asm/system.h"
 #include "asm/errno.h"
 #include "asm/uaccess.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "irq_user.h"
 #include "irq_kern.h"
Index: linux-2.6.21-mm/arch/um/kernel/mem.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/mem.c	2007-03-21 17:29:21.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/mem.c	2007-03-21 17:30:34.000000000 -0400
@@ -13,7 +13,6 @@
 #include "asm/page.h"
 #include "asm/fixmap.h"
 #include "asm/pgalloc.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "as-layout.h"
 #include "kern.h"
Index: linux-2.6.21-mm/arch/um/kernel/physmem.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/physmem.c	2007-03-21 17:29:21.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/physmem.c	2007-03-21 17:31:06.000000000 -0400
@@ -14,7 +14,6 @@
 #include "asm/pgtable.h"
 #include "kern_util.h"
 #include "as-layout.h"
-#include "user_util.h"
 #include "mode_kern.h"
 #include "mem.h"
 #include "mem_user.h"
Index: linux-2.6.21-mm/arch/um/kernel/process.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/process.c	2007-03-21 17:29:21.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/process.c	2007-03-21 17:30:34.000000000 -0400
@@ -32,7 +32,6 @@
 #include "asm/tlbflush.h"
 #include "asm/uaccess.h"
 #include "asm/user.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "as-layout.h"
 #include "kern.h"
Index: linux-2.6.21-mm/arch/um/kernel/reboot.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/reboot.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/reboot.c	2007-03-21 17:30:34.000000000 -0400
@@ -6,7 +6,6 @@
 #include "linux/module.h"
 #include "linux/sched.h"
 #include "asm/smp.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "kern.h"
 #include "os.h"
Index: linux-2.6.21-mm/arch/um/kernel/signal.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/signal.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/signal.c	2007-03-21 17:30:34.000000000 -0400
@@ -18,7 +18,6 @@
 #include "asm/signal.h"
 #include "asm/uaccess.h"
 #include "asm/unistd.h"
-#include "user_util.h"
 #include "asm/ucontext.h"
 #include "kern_util.h"
 #include "signal_kern.h"
Index: linux-2.6.21-mm/arch/um/kernel/skas/process.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/skas/process.c	2007-03-21 17:29:21.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/skas/process.c	2007-03-21 17:30:34.000000000 -0400
@@ -16,7 +16,6 @@
 #include "as-layout.h"
 #include "skas.h"
 #include "os.h"
-#include "user_util.h"
 #include "tlb.h"
 #include "kern.h"
 #include "mode.h"
Index: linux-2.6.21-mm/arch/um/kernel/skas/tlb.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/skas/tlb.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/skas/tlb.c	2007-03-21 17:30:34.000000000 -0400
@@ -10,7 +10,6 @@
 #include "asm/page.h"
 #include "asm/pgtable.h"
 #include "asm/mmu.h"
-#include "user_util.h"
 #include "mem_user.h"
 #include "mem.h"
 #include "skas.h"
Index: linux-2.6.21-mm/arch/um/kernel/smp.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/smp.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/smp.c	2007-03-21 17:30:34.000000000 -0400
@@ -21,7 +21,6 @@ DEFINE_PER_CPU(struct mmu_gather, mmu_ga
 #include "asm/smp.h"
 #include "asm/processor.h"
 #include "asm/spinlock.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "kern.h"
 #include "irq_user.h"
Index: linux-2.6.21-mm/arch/um/kernel/syscall.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/syscall.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/syscall.c	2007-03-21 17:30:34.000000000 -0400
@@ -18,7 +18,6 @@
 #include "asm/mman.h"
 #include "asm/uaccess.h"
 #include "kern_util.h"
-#include "user_util.h"
 #include "sysdep/syscalls.h"
 #include "mode_kern.h"
 #include "choose-mode.h"
Index: linux-2.6.21-mm/arch/um/kernel/sysrq.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/sysrq.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/sysrq.c	2007-03-21 17:30:34.000000000 -0400
@@ -10,7 +10,6 @@
 #include "asm/page.h"
 #include "asm/processor.h"
 #include "sysrq.h"
-#include "user_util.h"
 
 /* Catch non-i386 SUBARCH's. */
 #if !defined(CONFIG_UML_X86) || defined(CONFIG_64BIT)
Index: linux-2.6.21-mm/arch/um/kernel/time.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/time.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/time.c	2007-03-21 17:30:34.000000000 -0400
@@ -18,7 +18,6 @@
 #include "asm/param.h"
 #include "asm/current.h"
 #include "kern_util.h"
-#include "user_util.h"
 #include "mode.h"
 #include "os.h"
 
Index: linux-2.6.21-mm/arch/um/kernel/tlb.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/tlb.c	2007-03-21 17:29:21.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/tlb.c	2007-03-21 17:31:18.000000000 -0400
@@ -10,7 +10,6 @@
 #include "choose-mode.h"
 #include "mode_kern.h"
 #include "as-layout.h"
-#include "user_util.h"
 #include "tlb.h"
 #include "mem.h"
 #include "mem_user.h"
Index: linux-2.6.21-mm/arch/um/kernel/trap.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/trap.c	2007-03-21 17:29:21.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/trap.c	2007-03-21 17:30:34.000000000 -0400
@@ -18,7 +18,6 @@
 #include "asm/current.h"
 #include "asm/irq.h"
 #include "sysdep/sigcontext.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "as-layout.h"
 #include "arch.h"
Index: linux-2.6.21-mm/arch/um/kernel/tt/exec_kern.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/tt/exec_kern.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/tt/exec_kern.c	2007-03-21 17:30:34.000000000 -0400
@@ -10,7 +10,6 @@
 #include "asm/uaccess.h"
 #include "asm/pgalloc.h"
 #include "asm/tlbflush.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "irq_user.h"
 #include "mem_user.h"
Index: linux-2.6.21-mm/arch/um/kernel/tt/exec_user.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/tt/exec_user.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/tt/exec_user.c	2007-03-21 17:30:34.000000000 -0400
@@ -10,7 +10,6 @@
 #include <errno.h>
 #include <sys/wait.h>
 #include <signal.h>
-#include "user_util.h"
 #include "kern_util.h"
 #include "user.h"
 #include "ptrace_user.h"
Index: linux-2.6.21-mm/arch/um/kernel/tt/gdb.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/tt/gdb.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/tt/gdb.c	2007-03-21 17:30:34.000000000 -0400
@@ -17,7 +17,6 @@
 #include "user.h"
 #include "debug.h"
 #include "kern_util.h"
-#include "user_util.h"
 #include "tt.h"
 #include "sysdep/thread.h"
 #include "os.h"
Index: linux-2.6.21-mm/arch/um/kernel/tt/mem.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/tt/mem.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/tt/mem.c	2007-03-21 17:30:34.000000000 -0400
@@ -8,7 +8,6 @@
 #include "asm/uaccess.h"
 #include "mem_user.h"
 #include "kern_util.h"
-#include "user_util.h"
 #include "kern.h"
 #include "tt.h"
 
Index: linux-2.6.21-mm/arch/um/kernel/tt/mem_user.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/tt/mem_user.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/tt/mem_user.c	2007-03-21 17:30:34.000000000 -0400
@@ -11,7 +11,6 @@
 #include <sys/mman.h>
 #include "tt.h"
 #include "mem_user.h"
-#include "user_util.h"
 #include "os.h"
 
 void remap_data(void *segment_start, void *segment_end, int w)
Index: linux-2.6.21-mm/arch/um/kernel/tt/process_kern.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/tt/process_kern.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/tt/process_kern.c	2007-03-21 17:30:34.000000000 -0400
@@ -14,7 +14,6 @@
 #include "asm/tlbflush.h"
 #include "irq_user.h"
 #include "kern_util.h"
-#include "user_util.h"
 #include "os.h"
 #include "kern.h"
 #include "sigcontext.h"
Index: linux-2.6.21-mm/arch/um/kernel/tt/ptproxy/proxy.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/tt/ptproxy/proxy.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/tt/ptproxy/proxy.c	2007-03-21 17:30:34.000000000 -0400
@@ -26,7 +26,6 @@ Jeff Dike (jdike@karaya.com) : Modified 
 #include "sysdep.h"
 #include "wait.h"
 
-#include "user_util.h"
 #include "user.h"
 #include "os.h"
 #include "tempfile.h"
Index: linux-2.6.21-mm/arch/um/kernel/tt/ptproxy/ptrace.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/tt/ptproxy/ptrace.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/tt/ptproxy/ptrace.c	2007-03-21 17:30:34.000000000 -0400
@@ -16,7 +16,6 @@ Jeff Dike (jdike@karaya.com) : Modified 
 
 #include "ptproxy.h"
 #include "debug.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "ptrace_user.h"
 #include "tt.h"
Index: linux-2.6.21-mm/arch/um/kernel/tt/ptproxy/sysdep.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/tt/ptproxy/sysdep.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/tt/ptproxy/sysdep.c	2007-03-21 17:30:34.000000000 -0400
@@ -13,7 +13,6 @@ terms and conditions.
 #include <sys/types.h>
 #include <linux/unistd.h>
 #include "ptrace_user.h"
-#include "user_util.h"
 #include "user.h"
 #include "os.h"
 
Index: linux-2.6.21-mm/arch/um/kernel/tt/ptproxy/wait.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/tt/ptproxy/wait.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/tt/ptproxy/wait.c	2007-03-21 17:30:34.000000000 -0400
@@ -13,7 +13,6 @@ terms and conditions.
 #include "ptproxy.h"
 #include "sysdep.h"
 #include "wait.h"
-#include "user_util.h"
 #include "ptrace_user.h"
 #include "sysdep/ptrace.h"
 #include "sysdep/sigcontext.h"
Index: linux-2.6.21-mm/arch/um/kernel/tt/syscall_user.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/tt/syscall_user.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/tt/syscall_user.c	2007-03-21 17:30:34.000000000 -0400
@@ -11,7 +11,6 @@
 #include "sigcontext.h"
 #include "ptrace_user.h"
 #include "task.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "syscall.h"
 #include "tt.h"
Index: linux-2.6.21-mm/arch/um/kernel/tt/tlb.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/tt/tlb.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/tt/tlb.c	2007-03-21 17:30:34.000000000 -0400
@@ -12,7 +12,6 @@
 #include "asm/pgtable.h"
 #include "asm/uaccess.h"
 #include "asm/tlbflush.h"
-#include "user_util.h"
 #include "mem_user.h"
 #include "os.h"
 #include "tlb.h"
Index: linux-2.6.21-mm/arch/um/kernel/tt/tracer.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/tt/tracer.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/tt/tracer.c	2007-03-21 17:30:34.000000000 -0400
@@ -19,7 +19,6 @@
 #include "sigcontext.h"
 #include "sysdep/sigcontext.h"
 #include "os.h"
-#include "user_util.h"
 #include "mem_user.h"
 #include "process.h"
 #include "kern_util.h"
Index: linux-2.6.21-mm/arch/um/kernel/tt/trap_user.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/tt/trap_user.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/tt/trap_user.c	2007-03-21 17:30:34.000000000 -0400
@@ -8,7 +8,6 @@
 #include <signal.h>
 #include "sysdep/ptrace.h"
 #include "sysdep/sigcontext.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "task.h"
 #include "tt.h"
Index: linux-2.6.21-mm/arch/um/kernel/tt/uaccess_user.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/tt/uaccess_user.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/tt/uaccess_user.c	2007-03-21 17:30:34.000000000 -0400
@@ -5,7 +5,6 @@
  */
 
 #include <string.h>
-#include "user_util.h"
 #include "uml_uaccess.h"
 #include "task.h"
 #include "kern_util.h"
Index: linux-2.6.21-mm/arch/um/kernel/um_arch.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/um_arch.c	2007-03-21 17:29:21.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/um_arch.c	2007-03-21 17:30:34.000000000 -0400
@@ -26,7 +26,6 @@
 #include "asm/setup.h"
 #include "ubd_user.h"
 #include "asm/current.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "as-layout.h"
 #include "arch.h"
Index: linux-2.6.21-mm/arch/um/os-Linux/drivers/ethertap_user.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/drivers/ethertap_user.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/drivers/ethertap_user.c	2007-03-21 17:30:34.000000000 -0400
@@ -16,7 +16,6 @@
 #include <net/if.h>
 #include "user.h"
 #include "kern_util.h"
-#include "user_util.h"
 #include "net_user.h"
 #include "etap.h"
 #include "os.h"
Index: linux-2.6.21-mm/arch/um/os-Linux/drivers/tuntap_user.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/drivers/tuntap_user.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/drivers/tuntap_user.c	2007-03-21 17:30:34.000000000 -0400
@@ -18,7 +18,6 @@
 #include "net_user.h"
 #include "tuntap.h"
 #include "kern_util.h"
-#include "user_util.h"
 #include "user.h"
 #include "os.h"
 
Index: linux-2.6.21-mm/arch/um/os-Linux/file.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/file.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/file.c	2007-03-21 17:30:34.000000000 -0400
@@ -18,7 +18,6 @@
 #include "os.h"
 #include "user.h"
 #include "kern_util.h"
-#include "user_util.h"
 
 static void copy_stat(struct uml_stat *dst, struct stat64 *src)
 {
Index: linux-2.6.21-mm/arch/um/os-Linux/helper.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/helper.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/helper.c	2007-03-21 17:30:34.000000000 -0400
@@ -13,7 +13,6 @@
 #include <sys/wait.h>
 #include "user.h"
 #include "kern_util.h"
-#include "user_util.h"
 #include "os.h"
 #include "um_malloc.h"
 
Index: linux-2.6.21-mm/arch/um/os-Linux/irq.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/irq.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/irq.c	2007-03-21 17:30:34.000000000 -0400
@@ -11,7 +11,6 @@
 #include <sys/poll.h>
 #include <sys/types.h>
 #include <sys/time.h>
-#include "user_util.h"
 #include "kern_util.h"
 #include "user.h"
 #include "process.h"
Index: linux-2.6.21-mm/arch/um/os-Linux/main.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/main.c	2007-03-21 17:29:21.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/main.c	2007-03-21 17:30:34.000000000 -0400
@@ -13,7 +13,6 @@
 #include <sys/mman.h>
 #include <sys/user.h>
 #include <asm/page.h>
-#include "user_util.h"
 #include "kern_util.h"
 #include "as-layout.h"
 #include "mem_user.h"
Index: linux-2.6.21-mm/arch/um/os-Linux/mem.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/mem.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/mem.c	2007-03-21 17:30:34.000000000 -0400
@@ -11,7 +11,6 @@
 #include <sys/statfs.h>
 #include "kern_util.h"
 #include "user.h"
-#include "user_util.h"
 #include "mem_user.h"
 #include "init.h"
 #include "os.h"
Index: linux-2.6.21-mm/arch/um/os-Linux/process.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/process.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/process.c	2007-03-21 17:30:34.000000000 -0400
@@ -14,7 +14,6 @@
 #include "ptrace_user.h"
 #include "os.h"
 #include "user.h"
-#include "user_util.h"
 #include "process.h"
 #include "irq_user.h"
 #include "kern_util.h"
Index: linux-2.6.21-mm/arch/um/os-Linux/sigio.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/sigio.c	2007-03-21 16:16:50.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/sigio.c	2007-03-21 17:30:34.000000000 -0400
@@ -17,7 +17,6 @@
 #include "init.h"
 #include "user.h"
 #include "kern_util.h"
-#include "user_util.h"
 #include "sigio.h"
 #include "os.h"
 #include "um_malloc.h"
Index: linux-2.6.21-mm/arch/um/os-Linux/signal.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/signal.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/signal.c	2007-03-21 17:30:34.000000000 -0400
@@ -11,7 +11,6 @@
 #include <stdarg.h>
 #include <string.h>
 #include <sys/mman.h>
-#include "user_util.h"
 #include "user.h"
 #include "signal_kern.h"
 #include "sysdep/sigcontext.h"
Index: linux-2.6.21-mm/arch/um/os-Linux/skas/mem.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/skas/mem.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/skas/mem.c	2007-03-21 17:30:34.000000000 -0400
@@ -17,7 +17,6 @@
 #include "os.h"
 #include "proc_mm.h"
 #include "ptrace_user.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "task.h"
 #include "registers.h"
Index: linux-2.6.21-mm/arch/um/os-Linux/skas/process.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/skas/process.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/skas/process.c	2007-03-21 17:30:34.000000000 -0400
@@ -18,7 +18,6 @@
 #include <asm/types.h>
 #include "user.h"
 #include "sysdep/ptrace.h"
-#include "user_util.h"
 #include "kern_util.h"
 #include "skas.h"
 #include "stub-data.h"
Index: linux-2.6.21-mm/arch/um/os-Linux/skas/trap.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/skas/trap.c	2007-03-21 17:29:21.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/skas/trap.c	2007-03-21 17:30:34.000000000 -0400
@@ -5,7 +5,6 @@
 
 #include <signal.h>
 #include <errno.h>
-#include "user_util.h"
 #include "kern_util.h"
 #include "as-layout.h"
 #include "task.h"
Index: linux-2.6.21-mm/arch/um/os-Linux/start_up.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/start_up.c	2007-03-21 15:24:33.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/start_up.c	2007-03-21 17:30:34.000000000 -0400
@@ -21,7 +21,6 @@
 #include <asm/unistd.h>
 #include <asm/page.h>
 #include <sys/types.h>
-#include "user_util.h"
 #include "kern_util.h"
 #include "user.h"
 #include "signal_kern.h"
Index: linux-2.6.21-mm/arch/um/os-Linux/sys-i386/tls.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/sys-i386/tls.c	2007-03-21 17:29:56.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/sys-i386/tls.c	2007-03-21 17:30:34.000000000 -0400
@@ -6,7 +6,6 @@
 
 #include "sysdep/tls.h"
 #include "user.h"
-#include "user_util.h"
 
 /* Checks whether host supports TLS, and sets *tls_min according to the value
  * valid on the host.
Index: linux-2.6.21-mm/arch/um/os-Linux/time.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/time.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/time.c	2007-03-21 17:30:34.000000000 -0400
@@ -10,7 +10,6 @@
 #include <sys/time.h>
 #include <signal.h>
 #include <errno.h>
-#include "user_util.h"
 #include "kern_util.h"
 #include "user.h"
 #include "process.h"
Index: linux-2.6.21-mm/arch/um/os-Linux/trap.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/trap.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/trap.c	2007-03-21 17:30:34.000000000 -0400
@@ -6,7 +6,6 @@
 #include <stdlib.h>
 #include <signal.h>
 #include "kern_util.h"
-#include "user_util.h"
 #include "os.h"
 #include "mode.h"
 #include "longjmp.h"
Index: linux-2.6.21-mm/arch/um/os-Linux/tt.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/tt.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/tt.c	2007-03-21 17:30:34.000000000 -0400
@@ -18,7 +18,6 @@
 #include <asm/ptrace.h>
 #include <asm/unistd.h>
 #include <asm/page.h>
-#include "user_util.h"
 #include "kern_util.h"
 #include "user.h"
 #include "signal_kern.h"
Index: linux-2.6.21-mm/arch/um/os-Linux/util.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/util.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/util.c	2007-03-21 17:30:34.000000000 -0400
@@ -21,7 +21,6 @@
 #include <sched.h>
 #include <termios.h>
 #include <string.h>
-#include "user_util.h"
 #include "kern_util.h"
 #include "user.h"
 #include "mem_user.h"
Index: linux-2.6.21-mm/arch/um/sys-i386/bugs.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/sys-i386/bugs.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/sys-i386/bugs.c	2007-03-21 17:30:34.000000000 -0400
@@ -13,7 +13,6 @@
 #include "sysdep/ptrace.h"
 #include "task.h"
 #include "os.h"
-#include "user_util.h"
 
 #define MAXTOKEN 64
 
Index: linux-2.6.21-mm/arch/um/sys-i386/ptrace_user.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/sys-i386/ptrace_user.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/sys-i386/ptrace_user.c	2007-03-21 17:30:34.000000000 -0400
@@ -15,7 +15,6 @@
 #include "user.h"
 #include "os.h"
 #include "uml-config.h"
-#include "user_util.h"
 
 int ptrace_getregs(long pid, unsigned long *regs_out)
 {
Index: linux-2.6.21-mm/arch/um/sys-ppc/sigcontext.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/sys-ppc/sigcontext.c	2007-03-21 15:22:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/sys-ppc/sigcontext.c	2007-03-21 17:30:34.000000000 -0400
@@ -1,7 +1,6 @@
 #include "asm/ptrace.h"
 #include "asm/sigcontext.h"
 #include "sysdep/ptrace.h"
-#include "user_util.h"
 
 /*
  * Overrides for Emacs so that we follow Linus's tabbing style.
Index: linux-2.6.21-mm/arch/um/kernel/ksyms.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/ksyms.c	2007-03-21 17:29:21.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/ksyms.c	2007-03-21 17:31:37.000000000 -0400
@@ -17,7 +17,6 @@
 #include "asm/tlbflush.h"
 #include "kern_util.h"
 #include "as-layout.h"
-#include "user_util.h"
 #include "mem_user.h"
 #include "os.h"
 
