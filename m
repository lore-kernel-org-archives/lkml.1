Return-Path: <linux-kernel-owner+w=401wt.eu-S1759884AbXIRPO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759884AbXIRPO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 11:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759241AbXIRPOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 11:14:42 -0400
Received: from sslsrv.de ([62.75.159.123]:48863 "EHLO sslsrv.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758200AbXIRPOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 11:14:40 -0400
From: Philipp Marek <philipp@marek.priv.at>
To: linux-kernel@vger.kernel.org
Subject: UML dead with current -git?
Date: Tue, 18 Sep 2007 17:14:33 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_at+7G0lvrNw6RoL"
Message-Id: <200709181714.34035@x5>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_at+7G0lvrNw6RoL
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello everybody,

I'm trying to build a UML machine on x86-64 (config attached) 
but I'm getting compile errors.


What am I doing wrong?

	make allnoconfig ARCH=um
	make menuconfig ARCH=um
selected a few options
	make -j 5 ARCH=um
	..
	include/linux/jiffies.h:225:31: error: division by zero in #if
	include/linux/jiffies.h:225:46: warning: "SHIFT_HZ" is not defined
	In file included from arch/um/include/sysdep/kernel-offsets.h:2,
                 from arch/um/kernel/asm-offsets.c:1:
	include/linux/sched.h: In function 'dequeue_signal_lock':
	include/linux/sched.h:1506: error: implicit declaration of function 'local_irq_save'
	include/linux/sched.h:1508: error: implicit declaration of function 'local_irq_restore'
	In file included from include/linux/crypto.h:21,
                 from arch/um/include/sysdep/kernel-offsets.h:5,
                 from arch/um/kernel/asm-offsets.c:1:
	include/linux/module.h: At top level:
	include/linux/module.h:222: error: requested alignment is not a constant
	In file included from arch/um/kernel/asm-offsets.c:1:
	arch/um/include/sysdep/kernel-offsets.h:25:29: error: asm/arch/unistd.h: No such file or directory
	In file included from arch/um/include/sysdep/kernel-offsets.h:30,
                 from arch/um/kernel/asm-offsets.c:1:
	arch/um/include/common-offsets.h: In function 'foo':
	arch/um/include/common-offsets.h:8: error: 'struct thread_struct' has no member named 'regs'
	make[1]: *** [arch/um/kernel/asm-offsets.s] Error 1
	make: *** [prepare0] Error 2


Thank you for all help.


Regards,

Phil


-- 
Versioning your /etc, /home or even your whole installation?
             Try fsvs (fsvs.tigris.org)!

--Boundary-00=_at+7G0lvrNw6RoL
Content-Type: text/plain;
  charset="utf-8";
  name="build.txt"
Content-Transfer-Encoding: 7bit
Content-Description: make output
Content-Disposition: attachment;
	filename="build.txt"

  SYMLINK arch/um/include/kern_constants.h
make[1]: `arch/um/sys-x86_64/user-offsets.s' is up to date.
  CHK     arch/um/include/user_constants.h
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CC      arch/um/kernel/asm-offsets.s
In file included from include/asm/pda.h:8,
                 from include/asm/current.h:7,
                 from include/linux/capability.h:47,
                 from include/linux/sched.h:49,
                 from arch/um/include/sysdep/kernel-offsets.h:2,
                 from arch/um/kernel/asm-offsets.c:1:
include/asm/page.h:89:6: warning: "CONFIG_PHYSICAL_START" is not defined
In file included from include/linux/prefetch.h:14,
                 from include/linux/list.h:8,
                 from include/linux/preempt.h:11,
                 from include/linux/spinlock.h:49,
                 from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/timex.h:57,
                 from include/linux/sched.h:53,
                 from arch/um/include/sysdep/kernel-offsets.h:2,
                 from arch/um/kernel/asm-offsets.c:1:
include/asm/processor.h:78: error: 'CONFIG_X86_L1_CACHE_SHIFT' undeclared here (not in a function)
include/asm/processor.h:78: error: requested alignment is not a constant
include/asm/processor.h:198: error: requested alignment is not a constant
In file included from include/linux/sched.h:54,
                 from arch/um/include/sysdep/kernel-offsets.h:2,
                 from arch/um/kernel/asm-offsets.c:1:
include/linux/jiffies.h:18:5: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:20:7: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:22:7: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:24:7: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:26:7: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:28:7: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:30:7: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:33:3: error: #error You lose.
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:46: warning: "SHIFT_HZ" is not defined
In file included from arch/um/include/sysdep/kernel-offsets.h:2,
                 from arch/um/kernel/asm-offsets.c:1:
include/linux/sched.h: In function 'dequeue_signal_lock':
include/linux/sched.h:1506: error: implicit declaration of function 'local_irq_save'
include/linux/sched.h:1508: error: implicit declaration of function 'local_irq_restore'
In file included from include/linux/crypto.h:21,
                 from arch/um/include/sysdep/kernel-offsets.h:5,
                 from arch/um/kernel/asm-offsets.c:1:
include/linux/module.h: At top level:
include/linux/module.h:222: error: requested alignment is not a constant
In file included from arch/um/kernel/asm-offsets.c:1:
arch/um/include/sysdep/kernel-offsets.h:25:29: error: asm/arch/unistd.h: No such file or directory
In file included from arch/um/include/sysdep/kernel-offsets.h:30,
                 from arch/um/kernel/asm-offsets.c:1:
arch/um/include/common-offsets.h: In function 'foo':
arch/um/include/common-offsets.h:8: error: 'struct thread_struct' has no member named 'regs'
make[1]: *** [arch/um/kernel/asm-offsets.s] Error 1
make: *** [prepare0] Error 2

--Boundary-00=_at+7G0lvrNw6RoL
Content-Type: text/plain;
  charset="utf-8";
  name=".config"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=".config"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.23-rc6
# Tue Sep 18 17:11:16 2007
#
CONFIG_DEFCONFIG_LIST="arch/$ARCH/defconfig"
CONFIG_GENERIC_HARDIRQS=y
CONFIG_UML=y
CONFIG_MMU=y
CONFIG_NO_IOMEM=y
# CONFIG_TRACE_IRQFLAGS_SUPPORT is not set
CONFIG_LOCKDEP_SUPPORT=y
# CONFIG_STACKTRACE_SUPPORT is not set
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_BUG=y
CONFIG_IRQ_RELEASE_METHOD=y

#
# UML-specific options
#
CONFIG_STATIC_LINK=y
CONFIG_MODE_SKAS=y
CONFIG_UML_X86=y
CONFIG_64BIT=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_TOP_ADDR=0x80000000
CONFIG_3_LEVEL_PGTABLES=y
CONFIG_STUB_CODE=0x7fbfffe000
CONFIG_STUB_DATA=0x7fbffff000
CONFIG_STUB_START=0x7fbfffe000
# CONFIG_ARCH_HAS_SC_SIGNALS is not set
# CONFIG_ARCH_REUSE_HOST_VSYSCALL_AREA is not set
CONFIG_SMP_BROKEN=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
# CONFIG_SPARSEMEM_STATIC is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
CONFIG_LD_SCRIPT_STATIC=y
# CONFIG_NET is not set
CONFIG_BINFMT_ELF=y
# CONFIG_BINFMT_MISC is not set
CONFIG_HOSTFS=y
# CONFIG_HPPFS is not set
CONFIG_MCONSOLE=y
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_NEST_LEVEL=0
CONFIG_KERNEL_STACK_ORDER=1
# CONFIG_UML_REAL_TIME_CLOCK is not set

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=128
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_USER_NS is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=14
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
# CONFIG_BLK_DEV_INITRD is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_EXTRA_PASS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y
CONFIG_BLOCK=y
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_BLK_DEV_BSG is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_AS is not set
# CONFIG_IOSCHED_DEADLINE is not set
# CONFIG_IOSCHED_CFQ is not set
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
# CONFIG_BLK_DEV is not set
# CONFIG_MMAPPER is not set

#
# Character Devices
#
# CONFIG_STDERR_CONSOLE is not set
CONFIG_STDIO_CONSOLE=y
# CONFIG_SSL is not set
# CONFIG_NULL_CHAN is not set
# CONFIG_PORT_CHAN is not set
# CONFIG_PTY_CHAN is not set
# CONFIG_TTY_CHAN is not set
# CONFIG_XTERM_CHAN is not set
CONFIG_NOCONFIG_CHAN=y
CONFIG_CON_ZERO_CHAN="fd:0,fd:1"
CONFIG_CON_CHAN="xterm"
CONFIG_SSL_CHAN="pty"
# CONFIG_UNIX98_PTYS is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_WATCHDOG is not set
# CONFIG_UML_SOUND is not set
# CONFIG_SOUND is not set
# CONFIG_HOSTAUDIO is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_UML_RANDOM is not set

#
# Generic Driver Options
#
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
# CONFIG_FW_LOADER is not set
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set

#
# Networking
#

#
# File systems
#
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
# CONFIG_EXT4DEV_FS is not set
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_FS_POSIX_ACL is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_INOTIFY is not set
# CONFIG_QUOTA is not set
CONFIG_DNOTIFY=y
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_RAMFS=y
# CONFIG_CONFIGFS_FS is not set

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y

#
# Native Language Support
#
# CONFIG_NLS is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_CRYPTO is not set

#
# Library routines
#
# CONFIG_CRC_CCITT is not set
# CONFIG_CRC16 is not set
# CONFIG_CRC_ITU_T is not set
# CONFIG_CRC32 is not set
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_PLIST=y
CONFIG_HAS_DMA=y

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
# CONFIG_SCSI is not set
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_MD is not set
# CONFIG_INPUT is not set

#
# Kernel hacking
#
# CONFIG_PRINTK_TIME is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_LIST is not set
CONFIG_FRAME_POINTER=y
CONFIG_FORCED_INLINING=y
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_GPROF is not set
# CONFIG_GCOV is not set
# CONFIG_DEBUG_STACK_USAGE is not set

--Boundary-00=_at+7G0lvrNw6RoL--
