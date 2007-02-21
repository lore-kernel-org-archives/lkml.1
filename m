Return-Path: <linux-kernel-owner+w=401wt.eu-S1751183AbXBUIRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751183AbXBUIRz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 03:17:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbXBUIRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 03:17:55 -0500
Received: from twin.jikos.cz ([213.151.79.26]:54477 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbXBUIRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 03:17:53 -0500
Date: Wed, 21 Feb 2007 09:16:28 +0100
From: David Sterba <dave@jikos.cz>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org
Subject: [PATCH] Fix trivial help text typos in Kconfig* files
Message-ID: <20070221081628.GB27718@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(patch against 2.6.21-rc1)

Fix several typos in help text in Kconfig* files.

Signed-off-by: David Sterba <dave@jikos.cz>
---
 arch/cris/arch-v32/drivers/Kconfig |    2 +-
 arch/h8300/Kconfig.debug           |    4 ++--
 arch/i386/Kconfig.cpu              |    4 ++--
 arch/ia64/Kconfig                  |    2 +-
 arch/m68knommu/Kconfig.debug       |    2 +-
 arch/mips/Kconfig                  |    6 +++---
 arch/powerpc/Kconfig.debug         |    2 +-
 arch/s390/crypto/Kconfig           |    2 +-
 crypto/Kconfig                     |    2 +-
 drivers/ata/Kconfig                |    2 +-
 drivers/char/tpm/Kconfig           |    2 +-
 drivers/crypto/Kconfig             |    2 +-
 drivers/macintosh/Kconfig          |    2 +-
 drivers/rtc/Kconfig                |    2 +-
 drivers/usb/serial/Kconfig         |    2 +-
 init/Kconfig                       |    2 +-
 kernel/Kconfig.preempt             |    4 ++--
 net/ipv4/Kconfig                   |    4 ++--
 net/ipv6/netfilter/Kconfig         |    2 +-
 net/netfilter/Kconfig              |    2 +-
 security/selinux/Kconfig           |    2 +-
 21 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/arch/cris/arch-v32/drivers/Kconfig b/arch/cris/arch-v32/drivers/Kconfig
index f64624f..1d859c1 100644
--- a/arch/cris/arch-v32/drivers/Kconfig
+++ b/arch/cris/arch-v32/drivers/Kconfig
@@ -603,7 +603,7 @@ config ETRAX_CARDBUS
         select HOTPLUG
         select PCCARD_NONSTATIC
         help
-	 Enabled the ETRAX Carbus driver.
+	 Enabled the ETRAX Cardbus driver.
 
 config PCI
        bool
diff --git a/arch/h8300/Kconfig.debug b/arch/h8300/Kconfig.debug
index e0e9bcb..554efe6 100644
--- a/arch/h8300/Kconfig.debug
+++ b/arch/h8300/Kconfig.debug
@@ -21,12 +21,12 @@ config GDB_MAGICPRINT
 	bool "Message Output for GDB MagicPrint service"
 	depends on (H8300H_SIM || H8S_SIM)
 	help
-	  kernel messages output useing MagicPrint service from GDB
+	  kernel messages output using MagicPrint service from GDB
 
 config SYSCALL_PRINT
 	bool "SystemCall trace print"
 	help
-	  outout history of systemcall
+	  output history of systemcall
 
 config GDB_DEBUG
    	bool "Use gdb stub"
diff --git a/arch/i386/Kconfig.cpu b/arch/i386/Kconfig.cpu
index b99c0e2..3e32fe5 100644
--- a/arch/i386/Kconfig.cpu
+++ b/arch/i386/Kconfig.cpu
@@ -107,7 +107,7 @@ config MCORE2
 	bool "Core 2/newer Xeon"
 	help
 	  Select this for Intel Core 2 and newer Core 2 Xeons (Xeon 51xx and 53xx)
-	  CPUs. You can distingush newer from older Xeons by the CPU family
+	  CPUs. You can distinguish newer from older Xeons by the CPU family
 	  in /proc/cpuinfo. Newer ones have 6.
 
 config MPENTIUM4
@@ -171,7 +171,7 @@ config MWINCHIP3D
 	help
 	  Select this for an IDT Winchip-2A or 3.  Linux and GCC
 	  treat this chip as a 586TSC with some extended instructions
-	  and alignment reqirements.  Also enable out of order memory
+	  and alignment requirements.  Also enable out of order memory
 	  stores for this CPU, which can increase performance of some
 	  operations.
 
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index d51f0f1..7e24e7d 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -456,7 +456,7 @@ config KEXEC
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
-	  but it is indepedent of the system firmware.   And like a reboot
+	  but it is independent of the system firmware.   And like a reboot
 	  you can start any kernel with it, not just Linux.
 
 	  The name comes from the similiarity to the exec system call.
diff --git a/arch/m68knommu/Kconfig.debug b/arch/m68knommu/Kconfig.debug
index 763c9aa..9ff47bd 100644
--- a/arch/m68knommu/Kconfig.debug
+++ b/arch/m68knommu/Kconfig.debug
@@ -5,7 +5,7 @@ source "lib/Kconfig.debug"
 config FULLDEBUG
 	bool "Full Symbolic/Source Debugging support"
 	help
-	  Enable debuging symbols on kernel build.
+	  Enable debugging symbols on kernel build.
 
 config HIGHPROFILE
 	bool "Use fast second timer for profiling"
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index c6f74f1..5320767 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -934,7 +934,7 @@ choice
 	  byte order. These modes require different kernels and a different
 	  Linux distribution.  In general there is one preferred byteorder for a
 	  particular system but some systems are just as commonly used in the
-	  one or the other endianess.
+	  one or the other endianness.
 
 config CPU_BIG_ENDIAN
 	bool "Big endian"
@@ -1712,7 +1712,7 @@ config ARCH_DISCONTIGMEM_ENABLE
 	bool
 	default y if SGI_IP27
 	help
-	  Say Y to upport efficient handling of discontiguous physical memory,
+	  Say Y to support efficient handling of discontiguous physical memory,
 	  for architectures which are either NUMA (Non-Uniform Memory Access)
 	  or have huge holes in the physical address space for other reasons.
 	  See <file:Documentation/vm/numa> for more.
@@ -1897,7 +1897,7 @@ config KEXEC
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
-	  but it is indepedent of the system firmware.   And like a reboot
+	  but it is independent of the system firmware.   And like a reboot
 	  you can start any kernel with it, not just Linux.
 
 	  The name comes from the similiarity to the exec system call.
diff --git a/arch/powerpc/Kconfig.debug b/arch/powerpc/Kconfig.debug
index d39d133..0317e84 100644
--- a/arch/powerpc/Kconfig.debug
+++ b/arch/powerpc/Kconfig.debug
@@ -23,7 +23,7 @@ config HCALL_STATS
 	depends on PPC_PSERIES && DEBUG_FS
 	help
 	  Adds code to keep track of the number of hypervisor calls made and
-	  the amount of time spent in hypervisor callsr.  Wall time spent in
+	  the amount of time spent in hypervisor calls.  Wall time spent in
 	  each call is always calculated, and if available CPU cycles spent
 	  are also calculated.  A directory named hcall_inst is added at the
 	  root of the debugfs filesystem.  Within the hcall_inst directory
diff --git a/arch/s390/crypto/Kconfig b/arch/s390/crypto/Kconfig
index 99ff9f0..d1defbb 100644
--- a/arch/s390/crypto/Kconfig
+++ b/arch/s390/crypto/Kconfig
@@ -54,7 +54,7 @@ config S390_PRNG
 	default "m"
 	help
 	  Select this option if you want to use the s390 pseudo random number
-	  generator. The PRNG is part of the cryptograhic processor functions
+	  generator. The PRNG is part of the cryptographic processor functions
 	  and uses triple-DES to generate secure random numbers like the
 	  ANSI X9.17 standard. The PRNG is usable via the char device
 	  /dev/prandom.
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 086fcec..9f954fd 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -258,7 +258,7 @@ config CRYPTO_SERPENT
 
 	  Keys are allowed to be from 0 to 256 bits in length, in steps
 	  of 8 bits.  Also includes the 'Tnepres' algorithm, a reversed
-	  variant of Serpent for compatibility with old kerneli code.
+	  variant of Serpent for compatibility with old kernel code.
 
 	  See also:
 	  <http://www.cl.cam.ac.uk/~rja14/serpent.html>
diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 4af0a4b..e655528 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -430,7 +430,7 @@ config PATA_OPTIDMA
 	help
 	  This option enables DMA/PIO support for the later OPTi
 	  controllers found on some old motherboards and in some
-	  latops
+	  laptops.
 
 	  If unsure, say N.
 
diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index fe00c7d..11089be 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -33,7 +33,7 @@ config TCG_NSC
 	tristate "National Semiconductor TPM Interface"
 	depends on TCG_TPM && PNPACPI
 	---help---
-	  If you have a TPM security chip from National Semicondutor 
+	  If you have a TPM security chip from National Semiconductor 
 	  say Yes and it will be accessible from within Linux.  To 
 	  compile this driver as a module, choose M here; the module 
 	  will be called tpm_nsc.
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index ff8c4be..6da963b 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -61,7 +61,7 @@ config CRYPTO_DEV_GEODE
 	default m
 	help
 	  Say 'Y' here to use the AMD Geode LX processor on-board AES
-	  engine for the CryptoAPI AES alogrithm.
+	  engine for the CryptoAPI AES algorithm.
 
 	  To compile this driver as a module, choose M here: the module
 	  will be called geode-aes.
diff --git a/drivers/macintosh/Kconfig b/drivers/macintosh/Kconfig
index 1a86387..7ae7e5d 100644
--- a/drivers/macintosh/Kconfig
+++ b/drivers/macintosh/Kconfig
@@ -231,7 +231,7 @@ config PMAC_RACKMETER
 	tristate "Support for Apple XServe front panel LEDs"
 	depends on PPC_PMAC
 	help
-	  This driver procides some support to control the front panel
+	  This driver provides some support to control the front panel
           blue LEDs "vu-meter" of the XServer macs.
 
 endmenu
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index deef296..f209212 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -88,7 +88,7 @@ config RTC_INTF_DEV_UIE_EMUL
 	bool "RTC UIE emulation on dev interface"
 	depends on RTC_INTF_DEV
 	help
-	  Provides an emulation for RTC_UIE if the underlaying rtc chip
+	  Provides an emulation for RTC_UIE if the underlying rtc chip
 	  driver does not expose RTC_UIE ioctls.  Those requests generate
 	  once-per-second update interrupts, used for synchronization.
 
diff --git a/drivers/usb/serial/Kconfig b/drivers/usb/serial/Kconfig
index 2f4d303..4098b5e 100644
--- a/drivers/usb/serial/Kconfig
+++ b/drivers/usb/serial/Kconfig
@@ -558,7 +558,7 @@ config USB_SERIAL_DEBUG
 	tristate "USB Debugging Device"
 	depends on USB_SERIAL
 	help
-	  Say Y here if you have a USB debugging device used to recieve
+	  Say Y here if you have a USB debugging device used to receive
 	  debugging data from another machine.  The most common of these
 	  devices is the NetChip TurboCONNECT device.
 
diff --git a/init/Kconfig b/init/Kconfig
index f977086..9c69c0a 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -287,7 +287,7 @@ config SYSFS_DEPRECATED
 	  releases.
 
 	  If enabled, this option will also move any device structures
-	  that belong to a class, back into the /sys/class heirachy, in
+	  that belong to a class, back into the /sys/class hierarchy, in
 	  order to support older versions of udev.
 
 	  If you are using a distro that was released in 2006 or later,
diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
index 0b46a5d..c64ce9c 100644
--- a/kernel/Kconfig.preempt
+++ b/kernel/Kconfig.preempt
@@ -23,7 +23,7 @@ config PREEMPT_VOLUNTARY
 	  "explicit preemption points" to the kernel code. These new
 	  preemption points have been selected to reduce the maximum
 	  latency of rescheduling, providing faster application reactions,
-	  at the cost of slighly lower throughput.
+	  at the cost of slightly lower throughput.
 
 	  This allows reaction to interactive events by allowing a
 	  low priority process to voluntarily preempt itself even if it
@@ -43,7 +43,7 @@ config PREEMPT
 	  even if it is in kernel mode executing a system call and would
 	  otherwise not be about to reach a natural preemption point.
 	  This allows applications to run more 'smoothly' even when the
-	  system is under load, at the cost of slighly lower throughput
+	  system is under load, at the cost of slightly lower throughput
 	  and a slight runtime overhead to kernel code.
 
 	  Select this if you are building a kernel for a desktop or
diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index 91f3a5c..4cf064f 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -130,7 +130,7 @@ config IP_ROUTE_MULTIPATH_RR
 	tristate "MULTIPATH: round robin algorithm"
 	depends on IP_ROUTE_MULTIPATH_CACHED
 	help
-	  Mulitpath routes are chosen according to Round Robin
+	  Multipath routes are chosen according to Round Robin
 
 config IP_ROUTE_MULTIPATH_RANDOM
 	tristate "MULTIPATH: random algorithm"
@@ -624,7 +624,7 @@ config TCP_MD5SIG
 	select CRYPTO
 	select CRYPTO_MD5
 	---help---
-	  RFC2385 specifices a method of giving MD5 protection to TCP sessions.
+	  RFC2385 specifies a method of giving MD5 protection to TCP sessions.
 	  Its main (only?) use is to protect BGP sessions between core routers
 	  on the Internet.
 
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index da07e9a..3b4d192 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -28,7 +28,7 @@ config IP6_NF_QUEUE
 	  packets which enables users to receive the filtered packets
 	  with QUEUE target using libipq.
 
-	  THis option enables the old IPv6-only "ip6_queue" implementation
+	  This option enables the old IPv6-only "ip6_queue" implementation
 	  which has been obsoleted by the new "nfnetlink_queue" code (see
 	  CONFIG_NETFILTER_NETLINK_QUEUE).
 
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 253fce3..a92f4a8 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -229,7 +229,7 @@ config NF_CONNTRACK_PPTP
 
 	  Please note that not all PPTP modes of operation are supported yet.
 	  Specifically these limitations exist:
-	    - Blindy assumes that control connections are always established
+	    - Blindly assumes that control connections are always established
 	      in PNS->PAC direction. This is a violation of RFC2637.
 	    - Only supports a single call within each session
 
diff --git a/security/selinux/Kconfig b/security/selinux/Kconfig
index 23b5104..b32a459 100644
--- a/security/selinux/Kconfig
+++ b/security/selinux/Kconfig
@@ -137,7 +137,7 @@ config SECURITY_SELINUX_POLICYDB_VERSION
 
 	  Examples:
 	  For the Fedora Core 3 or 4 Linux distributions, enable this option
-	  and set the value via the next option. For Fedore Core 5 and later,
+	  and set the value via the next option. For Fedora Core 5 and later,
 	  do not enable this option.
 
 	  If you are unsure how to answer this question, answer N.
