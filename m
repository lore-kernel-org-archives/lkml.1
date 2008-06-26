Return-Path: <linux-kernel-owner+w=401wt.eu-S1763504AbYFZNBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763504AbYFZNBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759679AbYFZMlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:41:44 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:22648 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759331AbYFZMlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:41:39 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       linuxppc-dev@ozlabs.org, vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk,
       hpa@zytor.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 58/60] microblaze_v4: sys_microblaze.c
Date: Thu, 26 Jun 2008 14:30:27 +0200
Message-Id: <1214483429-32360-59-git-send-email-monstr@seznam.cz>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <1214483429-32360-58-git-send-email-monstr@seznam.cz>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz>
 <1214483429-32360-2-git-send-email-monstr@seznam.cz>
 <1214483429-32360-3-git-send-email-monstr@seznam.cz>
 <1214483429-32360-4-git-send-email-monstr@seznam.cz>
 <1214483429-32360-5-git-send-email-monstr@seznam.cz>
 <1214483429-32360-6-git-send-email-monstr@seznam.cz>
 <1214483429-32360-7-git-send-email-monstr@seznam.cz>
 <1214483429-32360-8-git-send-email-monstr@seznam.cz>
 <1214483429-32360-9-git-send-email-monstr@seznam.cz>
 <1214483429-32360-10-git-send-email-monstr@seznam.cz>
 <1214483429-32360-11-git-send-email-monstr@seznam.cz>
 <1214483429-32360-12-git-send-email-monstr@seznam.cz>
 <1214483429-32360-13-git-send-email-monstr@seznam.cz>
 <1214483429-32360-14-git-send-email-monstr@seznam.cz>
 <1214483429-32360-15-git-send-email-monstr@seznam.cz>
 <1214483429-32360-16-git-send-email-monstr@seznam.cz>
 <1214483429-32360-17-git-send-email-monstr@seznam.cz>
 <1214483429-32360-18-git-send-email-monstr@seznam.cz>
 <1214483429-32360-19-git-send-email-monstr@seznam.cz>
 <1214483429-32360-20-git-send-email-monstr@seznam.cz>
 <1214483429-32360-21-git-send-email-monstr@seznam.cz>
 <1214483429-32360-22-git-send-email-monstr@seznam.cz>
 <1214483429-32360-23-git-send-email-monstr@seznam.cz>
 <1214483429-32360-24-git-send-email-monstr@seznam.cz>
 <1214483429-32360-25-git-send-email-monstr@seznam.cz>
 <1214483429-32360-26-git-send-email-monstr@seznam.cz>
 <1214483429-32360-27-git-send-email-monstr@seznam.cz>
 <1214483429-32360-28-git-send-email-monstr@seznam.cz>
 <1214483429-32360-29-git-send-email-monstr@seznam.cz>
 <1214483429-32360-30-git-send-email-monstr@seznam.cz>
 <1214483429-32360-31-git-send-email-monstr@seznam.cz>
 <1214483429-32360-32-git-send-email-monstr@seznam.cz>
 <1214483429-32360-33-git-send-email-monstr@seznam.cz>
 <1214483429-32360-34-git-send-email-monstr@seznam.cz>
 <1214483429-32360-35-git-send-email-monstr@seznam.cz>
 <1214483429-32360-36-git-send-email-monstr@seznam.cz>
 <1214483429-32360-37-git-send-email-monstr@seznam.cz>
 <1214483429-32360-38-git-send-email-monstr@seznam.cz>
 <1214483429-32360-39-git-send-email-monstr@seznam.cz>
 <1214483429-32360-40-git-send-email-monstr@seznam.cz>
 <1214483429-32360-41-git-send-email-monstr@seznam.cz>
 <1214483429-32360-42-git-send-email-monstr@seznam.cz>
 <1214483429-32360-43-git-send-email-monstr@seznam.cz>
 <1214483429-32360-44-git-send-email-monstr@seznam.cz>
 <1214483429-32360-45-git-send-email-monstr@seznam.cz>
 <1214483429-32360-46-git-send-email-monstr@seznam.cz>
 <1214483429-32360-47-git-send-email-monstr@seznam.cz>
 <1214483429-32360-48-git-send-email-monstr@seznam.cz>
 <1214483429-32360-49-git-send-email-monstr@seznam.cz>
 <1214483429-32360-50-git-send-email-monstr@seznam.cz>
 <1214483429-32360-51-git-send-email-monstr@seznam.cz>
 <1214483429-32360-52-git-send-email-monstr@seznam.cz>
 <1214483429-32360-53-git-send-email-monstr@seznam.cz>
 <1214483429-32360-54-git-send-email-monstr@seznam.cz>
 <1214483429-32360-55-git-send-email-monstr@seznam.cz>
 <1214483429-32360-56-git-send-email-monstr@seznam.cz>
 <1214483429-32360-57-git-send-email-monstr@seznam.cz>
 <1214483429-32360-58-git-send-email-monstr@seznam.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/sys_microblaze.c |  283 +++++++++++++++++++++++++++++++
 1 files changed, 283 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/sys_microblaze.c

diff --git a/arch/microblaze/kernel/sys_microblaze.c b/arch/microblaze/kernel/sys_microblaze.c
new file mode 100644
index 0000000..4ff008b
--- /dev/null
+++ b/arch/microblaze/kernel/sys_microblaze.c
@@ -0,0 +1,283 @@
+/*
+ * Copyright (C) 2007 PetaLogix
+ *	John Williams <john.williams@petalogix.com>
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *	Yasushi SHOJI <yashi@atmark-techno.com>
+ *	Tetsuya OHKAWA <tetsuya@atmark-techno.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/errno.h>
+#include <linux/mm.h>
+#include <linux/smp.h>
+#include <linux/smp_lock.h>
+#include <linux/syscalls.h>
+#include <linux/sem.h>
+#include <linux/msg.h>
+#include <linux/shm.h>
+#include <linux/stat.h>
+#include <linux/mman.h>
+#include <linux/sys.h>
+#include <linux/ipc.h>
+#include <linux/utsname.h>
+#include <linux/file.h>
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/fs.h>
+
+#include <asm/uaccess.h>
+#include <linux/ipc.h>
+#include <asm/semaphore.h>
+#include <asm/unistd.h>
+
+/*
+ * sys_ipc() is the de-multiplexer for the SysV IPC calls..
+ *
+ * This is really horribly ugly.
+ */
+int
+sys_ipc(uint call, int first, int second, int third, void *ptr, long fifth)
+{
+	int version, ret;
+
+	version = call >> 16; /* hack for backward compatibility */
+	call &= 0xffff;
+
+	ret = -EINVAL;
+	switch (call) {
+	case SEMOP:
+		ret = sys_semop(first, (struct sembuf *)ptr, second);
+		break;
+	case SEMGET:
+		ret = sys_semget(first, second, third);
+		break;
+	case SEMCTL:
+	{
+		union semun fourth;
+
+		if (!ptr)
+			break;
+		if ((ret = access_ok(VERIFY_READ, ptr,
+					sizeof(long)) ? 0 : -EFAULT)
+			|| (ret = get_user(fourth.__pad, (void **)ptr)))
+			break;
+		ret = sys_semctl(first, second, third, fourth);
+		break;
+	}
+	case MSGSND:
+		ret = sys_msgsnd(first, (struct msgbuf *) ptr, second, third);
+		break;
+	case MSGRCV:
+		switch (version) {
+		case 0: {
+			struct ipc_kludge tmp;
+
+			if (!ptr)
+				break;
+			if ((ret = access_ok(VERIFY_READ, ptr,
+					sizeof(tmp)) ? 0 : -EFAULT)
+				|| (ret = copy_from_user(&tmp,
+						(struct ipc_kludge *) ptr,
+						sizeof(tmp))))
+				break;
+			ret = sys_msgrcv(first, tmp.msgp, second, tmp.msgtyp,
+					third);
+			break;
+			}
+		default:
+			ret = sys_msgrcv(first, (struct msgbuf *) ptr,
+					second, fifth, third);
+			break;
+		}
+		break;
+	case MSGGET:
+		ret = sys_msgget((key_t) first, second);
+		break;
+	case MSGCTL:
+		ret = sys_msgctl(first, second, (struct msqid_ds *) ptr);
+		break;
+	case SHMAT:
+		switch (version) {
+		default: {
+			ulong raddr;
+
+			if ((ret = access_ok(VERIFY_WRITE, (ulong *) third,
+					sizeof(ulong)) ? 0 : -EFAULT))
+				break;
+			ret = do_shmat(first, (char *) ptr, second, &raddr);
+			if (ret)
+				break;
+			ret = put_user(raddr, (ulong *) third);
+			break;
+			}
+		case 1:	/* iBCS2 emulator entry point */
+			if (!segment_eq(get_fs(), get_ds()))
+				break;
+			ret = do_shmat(first, (char *) ptr, second,
+					(ulong *) third);
+			break;
+		}
+		break;
+	case SHMDT:
+		ret = sys_shmdt((char *)ptr);
+		break;
+	case SHMGET:
+		ret = sys_shmget(first, second, third);
+		break;
+	case SHMCTL:
+		ret = sys_shmctl(first, second, (struct shmid_ds *) ptr);
+		break;
+	}
+
+	return ret;
+}
+
+long execve(const char *filename, char **argv, char **envp)
+{
+	struct pt_regs regs;
+	int ret;
+
+	memset(&regs, 0, sizeof(struct pt_regs));
+	local_save_flags(regs.msr);
+	ret = do_execve((char *)filename, (char __user * __user *)argv,
+			(char __user * __user *)envp, &regs);
+
+	if (ret < 0)
+		goto out;
+
+	/*
+	 * Save argc to the register structure for userspace.
+	 */
+	regs.r5 = ret; /* FIXME */
+
+	/*
+	 * We were successful. We won't be returning to our caller, but
+	 * instead to user space by manipulating the kernel stack.
+	 */
+	asm volatile ("addk	r5, r0, %0	\n\t"
+			"addk	r6, r0, %1	\n\t"
+			/* copy regs to top of stack */
+			"brlid	r15, memmove	\n\t"
+			"addik	r7, r0, %2	\n\t"
+			"brid	ret_to_user	\n\t"
+			/* reposition stack pointer */
+			"addk	r1, r0, r3	\n\t"
+			:
+			: "r" (task_pt_regs(current)),
+			"r" (&regs),
+			"i" (sizeof(regs))
+			: "r1", "r3", "r5", "r6", "r7", "r15", "memory");
+
+out:
+	return ret;
+}
+EXPORT_SYMBOL(execve);
+
+asmlinkage int sys_vfork(struct pt_regs *regs)
+{
+	return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, regs->r1,
+						regs, 0, NULL, NULL);
+}
+
+asmlinkage int sys_clone(int flags, unsigned long stack, struct pt_regs *regs)
+{
+	if (!stack)
+		stack = regs->r1;
+	return do_fork(flags, stack, regs, 0, NULL, NULL);
+}
+
+asmlinkage int sys_execve(char __user *filenamei, char __user * __user *argv,
+			char __user * __user *envp, struct pt_regs *regs)
+{
+	int error;
+	char *filename;
+
+	filename = getname(filenamei);
+	error = PTR_ERR(filename);
+	if (IS_ERR(filename))
+		goto out;
+	error = do_execve(filename, argv, envp, regs);
+	putname(filename);
+out:
+	return error;
+}
+
+static inline unsigned long
+do_mmap2(unsigned long addr, size_t len,
+	unsigned long prot, unsigned long flags,
+	unsigned long fd, unsigned long pgoff)
+{
+	struct file *file = NULL;
+	int ret = -EBADF;
+
+	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
+	if (!(flags & MAP_ANONYMOUS))
+		if (!(file = fget(fd))) {
+			printk(KERN_INFO "no fd in mmap\r\n");
+			goto out;
+		}
+
+	down_write(&current->mm->mmap_sem);
+	ret = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
+	up_write(&current->mm->mmap_sem);
+	if (file)
+		fput(file);
+out:
+	return ret;
+}
+
+unsigned long sys_mmap2(unsigned long addr, size_t len,
+			unsigned long prot, unsigned long flags,
+			unsigned long fd, unsigned long pgoff)
+{
+	return do_mmap2(addr, len, prot, flags, fd, pgoff);
+}
+
+unsigned long sys_mmap(unsigned long addr, size_t len,
+			unsigned long prot, unsigned long flags,
+			unsigned long fd, off_t offset)
+{
+	int err = -EINVAL;
+
+	if (offset & ~PAGE_MASK) {
+		printk(KERN_INFO "no pagemask in mmap\r\n");
+		goto out;
+	}
+
+	err = do_mmap2(addr, len, prot, flags, fd, offset >> PAGE_SHIFT);
+out:
+	return err;
+}
+
+int sys_uname(struct old_utsname *name)
+{
+	int err = -EFAULT;
+
+	down_read(&uts_sem);
+	if (name && !copy_to_user(name, utsname(), sizeof(*name)))
+		err = 0;
+	up_read(&uts_sem);
+	return err;
+}
+
+/*
+ * Do a system call from kernel instead of calling sys_execve so we
+ * end up with proper pt_regs.
+ */
+int kernel_execve(const char *filename, char *const argv[], char *const envp[])
+{
+	register const char *__a __asm__("r5") = filename;
+	register const void *__b __asm__("r6") = argv;
+	register const void *__c __asm__("r7") = envp;
+	register unsigned long __syscall __asm__("r12") = __NR_execve;
+	register unsigned long __ret __asm__("r3");
+	__asm__ __volatile__ ("brki r14, 0x8"
+			: "=r" (__ret), "=r" (__syscall)
+			: "1" (__syscall), "r" (__a), "r" (__b), "r" (__c)
+			: "r4", "r8", "r9",
+			"r10", "r11", "r14", "cc", "memory");
+	return __ret;
+}
-- 
1.5.4.GIT

