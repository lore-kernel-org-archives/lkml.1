Return-Path: <linux-kernel-owner+w=401wt.eu-S1757263AbYILWGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263AbYILWGc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 18:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756054AbYILWGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 18:06:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44436 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754802AbYILWGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 18:06:19 -0400
Message-ID: <48CAE7A0.8000004@linux-foundation.org>
Date: Fri, 12 Sep 2008 17:05:20 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #11308] tbench regression on each kernel release from  2.6.22
 -&gt; 2.6.28
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik> <SpS7rta8n4.A.mr.ZesyIB@albercik>
In-Reply-To: <SpS7rta8n4.A.mr.ZesyIB@albercik>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11308
> Subject		: tbench regression on each kernel release from 2.6.22 -&gt; 2.6.28
> Submitter	: Christoph Lameter <cl@linux-foundation.org>
> Date		: 2008-08-11 18:36 (33 days old)
> References	: http://marc.info/?l=linux-kernel&m=121847986119495&w=4
> 
> 
> 

tbench

2.6.27-rc6	2760 MB/sec
2.6.22 		3235.47 MB/sec

diff on the .config files for each (took .22 config and did a make oldconfig)

--- /boot/config-2.6.22.1-4U4JUMP1.12	2008-01-22 08:06:38.000000000 -0600
+++ .config	2008-09-12 16:33:52.000000000 -0500
@@ -1,55 +1,89 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.22.1-4U4JUMP1.12
-# Mon Jan 21 16:05:52 2008
+# Linux kernel version: 2.6.27-rc6
+# Fri Sep 12 16:33:52 2008
 #
+# CONFIG_64BIT is not set
 CONFIG_X86_32=y
+# CONFIG_X86_64 is not set
+CONFIG_X86=y
+CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
+# CONFIG_GENERIC_LOCKBREAK is not set
 CONFIG_GENERIC_TIME=y
+CONFIG_GENERIC_CMOS_UPDATE=y
 CONFIG_CLOCKSOURCE_WATCHDOG=y
 CONFIG_GENERIC_CLOCKEVENTS=y
 CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
 CONFIG_LOCKDEP_SUPPORT=y
 CONFIG_STACKTRACE_SUPPORT=y
-CONFIG_SEMAPHORE_SLEEPERS=y
-CONFIG_X86=y
+CONFIG_HAVE_LATENCYTOP_SUPPORT=y
+CONFIG_FAST_CMPXCHG_LOCAL=y
 CONFIG_MMU=y
 CONFIG_ZONE_DMA=y
-CONFIG_QUICKLIST=y
 CONFIG_GENERIC_ISA_DMA=y
 CONFIG_GENERIC_IOMAP=y
 CONFIG_GENERIC_BUG=y
 CONFIG_GENERIC_HWEIGHT=y
+# CONFIG_GENERIC_GPIO is not set
 CONFIG_ARCH_MAY_HAVE_PC_FDC=y
-CONFIG_DMI=y
+# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
+CONFIG_RWSEM_XCHGADD_ALGORITHM=y
+# CONFIG_ARCH_HAS_ILOG2_U32 is not set
+# CONFIG_ARCH_HAS_ILOG2_U64 is not set
+CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
+CONFIG_GENERIC_CALIBRATE_DELAY=y
+# CONFIG_GENERIC_TIME_VSYSCALL is not set
+CONFIG_ARCH_HAS_CPU_RELAX=y
+CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
+CONFIG_HAVE_SETUP_PER_CPU_AREA=y
+# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
+CONFIG_ARCH_HIBERNATION_POSSIBLE=y
+CONFIG_ARCH_SUSPEND_POSSIBLE=y
+# CONFIG_ZONE_DMA32 is not set
+CONFIG_ARCH_POPULATES_NODE_MAP=y
+# CONFIG_AUDIT_ARCH is not set
+CONFIG_ARCH_SUPPORTS_AOUT=y
+CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
+CONFIG_GENERIC_HARDIRQS=y
+CONFIG_GENERIC_IRQ_PROBE=y
+CONFIG_GENERIC_PENDING_IRQ=y
+CONFIG_X86_SMP=y
+CONFIG_X86_32_SMP=y
+CONFIG_X86_HT=y
+CONFIG_X86_BIOS_REBOOT=y
+CONFIG_X86_TRAMPOLINE=y
+CONFIG_KTIME_SCALAR=y
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

 #
-# Code maturity level options
+# General setup
 #
 CONFIG_EXPERIMENTAL=y
 CONFIG_LOCK_KERNEL=y
 CONFIG_INIT_ENV_ARG_LIMIT=32
-
-#
-# General setup
-#
 CONFIG_LOCALVERSION=""
 CONFIG_LOCALVERSION_AUTO=y
 CONFIG_SWAP=y
 CONFIG_SYSVIPC=y
-# CONFIG_IPC_NS is not set
 CONFIG_SYSVIPC_SYSCTL=y
 CONFIG_POSIX_MQUEUE=y
 # CONFIG_BSD_PROCESS_ACCT is not set
 # CONFIG_TASKSTATS is not set
-# CONFIG_UTS_NS is not set
 # CONFIG_AUDIT is not set
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=18
-# CONFIG_CPUSETS is not set
+# CONFIG_CGROUPS is not set
+CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
+# CONFIG_GROUP_SCHED is not set
 CONFIG_SYSFS_DEPRECATED=y
+CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_RELAY is not set
+CONFIG_NAMESPACES=y
+# CONFIG_UTS_NS is not set
+# CONFIG_IPC_NS is not set
+# CONFIG_USER_NS is not set
+# CONFIG_PID_NS is not set
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE=""
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
@@ -64,6 +98,8 @@
 CONFIG_PRINTK=y
 CONFIG_BUG=y
 CONFIG_ELF_CORE=y
+CONFIG_PCSPKR_PLATFORM=y
+CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
 CONFIG_ANON_INODES=y
@@ -76,28 +112,40 @@
 CONFIG_SLAB=y
 # CONFIG_SLUB is not set
 # CONFIG_SLOB is not set
+CONFIG_PROFILING=y
+# CONFIG_MARKERS is not set
+CONFIG_OPROFILE=y
+CONFIG_HAVE_OPROFILE=y
+CONFIG_KPROBES=y
+CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
+CONFIG_KRETPROBES=y
+CONFIG_HAVE_IOREMAP_PROT=y
+CONFIG_HAVE_KPROBES=y
+CONFIG_HAVE_KRETPROBES=y
+# CONFIG_HAVE_ARCH_TRACEHOOK is not set
+# CONFIG_HAVE_DMA_ATTRS is not set
+CONFIG_USE_GENERIC_SMP_HELPERS=y
+# CONFIG_HAVE_CLK is not set
+CONFIG_PROC_PAGE_MONITOR=y
+CONFIG_HAVE_GENERIC_DMA_COHERENT=y
+CONFIG_SLABINFO=y
 CONFIG_RT_MUTEXES=y
 # CONFIG_TINY_SHMEM is not set
 CONFIG_BASE_SMALL=0
-
-#
-# Loadable module support
-#
 CONFIG_MODULES=y
+# CONFIG_MODULE_FORCE_LOAD is not set
 CONFIG_MODULE_UNLOAD=y
 CONFIG_MODULE_FORCE_UNLOAD=y
 # CONFIG_MODVERSIONS is not set
 # CONFIG_MODULE_SRCVERSION_ALL is not set
-# CONFIG_KMOD is not set
+CONFIG_KMOD=y
 CONFIG_STOP_MACHINE=y
-
-#
-# Block layer
-#
 CONFIG_BLOCK=y
 CONFIG_LBD=y
 # CONFIG_BLK_DEV_IO_TRACE is not set
 # CONFIG_LSF is not set
+# CONFIG_BLK_DEV_BSG is not set
+# CONFIG_BLK_DEV_INTEGRITY is not set

 #
 # IO Schedulers
@@ -111,6 +159,7 @@
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
+CONFIG_CLASSIC_RCU=y

 #
 # Processor type and features
@@ -118,17 +167,23 @@
 CONFIG_TICK_ONESHOT=y
 CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
+CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
 CONFIG_SMP=y
+CONFIG_X86_FIND_SMP_CONFIG=y
+CONFIG_X86_MPPARSE=y
 # CONFIG_X86_PC is not set
 # CONFIG_X86_ELAN is not set
 # CONFIG_X86_VOYAGER is not set
+CONFIG_X86_GENERICARCH=y
 # CONFIG_X86_NUMAQ is not set
 # CONFIG_X86_SUMMIT is not set
-# CONFIG_X86_BIGSMP is not set
-# CONFIG_X86_VISWS is not set
-CONFIG_X86_GENERICARCH=y
 # CONFIG_X86_ES7000 is not set
-# CONFIG_PARAVIRT is not set
+# CONFIG_X86_BIGSMP is not set
+# CONFIG_X86_VSMP is not set
+# CONFIG_X86_RDC321X is not set
+CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
+# CONFIG_PARAVIRT_GUEST is not set
+# CONFIG_MEMTEST is not set
 CONFIG_X86_CYCLONE_TIMER=y
 # CONFIG_M386 is not set
 # CONFIG_M486 is not set
@@ -139,7 +194,6 @@
 # CONFIG_MPENTIUMII is not set
 # CONFIG_MPENTIUMIII is not set
 # CONFIG_MPENTIUMM is not set
-CONFIG_MCORE2=y
 # CONFIG_MPENTIUM4 is not set
 # CONFIG_MK6 is not set
 # CONFIG_MK7 is not set
@@ -154,33 +208,34 @@
 # CONFIG_MCYRIXIII is not set
 # CONFIG_MVIAC3_2 is not set
 # CONFIG_MVIAC7 is not set
+# CONFIG_MPSC is not set
+CONFIG_MCORE2=y
+# CONFIG_GENERIC_CPU is not set
 CONFIG_X86_GENERIC=y
+CONFIG_X86_CPU=y
 CONFIG_X86_CMPXCHG=y
