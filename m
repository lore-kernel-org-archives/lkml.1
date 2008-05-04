Return-Path: <linux-kernel-owner+w=401wt.eu-S1756511AbYEEINw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbYEEINw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 04:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754722AbYEEINc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 04:13:32 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:33583 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755946AbYEEIN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 04:13:28 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 55/56] microblaze_v2: sys_microblaze.c
Date: Sun,  4 May 2008 13:41:44 +0200
Message-Id: <f9a90de744326afc94452b9acbf16cdc05002f8e.1209897267.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <90266c91f066bbc32d487bc7ee55b2f7e6ce0428.1209897267.git.monstr@monstr.eu>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>
 <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
 <c805caeb1dd7f6d1349c4a463cb88a5342a170d2.1209897266.git.monstr@monstr.eu>
 <f120ababf2bade9aab7199bffb3014aa606e5a1c.1209897266.git.monstr@monstr.eu>
 <684c36e5ad3f598e5079e88ec195545c4a7150c2.1209897266.git.monstr@monstr.eu>
 <ed3695121faf485d491cecdd96d5d4dcc498411d.1209897266.git.monstr@monstr.eu>
 <0674b1f7abb9a3d564b68c95bc28adc2c2fe9551.1209897266.git.monstr@monstr.eu>
 <9a7c6646e5dd9724c1cf34767adec181481fa3ef.1209897266.git.monstr@monstr.eu>
 <932956128c9c655a218a940eaf02017a5dd0bdf9.1209897266.git.monstr@monstr.eu>
 <2f801c33caee22e112af51ae927c264ce99ead01.1209897266.git.monstr@monstr.eu>
 <2391e49379fb6639f57d9d6e5811f3d49a4c6fda.1209897266.git.monstr@monstr.eu>
 <0873f3a1f3b72591735c6461b51964693cac52e5.1209897266.git.monstr@monstr.eu>
 <0ba1f259d3c17eba54e334622493577493f5065f.1209897266.git.monstr@monstr.eu>
 <694451053534fea7b78fb9d618b53a2b5ebeb602.1209897266.git.monstr@monstr.eu>
 <f0c837df4106a31c1a81917596603918f722ea7b.1209897266.git.monstr@monstr.eu>
 <d883a8d8da812d77fefd47730d28d0bdb7b504e0.1209897266.git.monstr@monstr.eu>
 <625ef466cf121d655539eedc919dd39166087e0c.1209897266.git.monstr@monstr.eu>
 <b5067a1846075ddd1035966ea1edc908579e2e88.1209897266.git.monstr@monstr.eu>
 <378157891bac535dbc55e658d5f03fdd332e85cf.1209897266.git.monstr@monstr.eu>
 <eadcc6f4754df78b69d6d54c404624d0390c8558.1209897266.git.monstr@monstr.eu>
 <4df4022e06b9056202cc2fdf0b99deb01563a0fa.1209897266.git.monstr@monstr.eu>
 <6b0c9864dc80776ae48d6488a6892e5d698751b7.1209897266.git.monstr@monstr.eu>
 <ea5cbbca49c38c506960fddba29cbd8cb24e1a8d.1209897266.git.monstr@monstr.eu>
 <4f4d6ed3fce9b21cdd6dcacb2d72fff7e9830628.1209897266.git.monstr@monstr.eu>
 <35e662a81eb86c7ffb2aaa6141ca38a07789f382.1209897266.git.monstr@monstr.eu>
 <b41fcf3dd830f4ba82692a9bec2406ed0c290e7e.1209897266.git.monstr@monstr.eu>
 <14acb31da2794d2d5916da3db3d75fe2285ac055.1209897266.git.monstr@monstr.eu>
 <598221ce2159046614d7b158ea62d5af51907af3.1209897266.git.monstr@monstr.eu>
 <41c1f410eaafd875246362d10ef9866d8cc2a934.1209897266.git.monstr@monstr.eu>
 <09ce2baf0c8308d3fbca98e7eb36a6aab59112a7.1209897266.git.monstr@monstr.eu>
 <c9418c683be99ae12abb89575c362d586c026bad.1209897266.git.monstr@monstr.eu>
 <cfde3796e95bdd17c32e4fd7762d0aee55967707.1209897266.git.monstr@monstr.eu>
 <8aba2d82c85cd1d5b56de328c1fd080ee51f0211.1209897266.git.monstr@monstr.eu>
 <c4000ff625bd217f9bb683e3bf8c7193a82bd744.1209897266.git.monstr@monstr.eu>
 <491f823fac6c03cc36834ec569a45d30a03a72cf.1209897266.git.monstr@monstr.eu>
 <96f2004535c34a0c762bf2012c299cbf9f89ab32.1209897266.git.monstr@monstr.eu>
 <92cd3a27b393bb394d48902594152351a92c59bb.1209897266.git.monstr@monstr.eu>
 <4e20213f5f296268a24955df8c951f7fba279816.1209897266.git.monstr@monstr.eu>
 <49eccf3408b90a5ebb42635493bbeef3b584acb9.1209897266.git.monstr@monstr.eu>
 <d1e4a572d2add458e1dc7c4f5a3039ae4faa2c04.1209897266.git.monstr@monstr.eu>
 <27d6acda14c492aae35d8bb1343a122624560418.1209897266.git.monstr@monstr.eu>
 <64e6fc7378cd5c714fcceef7d4965c1fb3d1b288.1209897266.git.monstr@monstr.eu>
 <9cc0d54a98f25748dc3f16fc3250524d7cd00877.1209897266.git.monstr@monstr.eu>
 <5d240127ee05c28d5156bfbf305329f9540f6c14.1209897267.git.monstr@monstr.eu>
 <59b5238f7a259dcac4c9ca6513756a188625462e.1209897267.git.monstr@monstr.eu>
 <8e1d421649250f7a3f638cd552bc46e5f5845890.1209897267.git.monstr@monstr.eu>
 <5b1319d426b1f55e08402790b4bc16a33ec7c00c.1209897267.git.monstr@monstr.eu>
 <eff9f144fc70b87a9ff6767e9ab92d3d55eebbae.1209897267.git.monstr@monstr.eu>
 <643084ee3819dd169cad3c4e3565c5ff20dd3429.1209897267.git.monstr@monstr.eu>
 <231ae415bf52de25c69f727fd13c50d201f8ecd8.1209897267.git.monstr@monstr.eu>
 <53e5b22838d017b7cf7f44c4bafe5f7e253732ce.1209897267.git.monstr@monstr.eu>
 <affa82887bee64b05420fdd5f723cca920acad90.1209897267.git.monstr@monstr.eu>
 <c709de3e3767d1be8b23ce73255389c525737c36.1209897267.git.monstr@monstr.eu>
 <a484cc541ae55e099035cccf903f208f39fdeb39.1209897267.git.monstr@monstr.eu>
 <90266c91f066bbc32d487bc7ee55b2f7e6ce0428.1209897267.git.monstr@monstr.eu>
In-Reply-To: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/sys_microblaze.c |  287 +++++++++++++++++++++++++++++++
 1 files changed, 287 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/sys_microblaze.c

diff --git a/arch/microblaze/kernel/sys_microblaze.c b/arch/microblaze/kernel/sys_microblaze.c
new file mode 100644
index 0000000..1cf8efd
--- /dev/null
+++ b/arch/microblaze/kernel/sys_microblaze.c
@@ -0,0 +1,287 @@
+/*
+ * arch/microblaze/kernel/sys_microblaze.c
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ * Copyright (C) 2007 PetaLogix
+ *
+ * Authors:
+ * John Williams <john.williams@petalogix.com>
+ * Yasushi SHOJI <yashi@atmark-techno.com>
+ * Tetsuya OHKAWA <tetsuya@atmark-techno.com>
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

