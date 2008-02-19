Return-Path: <linux-kernel-owner+w=401wt.eu-S1760567AbYBSS74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760567AbYBSS74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 13:59:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759725AbYBSS7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 13:59:11 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759687AbYBSS7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 13:59:09 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 4/4] MN10300: Update asb2303_defconfig
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
       dhowells@redhat.com
Date: Tue, 19 Feb 2008 18:59:04 +0000
Message-ID: <20080219185904.22304.1711.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080219185848.22304.75764.stgit@warthog.procyon.org.uk>
References: <20080219185848.22304.75764.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the ASB2303 default configuration.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/configs/asb2303_defconfig |   33 +++++++++++++++++++++++---------
 1 files changed, 24 insertions(+), 9 deletions(-)


diff --git a/arch/mn10300/configs/asb2303_defconfig b/arch/mn10300/configs/asb2303_defconfig
index ca9876a..3aa8906 100644
--- a/arch/mn10300/configs/asb2303_defconfig
+++ b/arch/mn10300/configs/asb2303_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.24-rc2
-# Fri Nov 16 13:36:38 2007
+# Linux kernel version: 2.6.25-rc2
+# Tue Feb 19 18:52:24 2008
 #
 CONFIG_MN10300=y
 CONFIG_AM33=y
@@ -21,6 +21,7 @@ CONFIG_ARCH_HAS_ILOG2_U32=y
 # CONFIG_ARCH_SUPPORTS_AOUT is not set
 CONFIG_GENERIC_HARDIRQS=y
 # CONFIG_HOTPLUG_CPU is not set
+CONFIG_HZ=1000
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 
 #
@@ -38,15 +39,16 @@ CONFIG_SYSVIPC_SYSCTL=y
 CONFIG_BSD_PROCESS_ACCT=y
 # CONFIG_BSD_PROCESS_ACCT_V3 is not set
 # CONFIG_TASKSTATS is not set
-# CONFIG_USER_NS is not set
-# CONFIG_PID_NS is not set
 # CONFIG_AUDIT is not set
 # CONFIG_IKCONFIG is not set
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CGROUPS is not set
-# CONFIG_FAIR_GROUP_SCHED is not set
+# CONFIG_GROUP_SCHED is not set
+# CONFIG_USER_SCHED is not set
+# CONFIG_CGROUP_SCHED is not set
 # CONFIG_SYSFS_DEPRECATED is not set
 # CONFIG_RELAY is not set
+# CONFIG_NAMESPACES is not set
 # CONFIG_BLK_DEV_INITRD is not set
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_SYSCTL=y
@@ -57,22 +59,33 @@ CONFIG_SYSCTL_SYSCALL=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
 CONFIG_ELF_CORE=y
+CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
 CONFIG_ANON_INODES=y
 CONFIG_EPOLL=y
 CONFIG_SIGNALFD=y
+CONFIG_TIMERFD=y
 CONFIG_EVENTFD=y
 CONFIG_SHMEM=y
 # CONFIG_VM_EVENT_COUNTERS is not set
 CONFIG_SLAB=y
 # CONFIG_SLUB is not set
 # CONFIG_SLOB is not set
+CONFIG_PROFILING=y
+# CONFIG_MARKERS is not set
+CONFIG_OPROFILE=y
+# CONFIG_HAVE_OPROFILE is not set
+# CONFIG_HAVE_KPROBES is not set
+# CONFIG_PROC_PAGE_MONITOR is not set
+CONFIG_SLABINFO=y
 CONFIG_RT_MUTEXES=y
 # CONFIG_TINY_SHMEM is not set
 CONFIG_BASE_SMALL=0
 # CONFIG_MODULES is not set
 # CONFIG_BLOCK is not set
+CONFIG_CLASSIC_RCU=y
+# CONFIG_PREEMPT_RCU is not set
 
 #
 # Matsushita MN10300 system setup
@@ -206,6 +219,7 @@ CONFIG_DEFAULT_TCP_CONG="cubic"
 #
 # CONFIG_NET_PKTGEN is not set
 # CONFIG_HAMRADIO is not set
+# CONFIG_CAN is not set
 # CONFIG_IRDA is not set
 # CONFIG_BT is not set
 # CONFIG_AF_RXRPC is not set
@@ -311,6 +325,8 @@ CONFIG_MTD_PHYSMAP_BANKWIDTH=2
 # CONFIG_PARPORT is not set
 CONFIG_MISC_DEVICES=y
 # CONFIG_EEPROM_93CX6 is not set
+# CONFIG_ENCLOSURE_SERVICES is not set
+# CONFIG_HAVE_IDE is not set
 
 #
 # SCSI device support
@@ -345,7 +361,6 @@ CONFIG_SMC91X=y
 # CONFIG_WAN is not set
 # CONFIG_PPP is not set
 # CONFIG_SLIP is not set
-# CONFIG_SHAPER is not set
 # CONFIG_NETCONSOLE is not set
 # CONFIG_NETPOLL is not set
 # CONFIG_NET_POLL_CONTROLLER is not set
@@ -405,6 +420,7 @@ CONFIG_RTC=y
 # CONFIG_W1 is not set
 # CONFIG_POWER_SUPPLY is not set
 # CONFIG_HWMON is not set
+# CONFIG_THERMAL is not set
 # CONFIG_WATCHDOG is not set
 
 #
@@ -444,6 +460,7 @@ CONFIG_SSB_POSSIBLE=y
 # CONFIG_SOUND is not set
 # CONFIG_USB_SUPPORT is not set
 # CONFIG_MMC is not set
+# CONFIG_MEMSTICK is not set
 # CONFIG_NEW_LEDS is not set
 # CONFIG_RTC_CLASS is not set
 
@@ -455,10 +472,10 @@ CONFIG_SSB_POSSIBLE=y
 #
 # File systems
 #
+CONFIG_DNOTIFY=y
 CONFIG_INOTIFY=y
 CONFIG_INOTIFY_USER=y
 # CONFIG_QUOTA is not set
-CONFIG_DNOTIFY=y
 # CONFIG_AUTOFS_FS is not set
 # CONFIG_AUTOFS4_FS is not set
 # CONFIG_FUSE_FS is not set
@@ -554,5 +571,3 @@ CONFIG_HAS_DMA=y
 #
 # Profiling support
 #
-CONFIG_PROFILING=y
-CONFIG_OPROFILE=y

