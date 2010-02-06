Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933100Ab0BFRrz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 12:47:55 -0500
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:53662 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932905Ab0BFRrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 12:47:33 -0500
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Cc: Frans Pop <elendil@planet.nl>, user-mode-linux-devel@lists.sourceforge.net,
       Jeff Dike <jdike@addtoit.com>
Subject: [PATCH 14/16] um: remove trailing space in messages
Date: Sat,  6 Feb 2010 18:47:21 +0100
Message-Id: <1265478443-31072-14-git-send-email-elendil@planet.nl>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <201002061844.45212.elendil@planet.nl>
References: <201002061844.45212.elendil@planet.nl>
X-OriginalArrivalTime: 06 Feb 2010 17:47:26.0768 (UTC) FILETIME=[72263B00:01CAA754]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: user-mode-linux-devel@lists.sourceforge.net
Cc: Jeff Dike <jdike@addtoit.com>
---

Note that the URL in the patch for arch/um/os-Linux/start_up.c is dead.
---
 arch/um/drivers/mconsole_kern.c |   26 +++++++++++++-------------
 arch/um/drivers/ubd_kern.c      |    4 ++--
 arch/um/kernel/sysrq.c          |    2 +-
 arch/um/kernel/um_arch.c        |    4 ++--
 arch/um/os-Linux/aio.c          |    6 +++---
 arch/um/os-Linux/skas/mem.c     |    2 +-
 arch/um/os-Linux/start_up.c     |    2 +-
 7 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/arch/um/drivers/mconsole_kern.c b/arch/um/drivers/mconsole_kern.c
index 3b3c366..fe0c22e 100644
--- a/arch/um/drivers/mconsole_kern.c
+++ b/arch/um/drivers/mconsole_kern.c
@@ -246,19 +246,19 @@ void mconsole_proc(struct mc_request *req)
 }
 
 #define UML_MCONSOLE_HELPTEXT \
-"Commands: \n\
-    version - Get kernel version \n\
-    help - Print this message \n\
-    halt - Halt UML \n\
-    reboot - Reboot UML \n\
-    config <dev>=<config> - Add a new device to UML;  \n\
-	same syntax as command line \n\
-    config <dev> - Query the configuration of a device \n\
-    remove <dev> - Remove a device from UML \n\
-    sysrq <letter> - Performs the SysRq action controlled by the letter \n\
-    cad - invoke the Ctrl-Alt-Del handler \n\
-    stop - pause the UML; it will do nothing until it receives a 'go' \n\
-    go - continue the UML after a 'stop' \n\
+"Commands:\n\
+    version - Get kernel version\n\
+    help - Print this message\n\
+    halt - Halt UML\n\
+    reboot - Reboot UML\n\
+    config <dev>=<config> - Add a new device to UML;\n\
+	same syntax as command line\n\
+    config <dev> - Query the configuration of a device\n\
+    remove <dev> - Remove a device from UML\n\
+    sysrq <letter> - Performs the SysRq action controlled by the letter\n\
+    cad - invoke the Ctrl-Alt-Del handler\n\
+    stop - pause the UML; it will do nothing until it receives a 'go'\n\
+    go - continue the UML after a 'stop'\n\
     log <string> - make UML enter <string> into the kernel log\n\
     proc <file> - returns the contents of the UML's /proc/<file>\n\
     stack <pid> - returns the stack of the specified pid\n\
diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 5ff5546..5d6c8c2 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -418,10 +418,10 @@ __uml_help(ubd_setup,
 "    a COW file or a backing file. To override this detection, add the 'd'\n"
 "    flag:\n"
 "	ubd0d=BackingFile\n"
-"    Usually, there is a filesystem in the file, but \n"
+"    Usually, there is a filesystem in the file, but\n"
 "    that's not required. Swap devices containing swap files can be\n"
 "    specified like this. Also, a file which doesn't contain a\n"
-"    filesystem can have its contents read in the virtual \n"
+"    filesystem can have its contents read in the virtual\n"
 "    machine by running 'dd' on the device. <n> must be in the range\n"
 "    0 to 7. Appending an 'r' to the number will cause that device\n"
 "    to be mounted read-only. For example ubd1r=./ext_fs. Appending\n"
diff --git a/arch/um/kernel/sysrq.c b/arch/um/kernel/sysrq.c
index 0960de5..97131a0 100644
--- a/arch/um/kernel/sysrq.c
+++ b/arch/um/kernel/sysrq.c
@@ -20,7 +20,7 @@ void show_trace(struct task_struct *task, unsigned long * stack)
 		WARN_ON(1);
 	}
 
-	printk(KERN_INFO "Call Trace: \n");
+	printk(KERN_INFO "Call Trace:\n");
 	while (((long) stack & (THREAD_SIZE-1)) != 0) {
 		addr = *stack;
 		if (__kernel_text_address(addr)) {
diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
index 8d84250..066f8db 100644
--- a/arch/um/kernel/um_arch.c
+++ b/arch/um/kernel/um_arch.c
@@ -142,14 +142,14 @@ __uml_setup("root=", uml_root_setup,
 "root=<file containing the root fs>\n"
 "    This is actually used by the generic kernel in exactly the same\n"
 "    way as in any other kernel. If you configure a number of block\n"
-"    devices and want to boot off something other than ubd0, you \n"
+"    devices and want to boot off something other than ubd0, you\n"
 "    would use something like:\n"
 "        root=/dev/ubd5\n\n"
 );
 
 static int __init no_skas_debug_setup(char *line, int *add)
 {
-	printf("'debug' is not necessary to gdb UML in skas mode - run \n");
+	printf("'debug' is not necessary to gdb UML in skas mode - run\n");
 	printf("'gdb linux'\n");
 
 	return 0;
diff --git a/arch/um/os-Linux/aio.c b/arch/um/os-Linux/aio.c
index 57e3d46..c660037 100644
--- a/arch/um/os-Linux/aio.c
+++ b/arch/um/os-Linux/aio.c
@@ -314,12 +314,12 @@ __uml_setup("aio=2.4", set_aio_24,
 "aio=2.4\n"
 "    This is used to force UML to use 2.4-style AIO even when 2.6 AIO is\n"
 "    available.  2.4 AIO is a single thread that handles one request at a\n"
-"    time, synchronously.  2.6 AIO is a thread which uses the 2.6 AIO \n"
-"    interface to handle an arbitrary number of pending requests.  2.6 AIO \n"
+"    time, synchronously.  2.6 AIO is a thread which uses the 2.6 AIO\n"
+"    interface to handle an arbitrary number of pending requests.  2.6 AIO\n"
 "    is not available in tt mode, on 2.4 hosts, or when UML is built with\n"
 "    /usr/include/linux/aio_abi.h not available.  Many distributions don't\n"
 "    include aio_abi.h, so you will need to copy it from a kernel tree to\n"
-"    your /usr/include/linux in order to build an AIO-capable UML\n\n"
+"    your /usr/include/linux in order to build an AIO-capable UML.\n\n"
 );
 
 static int init_aio(void)
diff --git a/arch/um/os-Linux/skas/mem.c b/arch/um/os-Linux/skas/mem.c
index d261f17..182d823 100644
--- a/arch/um/os-Linux/skas/mem.c
+++ b/arch/um/os-Linux/skas/mem.c
@@ -70,7 +70,7 @@ static inline long do_syscall_stub(struct mm_id * mm_idp, void **addr)
 
 	n = ptrace_setregs(pid, syscall_regs);
 	if (n < 0) {
-		printk(UM_KERN_ERR "Registers - \n");
+		printk(UM_KERN_ERR "Registers -\n");
 		for (i = 0; i < MAX_REG_NR; i++)
 			printk(UM_KERN_ERR "\t%d\t0x%lx\n", i, syscall_regs[i]);
 		panic("do_syscall_stub : PTRACE_SETREGS failed, errno = %d\n",
diff --git a/arch/um/os-Linux/start_up.c b/arch/um/os-Linux/start_up.c
index 02ee9ad..a092059 100644
--- a/arch/um/os-Linux/start_up.c
+++ b/arch/um/os-Linux/start_up.c
@@ -195,7 +195,7 @@ __uml_setup("nosysemu", nosysemu_cmd_param,
 "    SYSEMU is a performance-patch introduced by Laurent Vivier. It changes\n"
 "    behaviour of ptrace() and helps reducing host context switch rate.\n"
 "    To make it working, you need a kernel patch for your host, too.\n"
-"    See http://perso.wanadoo.fr/laurent.vivier/UML/ for further \n"
+"    See http://perso.wanadoo.fr/laurent.vivier/UML/ for further\n"
 "    information.\n\n");
 
 static void __init check_sysemu(void)
-- 
1.6.6.1

