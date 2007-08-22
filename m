Return-Path: <linux-kernel-owner+w=401wt.eu-S934174AbXHVRWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934174AbXHVRWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 13:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765726AbXHVRU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 13:20:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:65458 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765595AbXHVRU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 13:20:56 -0400
Message-Id: <200708221909.18007.arnd@arndb.de>
References: <20070822170124.764128591@arndb.de>
User-Agent: quilt/0.45-1
Date: Wed, 22 Aug 2007 19:09:17 +0200
From: Arnd Bergmann <arnd@arndb.de>
To: paulus@samba.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       cbe-oss-dev@ozlabs.org, Arnd Bergmann <arnd.bergmann@de.ibm.com>
Subject: [patch 5/5] update cell_defconfig for 2.6.23
Content-Disposition: inline
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?iso-8859-1?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?iso-8859-1?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ?=
 =?iso-8859-1?q?=0A=098MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?iso-8859-1?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?iso-8859-1?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/SYwJL7njj54X2ovjs/LM77KNaF1vvkMjEYFd
 vkfufMunOkDDuDR25XTtZZytW6JalOR5hdH7WPNDhcxirMj50E
 Dx0yjy2xr8wleB0/xqLjg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd.bergmann@de.ibm.com>
Signed-off-by: Arnd Bergmann <arnd.bergmann@de.ibm.com>
---
Index: linux-2.6/arch/powerpc/configs/cell_defconfig
===================================================================
--- linux-2.6.orig/arch/powerpc/configs/cell_defconfig
+++ linux-2.6/arch/powerpc/configs/cell_defconfig
@@ -1,9 +1,23 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.22-rc6
-# Tue Jun 26 12:32:34 2007
+# Linux kernel version: 2.6.23-rc3
+# Wed Aug 22 15:19:19 2007
 #
 CONFIG_PPC64=y
+
+#
+# Processor support
+#
+# CONFIG_POWER4_ONLY is not set
+CONFIG_POWER3=y
+CONFIG_POWER4=y
+CONFIG_PPC_FPU=y
+CONFIG_ALTIVEC=y
+CONFIG_PPC_STD_MMU=y
+CONFIG_PPC_MM_SLICES=y
+CONFIG_VIRT_CPU_ACCOUNTING=y
+CONFIG_SMP=y
+CONFIG_NR_CPUS=4
 CONFIG_64BIT=y
 CONFIG_PPC_MERGE=y
 CONFIG_MMU=y
@@ -15,6 +29,7 @@ CONFIG_ARCH_HAS_ILOG2_U64=y
 CONFIG_GENERIC_HWEIGHT=y
 CONFIG_GENERIC_CALIBRATE_DELAY=y
 CONFIG_GENERIC_FIND_NEXT_BIT=y
+CONFIG_ARCH_NO_VIRT_TO_BUS=y
 CONFIG_PPC=y
 CONFIG_EARLY_PRINTK=y
 CONFIG_COMPAT=y
@@ -22,51 +37,33 @@ CONFIG_SYSVIPC_COMPAT=y
 CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
 CONFIG_ARCH_MAY_HAVE_PC_FDC=y
 CONFIG_PPC_OF=y
+CONFIG_OF=y
 CONFIG_PPC_UDBG_16550=y
 # CONFIG_GENERIC_TBSYNC is not set
 CONFIG_AUDIT_ARCH=y
 CONFIG_GENERIC_BUG=y
 # CONFIG_DEFAULT_UIMAGE is not set
-
-#
-# Processor support
-#
-# CONFIG_POWER4_ONLY is not set
-CONFIG_POWER3=y
-CONFIG_POWER4=y
-CONFIG_PPC_FPU=y
 # CONFIG_PPC_DCR_NATIVE is not set
 CONFIG_PPC_DCR_MMIO=y
 CONFIG_PPC_DCR=y
 CONFIG_PPC_OF_PLATFORM_PCI=y
-CONFIG_ALTIVEC=y
-CONFIG_PPC_STD_MMU=y
-CONFIG_PPC_MM_SLICES=y
-CONFIG_VIRT_CPU_ACCOUNTING=y
-CONFIG_SMP=y
-CONFIG_NR_CPUS=4
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
 # CONFIG_POSIX_MQUEUE is not set
 # CONFIG_BSD_PROCESS_ACCT is not set
 # CONFIG_TASKSTATS is not set
-# CONFIG_UTS_NS is not set
+# CONFIG_USER_NS is not set
 # CONFIG_AUDIT is not set
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
@@ -96,16 +93,13 @@ CONFIG_TIMERFD=y
 CONFIG_EVENTFD=y
 CONFIG_SHMEM=y
 CONFIG_VM_EVENT_COUNTERS=y
-CONFIG_SLAB=y
-# CONFIG_SLUB is not set
+CONFIG_SLUB_DEBUG=y
+# CONFIG_SLAB is not set
+CONFIG_SLUB=y
 # CONFIG_SLOB is not set
 CONFIG_RT_MUTEXES=y
 # CONFIG_TINY_SHMEM is not set
 CONFIG_BASE_SMALL=0
-
-#
-# Loadable module support
-#
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_MODULE_FORCE_UNLOAD is not set
@@ -113,12 +107,9 @@ CONFIG_MODULE_UNLOAD=y
 # CONFIG_MODULE_SRCVERSION_ALL is not set
 CONFIG_KMOD=y
 CONFIG_STOP_MACHINE=y
-
-#
-# Block layer
-#
 CONFIG_BLOCK=y
 # CONFIG_BLK_DEV_IO_TRACE is not set
+# CONFIG_BLK_DEV_BSG is not set
 
 #
 # IO Schedulers
@@ -138,7 +129,9 @@ CONFIG_DEFAULT_IOSCHED="anticipatory"
 #
 CONFIG_PPC_MULTIPLATFORM=y
 # CONFIG_EMBEDDED6xx is not set
-# CONFIG_APUS is not set
+# CONFIG_PPC_82xx is not set
+# CONFIG_PPC_83xx is not set
+# CONFIG_PPC_86xx is not set
 # CONFIG_PPC_PSERIES is not set
 # CONFIG_PPC_ISERIES is not set
 # CONFIG_PPC_MPC52xx is not set
@@ -158,7 +151,11 @@ CONFIG_PS3_HTAB_SIZE=20
 CONFIG_PS3_USE_LPAR_ADDR=y
 CONFIG_PS3_VUART=y
 CONFIG_PS3_PS3AV=y
-CONFIG_PS3_SYS_MANAGER=y
+CONFIG_PS3_SYS_MANAGER=m
+CONFIG_PS3_STORAGE=y
+CONFIG_PS3_DISK=y
+CONFIG_PS3_ROM=m
+CONFIG_PS3_FLASH=m
 CONFIG_PPC_CELL=y
 CONFIG_PPC_CELL_NATIVE=y
 CONFIG_PPC_IBM_CELL_BLADE=y
@@ -171,6 +168,7 @@ CONFIG_SPU_BASE=y
 CONFIG_CBE_RAS=y
 CONFIG_CBE_THERM=m
 CONFIG_CBE_CPUFREQ=m
+CONFIG_CBE_CPUFREQ_PMI=m
 # CONFIG_PQ2ADS is not set
 CONFIG_PPC_NATIVE=y
 CONFIG_UDBG_RTAS_CONSOLE=y
@@ -183,7 +181,7 @@ CONFIG_PPC_RTAS=y
 # CONFIG_RTAS_ERROR_LOGGING is not set
 CONFIG_RTAS_PROC=y
 CONFIG_RTAS_FLASH=y
-# CONFIG_PPC_PMI is not set
+CONFIG_PPC_PMI=m
 CONFIG_MMIO_NVRAM=y
 # CONFIG_PPC_MPC106 is not set
 # CONFIG_PPC_970_NAP is not set
@@ -206,6 +204,8 @@ CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
 # CPU Frequency drivers
 #
 # CONFIG_CPM2 is not set
+CONFIG_AXON_RAM=m
+# CONFIG_FSL_ULI1575 is not set
 
 #
 # Kernel options
@@ -248,6 +248,7 @@ CONFIG_SPLIT_PTLOCK_CPUS=4
 CONFIG_MIGRATION=y
 CONFIG_RESOURCES_64BIT=y
 CONFIG_ZONE_DMA_FLAG=1
+CONFIG_BOUNCE=y
 CONFIG_ARCH_MEMORY_PROBE=y
 CONFIG_NODES_SPAN_OTHER_NODES=y
 CONFIG_PPC_HAS_HASH_64K=y
@@ -268,7 +269,9 @@ CONFIG_GENERIC_ISA_DMA=y
 # CONFIG_PPC_INDIRECT_PCI is not set
 CONFIG_PCI=y
 CONFIG_PCI_DOMAINS=y
+CONFIG_PCI_SYSCALL=y
 CONFIG_PCIEPORTBUS=y
+CONFIG_PCIEAER=y
 CONFIG_ARCH_SUPPORTS_MSI=y
 # CONFIG_PCI_MSI is not set
 # CONFIG_PCI_DEBUG is not set
@@ -359,6 +362,7 @@ CONFIG_NETFILTER_XT_TARGET_DSCP=m
 CONFIG_NETFILTER_XT_TARGET_MARK=m
 CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
 CONFIG_NETFILTER_XT_TARGET_NFLOG=m
+# CONFIG_NETFILTER_XT_TARGET_TRACE is not set
 CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
 CONFIG_NETFILTER_XT_MATCH_COMMENT=m
 CONFIG_NETFILTER_XT_MATCH_DCCP=m
@@ -377,6 +381,7 @@ CONFIG_NETFILTER_XT_MATCH_SCTP=m
 CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
 CONFIG_NETFILTER_XT_MATCH_STRING=m
 CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
+CONFIG_NETFILTER_XT_MATCH_U32=m
 CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
 
 #
@@ -448,6 +453,7 @@ CONFIG_NET_CLS_ROUTE=y
 # CONFIG_MAC80211 is not set
 # CONFIG_IEEE80211 is not set
 # CONFIG_RFKILL is not set
+# CONFIG_NET_9P is not set
 
 #
 # Device Drivers
@@ -462,28 +468,12 @@ CONFIG_FW_LOADER=y
 # CONFIG_DEBUG_DRIVER is not set
 # CONFIG_DEBUG_DEVRES is not set
 # CONFIG_SYS_HYPERVISOR is not set
-
-#
-# Connector - unified userspace <-> kernelspace linker
-#
 # CONFIG_CONNECTOR is not set
 # CONFIG_MTD is not set
-
-#
-# Parallel port support
-#
+CONFIG_OF_DEVICE=y
 # CONFIG_PARPORT is not set
-
-#
-# Plug and Play support
-#
-# CONFIG_PNPACPI is not set
-
-#
-# Block devices
-#
+CONFIG_BLK_DEV=y
 # CONFIG_BLK_DEV_FD is not set
-# CONFIG_BLK_CPQ_DA is not set
 # CONFIG_BLK_CPQ_CISS_DA is not set
 # CONFIG_BLK_DEV_DAC960 is not set
 # CONFIG_BLK_DEV_UMEM is not set
@@ -499,14 +489,11 @@ CONFIG_BLK_DEV_RAM_SIZE=131072
 CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
 # CONFIG_CDROM_PKTCDVD is not set
 # CONFIG_ATA_OVER_ETH is not set
-
-#
-# Misc devices
-#
+CONFIG_MISC_DEVICES=y
 # CONFIG_PHANTOM is not set
+# CONFIG_EEPROM_93CX6 is not set
 # CONFIG_SGI_IOC4 is not set
 # CONFIG_TIFM_CORE is not set
-# CONFIG_BLINK is not set
 CONFIG_IDE=y
 CONFIG_BLK_DEV_IDE=y
 
@@ -572,6 +559,7 @@ CONFIG_BLK_DEV_IDEDMA=y
 #
 # CONFIG_RAID_ATTRS is not set
 CONFIG_SCSI=y
+CONFIG_SCSI_DMA=y
 # CONFIG_SCSI_TGT is not set
 # CONFIG_SCSI_NETLINK is not set
 CONFIG_SCSI_PROC_FS=y
@@ -604,10 +592,7 @@ CONFIG_SCSI_WAIT_SCAN=m
 # CONFIG_SCSI_ISCSI_ATTRS is not set
 CONFIG_SCSI_SAS_ATTRS=y
 # CONFIG_SCSI_SAS_LIBSAS is not set
-
-#
-# SCSI low-level drivers
-#
+CONFIG_SCSI_LOWLEVEL=y
 # CONFIG_ISCSI_TCP is not set
 # CONFIG_BLK_DEV_3W_XXXX_RAID is not set
 # CONFIG_SCSI_3W_9XXX is not set
@@ -622,7 +607,6 @@ CONFIG_SCSI_SAS_ATTRS=y
 # CONFIG_MEGARAID_LEGACY is not set
 # CONFIG_MEGARAID_SAS is not set
 # CONFIG_SCSI_HPTIOP is not set
-# CONFIG_SCSI_BUSLOGIC is not set
 # CONFIG_SCSI_DMX3191D is not set
 # CONFIG_SCSI_EATA is not set
 # CONFIG_SCSI_FUTURE_DOMAIN is not set
@@ -696,10 +680,6 @@ CONFIG_PATA_PDC2027X=m
 # CONFIG_PATA_VIA is not set
 # CONFIG_PATA_WINBOND is not set
 # CONFIG_PATA_SCC is not set
-
-#
-# Multi-device support (RAID and LVM)
-#
 CONFIG_MD=y
 CONFIG_BLK_DEV_MD=m
 CONFIG_MD_LINEAR=m
@@ -717,6 +697,7 @@ CONFIG_DM_MIRROR=m
 CONFIG_DM_ZERO=m
 CONFIG_DM_MULTIPATH=m
 # CONFIG_DM_MULTIPATH_EMC is not set
+# CONFIG_DM_MULTIPATH_RDAC is not set
 # CONFIG_DM_DELAY is not set
 
 #
@@ -728,43 +709,30 @@ CONFIG_FUSION=y
 CONFIG_FUSION_SAS=y
 CONFIG_FUSION_MAX_SGE=128
 # CONFIG_FUSION_CTL is not set
+# CONFIG_FUSION_LOGGING is not set
 
 #
 # IEEE 1394 (FireWire) support
 #
 # CONFIG_FIREWIRE is not set
 # CONFIG_IEEE1394 is not set
-
-#
-# I2O device support
-#
 # CONFIG_I2O is not set
 # CONFIG_MACINTOSH_DRIVERS is not set
-
-#
-# Network device support
-#
 CONFIG_NETDEVICES=y
+# CONFIG_NETDEVICES_MULTIQUEUE is not set
 # CONFIG_DUMMY is not set
 CONFIG_BONDING=m
+CONFIG_MACVLAN=m
 # CONFIG_EQUALIZER is not set
 CONFIG_TUN=y
 # CONFIG_ARCNET is not set
 # CONFIG_PHYLIB is not set
-
-#
-# Ethernet (10 or 100Mbit)
-#
 CONFIG_NET_ETHERNET=y
 CONFIG_MII=y
 # CONFIG_HAPPYMEAL is not set
 # CONFIG_SUNGEM is not set
 # CONFIG_CASSINI is not set
 # CONFIG_NET_VENDOR_3COM is not set
-
-#
-# Tulip family network device support
-#
 # CONFIG_NET_TULIP is not set
 # CONFIG_HP100 is not set
 # CONFIG_NET_PCI is not set
@@ -781,11 +749,12 @@ CONFIG_E1000_NAPI=y
 # CONFIG_SIS190 is not set
 CONFIG_SKGE=m
 CONFIG_SKY2=m
-# CONFIG_SK98LIN is not set
+# CONFIG_SKY2_DEBUG is not set
 # CONFIG_VIA_VELOCITY is not set
 CONFIG_TIGON3=y
 # CONFIG_BNX2 is not set
 CONFIG_SPIDER_NET=y
+CONFIG_GELIC_NET=m
 # CONFIG_QLA3XXX is not set
 # CONFIG_ATL1 is not set
 CONFIG_NETDEV_10000=y
@@ -824,15 +793,7 @@ CONFIG_NETDEV_10000=y
 # CONFIG_NETCONSOLE is not set
 # CONFIG_NETPOLL is not set
 # CONFIG_NET_POLL_CONTROLLER is not set
-
-#
-# ISDN subsystem
-#
 # CONFIG_ISDN is not set
-
-#
-# Telephony Support
-#
 # CONFIG_PHONE is not set
 
 #
@@ -925,10 +886,6 @@ CONFIG_UNIX98_PTYS=y
 CONFIG_HVC_DRIVER=y
 CONFIG_HVC_RTAS=y
 CONFIG_HVC_BEAT=y
-
-#
-# IPMI
-#
 CONFIG_IPMI_HANDLER=m
 # CONFIG_IPMI_PANIC_EVENT is not set
 CONFIG_IPMI_DEVICE_INTERFACE=m
@@ -963,10 +920,6 @@ CONFIG_GEN_RTC=y
 # CONFIG_DRM is not set
 # CONFIG_RAW_DRIVER is not set
 # CONFIG_HANGCHECK_TIMER is not set
-
-#
-# TPM devices
-#
 # CONFIG_TCG_TPM is not set
 CONFIG_DEVPORT=y
 CONFIG_I2C=y
@@ -1000,6 +953,7 @@ CONFIG_I2C_ALGOBIT=y
 # CONFIG_I2C_SIS5595 is not set
 # CONFIG_I2C_SIS630 is not set
 # CONFIG_I2C_SIS96X is not set
+# CONFIG_I2C_TAOS_EVM is not set
 # CONFIG_I2C_STUB is not set
 # CONFIG_I2C_TINY_USB is not set
 # CONFIG_I2C_VIA is not set
@@ -1011,11 +965,13 @@ CONFIG_I2C_ALGOBIT=y
 #
 # CONFIG_SENSORS_DS1337 is not set
 # CONFIG_SENSORS_DS1374 is not set
+# CONFIG_DS1682 is not set
 # CONFIG_SENSORS_EEPROM is not set
 # CONFIG_SENSORS_PCF8574 is not set
 # CONFIG_SENSORS_PCA9539 is not set
 # CONFIG_SENSORS_PCF8591 is not set
 # CONFIG_SENSORS_MAX6875 is not set
+# CONFIG_SENSORS_TSL2550 is not set
 # CONFIG_I2C_DEBUG_CORE is not set
 # CONFIG_I2C_DEBUG_ALGO is not set
 # CONFIG_I2C_DEBUG_BUS is not set
@@ -1026,11 +982,8 @@ CONFIG_I2C_ALGOBIT=y
 #
 # CONFIG_SPI is not set
 # CONFIG_SPI_MASTER is not set
-
-#
-# Dallas's 1-wire bus
-#
 # CONFIG_W1 is not set
+# CONFIG_POWER_SUPPLY is not set
 # CONFIG_HWMON is not set
 
 #
@@ -1055,6 +1008,7 @@ CONFIG_I2C_ALGOBIT=y
 #
 # CONFIG_DISPLAY_SUPPORT is not set
 # CONFIG_VGASTATE is not set
+CONFIG_VIDEO_OUTPUT_CONTROL=m
 # CONFIG_FB is not set
 # CONFIG_FB_IBM_GXT4500 is not set
 
@@ -1068,10 +1022,7 @@ CONFIG_DUMMY_CONSOLE=y
 # Sound
 #
 # CONFIG_SOUND is not set
-
-#
-# HID Devices
-#
+CONFIG_HID_SUPPORT=y
 CONFIG_HID=m
 # CONFIG_HID_DEBUG is not set
 
@@ -1085,10 +1036,7 @@ CONFIG_HID=m
 #
 # CONFIG_USB_KBD is not set
 # CONFIG_USB_MOUSE is not set
-
-#
-# USB support
-#
+CONFIG_USB_SUPPORT=y
 CONFIG_USB_ARCH_HAS_HCD=y
 CONFIG_USB_ARCH_HAS_OHCI=y
 CONFIG_USB_ARCH_HAS_EHCI=y
@@ -1122,6 +1070,7 @@ CONFIG_USB_OHCI_BIG_ENDIAN_MMIO=y
 CONFIG_USB_OHCI_LITTLE_ENDIAN=y
 # CONFIG_USB_UHCI_HCD is not set
 # CONFIG_USB_SL811_HCD is not set
+# CONFIG_USB_R8A66597_HCD is not set
 
 #
 # USB Device Class drivers
@@ -1199,23 +1148,7 @@ CONFIG_USB_MON=y
 #
 # CONFIG_USB_GADGET is not set
 # CONFIG_MMC is not set
-
-#
-# LED devices
-#
 # CONFIG_NEW_LEDS is not set
-
-#
-# LED drivers
-#
-
-#
-# LED Triggers
-#
-
-#
-# InfiniBand support
-#
 CONFIG_INFINIBAND=m
 CONFIG_INFINIBAND_USER_MAD=m
 CONFIG_INFINIBAND_USER_ACCESS=m
@@ -1231,14 +1164,13 @@ CONFIG_INFINIBAND_IPOIB_DEBUG=y
 CONFIG_INFINIBAND_IPOIB_DEBUG_DATA=y
 # CONFIG_INFINIBAND_SRP is not set
 # CONFIG_INFINIBAND_ISER is not set
+CONFIG_EDAC=y
 
 #
-# EDAC - error detection and reporting (RAS) (EXPERIMENTAL)
-#
-
-#
-# Real Time Clock
+# Reporting subsystems
 #
+# CONFIG_EDAC_DEBUG is not set
+CONFIG_EDAC_MM_EDAC=y
 # CONFIG_RTC_CLASS is not set
 
 #
@@ -1255,6 +1187,12 @@ CONFIG_INFINIBAND_IPOIB_DEBUG_DATA=y
 #
 
 #
+# Userspace I/O
+#
+CONFIG_UIO=m
+# CONFIG_UIO_CIF is not set
+
+#
 # File systems
 #
 CONFIG_EXT2_FS=y
@@ -1357,7 +1295,6 @@ CONFIG_SUNRPC=y
 # CONFIG_NCP_FS is not set
 # CONFIG_CODA_FS is not set
 # CONFIG_AFS_FS is not set
-# CONFIG_9P_FS is not set
 
 #
 # Partition Types
@@ -1439,6 +1376,7 @@ CONFIG_BITREVERSE=y
 # CONFIG_CRC16 is not set
 # CONFIG_CRC_ITU_T is not set
 CONFIG_CRC32=y
+# CONFIG_CRC7 is not set
 # CONFIG_LIBCRC32C is not set
 CONFIG_ZLIB_INFLATE=m
 CONFIG_ZLIB_DEFLATE=m
@@ -1471,9 +1409,10 @@ CONFIG_DEBUG_FS=y
 CONFIG_DEBUG_KERNEL=y
 # CONFIG_DEBUG_SHIRQ is not set
 # CONFIG_DETECT_SOFTLOCKUP is not set
+CONFIG_SCHED_DEBUG=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
-# CONFIG_DEBUG_SLAB is not set
+# CONFIG_SLUB_DEBUG_ON is not set
 # CONFIG_DEBUG_RT_MUTEXES is not set
 # CONFIG_RT_MUTEX_TESTER is not set
 # CONFIG_DEBUG_SPINLOCK is not set
@@ -1504,10 +1443,6 @@ CONFIG_IRQSTACKS=y
 #
 # CONFIG_KEYS is not set
 # CONFIG_SECURITY is not set
-
-#
-# Cryptographic options
-#
 CONFIG_CRYPTO=y
 CONFIG_CRYPTO_ALGAPI=y
 CONFIG_CRYPTO_BLKCIPHER=m
@@ -1546,7 +1481,4 @@ CONFIG_CRYPTO_DEFLATE=m
 # CONFIG_CRYPTO_CRC32C is not set
 # CONFIG_CRYPTO_CAMELLIA is not set
 # CONFIG_CRYPTO_TEST is not set
-
-#
-# Hardware crypto devices
-#
+CONFIG_CRYPTO_HW=y

--

