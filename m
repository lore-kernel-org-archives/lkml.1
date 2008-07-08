Return-Path: <linux-kernel-owner+w=401wt.eu-S1757783AbYGHMIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757783AbYGHMIF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 08:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbYGHMHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 08:07:51 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:24717 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755116AbYGHMHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 08:07:49 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: monstr@seznam.cz, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, vapier.adi@gmail.com,
       alan@lxorguk.ukuu.org.uk, hpa@zytor.com, lethal@linux-sh.org,
       florian@openwrt.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 56/58] microblaze_v5: sys_microblaze.c
Date: Tue,  8 Jul 2008 13:59:56 +0200
Message-Id: <41cdea2c3255c0bcc7da940a2a1e76d48dc71d02.1215517976.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <64353f136ffa9f5dba8854168b6ef9d3a71f5a47.1215517976.git.monstr@monstr.eu>
References: <1215518398-5057-1-git-send-email-monstr@monstr.eu>
 <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
 <c03d29cbccaef8aed8a2911c2a259fbd79ad23d9.1215517976.git.monstr@monstr.eu>
 <58f35f498bac29e7105c589c06567e86c5a42dd5.1215517976.git.monstr@monstr.eu>
 <810775b1bb678003923039726a9153ee34fb67b4.1215517976.git.monstr@monstr.eu>
 <2a24e5bc2cfbd349613ef10c716a28f04ce24a9f.1215517976.git.monstr@monstr.eu>
 <3171c5cf21eefc79665165f4a14bc5b68dd03f95.1215517976.git.monstr@monstr.eu>
 <9be4eff2f4d015023c453eaec3b3473a44380491.1215517976.git.monstr@monstr.eu>
 <f8e331ed9432719f3c0555c840cbbb7bbc1a6322.1215517976.git.monstr@monstr.eu>
 <4409daf2ac356e902a8f091bb5908eb8a90218bc.1215517976.git.monstr@monstr.eu>
 <f7458acb0252f72b5620d19c76104408ecc2e451.1215517976.git.monstr@monstr.eu>
 <dbd9df742cdd9eb3355d7bc8e39f9dfef6c545e4.1215517976.git.monstr@monstr.eu>
 <1f9a1f345caa749cb630cf85f95f217366395069.1215517976.git.monstr@monstr.eu>
 <fe3686f0f70d838b33642bcbcd7185fc2180b366.1215517976.git.monstr@monstr.eu>
 <e61f5a8579570cf7cd18a22e4106b7f85518928e.1215517976.git.monstr@monstr.eu>
 <59d7e0a5f38b8d38f01f357a071fc93eed36f3a8.1215517976.git.monstr@monstr.eu>
 <143afcf84af583ab66da7e8acfc9eb03b7f3eaa0.1215517976.git.monstr@monstr.eu>
 <a967ee4e5a60b410e2810ce0475e8fd04f99e3ae.1215517976.git.monstr@monstr.eu>
 <c5f0730287365c845746467a9917dbc07d2fca3c.1215517976.git.monstr@monstr.eu>
 <2aa1ac7891af57959237aae3addf4bbe607f55d7.1215517976.git.monstr@monstr.eu>
 <875ba2708f6cd3c585e4d965142e2feb07c39a0e.1215517976.git.monstr@monstr.eu>
 <eb0e741f891335df37c3cd19f1a3ce2f7ce8652a.1215517976.git.monstr@monstr.eu>
 <b28df2ea2419cbda26f9089ed6edcc175c009688.1215517976.git.monstr@monstr.eu>
 <5da1d8f069f18f14faee8c4bff736791179ef6f1.1215517976.git.monstr@monstr.eu>
 <9a32168fe72b772f301216a7090670474af78e49.1215517976.git.monstr@monstr.eu>
 <7ada4bceefc1806a2c8ef73676b7aabd8ac1cad6.1215517976.git.monstr@monstr.eu>
 <701c1dac442ac09f5010cb5356cc1a12bb0abfe1.1215517976.git.monstr@monstr.eu>
 <9b48e9d85b4a5a6dcffce8eef62b232b6bfac8e8.1215517976.git.monstr@monstr.eu>
 <04b0b222b84ba9cfe2507a9081f4d715f2323733.1215517976.git.monstr@monstr.eu>
 <d4c1b3ecfec1bf37ca0ecea6909ad25bbc945630.1215517976.git.monstr@monstr.eu>
 <6e5687d37386334cf122d1eafcca0c6649c955be.1215517976.git.monstr@monstr.eu>
 <689cff1b6d98f60d8f8abc4472193688b524284d.1215517976.git.monstr@monstr.eu>
 <9664f18e7e86af4332018549b29bf0797d6afcd5.1215517976.git.monstr@monstr.eu>
 <c7120d8a6379cb1a18af5330997e30ec974acc2f.1215517976.git.monstr@monstr.eu>
 <d1d33c18956829ec9ac7daf8d0516b17e85ed190.1215517976.git.monstr@monstr.eu>
 <7a16429cfc461420883dbaa80c16047e5a1a91c1.1215517976.git.monstr@monstr.eu>
 <b6a0f3bceb0867c55613463fc43be5328fcedecd.1215517976.git.monstr@monstr.eu>
 <fc26823d77c7180b62022e2d4bcca3c4fe6de574.1215517976.git.monstr@monstr.eu>
 <64089967061955b7a29eb6d4e6269ff75b5442f2.1215517976.git.monstr@monstr.eu>
 <92e3ab88c2174acf4e25c474c1f68ffd4db72ca6.1215517976.git.monstr@monstr.eu>
 <5174afd0eaa5c6cb9344ea3217199e48899be313.1215517976.git.monstr@monstr.eu>
 <bcb94400dca62fb349d0ab1e0a6209291fdcdfc5.1215517976.git.monstr@monstr.eu>
 <5b2ed516b2e51d5117386c1b6eb814acc6e5a157.1215517976.git.monstr@monstr.eu>
 <421f4b613d4dbd983df1545a9a163347e5bd1c56.1215517976.git.monstr@monstr.eu>
 <0d39e8f03c487c004efa226c5ee81a81a8856768.1215517976.git.monstr@monstr.eu>
 <c4f477d71dd4cd2ae884b9c47756c9334f8dac18.1215517976.git.monstr@monstr.eu>
 <a98df8525bf9287d7a8b6077ff20dd61a055a98e.1215517976.git.monstr@monstr.eu>
 <c6651b096ee8a0691f94f8c19574302dbfb61ee4.1215517976.git.monstr@monstr.eu>
 <2ac3915482a9a50f7a4531908305b326baa2008e.1215517976.git.monstr@monstr.eu>
 <3c5eac3dbdbf538c727a4a8fe336cdd55650bb37.1215517976.git.monstr@monstr.eu>
 <6c03dcf8dbfd910ebf6c2f95db61d0456aa943e1.1215517976.git.monstr@monstr.eu>
 <1054e7643bd01351ba67273043203df322b49bea.1215517976.git.monstr@monstr.eu>
 <2bc35758e609ee5b79afe0f58be17d11a01498dc.1215517976.git.monstr@monstr.eu>
 <542a23f9748621b66e6f0ef8e0eb6248d542aa99.1215517976.git.monstr@monstr.eu>
 <5fbc8a35844b0f81291f7cf3ff5030baca819b67.1215517976.git.monstr@monstr.eu>
 <64353f136ffa9f5dba8854168b6ef9d3a71f5a47.1215517976.git.monstr@monstr.eu>
In-Reply-To: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
References: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Acked-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/sys_microblaze.c |  272 +++++++++++++++++++++++++++++++
 1 files changed, 272 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/sys_microblaze.c

diff --git a/arch/microblaze/kernel/sys_microblaze.c b/arch/microblaze/kernel/sys_microblaze.c
new file mode 100644
index 0000000..def5ff9
--- /dev/null
+++ b/arch/microblaze/kernel/sys_microblaze.c
@@ -0,0 +1,272 @@
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
+#include <linux/ipc.h>
+#include <linux/semaphore.h>
+
+#include <asm/uaccess.h>
+#include <asm/unistd.h>
+
+/*
+ * sys_ipc() is the de-multiplexer for the SysV IPC calls..
+ *
+ * This is really horribly ugly. This will be remove with new toolchain.
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

