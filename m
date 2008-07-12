Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547AbYGLQbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbYGLQbl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 12:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753747AbYGLQbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 12:31:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:44754 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbYGLQbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 12:31:32 -0400
Subject: [PATCH] init: fix sparse warnings
From: Jaswinder Singh <jaswinder@infradead.org>
To: LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=utf8
Date: Sat, 12 Jul 2008 22:00:54 +0530
Message-Id: <1215880254.19076.38.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿﻿I am trying to solve following sparse warnings. Please give me feedback
for the Patch. You can also find updated sparse patches from
http://git.infradead.org/users/jaswinder/sparse-2.6.git

  CHECK   init/main.c
init/main.c:193:6: warning: symbol 'envp_init' was not declared. Should it be static?
init/main.c:805:16: warning: cast adds address space to expression (<asn:1>)

CHECK   init/do_mounts.c
init/do_mounts.c:22:16: warning: symbol 'rd_doload' was not declared. Should it be static?
init/do_mounts.c:216:22: warning: incorrect type in argument 1 (different address spaces)
init/do_mounts.c:216:22:    expected char [noderef] <asn:1>*dev_name
init/do_mounts.c:216:22:    got char *name
init/do_mounts.c:216:28: warning: incorrect type in argument 2 (different address spaces)
init/do_mounts.c:216:28:    expected char [noderef] <asn:1>*dir_name
init/do_mounts.c:216:28:    got char static *<noident>
init/do_mounts.c:216:37: warning: incorrect type in argument 3 (different address spaces)
init/do_mounts.c:216:37:    expected char [noderef] <asn:1>*type
init/do_mounts.c:216:37:    got char *fs
init/do_mounts.c:216:48: warning: incorrect type in argument 5 (different address spaces)
init/do_mounts.c:216:48:    expected void [noderef] <asn:1>*data
init/do_mounts.c:216:48:    got void *data
init/do_mounts.c:220:12: warning: incorrect type in argument 1 (different address spaces)
init/do_mounts.c:220:12:    expected char const [noderef] <asn:1>*filename
init/do_mounts.c:220:12:    got char static *<noident>
init/do_mounts.c:306:16: warning: incorrect type in argument 1 (different address spaces)
init/do_mounts.c:306:16:    expected char const [noderef] <asn:1>*filename
init/do_mounts.c:306:16:    got char static *<noident>
init/do_mounts.c:312:16: warning: incorrect type in argument 1 (different address spaces)
init/do_mounts.c:312:16:    expected char const [noderef] <asn:1>*filename
init/do_mounts.c:312:16:    got char static *<noident>
init/do_mounts.c:317:17: warning: incorrect type in argument 2 (different address spaces)
init/do_mounts.c:317:17:    expected char [noderef] <asn:1>*buf
init/do_mounts.c:317:17:    got char *<noident>
init/do_mounts.h:18:13: warning: incorrect type in argument 1 (different address spaces)
init/do_mounts.h:18:13:    expected char const [noderef] <asn:1>*pathname
init/do_mounts.h:18:13:    got char *name
init/do_mounts.h:19:19: warning: incorrect type in argument 1 (different address spaces)
init/do_mounts.h:19:19:    expected char const [noderef] <asn:1>*filename
init/do_mounts.h:19:19:    got char *name
init/do_mounts.c:403:12: warning: incorrect type in argument 1 (different address spaces)
init/do_mounts.c:403:12:    expected char [noderef] <asn:1>*dev_name
init/do_mounts.c:403:12:    got char static *<noident>
init/do_mounts.c:403:17: warning: incorrect type in argument 2 (different address spaces)
init/do_mounts.c:403:17:    expected char [noderef] <asn:1>*dir_name
init/do_mounts.c:403:17:    got char static *<noident>
init/do_mounts.c:404:13: warning: incorrect type in argument 1 (different address spaces)
init/do_mounts.c:404:13:    expected char const [noderef] <asn:1>*filename
init/do_mounts.c:404:13:    got char static *<noident>

CHECK   init/do_mounts_rd.c
init/do_mounts_rd.c:73:15: warning: incorrect type in argument 2 (different address spaces)
init/do_mounts_rd.c:73:15:    expected char [noderef] <asn:1>*buf
init/do_mounts_rd.c:73:15:    got unsigned char *[assigned] buf
init/do_mounts_rd.c:108:15: warning: incorrect type in argument 2 (different address spaces)
init/do_mounts_rd.c:108:15:    expected char [noderef] <asn:1>*buf
init/do_mounts_rd.c:108:15:    got unsigned char *[assigned] buf
init/do_mounts_rd.c:152:20: warning: incorrect type in argument 1 (different address spaces)
init/do_mounts_rd.c:152:20:    expected char const [noderef] <asn:1>*filename
init/do_mounts_rd.c:152:20:    got char static *<noident>
init/do_mounts_rd.c:156:19: warning: incorrect type in argument 1 (different address spaces)
init/do_mounts_rd.c:156:19:    expected char const [noderef] <asn:1>*filename
init/do_mounts_rd.c:156:19:    got char *from
init/do_mounts_rd.c:231:21: warning: incorrect type in argument 1 (different address spaces)
init/do_mounts_rd.c:231:21:    expected char const [noderef] <asn:1>*filename
init/do_mounts_rd.c:231:21:    got char *from
init/do_mounts_rd.c:238:19: warning: incorrect type in argument 2 (different address spaces)
init/do_mounts_rd.c:238:19:    expected char [noderef] <asn:1>*buf
init/do_mounts_rd.c:238:19:    got char *[assigned] buf
init/do_mounts_rd.c:239:21: warning: incorrect type in argument 2 (different address spaces)
init/do_mounts_rd.c:239:21:    expected char const [noderef] <asn:1>*buf
init/do_mounts_rd.c:239:21:    got char *[assigned] buf
init/do_mounts_rd.c:257:13: warning: incorrect type in argument 1 (different address spaces)
init/do_mounts_rd.c:257:13:    expected char const [noderef] <asn:1>*pathname
init/do_mounts_rd.c:257:13:    got char static *<noident>
init/do_mounts.h:18:13: warning: incorrect type in argument 1 (different address spaces)
init/do_mounts.h:18:13:    expected char const [noderef] <asn:1>*pathname
init/do_mounts.h:18:13:    got char *name
init/do_mounts.h:19:19: warning: incorrect type in argument 1 (different address spaces)
init/do_mounts.h:19:19:    expected char const [noderef] <asn:1>*filename
init/do_mounts.h:19:19:    got char *name
init/do_mounts.h:18:13: warning: incorrect type in argument 1 (different address spaces)
init/do_mounts.h:18:13:    expected char const [noderef] <asn:1>*pathname
init/do_mounts.h:18:13:    got char *name
init/do_mounts.h:19:19: warning: incorrect type in argument 1 (different address spaces)
init/do_mounts.h:19:19:    expected char const [noderef] <asn:1>*filename
init/do_mounts.h:19:19:    got char *name
init/do_mounts_rd.c:352:30: warning: incorrect type in argument 2 (different address spaces)
init/do_mounts_rd.c:352:30:    expected char [noderef] <asn:1>*buf
init/do_mounts_rd.c:352:30:    got unsigned char [usertype] *static [toplevel] inbuf
init/do_mounts_rd.c:373:36: warning: incorrect type in argument 2 (different address spaces)
init/do_mounts_rd.c:373:36:    expected char const [noderef] <asn:1>*buf
init/do_mounts_rd.c:373:36:    got unsigned char [usertype] *static [toplevel] window

CHECK   init/do_mounts_initrd.c
init/do_mounts_initrd.c:35:18: warning: incorrect type in argument 1 (different address spaces)
init/do_mounts_initrd.c:35:18:    expected char const [noderef] <asn:1>*filename
init/do_mounts_initrd.c:35:18:    got char static *<noident>
init/do_mounts.h:18:13: warning: incorrect type in argument 1 (different address spaces)
init/do_mounts.h:18:13:    expected char const [noderef] <asn:1>*pathname
init/do_mounts.h:18:13:    got char *name
init/do_mounts.h:19:19: warning: incorrect type in argument 1 (different address spaces)
init/do_mounts.h:19:19:    expected char const [noderef] <asn:1>*filename
init/do_mounts.h:19:19:    got char *name
init/do_mounts_initrd.c:50:12: warning: incorrect type in argument 1 (different address spaces)
init/do_mounts_initrd.c:50:12:    expected char const [noderef] <asn:1>*pathname
init/do_mounts_initrd.c:50:12:    got char static *<noident>
init/do_mounts_initrd.c:51:21: warning: incorrect type in argument 1 (different address spaces)
init/do_mounts_initrd.c:51:21:    expected char const [noderef] <asn:1>*filename
init/do_mounts_initrd.c:51:21:    got char static *<noident>
init/do_mounts_initrd.c:52:20: warning: incorrect type in argument 1 (different address spaces)
init/do_mounts_initrd.c:52:20:    expected char const [noderef] <asn:1>*filename
init/do_mounts_initrd.c:52:20:    got char static *<noident>
init/do_mounts_initrd.c:54:12: warning: incorrect type in argument 1 (different address spaces)
init/do_mounts_initrd.c:54:12:    expected char const [noderef] <asn:1>*filename
init/do_mounts_initrd.c:54:12:    got char static *<noident>
init/do_mounts_initrd.c:55:12: warning: incorrect type in argument 1 (different address spaces)
init/do_mounts_initrd.c:55:12:    expected char [noderef] <asn:1>*dev_name
init/do_mounts_initrd.c:55:12:    got char static *<noident>
init/do_mounts_initrd.c:55:17: warning: incorrect type in argument 2 (different address spaces)
init/do_mounts_initrd.c:55:17:    expected char [noderef] <asn:1>*dir_name
init/do_mounts_initrd.c:55:17:    got char static *<noident>
init/do_mounts_initrd.c:56:13: warning: incorrect type in argument 1 (different address spaces)
init/do_mounts_initrd.c:56:13:    expected char const [noderef] <asn:1>*filename
init/do_mounts_initrd.c:56:13:    got char static *<noident>
init/do_mounts_initrd.c:73:12: warning: incorrect type in argument 1 (different address spaces)
init/do_mounts_initrd.c:73:12:    expected char [noderef] <asn:1>*dev_name
init/do_mounts_initrd.c:73:12:    got char static *<noident>
init/do_mounts_initrd.c:73:17: warning: incorrect type in argument 2 (different address spaces)
init/do_mounts_initrd.c:73:17:    expected char [noderef] <asn:1>*dir_name
init/do_mounts_initrd.c:73:17:    got char static *<noident>
init/do_mounts_initrd.c:76:13: warning: incorrect type in argument 1 (different address spaces)
init/do_mounts_initrd.c:76:13:    expected char const [noderef] <asn:1>*filename
init/do_mounts_initrd.c:76:13:    got char static *<noident>
init/do_mounts_initrd.c:81:13: warning: incorrect type in argument 1 (different address spaces)
init/do_mounts_initrd.c:81:13:    expected char const [noderef] <asn:1>*filename
init/do_mounts_initrd.c:81:13:    got char static *<noident>
init/do_mounts_initrd.c:89:20: warning: incorrect type in argument 1 (different address spaces)
init/do_mounts_initrd.c:89:20:    expected char [noderef] <asn:1>*dev_name
init/do_mounts_initrd.c:89:20:    got char static *<noident>
init/do_mounts_initrd.c:89:28: warning: incorrect type in argument 2 (different address spaces)
init/do_mounts_initrd.c:89:28:    expected char [noderef] <asn:1>*dir_name
init/do_mounts_initrd.c:89:28:    got char static *<noident>
init/do_mounts_initrd.c:93:21: warning: incorrect type in argument 1 (different address spaces)
init/do_mounts_initrd.c:93:21:    expected char const [noderef] <asn:1>*filename
init/do_mounts_initrd.c:93:21:    got char static *<noident>
init/do_mounts_initrd.c:99:14: warning: incorrect type in argument 1 (different address spaces)
init/do_mounts_initrd.c:99:14:    expected char [noderef] <asn:1>*name
init/do_mounts_initrd.c:99:14:    got char static *<noident>
init/do_mounts.h:18:13: warning: incorrect type in argument 1 (different address spaces)
init/do_mounts.h:18:13:    expected char const [noderef] <asn:1>*pathname
init/do_mounts.h:18:13:    got char *name
init/do_mounts.h:19:19: warning: incorrect type in argument 1 (different address spaces)
init/do_mounts.h:19:19:    expected char const [noderef] <asn:1>*filename
init/do_mounts.h:19:19:    got char *name
init/do_mounts_initrd.c:122:15: warning: incorrect type in argument 1 (different address spaces)
init/do_mounts_initrd.c:122:15:    expected char const [noderef] <asn:1>*pathname
init/do_mounts_initrd.c:122:15:    got char static *<noident>
init/do_mounts_initrd.c:127:13: warning: incorrect type in argument 1 (different address spaces)
init/do_mounts_initrd.c:127:13:    expected char const [noderef] <asn:1>*pathname
init/do_mounts_initrd.c:127:13:    got char static *<noident>

CHECK   init/initramfs.c
init/initramfs.c:243:21: warning: incorrect type in argument 1 (different address spaces)
init/initramfs.c:243:21:    expected char const [noderef] <asn:1>*oldname
init/initramfs.c:243:21:    got char *old
init/initramfs.c:243:26: warning: incorrect type in argument 2 (different address spaces)
init/initramfs.c:243:26:    expected char const [noderef] <asn:1>*newname
init/initramfs.c:243:26:    got char *static [toplevel] [assigned] collected
init/initramfs.c:252:20: warning: incorrect type in argument 1 (different address spaces)
init/initramfs.c:252:20:    expected char [noderef] <asn:1>*filename
init/initramfs.c:252:20:    got char *path
init/initramfs.c:252:27: warning: incorrect type in argument 2 (different address spaces)
init/initramfs.c:252:27:    expected struct stat [noderef] <asn:1>*statbuf
init/initramfs.c:252:27:    got struct stat *<noident>
init/initramfs.c:254:14: warning: incorrect type in argument 1 (different address spaces)
init/initramfs.c:254:14:    expected char const [noderef] <asn:1>*pathname
init/initramfs.c:254:14:    got char *path
init/initramfs.c:256:15: warning: incorrect type in argument 1 (different address spaces)
init/initramfs.c:256:15:    expected char const [noderef] <asn:1>*pathname
init/initramfs.c:256:15:    got char *path
init/initramfs.c:279:19: warning: incorrect type in argument 1 (different address spaces)
init/initramfs.c:279:19:    expected char const [noderef] <asn:1>*filename
init/initramfs.c:279:19:    got char *static [toplevel] [assigned] collected
init/initramfs.c:288:13: warning: incorrect type in argument 1 (different address spaces)
init/initramfs.c:288:13:    expected char const [noderef] <asn:1>*pathname
init/initramfs.c:288:13:    got char *static [toplevel] [assigned] collected
init/initramfs.c:289:13: warning: incorrect type in argument 1 (different address spaces)
init/initramfs.c:289:13:    expected char const [noderef] <asn:1>*filename
init/initramfs.c:289:13:    got char *static [toplevel] [assigned] collected
init/initramfs.c:290:13: warning: incorrect type in argument 1 (different address spaces)
init/initramfs.c:290:13:    expected char const [noderef] <asn:1>*filename
init/initramfs.c:290:13:    got char *static [toplevel] [assigned] collected
init/initramfs.c:294:14: warning: incorrect type in argument 1 (different address spaces)
init/initramfs.c:294:14:    expected char const [noderef] <asn:1>*filename
init/initramfs.c:294:14:    got char *static [toplevel] [assigned] collected
init/initramfs.c:295:14: warning: incorrect type in argument 1 (different address spaces)
init/initramfs.c:295:14:    expected char const [noderef] <asn:1>*filename
init/initramfs.c:295:14:    got char *static [toplevel] [assigned] collected
init/initramfs.c:296:14: warning: incorrect type in argument 1 (different address spaces)
init/initramfs.c:296:14:    expected char const [noderef] <asn:1>*filename
init/initramfs.c:296:14:    got char *static [toplevel] [assigned] collected
init/initramfs.c:305:18: warning: incorrect type in argument 2 (different address spaces)
init/initramfs.c:305:18:    expected char const [noderef] <asn:1>*buf
init/initramfs.c:305:18:    got char *static [toplevel] [assigned] victim
init/initramfs.c:311:18: warning: incorrect type in argument 2 (different address spaces)
init/initramfs.c:311:18:    expected char const [noderef] <asn:1>*buf
init/initramfs.c:311:18:    got char *static [toplevel] [assigned] victim
init/initramfs.c:322:24: warning: incorrect type in argument 1 (different address spaces)
init/initramfs.c:322:24:    expected char const [noderef] <asn:1>*old
init/initramfs.c:322:24:    got char *
init/initramfs.c:322:45: warning: incorrect type in argument 2 (different address spaces)
init/initramfs.c:322:45:    expected char const [noderef] <asn:1>*new
init/initramfs.c:322:45:    got char *static [toplevel] [assigned] collected
init/initramfs.c:323:13: warning: incorrect type in argument 1 (different address spaces)
init/initramfs.c:323:13:    expected char const [noderef] <asn:1>*filename
init/initramfs.c:323:13:    got char *static [toplevel] [assigned] collected
init/initramfs.c:561:17: warning: incorrect type in argument 1 (different address spaces)
init/initramfs.c:561:17:    expected char const [noderef] <asn:1>*filename
init/initramfs.c:561:17:    got char static *<noident>
init/initramfs.c:563:19: warning: incorrect type in argument 2 (different address spaces)
init/initramfs.c:563:19:    expected char const [noderef] <asn:1>*buf
init/initramfs.c:563:19:    got char *<noident>

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 include/linux/initrd.h  |   12 +++++++++
 init/do_mounts.c        |   32 ++++++++++++++-----------
 init/do_mounts.h        |    4 +-
 init/do_mounts_initrd.c |   58 +++++++++++++++++++++++++++++++---------------
 init/do_mounts_rd.c     |   25 ++++++++++---------
 init/initramfs.c        |   41 +++++++++++++++++++-------------
 init/main.c             |    4 +-
 7 files changed, 110 insertions(+), 66 deletions(-)

diff --git a/include/linux/initrd.h b/include/linux/initrd.h
index 55289d2..83cba3a 100644
--- a/include/linux/initrd.h
+++ b/include/linux/initrd.h
@@ -1,3 +1,5 @@
+#ifndef _LINUX_INITRD_H
+#define _LINUX_INITRD_H
 
 #define INITRD_MINOR 250 /* shouldn't collide with /dev/ram* too soon ... */
 
@@ -18,3 +20,13 @@ extern unsigned long initrd_start, initrd_end;
 extern void free_initrd_mem(unsigned long, unsigned long);
 
 extern unsigned int real_root_dev;
+
+extern char *envp_init[];
+
+extern const char __user cuold[], curoot[], curootroot[], cudot[], cuinitrd[];
+extern const char __user cudevram[], cudevconsole[], cudevroot[];
+extern const char __user cudevrootold[];
+extern char __user uold[], uroot[], urootroot[], udot[], uinitrd[];
+extern char __user udevram[], udevconsole[], udevroot[], udevrootold[];
+
+#endif /* _LINUX_INITRD_H */
diff --git a/init/do_mounts.c b/init/do_mounts.c
index 660c1e5..d82aa6b 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -11,6 +11,7 @@
 #include <linux/mount.h>
 #include <linux/device.h>
 #include <linux/init.h>
+#include <linux/initrd.h>
 #include <linux/fs.h>
 
 #include <linux/nfs_fs.h>
@@ -211,13 +212,15 @@ static void __init get_fs_names(char *page)
 	*s = '\0';
 }
 
-static int __init do_mount_root(char *name, char *fs, int flags, void *data)
+static int __init do_mount_root(char __user *name, char *fs,
+				unsigned long flags, void *data)
 {
-	int err = sys_mount(name, "/root", fs, flags, data);
+	long err = sys_mount(name, urootroot, (char __user *)fs,
+			     flags, (void __user *)data);
 	if (err)
 		return err;
 
-	sys_chdir("/root");
+	sys_chdir(urootroot);
 	ROOT_DEV = current->fs->pwd.mnt->mnt_sb->s_dev;
 	printk("VFS: Mounted root (%s filesystem)%s.\n",
 	       current->fs->pwd.mnt->mnt_sb->s_type->name,
@@ -226,7 +229,7 @@ static int __init do_mount_root(char *name, char *fs, int flags, void *data)
 	return 0;
 }
 
-void __init mount_block_root(char *name, int flags)
+void __init mount_block_root(char __user *name, unsigned long flags)
 {
 	char *fs_names = __getname();
 	char *p;
@@ -284,9 +287,9 @@ static int __init mount_nfs_root(void)
 {
 	void *data = nfs_root_data();
 
-	create_dev("/dev/root", ROOT_DEV);
+	create_dev(cudevroot, ROOT_DEV);
 	if (data &&
-	    do_mount_root("/dev/root", "nfs", root_mountflags, data) == 0)
+	    do_mount_root(devroot, "nfs", root_mountflags, data) == 0)
 		return 1;
 	return 0;
 }
@@ -297,19 +300,19 @@ void __init change_floppy(char *fmt, ...)
 {
 	struct termios termios;
 	char buf[80];
-	char c;
+	char __user c;
 	int fd;
 	va_list args;
 	va_start(args, fmt);
 	vsprintf(buf, fmt, args);
 	va_end(args);
-	fd = sys_open("/dev/root", O_RDWR | O_NDELAY, 0);
+	fd = sys_open(cudevroot, O_RDWR | O_NDELAY, 0);
 	if (fd >= 0) {
 		sys_ioctl(fd, FDEJECT, 0);
 		sys_close(fd);
 	}
 	printk(KERN_NOTICE "VFS: Insert %s and press ENTER\n", buf);
-	fd = sys_open("/dev/console", O_RDWR, 0);
+	fd = sys_open(cudevconsole, O_RDWR, 0);
 	if (fd >= 0) {
 		sys_ioctl(fd, TCGETS, (long)&termios);
 		termios.c_lflag &= ~ICANON;
@@ -346,8 +349,8 @@ void __init mount_root(void)
 	}
 #endif
 #ifdef CONFIG_BLOCK
-	create_dev("/dev/root", ROOT_DEV);
-	mount_block_root("/dev/root", root_mountflags);
+	create_dev(cudevroot, ROOT_DEV);
+	mount_block_root(udevroot, root_mountflags);
 #endif
 }
 
@@ -373,7 +376,8 @@ void __init prepare_namespace(void)
 	if (saved_root_name[0]) {
 		root_device_name = saved_root_name;
 		if (!strncmp(root_device_name, "mtd", 3)) {
-			mount_block_root(root_device_name, root_mountflags);
+			mount_block_root((char __user *)root_device_name,
+					 root_mountflags);
 			goto out;
 		}
 		ROOT_DEV = name_to_dev_t(root_device_name);
@@ -400,7 +404,7 @@ void __init prepare_namespace(void)
 
 	mount_root();
 out:
-	sys_mount(".", "/", NULL, MS_MOVE, NULL);
-	sys_chroot(".");
+	sys_mount(udot, uroot, NULL, MS_MOVE, NULL);
+	sys_chroot(cudot);
 }
 
diff --git a/init/do_mounts.h b/init/do_mounts.h
index 735705d..49e5ec6 100644
--- a/init/do_mounts.h
+++ b/init/do_mounts.h
@@ -8,12 +8,12 @@
 #include <linux/root_dev.h>
 
 void  change_floppy(char *fmt, ...);
-void  mount_block_root(char *name, int flags);
+void  mount_block_root(char __user *name, unsigned long flags);
 void  mount_root(void);
 extern int root_mountflags;
 extern char *root_device_name;
 
-static inline int create_dev(char *name, dev_t dev)
+static inline int create_dev(const char __user *name, dev_t dev)
 {
 	sys_unlink(name);
 	return sys_mknod(name, S_IFBLK|0600, new_encode_dev(dev));
diff --git a/init/do_mounts_initrd.c b/init/do_mounts_initrd.c
index 614241b..39b4e0b 100644
--- a/init/do_mounts_initrd.c
+++ b/init/do_mounts_initrd.c
@@ -16,6 +16,26 @@ unsigned int real_root_dev;	/* do_proc_dointvec cannot handle kdev_t */
 static int __initdata old_fd, root_fd;
 static int __initdata mount_initrd = 1;
 
+const char __user cuold[] = "/old";
+char __user uold[] = "/old";
+const char __user curoot[] = "/";
+char __user uroot[] = "/";
+const char __user curootroot[] = "/root";
+char __user urootroot[] = "/root";
+const char __user cudot[] = ".";
+char __user udot[] = ".";
+const char __user cuinitrd[] = "/root/initrd";
+char __user uinitrd[] = "/root/initrd";
+/* devs */
+const char __user cudevram[] = "/dev/ram";
+char __user udevram[] = "/dev/ram";
+const char __user cudevconsole[] = "/dev/console";
+char __user udevconsole[] = "/dev/console";
+const char __user cudevroot[] = "/dev/root";
+char __user udevroot[] = "/dev/root";
+const char __user cudevrootold[] = "/dev/root.old";
+char __user udevrootold[] = "/dev/root.old";
+
 static int __init no_initrd(char *str)
 {
 	mount_initrd = 0;
@@ -27,12 +47,11 @@ __setup("noinitrd", no_initrd);
 static int __init do_linuxrc(void * shell)
 {
 	static char *argv[] = { "linuxrc", NULL, };
-	extern char * envp_init[];
 
 	sys_close(old_fd);sys_close(root_fd);
 	sys_close(0);sys_close(1);sys_close(2);
 	sys_setsid();
-	(void) sys_open("/dev/console",O_RDWR,0);
+	(void) sys_open(cudevconsole, O_RDWR, 0);
 	(void) sys_dup(0);
 	(void) sys_dup(0);
 	return kernel_execve(shell, argv, envp_init);
@@ -44,16 +63,16 @@ static void __init handle_initrd(void)
 	int pid;
 
 	real_root_dev = new_encode_dev(ROOT_DEV);
-	create_dev("/dev/root.old", Root_RAM0);
+	create_dev(cudevrootold, Root_RAM0);
 	/* mount initrd on rootfs' /root */
-	mount_block_root("/dev/root.old", root_mountflags & ~MS_RDONLY);
-	sys_mkdir("/old", 0700);
-	root_fd = sys_open("/", 0, 0);
-	old_fd = sys_open("/old", 0, 0);
+	mount_block_root(udevrootold, root_mountflags & ~MS_RDONLY);
+	sys_mkdir(cuold, 0700);
+	root_fd = sys_open(curoot, 0, 0);
+	old_fd = sys_open(cuold, 0, 0);
 	/* move initrd over / and chdir/chroot in initrd root */
-	sys_chdir("/root");
-	sys_mount(".", "/", NULL, MS_MOVE, NULL);
-	sys_chroot(".");
+	sys_chdir(curootroot);
+	sys_mount(udot, uroot, NULL, MS_MOVE, NULL);
+	sys_chroot(cudot);
 
 	/*
 	 * In case that a resume from disk is carried out by linuxrc or one of
@@ -70,15 +89,15 @@ static void __init handle_initrd(void)
 
 	/* move initrd to rootfs' /old */
 	sys_fchdir(old_fd);
-	sys_mount("/", ".", NULL, MS_MOVE, NULL);
+	sys_mount(uroot, udot, NULL, MS_MOVE, NULL);
 	/* switch root and cwd back to / of rootfs */
 	sys_fchdir(root_fd);
-	sys_chroot(".");
+	sys_chroot(cudot);
 	sys_close(old_fd);
 	sys_close(root_fd);
 
 	if (new_decode_dev(real_root_dev) == Root_RAM0) {
-		sys_chdir("/old");
+		sys_chdir(cuold);
 		return;
 	}
 
@@ -86,17 +105,17 @@ static void __init handle_initrd(void)
 	mount_root();
 
 	printk(KERN_NOTICE "Trying to move old root to /initrd ... ");
-	error = sys_mount("/old", "/root/initrd", NULL, MS_MOVE, NULL);
+	error = sys_mount(uold, uinitrd, NULL, MS_MOVE, NULL);
 	if (!error)
 		printk("okay\n");
 	else {
-		int fd = sys_open("/dev/root.old", O_RDWR, 0);
+		int fd = sys_open(cudevrootold, O_RDWR, 0);
 		if (error == -ENOENT)
 			printk("/initrd does not exist. Ignored.\n");
 		else
 			printk("failed\n");
 		printk(KERN_NOTICE "Unmounting old root\n");
-		sys_umount("/old", MNT_DETACH);
+		sys_umount(uold, MNT_DETACH);
 		printk(KERN_NOTICE "Trying to free ramdisk memory ... ");
 		if (fd < 0) {
 			error = fd;
@@ -110,8 +129,9 @@ static void __init handle_initrd(void)
 
 int __init initrd_load(void)
 {
+	const char __user pathname[] = "/initrd.image";
 	if (mount_initrd) {
-		create_dev("/dev/ram", Root_RAM0);
+		create_dev(udevram, Root_RAM0);
 		/*
 		 * Load the initrd data into /dev/ram0. Execute it as initrd
 		 * unless /dev/ram0 is supposed to be our actual root device,
@@ -119,11 +139,11 @@ int __init initrd_load(void)
 		 * mounted in the normal path.
 		 */
 		if (rd_load_image("/initrd.image") && ROOT_DEV != Root_RAM0) {
-			sys_unlink("/initrd.image");
+			sys_unlink(pathname);
 			handle_initrd();
 			return 1;
 		}
 	}
-	sys_unlink("/initrd.image");
+	sys_unlink(pathname);
 	return 0;
 }
diff --git a/init/do_mounts_rd.c b/init/do_mounts_rd.c
index 46dfd64..e11c956 100644
--- a/init/do_mounts_rd.c
+++ b/init/do_mounts_rd.c
@@ -70,7 +70,7 @@ identify_ramdisk_image(int fd, int start_block)
 	 * Read block 0 to test for gzipped kernel
 	 */
 	sys_lseek(fd, start_block * BLOCK_SIZE, 0);
-	sys_read(fd, buf, size);
+	sys_read(fd, (char __user *)buf, size);
 
 	/*
 	 * If it matches the gzip magic numbers, return -1
@@ -105,7 +105,7 @@ identify_ramdisk_image(int fd, int start_block)
 	 * Read block 1 to test for minix and ext2 superblock
 	 */
 	sys_lseek(fd, (start_block+1) * BLOCK_SIZE, 0);
-	sys_read(fd, buf, size);
+	sys_read(fd, (char __user *)buf, size);
 
 	/* Try minix */
 	if (minixsb->s_magic == MINIX_SUPER_MAGIC ||
@@ -149,11 +149,11 @@ int __init rd_load_image(char *from)
 	char rotator[4] = { '|' , '/' , '-' , '\\' };
 #endif
 
-	out_fd = sys_open("/dev/ram", O_RDWR, 0);
+	out_fd = sys_open(cudevram, O_RDWR, 0);
 	if (out_fd < 0)
 		goto out;
 
-	in_fd = sys_open(from, O_RDONLY, 0);
+	in_fd = sys_open((const char __user *)from, O_RDONLY, 0);
 	if (in_fd < 0)
 		goto noclose_input;
 
@@ -228,15 +228,16 @@ int __init rd_load_image(char *from)
 				goto noclose_input;
 			}
 			change_floppy("disk #%d", disk);
-			in_fd = sys_open(from, O_RDONLY, 0);
+			in_fd = sys_open((const char __user *)from,
+					 O_RDONLY, 0);
 			if (in_fd < 0)  {
 				printk("Error opening disk.\n");
 				goto noclose_input;
 			}
 			printk("Loading disk #%d... ", disk);
 		}
-		sys_read(in_fd, buf, BLOCK_SIZE);
-		sys_write(out_fd, buf, BLOCK_SIZE);
+		sys_read(in_fd, (char __user *)buf, BLOCK_SIZE);
+		sys_write(out_fd, (char __user *)buf, BLOCK_SIZE);
 #if !defined(CONFIG_S390) && !defined(CONFIG_PPC_ISERIES)
 		if (!(i % 16)) {
 			printk("%c\b", rotator[rotate & 0x3]);
@@ -254,7 +255,7 @@ noclose_input:
 	sys_close(out_fd);
 out:
 	kfree(buf);
-	sys_unlink("/dev/ram");
+	sys_unlink(cudevram);
 	return res;
 }
 
@@ -262,8 +263,8 @@ int __init rd_load_disk(int n)
 {
 	if (rd_prompt)
 		change_floppy("root floppy disk to be loaded into RAM disk");
-	create_dev("/dev/root", ROOT_DEV);
-	create_dev("/dev/ram", MKDEV(RAMDISK_MAJOR, n));
+	create_dev(cudevroot, ROOT_DEV);
+	create_dev(cudevram, MKDEV(RAMDISK_MAJOR, n));
 	return rd_load_image("/dev/root");
 }
 
@@ -349,7 +350,7 @@ static int __init fill_inbuf(void)
 {
 	if (exit_code) return -1;
 	
-	insize = sys_read(crd_infd, inbuf, INBUFSIZ);
+	insize = sys_read(crd_infd, (char __user *)inbuf, INBUFSIZ);
 	if (insize == 0) {
 		error("RAMDISK: ran out of compressed data");
 		return -1;
@@ -370,7 +371,7 @@ static void __init flush_window(void)
     unsigned n, written;
     uch *in, ch;
     
-    written = sys_write(crd_outfd, window, outcnt);
+    written = sys_write(crd_outfd, (char __user *)window, outcnt);
     if (written != outcnt && unzip_error == 0) {
 	printk(KERN_ERR "RAMDISK: incomplete write (%d != %d) %ld\n",
 	       written, outcnt, bytes_out);
diff --git a/init/initramfs.c b/init/initramfs.c
index 8eeeccb..dc6706c 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -240,7 +240,9 @@ static int __init maybe_link(void)
 	if (nlink >= 2) {
 		char *old = find_link(major, minor, ino, mode, collected);
 		if (old)
-			return (sys_link(old, collected) < 0) ? -1 : 1;
+			return (sys_link((const char __user *)old,
+					 (const char __user *)collected)
+					 < 0) ? -1 : 1;
 	}
 	return 0;
 }
@@ -249,11 +251,13 @@ static void __init clean_path(char *path, mode_t mode)
 {
 	struct stat st;
 
-	if (!sys_newlstat(path, &st) && (st.st_mode^mode) & S_IFMT) {
+	if (!sys_newlstat((char __user *)path,
+			  (struct stat __user *)&st) &&
+			  (st.st_mode^mode) & S_IFMT) {
 		if (S_ISDIR(st.st_mode))
-			sys_rmdir(path);
+			sys_rmdir((const char __user *)path);
 		else
-			sys_unlink(path);
+			sys_unlink((const char __user *)path);
 	}
 }
 
@@ -276,7 +280,8 @@ static int __init do_name(void)
 			int openflags = O_WRONLY|O_CREAT;
 			if (ml != 1)
 				openflags |= O_TRUNC;
-			wfd = sys_open(collected, openflags, mode);
+			wfd = sys_open((const char __user *)collected,
+				       openflags, mode);
 
 			if (wfd >= 0) {
 				sys_fchown(wfd, uid, gid);
@@ -285,15 +290,15 @@ static int __init do_name(void)
 			}
 		}
 	} else if (S_ISDIR(mode)) {
-		sys_mkdir(collected, mode);
-		sys_chown(collected, uid, gid);
-		sys_chmod(collected, mode);
+		sys_mkdir((const char __user *)collected, mode);
+		sys_chown((const char __user *)collected, uid, gid);
+		sys_chmod((const char __user *)collected, mode);
 	} else if (S_ISBLK(mode) || S_ISCHR(mode) ||
 		   S_ISFIFO(mode) || S_ISSOCK(mode)) {
 		if (maybe_link() == 0) {
-			sys_mknod(collected, mode, rdev);
-			sys_chown(collected, uid, gid);
-			sys_chmod(collected, mode);
+			sys_mknod((const char __user *)collected, mode, rdev);
+			sys_chown((const char __user *)collected, uid, gid);
+			sys_chmod((const char __user *)collected, mode);
 		}
 	}
 	return 0;
@@ -302,13 +307,13 @@ static int __init do_name(void)
 static int __init do_copy(void)
 {
 	if (count >= body_len) {
-		sys_write(wfd, victim, body_len);
+		sys_write(wfd, (const char __user *)victim, body_len);
 		sys_close(wfd);
 		eat(body_len);
 		state = SkipIt;
 		return 0;
 	} else {
-		sys_write(wfd, victim, count);
+		sys_write(wfd, (const char __user *)victim, count);
 		body_len -= count;
 		eat(count);
 		return 1;
@@ -319,8 +324,9 @@ static int __init do_symlink(void)
 {
 	collected[N_ALIGN(name_len) + body_len] = '\0';
 	clean_path(collected, 0);
-	sys_symlink(collected + N_ALIGN(name_len), collected);
-	sys_lchown(collected, uid, gid);
+	sys_symlink((const char __user *)collected + N_ALIGN(name_len),
+		    (const char __user *)collected);
+	sys_lchown((const char __user *)collected, uid, gid);
 	state = SkipIt;
 	next_state = Reset;
 	return 0;
@@ -540,6 +546,7 @@ skip:
 
 static int __init populate_rootfs(void)
 {
+	const char __user image[] = "/initrd.image";
 	char *err = unpack_to_rootfs(__initramfs_start,
 			 __initramfs_end - __initramfs_start, 0);
 	if (err)
@@ -558,9 +565,9 @@ static int __init populate_rootfs(void)
 			return 0;
 		}
 		printk("it isn't (%s); looks like an initrd\n", err);
-		fd = sys_open("/initrd.image", O_WRONLY|O_CREAT, 0700);
+		fd = sys_open(image, O_WRONLY|O_CREAT, 0700);
 		if (fd >= 0) {
-			sys_write(fd, (char *)initrd_start,
+			sys_write(fd, (const char __user *)initrd_start,
 					initrd_end - initrd_start);
 			sys_close(fd);
 			free_initrd();
diff --git a/init/main.c b/init/main.c
index f7fb200..a756446 100644
--- a/init/main.c
+++ b/init/main.c
@@ -190,7 +190,7 @@ static int __init set_reset_devices(char *str)
 __setup("reset_devices", set_reset_devices);
 
 static char * argv_init[MAX_INIT_ARGS+2] = { "init", NULL, };
-char * envp_init[MAX_INIT_ENVS+2] = { "HOME=/", "TERM=linux", NULL, };
+char *envp_init[MAX_INIT_ENVS+2] = { "HOME=/", "TERM=linux", NULL, };
 static const char *panic_later, *panic_param;
 
 extern struct obs_kernel_param __setup_start[], __setup_end[];
@@ -802,7 +802,7 @@ static int noinline init_post(void)
 	system_state = SYSTEM_RUNNING;
 	numa_default_policy();
 
-	if (sys_open((const char __user *) "/dev/console", O_RDWR, 0) < 0)
+	if (sys_open(cudevconsole, O_RDWR, 0) < 0)
 		printk(KERN_WARNING "Warning: unable to open an initial console.\n");
 
 	(void) sys_dup(0);
-- 
1.5.5.1



