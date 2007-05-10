Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbXEJOCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbXEJOCQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 10:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762260AbXEJN74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 09:59:56 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:52703 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762696AbXEJN7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 09:59:50 -0400
Subject: Please pull git390 'for-linus' branch
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain
Organization: IBM Corporation
Date: Thu, 10 May 2007 16:00:13 +0200
Message-Id: <1178805613.29611.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from 'for-linus' branch of

	git://git390.osdl.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

 arch/s390/Kconfig               |   49 +++------
 arch/s390/defconfig             |  234 +++++++++++++++++++++-----------------
 arch/s390/hypfs/inode.c         |    2 +-
 arch/s390/kernel/ipl.c          |   26 ++--
 arch/s390/mm/fault.c            |    5 +-
 drivers/ata/Kconfig             |    1 +
 drivers/auxdisplay/Kconfig      |    1 +
 drivers/block/Kconfig           |    4 +-
 drivers/char/Kconfig            |   11 ++-
 drivers/char/ipmi/Kconfig       |    2 +
 drivers/char/tpm/Kconfig        |    1 +
 drivers/crypto/Kconfig          |   22 ++++
 drivers/dma/Kconfig             |    1 +
 drivers/edac/Kconfig            |    1 +
 drivers/hwmon/Kconfig           |    1 +
 drivers/i2c/Kconfig             |    1 +
 drivers/ide/Kconfig             |    1 +
 drivers/ieee1394/Kconfig        |    1 +
 drivers/infiniband/Kconfig      |    1 +
 drivers/input/Kconfig           |    1 +
 drivers/isdn/Kconfig            |    1 +
 drivers/kvm/Kconfig             |    1 +
 drivers/leds/Kconfig            |    1 +
 drivers/media/Kconfig           |    1 +
 drivers/message/fusion/Kconfig  |    1 +
 drivers/message/i2o/Kconfig     |    1 +
 drivers/mfd/Kconfig             |    1 +
 drivers/mmc/Kconfig             |    1 +
 drivers/mtd/Kconfig             |    1 +
 drivers/net/phy/Kconfig         |    1 +
 drivers/net/wireless/Kconfig    |    1 +
 drivers/parport/Kconfig         |    1 +
 drivers/pnp/Kconfig             |    1 +
 drivers/rtc/Kconfig             |    1 +
 drivers/s390/Kconfig            |  239 ---------------------------------------
 drivers/s390/block/Kconfig      |   11 +-
 drivers/s390/block/dasd.c       |    8 +-
 drivers/s390/block/dasd_diag.c  |   10 +-
 drivers/s390/block/dasd_eckd.c  |    6 +-
 drivers/s390/block/dasd_ioctl.c |    4 +-
 drivers/s390/char/Kconfig       |  166 +++++++++++++++++++++++++++
 drivers/s390/char/monreader.c   |   14 +-
 drivers/s390/char/raw3270.c     |    5 +-
 drivers/s390/char/sclp.h        |    3 +
 drivers/s390/char/sclp_sdias.c  |    8 +-
 drivers/s390/char/zcore.c       |    9 +-
 drivers/s390/cio/css.c          |    3 +-
 drivers/s390/cio/css.h          |    2 -
 drivers/s390/cio/device.c       |    4 +-
 drivers/s390/cio/device_ops.c   |   11 ++
 drivers/s390/cio/qdio.c         |    1 +
 drivers/s390/net/Kconfig        |    8 +-
 drivers/s390/net/qeth_mpc.c     |    4 +-
 drivers/s390/scsi/zfcp_aux.c    |    8 +-
 drivers/s390/scsi/zfcp_dbf.c    |    2 +-
 drivers/serial/Kconfig          |    1 +
 drivers/spi/Kconfig             |    1 +
 drivers/telephony/Kconfig       |    1 +
 drivers/usb/Kconfig             |    1 +
 drivers/video/Kconfig           |    1 +
 drivers/w1/Kconfig              |    1 +
 include/asm-s390/ccwdev.h       |    3 +-
 include/asm-s390/ipl.h          |    2 +-
 include/asm-s390/param.h        |    2 +-
 net/Kconfig                     |    1 +
 net/ax25/Kconfig                |    2 +-
 net/bluetooth/Kconfig           |    2 +-
 net/irda/Kconfig                |    2 +-
 sound/Kconfig                   |    1 +
 69 files changed, 468 insertions(+), 459 deletions(-)
 delete mode 100644 drivers/s390/Kconfig
 create mode 100644 drivers/s390/char/Kconfig

Cornelia Huck (4):
      [S390] fix subsystem removal fallout
      [S390] cio: Get rid of _ccw_device_get_device_number().
      [S390] cio: Make some structures and a function static.
      [S390] dasd: Fix modular build.

Heiko Carstens (2):
      [S390] Avoid sparse warnings.
      [S390] Avoid compile warning.

Martin Schwidefsky (8):
      [S390] monreader inlining cleanup.
      [S390] Kconfig: refine depends statements.
      [S390] Kconfig: menus with depends on HAS_IOMEM.
      [S390] Kconfig: unwanted menus for s390.
      [S390] Kconfig: common config options for s390.
      [S390] Kconfig: use common Kconfig files for s390.
      [S390] Kconfig: no wireless on s390.
      [S390] update default configuration.

Ursula Braun (1):
      [S390] qdio: re-add lost perf_stats.tl_runs change in qdio_handle_pci

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 1a84719..098c62c 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -4,27 +4,23 @@
 #
 
 config MMU
-	bool
-	default y
+	def_bool y
 
 config ZONE_DMA
 	def_bool y
 	depends on 64BIT
 
 config LOCKDEP_SUPPORT
-	bool
-	default y
+	def_bool y
 
 config STACKTRACE_SUPPORT
-	bool
-	default y
+	def_bool y
 
 config RWSEM_GENERIC_SPINLOCK
 	bool
 
 config RWSEM_XCHGADD_ALGORITHM
-	bool
-	default y
+	def_bool y
 
 config ARCH_HAS_ILOG2_U32
 	bool
@@ -35,8 +31,7 @@ config ARCH_HAS_ILOG2_U64
 	default n
 
 config GENERIC_HWEIGHT
-	bool
-	default y
+	def_bool y
 
 config GENERIC_TIME
 	def_bool y
@@ -55,8 +50,7 @@ config NO_DMA
 mainmenu "Linux Kernel Configuration"
 
 config S390
-	bool
-	default y
+	def_bool y
 
 source "init/Kconfig"
 
@@ -280,6 +274,10 @@ config WARN_STACK_SIZE
 config ARCH_POPULATES_NODE_MAP
 	def_bool y
 
+comment "Kernel preemption"
+
+source "kernel/Kconfig.preempt"
+
 source "mm/Kconfig"
 
 config HOLES_IN_ZONE
@@ -320,17 +318,6 @@ config QDIO_DEBUG
 
 comment "Misc"
 
-config PREEMPT
-	bool "Preemptible Kernel"
-	help
-	  This option reduces the latency of the kernel when reacting to
-	  real-time or interactive events by allowing a low priority process to
-	  be preempted even if it is in kernel mode executing a system call.
-	  This allows applications to run more reliably even when the system is
-	  under load.
-
-	  Say N if you are unsure.
-
 config IPL
 	bool "Builtin IPL record support"
 	help
@@ -488,6 +475,8 @@ config APPLDATA_NET_SUM
 	  This can also be compiled as a module, which will be called
 	  appldata_net_sum.o.
 
+source kernel/Kconfig.hz
+
 config NO_IDLE_HZ
 	bool "No HZ timer ticks in idle"
 	help
@@ -535,18 +524,12 @@ endmenu
 source "net/Kconfig"
 
 config PCMCIA
-	bool
-	default n
-
-source "drivers/base/Kconfig"
+	def_bool n
 
-source "drivers/connector/Kconfig"
-
-source "drivers/scsi/Kconfig"
-
-source "drivers/s390/Kconfig"
+config CCW
+	def_bool y
 
-source "drivers/net/Kconfig"
+source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
diff --git a/arch/s390/defconfig b/arch/s390/defconfig
index 0e4da8a..485b60c 100644
--- a/arch/s390/defconfig
+++ b/arch/s390/defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.21-rc1
-# Wed Feb 21 10:44:30 2007
+# Linux kernel version: 2.6.21
+# Thu May 10 15:18:19 2007
 #
 CONFIG_MMU=y
 CONFIG_ZONE_DMA=y
@@ -14,6 +14,7 @@ CONFIG_GENERIC_HWEIGHT=y
 CONFIG_GENERIC_TIME=y
 CONFIG_GENERIC_BUG=y
 CONFIG_NO_IOMEM=y
+CONFIG_NO_DMA=y
 CONFIG_S390=y
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 
@@ -41,9 +42,11 @@ CONFIG_AUDIT=y
 # CONFIG_AUDITSYSCALL is not set
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
+CONFIG_LOG_BUF_SHIFT=17
 # CONFIG_CPUSETS is not set
 CONFIG_SYSFS_DEPRECATED=y
 # CONFIG_RELAY is not set
+CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE=""
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_SYSCTL=y
@@ -60,12 +63,14 @@ CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
 CONFIG_EPOLL=y
 CONFIG_SHMEM=y
-CONFIG_SLAB=y
 CONFIG_VM_EVENT_COUNTERS=y
+CONFIG_SLUB_DEBUG=y
+CONFIG_SLAB=y
+# CONFIG_SLUB is not set
+# CONFIG_SLOB is not set
 CONFIG_RT_MUTEXES=y
 # CONFIG_TINY_SHMEM is not set
 CONFIG_BASE_SMALL=0
-# CONFIG_SLOB is not set
 
 #
 # Loadable module support
@@ -128,6 +133,14 @@ CONFIG_CHECK_STACK=y
 CONFIG_STACK_GUARD=256
 # CONFIG_WARN_STACK is not set
 CONFIG_ARCH_POPULATES_NODE_MAP=y
+
+#
+# Kernel preemption
+#
+# CONFIG_PREEMPT_NONE is not set
+# CONFIG_PREEMPT_VOLUNTARY is not set
+CONFIG_PREEMPT=y
+CONFIG_PREEMPT_BKL=y
 CONFIG_SELECT_MEMORY_MODEL=y
 CONFIG_FLATMEM_MANUAL=y
 # CONFIG_DISCONTIGMEM_MANUAL is not set
@@ -150,7 +163,6 @@ CONFIG_QDIO=y
 #
 # Misc
 #
-CONFIG_PREEMPT=y
 CONFIG_IPL=y
 # CONFIG_IPL_TAPE is not set
 CONFIG_IPL_VM=y
@@ -163,6 +175,11 @@ CONFIG_PFAULT=y
 CONFIG_VIRT_TIMER=y
 CONFIG_VIRT_CPU_ACCOUNTING=y
 # CONFIG_APPLDATA_BASE is not set
+CONFIG_HZ_100=y
+# CONFIG_HZ_250 is not set
+# CONFIG_HZ_300 is not set
+# CONFIG_HZ_1000 is not set
+CONFIG_HZ=100
 CONFIG_NO_IDLE_HZ=y
 CONFIG_NO_IDLE_HZ_INIT=y
 CONFIG_S390_HYPFS_FS=y
@@ -177,7 +194,6 @@ CONFIG_NET=y
 #
 # Networking options
 #
-# CONFIG_NETDEBUG is not set
 CONFIG_PACKET=y
 # CONFIG_PACKET_MMAP is not set
 CONFIG_UNIX=y
@@ -216,6 +232,7 @@ CONFIG_DEFAULT_TCP_CONG="cubic"
 CONFIG_IPV6=y
 # CONFIG_IPV6_PRIVACY is not set
 # CONFIG_IPV6_ROUTER_PREF is not set
+# CONFIG_IPV6_OPTIMISTIC_DAD is not set
 # CONFIG_INET6_AH is not set
 # CONFIG_INET6_ESP is not set
 # CONFIG_INET6_IPCOMP is not set
@@ -240,7 +257,12 @@ CONFIG_IPV6_SIT=y
 #
 # SCTP Configuration (EXPERIMENTAL)
 #
-# CONFIG_IP_SCTP is not set
+CONFIG_IP_SCTP=m
+# CONFIG_SCTP_DBG_MSG is not set
+# CONFIG_SCTP_DBG_OBJCNT is not set
+# CONFIG_SCTP_HMAC_NONE is not set
+# CONFIG_SCTP_HMAC_SHA1 is not set
+CONFIG_SCTP_HMAC_MD5=y
 
 #
 # TIPC Configuration (EXPERIMENTAL)
@@ -263,9 +285,6 @@ CONFIG_IPV6_SIT=y
 #
 CONFIG_NET_SCHED=y
 CONFIG_NET_SCH_FIFO=y
-CONFIG_NET_SCH_CLK_JIFFIES=y
-# CONFIG_NET_SCH_CLK_GETTIMEOFDAY is not set
-# CONFIG_NET_SCH_CLK_CPU is not set
 
 #
 # Queueing/Scheduling
@@ -308,11 +327,14 @@ CONFIG_NET_ESTIMATOR=y
 #
 # CONFIG_NET_PKTGEN is not set
 # CONFIG_NET_TCPPROBE is not set
-# CONFIG_HAMRADIO is not set
-# CONFIG_IRDA is not set
-# CONFIG_BT is not set
-# CONFIG_IEEE80211 is not set
+# CONFIG_AF_RXRPC is not set
+# CONFIG_RFKILL is not set
 # CONFIG_PCMCIA is not set
+CONFIG_CCW=y
+
+#
+# Device Drivers
+#
 
 #
 # Generic Driver Options
@@ -330,6 +352,37 @@ CONFIG_SYS_HYPERVISOR=y
 # CONFIG_CONNECTOR is not set
 
 #
+# Block devices
+#
+# CONFIG_BLK_DEV_COW_COMMON is not set
+CONFIG_BLK_DEV_LOOP=m
+# CONFIG_BLK_DEV_CRYPTOLOOP is not set
+CONFIG_BLK_DEV_NBD=m
+CONFIG_BLK_DEV_RAM=y
+CONFIG_BLK_DEV_RAM_COUNT=16
+CONFIG_BLK_DEV_RAM_SIZE=4096
+CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
+# CONFIG_CDROM_PKTCDVD is not set
+# CONFIG_ATA_OVER_ETH is not set
+
+#
+# S/390 block device drivers
+#
+CONFIG_BLK_DEV_XPRAM=m
+# CONFIG_DCSSBLK is not set
+CONFIG_DASD=y
+CONFIG_DASD_PROFILE=y
+CONFIG_DASD_ECKD=y
+CONFIG_DASD_FBA=y
+CONFIG_DASD_DIAG=y
+CONFIG_DASD_EER=y
+
+#
+# Misc devices
+#
+# CONFIG_BLINK is not set
+
+#
 # SCSI device support
 #
 # CONFIG_RAID_ATTRS is not set
@@ -356,6 +409,7 @@ CONFIG_SCSI_MULTI_LUN=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_LOGGING=y
 CONFIG_SCSI_SCAN_ASYNC=y
+CONFIG_SCSI_WAIT_SCAN=m
 
 #
 # SCSI Transports
@@ -372,34 +426,6 @@ CONFIG_SCSI_FC_ATTRS=y
 # CONFIG_ISCSI_TCP is not set
 # CONFIG_SCSI_DEBUG is not set
 CONFIG_ZFCP=y
-CONFIG_CCW=y
-
-#
-# Block devices
-#
-# CONFIG_BLK_DEV_COW_COMMON is not set
-CONFIG_BLK_DEV_LOOP=m
-# CONFIG_BLK_DEV_CRYPTOLOOP is not set
-CONFIG_BLK_DEV_NBD=m
-CONFIG_BLK_DEV_RAM=y
-CONFIG_BLK_DEV_RAM_COUNT=16
-CONFIG_BLK_DEV_RAM_SIZE=4096
-CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
-CONFIG_BLK_DEV_INITRD=y
-# CONFIG_CDROM_PKTCDVD is not set
-
-#
-# S/390 block device drivers
-#
-CONFIG_BLK_DEV_XPRAM=m
-# CONFIG_DCSSBLK is not set
-CONFIG_DASD=y
-CONFIG_DASD_PROFILE=y
-CONFIG_DASD_ECKD=y
-CONFIG_DASD_FBA=y
-CONFIG_DASD_DIAG=y
-CONFIG_DASD_EER=y
-# CONFIG_ATA_OVER_ETH is not set
 
 #
 # Multi-device support (RAID and LVM)
@@ -421,56 +447,7 @@ CONFIG_DM_MIRROR=y
 CONFIG_DM_ZERO=y
 CONFIG_DM_MULTIPATH=y
 # CONFIG_DM_MULTIPATH_EMC is not set
-
-#
-# Character device drivers
-#
-CONFIG_UNIX98_PTYS=y
-CONFIG_UNIX98_PTY_COUNT=2048
-# CONFIG_HANGCHECK_TIMER is not set
-
-#
-# Watchdog Cards
-#
-# CONFIG_WATCHDOG is not set
-
-#
-# S/390 character device drivers
-#
-CONFIG_TN3270=y
-CONFIG_TN3270_TTY=y
-CONFIG_TN3270_FS=m
-CONFIG_TN3270_CONSOLE=y
-CONFIG_TN3215=y
-CONFIG_TN3215_CONSOLE=y
-CONFIG_CCW_CONSOLE=y
-CONFIG_SCLP_TTY=y
-CONFIG_SCLP_CONSOLE=y
-CONFIG_SCLP_VT220_TTY=y
-CONFIG_SCLP_VT220_CONSOLE=y
-CONFIG_SCLP_CPI=m
-CONFIG_S390_TAPE=m
-
-#
-# S/390 tape interface support
-#
-CONFIG_S390_TAPE_BLOCK=y
-
-#
-# S/390 tape hardware support
-#
-CONFIG_S390_TAPE_34XX=m
-# CONFIG_S390_TAPE_3590 is not set
-# CONFIG_VMLOGRDR is not set
-# CONFIG_VMCP is not set
-# CONFIG_MONREADER is not set
-CONFIG_MONWRITER=m
-
-#
-# Cryptographic devices
-#
-CONFIG_ZCRYPT=m
-# CONFIG_ZCRYPT_MONOLITHIC is not set
+# CONFIG_DM_DELAY is not set
 
 #
 # Network device support
@@ -482,10 +459,6 @@ CONFIG_EQUALIZER=m
 CONFIG_TUN=m
 
 #
-# PHY device support
-#
-
-#
 # Ethernet (10 or 100Mbit)
 #
 CONFIG_NET_ETHERNET=y
@@ -498,6 +471,7 @@ CONFIG_NET_ETHERNET=y
 #
 # Ethernet (10000 Mbit)
 #
+CONFIG_MLX4_DEBUG=y
 
 #
 # Token Ring devices
@@ -505,11 +479,6 @@ CONFIG_NET_ETHERNET=y
 # CONFIG_TR is not set
 
 #
-# Wireless LAN (non-hamradio)
-#
-# CONFIG_NET_RADIO is not set
-
-#
 # Wan interfaces
 #
 # CONFIG_WAN is not set
@@ -537,6 +506,56 @@ CONFIG_CCWGROUP=y
 # CONFIG_NET_POLL_CONTROLLER is not set
 
 #
+# Character devices
+#
+CONFIG_UNIX98_PTYS=y
+CONFIG_LEGACY_PTYS=y
+CONFIG_LEGACY_PTY_COUNT=256
+
+#
+# Watchdog Cards
+#
+# CONFIG_WATCHDOG is not set
+CONFIG_HW_RANDOM=m
+# CONFIG_R3964 is not set
+CONFIG_RAW_DRIVER=m
+CONFIG_MAX_RAW_DEVS=256
+# CONFIG_HANGCHECK_TIMER is not set
+
+#
+# S/390 character device drivers
+#
+CONFIG_TN3270=y
+CONFIG_TN3270_TTY=y
+CONFIG_TN3270_FS=m
+CONFIG_TN3270_CONSOLE=y
+CONFIG_TN3215=y
+CONFIG_TN3215_CONSOLE=y
+CONFIG_CCW_CONSOLE=y
+CONFIG_SCLP=y
+CONFIG_SCLP_TTY=y
+CONFIG_SCLP_CONSOLE=y
+CONFIG_SCLP_VT220_TTY=y
+CONFIG_SCLP_VT220_CONSOLE=y
+CONFIG_SCLP_CPI=m
+CONFIG_S390_TAPE=m
+
+#
+# S/390 tape interface support
+#
+CONFIG_S390_TAPE_BLOCK=y
+
+#
+# S/390 tape hardware support
+#
+CONFIG_S390_TAPE_34XX=m
+# CONFIG_S390_TAPE_3590 is not set
+# CONFIG_VMLOGRDR is not set
+# CONFIG_VMCP is not set
+# CONFIG_MONREADER is not set
+CONFIG_MONWRITER=m
+
+#
 # File systems
 #
 CONFIG_EXT2_FS=y
@@ -628,6 +647,7 @@ CONFIG_LOCKD_V4=y
 CONFIG_EXPORTFS=y
 CONFIG_NFS_COMMON=y
 CONFIG_SUNRPC=y
+# CONFIG_SUNRPC_BIND34 is not set
 # CONFIG_RPCSEC_GSS_KRB5 is not set
 # CONFIG_RPCSEC_GSS_SPKM3 is not set
 # CONFIG_SMB_FS is not set
@@ -658,6 +678,7 @@ CONFIG_MSDOS_PARTITION=y
 # CONFIG_SUN_PARTITION is not set
 # CONFIG_KARMA_PARTITION is not set
 # CONFIG_EFI_PARTITION is not set
+# CONFIG_SYSV68_PARTITION is not set
 
 #
 # Native Language Support
@@ -668,8 +689,6 @@ CONFIG_MSDOS_PARTITION=y
 # Distributed Lock Manager
 #
 CONFIG_DLM=m
-CONFIG_DLM_TCP=y
-# CONFIG_DLM_SCTP is not set
 # CONFIG_DLM_DEBUG is not set
 
 #
@@ -693,7 +712,6 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
 CONFIG_HEADERS_CHECK=y
 CONFIG_DEBUG_KERNEL=y
-CONFIG_LOG_BUF_SHIFT=17
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
 # CONFIG_DEBUG_SLAB is not set
@@ -729,12 +747,13 @@ CONFIG_FORCED_INLINING=y
 CONFIG_CRYPTO=y
 CONFIG_CRYPTO_ALGAPI=y
 CONFIG_CRYPTO_BLKCIPHER=y
+CONFIG_CRYPTO_HASH=m
 CONFIG_CRYPTO_MANAGER=y
-# CONFIG_CRYPTO_HMAC is not set
+CONFIG_CRYPTO_HMAC=m
 # CONFIG_CRYPTO_XCBC is not set
 # CONFIG_CRYPTO_NULL is not set
 # CONFIG_CRYPTO_MD4 is not set
-# CONFIG_CRYPTO_MD5 is not set
+CONFIG_CRYPTO_MD5=m
 # CONFIG_CRYPTO_SHA1 is not set
 # CONFIG_CRYPTO_SHA256 is not set
 # CONFIG_CRYPTO_SHA512 is not set
@@ -745,6 +764,7 @@ CONFIG_CRYPTO_ECB=m
 CONFIG_CRYPTO_CBC=y
 CONFIG_CRYPTO_PCBC=m
 # CONFIG_CRYPTO_LRW is not set
+# CONFIG_CRYPTO_CRYPTD is not set
 # CONFIG_CRYPTO_DES is not set
 CONFIG_CRYPTO_FCRYPT=m
 # CONFIG_CRYPTO_BLOWFISH is not set
@@ -771,6 +791,8 @@ CONFIG_CRYPTO_CAMELLIA=m
 # CONFIG_CRYPTO_DES_S390 is not set
 # CONFIG_CRYPTO_AES_S390 is not set
 CONFIG_S390_PRNG=m
+CONFIG_ZCRYPT=m
+# CONFIG_ZCRYPT_MONOLITHIC is not set
 
 #
 # Library routines
diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index ba5d316..8e1ea1c 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -477,7 +477,7 @@ static int __init hypfs_init(void)
 			goto fail_diag;
 		}
 	}
-	kset_set_kset_s(&s390_subsys, hypervisor_subsys);
+	kobj_set_kset_s(&s390_subsys, hypervisor_subsys);
 	rc = subsystem_register(&s390_subsys);
 	if (rc)
 		goto fail_sysfs;
diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index 0ea048d..367caf9 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -816,23 +816,23 @@ static int __init ipl_register_fcp_files(void)
 {
 	int rc;
 
-	rc = sysfs_create_group(&ipl_subsys.kset.kobj,
+	rc = sysfs_create_group(&ipl_subsys.kobj,
 				&ipl_fcp_attr_group);
 	if (rc)
 		goto out;
-	rc = sysfs_create_bin_file(&ipl_subsys.kset.kobj,
+	rc = sysfs_create_bin_file(&ipl_subsys.kobj,
 				   &ipl_parameter_attr);
 	if (rc)
 		goto out_ipl_parm;
-	rc = sysfs_create_bin_file(&ipl_subsys.kset.kobj,
+	rc = sysfs_create_bin_file(&ipl_subsys.kobj,
 				   &ipl_scp_data_attr);
 	if (!rc)
 		goto out;
 
-	sysfs_remove_bin_file(&ipl_subsys.kset.kobj, &ipl_parameter_attr);
+	sysfs_remove_bin_file(&ipl_subsys.kobj, &ipl_parameter_attr);
 
 out_ipl_parm:
-	sysfs_remove_group(&ipl_subsys.kset.kobj, &ipl_fcp_attr_group);
+	sysfs_remove_group(&ipl_subsys.kobj, &ipl_fcp_attr_group);
 out:
 	return rc;
 }
@@ -846,7 +846,7 @@ static int __init ipl_init(void)
 		return rc;
 	switch (ipl_info.type) {
 	case IPL_TYPE_CCW:
-		rc = sysfs_create_group(&ipl_subsys.kset.kobj,
+		rc = sysfs_create_group(&ipl_subsys.kobj,
 					&ipl_ccw_attr_group);
 		break;
 	case IPL_TYPE_FCP:
@@ -854,11 +854,11 @@ static int __init ipl_init(void)
 		rc = ipl_register_fcp_files();
 		break;
 	case IPL_TYPE_NSS:
-		rc = sysfs_create_group(&ipl_subsys.kset.kobj,
+		rc = sysfs_create_group(&ipl_subsys.kobj,
 					&ipl_nss_attr_group);
 		break;
 	default:
-		rc = sysfs_create_group(&ipl_subsys.kset.kobj,
+		rc = sysfs_create_group(&ipl_subsys.kobj,
 					&ipl_unknown_attr_group);
 		break;
 	}
@@ -885,7 +885,7 @@ static int __init reipl_nss_init(void)
 
 	if (!MACHINE_IS_VM)
 		return 0;
-	rc = sysfs_create_group(&reipl_subsys.kset.kobj, &reipl_nss_attr_group);
+	rc = sysfs_create_group(&reipl_subsys.kobj, &reipl_nss_attr_group);
 	if (rc)
 		return rc;
 	strncpy(reipl_nss_name, kernel_nss_name, NSS_NAME_SIZE + 1);
@@ -900,7 +900,7 @@ static int __init reipl_ccw_init(void)
 	reipl_block_ccw = (void *) get_zeroed_page(GFP_KERNEL);
 	if (!reipl_block_ccw)
 		return -ENOMEM;
-	rc = sysfs_create_group(&reipl_subsys.kset.kobj, &reipl_ccw_attr_group);
+	rc = sysfs_create_group(&reipl_subsys.kobj, &reipl_ccw_attr_group);
 	if (rc) {
 		free_page((unsigned long)reipl_block_ccw);
 		return rc;
@@ -938,7 +938,7 @@ static int __init reipl_fcp_init(void)
 	reipl_block_fcp = (void *) get_zeroed_page(GFP_KERNEL);
 	if (!reipl_block_fcp)
 		return -ENOMEM;
-	rc = sysfs_create_group(&reipl_subsys.kset.kobj, &reipl_fcp_attr_group);
+	rc = sysfs_create_group(&reipl_subsys.kobj, &reipl_fcp_attr_group);
 	if (rc) {
 		free_page((unsigned long)reipl_block_fcp);
 		return rc;
@@ -990,7 +990,7 @@ static int __init dump_ccw_init(void)
 	dump_block_ccw = (void *) get_zeroed_page(GFP_KERNEL);
 	if (!dump_block_ccw)
 		return -ENOMEM;
-	rc = sysfs_create_group(&dump_subsys.kset.kobj, &dump_ccw_attr_group);
+	rc = sysfs_create_group(&dump_subsys.kobj, &dump_ccw_attr_group);
 	if (rc) {
 		free_page((unsigned long)dump_block_ccw);
 		return rc;
@@ -1014,7 +1014,7 @@ static int __init dump_fcp_init(void)
 	dump_block_fcp = (void *) get_zeroed_page(GFP_KERNEL);
 	if (!dump_block_fcp)
 		return -ENOMEM;
-	rc = sysfs_create_group(&dump_subsys.kset.kobj, &dump_fcp_attr_group);
+	rc = sysfs_create_group(&dump_subsys.kobj, &dump_fcp_attr_group);
 	if (rc) {
 		free_page((unsigned long)dump_block_fcp);
 		return rc;
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 8b924b3..d855cdb 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -253,7 +253,10 @@ static int signal_return(struct mm_struct *mm, struct pt_regs *regs,
 			 unsigned long address, unsigned long error_code)
 {
 	u16 instruction;
-	int rc, compat;
+	int rc;
+#ifdef CONFIG_COMPAT
+	int compat;
+#endif
 
 	pagefault_disable();
 	rc = __get_user(instruction, (u16 __user *) regs->psw.addr);
diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index c721966..f031b87 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -3,6 +3,7 @@
 #
 
 menu "Serial ATA (prod) and Parallel ATA (experimental) drivers"
+	depends on HAS_IOMEM
 
 config ATA
 	tristate "ATA device support"
diff --git a/drivers/auxdisplay/Kconfig b/drivers/auxdisplay/Kconfig
index 0300e7f..2e18a63 100644
--- a/drivers/auxdisplay/Kconfig
+++ b/drivers/auxdisplay/Kconfig
@@ -6,6 +6,7 @@
 #
 
 menu "Auxiliary Display support"
+	depends on PARPORT
 
 config KS0108
 	tristate "KS0108 LCD Controller"
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 17ee97f..b4c8319 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -444,8 +444,6 @@ config CDROM_PKTCDVD_WCACHE
 	  this option is dangerous unless the CD-RW media is known good, as we
 	  don't do deferred write error handling yet.
 
-source "drivers/s390/block/Kconfig"
-
 config ATA_OVER_ETH
 	tristate "ATA over Ethernet support"
 	depends on NET
@@ -453,6 +451,8 @@ config ATA_OVER_ETH
 	This driver provides Support for ATA over Ethernet block
 	devices like the Coraid EtherDrive (R) Storage Blade.
 
+source "drivers/s390/block/Kconfig"
+
 endmenu
 
 endif
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 2df42fd..abcafac 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -6,6 +6,7 @@ menu "Character devices"
 
 config VT
 	bool "Virtual terminal" if EMBEDDED
+	depends on !S390
 	select INPUT
 	default y if !VIOCONS
 	---help---
@@ -81,6 +82,7 @@ config VT_HW_CONSOLE_BINDING
 
 config SERIAL_NONSTANDARD
 	bool "Non-standard serial port support"
+	depends on HAS_IOMEM
 	---help---
 	  Say Y here if you have any non-standard serial boards -- boards
 	  which aren't supported using the standard "dumb" serial driver.
@@ -765,7 +767,7 @@ config NVRAM
 
 config RTC
 	tristate "Enhanced Real Time Clock Support"
-	depends on !PPC && !PARISC && !IA64 && !M68K && (!SPARC || PCI) && !FRV && !ARM && !SUPERH
+	depends on !PPC && !PARISC && !IA64 && !M68K && (!SPARC || PCI) && !FRV && !ARM && !SUPERH && !S390
 	---help---
 	  If you say Y here and create a character special file /dev/rtc with
 	  major number 10 and minor number 135 using mknod ("man mknod"), you
@@ -813,7 +815,7 @@ config SGI_IP27_RTC
 
 config GEN_RTC
 	tristate "Generic /dev/rtc emulation"
-	depends on RTC!=y && !IA64 && !ARM && !M32R && !SPARC && !FRV
+	depends on RTC!=y && !IA64 && !ARM && !M32R && !SPARC && !FRV && !S390
 	---help---
 	  If you say Y here and create a character special file /dev/rtc with
 	  major number 10 and minor number 135 using mknod ("man mknod"), you
@@ -858,6 +860,7 @@ config COBALT_LCD
 
 config DTLK
 	tristate "Double Talk PC internal speech card support"
+	depends on ISA
 	help
 	  This driver is for the DoubleTalk PC, a speech synthesizer
 	  manufactured by RC Systems (<http://www.rcsys.com/>).  It is also
@@ -1043,7 +1046,7 @@ config HPET_MMAP
 
 config HANGCHECK_TIMER
 	tristate "Hangcheck timer"
-	depends on X86 || IA64 || PPC64
+	depends on X86 || IA64 || PPC64 || S390
 	help
 	  The hangcheck-timer module detects when the system has gone
 	  out to lunch past a certain margin.  It can reboot the system
@@ -1078,5 +1081,7 @@ config DEVPORT
 	depends on ISA || PCI
 	default y
 
+source "drivers/s390/char/Kconfig"
+
 endmenu
 
diff --git a/drivers/char/ipmi/Kconfig b/drivers/char/ipmi/Kconfig
index a6dcb29..b894f67 100644
--- a/drivers/char/ipmi/Kconfig
+++ b/drivers/char/ipmi/Kconfig
@@ -3,6 +3,8 @@
 #
 
 menu "IPMI"
+	depends on HAS_IOMEM
+
 config IPMI_HANDLER
        tristate 'IPMI top-level message handler'
        help
diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index 11089be..dc4e1ff 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -3,6 +3,7 @@
 #
 
 menu "TPM devices"
+	depends on HAS_IOMEM
 
 config TCG_TPM
 	tristate "TPM Hardware Support"
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index f4c6345..e678a33 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -56,4 +56,26 @@ config CRYPTO_DEV_GEODE
 	  To compile this driver as a module, choose M here: the module
 	  will be called geode-aes.
 
+config ZCRYPT
+	tristate "Support for PCI-attached cryptographic adapters"
+	depends on S390
+	select ZCRYPT_MONOLITHIC if ZCRYPT="y"
+	default "m"
+	help
+	  Select this option if you want to use a PCI-attached cryptographic
+	  adapter like:
+	  + PCI Cryptographic Accelerator (PCICA)
+	  + PCI Cryptographic Coprocessor (PCICC)
+	  + PCI-X Cryptographic Coprocessor (PCIXCC)
+	  + Crypto Express2 Coprocessor (CEX2C)
+	  + Crypto Express2 Accelerator (CEX2A)
+
+config ZCRYPT_MONOLITHIC
+	bool "Monolithic zcrypt module"
+	depends on ZCRYPT="m"
+	help
+	  Select this option if you want to have a single module z90crypt.ko
+	  that contains all parts of the crypto device driver (ap bus,
+	  request router and all the card drivers).
+
 endmenu
diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 30d021d..72be6c6 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -3,6 +3,7 @@
 #
 
 menu "DMA Engine support"
+	depends on !S390
 
 config DMA_ENGINE
 	bool "Support for DMA engines"
diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 4f08984..807c402 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -7,6 +7,7 @@
 #
 
 menu 'EDAC - error detection and reporting (RAS) (EXPERIMENTAL)'
+	depends on HAS_IOMEM
 
 config EDAC
 	tristate "EDAC core system error reporting (EXPERIMENTAL)"
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 3ba3a52..4d1cb5b 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -4,6 +4,7 @@
 
 menuconfig HWMON
 	tristate "Hardware Monitoring support"
+	depends on HAS_IOMEM
 	default y
 	help
 	  Hardware monitoring devices let you monitor the hardware health
diff --git a/drivers/i2c/Kconfig b/drivers/i2c/Kconfig
index 434a61b..9686734 100644
--- a/drivers/i2c/Kconfig
+++ b/drivers/i2c/Kconfig
@@ -4,6 +4,7 @@
 
 menuconfig I2C
 	tristate "I2C support"
+	depends on HAS_IOMEM
 	---help---
 	  I2C (pronounce: I-square-C) is a slow serial bus protocol used in
 	  many micro controller applications and developed by Philips.  SMBus,
diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 1d06b41..9040809 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -7,6 +7,7 @@
 if BLOCK
 
 menu "ATA/ATAPI/MFM/RLL support"
+	depends on HAS_IOMEM
 
 config IDE
 	tristate "ATA/ATAPI/MFM/RLL support"
diff --git a/drivers/ieee1394/Kconfig b/drivers/ieee1394/Kconfig
index 61d7809..f21426a 100644
--- a/drivers/ieee1394/Kconfig
+++ b/drivers/ieee1394/Kconfig
@@ -1,4 +1,5 @@
 menu "IEEE 1394 (FireWire) support"
+	depends on PCI || BROKEN
 
 config IEEE1394
 	tristate "IEEE 1394 (FireWire) support"
diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index 37deaae..994decc 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -1,4 +1,5 @@
 menu "InfiniBand support"
+	depends on HAS_IOMEM
 
 config INFINIBAND
 	depends on PCI || BROKEN
diff --git a/drivers/input/Kconfig b/drivers/input/Kconfig
index 0e9b695..f814fb3 100644
--- a/drivers/input/Kconfig
+++ b/drivers/input/Kconfig
@@ -3,6 +3,7 @@
 #
 
 menu "Input device support"
+	depends on !S390
 
 config INPUT
 	tristate "Generic input layer (needed for keyboard, mouse, ...)" if EMBEDDED
diff --git a/drivers/isdn/Kconfig b/drivers/isdn/Kconfig
index c90afee..d42fe89 100644
--- a/drivers/isdn/Kconfig
+++ b/drivers/isdn/Kconfig
@@ -3,6 +3,7 @@
 #
 
 menu "ISDN subsystem"
+	depends on !S390
 
 config ISDN
 	tristate "ISDN support"
diff --git a/drivers/kvm/Kconfig b/drivers/kvm/Kconfig
index 703cc88..e8e37d8 100644
--- a/drivers/kvm/Kconfig
+++ b/drivers/kvm/Kconfig
@@ -2,6 +2,7 @@
 # KVM configuration
 #
 menu "Virtualization"
+	depends on X86
 
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 80acd08..87d2046 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -1,5 +1,6 @@
 
 menu "LED devices"
+	depends on HAS_IOMEM
 
 config NEW_LEDS
 	bool "LED Support"
diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 91d2579..3a80e0c 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -3,6 +3,7 @@
 #
 
 menu "Multimedia devices"
+	depends on HAS_IOMEM
 
 config VIDEO_DEV
 	tristate "Video For Linux"
diff --git a/drivers/message/fusion/Kconfig b/drivers/message/fusion/Kconfig
index 71037f9..c88cc75 100644
--- a/drivers/message/fusion/Kconfig
+++ b/drivers/message/fusion/Kconfig
@@ -1,5 +1,6 @@
 
 menu "Fusion MPT device support"
+	depends on PCI
 
 config FUSION
 	bool
diff --git a/drivers/message/i2o/Kconfig b/drivers/message/i2o/Kconfig
index 6443392..f4ac21e 100644
--- a/drivers/message/i2o/Kconfig
+++ b/drivers/message/i2o/Kconfig
@@ -1,5 +1,6 @@
 
 menu "I2O device support"
+	depends on PCI
 
 config I2O
 	tristate "I2O support"
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index ab6e985..a20a51e 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -3,6 +3,7 @@
 #
 
 menu "Multifunction device drivers"
+	depends on HAS_IOMEM
 
 config MFD_SM501
 	tristate "Support for Silicon Motion SM501"
diff --git a/drivers/mmc/Kconfig b/drivers/mmc/Kconfig
index 45b7d53..c0b41e8 100644
--- a/drivers/mmc/Kconfig
+++ b/drivers/mmc/Kconfig
@@ -4,6 +4,7 @@
 
 menuconfig MMC
 	tristate "MMC/SD card support"
+	depends on HAS_IOMEM
 	help
 	  MMC is the "multi-media card" bus protocol.
 
diff --git a/drivers/mtd/Kconfig b/drivers/mtd/Kconfig
index c1b47db..fbec8cd 100644
--- a/drivers/mtd/Kconfig
+++ b/drivers/mtd/Kconfig
@@ -2,6 +2,7 @@
 
 menuconfig MTD
 	tristate "Memory Technology Device (MTD) support"
+	depends on HAS_IOMEM
 	help
 	  Memory Technology Devices are flash, RAM and similar chips, often
 	  used for solid state file systems on embedded devices. This option
diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index f994f12..c0d3101 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -3,6 +3,7 @@
 #
 
 menu "PHY device support"
+	depends on !S390
 
 config PHYLIB
 	tristate "PHY Device support and infrastructure"
diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index e273347..e3f5bb0 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -3,6 +3,7 @@
 #
 
 menu "Wireless LAN"
+	depends on !S390
 
 config WLAN_PRE80211
 	bool "Wireless LAN (pre-802.11)"
diff --git a/drivers/parport/Kconfig b/drivers/parport/Kconfig
index 36c6a1b..f46c69e 100644
--- a/drivers/parport/Kconfig
+++ b/drivers/parport/Kconfig
@@ -6,6 +6,7 @@
 #
 
 menu "Parallel port support"
+	depends on HAS_IOMEM
 
 config PARPORT
 	tristate "Parallel port support"
diff --git a/drivers/pnp/Kconfig b/drivers/pnp/Kconfig
index c514320..1959cef 100644
--- a/drivers/pnp/Kconfig
+++ b/drivers/pnp/Kconfig
@@ -3,6 +3,7 @@
 #
 
 menu "Plug and Play support"
+	depends on HAS_IOMEM
 
 config PNP
 	bool "Plug and Play support"
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 76422ed..1759baa 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -3,6 +3,7 @@
 #
 
 menu "Real Time Clock"
+	depends on !S390
 
 config RTC_LIB
 	tristate
diff --git a/drivers/s390/Kconfig b/drivers/s390/Kconfig
deleted file mode 100644
index 165af39..0000000
--- a/drivers/s390/Kconfig
+++ /dev/null
@@ -1,239 +0,0 @@
-config CCW
-	bool
-	default y
-
-source "drivers/block/Kconfig"
-
-source "drivers/md/Kconfig"
-
-
-menu "Character device drivers"
-
-config UNIX98_PTYS
-	bool "Unix98 PTY support"
-	---help---
-	  A pseudo terminal (PTY) is a software device consisting of two
-	  halves: a master and a slave. The slave device behaves identical to
-	  a physical terminal; the master device is used by a process to
-	  read data from and write data to the slave, thereby emulating a
-	  terminal. Typical programs for the master side are telnet servers
-	  and xterms.
-
-	  Linux has traditionally used the BSD-like names /dev/ptyxx for
-	  masters and /dev/ttyxx for slaves of pseudo terminals. This scheme
-	  has a number of problems. The GNU C library glibc 2.1 and later,
-	  however, supports the Unix98 naming standard: in order to acquire a
-	  pseudo terminal, a process opens /dev/ptmx; the number of the pseudo
-	  terminal is then made available to the process and the pseudo
-	  terminal slave can be accessed as /dev/pts/<number>. What was
-	  traditionally /dev/ttyp2 will then be /dev/pts/2, for example.
-
-	  The entries in /dev/pts/ are created on the fly by a virtual
-	  file system; therefore, if you say Y here you should say Y to
-	  "/dev/pts file system for Unix98 PTYs" as well.
-
-	  If you want to say Y here, you need to have the C library glibc 2.1
-	  or later (equal to libc-6.1, check with "ls -l /lib/libc.so.*").
-	  Read the instructions in <file:Documentation/Changes> pertaining to
-	  pseudo terminals. It's safe to say N.
-
-config UNIX98_PTY_COUNT
-	int "Maximum number of Unix98 PTYs in use (0-2048)"
-	depends on UNIX98_PTYS
-	default "256"
-	help
-	  The maximum number of Unix98 PTYs that can be used at any one time.
-	  The default is 256, and should be enough for desktop systems. Server
-	  machines which support incoming telnet/rlogin/ssh connections and/or
-	  serve several X terminals may want to increase this: every incoming
-	  connection and every xterm uses up one PTY.
-
-	  When not in use, each additional set of 256 PTYs occupy
-	  approximately 8 KB of kernel memory on 32-bit architectures.
-
-config HANGCHECK_TIMER
-	tristate "Hangcheck timer"
-	help
-	  The hangcheck-timer module detects when the system has gone
-	  out to lunch past a certain margin.  It can reboot the system
-	  or merely print a warning.
-
-source "drivers/char/watchdog/Kconfig"
-
-comment "S/390 character device drivers"
-
-config TN3270
-	tristate "Support for locally attached 3270 terminals"
-	help
-	  Include support for IBM 3270 terminals.
-
-config TN3270_TTY
-	tristate "Support for tty input/output on 3270 terminals"
-	depends on TN3270
-	help
-	  Include support for using an IBM 3270 terminal as a Linux tty.
-
-config TN3270_FS
-	tristate "Support for fullscreen applications on 3270 terminals"
-	depends on TN3270
-	help
-	  Include support for fullscreen applications on an IBM 3270 terminal.
-
-config TN3270_CONSOLE
-	bool "Support for console on 3270 terminal"
-	depends on TN3270=y && TN3270_TTY=y
-	help
-	  Include support for using an IBM 3270 terminal as a Linux system
-	  console.  Available only if 3270 support is compiled in statically.
-
-config TN3215
-	bool "Support for 3215 line mode terminal"
-	help
-	  Include support for IBM 3215 line-mode terminals.
-
-config TN3215_CONSOLE
-	bool "Support for console on 3215 line mode terminal"
-	depends on TN3215
-	help
-	  Include support for using an IBM 3215 line-mode terminal as a
-	  Linux system console.
-
-config CCW_CONSOLE
- 	bool
- 	depends on TN3215_CONSOLE || TN3270_CONSOLE
- 	default y
- 
-config SCLP_TTY
-	bool "Support for SCLP line mode terminal"
-	help
-	  Include support for IBM SCLP line-mode terminals.
-
-config SCLP_CONSOLE
-	bool "Support for console on SCLP line mode terminal"
-	depends on SCLP_TTY
-	help
-	  Include support for using an IBM HWC line-mode terminal as the Linux
-	  system console.
-
-config SCLP_VT220_TTY
-	bool "Support for SCLP VT220-compatible terminal"
-	help
-	  Include support for an IBM SCLP VT220-compatible terminal.
-
-config SCLP_VT220_CONSOLE
-	bool "Support for console on SCLP VT220-compatible terminal"
-	depends on SCLP_VT220_TTY
-	help
-	  Include support for using an IBM SCLP VT220-compatible terminal as a
-	  Linux system console.
-
-config SCLP_CPI
-	tristate "Control-Program Identification"
-	help
-	  This option enables the hardware console interface for system
-	  identification. This is commonly used for workload management and
-	  gives you a nice name for the system on the service element.
-	  Please select this option as a module since built-in operation is
-	  completely untested.
-	  You should only select this option if you know what you are doing,
-	  need this feature and intend to run your kernel in LPAR.
-
-config S390_TAPE
-	tristate "S/390 tape device support"
-	help
-	  Select this option if you want to access channel-attached tape
-	  devices on IBM S/390 or zSeries.
-	  If you select this option you will also want to select at
-	  least one of the tape interface options and one of the tape
-	  hardware options in order to access a tape device.
-	  This option is also available as a module. The module will be
-	  called tape390 and include all selected interfaces and
-	  hardware drivers.
-
-comment "S/390 tape interface support"
-	depends on S390_TAPE
-
-config S390_TAPE_BLOCK
-	bool "Support for tape block devices"
-	depends on S390_TAPE
-	help
-	  Select this option if you want to access your channel-attached tape
-	  devices using the block device interface.  This interface is similar
-	  to CD-ROM devices on other platforms.  The tapes can only be
-	  accessed read-only when using this interface.  Have a look at
-	  <file:Documentation/s390/TAPE> for further information about creating
-	  volumes for and using this interface.  It is safe to say "Y" here.
-
-comment "S/390 tape hardware support"
-	depends on S390_TAPE
-
-config S390_TAPE_34XX
-	tristate "Support for 3480/3490 tape hardware"
-	depends on S390_TAPE
-	help
-	  Select this option if you want to access IBM 3480/3490 magnetic
-	  tape subsystems and 100% compatibles.
-	  It is safe to say "Y" here.
-
-config S390_TAPE_3590
-	tristate "Support for 3590 tape hardware"
-	depends on S390_TAPE
-	help
-	  Select this option if you want to access IBM 3590 magnetic
-	  tape subsystems and 100% compatibles.
-	  It is safe to say "Y" here.
-
-config VMLOGRDR
-	tristate "Support for the z/VM recording system services (VM only)"
-	depends on IUCV
-	help
-	  Select this option if you want to be able to receive records collected
-	  by the z/VM recording system services, eg. from *LOGREC, *ACCOUNT or
-	  *SYMPTOM.
-	  This driver depends on the IUCV support driver.
-
-config VMCP
-	tristate "Support for the z/VM CP interface (VM only)"
-	help
-	  Select this option if you want to be able to interact with the control
-	  program on z/VM
-
-
-config MONREADER
-	tristate "API for reading z/VM monitor service records"
-	depends on IUCV
-	help
-	  Character device driver for reading z/VM monitor service records
-
-config MONWRITER
-	tristate "API for writing z/VM monitor service records"
-	default "m"
-	help
-	  Character device driver for writing z/VM monitor service records
-
-endmenu
-
-menu "Cryptographic devices"
-
-config ZCRYPT
-	tristate "Support for PCI-attached cryptographic adapters"
-	select ZCRYPT_MONOLITHIC if ZCRYPT="y"
-	default "m"
-	help
-	  Select this option if you want to use a PCI-attached cryptographic
-	  adapter like:
-	  + PCI Cryptographic Accelerator (PCICA)
-	  + PCI Cryptographic Coprocessor (PCICC)
-	  + PCI-X Cryptographic Coprocessor (PCIXCC)
-	  + Crypto Express2 Coprocessor (CEX2C)
-	  + Crypto Express2 Accelerator (CEX2A)
-
-config ZCRYPT_MONOLITHIC
-	bool "Monolithic zcrypt module"
-	depends on ZCRYPT="m"
-	help
-	  Select this option if you want to have a single module z90crypt.ko
-	  that contains all parts of the crypto device driver (ap bus,
-	  request router and all the card drivers).
-
-endmenu
diff --git a/drivers/s390/block/Kconfig b/drivers/s390/block/Kconfig
index b250c53..e879b21 100644
--- a/drivers/s390/block/Kconfig
+++ b/drivers/s390/block/Kconfig
@@ -1,11 +1,9 @@
-if S390 && BLOCK
-
 comment "S/390 block device drivers"
-	depends on S390
+	depends on S390 && BLOCK
 
 config BLK_DEV_XPRAM
 	tristate "XPRAM disk support"
-	depends on S390
+	depends on S390 && BLOCK
 	help
 	  Select this option if you want to use your expanded storage on S/390
 	  or zSeries as a disk.  This is useful as a _fast_ swap device if you
@@ -15,12 +13,13 @@ config BLK_DEV_XPRAM
 
 config DCSSBLK
 	tristate "DCSSBLK support"
+	depends on S390 && BLOCK
 	help
 	  Support for dcss block device
 
 config DASD
 	tristate "Support for DASD devices"
-	depends on CCW
+	depends on CCW && BLOCK
 	help
 	  Enable this option if you want to access DASDs directly utilizing
 	  S/390s channel subsystem commands. This is necessary for running
@@ -62,5 +61,3 @@ config DASD_EER
 	  This driver provides a character device interface to the
 	  DASD extended error reporting. This is only needed if you want to
 	  use applications written for the EER facility.
-
-endif
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index 9775210..bfeca57 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -2174,9 +2174,10 @@ dasd_generic_notify(struct ccw_device *cdev, int event)
 	return ret;
 }
 
-struct dasd_ccw_req * dasd_generic_build_rdc(struct dasd_device *device,
-					     void *rdc_buffer,
-					     int rdc_buffer_size, char *magic)
+static struct dasd_ccw_req *dasd_generic_build_rdc(struct dasd_device *device,
+						   void *rdc_buffer,
+						   int rdc_buffer_size,
+						   char *magic)
 {
 	struct dasd_ccw_req *cqr;
 	struct ccw1 *ccw;
@@ -2219,6 +2220,7 @@ int dasd_generic_read_dev_chars(struct dasd_device *device, char *magic,
 	dasd_sfree_request(cqr, cqr->device);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(dasd_generic_read_dev_chars);
 
 static int __init
 dasd_init(void)
diff --git a/drivers/s390/block/dasd_diag.c b/drivers/s390/block/dasd_diag.c
index e810e4a..eccac1c 100644
--- a/drivers/s390/block/dasd_diag.c
+++ b/drivers/s390/block/dasd_diag.c
@@ -50,6 +50,7 @@ struct dasd_diag_private {
 	struct dasd_diag_rw_io iob;
 	struct dasd_diag_init_io iib;
 	blocknum_t pt_block;
+	struct ccw_dev_id dev_id;
 };
 
 struct dasd_diag_req {
@@ -102,7 +103,7 @@ mdsk_init_io(struct dasd_device *device, unsigned int blocksize,
 	iib = &private->iib;
 	memset(iib, 0, sizeof (struct dasd_diag_init_io));
 
-	iib->dev_nr = _ccw_device_get_device_number(device->cdev);
+	iib->dev_nr = private->dev_id.devno;
 	iib->block_size = blocksize;
 	iib->offset = offset;
 	iib->flaga = DASD_DIAG_FLAGA_DEFAULT;
@@ -127,7 +128,7 @@ mdsk_term_io(struct dasd_device * device)
 	private = (struct dasd_diag_private *) device->private;
 	iib = &private->iib;
 	memset(iib, 0, sizeof (struct dasd_diag_init_io));
-	iib->dev_nr = _ccw_device_get_device_number(device->cdev);
+	iib->dev_nr = private->dev_id.devno;
 	rc = dia250(iib, TERM_BIO);
 	return rc;
 }
@@ -166,7 +167,7 @@ dasd_start_diag(struct dasd_ccw_req * cqr)
 	private = (struct dasd_diag_private *) device->private;
 	dreq = (struct dasd_diag_req *) cqr->data;
 
-	private->iob.dev_nr = _ccw_device_get_device_number(device->cdev);
+	private->iob.dev_nr = private->dev_id.devno;
 	private->iob.key = 0;
 	private->iob.flags = DASD_DIAG_RWFLAG_ASYNC;
 	private->iob.block_count = dreq->block_count;
@@ -323,11 +324,12 @@ dasd_diag_check_device(struct dasd_device *device)
 				"memory allocation failed for private data");
 			return -ENOMEM;
 		}
+		ccw_device_get_id(device->cdev, &private->dev_id);
 		device->private = (void *) private;
 	}
 	/* Read Device Characteristics */
 	rdc_data = (void *) &(private->rdc_data);
-	rdc_data->dev_nr = _ccw_device_get_device_number(device->cdev);
+	rdc_data->dev_nr = private->dev_id.devno;
 	rdc_data->rdc_len = sizeof (struct dasd_diag_characteristics);
 
 	rc = diag210((struct diag210 *) rdc_data);
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index c9583fb..418b4e6 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -450,9 +450,9 @@ dasd_eckd_generate_uid(struct dasd_device *device, struct dasd_uid *uid)
 	return 0;
 }
 
-struct dasd_ccw_req * dasd_eckd_build_rcd_lpm(struct dasd_device *device,
-					      void *rcd_buffer,
-					      struct ciw *ciw, __u8 lpm)
+static struct dasd_ccw_req *dasd_eckd_build_rcd_lpm(struct dasd_device *device,
+						    void *rcd_buffer,
+						    struct ciw *ciw, __u8 lpm)
 {
 	struct dasd_ccw_req *cqr;
 	struct ccw1 *ccw;
diff --git a/drivers/s390/block/dasd_ioctl.c b/drivers/s390/block/dasd_ioctl.c
index 758cfb5..672eb0a 100644
--- a/drivers/s390/block/dasd_ioctl.c
+++ b/drivers/s390/block/dasd_ioctl.c
@@ -255,6 +255,7 @@ dasd_ioctl_information(struct dasd_device *device,
 	unsigned long flags;
 	int rc;
 	struct ccw_device *cdev;
+	struct ccw_dev_id dev_id;
 
 	if (!device->discipline->fill_info)
 		return -EINVAL;
@@ -270,8 +271,9 @@ dasd_ioctl_information(struct dasd_device *device,
 	}
 
 	cdev = device->cdev;
+	ccw_device_get_id(cdev, &dev_id);
 
-	dasd_info->devno = _ccw_device_get_device_number(device->cdev);
+	dasd_info->devno = dev_id.devno;
 	dasd_info->schid = _ccw_device_get_subchannel_number(device->cdev);
 	dasd_info->cu_type = cdev->id.cu_type;
 	dasd_info->cu_model = cdev->id.cu_model;
diff --git a/drivers/s390/char/Kconfig b/drivers/s390/char/Kconfig
new file mode 100644
index 0000000..66102a1
--- /dev/null
+++ b/drivers/s390/char/Kconfig
@@ -0,0 +1,166 @@
+comment "S/390 character device drivers"
+	depends on S390
+
+config TN3270
+	tristate "Support for locally attached 3270 terminals"
+	depends on CCW
+	help
+	  Include support for IBM 3270 terminals.
+
+config TN3270_TTY
+	tristate "Support for tty input/output on 3270 terminals"
+	depends on TN3270
+	help
+	  Include support for using an IBM 3270 terminal as a Linux tty.
+
+config TN3270_FS
+	tristate "Support for fullscreen applications on 3270 terminals"
+	depends on TN3270
+	help
+	  Include support for fullscreen applications on an IBM 3270 terminal.
+
+config TN3270_CONSOLE
+	bool "Support for console on 3270 terminal"
+	depends on TN3270=y && TN3270_TTY=y
+	help
+	  Include support for using an IBM 3270 terminal as a Linux system
+	  console.  Available only if 3270 support is compiled in statically.
+
+config TN3215
+	bool "Support for 3215 line mode terminal"
+	depends on CCW
+	help
+	  Include support for IBM 3215 line-mode terminals.
+
+config TN3215_CONSOLE
+	bool "Support for console on 3215 line mode terminal"
+	depends on TN3215
+	help
+	  Include support for using an IBM 3215 line-mode terminal as a
+	  Linux system console.
+
+config CCW_CONSOLE
+	bool
+	depends on TN3215_CONSOLE || TN3270_CONSOLE
+	default y
+
+config SCLP
+	bool "Support for SCLP"
+	depends on S390
+	help
+	  Include support for the SCLP interface to the service element.
+
+config SCLP_TTY
+	bool "Support for SCLP line mode terminal"
+	depends on SCLP
+	help
+	  Include support for IBM SCLP line-mode terminals.
+
+config SCLP_CONSOLE
+	bool "Support for console on SCLP line mode terminal"
+	depends on SCLP_TTY
+	help
+	  Include support for using an IBM HWC line-mode terminal as the Linux
+	  system console.
+
+config SCLP_VT220_TTY
+	bool "Support for SCLP VT220-compatible terminal"
+	depends on SCLP
+	help
+	  Include support for an IBM SCLP VT220-compatible terminal.
+
+config SCLP_VT220_CONSOLE
+	bool "Support for console on SCLP VT220-compatible terminal"
+	depends on SCLP_VT220_TTY
+	help
+	  Include support for using an IBM SCLP VT220-compatible terminal as a
+	  Linux system console.
+
+config SCLP_CPI
+	tristate "Control-Program Identification"
+	depends on SCLP
+	help
+	  This option enables the hardware console interface for system
+	  identification. This is commonly used for workload management and
+	  gives you a nice name for the system on the service element.
+	  Please select this option as a module since built-in operation is
+	  completely untested.
+	  You should only select this option if you know what you are doing,
+	  need this feature and intend to run your kernel in LPAR.
+
+config S390_TAPE
+	tristate "S/390 tape device support"
+	depends on CCW
+	help
+	  Select this option if you want to access channel-attached tape
+	  devices on IBM S/390 or zSeries.
+	  If you select this option you will also want to select at
+	  least one of the tape interface options and one of the tape
+	  hardware options in order to access a tape device.
+	  This option is also available as a module. The module will be
+	  called tape390 and include all selected interfaces and
+	  hardware drivers.
+
+comment "S/390 tape interface support"
+	depends on S390_TAPE
+
+config S390_TAPE_BLOCK
+	bool "Support for tape block devices"
+	depends on S390_TAPE
+	help
+	  Select this option if you want to access your channel-attached tape
+	  devices using the block device interface.  This interface is similar
+	  to CD-ROM devices on other platforms.  The tapes can only be
+	  accessed read-only when using this interface.  Have a look at
+	  <file:Documentation/s390/TAPE> for further information about creating
+	  volumes for and using this interface.  It is safe to say "Y" here.
+
+comment "S/390 tape hardware support"
+	depends on S390_TAPE
+
+config S390_TAPE_34XX
+	tristate "Support for 3480/3490 tape hardware"
+	depends on S390_TAPE
+	help
+	  Select this option if you want to access IBM 3480/3490 magnetic
+	  tape subsystems and 100% compatibles.
+	  It is safe to say "Y" here.
+
+config S390_TAPE_3590
+	tristate "Support for 3590 tape hardware"
+	depends on S390_TAPE
+	help
+	  Select this option if you want to access IBM 3590 magnetic
+	  tape subsystems and 100% compatibles.
+	  It is safe to say "Y" here.
+
+config VMLOGRDR
+	tristate "Support for the z/VM recording system services (VM only)"
+	depends on IUCV
+	help
+	  Select this option if you want to be able to receive records collected
+	  by the z/VM recording system services, eg. from *LOGREC, *ACCOUNT or
+	  *SYMPTOM.
+	  This driver depends on the IUCV support driver.
+
+config VMCP
+	tristate "Support for the z/VM CP interface (VM only)"
+	depends on S390
+	help
+	  Select this option if you want to be able to interact with the control
+	  program on z/VM
+
+
+config MONREADER
+	tristate "API for reading z/VM monitor service records"
+	depends on IUCV
+	help
+	  Character device driver for reading z/VM monitor service records
+
+config MONWRITER
+	tristate "API for writing z/VM monitor service records"
+	depends on S390
+	default "m"
+	help
+	  Character device driver for writing z/VM monitor service records
+
diff --git a/drivers/s390/char/monreader.c b/drivers/s390/char/monreader.c
index 8df7b13..67009bf 100644
--- a/drivers/s390/char/monreader.c
+++ b/drivers/s390/char/monreader.c
@@ -97,7 +97,7 @@ static u8 user_data_sever[16] = {
  * Create the 8 bytes EBCDIC DCSS segment name from
  * an ASCII name, incl. padding
  */
-static inline void dcss_mkname(char *ascii_name, char *ebcdic_name)
+static void dcss_mkname(char *ascii_name, char *ebcdic_name)
 {
 	int i;
 
@@ -191,7 +191,7 @@ static inline u32 mon_rec_end(struct mon_msg *monmsg)
 	return *((u32 *) (mon_mca_start(monmsg) + monmsg->mca_offset + 8));
 }
 
-static inline int mon_check_mca(struct mon_msg *monmsg)
+static int mon_check_mca(struct mon_msg *monmsg)
 {
 	if ((mon_rec_end(monmsg) <= mon_rec_start(monmsg)) ||
 	    (mon_rec_start(monmsg) < mon_dcss_start) ||
@@ -209,8 +209,8 @@ static inline int mon_check_mca(struct mon_msg *monmsg)
 	return 0;
 }
 
-static inline int mon_send_reply(struct mon_msg *monmsg,
-				 struct mon_private *monpriv)
+static int mon_send_reply(struct mon_msg *monmsg,
+			  struct mon_private *monpriv)
 {
 	int rc;
 
@@ -236,7 +236,7 @@ static inline int mon_send_reply(struct mon_msg *monmsg,
 	return 0;
 }
 
-static inline void mon_free_mem(struct mon_private *monpriv)
+static void mon_free_mem(struct mon_private *monpriv)
 {
 	int i;
 
@@ -246,7 +246,7 @@ static inline void mon_free_mem(struct mon_private *monpriv)
 	kfree(monpriv);
 }
 
-static inline struct mon_private *mon_alloc_mem(void)
+static struct mon_private *mon_alloc_mem(void)
 {
 	int i;
 	struct mon_private *monpriv;
@@ -307,7 +307,7 @@ static inline void mon_next_mca(struct mon_msg *monmsg)
 	monmsg->pos = 0;
 }
 
-static inline struct mon_msg *mon_next_message(struct mon_private *monpriv)
+static struct mon_msg *mon_next_message(struct mon_private *monpriv)
 {
 	struct mon_msg *monmsg;
 
diff --git a/drivers/s390/char/raw3270.c b/drivers/s390/char/raw3270.c
index 8facd14..f6ef90e 100644
--- a/drivers/s390/char/raw3270.c
+++ b/drivers/s390/char/raw3270.c
@@ -589,9 +589,10 @@ static int
 __raw3270_size_device_vm(struct raw3270 *rp)
 {
 	int rc, model;
+	struct ccw_dev_id dev_id;
 
-	raw3270_init_diag210.vrdcdvno = 
-		_ccw_device_get_device_number(rp->cdev);
+	ccw_device_get_id(rp->cdev, &dev_id);
+	raw3270_init_diag210.vrdcdvno = dev_id.devno;
 	raw3270_init_diag210.vrdclen = sizeof(struct diag210);
 	rc = diag210(&raw3270_init_diag210);
 	if (rc)
diff --git a/drivers/s390/char/sclp.h b/drivers/s390/char/sclp.h
index 87ac4a3..dbb99d1 100644
--- a/drivers/s390/char/sclp.h
+++ b/drivers/s390/char/sclp.h
@@ -132,6 +132,9 @@ int sclp_deactivate(void);
 int sclp_reactivate(void);
 int sclp_service_call(sclp_cmdw_t command, void *sccb);
 
+int sclp_sdias_init(void);
+void sclp_sdias_exit(void);
+
 /* useful inlines */
 
 /* VM uses EBCDIC 037, LPAR+native(SE+HMC) use EBCDIC 500 */
diff --git a/drivers/s390/char/sclp_sdias.c b/drivers/s390/char/sclp_sdias.c
index 52283da..1c06497 100644
--- a/drivers/s390/char/sclp_sdias.c
+++ b/drivers/s390/char/sclp_sdias.c
@@ -66,9 +66,9 @@ static DEFINE_MUTEX(sdias_mutex);
 
 static void sdias_callback(struct sclp_req *request, void *data)
 {
-	struct sdias_sccb *sccb;
+	struct sdias_sccb *cbsccb;
 
-	sccb = (struct sdias_sccb *) request->sccb;
+	cbsccb = (struct sdias_sccb *) request->sccb;
 	sclp_req_done = 1;
 	wake_up(&sdias_wq); /* Inform caller, that request is complete */
 	TRACE("callback done\n");
@@ -229,7 +229,7 @@ out:
 	return rc;
 }
 
-int __init sdias_init(void)
+int __init sclp_sdias_init(void)
 {
 	int rc;
 
@@ -248,7 +248,7 @@ int __init sdias_init(void)
 	return 0;
 }
 
-void __exit sdias_exit(void)
+void __exit sclp_sdias_exit(void)
 {
 	debug_unregister(sdias_dbf);
 	sclp_unregister(&sclp_sdias_register);
diff --git a/drivers/s390/char/zcore.c b/drivers/s390/char/zcore.c
index 89d4393..66eb068 100644
--- a/drivers/s390/char/zcore.c
+++ b/drivers/s390/char/zcore.c
@@ -21,6 +21,7 @@
 #include <asm/debug.h>
 #include <asm/processor.h>
 #include <asm/irqflags.h>
+#include "sclp.h"
 
 #define TRACE(x...) debug_sprintf_event(zcore_dbf, 1, x)
 #define MSG(x...) printk( KERN_ALERT x )
@@ -564,8 +565,6 @@ static void __init zcore_header_init(int arch, struct zcore_header *hdr)
 	get_cpu_id(&hdr->cpu_id);
 }
 
-extern int sdias_init(void);
-
 static int __init zcore_init(void)
 {
 	unsigned char arch;
@@ -582,7 +581,7 @@ static int __init zcore_init(void)
 	TRACE("wwpn:   %llx\n", (unsigned long long) ipl_info.data.fcp.wwpn);
 	TRACE("lun:    %llx\n", (unsigned long long) ipl_info.data.fcp.lun);
 
-	rc = sdias_init();
+	rc = sclp_sdias_init();
 	if (rc)
 		goto fail;
 
@@ -634,12 +633,10 @@ fail:
 	return rc;
 }
 
-extern void sdias_exit(void);
-
 static void __exit zcore_exit(void)
 {
 	debug_unregister(zcore_dbf);
-	sdias_exit();
+	sclp_sdias_exit();
 	diag308(DIAG308_REL_HSA, NULL);
 }
 
diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index 27c6d9e..dfca0ef 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -191,8 +191,7 @@ static int css_register_subchannel(struct subchannel *sch)
 	return ret;
 }
 
-int
-css_probe_device(struct subchannel_id schid)
+static int css_probe_device(struct subchannel_id schid)
 {
 	int ret;
 	struct subchannel *sch;
diff --git a/drivers/s390/cio/css.h b/drivers/s390/cio/css.h
index 71fcfdc..ed79775 100644
--- a/drivers/s390/cio/css.h
+++ b/drivers/s390/cio/css.h
@@ -138,9 +138,7 @@ struct css_driver {
  * all css_drivers have the css_bus_type
  */
 extern struct bus_type css_bus_type;
-extern struct css_driver io_subchannel_driver;
 
-extern int css_probe_device(struct subchannel_id);
 extern int css_sch_device_register(struct subchannel *);
 extern void css_sch_device_unregister(struct subchannel *);
 extern struct subchannel * get_subchannel_by_schid(struct subchannel_id);
diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index a23ff58..a8b373f 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -129,7 +129,7 @@ static void io_subchannel_verify(struct device *);
 static void io_subchannel_ioterm(struct device *);
 static void io_subchannel_shutdown(struct subchannel *);
 
-struct css_driver io_subchannel_driver = {
+static struct css_driver io_subchannel_driver = {
 	.subchannel_type = SUBCHANNEL_TYPE_IO,
 	.drv = {
 		.name = "io_subchannel",
@@ -546,7 +546,7 @@ static struct attribute_group ccwdev_attr_group = {
 	.attrs = ccwdev_attrs,
 };
 
-struct attribute_group *ccwdev_attr_groups[] = {
+static struct attribute_group *ccwdev_attr_groups[] = {
 	&ccwdev_attr_group,
 	NULL,
 };
diff --git a/drivers/s390/cio/device_ops.c b/drivers/s390/cio/device_ops.c
index 16f59fc..a5d263f 100644
--- a/drivers/s390/cio/device_ops.c
+++ b/drivers/s390/cio/device_ops.c
@@ -616,6 +616,17 @@ ccw_device_get_chp_desc(struct ccw_device *cdev, int chp_no)
 	return chp_get_chp_desc(chpid);
 }
 
+/**
+ * ccw_device_get_id - obtain a ccw device id
+ * @cdev: device to obtain the id for
+ * @dev_id: where to fill in the values
+ */
+void ccw_device_get_id(struct ccw_device *cdev, struct ccw_dev_id *dev_id)
+{
+	*dev_id = cdev->private->dev_id;
+}
+EXPORT_SYMBOL(ccw_device_get_id);
+
 // FIXME: these have to go:
 
 int
diff --git a/drivers/s390/cio/qdio.c b/drivers/s390/cio/qdio.c
index f770018..e70aeb7 100644
--- a/drivers/s390/cio/qdio.c
+++ b/drivers/s390/cio/qdio.c
@@ -1983,6 +1983,7 @@ qdio_handle_pci(struct qdio_irq *irq_ptr)
 		if (q->is_input_q&QDIO_FLAG_NO_INPUT_INTERRUPT_CONTEXT)
 			qdio_mark_q(q);
 		else {
+			qdio_perf_stat_dec(&perf_stats.tl_runs);
 			__qdio_inbound_processing(q);
 		}
 	}
diff --git a/drivers/s390/net/Kconfig b/drivers/s390/net/Kconfig
index f98fa46..eada69d 100644
--- a/drivers/s390/net/Kconfig
+++ b/drivers/s390/net/Kconfig
@@ -3,7 +3,7 @@ menu "S/390 network device drivers"
 
 config LCS
 	tristate "Lan Channel Station Interface"
-	depends on NETDEVICES && (NET_ETHERNET || TR || FDDI)
+	depends on CCW && NETDEVICES && (NET_ETHERNET || TR || FDDI)
 	help
 	   Select this option if you want to use LCS networking  on IBM S/390
   	   or zSeries. This device driver supports Token Ring (IEEE 802.5),
@@ -13,7 +13,7 @@ config LCS
 
 config CTC
 	tristate "CTC device support"
-	depends on NETDEVICES
+	depends on CCW && NETDEVICES
 	help
 	  Select this option if you want to use channel-to-channel networking
 	  on IBM S/390 or zSeries. This device driver supports real CTC
@@ -42,7 +42,7 @@ config SMSGIUCV
 
 config CLAW
 	tristate "CLAW device support"
-	depends on NETDEVICES
+	depends on CCW && NETDEVICES
 	help
 	  This driver supports channel attached CLAW devices.
 	  CLAW is Common Link Access for Workstation.  Common devices
@@ -52,7 +52,7 @@ config CLAW
 
 config QETH
 	tristate "Gigabit Ethernet device support"
-	depends on NETDEVICES && IP_MULTICAST && QDIO
+	depends on CCW && NETDEVICES && IP_MULTICAST && QDIO
 	help
 	  This driver supports the IBM S/390 and zSeries OSA Express adapters
 	  in QDIO mode (all media types), HiperSockets interfaces and VM GuestLAN
diff --git a/drivers/s390/net/qeth_mpc.c b/drivers/s390/net/qeth_mpc.c
index f54fdfd..f29a4bc 100644
--- a/drivers/s390/net/qeth_mpc.c
+++ b/drivers/s390/net/qeth_mpc.c
@@ -162,7 +162,7 @@ struct ipa_rc_msg {
 	char *msg;
 };
 
-struct ipa_rc_msg qeth_ipa_rc_msg[] = {
+static struct ipa_rc_msg qeth_ipa_rc_msg[] = {
 	{IPA_RC_SUCCESS,		"success"},
 	{IPA_RC_NOTSUPP,		"Command not supported"},
 	{IPA_RC_IP_TABLE_FULL,		"Add Addr IP Table Full - ipv6"},
@@ -226,7 +226,7 @@ struct ipa_cmd_names {
 	char *name;
 };
 
-struct ipa_cmd_names qeth_ipa_cmd_names[] = {
+static struct ipa_cmd_names qeth_ipa_cmd_names[] = {
 	{IPA_CMD_STARTLAN,	"startlan"},
 	{IPA_CMD_STOPLAN,	"stoplan"},
 	{IPA_CMD_SETVMAC,	"setvmac"},
diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
index 324899c..ddff40c 100644
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -607,8 +607,7 @@ zfcp_sg_list_free(struct zfcp_sg_list *sg_list)
  * @sg_count: elements in array
  * Return: size of entire scatter-gather list
  */
-size_t
-zfcp_sg_size(struct scatterlist *sg, unsigned int sg_count)
+static size_t zfcp_sg_size(struct scatterlist *sg, unsigned int sg_count)
 {
 	unsigned int i;
 	struct scatterlist *p;
@@ -975,8 +974,7 @@ zfcp_free_low_mem_buffers(struct zfcp_adapter *adapter)
 		mempool_destroy(adapter->pool.data_gid_pn);
 }
 
-void
-zfcp_dummy_release(struct device *dev)
+static void zfcp_dummy_release(struct device *dev)
 {
 	return;
 }
@@ -1336,7 +1334,7 @@ zfcp_nameserver_enqueue(struct zfcp_adapter *adapter)
 
 #define ZFCP_LOG_AREA                   ZFCP_LOG_AREA_FC
 
-void
+static void
 zfcp_fsf_incoming_els_rscn(struct zfcp_adapter *adapter,
 			   struct fsf_status_read_buffer *status_buffer)
 {
diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
index d8191d1..5f32124 100644
--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -478,7 +478,7 @@ static struct debug_view zfcp_hba_dbf_view = {
 	NULL
 };
 
-void
+static void
 _zfcp_san_dbf_event_common_ct(const char *tag, struct zfcp_fsf_req *fsf_req,
 			      u32 s_id, u32 d_id, void *buffer, int buflen)
 {
diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index e8efe93..a6f5bfb 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -5,6 +5,7 @@
 #
 
 menu "Serial drivers"
+	depends on HAS_IOMEM
 
 #
 # The new 8250/16550 serial drivers
diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 07c587e..7c9d37f 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -6,6 +6,7 @@
 # fully appropriate there, so it'd need some thought to do well.
 #
 menu "SPI support"
+	depends on HAS_IOMEM
 
 config SPI
 	bool "SPI support"
diff --git a/drivers/telephony/Kconfig b/drivers/telephony/Kconfig
index 7625b18..dd1d6a5 100644
--- a/drivers/telephony/Kconfig
+++ b/drivers/telephony/Kconfig
@@ -3,6 +3,7 @@
 #
 
 menu "Telephony Support"
+	depends on HAS_IOMEM
 
 config PHONE
 	tristate "Linux telephony support"
diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
index 278a22c..15499b7 100644
--- a/drivers/usb/Kconfig
+++ b/drivers/usb/Kconfig
@@ -3,6 +3,7 @@
 #
 
 menu "USB support"
+	depends on HAS_IOMEM
 
 # Host-side USB depends on having a host controller
 # NOTE:  dummy_hcd is always an option, but it's ignored here ...
diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 9a256d2..f544388 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -3,6 +3,7 @@
 #
 
 menu "Graphics support"
+	depends on HAS_IOMEM
 
 source "drivers/video/backlight/Kconfig"
 source "drivers/video/display/Kconfig"
diff --git a/drivers/w1/Kconfig b/drivers/w1/Kconfig
index c287a9a..ca75b3a 100644
--- a/drivers/w1/Kconfig
+++ b/drivers/w1/Kconfig
@@ -1,4 +1,5 @@
 menu "Dallas's 1-wire bus"
+	depends on HAS_IOMEM
 
 config W1
 	tristate "Dallas's 1-wire support"
diff --git a/include/asm-s390/ccwdev.h b/include/asm-s390/ccwdev.h
index 6795ece..4c2e171 100644
--- a/include/asm-s390/ccwdev.h
+++ b/include/asm-s390/ccwdev.h
@@ -16,6 +16,7 @@
 /* structs from asm/cio.h */
 struct irb;
 struct ccw1;
+struct ccw_dev_id;
 
 /* simplified initializers for struct ccw_device:
  * CCW_DEVICE and CCW_DEVICE_DEVTYPE initialize one
@@ -175,6 +176,7 @@ extern int ccw_device_set_offline(struct ccw_device *cdev);
 
 extern struct ciw *ccw_device_get_ciw(struct ccw_device *, __u32 cmd);
 extern __u8 ccw_device_get_path_mask(struct ccw_device *);
+extern void ccw_device_get_id(struct ccw_device *, struct ccw_dev_id *);
 
 #define get_ccwdev_lock(x) (x)->ccwlock
 
@@ -184,7 +186,6 @@ extern __u8 ccw_device_get_path_mask(struct ccw_device *);
 extern struct ccw_device *ccw_device_probe_console(void);
 
 // FIXME: these have to go
-extern int _ccw_device_get_device_number(struct ccw_device *);
 extern int _ccw_device_get_subchannel_number(struct ccw_device *);
 
 extern void *ccw_device_get_chp_desc(struct ccw_device *, int);
diff --git a/include/asm-s390/ipl.h b/include/asm-s390/ipl.h
index bdcd448..2c40fd3 100644
--- a/include/asm-s390/ipl.h
+++ b/include/asm-s390/ipl.h
@@ -79,8 +79,8 @@ struct ipl_parameter_block {
  * IPL validity flags
  */
 extern u32 ipl_flags;
-
 extern u32 dump_prefix_page;
+extern unsigned int zfcpdump_prefix_array[];
 
 extern void do_reipl(void);
 extern void ipl_save_parameters(void);
diff --git a/include/asm-s390/param.h b/include/asm-s390/param.h
index 085a7e2..34aaa46 100644
--- a/include/asm-s390/param.h
+++ b/include/asm-s390/param.h
@@ -10,7 +10,7 @@
 #define _ASMS390_PARAM_H
 
 #ifdef __KERNEL__
-# define HZ		100		/* Internal kernel timer frequency */
+# define HZ		CONFIG_HZ	/* Internal kernel timer frequency */
 # define USER_HZ	100		/* .. some user interfaces are in "ticks" */
 # define CLOCKS_PER_SEC	(USER_HZ)	/* like times() */
 #endif
diff --git a/net/Kconfig b/net/Kconfig
index caeacd1..f3de729 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -218,6 +218,7 @@ config FIB_RULES
 	bool
 
 menu "Wireless"
+	depends on !S390
 
 source "net/wireless/Kconfig"
 source "net/mac80211/Kconfig"
diff --git a/net/ax25/Kconfig b/net/ax25/Kconfig
index 43dd86f..2a72aa9 100644
--- a/net/ax25/Kconfig
+++ b/net/ax25/Kconfig
@@ -3,7 +3,7 @@
 #
 
 menuconfig HAMRADIO
-	depends on NET
+	depends on NET && !S390
 	bool "Amateur Radio support"
 	help
 	  If you want to connect your Linux box to an amateur radio, answer Y
diff --git a/net/bluetooth/Kconfig b/net/bluetooth/Kconfig
index 6929490..7725da9 100644
--- a/net/bluetooth/Kconfig
+++ b/net/bluetooth/Kconfig
@@ -3,7 +3,7 @@
 #
 
 menuconfig BT
-	depends on NET
+	depends on NET && !S390
 	tristate "Bluetooth subsystem support"
 	help
 	  Bluetooth is low-cost, low-power, short-range wireless technology.
diff --git a/net/irda/Kconfig b/net/irda/Kconfig
index 9efb17b..c8671a7 100644
--- a/net/irda/Kconfig
+++ b/net/irda/Kconfig
@@ -3,7 +3,7 @@
 #
 
 menuconfig IRDA
-	depends on NET
+	depends on NET && !S390
 	tristate "IrDA (infrared) subsystem support"
 	select CRC_CCITT
 	---help---
diff --git a/sound/Kconfig b/sound/Kconfig
index 97532bb..9ea4738 100644
--- a/sound/Kconfig
+++ b/sound/Kconfig
@@ -2,6 +2,7 @@
 #
 
 menu "Sound"
+	depends on HAS_IOMEM
 
 config SOUND
 	tristate "Sound card support"


