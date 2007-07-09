Return-Path: <linux-kernel-owner+w=401wt.eu-S1757964AbXGIRtH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964AbXGIRtH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 13:49:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128AbXGIRs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 13:48:56 -0400
Received: from sccrmhc12.comcast.net ([63.240.77.82]:58325 "EHLO
	sccrmhc12.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033AbXGIRsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 13:48:54 -0400
Date: Mon, 9 Jul 2007 13:45:16 -0400
From: Matt LaPlante <kernel1@cyberdogtech.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org
Subject: [PATCH] 2.6.22 - Documentation Cleanup
Message-Id: <20070709134516.f5e7dc07.kernel1@cyberdogtech.com>
X-Mailer: Sylpheed 2.4.0 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Processed: mail.cyberdogtech.com, Mon, 09 Jul 2007 13:45:22 -0400
	(not processed: message from valid local sender)
X-Return-Path: kernel1@cyberdogtech.com
X-Envelope-From: kernel1@cyberdogtech.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
X-MDAV-Processed: mail.cyberdogtech.com, Mon, 09 Jul 2007 13:45:23 -0400
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix misc small issues/typos/grammar in Documentation txts for 2.6.22.

Signed-off-by: Matt LaPlante <kernel1@cyberdogtech.com>
--

diff -ru a/Documentation/arm/Samsung-S3C24XX/DMA.txt b/Documentation/arm/Samsung-S3C24XX/DMA.txt
--- a/Documentation/arm/Samsung-S3C24XX/DMA.txt	2007-07-08 19:32:17.000000000 -0400
+++ b/Documentation/arm/Samsung-S3C24XX/DMA.txt	2007-07-08 23:11:21.000000000 -0400
@@ -17,15 +17,15 @@
    channels to all sources, which means that some devices
    have a restricted number of channels that can be used.
 
-   To allow flexibilty for each cpu type and board, the
-   dma code can be given an dma ordering structure which
+   To allow flexibility for each cpu type and board, the
+   DMA code can be given a DMA ordering structure which
    allows the order of channel search to be specified, as
    well as allowing the prohibition of certain claims.
 
    struct s3c24xx_dma_order has a list of channels, and
-   each channel within has a slot for a list of dma
-   channel numbers. The slots are searched in order, for
-   the presence of a dma channel number with DMA_CH_VALID
+   each channel within has a slot for a list of DMA
+   channel numbers. The slots are searched in order for
+   the presence of a DMA channel number with DMA_CH_VALID
    orred in.
 
    If the order has the flag DMA_CH_NEVER set, then after
@@ -33,8 +33,8 @@
    found channel, thus denying the request.
 
    A board support file can call s3c24xx_dma_order_set()
-   to register an complete ordering set. The routine will
-   copy the data, so the original can be discared with
+   to register a complete ordering set. The routine will
+   copy the data, so the original can be discarded with
    __initdata.
 
 
diff -ru a/Documentation/devices.txt b/Documentation/devices.txt
--- a/Documentation/devices.txt	2007-07-08 19:32:17.000000000 -0400
+++ b/Documentation/devices.txt	2007-07-08 23:46:00.000000000 -0400
@@ -2186,7 +2186,7 @@
 
 136-143 char	Unix98 PTY slaves
 		  0 = /dev/pts/0	First Unix98 pseudo-TTY
-		  1 = /dev/pts/1	Second Unix98 pesudo-TTY
+		  1 = /dev/pts/1	Second Unix98 pseudo-TTY
 		    ...
 
 		These device nodes are automatically generated with
diff -ru a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
--- a/Documentation/driver-model/devres.txt	2007-07-08 19:32:17.000000000 -0400
+++ b/Documentation/driver-model/devres.txt	2007-07-09 12:19:28.000000000 -0400
@@ -32,7 +32,7 @@
 
 For one reason or another, low level drivers don't receive as much
 attention or testing as core code, and bugs on driver detach or
-initilaization failure doesn't happen often enough to be noticeable.
+initialization failure doesn't happen often enough to be noticeable.
 Init failure path is worse because it's much less travelled while
 needs to handle multiple entry points.
 
@@ -160,7 +160,7 @@
   devres_release_group(dev, NULL);
   return err_code;
 
-As resource acquision failure usually means probe failure, constructs
+As resource acquisition failure usually means probe failure, constructs
 like above are usually useful in midlayer driver (e.g. libata core
 layer) where interface function shouldn't have side effect on failure.
 For LLDs, just returning error code suffices in most cases.
diff -ru a/Documentation/fb/deferred_io.txt b/Documentation/fb/deferred_io.txt
--- a/Documentation/fb/deferred_io.txt	2007-07-08 19:32:17.000000000 -0400
+++ b/Documentation/fb/deferred_io.txt	2007-07-08 22:59:22.000000000 -0400
@@ -3,7 +3,7 @@
 
 Deferred IO is a way to delay and repurpose IO. It uses host memory as a
 buffer and the MMU pagefault as a pretrigger for when to perform the device
-IO. The following example may be a useful explaination of how one such setup
+IO. The following example may be a useful explanation of how one such setup
 works:
 
 - userspace app like Xfbdev mmaps framebuffer
@@ -28,7 +28,7 @@
 
 For some types of nonvolatile high latency displays, the desired image is
 the final image rather than the intermediate stages which is why it's okay
-to not update for each write that is occuring.
+to not update for each write that is occurring.
 
 It may be the case that this is useful in other scenarios as well. Paul Mundt
 has mentioned a case where it is beneficial to use the page count to decide
diff -ru a/Documentation/filesystems/9p.txt b/Documentation/filesystems/9p.txt
--- a/Documentation/filesystems/9p.txt	2007-07-08 19:32:17.000000000 -0400
+++ b/Documentation/filesystems/9p.txt	2007-07-09 12:22:03.000000000 -0400
@@ -40,7 +40,7 @@
   aname=name	aname specifies the file tree to access when the server is
   		offering several exported file systems.
 
-  cache=mode	specifies a cacheing policy.  By default, no caches are used.
+  cache=mode	specifies a caching policy.  By default, no caches are used.
 			loose = no attempts are made at consistency,
                                 intended for exclusive, read-only mounts
 
diff -ru a/Documentation/ia64/err_inject.txt b/Documentation/ia64/err_inject.txt
--- a/Documentation/ia64/err_inject.txt	2007-07-08 19:32:17.000000000 -0400
+++ b/Documentation/ia64/err_inject.txt	2007-07-08 23:55:10.000000000 -0400
@@ -21,10 +21,10 @@
 
 Below is a sample application as part of the whole tool. The sample
 can be used as a working test tool. Or it can be expanded to include
-more features. It also can be a integrated into a libary or other user
+more features. It also can be a integrated into a library or other user
 application to have more thorough test.
 
-The sample application takes err.conf as error configuation input. Gcc
+The sample application takes err.conf as error configuration input. GCC
 compiles the code. After you install err_inject driver, you can run
 this sample application to inject errors.
 
@@ -809,7 +809,7 @@
 	}
 
 	/* Create semaphore: If one_lock, one semaphore for all processors.
-	   Otherwise, one sempaphore for each processor. */
+	   Otherwise, one semaphore for each processor. */
 	if (one_lock) {
 		if (create_sem(0)) {
 			printf("Can not create semaphore...exit\n");
diff -ru a/Documentation/input/atarikbd.txt b/Documentation/input/atarikbd.txt
--- a/Documentation/input/atarikbd.txt	2007-07-08 19:32:17.000000000 -0400
+++ b/Documentation/input/atarikbd.txt	2007-07-08 23:27:26.000000000 -0400
@@ -170,7 +170,7 @@
 keys. Any keys down at power-up are presumed to be stuck, and their BREAK
 (sic) code is returned (which without the preceding MAKE code is a flag for a
 keyboard error). If the controller self-test completes without error, the code
-0xF0 is returned. (This code will be used to indicate the version/rlease of
+0xF0 is returned. (This code will be used to indicate the version/release of
 the ikbd controller. The first release of the ikbd is version 0xF0, should
 there be a second release it will be 0xF1, and so on.)
 The ikbd defaults to a mouse position reporting with threshold of 1 unit in
@@ -413,7 +413,7 @@
             %nnnnmmmm   ; where m is JOYSTICK1 state
                         ; and n is JOYSTICK0 state
 
-Sets the ikbd to do nothing but monitor the serial command lne, maintain the
+Sets the ikbd to do nothing but monitor the serial command line, maintain the
 time-of-day clock, and monitor the joystick. The rate sets the interval
 between joystick samples.
 N.B. The user should not set the rate higher than the serial communications
@@ -446,10 +446,10 @@
                         ; until vertical cursor key is generated before RY
                         ; has elapsed
     VX                  ; length (in tenths of seconds) of joystick closure
-                        ; until horizontal cursor keystokes are generated
+                        ; until horizontal cursor keystrokes are generated
                         ; after RX has elapsed
     VY                  ; length (in tenths of seconds) of joystick closure
-                        ; until vertical cursor keystokes are generated
+                        ; until vertical cursor keystrokes are generated
                         ; after RY has elapsed
 
 In this mode, joystick 0 is scanned in a way that simulates cursor keystrokes.
diff -ru a/Documentation/input/iforce-protocol.txt b/Documentation/input/iforce-protocol.txt
--- a/Documentation/input/iforce-protocol.txt	2007-07-08 19:32:17.000000000 -0400
+++ b/Documentation/input/iforce-protocol.txt	2007-07-08 22:26:12.000000000 -0400
@@ -7,7 +7,7 @@
 send an email to: deneux@ifrance.com
 
 ** WARNING **
-I may not be held responsible for any dammage or harm caused if you try to
+I may not be held responsible for any damage or harm caused if you try to
 send data to your I-Force device based on what you read in this document.
 
 ** Preliminary Notes:
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
 
@@ -239,7 +239,7 @@
 3. Play the effect, and watch what happens on the spy screen.
 
 A few words about ComPortSpy:
-At first glance, this soft seems, hum, well... buggy. In fact, data appear with a few seconds latency. Personnaly, I restart it every time I play an effect.
+At first glance, this soft seems, hum, well... buggy. In fact, data appear with a few seconds latency. Personally, I restart it every time I play an effect.
 Remember it's free (as in free beer) and alpha!
 
 ** URLS **
diff -ru a/Documentation/input/input-programming.txt b/Documentation/input/input-programming.txt
--- a/Documentation/input/input-programming.txt	2007-07-08 19:32:17.000000000 -0400
+++ b/Documentation/input/input-programming.txt	2007-07-08 22:32:20.000000000 -0400
@@ -79,7 +79,7 @@
 booting the kernel, it grabs the required resources (it should also check
 for the presence of the device).
 
-Then it allocates a new input device structure with input_aloocate_device()
+Then it allocates a new input device structure with input_allocate_device()
 and sets up input bitfields. This way the device driver tells the other
 parts of the input systems what it is - what events can be generated or
 accepted by this input device. Our example device can only generate EV_KEY
diff -ru a/Documentation/kdump/kdump.txt b/Documentation/kdump/kdump.txt
--- a/Documentation/kdump/kdump.txt	2007-07-08 19:32:17.000000000 -0400
+++ b/Documentation/kdump/kdump.txt	2007-07-08 23:35:58.000000000 -0400
@@ -69,7 +69,7 @@
 
 This is a symlink to the latest version, which at the time of writing is
 20061214, the only release of kexec-tools-testing so far. As other versions
-are made released, the older onese will remain available at
+are released, the older ones will remain available at
 http://www.kernel.org/pub/linux/kernel/people/horms/kexec-tools/
 
 Note: Latest kexec-tools-testing git tree is available at
@@ -108,7 +108,7 @@
 
 2) Or use the system kernel binary itself as dump-capture kernel and there is
    no need to build a separate dump-capture kernel. This is possible
-   only with the architecutres which support a relocatable kernel. As
+   only with the architectures which support a relocatable kernel. As
    of today i386 and ia64 architectures support relocatable kernel.
 
 Building a relocatable kernel is advantageous from the point of view that
@@ -235,7 +235,7 @@
 ----------------------------------------------------------
 
 - No specific options are required to create a dump-capture kernel
-  for ia64, other than those specified in the arch idependent section
+  for ia64, other than those specified in the arch independent section
   above. This means that it is possible to use the system kernel
   as a dump-capture kernel if desired.
 
@@ -360,7 +360,7 @@
 is called inside interrupt context or die() is called and panic_on_oops is set,
 the system will boot into the dump-capture kernel.
 
-On powererpc systems when a soft-reset is generated, die() is called by all cpus
+On PowerPC systems when a soft-reset is generated, die() is called by all cpus
 and the system will boot into the dump-capture kernel.
 
 For testing purposes, you can trigger a crash by using "ALT-SysRq-c",
diff -ru a/Documentation/kernel-docs.txt b/Documentation/kernel-docs.txt
--- a/Documentation/kernel-docs.txt	2007-07-08 19:32:17.000000000 -0400
+++ b/Documentation/kernel-docs.txt	2007-07-08 23:38:30.000000000 -0400
@@ -76,9 +76,9 @@
      * Title: "Conceptual Architecture of the Linux Kernel"
        Author: Ivan T. Bowman.
        URL: http://plg.uwaterloo.ca/~itbowman/papers/CS746G-a1.html
-       Keywords: conceptual software arquitecture, extracted design,
+       Keywords: conceptual software architecture, extracted design,
        reverse engineering, system structure.
-       Description: Conceptual software arquitecture of the Linux kernel,
+       Description: Conceptual software architecture of the Linux kernel,
        automatically extracted from the source code. Very detailed. Good
        figures. Gives good overall kernel understanding.
 
diff -ru a/Documentation/networking/bcm43xx.txt b/Documentation/networking/bcm43xx.txt
--- a/Documentation/networking/bcm43xx.txt	2007-07-08 19:32:17.000000000 -0400
+++ b/Documentation/networking/bcm43xx.txt	2007-07-08 23:00:01.000000000 -0400
@@ -37,7 +37,7 @@
 required. The firmware used by the chip is the intellectual property
 of Broadcom and they have not given the bcm43xx team redistribution
 rights to this firmware.  Since we cannot legally redistribute
-the firwmare we cannot include it with the driver. Furthermore, it
+the firmware we cannot include it with the driver. Furthermore, it
 cannot be placed in the downloadable archives of any distributing
 organization; therefore, the user is responsible for obtaining the
 firmware and placing it in the appropriate location so that the driver
diff -ru a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
--- a/Documentation/networking/ip-sysctl.txt	2007-07-08 19:32:17.000000000 -0400
+++ b/Documentation/networking/ip-sysctl.txt	2007-07-08 22:51:42.000000000 -0400
@@ -286,7 +286,7 @@
 	when the connection closes, so that connections established in the
 	near future can use these to set initial conditions.  Usually, this
 	increases overall performance, but may sometimes cause performance
-	degredation.  If set, TCP will not cache metrics on closing
+	degradation.  If set, TCP will not cache metrics on closing
 	connections.
 
 tcp_orphan_retries - INTEGER
diff -ru a/Documentation/networking/rxrpc.txt b/Documentation/networking/rxrpc.txt
--- a/Documentation/networking/rxrpc.txt	2007-07-08 19:32:17.000000000 -0400
+++ b/Documentation/networking/rxrpc.txt	2007-07-09 12:16:45.000000000 -0400
@@ -689,7 +689,7 @@
      buffers manipulated directly.
 
 To use the RxRPC facility, a kernel utility must still open an AF_RXRPC socket,
-bind an addess as appropriate and listen if it's to be a server socket, but
+bind an address as appropriate and listen if it's to be a server socket, but
 then it passes this to the kernel interface functions.
 
 The kernel interface functions are as follows:
diff -ru a/Documentation/networking/udplite.txt b/Documentation/networking/udplite.txt
--- a/Documentation/networking/udplite.txt	2007-07-08 19:32:17.000000000 -0400
+++ b/Documentation/networking/udplite.txt	2007-07-08 23:13:39.000000000 -0400
@@ -12,7 +12,7 @@
   For in-depth information, you can consult:
 
    o The UDP-Lite Homepage: http://www.erg.abdn.ac.uk/users/gerrit/udp-lite/
-       Fom here you can also download some example application source code.
+       From here you can also download some example application source code.
 
    o The UDP-Lite HOWTO on
        http://www.erg.abdn.ac.uk/users/gerrit/udp-lite/files/UDP-Lite-HOWTO.txt
@@ -223,7 +223,7 @@
   While it is important that such cases are dealt with correctly, they
   are (annoyingly) rare: UDP-Lite is designed for optimising multimedia
   performance over wireless (or generally noisy) links and thus smaller
-  coverage lenghts are likely to be expected.
+  coverage lengths are likely to be expected.
 
 
   V) UDP-LITE RUNTIME STATISTICS AND THEIR MEANING
@@ -259,7 +259,7 @@
   VI) IPTABLES
 
   There is packet match support for UDP-Lite as well as support for the LOG target.
-  If you copy and paste the following line into /etc/protcols,
+  If you copy and paste the following line into /etc/protocols,
 
   udplite 136     UDP-Lite        # UDP-Lite [RFC 3828]
 
diff -ru a/Documentation/power/swsusp-and-swap-files.txt b/Documentation/power/swsusp-and-swap-files.txt
--- a/Documentation/power/swsusp-and-swap-files.txt	2007-07-08 19:32:17.000000000 -0400
+++ b/Documentation/power/swsusp-and-swap-files.txt	2007-07-08 22:52:59.000000000 -0400
@@ -39,7 +39,7 @@
 where <swap_file_partition> is the partition on which the swap file is located
 and <swap_file_offset> is the offset of the swap header determined by the
 application in 2) (of course, this step may be carried out automatically
-by the same application that determies the swap file's header offset using the
+by the same application that determines the swap file's header offset using the
 FIBMAP ioctl)
 
 OR
diff -ru a/Documentation/powerpc/eeh-pci-error-recovery.txt b/Documentation/powerpc/eeh-pci-error-recovery.txt
--- a/Documentation/powerpc/eeh-pci-error-recovery.txt	2007-07-08 19:32:17.000000000 -0400
+++ b/Documentation/powerpc/eeh-pci-error-recovery.txt	2007-07-08 23:07:26.000000000 -0400
@@ -36,7 +36,7 @@
 EEH was originally designed to guard against hardware failure, such
 as PCI cards dying from heat, humidity, dust, vibration and bad
 electrical connections. The vast majority of EEH errors seen in
-"real life" are due to eithr poorly seated PCI cards, or,
+"real life" are due to either poorly seated PCI cards, or,
 unfortunately quite commonly, due device driver bugs, device firmware
 bugs, and sometimes PCI card hardware bugs.
 
diff -ru a/Documentation/powerpc/mpc52xx-device-tree-bindings.txt b/Documentation/powerpc/mpc52xx-device-tree-bindings.txt
--- a/Documentation/powerpc/mpc52xx-device-tree-bindings.txt	2007-07-08 19:32:17.000000000 -0400
+++ b/Documentation/powerpc/mpc52xx-device-tree-bindings.txt	2007-07-08 22:24:35.000000000 -0400
@@ -17,12 +17,12 @@
 describes what devices are present on the board and how they are
 connected.  The device tree can either be passed as a binary blob (as
 described in Documentation/powerpc/booting-without-of.txt), or passed
-by Open Firmare (IEEE 1275) compatible firmware using an OF compatible
+by Open Firmware (IEEE 1275) compatible firmware using an OF compatible
 client interface API.
 
 This document specifies the requirements on the device-tree for mpc5200
 based boards.  These requirements are above and beyond the details
-specified in either the OpenFirmware spec or booting-without-of.txt
+specified in either the Open Firmware spec or booting-without-of.txt
 
 All new mpc5200-based boards are expected to match this document.  In
 cases where this document is not sufficient to support a new board port,
@@ -73,8 +73,8 @@
 selected.
 
 The split between the MPC5200 and the MPC5200B leaves a bit of a
-connundrum.  How should the compatible property be set up to provide
-maximum compatability information; but still acurately describe the
+conundrum.  How should the compatible property be set up to provide
+maximum compatibility information; but still accurately describe the
 chip?  For the MPC5200; the answer is easy.  Most of the SoC devices
 originally appeared on the MPC5200.  Since they didn't exist anywhere
 else; the 5200 compatible properties will contain only one item;
@@ -84,7 +84,7 @@
 silicon bugs and it adds a small number of enhancements.  Most of the
 devices either provide exactly the same interface as on the 5200.  A few
 devices have extra functions but still have a backwards compatible mode.
-To express this infomation as completely as possible, 5200B device trees
+To express this information as completely as possible, 5200B device trees
 should have two items in the compatible list;
 "mpc5200b-<device>\0mpc5200-<device>".  It is *strongly* recommended
 that 5200B device trees follow this convention (instead of only listing
@@ -199,7 +199,7 @@
 ata@<addr>	ata		mpc5200-ata	  IDE ATA interface
 i2c@<addr>	i2c		mpc5200-i2c	  I2C controller
 usb@<addr>	usb-ohci-be	mpc5200-ohci,ohci-be	USB controller
-xlb@<addr>	xlb		mpc5200-xlb	  XLB arbritrator
+xlb@<addr>	xlb		mpc5200-xlb	  XLB arbitrator
 
 Important child node properties
 name		type		description
diff -ru a/Documentation/scsi/aic79xx.txt b/Documentation/scsi/aic79xx.txt
--- a/Documentation/scsi/aic79xx.txt	2007-07-08 19:32:17.000000000 -0400
+++ b/Documentation/scsi/aic79xx.txt	2007-07-08 23:21:13.000000000 -0400
@@ -120,7 +120,7 @@
           list size to avoid SCSI malloc pool fragmentation.
         - Cleanup channel display in our /proc output.
         - Workaround duplicate device entries in the mid-layer
-          devlice list during add-single-device.
+          device list during add-single-device.
 
    1.3.6 (March 28th, 2003)
         - Correct a double free in the Domain Validation code.
diff -ru a/Documentation/scsi/aic7xxx.txt b/Documentation/scsi/aic7xxx.txt
--- a/Documentation/scsi/aic7xxx.txt	2007-07-08 19:32:17.000000000 -0400
+++ b/Documentation/scsi/aic7xxx.txt	2007-07-08 23:19:47.000000000 -0400
@@ -159,7 +159,7 @@
         - Add support for 2.5.X's scsi_report_device_reset().
 
    6.2.34 (May 5th, 2003)
-        - Fix locking regression instroduced in 6.2.29 that
+        - Fix locking regression introduced in 6.2.29 that
           could cause a lock order reversal between the io_request_lock
           and our per-softc lock.  This was only possible on RH9,
           SuSE, and kernel.org 2.4.X kernels.
@@ -264,7 +264,7 @@
               Option: tag_info:{{value[,value...]}[,{value[,value...]}...]}
           Definition: Set the per-target tagged queue depth on a
                       per controller basis.  Both controllers and targets
-                      may be ommitted indicating that they should retain
+                      may be omitted indicating that they should retain
                       the default tag depth.
             Examples: tag_info:{{16,32,32,64,8,8,,32,32,32,32,32,32,32,32,32}
                         On Controller 0
@@ -290,7 +290,7 @@
    -----------------------------------------------------------------
               Option: dv: {value[,value...]} 
           Definition: Set Domain Validation Policy on a per-controller basis.
-                      Controllers may be ommitted indicating that
+                      Controllers may be omitted indicating that
                       they should retain the default read streaming setting.
              Example: dv:{-1,0,,1,1,0}
                         On Controller 0 leave DV at its default setting.
diff -ru a/Documentation/scsi/ibmmca.txt b/Documentation/scsi/ibmmca.txt
--- a/Documentation/scsi/ibmmca.txt	2007-07-08 19:32:17.000000000 -0400
+++ b/Documentation/scsi/ibmmca.txt	2007-07-09 12:47:52.000000000 -0400
@@ -21,7 +21,7 @@
    versions older than 4.0 do not work with kernels 2.4.0 or later! If you
    try to compile your kernel with the wrong driver source, the 
    compilation is aborted and you get a corresponding error message. This is
-   no bug in the driver. It prevents you from using the wrong sourcecode
+   no bug in the driver; it prevents you from using the wrong source code
    with the wrong kernel version.
 
    Authors of this Driver
@@ -58,7 +58,7 @@
    5 Users' Manual
      5.1 Commandline Parameters
      5.2 Troubleshooting
-     5.3 Bugreports
+     5.3 Bug reports
      5.4 Support WWW-page
    6 References
    7 Credits to
@@ -72,12 +72,12 @@
    1 Abstract
    ----------
    This README-file describes the IBM SCSI-subsystem low level driver for 
-   Linux. The descriptions which were formerly kept in the source-code have 
-   been taken out to this file to easify the codes' readability. The driver 
+   Linux. The descriptions which were formerly kept in the source code have 
+   been taken out of this file to simplify the codes readability. The driver 
    description has been updated, as most of the former description was already
    quite outdated. The history of the driver development is also kept inside 
    here. Multiple historical developments have been summarized to shorten the 
-   textsize a bit. At the end of this file you can find a small manual for 
+   text size a bit. At the end of this file you can find a small manual for 
    this driver and hints to get it running on your machine.
 
    2 Driver Description
@@ -186,7 +186,7 @@
    between 0 and 7). The IBM SCSI-2 F/W adapter offers this on up to two
    busses and provides support for 30 logical devices at the same time, where
    in wide-addressing mode you can have 16 puns with 32 luns on each device.
-   This section dexribes you the handling of devices on non-F/W adapters.
+   This section describes the handling of devices on non-F/W adapters.
    Just imagine, that you can have 16 * 32 = 512 devices on a F/W adapter
    which means a lot of possible devices for such a small machine.
 
@@ -251,7 +251,7 @@
    lun>0 or to non-existing devices, in order to satisfy the subsystem, if 
    there are less than 15 SCSI-devices connected. In the case of more than 15 
    devices, the dynamical mapping goes active. If the get_scsi[][] reports a 
-   device to be existant, but it has no ldn assigned, it gets a ldn out of 7 
+   device to be existent, but it has no ldn assigned, it gets a ldn out of 7 
    to 14. The numbers are assigned in cyclic order. Therefore it takes 8 
    dynamical reassignments on the SCSI-devices, until a certain device 
    loses its ldn again. This assures that dynamical remapping is avoided 
@@ -551,7 +551,7 @@
       than devices are available, they are assigned to non existing pun,lun
       combinations to satisfy the adapter. With this, the dynamical mapping
       was possible to implement. (For further info see the text in the 
-      source-code and in the description below. Read the description
+      source code and in the description below. Read the description
       below BEFORE installing this driver on your system!)
    2) Changed the name IBMMCA_DRIVER_VERSION to IBMMCA_SCSI_DRIVER_VERSION.
    3) The LED-display shows on PS/2-95 no longer the ldn, but the SCSI-ID
@@ -762,9 +762,9 @@
    - Michael Lang
 
    Apr 23, 2000 (v3.2pre1)
-   1) During a very long time, I collected a huge amount of bugreports from
+   1) During a very long time, I collected a huge amount of bug reports from
       various people, trying really quite different things on their SCSI-
-      PS/2s. Today, all these bugreports are taken into account and should be
+      PS/2s. Today, all these bug reports are taken into account and should be
       mostly solved. The major topics were:
       - Driver crashes during boottime by no obvious reason.
       - Driver panics while the midlevel-SCSI-driver is trying to inquire
@@ -819,7 +819,7 @@
    - Michael Lang
    
    July 17, 2000 (v3.2pre8)
-   A long period of collecting bugreports from all corners of the world
+   A long period of collecting bug reports from all corners of the world
    now lead to the following corrections to the code:
    1) SCSI-2 F/W support crashed with a COMMAND ERROR. The reason for this 
       was that it is possible to disable Fast-SCSI for the external bus.
@@ -873,7 +873,7 @@
    July 26, 2000 (v3.2pre11)
    1) I passed a horrible weekend getting mad with NMIs on kernel 2.2.14 and
       a model 9595. Asking around in the community, nobody except of me has
-      seen such errors. Weired, but I am trying to recompile everything on
+      seen such errors. Weird, but I am trying to recompile everything on
       the model 9595. Maybe, as I use a specially modified gcc, that could
       cause problems. But, it was not the reason. The true background was,
       that the kernel was compiled for i386 and the 9595 has a 486DX-2. 
@@ -886,7 +886,7 @@
       alive rotator during boottime. This makes sense, when no monitor is 
       connected to the system. You can get rid of all display activity, if
       you do not use any parameter or just ibmmcascsi=activity, for the 
-      harddrive activity LED, existant on all PS/2, except models 8595-XXX.
+      harddrive activity LED, existent on all PS/2, except models 8595-XXX.
       If no monitor is available, please use ibmmcascsi=display, which works
       fine together with the linuxinfo utility for the LED-panel.
    - Michael Lang
@@ -1115,7 +1115,7 @@
         If this really happens, do also send e-mail to the maintainer, as
 	forced detection should be never necessary. Forced detection is in
 	principal some flaw of the driver adapter detection and goes into 
-	bugreports.
+	bug reports.
      Q: The driver screws up, if it starts to probe SCSI-devices, is there
         some way out of it?
      A: Yes, that was some recognition problem of the correct SCSI-adapter
@@ -1188,7 +1188,7 @@
 	and 15 get ignored by the driver & adapter!
      Q: I have a 9595 and I get a NMI during heavy SCSI I/O e.g. during fsck.
         A COMMAND ERROR is reported and characters on the screen are missing.
-	Warm reboot is not possible. Things look like quite weired.
+	Warm reboot is not possible. Things look like quite weird.
      A: Check the processor type of your 9595. If you have an 80486 or 486DX-2
         processor complex on your mainboard and you compiled a kernel that
 	supports 80386 processors, it is possible, that the kernel cannot
@@ -1213,21 +1213,21 @@
 	problem. Not yet tried, but guessing that it could work. To get this,
 	set unchecked_isa_dma argument of ibmmca.h from 0 to 1.
 
-   5.3 Bugreports
+   5.3 Bug reports
    --------------
-   If you really find bugs in the sourcecode or the driver will successfully
+   If you really find bugs in the source code or the driver will successfully
    refuse to work on your machine, you should send a bug report to me. The
    best for this is to follow the instructions on the WWW-page for this
    driver. Fill out the bug-report form, placed on the WWW-page and ship it,
    so the bugs can be taken into account with maximum efforts. But, please
    do not send bug reports about this driver to Linus Torvalds or Leonard
-   Zubkoff, as Linus is burried in E-Mail and Leonard is supervising all
+   Zubkoff, as Linus is buried in E-Mail and Leonard is supervising all
    SCSI-drivers and won't have the time left to look inside every single
    driver to fix a bug and especially DO NOT send modified code to Linus
    Torvalds or Alan J. Cox which has not been checked here!!! They are both
-   quite burried in E-mail (as me, sometimes, too) and one should first check
+   quite buried in E-mail (as me, sometimes, too) and one should first check
    for problems on my local teststand. Recently, I got a lot of 
-   bugreports for errors in the ibmmca.c code, which I could not imagine, but
+   bug reports for errors in the ibmmca.c code, which I could not imagine, but
    a look inside some Linux-distribution showed me quite often some modified
    code, which did no longer work on most other machines than the one of the
    modifier. Ok, so now that there is maintenance service available for this
@@ -1261,7 +1261,7 @@
    some e-mail directly, but at least with the same information as required by
    the formular.
    
-   If you have extensive bugreports, including Ooops messages and 
+   If you have extensive bug reports, including Ooops messages and 
    screen-shots, please feel free to send it directly to the address
    of the maintainer, too. The current address of the maintainer is:
    
@@ -1318,7 +1318,7 @@
 		detailed bug reports and ideas for this driver (and his 
 		patience ;-)).
    Alan J. Cox  
-                for his bugreports and his bold activities in cross-checking
+                for his bug reports and his bold activities in cross-checking
 		the driver-code with his teststand.
 		
    7.2 Sponsors & Supporters
diff -ru a/Documentation/sound/alsa/soc/clocking.txt b/Documentation/sound/alsa/soc/clocking.txt
--- a/Documentation/sound/alsa/soc/clocking.txt	2007-07-08 19:32:17.000000000 -0400
+++ b/Documentation/sound/alsa/soc/clocking.txt	2007-07-08 22:43:33.000000000 -0400
@@ -2,20 +2,20 @@
 ==============
 
 This text describes the audio clocking terms in ASoC and digital audio in
-general. Note: Audio clocking can be complex !
+general. Note: Audio clocking can be complex!
 
 
 Master Clock
 ------------
 
-Every audio subsystem is driven by a master clock (sometimes refered to as MCLK
+Every audio subsystem is driven by a master clock (sometimes referred to as MCLK
 or SYSCLK). This audio master clock can be derived from a number of sources
 (e.g. crystal, PLL, CPU clock) and is responsible for producing the correct
 audio playback and capture sample rates.
 
-Some master clocks (e.g. PLL's and CPU based clocks) are configuarble in that
+Some master clocks (e.g. PLL's and CPU based clocks) are configurable in that
 their speed can be altered by software (depending on the system use and to save
-power). Other master clocks are fixed at at set frequency (i.e. crystals).
+power). Other master clocks are fixed at a set frequency (i.e. crystals).
 
 
 DAI Clocks
@@ -44,7 +44,7 @@
 it's best to configure BCLK to the lowest possible speed (depending on your
 rate, number of channels and wordsize) to save on power.
 
-It's also desireable to use the codec (if possible) to drive (or master) the
+It's also desirable to use the codec (if possible) to drive (or master) the
 audio clocks as it's usually gives more accurate sample rates than the CPU.
 
 
diff -ru a/Documentation/sound/alsa/soc/codec.txt b/Documentation/sound/alsa/soc/codec.txt
--- a/Documentation/sound/alsa/soc/codec.txt	2007-07-08 19:32:17.000000000 -0400
+++ b/Documentation/sound/alsa/soc/codec.txt	2007-07-08 23:03:19.000000000 -0400
@@ -19,7 +19,7 @@
  6) DAPM event handler.
  7) DAC Digital mute control.
 
-It's probably best to use this guide in conjuction with the existing codec
+It's probably best to use this guide in conjunction with the existing codec
 driver code in sound/soc/codecs/
 
 ASoC Codec driver breakdown
@@ -28,7 +28,7 @@
 1 - Codec DAI and PCM configuration
 -----------------------------------
 Each codec driver must have a struct snd_soc_codec_dai to define it's DAI and
-PCM's capablities and operations. This struct is exported so that it can be
+PCM's capabilities and operations. This struct is exported so that it can be
 registered with the core by your machine driver.
 
 e.g.
@@ -67,7 +67,7 @@
 
 2 - Codec control IO
 --------------------
-The codec can ususally be controlled via an I2C or SPI style interface (AC97
+The codec can usually be controlled via an I2C or SPI style interface (AC97
 combines control with data in the DAI). The codec drivers will have to provide
 functions to read and write the codec registers along with supplying a register
 cache:-
diff -ru a/Documentation/sound/alsa/soc/DAI.txt b/Documentation/sound/alsa/soc/DAI.txt
--- a/Documentation/sound/alsa/soc/DAI.txt	2007-07-08 19:32:17.000000000 -0400
+++ b/Documentation/sound/alsa/soc/DAI.txt	2007-07-08 23:58:21.000000000 -0400
@@ -20,12 +20,12 @@
 ===
 
  I2S is a common 4 wire DAI used in HiFi, STB and portable devices. The Tx and
-Rx lines are used for audio transmision, whilst the bit clock (BCLK) and
+Rx lines are used for audio transmission, whilst the bit clock (BCLK) and
 left/right clock (LRC) synchronise the link. I2S is flexible in that either the
 controller or CODEC can drive (master) the BCLK and LRC clock lines. Bit clock
 usually varies depending on the sample rate and the master system clock
 (SYSCLK). LRCLK is the same as the sample rate. A few devices support separate
-ADC and DAC LRCLK's, this allows for similtanious capture and playback at
+ADC and DAC LRCLK's, this allows for simultaneous capture and playback at
 different sample rates.
 
 I2S has several different operating modes:-
@@ -41,12 +41,12 @@
 PCM
 ===
 
-PCM is another 4 wire interface, very similar to I2S, that can support a more
+PCM is another 4 wire interface, very similar to I2S, which can support a more
 flexible protocol. It has bit clock (BCLK) and sync (SYNC) lines that are used
 to synchronise the link whilst the Tx and Rx lines are used to transmit and
 receive the audio data. Bit clock usually varies depending on sample rate
 whilst sync runs at the sample rate. PCM also supports Time Division
-Multiplexing (TDM) in that several devices can use the bus similtaniuosly (This
+Multiplexing (TDM) in that several devices can use the bus simultaneously (this
 is sometimes referred to as network mode).
 
 Common PCM operating modes:-
diff -ru a/Documentation/sound/alsa/soc/dapm.txt b/Documentation/sound/alsa/soc/dapm.txt
--- a/Documentation/sound/alsa/soc/dapm.txt	2007-07-08 19:32:17.000000000 -0400
+++ b/Documentation/sound/alsa/soc/dapm.txt	2007-07-08 22:49:25.000000000 -0400
@@ -11,7 +11,7 @@
 
 DAPM is also completely transparent to all user space applications as all power
 switching is done within the ASoC core. No code changes or recompiling are
-required for user space applications. DAPM makes power switching descisions based
+required for user space applications. DAPM makes power switching decisions based
 upon any audio stream (capture/playback) activity and audio mixer settings
 within the device.
 
@@ -38,7 +38,7 @@
       Enabled and disabled when stream playback/capture is started and
       stopped respectively. e.g. aplay, arecord.
 
-All DAPM power switching descisons are made automatically by consulting an audio
+All DAPM power switching decisions are made automatically by consulting an audio
 routing map of the whole machine. This map is specific to each machine and
 consists of the interconnections between every audio component (including
 internal codec components). All audio components that effect power are called
diff -ru a/Documentation/sound/alsa/soc/overview.txt b/Documentation/sound/alsa/soc/overview.txt
--- a/Documentation/sound/alsa/soc/overview.txt	2007-07-08 19:32:17.000000000 -0400
+++ b/Documentation/sound/alsa/soc/overview.txt	2007-07-09 12:30:56.000000000 -0400
@@ -2,7 +2,7 @@
 ==============
 
 The overall project goal of the ALSA System on Chip (ASoC) layer is to provide
-better ALSA support for embedded system on chip procesors (e.g. pxa2xx, au1x00,
+better ALSA support for embedded system on chip processors (e.g. pxa2xx, au1x00,
 iMX, etc) and portable audio codecs. Currently there is some support in the
 kernel for SoC audio, however it has some limitations:-
 
@@ -10,10 +10,11 @@
     cpu. This is not ideal and leads to code duplication i.e. Linux now has 4
     different wm8731 drivers for 4 different SoC platforms.
 
-  * There is no standard method to signal user initiated audio events.
-    e.g. Headphone/Mic insertion, Headphone/Mic detection after an insertion
-    event. These are quite common events on portable devices and ofter require
-    machine specific code to re route audio, enable amps etc after such an event.
+  * There is no standard method to signal user initiated audio events (e.g. 
+    Headphone/Mic insertion, Headphone/Mic detection after an insertion
+    event). These are quite common events on portable devices and often require
+    machine specific code to re-route audio, enable amps, etc., after such an 
+    event.
 
   * Current drivers tend to power up the entire codec when playing
     (or recording) audio. This is fine for a PC, but tends to waste a lot of
@@ -44,7 +45,7 @@
     signals the codec when to change power states.
 
   * Machine specific controls: Allow machines to add controls to the sound card
-    e.g. volume control for speaker amp.
+    (e.g. volume control for speaker amp).
 
 To achieve all this, ASoC basically splits an embedded audio system into 3
 components :-
@@ -57,7 +58,7 @@
     interface drivers (e.g. I2S, AC97, PCM) for that platform.
 
   * Machine driver: The machine driver handles any machine specific controls and
-    audio events. i.e. turing on an amp at start of playback.
+    audio events (e.g. turning on an amp at start of playback).
 
 
 Documentation
diff -ru a/Documentation/sound/alsa/soc/platform.txt b/Documentation/sound/alsa/soc/platform.txt
--- a/Documentation/sound/alsa/soc/platform.txt	2007-07-08 19:32:17.000000000 -0400
+++ b/Documentation/sound/alsa/soc/platform.txt	2007-07-08 23:01:48.000000000 -0400
@@ -20,7 +20,7 @@
 	int (*trigger)(struct snd_pcm_substream *, int);
 };
 
-The platform driver exports it's DMA functionailty via struct snd_soc_platform:-
+The platform driver exports its DMA functionality via struct snd_soc_platform:-
 
 struct snd_soc_platform {
 	char *name;
diff -ru a/Documentation/sound/alsa/soc/pops_clicks.txt b/Documentation/sound/alsa/soc/pops_clicks.txt
--- a/Documentation/sound/alsa/soc/pops_clicks.txt	2007-07-08 19:32:17.000000000 -0400
+++ b/Documentation/sound/alsa/soc/pops_clicks.txt	2007-07-08 23:33:28.000000000 -0400
@@ -2,7 +2,7 @@
 =====================
 
 Pops and clicks are unwanted audio artifacts caused by the powering up and down
-of components within the audio subsystem. This is noticable on PC's when an
+of components within the audio subsystem. This is noticeable on PCs when an
 audio module is either loaded or unloaded (at module load time the sound card is
 powered up and causes a popping noise on the speakers).
 
@@ -16,7 +16,7 @@
 ===================================
 
 Playback pops in portable audio subsystems cannot be completely eliminated atm,
-however future audio codec hardware will have better pop and click supression.
+however future audio codec hardware will have better pop and click suppression.
 Pops can be reduced within playback by powering the audio components in a
 specific order. This order is different for startup and shutdown and follows
 some basic rules:-
@@ -33,7 +33,7 @@
 ==================================
 
 Capture artifacts are somewhat easier to get rid as we can delay activating the
-ADC until all the pops have occured. This follows similar power rules to
+ADC until all the pops have occurred. This follows similar power rules to
 playback in that components are powered in a sequence depending upon stream
 startup or shutdown.
 
diff -ru a/Documentation/thinkpad-acpi.txt b/Documentation/thinkpad-acpi.txt
--- a/Documentation/thinkpad-acpi.txt	2007-07-08 19:32:17.000000000 -0400
+++ b/Documentation/thinkpad-acpi.txt	2007-07-08 23:42:12.000000000 -0400
@@ -777,7 +777,7 @@
 
 An enabled fan in level "auto" may stop spinning if the EC decides the
 ThinkPad is cool enough and doesn't need the extra airflow.  This is
-normal, and the EC will spin the fan up if the varios thermal readings
+normal, and the EC will spin the fan up if the various thermal readings
 rise too much.
 
 On the X40, this seems to depend on the CPU and HDD temperatures.
@@ -945,7 +945,7 @@
 Enabling debugging output
 -------------------------
 
-The module takes a debug paramater which can be used to selectively
+The module takes a debug parameter which can be used to selectively
 enable various classes of debugging output, for example:
 
 	 modprobe ibm_acpi debug=0xffff

