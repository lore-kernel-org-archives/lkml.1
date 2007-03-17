Return-Path: <linux-kernel-owner+w=401wt.eu-S1750954AbXCQSy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750954AbXCQSy6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 14:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbXCQSy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 14:54:58 -0400
Received: from sccrmhc15.comcast.net ([63.240.77.85]:59658 "EHLO
	sccrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbXCQSyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 14:54:55 -0400
Date: Sat, 17 Mar 2007 14:44:51 -0400
From: Matt LaPlante <kernel1@cyberdogtech.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org
Subject: [PATCH 21-rc4]  misc doc and kconfig typos
Message-Id: <20070317144451.6c83cf3b.kernel1@cyberdogtech.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.7; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Processed: mail.cyberdogtech.com, Sat, 17 Mar 2007 14:45:04 -0400
	(not processed: message from valid local sender)
X-Return-Path: kernel1@cyberdogtech.com
X-Envelope-From: kernel1@cyberdogtech.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
X-MDAV-Processed: mail.cyberdogtech.com, Sat, 17 Mar 2007 14:45:05 -0400
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix various typos in kernel docs and Kconfigs, 2.6.21-rc4.

Signed-off-by: Matt LaPlante <kernel1@cyberdogtech.com>
--

diff -ru a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
--- a/arch/arm/mach-at91/Kconfig	2007-03-17 13:20:34.000000000 -0400
+++ b/arch/arm/mach-at91/Kconfig	2007-03-17 13:37:28.000000000 -0400
@@ -100,7 +100,7 @@
 	depends on ARCH_AT91SAM9260
 	help
 	  Select this if you are using Atmel's AT91SAM9XE System-on-Chip.
-	  They are basicaly AT91SAM9260s with various sizes of embedded Flash.
+	  They are basically AT91SAM9260s with various sizes of embedded Flash.
 
 comment "AT91SAM9260 / AT91SAM9XE Board Type"
 
diff -ru a/arch/arm/mach-omap1/Kconfig b/arch/arm/mach-omap1/Kconfig
--- a/arch/arm/mach-omap1/Kconfig	2007-02-04 13:44:54.000000000 -0500
+++ b/arch/arm/mach-omap1/Kconfig	2007-03-17 13:45:35.000000000 -0400
@@ -84,7 +84,7 @@
           Support for the Palm Tungsten E PDA. Currently only the LCD panel
           is supported. To boot the kernel, you'll need a PalmOS compatible
           bootloader; check out http://palmtelinux.sourceforge.net for more
-          informations.
+          information.
           Say Y here if you have such a PDA, say NO otherwise.
 
 config MACH_NOKIA770
Only in b/arch/cris/arch-v10/drivers: eeprom.c.rej
diff -ru a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig	2007-03-17 13:20:35.000000000 -0400
+++ b/arch/powerpc/Kconfig	2007-03-17 13:47:58.000000000 -0400
@@ -625,7 +625,7 @@
 	depends PPC_IBM_CELL_BLADE
 	help
 	  PMI (Platform Management Interrupt) is a way to
-	  communicate with the BMC (Baseboard Mangement Controller).
+	  communicate with the BMC (Baseboard Management Controller).
 	  It is used in some IBM Cell blades.
 	default m
 
diff -ru a/Documentation/block/ioprio.txt b/Documentation/block/ioprio.txt
--- a/Documentation/block/ioprio.txt	2007-02-04 13:44:54.000000000 -0500
+++ b/Documentation/block/ioprio.txt	2007-03-17 14:21:29.000000000 -0400
@@ -6,10 +6,10 @@
 -----
 
 With the introduction of cfq v3 (aka cfq-ts or time sliced cfq), basic io
-priorities is supported for reads on files. This enables users to io nice
-processes or process groups, similar to what has been possible to cpu
-scheduling for ages. This document mainly details the current possibilites
-with cfq, other io schedulers do not support io priorities so far.
+priorities are supported for reads on files.  This enables users to io nice
+processes or process groups, similar to what has been possible with cpu
+scheduling for ages.  This document mainly details the current possibilities
+with cfq; other io schedulers do not support io priorities thus far.
 
 Scheduling classes
 ------------------
diff -ru a/Documentation/cpu-freq/cpufreq-stats.txt b/Documentation/cpu-freq/cpufreq-stats.txt
--- a/Documentation/cpu-freq/cpufreq-stats.txt	2007-02-04 13:44:54.000000000 -0500
+++ b/Documentation/cpu-freq/cpufreq-stats.txt	2007-03-17 13:33:57.000000000 -0400
@@ -17,7 +17,7 @@
 
 1. Introduction
 
-cpufreq-stats is a driver that provices CPU frequency statistics for each CPU.
+cpufreq-stats is a driver that provides CPU frequency statistics for each CPU.
 These statistics are provided in /sysfs as a bunch of read_only interfaces. This
 interface (when configured) will appear in a separate directory under cpufreq
 in /sysfs (<sysfs root>/devices/system/cpu/cpuX/cpufreq/stats/) for each CPU.
diff -ru a/Documentation/driver-model/platform.txt b/Documentation/driver-model/platform.txt
--- a/Documentation/driver-model/platform.txt	2007-03-17 13:20:34.000000000 -0400
+++ b/Documentation/driver-model/platform.txt	2007-03-17 13:33:57.000000000 -0400
@@ -16,7 +16,7 @@
 into system-on-chip platforms.  What they usually have in common
 is direct addressing from a CPU bus.  Rarely, a platform_device will
 be connected through a segment of some other kind of bus; but its
-registers will still be directly addressible.
+registers will still be directly addressable.
 
 Platform devices are given a name, used in driver binding, and a
 list of resources such as addresses and IRQs.
diff -ru a/Documentation/fb/imacfb.txt b/Documentation/fb/imacfb.txt
--- a/Documentation/fb/imacfb.txt	2007-02-04 13:44:54.000000000 -0500
+++ b/Documentation/fb/imacfb.txt	2007-03-17 13:33:57.000000000 -0400
@@ -17,7 +17,7 @@
 ==============
 
 Imacfb does not have any kind of autodetection of your machine.
-You have to add the fillowing kernel parameters in your elilo.conf:
+You have to add the following kernel parameters in your elilo.conf:
 	Macbook :
 		video=imacfb:macbook
 	MacMini :
diff -ru a/Documentation/filesystems/hpfs.txt b/Documentation/filesystems/hpfs.txt
--- a/Documentation/filesystems/hpfs.txt	2007-02-04 13:44:54.000000000 -0500
+++ b/Documentation/filesystems/hpfs.txt	2007-03-17 13:33:57.000000000 -0400
@@ -290,7 +290,7 @@
 2.07 More fixes for Warp Server. Now it really works
 2.08 Creating new files is not so slow on large disks
      An attempt to sync deleted file does not generate filesystem error
-2.09 Fixed error on extremly fragmented files
+2.09 Fixed error on extremely fragmented files
 
 
  vim: set textwidth=80:
diff -ru a/Documentation/filesystems/ntfs.txt b/Documentation/filesystems/ntfs.txt
--- a/Documentation/filesystems/ntfs.txt	2007-02-04 13:44:54.000000000 -0500
+++ b/Documentation/filesystems/ntfs.txt	2007-03-17 13:33:57.000000000 -0400
@@ -349,7 +349,7 @@
 Note the "Should sync?" parameter "nosync" means that the two mirrors are
 already in sync which will be the case on a clean shutdown of Windows.  If the
 mirrors are not clean, you can specify the "sync" option instead of "nosync"
-and the Device-Mapper driver will then copy the entirey of the "Source Device"
+and the Device-Mapper driver will then copy the entirety of the "Source Device"
 to the "Target Device" or if you specified multipled target devices to all of
 them.
 
diff -ru a/Documentation/filesystems/relay.txt b/Documentation/filesystems/relay.txt
--- a/Documentation/filesystems/relay.txt	2007-03-17 13:20:34.000000000 -0400
+++ b/Documentation/filesystems/relay.txt	2007-03-17 13:33:57.000000000 -0400
@@ -351,7 +351,7 @@
 the callback returns 0 to indicate that the buffer switch should not
 occur yet, i.e. until the consumer has had a chance to read the
 current set of ready sub-buffers.  For the relay_buf_full() function
-to make sense, the consumer is reponsible for notifying the relay
+to make sense, the consumer is responsible for notifying the relay
 interface when sub-buffers have been consumed via
 relay_subbufs_consumed().  Any subsequent attempts to write into the
 buffer will again invoke the subbuf_start() callback with the same
Only in b/Documentation/filesystems: relay.txt.orig
diff -ru a/Documentation/filesystems/xip.txt b/Documentation/filesystems/xip.txt
--- a/Documentation/filesystems/xip.txt	2007-02-04 13:44:54.000000000 -0500
+++ b/Documentation/filesystems/xip.txt	2007-03-17 13:33:57.000000000 -0400
@@ -19,7 +19,7 @@
 directly from/to the memory backed storage device. For file mappings, the
 storage device itself is mapped directly into userspace.
 
-This implementation was initialy written for shared memory segments between
+This implementation was initially written for shared memory segments between
 different virtual machines on s390 hardware to allow multiple machines to
 share the same binaries and libraries.
 
diff -ru a/Documentation/fujitsu/frv/gdbstub.txt b/Documentation/fujitsu/frv/gdbstub.txt
--- a/Documentation/fujitsu/frv/gdbstub.txt	2007-02-04 13:44:54.000000000 -0500
+++ b/Documentation/fujitsu/frv/gdbstub.txt	2007-03-17 13:33:57.000000000 -0400
@@ -126,5 +126,5 @@
 
 Furthermore, the GDB stub will intercept a number of exceptions automatically
 if they are caused by kernel execution. It will also intercept BUG() macro
-invokation.
+invocation.
 
diff -ru a/Documentation/input/atarikbd.txt b/Documentation/input/atarikbd.txt
--- a/Documentation/input/atarikbd.txt	2007-02-04 13:44:54.000000000 -0500
+++ b/Documentation/input/atarikbd.txt	2007-03-17 13:33:57.000000000 -0400
@@ -179,9 +179,9 @@
 the mouse. After any joystick command, the ikbd assumes that joysticks are
 connected to both Joystick0 and Joystick1. Any mouse command (except MOUSE
 DISABLE) then causes port 0 to again be scanned as if it were a mouse, and
-both buttons are logically connected to it. If a mouse diable command is
+both buttons are logically connected to it. If a mouse disable command is
 received while port 0 is presumed to be a mouse, the button is logically
-assigned to Joystick1 ( until the mouse is reenabled by another mouse command).
+assigned to Joystick1 (until the mouse is reenabled by another mouse command).
 
 9. ikbd Command Set
 
diff -ru a/Documentation/input/iforce-protocol.txt b/Documentation/input/iforce-protocol.txt
--- a/Documentation/input/iforce-protocol.txt	2007-02-04 13:44:54.000000000 -0500
+++ b/Documentation/input/iforce-protocol.txt	2007-03-17 13:33:57.000000000 -0400
@@ -7,7 +7,7 @@
 send an email to: deneux@ifrance.com
 
 ** WARNING **
-I may not be held responsible for any dammage or harm caused if you try to
+I may not be held responsible for any damage or harm caused if you try to
 send data to your I-Force device based on what you read in this document.
 
 ** Preliminary Notes:
@@ -97,7 +97,7 @@
 *** Attack and fade ***
 OP=  02
 LEN= 08
-00-01 Address where to store the parameteres
+00-01 Address where to store the parameters
 02-03 Duration of attack (little endian encoding, in ms)
 04 Level at end of attack. Signed byte.
 05-06 Duration of fade.
@@ -151,13 +151,13 @@
 Query command. Length varies according to the query type.
 The general format of this packet is:
 ff 01 QUERY [INDEX] CHECKSUM
-reponses are of the same form:
+responses are of the same form:
 FF LEN QUERY VALUE_QUERIED CHECKSUM2
 where LEN = 1 + length(VALUE_QUERIED)
 
 **** Query ram size ****
 QUERY = 42 ('B'uffer size)
-The device should reply with the same packet plus two additionnal bytes
+The device should reply with the same packet plus two additional bytes
 containing the size of the memory:
 ff 03 42 03 e8 CS would mean that the device has 1000 bytes of ram available.
 
diff -ru a/Documentation/input/xpad.txt b/Documentation/input/xpad.txt
--- a/Documentation/input/xpad.txt	2007-02-04 13:44:54.000000000 -0500
+++ b/Documentation/input/xpad.txt	2007-03-17 13:33:57.000000000 -0400
@@ -65,15 +65,15 @@
 I've tested this with Stepmania, and it works quite well.
 
 
-0.3 Unkown Controllers
+0.3 Unknown Controllers
 ----------------------
-If you have an unkown xbox controller, it should work just fine with
+If you have an unknown xbox controller, it should work just fine with
 the default settings.
 
 HOWEVER if you have an unknown dance pad not listed below, it will not
 work UNLESS you set "dpad_to_buttons" to 1 in the module configuration.
 
-PLEASE if you have an unkown controller, email Dom <binary1230@yahoo.com> with
+PLEASE, if you have an unknown controller, email Dom <binary1230@yahoo.com> with
 a dump from /proc/bus/usb and a description of the pad (manufacturer, country,
 whether it is a dance pad or normal controller) so that we can add your pad
 to the list of supported devices, ensuring that it will work out of the
diff -ru a/Documentation/MSI-HOWTO.txt b/Documentation/MSI-HOWTO.txt
--- a/Documentation/MSI-HOWTO.txt	2007-02-04 13:44:54.000000000 -0500
+++ b/Documentation/MSI-HOWTO.txt	2007-03-17 13:33:57.000000000 -0400
@@ -480,8 +480,8 @@
 
 6.1. Disabling MSI on a single device
 
-Under some circumstances, it might be required to disable MSI on a
-single device, It may be achived by either not calling pci_enable_msi()
+Under some circumstances it might be required to disable MSI on a
+single device.  This may be achieved by either not calling pci_enable_msi()
 or all, or setting the pci_dev->no_msi flag before (most of the time
 in a quirk).
 
@@ -492,7 +492,7 @@
 disabled on all devices behind this bridge. It is achieves by setting
 the PCI_BUS_FLAGS_NO_MSI flag in the pci_bus->bus_flags of the bridge
 subordinate bus. There is no need to set the same flag on bridges that
-are below the broken brigde. When pci_enable_msi() is called to enable
+are below the broken bridge. When pci_enable_msi() is called to enable
 MSI on a device, pci_msi_supported() takes care of checking the NO_MSI
 flag in all parent busses of the device.
 
diff -ru a/Documentation/netlabel/draft-ietf-cipso-ipsecurity-01.txt b/Documentation/netlabel/draft-ietf-cipso-ipsecurity-01.txt
--- a/Documentation/netlabel/draft-ietf-cipso-ipsecurity-01.txt	2007-02-04 13:44:54.000000000 -0500
+++ b/Documentation/netlabel/draft-ietf-cipso-ipsecurity-01.txt	2007-03-17 13:33:57.000000000 -0400
@@ -48,7 +48,7 @@
 intelligence communities.  They are generally available commercial systems
 for use in a variety of government and civil sector environments.
 
-The small number of ESO format codes can not support all the possible
+The small number of ESO format codes cannot support all the possible
 applications of a commercial security option.  The BSO and ESO were
 designed to only support the United States DoD.  CIPSO has been designed
 to support multiple security policies.  This Internet Draft provides the
@@ -150,7 +150,7 @@
 identifier field in the CIPSO header, implementations should assume that
 all tags, as well as fields within a tag, are not aligned on any particular
 octet boundary.   The tag types defined in this document contain alignment
-bytes to assist alignment of some information, however alignment can not
+bytes to assist alignment of some information, however alignment cannot
 be guaranteed if CIPSO is not the first IP option.
 
 CIPSO tag types 0 through 127 are reserved for defining standard tag
@@ -438,10 +438,10 @@
 IP networks.
 
 An implementation of CIPSO on a host MUST have the capability to reject a
-datagram for reasons that the information contained can not be adequately
+datagram for reasons that the information contained cannot be adequately
 protected by the receiving host or if acceptance may result in violation of
 the host or network security policy.  In addition, a CIPSO gateway or router
-MUST be able to reject datagrams going to networks that can not provide
+MUST be able to reject datagrams going to networks that cannot provide
 adequate protection or may violate the network's security policy.  To
 provide this capability the following minimal set of configuration
 parameters are required for CIPSO implementations:
@@ -599,7 +599,7 @@
 (code 10).  The value of the code field used is dependent upon whether
 the originator of the ICMP message is acting as a CIPSO host or a CIPSO
 gateway.  The recipient of the ICMP message MUST be able to handle either
-value.  The same procedure is performed if a CIPSO can not be added to an
+value.  The same procedure is performed if a CIPSO cannot be added to an
 IP packet because it is too large to fit in the IP options area.
 
 If the error is triggered by receipt of an ICMP message, the message
@@ -693,7 +693,7 @@
   a.  Use the CIPSO label of the original IP datagram
   b.  Drop the original datagram with no return message generated
 
-In most cases these options will have the same effect.  If you can not
+In most cases these options will have the same effect.  If you cannot
 interpret the label or if it is outside the label range of your host or
 interface then an ICMP message with the same label will probably not be
 able to exit the system.
diff -ru a/Documentation/networking/NAPI_HOWTO.txt b/Documentation/networking/NAPI_HOWTO.txt
--- a/Documentation/networking/NAPI_HOWTO.txt	2007-02-04 13:44:54.000000000 -0500
+++ b/Documentation/networking/NAPI_HOWTO.txt	2007-03-17 13:33:57.000000000 -0400
@@ -160,7 +160,7 @@
 it completes its work. The device cannot be out of poll list at this
 call, if it is then clearly it is a BUG(). You'll know ;->
 
-All these above nethods are used below. So keep reading for clarity.
+All of the above methods are used below, so keep reading for clarity.
 
 Device driver changes to be made when porting NAPI
 ==================================================
diff -ru a/Documentation/networking/udplite.txt b/Documentation/networking/udplite.txt
--- a/Documentation/networking/udplite.txt	2007-02-04 13:44:54.000000000 -0500
+++ b/Documentation/networking/udplite.txt	2007-03-17 13:33:57.000000000 -0400
@@ -139,7 +139,7 @@
   3) Disabling the Checksum Computation
 
   On both sender and receiver, checksumming will always be performed
-  and can not be disabled using SO_NO_CHECK. Thus
+  and cannot be disabled using SO_NO_CHECK. Thus
 
         setsockopt(sockfd, SOL_SOCKET, SO_NO_CHECK,  ... );
 
diff -ru a/Documentation/networking/wan-router.txt b/Documentation/networking/wan-router.txt
--- a/Documentation/networking/wan-router.txt	2007-02-04 13:44:54.000000000 -0500
+++ b/Documentation/networking/wan-router.txt	2007-03-17 13:33:57.000000000 -0400
@@ -336,7 +336,7 @@
 				creating applications using BiSync
    				streaming.        
 
-2.0.5   Aug 04, 1999 		CHDLC initializatin bug fix.
+2.0.5   Aug 04, 1999 		CHDLC initialization bug fix.
 				PPP interrupt driven driver: 
   				Fix to the PPP line hangup problem.
 				New PPP firmware
@@ -373,7 +373,7 @@
 				o cfgft1 GUI csu/dsu configurator
 				o wancfg GUI configuration file 
 				  configurator.
-				o Architectual directory changes.
+				o Architectural directory changes.
 
 beta-2.1.4 Jul 2000		o Dynamic interface configuration:
 					Network interfaces reflect the state
diff -ru a/Documentation/pnp.txt b/Documentation/pnp.txt
--- a/Documentation/pnp.txt	2007-02-04 13:44:54.000000000 -0500
+++ b/Documentation/pnp.txt	2007-03-17 13:33:57.000000000 -0400
@@ -140,7 +140,7 @@
 Requirements for a Linux PnP protocol:
 1.) the protocol must use EISA IDs
 2.) the protocol must inform the PnP Layer of a devices current configuration
-- the ability to set resources is optional but prefered.
+- the ability to set resources is optional but preferred.
 
 The following are PnP protocol related functions:
 
diff -ru a/Documentation/powerpc/booting-without-of.txt b/Documentation/powerpc/booting-without-of.txt
--- a/Documentation/powerpc/booting-without-of.txt	2007-03-17 13:20:34.000000000 -0400
+++ b/Documentation/powerpc/booting-without-of.txt	2007-03-17 13:33:57.000000000 -0400
@@ -193,8 +193,8 @@
   The kernel is configured for a single platform.  Part of the reason
   for this is to keep kernels on embedded systems small and efficient;
   part of this is due to the fact the code is already that way. In the
-  future, a kernel may support multiple platforms, but only if the
-  platforms feature the same core architectire.  A single kernel build
+  future a kernel may support multiple platforms, but only if the
+  platforms feature the same core architecture.  A single kernel build
   cannot support both configurations with Book E and configurations
   with classic Powerpc architectures.
 
@@ -1637,7 +1637,7 @@
      - assignment : function number of the pin according to the Pin Assignment
        tables in User Manual.  Each pin can have up to 4 possible functions in
        QE and two options for CPM.
-     - has_irq : indicates if the pin is used as source of exteral
+     - has_irq : indicates if the pin is used as source of external
        interrupts.
 
    Example:
Only in b/Documentation/powerpc: booting-without-of.txt.orig
diff -ru a/Documentation/scsi/aic7xxx_old.txt b/Documentation/scsi/aic7xxx_old.txt
--- a/Documentation/scsi/aic7xxx_old.txt	2007-02-04 13:44:54.000000000 -0500
+++ b/Documentation/scsi/aic7xxx_old.txt	2007-03-17 13:33:57.000000000 -0400
@@ -356,7 +356,7 @@
         or enable Tagged Command Queueing (TCQ) on specific devices.  As of
 	driver version 5.1.11, TCQ is now either on or off by default
 	according to the setting you choose during the make config process.
-	In order to en/disable TCQ for certian devices at boot time, a user
+	In order to en/disable TCQ for certain devices at boot time, a user
 	may use this boot param.  The driver will then parse this message out
         and en/disable the specific device entries that are present based upon
         the value given.  The param line is parsed in the following manner:
diff -ru a/Documentation/scsi/aic7xxx.txt b/Documentation/scsi/aic7xxx.txt
--- a/Documentation/scsi/aic7xxx.txt	2007-02-04 13:44:54.000000000 -0500
+++ b/Documentation/scsi/aic7xxx.txt	2007-03-17 13:33:57.000000000 -0400
@@ -40,7 +40,7 @@
    2.   Multi-function Twin Channel Device - Two controllers on one chip.
    3.   Command Channel Secondary DMA Engine - Allows scatter gather list
         and SCB prefetch.
-   4.   64 Byte SCB Support - Allows disconnected, unttagged request table
+   4.   64 Byte SCB Support - Allows disconnected, untagged request table
         for all possible target/lun combinations.
    5.   Block Move Instruction Support - Doubles the speed of certain
         sequencer operations.
diff -ru a/Documentation/scsi/ncr53c8xx.txt b/Documentation/scsi/ncr53c8xx.txt
--- a/Documentation/scsi/ncr53c8xx.txt	2007-02-04 13:44:54.000000000 -0500
+++ b/Documentation/scsi/ncr53c8xx.txt	2007-03-17 13:33:57.000000000 -0400
@@ -1265,7 +1265,7 @@
 15.1 Problem tracking
 
 Most SCSI problems are due to a non conformant SCSI bus or to buggy
-devices.  If infortunately you have SCSI problems, you can check the
+devices.  If unfortunately you have SCSI problems, you can check the
 following things:
 
 - SCSI bus cables
diff -ru a/Documentation/scsi/sym53c8xx_2.txt b/Documentation/scsi/sym53c8xx_2.txt
--- a/Documentation/scsi/sym53c8xx_2.txt	2007-02-04 13:44:54.000000000 -0500
+++ b/Documentation/scsi/sym53c8xx_2.txt	2007-03-17 13:33:57.000000000 -0400
@@ -587,7 +587,7 @@
 15.1 Problem tracking
 
 Most SCSI problems are due to a non conformant SCSI bus or too buggy
-devices.  If infortunately you have SCSI problems, you can check the
+devices.  If unfortunately you have SCSI problems, you can check the
 following things:
 
 - SCSI bus cables
diff -ru a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt	2007-02-04 13:44:54.000000000 -0500
+++ b/Documentation/sysctl/kernel.txt	2007-03-17 13:33:57.000000000 -0400
@@ -221,7 +221,7 @@
 
 0: try to continue operation
 
-1: panic immediatly.  If the `panic' sysctl is also non-zero then the
+1: panic immediately.  If the `panic' sysctl is also non-zero then the
    machine will be rebooted.
 
 ==============================================================
Only in b/Documentation/sysctl: kernel.txt.orig
diff -ru a/drivers/ata/Kconfig b/drivers/ata/Kconfig
--- a/drivers/ata/Kconfig	2007-03-17 13:20:56.000000000 -0400
+++ b/drivers/ata/Kconfig	2007-03-17 13:47:42.000000000 -0400
@@ -430,7 +430,7 @@
 	help
 	  This option enables DMA/PIO support for the later OPTi
 	  controllers found on some old motherboards and in some
-	  latops
+	  laptops.
 
 	  If unsure, say N.
 
diff -ru a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
--- a/drivers/crypto/Kconfig	2007-03-17 13:20:56.000000000 -0400
+++ b/drivers/crypto/Kconfig	2007-03-17 13:37:13.000000000 -0400
@@ -61,7 +61,7 @@
 	default m
 	help
 	  Say 'Y' here to use the AMD Geode LX processor on-board AES
-	  engine for the CryptoAPI AES alogrithm.
+	  engine for the CryptoAPI AES algorithm.
 
 	  To compile this driver as a module, choose M here: the module
 	  will be called geode-aes.
diff -ru a/drivers/isdn/capi/Kconfig b/drivers/isdn/capi/Kconfig
--- a/drivers/isdn/capi/Kconfig	2007-03-17 13:20:56.000000000 -0400
+++ b/drivers/isdn/capi/Kconfig	2007-03-17 13:40:36.000000000 -0400
@@ -17,7 +17,7 @@
 	help
 	  If you say Y here, the kernelcapi driver can make verbose traces
 	  of CAPI messages. This feature can be enabled/disabled via IOCTL for
-	  every controler (default disabled).
+	  every controller (default disabled).
 	  This will increase the size of the kernelcapi module by 20 KB.
 	  If unsure, say Y.
 
diff -ru a/drivers/media/video/pwc/philips.txt b/drivers/media/video/pwc/philips.txt
--- a/drivers/media/video/pwc/philips.txt	2007-02-04 13:44:54.000000000 -0500
+++ b/drivers/media/video/pwc/philips.txt	2007-03-17 13:33:57.000000000 -0400
@@ -54,9 +54,9 @@
    Specifies the desired framerate. Is an integer in the range of 4-30.
 
 fbufs
-   This paramter specifies the number of internal buffers to use for storing
+   This parameter specifies the number of internal buffers to use for storing
    frames from the cam. This will help if the process that reads images from
-   the cam is a bit slow or momentarely busy. However, on slow machines it
+   the cam is a bit slow or momentarily busy. However, on slow machines it
    only introduces lag, so choose carefully. The default is 3, which is
    reasonable. You can set it between 2 and 5.
 
@@ -209,7 +209,7 @@
 
      128   0x80   PWCX debugging                                      Off
 
-   For example, to trace the open() & read() fuctions, sum 8 + 4 = 12,
+   For example, to trace the open() & read() functions, sum 8 + 4 = 12,
    so you would supply trace=12 during insmod or modprobe. If
    you want to turn the initialization and probing tracing off, set trace=0.
    The default value for trace is 35 (0x23).
diff -ru a/drivers/message/fusion/lsi/mpi_history.txt b/drivers/message/fusion/lsi/mpi_history.txt
--- a/drivers/message/fusion/lsi/mpi_history.txt	2007-03-17 13:20:57.000000000 -0400
+++ b/drivers/message/fusion/lsi/mpi_history.txt	2007-03-17 13:33:57.000000000 -0400
@@ -571,7 +571,7 @@
  *  11-02-00  01.01.01  Original release for post 1.0 work
  *  12-04-00  01.01.02  Added messages for Common Transport Send and
  *                      Primitive Send.
- *  01-09-01  01.01.03  Modifed some of the new flags to have an MPI prefix
+ *  01-09-01  01.01.03  Modified some of the new flags to have an MPI prefix
  *                      and modified the FcPrimitiveSend flags.
  *  01-25-01  01.01.04  Move InitiatorIndex in LinkServiceRsp reply to a larger
  *                      field.
Only in b/drivers/message/fusion/lsi: mpi_history.txt.orig
diff -ru a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
--- a/drivers/mtd/maps/Kconfig	2007-03-17 13:20:57.000000000 -0400
+++ b/drivers/mtd/maps/Kconfig	2007-03-17 13:41:59.000000000 -0400
@@ -61,7 +61,7 @@
 	  (i.e., run-time calling physmap_configure()).
 
 config MTD_PHYSMAP_OF
-	tristate "Flash device in physical memory map based on OF descirption"
+	tristate "Flash device in physical memory map based on OF description"
 	depends on PPC_OF && (MTD_CFI || MTD_JEDECPROBE || MTD_ROM)
 	help
 	  This provides a 'mapping' driver which allows the NOR Flash and
diff -ru a/drivers/usb/serial/Kconfig b/drivers/usb/serial/Kconfig
--- a/drivers/usb/serial/Kconfig	2007-02-04 13:44:54.000000000 -0500
+++ b/drivers/usb/serial/Kconfig	2007-03-17 13:51:24.000000000 -0400
@@ -558,7 +558,7 @@
 	tristate "USB Debugging Device"
 	depends on USB_SERIAL
 	help
-	  Say Y here if you have a USB debugging device used to recieve
+	  Say Y here if you have a USB debugging device used to receive
 	  debugging data from another machine.  The most common of these
 	  devices is the NetChip TurboCONNECT device.
 
diff -ru a/drivers/video/Kconfig b/drivers/video/Kconfig
--- a/drivers/video/Kconfig	2007-03-17 13:21:35.000000000 -0400
+++ b/drivers/video/Kconfig	2007-03-17 13:43:41.000000000 -0400
@@ -139,7 +139,7 @@
 	 This is particularly important to one driver, matroxfb.  If
 	 unsure, say N.
 
-comment "Frambuffer hardware drivers"
+comment "Framebuffer hardware drivers"
 	depends on FB
 
 config FB_CIRRUS
diff -ru a/net/ipv4/Kconfig b/net/ipv4/Kconfig
--- a/net/ipv4/Kconfig	2007-03-17 13:21:44.000000000 -0400
+++ b/net/ipv4/Kconfig	2007-03-17 13:52:38.000000000 -0400
@@ -624,7 +624,7 @@
 	select CRYPTO
 	select CRYPTO_MD5
 	---help---
-	  RFC2385 specifices a method of giving MD5 protection to TCP sessions.
+	  RFC2385 specifies a method of giving MD5 protection to TCP sessions.
 	  Its main (only?) use is to protect BGP sessions between core routers
 	  on the Internet.
 
diff -ru a/security/selinux/Kconfig b/security/selinux/Kconfig
--- a/security/selinux/Kconfig	2007-02-04 13:44:54.000000000 -0500
+++ b/security/selinux/Kconfig	2007-03-17 13:43:14.000000000 -0400
@@ -137,7 +137,7 @@
 
 	  Examples:
 	  For the Fedora Core 3 or 4 Linux distributions, enable this option
-	  and set the value via the next option. For Fedore Core 5 and later,
+	  and set the value via the next option. For Fedora Core 5 and later,
 	  do not enable this option.
 
 	  If you are unsure how to answer this question, answer N.
diff -ru a/sound/core/Kconfig b/sound/core/Kconfig
--- a/sound/core/Kconfig	2007-02-04 13:44:54.000000000 -0500
+++ b/sound/core/Kconfig	2007-03-17 13:54:28.000000000 -0400
@@ -146,7 +146,7 @@
 	default y
 	help
 	  Say Y here to include code for verbose procfs contents (provides
-          usefull information to developers when a problem occurs). On the
+          useful information to developers when a problem occurs).  On the
           other side, it makes the ALSA subsystem larger.
 
 config SND_VERBOSE_PRINTK


