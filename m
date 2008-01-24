Return-Path: <linux-kernel-owner+w=401wt.eu-S1761779AbYAZQKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761779AbYAZQKw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 11:10:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758069AbYAZP5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 10:57:50 -0500
Received: from 206-47-31-89.wifiinternet.cz ([89.31.47.206]:1177 "EHLO
	monstr.monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757970AbYAZP5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 10:57:47 -0500
From: monstr@monstr.eu
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH 51/52] [microblaze] fcntl.h sockios.h ucontext.h unistd.h
Date: Thu, 24 Jan 2008 16:03:26 +0100
Message-Id: <e83ad9fcfb12993d8d20ce6663e563b8b496273e.1201107832.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.rc4.14.g6fc74
In-Reply-To: <993cd20fd7ee4ec891f1354690f93ca62d7871ec.1201107832.git.monstr@monstr.eu>
References: <1201187014-3979-1-git-send-email-monstr@monstr.eu>
 <dbff6b883dbcb108db53e5093994c473946e1240.1201107832.git.monstr@monstr.eu>
 <ac0947adfe718fcb4c0dc5f6f7ab64f8155541fb.1201107832.git.monstr@monstr.eu>
 <873c2bf1f67696aa11014886470f6ba46f04e8d2.1201107832.git.monstr@monstr.eu>
 <516d173b1789ea533431e8f5ad05751c6a353c88.1201107832.git.monstr@monstr.eu>
 <068508828aac6298b4cc65b0cd7b2737a61c466c.1201107832.git.monstr@monstr.eu>
 <010fc233f82a8f7a591c9f8315ae03f9951139aa.1201107832.git.monstr@monstr.eu>
 <68faaf69ea03196d4a56a263707355e7e7eb5c6a.1201107832.git.monstr@monstr.eu>
 <4b7d90fc1b9bcb3c0b1b308c6460390f7bdf3824.1201107832.git.monstr@monstr.eu>
 <eb28582e845efb4f2f26054630895f26fa69866e.1201107832.git.monstr@monstr.eu>
 <64e6e541db30cc4f1ee5cd85da4bdea6024f75b8.1201107832.git.monstr@monstr.eu>
 <90badb264d0e4ec49fdaa76842a5e5f259681299.1201107832.git.monstr@monstr.eu>
 <a013a2b7044186c64d55cdafc8c9b29bc73a7fc5.1201107832.git.monstr@monstr.eu>
 <60642f04ebcf9f76da50a1d40191755f258edcc5.1201107832.git.monstr@monstr.eu>
 <240998be1af3774635995fd19248f8b3a9e8a702.1201107832.git.monstr@monstr.eu>
 <3bcb9581bc512fdd0a124ac8322af9e2a8adc975.1201107832.git.monstr@monstr.eu>
 <db7f441df21cfe296a44744747b28f379e75fd49.1201107832.git.monstr@monstr.eu>
 <e6309af7cc6550ef5b399fc0902f1926f9e52e58.1201107832.git.monstr@monstr.eu>
 <2d11eef3abada1f41658a532a483c6121ded8054.1201107832.git.monstr@monstr.eu>
 <48db19662b808ab6f5455dd7f2116e6544c50e95.1201107832.git.monstr@monstr.eu>
 <7b0cfa6ae11749e20c941d0a4f03577141e022f8.1201107832.git.monstr@monstr.eu>
 <2f3db7ba4fe41cb9888adabf0e4e052d4da5c37c.1201107832.git.monstr@monstr.eu>
 <d67010417928d04766e6dd74820b12c249d61814.1201107832.git.monstr@monstr.eu>
 <37627293f081fa40f21234944ddb878d5e711740.1201107832.git.monstr@monstr.eu>
 <105791d33ea12564c70be0dd3fafef386f8e1b55.1201107832.git.monstr@monstr.eu>
 <b501d439bdfabddbdef5935db86b6f64c83d55c4.1201107832.git.monstr@monstr.eu>
 <43f77bd3045d72346eb39d3170de727050c835c1.1201107832.git.monstr@monstr.eu>
 <c09d54c49393bedbe4ca43df0e35cefa5fcc649c.1201107832.git.monstr@monstr.eu>
 <29ee870c02ea5d4c409644d7f0eb09cfbb1ec816.1201107832.git.monstr@monstr.eu>
 <99bfbc3fdb53003c11414681b2c73561d533c3ef.1201107832.git.monstr@monstr.eu>
 <1b21abdff6128297a902060b07a0c7ca6d8db633.1201107832.git.monstr@monstr.eu>
 <e173c10560cdf883ba3c7e639ca930f0627a2260.1201107832.git.monstr@monstr.eu>
 <155ee14d990137f7eb6fa76beee06c880c97e790.1201107832.git.monstr@monstr.eu>
 <34f2199d631406fbdf6b325a164e0d1899a3acb5.1201107832.git.monstr@monstr.eu>
 <14243bf49d44d1dbd6e377813f2635defcb82c4e.1201107832.git.monstr@monstr.eu>
 <01e493efdc1c8cb7ee0d5f8b7c73244e04680e71.1201107832.git.monstr@monstr.eu>
 <739e189a03021d2804f23d0774637a15038098bc.1201107832.git.monstr@monstr.eu>
 <d4eec3db9f6e6e86994444b8035d5e41db3f085b.1201107832.git.monstr@monstr.eu>
 <e445f6b37baf09d6469a0ad4eba189a7ca7ef7c3.1201107832.git.monstr@monstr.eu>
 <807d570db44eeed03e3211b933a207f42cf569f0.1201107832.git.monstr@monstr.eu>
 <990835fa238b139deac273e0573bcf5060e3ee80.1201107832.git.monstr@monstr.eu>
 <993cd20fd7ee4ec891f1354690f93ca62d7871ec.1201107832.git.monstr@monstr.eu>
In-Reply-To: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
References: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/fcntl.h    |  104 +++++++
 include/asm-microblaze/sockios.h  |   23 ++
 include/asm-microblaze/ucontext.h |   24 ++
 include/asm-microblaze/unistd.h   |  548 +++++++++++++++++++++++++++++++++++++
 4 files changed, 699 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-microblaze/fcntl.h
 create mode 100644 include/asm-microblaze/sockios.h
 create mode 100644 include/asm-microblaze/ucontext.h
 create mode 100644 include/asm-microblaze/unistd.h

diff --git a/include/asm-microblaze/fcntl.h b/include/asm-microblaze/fcntl.h
new file mode 100644
index 0000000..2b1fff2
--- /dev/null
+++ b/include/asm-microblaze/fcntl.h
@@ -0,0 +1,104 @@
+/*
+ * include/asm-microblaze/fcntl.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _MICROBLAZE_FCNTL_H
+#define _MICROBLAZE_FCNTL_H
+
+/* open/fcntl - O_SYNC is only implemented on blocks devices and on files
+ located on an ext2 file system */
+#define O_ACCMODE	0003
+#define O_RDONLY	00
+#define O_WRONLY	01
+#define O_RDWR		02
+#define O_CREAT		0100 /* not fcntl */
+#define O_EXCL		0200 /* not fcntl */
+#define O_NOCTTY	0400 /* not fcntl */
+#define O_TRUNC		01000 /* not fcntl */
+#define O_APPEND	02000
+#define O_NONBLOCK	04000
+#define O_NDELAY	O_NONBLOCK
+#define O_SYNC		010000
+#define FASYNC		020000 /* fcntl, for BSD compatibility */
+#define O_DIRECTORY	040000 /* must be a directory */
+#define O_NOFOLLOW	0100000 /* don't follow links */
+#define O_LARGEFILE	0200000
+#define O_DIRECT	0400000 /* direct disk access hint */
+#define O_NOATIME	01000000
+#define O_CLOEXEC	02000000
+
+#define F_DUPFD		0 /* dup */
+#define F_GETFD		1 /* get close_on_exec */
+#define F_SETFD		2 /* set/clear close_on_exec */
+#define F_GETFL		3 /* get file->f_flags */
+#define F_SETFL		4 /* set file->f_flags */
+#define F_GETLK		5
+#define F_SETLK		6
+#define F_SETLKW	7
+
+#define F_SETOWN	8 /* for sockets. */
+#define F_GETOWN	9 /* for sockets. */
+#define F_SETSIG	10 /* for sockets. */
+#define F_GETSIG	11 /* for sockets. */
+
+#define F_GETLK64	12 /* using 'struct flock64' */
+#define F_SETLK64	13
+#define F_SETLKW64	14
+
+/* for F_[GET|SET]FL */
+#define FD_CLOEXEC	1 /* actually anything with low bit set goes */
+
+/* for posix fcntl() and lockf() */
+#define F_RDLCK		0
+#define F_WRLCK		1
+#define F_UNLCK		2
+
+/* for old implementation of bsd flock () */
+#define F_EXLCK		4 /* or 3 */
+#define F_SHLCK		8 /* or 4 */
+
+/* for leases */
+#define F_INPROGRESS	16
+
+/* operations for bsd flock(), also used by the kernel implementation */
+#define LOCK_SH		1 /* shared lock */
+#define LOCK_EX		2 /* exclusive lock */
+#define LOCK_NB		4 /* or'd with one of the above to prevent blocking */
+#define LOCK_UN		8 /* remove lock */
+
+#define LOCK_MAND	32 /* This is a mandatory flock */
+#define LOCK_READ	64 /* ... Which allows concurrent read operations */
+#define LOCK_WRITE	128 /* ... Which allows concurrent write operations */
+#define LOCK_RW		192 /* ... Which allows concurrent read & write ops */
+
+#ifdef __KERNEL__
+#define F_POSIX		1
+#define F_FLOCK		2
+#define F_BROKEN	4 /* broken flock() emulation */
+#endif /* __KERNEL__ */
+
+struct flock {
+	short l_type;
+	short l_whence;
+	off_t l_start;
+	off_t l_len;
+	pid_t l_pid;
+};
+
+struct flock64 {
+	short l_type;
+	short l_whence;
+	loff_t l_start;
+	loff_t l_len;
+	pid_t l_pid;
+};
+
+#define F_LINUX_SPECIFIC_BASE	1024
+
+#endif /* _MICROBLAZE_FCNTL_H */
diff --git a/include/asm-microblaze/sockios.h b/include/asm-microblaze/sockios.h
new file mode 100644
index 0000000..079e166
--- /dev/null
+++ b/include/asm-microblaze/sockios.h
@@ -0,0 +1,23 @@
+/*
+ * include/asm-microblaze/sockios.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_SOCKIOS_H
+#define _ASM_SOCKIOS_H
+
+#include <asm/ioctl.h>
+
+#define FIOSETOWN	0x8901
+#define SIOCSPGRP	0x8902
+#define FIOGETOWN	0x8903
+#define SIOCGPGRP	0x8904
+#define SIOCATMARK	0x8905
+#define SIOCGSTAMP	0x8906 /* Get stamp */
+
+#endif /* _ASM_SOCKIOS_H */
diff --git a/include/asm-microblaze/ucontext.h b/include/asm-microblaze/ucontext.h
new file mode 100644
index 0000000..da464cf
--- /dev/null
+++ b/include/asm-microblaze/ucontext.h
@@ -0,0 +1,24 @@
+/*
+ * include/asm-microblaze/ucontext.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_UCONTEXT_H
+#define _ASM_UCONTEXT_H
+
+#include <asm/sigcontext.h>
+
+struct ucontext {
+	unsigned long		uc_flags;
+	struct ucontext		*uc_link;
+	stack_t			uc_stack;
+	struct sigcontext	uc_mcontext;
+	sigset_t		uc_sigmask; /* mask last for extensibility */
+};
+
+#endif /* _ASM_UCONTEXT_H */
diff --git a/include/asm-microblaze/unistd.h b/include/asm-microblaze/unistd.h
new file mode 100644
index 0000000..abaa2b7
--- /dev/null
+++ b/include/asm-microblaze/unistd.h
@@ -0,0 +1,548 @@
+/*
+ * include/asm-microblaze/unistd.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2007 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_UNISTD_H
+#define _ASM_UNISTD_H
+
+#define __NR_restart_syscall	0
+#define __NR_exit		1
+#define __NR_fork		2
+#define __NR_read		3
+#define __NR_write		4
+#define __NR_open		5
+#define __NR_close		6
+#define __NR_waitpid		7
+#define __NR_creat		8
+#define __NR_link		9
+#define __NR_unlink		10
+#define __NR_execve		11
+#define __NR_chdir		12
+#define __NR_time		13
+#define __NR_mknod		14
+#define __NR_chmod		15
+#define __NR_lchown		16
+#define __NR_break		17
+#define __NR_oldstat		18
+#define __NR_lseek		19
+#define __NR_getpid		20
+#define __NR_mount		21
+#define __NR_umount		22
+#define __NR_setuid		23
+#define __NR_getuid		24
+#define __NR_stime		25
+#define __NR_ptrace		26
+#define __NR_alarm		27
+#define __NR_oldfstat		28
+#define __NR_pause		29
+#define __NR_utime		30
+#define __NR_stty		31
+#define __NR_gtty		32
+#define __NR_access		33
+#define __NR_nice		34
+#define __NR_ftime		35
+#define __NR_sync		36
+#define __NR_kill		37
+#define __NR_rename		38
+#define __NR_mkdir		39
+#define __NR_rmdir		40
+#define __NR_dup		41
+#define __NR_pipe		42
+#define __NR_times		43
+#define __NR_prof		44
+#define __NR_brk		45
+#define __NR_setgid		46
+#define __NR_getgid		47
+#define __NR_signal		48
+#define __NR_geteuid		49
+#define __NR_getegid		50
+#define __NR_acct		51
+#define __NR_umount2		52
+#define __NR_lock		53
+#define __NR_ioctl		54
+#define __NR_fcntl		55
+#define __NR_mpx		56
+#define __NR_setpgid		57
+#define __NR_ulimit		58
+#define __NR_oldolduname	59
+#define __NR_umask		60
+#define __NR_chroot		61
+#define __NR_ustat		62
+#define __NR_dup2		63
+#define __NR_getppid		64
+#define __NR_getpgrp		65
+#define __NR_setsid		66
+#define __NR_sigaction		67
+#define __NR_sgetmask		68
+#define __NR_ssetmask		69
+#define __NR_setreuid		70
+#define __NR_setregid		71
+#define __NR_sigsuspend		72
+#define __NR_sigpending		73
+#define __NR_sethostname	74
+#define __NR_setrlimit		75
+#define __NR_getrlimit		76 /* Back compatible 2Gig limited rlimit */
+#define __NR_getrusage		77
+#define __NR_gettimeofday	78
+#define __NR_settimeofday	79
+#define __NR_getgroups		80
+#define __NR_setgroups		81
+#define __NR_select		82
+#define __NR_symlink		83
+#define __NR_oldlstat		84
+#define __NR_readlink		85
+#define __NR_uselib		86
+#define __NR_swapon		87
+#define __NR_reboot		88
+#define __NR_readdir		89
+#define __NR_mmap		90
+#define __NR_munmap		91
+#define __NR_truncate		92
+#define __NR_ftruncate		93
+#define __NR_fchmod		94
+#define __NR_fchown		95
+#define __NR_getpriority	96
+#define __NR_setpriority	97
+#define __NR_profil		98
+#define __NR_statfs		99
+#define __NR_fstatfs		100
+#define __NR_ioperm		101
+#define __NR_socketcall		102
+#define __NR_syslog		103
+#define __NR_setitimer		104
+#define __NR_getitimer		105
+#define __NR_stat		106
+#define __NR_lstat		107
+#define __NR_fstat		108
+#define __NR_olduname		109
+#define __NR_iopl		110
+#define __NR_vhangup		111
+#define __NR_idle		112
+#define __NR_vm86old		113
+#define __NR_wait4		114
+#define __NR_swapoff		115
+#define __NR_sysinfo		116
+#define __NR_ipc		117
+#define __NR_fsync		118
+#define __NR_sigreturn		119
+#define __NR_clone		120
+#define __NR_setdomainname	121
+#define __NR_uname		122
+#define __NR_modify_ldt		123
+#define __NR_adjtimex		124
+#define __NR_mprotect		125
+#define __NR_sigprocmask	126
+#define __NR_create_module	127
+#define __NR_init_module	128
+#define __NR_delete_module	129
+#define __NR_get_kernel_syms	130
+#define __NR_quotactl		131
+#define __NR_getpgid		132
+#define __NR_fchdir		133
+#define __NR_bdflush		134
+#define __NR_sysfs		135
+#define __NR_personality	136
+#define __NR_afs_syscall	137 /* Syscall for Andrew File System */
+#define __NR_setfsuid		138
+#define __NR_setfsgid		139
+#define __NR__llseek		140
+#define __NR_getdents		141
+#define __NR__newselect		142
+#define __NR_flock		143
+#define __NR_msync		144
+#define __NR_readv		145
+#define __NR_writev		146
+#define __NR_getsid		147
+#define __NR_fdatasync		148
+#define __NR__sysctl		149
+#define __NR_mlock		150
+#define __NR_munlock		151
+#define __NR_mlockall		152
+#define __NR_munlockall		153
+#define __NR_sched_setparam		154
+#define __NR_sched_getparam		155
+#define __NR_sched_setscheduler		156
+#define __NR_sched_getscheduler		157
+#define __NR_sched_yield		158
+#define __NR_sched_get_priority_max	159
+#define __NR_sched_get_priority_min	160
+#define __NR_sched_rr_get_interval	161
+#define __NR_nanosleep		162
+#define __NR_mremap		163
+#define __NR_setresuid		164
+#define __NR_getresuid		165
+#define __NR_vm86		166
+#define __NR_query_module	167
+#define __NR_poll		168
+#define __NR_nfsservctl		169
+#define __NR_setresgid		170
+#define __NR_getresgid		171
+#define __NR_prctl		172
+#define __NR_rt_sigreturn	173
+#define __NR_rt_sigaction	174
+#define __NR_rt_sigprocmask	175
+#define __NR_rt_sigpending	176
+#define __NR_rt_sigtimedwait	177
+#define __NR_rt_sigqueueinfo	178
+#define __NR_rt_sigsuspend	179
+#define __NR_pread64		180
+#define __NR_pwrite64		181
+#define __NR_chown		182
+#define __NR_getcwd		183
+#define __NR_capget		184
+#define __NR_capset		185
+#define __NR_sigaltstack	186
+#define __NR_sendfile		187
+#define __NR_getpmsg		188 /* some people actually want streams */
+#define __NR_putpmsg		189 /* some people actually want streams */
+#define __NR_vfork		190
+#define __NR_ugetrlimit		191 /* SuS compliant getrlimit */
+#define __NR_mmap2		192
+#define __NR_truncate64		193
+#define __NR_ftruncate64	194
+#define __NR_stat64		195
+#define __NR_lstat64		196
+#define __NR_fstat64		197
+#define __NR_lchown32		198
+#define __NR_getuid32		199
+#define __NR_getgid32		200
+#define __NR_geteuid32		201
+#define __NR_getegid32		202
+#define __NR_setreuid32		203
+#define __NR_setregid32		204
+#define __NR_getgroups32	205
+#define __NR_setgroups32	206
+#define __NR_fchown32		207
+#define __NR_setresuid32	208
+#define __NR_getresuid32	209
+#define __NR_setresgid32	210
+#define __NR_getresgid32	211
+#define __NR_chown32		212
+#define __NR_setuid32		213
+#define __NR_setgid32		214
+#define __NR_setfsuid32		215
+#define __NR_setfsgid32		216
+#define __NR_pivot_root		217
+#define __NR_mincore		218
+#define __NR_madvise		219
+#define __NR_madvise1		219 /* delete when C lib stub is removed */
+#define __NR_getdents64		220
+#define __NR_fcntl64		221
+/* 223 is unused */
+#define __NR_gettid		224
+#define __NR_readahead		225
+#define __NR_setxattr		226
+#define __NR_lsetxattr		227
+#define __NR_fsetxattr		228
+#define __NR_getxattr		229
+#define __NR_lgetxattr		230
+#define __NR_fgetxattr		231
+#define __NR_listxattr		232
+#define __NR_llistxattr		233
+#define __NR_flistxattr		234
+#define __NR_removexattr	235
+#define __NR_lremovexattr	236
+#define __NR_fremovexattr	237
+#define __NR_tkill		238
+#define __NR_sendfile64		239
+#define __NR_futex		240
+#define __NR_sched_setaffinity	241
+#define __NR_sched_getaffinity	242
+#define __NR_set_thread_area	243
+#define __NR_get_thread_area	244
+#define __NR_io_setup		245
+#define __NR_io_destroy		246
+#define __NR_io_getevents	247
+#define __NR_io_submit		248
+#define __NR_io_cancel		249
+#define __NR_fadvise64		250
+/* 251 is available for reuse (was briefly sys_set_zone_reclaim) */
+#define __NR_exit_group		252
+#define __NR_lookup_dcookie	253
+#define __NR_epoll_create	254
+#define __NR_epoll_ctl		255
+#define __NR_epoll_wait		256
+#define __NR_remap_file_pages	257
+#define __NR_set_tid_address	258
+#define __NR_timer_create	259
+#define __NR_timer_settime	(__NR_timer_create+1)
+#define __NR_timer_gettime	(__NR_timer_create+2)
+#define __NR_timer_getoverrun	(__NR_timer_create+3)
+#define __NR_timer_delete	(__NR_timer_create+4)
+#define __NR_clock_settime	(__NR_timer_create+5)
+#define __NR_clock_gettime	(__NR_timer_create+6)
+#define __NR_clock_getres	(__NR_timer_create+7)
+#define __NR_clock_nanosleep	(__NR_timer_create+8)
+#define __NR_statfs64		268
+#define __NR_fstatfs64		269
+#define __NR_tgkill		270
+#define __NR_utimes		271
+#define __NR_fadvise64_64	272
+#define __NR_vserver		273
+#define __NR_mbind		274
+#define __NR_get_mempolicy	275
+#define __NR_set_mempolicy	276
+#define __NR_mq_open		277
+#define __NR_mq_unlink		(__NR_mq_open+1)
+#define __NR_mq_timedsend	(__NR_mq_open+2)
+#define __NR_mq_timedreceive	(__NR_mq_open+3)
+#define __NR_mq_notify		(__NR_mq_open+4)
+#define __NR_mq_getsetattr	(__NR_mq_open+5)
+#define __NR_kexec_load		283
+#define __NR_waitid		284
+/* #define __NR_sys_setaltroot	285 */
+#define __NR_add_key		286
+#define __NR_request_key	287
+#define __NR_keyctl		288
+#define __NR_ioprio_set		289
+#define __NR_ioprio_get		290
+#define __NR_inotify_init	291
+#define __NR_inotify_add_watch	292
+#define __NR_inotify_rm_watch	293
+#define __NR_migrate_pages	294
+#define __NR_openat		295
+#define __NR_mkdirat		296
+#define __NR_mknodat		297
+#define __NR_fchownat		298
+#define __NR_futimesat		299
+#define __NR_fstatat64		300
+#define __NR_unlinkat		301
+#define __NR_renameat		302
+#define __NR_linkat		303
+#define __NR_symlinkat		304
+#define __NR_readlinkat		305
+#define __NR_fchmodat		306
+#define __NR_faccessat		307
+#define __NR_pselect6		308
+#define __NR_ppoll		309
+#define __NR_unshare		310
+#define __NR_set_robust_list	311
+#define __NR_get_robust_list	312
+#define __NR_splice		313
+#define __NR_sync_file_range	314
+#define __NR_tee		315
+#define __NR_vmsplice		316
+#define __NR_move_pages		317
+#define __NR_getcpu		318
+#define __NR_epoll_pwait	319
+#define __NR_utimensat		320
+#define __NR_signalfd		321
+#define __NR_timerfd		322
+#define __NR_eventfd		323
+#define __NR_fallocate		324
+
+#define NR_syscalls 324
+
+/*
+ * user-visible error numbers are in the range -1 - -128: see
+ * <asm-generic/errno.h>
+ *
+ * both i386 and microblaze use generic version * of errno.h. the
+ * generic version of errno.h has more than 128 of * numbers. not
+ * sure what the comment means.
+ *
+ * following code is taken from mb 2.4
+ */
+#define __syscall_return(type, res)					\
+do {									\
+	/* user-visible error numbers are in the range -1 - -124:	\
+	 see <asm-microblaze/errno.h> */				\
+	if ((unsigned long)(res) >= (unsigned long)(-125)) {		\
+		errno = -(res);						\
+		res = -1;						\
+	}								\
+	return (type) (res);						\
+} while (0)
+
+#define _syscall0(type, name)						\
+type name(void)								\
+{									\
+	long __ret;							\
+	asm volatile ("addik	r12, r0, %1	\n\t"			\
+			"brki	r14, 0x8	\n\t"			\
+			"addk	%0, r3, r0	\n\t"			\
+			: "=r" (__ret)					\
+			: "i" (__NR_##name)				\
+			: "r3", "r4", "r5", "r6", "r7", "r8", "r9",	\
+				"r10", "r12", "r14", "cc");		\
+	__syscall_return(type, __ret);					\
+}
+
+#define _syscall1(type, name, type1, arg1)				\
+type name(type1 arg1)							\
+{									\
+	long __ret;							\
+	asm volatile ("addk	r5, r0, %2	\n\t"			\
+			"addik	r12, r0, %1	\n\t"			\
+			"brki	r14, 0x8	\n\t"			\
+			"addk	%0, r3, r0	\n\t"			\
+			: "=r" (__ret)					\
+			: "i" (__NR_##name),				\
+			"r" ((long)arg1)				\
+			: "r3", "r4", "r5", "r6", "r7", "r8", "r9",	\
+				"r10", "r12", "r14", "cc");		\
+	__syscall_return(type, __ret);					\
+}
+
+#define _syscall2(type, name, type1, arg1, type2, arg2)			\
+type name(type1 arg1, type2 arg2)					\
+{									\
+	long __ret;							\
+	asm volatile ("addk	r5, r0, %2	\n\t"			\
+			"addk	r6, r0, %3	\n\t"			\
+			"addik	r12, r0, %1	\n\t"			\
+			"brki	r14, 0x8	\n\t"			\
+			"addk	%0, r3, r0	\n\t"			\
+			: "=r" (__ret)					\
+			: "i" (__NR_##name),				\
+			"r" ((long)arg1),				\
+			"r" ((long)arg2)				\
+			"r3", "r4", "r5", "r6", "r7", "r8", "r9",	\
+				"r10", "r12", "r14", "cc");		\
+	__syscall_return(type, __ret);					\
+}
+
+#define _syscall3(type, name, type1, arg1, type2, arg2, type3, arg3)	\
+type name(type1 arg1, type2 arg2, type3 arg3)				\
+{									\
+	long __ret;							\
+	asm volatile ("addk	r5, r0, %2	\n\t"			\
+			"addk	r6, r0, %3	\n\t"			\
+			"addk	r7, r0, %4	\n\t"			\
+			"addik	r12, r0, %1	\n\t"			\
+			"brki	r14, 0x8	\n\t"			\
+			"addk	%0, r3, r0	\n\t"			\
+			: "=r" (__ret)					\
+			: "i" (__NR_##name),				\
+			"r" ((long)arg1),				\
+			"r" ((long)arg2),				\
+			"r" ((long)arg3)				\
+			: "r3", "r4", "r5", "r6", "r7", "r8", "r9",	\
+				"r10", "r12", "r14", "cc");		\
+	__syscall_return(type, __ret);					\
+}
+
+#define _syscall4(type, name, type1, arg1, type2, arg2, type3, arg3,	\
+			type4, arg4)					\
+type name(type1 arg1, type2 arg2, type3 arg3, type4 arg4)		\
+{									\
+	long __ret;							\
+	asm volatile ("addk	r5, r0, %2	\n\t"			\
+			"addk	r6, r0, %3	\n\t"			\
+			"addk	r7, r0, %4	\n\t"			\
+			"addk	r8, r0, %5	\n\t"			\
+			"addik	r12, r0, %1	\n\t"			\
+			"brki	r14, 0x8	\n\t"			\
+			"addk	%0, r3, r0	\n\t"			\
+			: "=r" (__ret)					\
+			: "i" (__NR_##name),				\
+			"r" ((long)arg1),				\
+			"r" ((long)arg2),				\
+			"r" ((long)arg3),				\
+			"r" ((long)arg4)				\
+			: "r3", "r4", "r5", "r6", "r7", "r8", "r9",	\
+				"r10", "r12", "r14", "cc");		\
+	__syscall_return(type, __ret);					\
+}
+
+#define _syscall5(type, name, type1, arg1, type2, arg2, type3, arg3,	\
+			type4, arg4, type5, arg5)			\
+type name(type1 arg1, type2 arg2, type3 arg3, type4 arg4, type5 arg5)	\
+{									\
+	long __ret;							\
+	asm volatile ("addk	r5, r0, %2	\n\t"			\
+			"addk	r6, r0, %3	\n\t"			\
+			"addk	r7, r0, %4	\n\t"			\
+			"addk	r8, r0, %5	\n\t"			\
+			"addk	r9, r0, %6	\n\t"			\
+			"addik	r12, r0, %1	\n\t"			\
+			"brki	r14, 0x8	\n\t"			\
+			"addk	%0, r3, r0	\n\t"			\
+			: "=r" (__ret)					\
+			: "i" (__NR_##name),				\
+			"r" ((long)arg1),				\
+			"r" ((long)arg2),				\
+			"r" ((long)arg3),				\
+			"r" ((long)arg4),				\
+			"r" ((long)arg5)				\
+			: "r3", "r4", "r5", "r6", "r7", "r8", "r9",	\
+				"r10", "r12", "r14", "cc");		\
+	__syscall_return(type, __ret);					\
+}
+
+#define _syscall6(type, name, type1, arg1, type2, arg2, type3, arg3,	\
+			type4, arg4, type5, arg5, type6, arg6)		\
+type name(type1 arg1, type2 arg2, type3 arg3, type4 arg4, type5 arg5,	\
+			type6 arg6)					\
+{									\
+	long __ret;							\
+	asm volatile ("addk	r5, r0, %2	\n\t"			\
+			"addk	r6, r0, %3	\n\t"			\
+			"addk	r7, r0, %4	\n\t"			\
+			"addk	r8, r0, %5	\n\t"			\
+			"addk	r9, r0, %6	\n\t"			\
+			"addk	r10, r0, %7	\n\t"			\
+			"addik	r12, r0, %1	\n\t"			\
+			"brki	r14, 0x8	\n\t"			\
+			"addk	%0, r3, r0	\n\t"			\
+			: "=r" (__ret)					\
+			: "i" (__NR_##name),				\
+			"r" ((long)arg1),				\
+			"r" ((long)arg2),				\
+			"r" ((long)arg3),				\
+			"r" ((long)arg4),				\
+			"r" ((long)arg5),				\
+			"r" ((long)arg6)				\
+			: "r3", "r4", "r5", "r6", "r7", "r8", "r9",	\
+				"r10", "r12", "r14", "cc");		\
+	__syscall_return(type, __ret);					\
+}
+
+#ifdef __KERNEL_SYSCALLS__
+
+extern long execve(const char *filename, char **argv, char **envp);
+
+#endif /* __KERNEL_SYSCALLS__ */
+
+#ifdef __KERNEL__
+#define __ARCH_WANT_IPC_PARSE_VERSION
+/* #define __ARCH_WANT_OLD_READDIR */
+/* #define __ARCH_WANT_OLD_STAT */
+#define __ARCH_WANT_STAT64
+#define __ARCH_WANT_SYS_ALARM
+#define __ARCH_WANT_SYS_GETHOSTNAME
+#define __ARCH_WANT_SYS_PAUSE
+#define __ARCH_WANT_SYS_SGETMASK
+#define __ARCH_WANT_SYS_SIGNAL
+#define __ARCH_WANT_SYS_TIME
+#define __ARCH_WANT_SYS_UTIME
+#define __ARCH_WANT_SYS_WAITPID
+#define __ARCH_WANT_SYS_SOCKETCALL
+#define __ARCH_WANT_SYS_FADVISE64
+#define __ARCH_WANT_SYS_GETPGRP
+#define __ARCH_WANT_SYS_LLSEEK
+#define __ARCH_WANT_SYS_NICE
+/* #define __ARCH_WANT_SYS_OLD_GETRLIMIT */
+#define __ARCH_WANT_SYS_OLDUMOUNT
+#define __ARCH_WANT_SYS_SIGPENDING
+#define __ARCH_WANT_SYS_SIGPROCMASK
+#define __ARCH_WANT_SYS_RT_SIGACTION
+/* #define __ARCH_WANT_SYS_RT_SIGSUSPEND */
+#endif
+
+/*
+ * "Conditional" syscalls
+ *
+ * What we want is __attribute__((weak,alias("sys_ni_syscall"))),
+ * but it doesn't work on all toolchains, so we just do it by hand
+ */
+#define cond_syscall(x) asm(".weak\t" #x "\n\t.set\t" #x ",sys_ni_syscall");
+
+#endif /* _ASM_UNISTD_H */
-- 
1.5.4.rc4.14.g6fc74

