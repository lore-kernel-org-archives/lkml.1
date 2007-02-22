Return-Path: <linux-kernel-owner+w=401wt.eu-S1750897AbXBVNYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750897AbXBVNYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 08:24:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750898AbXBVNYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 08:24:31 -0500
Received: from free-electrons.com ([88.191.23.47]:38846 "EHLO
	sd-2511.dedibox.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbXBVNY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 08:24:28 -0500
From: Michael Opdenacker <michael-lists@free-electrons.com>
Organization: Free Electrons
To: Paolo Ornati <ornati@fastwebnet.it>
Subject: Re: [PATCH] [TRIVIAL] Fixing occurrences of "the the "
Date: Thu, 22 Feb 2007 14:23:56 +0100
User-Agent: KMail/1.9.5
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
References: <200702220927.28393.michael-lists@free-electrons.com> <20070222102631.231bf605@localhost>
In-Reply-To: <20070222102631.231bf605@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702221423.56689.michael-lists@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 February 2007 10:26, Paolo Ornati wrote:
> On Thu, 22 Feb 2007 09:27:28 +0100
> Michael Opdenacker <michael-lists@free-electrons.com> wrote:
> 
> > -	  Note the the latest Xeons (Xeon 51xx and 53xx) are not based on the
> > +	  Note the latest Xeons (Xeon 51xx and 53xx) are not based on the
> 
> shouldn't this be "Note that the"?  (and so on)
> 
> IOW: some of these are typos.
> 
> Some time ago I've done a similar patch for "Documentation/" (remove
> duplicated words) and fallen in the same mistake :)

Ciao Paolo,

You're definitely right...  Some more attention to the meaning of each sentence was needed.
I found several mistakes of this kind.

Here's an update for this patch. Many thanks!

:-)

Michael.

Signed-off-by: Michael Opdenacker <michael@free-electrons.com>

diff -Nurp linux-2.6.20/arch/mips/Makefile linux-2.6.20-the-the/arch/mips/Makefile
--- linux-2.6.20/arch/mips/Makefile	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/arch/mips/Makefile	2007-02-22 08:13:27.000000000 +0100
@@ -92,7 +92,7 @@ cflags-y += -ffreestanding
 # when fed the toolchain default!
 #
 # Certain gcc versions upto gcc 4.1.1 (probably 4.2-subversion as of
-# 2006-10-10 don't properly change the the predefined symbols if -EB / -EL
+# 2006-10-10 don't properly change the predefined symbols if -EB / -EL
 # are used, so we kludge that here.  A bug has been filed at
 # http://gcc.gnu.org/bugzilla/show_bug.cgi?id=29413.
 #
diff -Nurp linux-2.6.20/arch/mips/pci/fixup-sb1250.c linux-2.6.20-the-the/arch/mips/pci/fixup-sb1250.c
--- linux-2.6.20/arch/mips/pci/fixup-sb1250.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/arch/mips/pci/fixup-sb1250.c	2007-02-22 08:13:13.000000000 +0100
@@ -14,7 +14,7 @@
 #include <linux/pci.h>
 
 /*
- * Set the the BCM1250, etc. PCI host bridge's TRDY timeout
+ * Set the BCM1250, etc. PCI host bridge's TRDY timeout
  * to the finite max.
  */
 static void __init quirk_sb1250_pci(struct pci_dev *dev)
@@ -35,7 +35,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SI
 			quirk_sb1250_ht);
 
 /*
- * Set the the SP1011 HT/PCI bridge's TRDY timeout to the finite max.
+ * Set the SP1011 HT/PCI bridge's TRDY timeout to the finite max.
  */
 static void __init quirk_sp1011(struct pci_dev *dev)
 {
diff -Nurp linux-2.6.20/arch/powerpc/platforms/cell/io-workarounds.c linux-2.6.20-the-the/arch/powerpc/platforms/cell/io-workarounds.c
--- linux-2.6.20/arch/powerpc/platforms/cell/io-workarounds.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/arch/powerpc/platforms/cell/io-workarounds.c	2007-02-22 08:13:37.000000000 +0100
@@ -74,7 +74,7 @@ static void spider_io_flush(const volati
 	/* Fast path if we have a non-0 token, it indicates which bus we
 	 * are on.
 	 *
-	 * If the token is 0, that means either the the ioremap was done
+	 * If the token is 0, that means either that the ioremap was done
 	 * before we initialized this layer, or it's a PIO operation. We
 	 * fallback to a low path in this case. Hopefully, internal devices
 	 * which are ioremap'ed early should use in_XX/out_XX functions
diff -Nurp linux-2.6.20/arch/v850/kernel/entry.S linux-2.6.20-the-the/arch/v850/kernel/entry.S
--- linux-2.6.20/arch/v850/kernel/entry.S	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/arch/v850/kernel/entry.S	2007-02-22 08:14:16.000000000 +0100
@@ -523,7 +523,7 @@ END(ret_from_trap)
 
 
 /* This the initial entry point for a new child thread, with an appropriate
-   stack in place that makes it look the the child is in the middle of an
+   stack in place that makes it look that the child is in the middle of an
    syscall.  This function is actually `returned to' from switch_thread
    (copy_thread makes ret_from_fork the return address in each new thread's
    saved context).  */
diff -Nurp linux-2.6.20/arch/x86_64/Kconfig linux-2.6.20-the-the/arch/x86_64/Kconfig
--- linux-2.6.20/arch/x86_64/Kconfig	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/arch/x86_64/Kconfig	2007-02-22 08:06:58.000000000 +0100
@@ -148,7 +148,7 @@ config MPSC
 	  Optimize for Intel Pentium 4 and older Nocona/Dempsey Xeon CPUs
 	  with Intel Extended Memory 64 Technology(EM64T). For details see
 	  <http://www.intel.com/technology/64bitextensions/>.
-	  Note the the latest Xeons (Xeon 51xx and 53xx) are not based on the
+	  Note that the latest Xeons (Xeon 51xx and 53xx) are not based on the
           Netburst core and shouldn't use this option. You can distingush them
 	  using the cpu family field
 	  in /proc/cpuinfo. Family 15 is a older Xeon, Family 6 a newer one
diff -Nurp linux-2.6.20/block/ll_rw_blk.c linux-2.6.20-the-the/block/ll_rw_blk.c
--- linux-2.6.20/block/ll_rw_blk.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/block/ll_rw_blk.c	2007-02-22 08:14:26.000000000 +0100
@@ -1704,7 +1704,7 @@ EXPORT_SYMBOL(blk_stop_queue);
  *     on a queue, such as calling the unplug function after a timeout.
  *     A block device may call blk_sync_queue to ensure that any
  *     such activity is cancelled, thus allowing it to release resources
- *     the the callbacks might use. The caller must already have made sure
+ *     that the callbacks might use. The caller must already have made sure
  *     that its ->make_request_fn will not re-add plugging prior to calling
  *     this function.
  *
diff -Nurp linux-2.6.20/Documentation/ABI/removed/devfs linux-2.6.20-the-the/Documentation/ABI/removed/devfs
--- linux-2.6.20/Documentation/ABI/removed/devfs	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/Documentation/ABI/removed/devfs	2007-02-22 08:06:08.000000000 +0100
@@ -6,7 +6,7 @@ Description:
 	races, contains a naming policy within the kernel that is
 	against the LSB, and can be replaced by using udev.
 	The files fs/devfs/*, include/linux/devfs_fs*.h were removed,
-	along with the the assorted devfs function calls throughout the
+	along with the assorted devfs function calls throughout the
 	kernel tree.
 
 Users:
diff -Nurp linux-2.6.20/Documentation/driver-model/platform.txt linux-2.6.20-the-the/Documentation/driver-model/platform.txt
--- linux-2.6.20/Documentation/driver-model/platform.txt	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/Documentation/driver-model/platform.txt	2007-02-22 08:11:01.000000000 +0100
@@ -125,7 +125,7 @@ three different ways to find such a matc
       usually register later during booting, or by module loading.
 
     - Registering a driver using platform_driver_probe() works just like
-      using platform_driver_register(), except that the the driver won't
+      using platform_driver_register(), except that the driver won't
       be probed later if another device registers.  (Which is OK, since
       this interface is only for use with non-hotpluggable devices.)
 
diff -Nurp linux-2.6.20/Documentation/netlabel/introduction.txt linux-2.6.20-the-the/Documentation/netlabel/introduction.txt
--- linux-2.6.20/Documentation/netlabel/introduction.txt	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/Documentation/netlabel/introduction.txt	2007-02-22 08:04:44.000000000 +0100
@@ -30,7 +30,7 @@ The communication layer exists to allow 
 from user space.  The NetLabel communication layer uses a message based
 protocol built on top of the Generic NETLINK transport mechanism.  The exact
 formatting of these NetLabel messages as well as the Generic NETLINK family
-names can be found in the the 'net/netlabel/' directory as comments in the
+names can be found in the 'net/netlabel/' directory as comments in the
 header files as well as in 'include/net/netlabel.h'.
 
  * Security Module API
diff -Nurp linux-2.6.20/Documentation/pci.txt linux-2.6.20-the-the/Documentation/pci.txt
--- linux-2.6.20/Documentation/pci.txt	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/Documentation/pci.txt	2007-02-22 08:09:30.000000000 +0100
@@ -377,7 +377,7 @@ E.g. clearing pending interrupts.
 
 3.6 Register IRQ handler
 ~~~~~~~~~~~~~~~~~~~~~~~~
-While calling request_irq() is the the last step described here,
+While calling request_irq() is the last step described here,
 this is often just another intermediate step to initialize a device.
 This step can often be deferred until the device is opened for use.
 
diff -Nurp linux-2.6.20/Documentation/powerpc/booting-without-of.txt linux-2.6.20-the-the/Documentation/powerpc/booting-without-of.txt
--- linux-2.6.20/Documentation/powerpc/booting-without-of.txt	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/Documentation/powerpc/booting-without-of.txt	2007-02-22 08:12:04.000000000 +0100
@@ -1462,7 +1462,7 @@ platforms are moved over to use the flat
    Basically, it is a bus of devices, that could act more or less
    as a complete entity (UCC, USB etc ). All of them should be siblings on
    the "root" qe node, using the common properties from there.
-   The description below applies to the the qe of MPC8360 and
+   The description below applies to the qe of MPC8360 and
    more nodes and properties would be extended in the future.
 
    i) Root QE device
diff -Nurp linux-2.6.20/drivers/block/rd.c linux-2.6.20-the-the/drivers/block/rd.c
--- linux-2.6.20/drivers/block/rd.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/drivers/block/rd.c	2007-02-22 08:09:38.000000000 +0100
@@ -151,7 +151,7 @@ static int ramdisk_commit_write(struct f
 }
 
 /*
- * ->writepage to the the blockdev's mapping has to redirty the page so that the
+ * ->writepage to the blockdev's mapping has to redirty the page so that the
  * VM doesn't go and steal it.  We return AOP_WRITEPAGE_ACTIVATE so that the VM
  * won't try to (pointlessly) write the page again for a while.
  *
diff -Nurp linux-2.6.20/drivers/char/drm/drm_dma.c linux-2.6.20-the-the/drivers/char/drm/drm_dma.c
--- linux-2.6.20/drivers/char/drm/drm_dma.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/drivers/char/drm/drm_dma.c	2007-02-22 08:05:50.000000000 +0100
@@ -65,7 +65,7 @@ int drm_dma_setup(drm_device_t * dev)
  * \param dev DRM device.
  *
  * Free all pages associated with DMA buffers, the buffers and pages lists, and
- * finally the the drm_device::dma structure itself.
+ * finally the drm_device::dma structure itself.
  */
 void drm_dma_takedown(drm_device_t * dev)
 {
diff -Nurp linux-2.6.20/drivers/char/drm/drm_vm.c linux-2.6.20-the-the/drivers/char/drm/drm_vm.c
--- linux-2.6.20/drivers/char/drm/drm_vm.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/drivers/char/drm/drm_vm.c	2007-02-22 08:12:18.000000000 +0100
@@ -133,7 +133,7 @@ static __inline__ struct page *drm_do_vm
  * \param address access address.
  * \return pointer to the page structure.
  *
- * Get the the mapping, find the real physical page to map, get the page, and
+ * Get the mapping, find the real physical page to map, get the page, and
  * return it.
  */
 static __inline__ struct page *drm_do_vm_shm_nopage(struct vm_area_struct *vma,
diff -Nurp linux-2.6.20/drivers/char/drm/r300_reg.h linux-2.6.20-the-the/drivers/char/drm/r300_reg.h
--- linux-2.6.20/drivers/char/drm/r300_reg.h	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/drivers/char/drm/r300_reg.h	2007-02-22 08:13:46.000000000 +0100
@@ -293,7 +293,7 @@ I am fairly certain that they are correc
 #       define R300_PVS_CNTL_1_PROGRAM_START_SHIFT   0
 #       define R300_PVS_CNTL_1_POS_END_SHIFT         10
 #       define R300_PVS_CNTL_1_PROGRAM_END_SHIFT     20
-/* Addresses are relative the the vertex program parameters area. */
+/* Addresses are relative to the vertex program parameters area. */
 #define R300_VAP_PVS_CNTL_2                 0x22D4
 #       define R300_PVS_CNTL_2_PARAM_OFFSET_SHIFT 0
 #       define R300_PVS_CNTL_2_PARAM_COUNT_SHIFT  16
diff -Nurp linux-2.6.20/drivers/char/pcmcia/cm4000_cs.c linux-2.6.20-the-the/drivers/char/pcmcia/cm4000_cs.c
--- linux-2.6.20/drivers/char/pcmcia/cm4000_cs.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/drivers/char/pcmcia/cm4000_cs.c	2007-02-22 08:05:27.000000000 +0100
@@ -1115,7 +1115,7 @@ static ssize_t cmm_write(struct file *fi
 	/*
 	 * wait for atr to become valid.
 	 * note: it is important to lock this code. if we dont, the monitor
-	 * could be run between test_bit and the the call the sleep on the
+	 * could be run between test_bit and the call to sleep on the
 	 * atr-queue.  if *then* the monitor detects atr valid, it will wake up
 	 * any process on the atr-queue, *but* since we have been interrupted,
 	 * we do not yet sleep on this queue. this would result in a missed
diff -Nurp linux-2.6.20/drivers/ide/pci/siimage.c linux-2.6.20-the-the/drivers/ide/pci/siimage.c
--- linux-2.6.20/drivers/ide/pci/siimage.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/drivers/ide/pci/siimage.c	2007-02-22 08:04:15.000000000 +0100
@@ -847,7 +847,7 @@ static void __devinit init_mmio_iops_sii
 
 	/*
 	 *	Now set up the hw. We have to do this ourselves as
-	 *	the MMIO layout isnt the same as the the standard port
+	 *	the MMIO layout isnt the same as the standard port
 	 *	based I/O
 	 */
 
diff -Nurp linux-2.6.20/drivers/ieee1394/nodemgr.c linux-2.6.20-the-the/drivers/ieee1394/nodemgr.c
--- linux-2.6.20/drivers/ieee1394/nodemgr.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/drivers/ieee1394/nodemgr.c	2007-02-22 08:02:30.000000000 +0100
@@ -1752,7 +1752,7 @@ static int nodemgr_host_thread(void *__h
 			generation = get_hpsb_generation(host);
 
 			/* If we get a reset before we are done waiting, then
-			 * start the the waiting over again */
+			 * start the waiting over again */
 			if (generation != g)
 				g = generation, i = 0;
 		}
diff -Nurp linux-2.6.20/drivers/isdn/hardware/eicon/divasync.h linux-2.6.20-the-the/drivers/isdn/hardware/eicon/divasync.h
--- linux-2.6.20/drivers/isdn/hardware/eicon/divasync.h	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/drivers/isdn/hardware/eicon/divasync.h	2007-02-22 08:04:55.000000000 +0100
@@ -216,7 +216,7 @@ typedef struct
 #define SERIAL_HOOK_RING 0x85
 #define SERIAL_HOOK_DETACH 0x8f
  unsigned char Flags;           /* function refinements   */
- /* parameters passed by the the ATTACH request      */
+ /* parameters passed by the ATTACH request      */
  SERIAL_INT_CB InterruptHandler; /* called on each interrupt  */
  SERIAL_DPC_CB DeferredHandler; /* called on hook state changes */
  void   *HandlerContext; /* context for both handlers */
diff -Nurp linux-2.6.20/drivers/isdn/hisax/hfc_usb.c linux-2.6.20-the-the/drivers/isdn/hisax/hfc_usb.c
--- linux-2.6.20/drivers/isdn/hisax/hfc_usb.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/drivers/isdn/hisax/hfc_usb.c	2007-02-22 08:04:28.000000000 +0100
@@ -1219,11 +1219,11 @@ usb_init(hfcusb_data * hfc)
 	/* aux = output, reset off */
 	write_usb(hfc, HFCUSB_CIRM, 0x10);
 
-	/* set USB_SIZE to match the the wMaxPacketSize for INT or BULK transfers */
+	/* set USB_SIZE to match the wMaxPacketSize for INT or BULK transfers */
 	write_usb(hfc, HFCUSB_USB_SIZE,
 		  (hfc->packet_size / 8) | ((hfc->packet_size / 8) << 4));
 
-	/* set USB_SIZE_I to match the the wMaxPacketSize for ISO transfers */
+	/* set USB_SIZE_I to match the wMaxPacketSize for ISO transfers */
 	write_usb(hfc, HFCUSB_USB_SIZE_I, hfc->iso_packet_size);
 
 	/* enable PCM/GCI master mode */
diff -Nurp linux-2.6.20/drivers/media/dvb/dvb-usb/dvb-usb-remote.c linux-2.6.20-the-the/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
--- linux-2.6.20/drivers/media/dvb/dvb-usb/dvb-usb-remote.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/drivers/media/dvb/dvb-usb/dvb-usb-remote.c	2007-02-22 08:04:06.000000000 +0100
@@ -3,7 +3,7 @@
  * Copyright (C) 2004-6 Patrick Boettcher (patrick.boettcher@desy.de)
  * see dvb-usb-init.c for copyright information.
  *
- * This file contains functions for initializing the the input-device and for handling remote-control-queries.
+ * This file contains functions for initializing the input-device and for handling remote-control-queries.
  */
 #include "dvb-usb-common.h"
 #include <linux/usb/input.h>
diff -Nurp linux-2.6.20/drivers/media/dvb/frontends/tda10021.c linux-2.6.20-the-the/drivers/media/dvb/frontends/tda10021.c
--- linux-2.6.20/drivers/media/dvb/frontends/tda10021.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/drivers/media/dvb/frontends/tda10021.c	2007-02-22 08:01:46.000000000 +0100
@@ -1,6 +1,6 @@
 /*
     TDA10021  - Single Chip Cable Channel Receiver driver module
-	       used on the the Siemens DVB-C cards
+	       used on the Siemens DVB-C cards
 
     Copyright (C) 1999 Convergence Integrated Media GmbH <ralph@convergence.de>
     Copyright (C) 2004 Markus Schulz <msc@antzsystem.de>
diff -Nurp linux-2.6.20/drivers/media/dvb/frontends/tda10021.h linux-2.6.20-the-the/drivers/media/dvb/frontends/tda10021.h
--- linux-2.6.20/drivers/media/dvb/frontends/tda10021.h	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/drivers/media/dvb/frontends/tda10021.h	2007-02-22 08:11:46.000000000 +0100
@@ -1,6 +1,6 @@
 /*
     TDA10021  - Single Chip Cable Channel Receiver driver module
-	       used on the the Siemens DVB-C cards
+	       used on the Siemens DVB-C cards
 
     Copyright (C) 1999 Convergence Integrated Media GmbH <ralph@convergence.de>
     Copyright (C) 2004 Markus Schulz <msc@antzsystem.de>
diff -Nurp linux-2.6.20/drivers/media/dvb/frontends/ves1x93.c linux-2.6.20-the-the/drivers/media/dvb/frontends/ves1x93.c
--- linux-2.6.20/drivers/media/dvb/frontends/ves1x93.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/drivers/media/dvb/frontends/ves1x93.c	2007-02-22 08:01:36.000000000 +0100
@@ -306,7 +306,7 @@ static int ves1x93_read_status(struct dv
 	 * The ves1893 sometimes returns sync values that make no sense,
 	 * because, e.g., the SIGNAL bit is 0, while some of the higher
 	 * bits are 1 (and how can there be a CARRIER w/o a SIGNAL?).
-	 * Tests showed that the the VITERBI and SYNC bits are returned
+	 * Tests showed that the VITERBI and SYNC bits are returned
 	 * reliably, while the SIGNAL and CARRIER bits ar sometimes wrong.
 	 * If such a case occurs, we read the value again, until we get a
 	 * valid value.
diff -Nurp linux-2.6.20/drivers/media/video/em28xx/em28xx-video.c linux-2.6.20-the-the/drivers/media/video/em28xx/em28xx-video.c
--- linux-2.6.20/drivers/media/video/em28xx/em28xx-video.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/drivers/media/video/em28xx/em28xx-video.c	2007-02-22 08:06:47.000000000 +0100
@@ -1729,7 +1729,7 @@ static int em28xx_usb_probe(struct usb_i
 
 	endpoint = &interface->cur_altsetting->endpoint[1].desc;
 
-	/* check if the the device has the iso in endpoint at the correct place */
+	/* check if the device has the iso in endpoint at the correct place */
 	if ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) !=
 	    USB_ENDPOINT_XFER_ISOC) {
 		em28xx_err(DRIVER_NAME " probing error: endpoint is non-ISO endpoint!\n");
diff -Nurp linux-2.6.20/drivers/media/video/usbvideo/vicam.c linux-2.6.20-the-the/drivers/media/video/usbvideo/vicam.c
--- linux-2.6.20/drivers/media/video/usbvideo/vicam.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/drivers/media/video/usbvideo/vicam.c	2007-02-22 08:10:17.000000000 +0100
@@ -28,7 +28,7 @@
  *
  * Portions of this code were also copied from usbvideo.c
  *
- * Special thanks to the the whole team at Sourceforge for help making
+ * Special thanks to the whole team at Sourceforge for help making
  * this driver become a reality.  Notably:
  * Andy Armstrong who reverse engineered the color encoding and
  * Pavel Machek and Chris Cheney who worked on reverse engineering the
diff -Nurp linux-2.6.20/drivers/message/fusion/mptbase.c linux-2.6.20-the-the/drivers/message/fusion/mptbase.c
--- linux-2.6.20/drivers/message/fusion/mptbase.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/drivers/message/fusion/mptbase.c	2007-02-22 08:03:54.000000000 +0100
@@ -3556,7 +3556,7 @@ initChainBuffers(MPT_ADAPTER *ioc)
 	 * index = chain_idx
 	 *
 	 * Calculate the number of chain buffers needed(plus 1) per I/O
-	 * then multiply the the maximum number of simultaneous cmds
+	 * then multiply the maximum number of simultaneous cmds
 	 *
 	 * num_sge = num sge in request frame + last chain buffer
 	 * scale = num sge per chain buffer if no chain element
diff -Nurp linux-2.6.20/drivers/mtd/maps/nettel.c linux-2.6.20-the-the/drivers/mtd/maps/nettel.c
--- linux-2.6.20/drivers/mtd/maps/nettel.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/drivers/mtd/maps/nettel.c	2007-02-22 08:02:20.000000000 +0100
@@ -358,7 +358,7 @@ int __init nettel_init(void)
 	/* Turn other PAR off so the first probe doesn't find it */
 	*intel1par = 0;
 
-	/* Probe for the the size of the first Intel flash */
+	/* Probe for the size of the first Intel flash */
 	nettel_intel_map.size = maxsize;
 	nettel_intel_map.phys = intel0addr;
 	nettel_intel_map.virt = ioremap_nocache(intel0addr, maxsize);
diff -Nurp linux-2.6.20/drivers/mtd/onenand/onenand_base.c linux-2.6.20-the-the/drivers/mtd/onenand/onenand_base.c
--- linux-2.6.20/drivers/mtd/onenand/onenand_base.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/drivers/mtd/onenand/onenand_base.c	2007-02-22 08:11:10.000000000 +0100
@@ -1911,7 +1911,7 @@ static int onenand_check_maf(int manuf)
  * @param mtd		MTD device structure
  *
  * OneNAND detection method:
- *   Compare the the values from command with ones from register
+ *   Compare the values from command with ones from register
  */
 static int onenand_probe(struct mtd_info *mtd)
 {
diff -Nurp linux-2.6.20/drivers/net/bonding/bond_main.c linux-2.6.20-the-the/drivers/net/bonding/bond_main.c
--- linux-2.6.20/drivers/net/bonding/bond_main.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/drivers/net/bonding/bond_main.c	2007-02-22 07:59:22.000000000 +0100
@@ -3440,7 +3440,7 @@ void bond_unregister_arp(struct bonding 
 /*---------------------------- Hashing Policies -----------------------------*/
 
 /*
- * Hash for the the output device based upon layer 3 and layer 4 data. If
+ * Hash for the output device based upon layer 3 and layer 4 data. If
  * the packet is a frag or not TCP or UDP, just use layer 3 data.  If it is
  * altogether not IP, mimic bond_xmit_hash_policy_l2()
  */
diff -Nurp linux-2.6.20/drivers/net/e1000/e1000_hw.c linux-2.6.20-the-the/drivers/net/e1000/e1000_hw.c
--- linux-2.6.20/drivers/net/e1000/e1000_hw.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/drivers/net/e1000/e1000_hw.c	2007-02-22 08:14:39.000000000 +0100
@@ -5214,7 +5214,7 @@ e1000_is_onboard_nvm_eeprom(struct e1000
  * hw - Struct containing variables accessed by shared code
  *
  * Reads the first 64 16 bit words of the EEPROM and sums the values read.
- * If the the sum of the 64 16 bit words is 0xBABA, the EEPROM's checksum is
+ * If the sum of the 64 16 bit words is 0xBABA, the EEPROM's checksum is
  * valid.
  *****************************************************************************/
 int32_t
diff -Nurp linux-2.6.20/drivers/net/eepro.c linux-2.6.20-the-the/drivers/net/eepro.c
--- linux-2.6.20/drivers/net/eepro.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/drivers/net/eepro.c	2007-02-22 07:58:42.000000000 +0100
@@ -1126,7 +1126,7 @@ static void eepro_tx_timeout (struct net
 	printk (KERN_ERR "%s: transmit timed out, %s?\n", dev->name,
 		"network cable problem");
 	/* This is not a duplicate. One message for the console,
-	   one for the the log file  */
+	   one for the log file  */
 	printk (KERN_DEBUG "%s: transmit timed out, %s?\n", dev->name,
 		"network cable problem");
 	eepro_complete_selreset(ioaddr);
diff -Nurp linux-2.6.20/drivers/net/ixgb/ixgb_ee.c linux-2.6.20-the-the/drivers/net/ixgb/ixgb_ee.c
--- linux-2.6.20/drivers/net/ixgb/ixgb_ee.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/drivers/net/ixgb/ixgb_ee.c	2007-02-22 08:09:47.000000000 +0100
@@ -315,7 +315,7 @@ ixgb_wait_eeprom_command(struct ixgb_hw 
  * hw - Struct containing variables accessed by shared code
  *
  * Reads the first 64 16 bit words of the EEPROM and sums the values read.
- * If the the sum of the 64 16 bit words is 0xBABA, the EEPROM's checksum is
+ * If the sum of the 64 16 bit words is 0xBABA, the EEPROM's checksum is
  * valid.
  *
  * Returns:
diff -Nurp linux-2.6.20/drivers/net/meth.h linux-2.6.20-the-the/drivers/net/meth.h
--- linux-2.6.20/drivers/net/meth.h	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/drivers/net/meth.h	2007-02-22 08:00:29.000000000 +0100
@@ -126,7 +126,7 @@ typedef struct rx_packet {
 				       /*   Note: when loopback is set this bit becomes collision control.  Setting this bit will */
 				       /*         cause a collision to be reported. */
 
-				       /* Bits 5 and 6 are used to determine the the Destination address filter mode */
+				       /* Bits 5 and 6 are used to determine the Destination address filter mode */
 #define METH_ACCEPT_MY 0			/* 00: Accept PHY address only */
 #define METH_ACCEPT_MCAST 0x20	/* 01: Accept physical, broadcast, and multicast filter matches only */
 #define METH_ACCEPT_AMCAST 0x40	/* 10: Accept physical, broadcast, and all multicast packets */
diff -Nurp linux-2.6.20/drivers/net/tulip/interrupt.c linux-2.6.20-the-the/drivers/net/tulip/interrupt.c
--- linux-2.6.20/drivers/net/tulip/interrupt.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/drivers/net/tulip/interrupt.c	2007-02-22 07:58:54.000000000 +0100
@@ -270,7 +270,7 @@ done:
             This would turn on IM for devices that is not contributing
             to backlog congestion with unnecessary latency.
 
-             We monitor the the device RX-ring and have:
+             We monitor the device RX-ring and have:
 
              HW Interrupt Mitigation either ON or OFF.
 
diff -Nurp linux-2.6.20/drivers/net/tulip/winbond-840.c linux-2.6.20-the-the/drivers/net/tulip/winbond-840.c
--- linux-2.6.20/drivers/net/tulip/winbond-840.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/drivers/net/tulip/winbond-840.c	2007-02-22 08:02:54.000000000 +0100
@@ -1022,7 +1022,7 @@ static int start_tx(struct sk_buff *skb,
 		np->tx_ring[entry].length |= DescEndRing;
 
 	/* Now acquire the irq spinlock.
-	 * The difficult race is the the ordering between
+	 * The difficult race is the ordering between
 	 * increasing np->cur_tx and setting DescOwned:
 	 * - if np->cur_tx is increased first the interrupt
 	 *   handler could consider the packet as transmitted
diff -Nurp linux-2.6.20/drivers/net/tulip/xircom_cb.c linux-2.6.20-the-the/drivers/net/tulip/xircom_cb.c
--- linux-2.6.20/drivers/net/tulip/xircom_cb.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/drivers/net/tulip/xircom_cb.c	2007-02-22 08:14:03.000000000 +0100
@@ -1043,7 +1043,7 @@ static int enable_promisc(struct xircom_
 
 
 /*
-link_status() checks the the links status and will return 0 for no link, 10 for 10mbit link and 100 for.. guess what.
+link_status() checks the links status and will return 0 for no link, 10 for 10mbit link and 100 for.. guess what.
 
 Must be called in locked state with interrupts disabled
 */
diff -Nurp linux-2.6.20/drivers/net/typhoon.c linux-2.6.20-the-the/drivers/net/typhoon.c
--- linux-2.6.20/drivers/net/typhoon.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/drivers/net/typhoon.c	2007-02-22 07:59:53.000000000 +0100
@@ -639,7 +639,7 @@ typhoon_issue_command(struct typhoon *tp
 
 	typhoon_inc_cmd_index(&ring->lastWrite, num_cmd);
 
-	/* "I feel a presence... another warrior is on the the mesa."
+	/* "I feel a presence... another warrior is on the mesa."
 	 */
 	wmb();
 	iowrite32(ring->lastWrite, tp->ioaddr + TYPHOON_REG_CMD_READY);
diff -Nurp linux-2.6.20/drivers/net/wireless/airport.c linux-2.6.20-the-the/drivers/net/wireless/airport.c
--- linux-2.6.20/drivers/net/wireless/airport.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/drivers/net/wireless/airport.c	2007-02-22 08:10:50.000000000 +0100
@@ -149,7 +149,7 @@ static int airport_hard_reset(struct ori
 	/* Vitally important.  If we don't do this it seems we get an
 	 * interrupt somewhere during the power cycle, since
 	 * hw_unavailable is already set it doesn't get ACKed, we get
-	 * into an interrupt loop and the the PMU decides to turn us
+	 * into an interrupt loop and the PMU decides to turn us
 	 * off. */
 	disable_irq(dev->irq);
 
diff -Nurp linux-2.6.20/drivers/s390/char/sclp_rw.c linux-2.6.20-the-the/drivers/s390/char/sclp_rw.c
--- linux-2.6.20/drivers/s390/char/sclp_rw.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/drivers/s390/char/sclp_rw.c	2007-02-22 08:00:04.000000000 +0100
@@ -23,7 +23,7 @@
 
 /*
  * The room for the SCCB (only for writing) is not equal to a pages size
- * (as it is specified as the maximum size in the the SCLP documentation)
+ * (as it is specified as the maximum size in the SCLP documentation)
  * because of the additional data structure described above.
  */
 #define MAX_SCCB_ROOM (PAGE_SIZE - sizeof(struct sclp_buffer))
diff -Nurp linux-2.6.20/drivers/s390/net/qeth_main.c linux-2.6.20-the-the/drivers/s390/net/qeth_main.c
--- linux-2.6.20/drivers/s390/net/qeth_main.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/drivers/s390/net/qeth_main.c	2007-02-22 07:58:31.000000000 +0100
@@ -2773,7 +2773,7 @@ qeth_flush_buffers(struct qeth_qdio_out_
 			if (!atomic_read(&queue->set_pci_flags_count)){
 				/*
 				 * there's no outstanding PCI any more, so we
-				 * have to request a PCI to be sure the the PCI
+				 * have to request a PCI to be sure that the PCI
 				 * will wake at some time in the future then we
 				 * can flush packed buffers that might still be
 				 * hanging around, which can happen if no
diff -Nurp linux-2.6.20/drivers/s390/scsi/zfcp_qdio.c linux-2.6.20-the-the/drivers/s390/scsi/zfcp_qdio.c
--- linux-2.6.20/drivers/s390/scsi/zfcp_qdio.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/drivers/s390/scsi/zfcp_qdio.c	2007-02-22 08:05:05.000000000 +0100
@@ -222,7 +222,7 @@ zfcp_qdio_handler_error_check(struct zfc
                 * Since we have been using this adapter, it is save to assume
                 * that it is not failed but recoverable. The card seems to
                 * report link-up events by self-initiated queue shutdown.
-                * That is why we need to clear the the link-down flag
+                * That is why we need to clear the link-down flag
                 * which is set again in case we have missed by a mile.
                 */
                zfcp_erp_adapter_reopen(
diff -Nurp linux-2.6.20/drivers/scsi/aic7xxx/aic79xx_pci.c linux-2.6.20-the-the/drivers/scsi/aic7xxx/aic79xx_pci.c
--- linux-2.6.20/drivers/scsi/aic7xxx/aic79xx_pci.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/drivers/scsi/aic7xxx/aic79xx_pci.c	2007-02-22 08:06:27.000000000 +0100
@@ -966,7 +966,7 @@ ahd_aic790X_setup(struct ahd_softc *ahd)
 			      |  AHD_BUSFREEREV_BUG;
 		ahd->bugs |= AHD_LQOOVERRUN_BUG|AHD_EARLY_REQ_BUG;
 
-		/* If the user requested the the SLOWCRC bit to be set. */
+		/* If the user requested that the SLOWCRC bit to be set. */
 		if (aic79xx_slowcrc)
 			ahd->features |= AHD_AIC79XXB_SLOWCRC;
 
diff -Nurp linux-2.6.20/drivers/scsi/aic94xx/Makefile linux-2.6.20-the-the/drivers/scsi/aic94xx/Makefile
--- linux-2.6.20/drivers/scsi/aic94xx/Makefile	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/drivers/scsi/aic94xx/Makefile	2007-02-22 08:14:49.000000000 +0100
@@ -6,7 +6,7 @@
 #
 # This file is licensed under GPLv2.
 #
-# This file is part of the the aic94xx driver.
+# This file is part of the aic94xx driver.
 #
 # The aic94xx driver is free software; you can redistribute it and/or
 # modify it under the terms of the GNU General Public License as
diff -Nurp linux-2.6.20/drivers/scsi/dc395x.c linux-2.6.20-the-the/drivers/scsi/dc395x.c
--- linux-2.6.20/drivers/scsi/dc395x.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/drivers/scsi/dc395x.c	2007-02-22 07:56:02.000000000 +0100
@@ -541,7 +541,7 @@ static struct ParameterData __devinitdat
 
 
 /*
- * Safe settings. If set to zero the the BIOS/default values with
+ * Safe settings. If set to zero the BIOS/default values with
  * command line overrides will be used. If set to 1 then safe and
  * slow settings will be used.
  */
@@ -617,7 +617,7 @@ static void __devinit fix_settings(void)
 
 /*
  * Mapping from the eeprom delay index value (index into this array)
- * to the the number of actual seconds that the delay should be for.
+ * to the number of actual seconds that the delay should be for.
  */
 static char __devinitdata eeprom_index_to_delay_map[] = 
 	{ 1, 3, 5, 10, 16, 30, 60, 120 };
@@ -4136,7 +4136,7 @@ static void __devinit trms1040_write_all
  * @io_port:	base I/O address
  * @addr:	offset into SEEPROM
  *
- * Returns the the byte read.
+ * Returns the byte read.
  **/
 static u8 __devinit trms1040_get_data(unsigned long io_port, u8 addr)
 {
diff -Nurp linux-2.6.20/drivers/scsi/scsi_lib.c linux-2.6.20-the-the/drivers/scsi/scsi_lib.c
--- linux-2.6.20/drivers/scsi/scsi_lib.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/drivers/scsi/scsi_lib.c	2007-02-22 08:13:03.000000000 +0100
@@ -173,7 +173,7 @@ int scsi_queue_insert(struct scsi_cmnd *
  * @retries:	number of times to retry request
  * @flags:	or into request flags;
  *
- * returns the req->errors value which is the the scsi_cmnd result
+ * returns the req->errors value which is the scsi_cmnd result
  * field.
  **/
 int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
diff -Nurp linux-2.6.20/drivers/usb/host/hc_crisv10.h linux-2.6.20-the-the/drivers/usb/host/hc_crisv10.h
--- linux-2.6.20/drivers/usb/host/hc_crisv10.h	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/drivers/usb/host/hc_crisv10.h	2007-02-22 08:15:00.000000000 +0100
@@ -93,7 +93,7 @@ typedef struct etrax_usb_urb_priv {
 	__u8 epid;
 
 	/* The rx_data_list field is used for periodic traffic, to hold
-	   received data for later processing in the the complete_urb functions,
+	   received data for later processing in the complete_urb functions,
 	   where the data us copied to the urb's transfer_buffer. Basically, we
 	   use this intermediate storage because we don't know when it's safe to
 	   reuse the transfer_buffer (FIXME?). */
diff -Nurp linux-2.6.20/drivers/usb/misc/auerswald.c linux-2.6.20-the-the/drivers/usb/misc/auerswald.c
--- linux-2.6.20/drivers/usb/misc/auerswald.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/drivers/usb/misc/auerswald.c	2007-02-22 08:05:40.000000000 +0100
@@ -1307,7 +1307,7 @@ static int auerswald_addservice (pauersw
 }
 
 
-/* remove a service from the the device
+/* remove a service from the device
    scp->id must be set! */
 static void auerswald_removeservice (pauerswald_t cp, pauerscon_t scp)
 {
diff -Nurp linux-2.6.20/drivers/usb/net/usbnet.h linux-2.6.20-the-the/drivers/usb/net/usbnet.h
--- linux-2.6.20/drivers/usb/net/usbnet.h	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/drivers/usb/net/usbnet.h	2007-02-22 08:10:08.000000000 +0100
@@ -128,7 +128,7 @@ extern void usbnet_disconnect(struct usb
 
 
 /* Drivers that reuse some of the standard USB CDC infrastructure
- * (notably, using multiple interfaces according to the the CDC
+ * (notably, using multiple interfaces according to the CDC
  * union descriptor) get some helper code.
  */
 struct cdc_state {
diff -Nurp linux-2.6.20/drivers/video/i810/i810_main.c linux-2.6.20-the-the/drivers/video/i810/i810_main.c
--- linux-2.6.20/drivers/video/i810/i810_main.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/drivers/video/i810/i810_main.c	2007-02-22 08:15:10.000000000 +0100
@@ -1714,7 +1714,7 @@ static int __devinit i810_alloc_agp_mem(
  * @info: pointer to device specific info structure
  *
  * DESCRIPTION:
- * Sets the the user monitor's horizontal and vertical
+ * Sets the user monitor's horizontal and vertical
  * frequency limits
  */
 static void __devinit i810_init_monspecs(struct fb_info *info)
diff -Nurp linux-2.6.20/drivers/video/skeletonfb.c linux-2.6.20-the-the/drivers/video/skeletonfb.c
--- linux-2.6.20/drivers/video/skeletonfb.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/drivers/video/skeletonfb.c	2007-02-22 08:15:19.000000000 +0100
@@ -14,7 +14,7 @@
  *  of it. 
  *
  *  First the roles of struct fb_info and struct display have changed. Struct
- *  display will go away. The way the the new framebuffer console code will
+ *  display will go away. The way the new framebuffer console code will
  *  work is that it will act to translate data about the tty/console in 
  *  struct vc_data to data in a device independent way in struct fb_info. Then
  *  various functions in struct fb_ops will be called to store the device 
diff -Nurp linux-2.6.20/fs/ext2/ext2.h linux-2.6.20-the-the/fs/ext2/ext2.h
--- linux-2.6.20/fs/ext2/ext2.h	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/fs/ext2/ext2.h	2007-02-22 07:59:03.000000000 +0100
@@ -42,7 +42,7 @@ struct ext2_inode_info {
 
 	/*
 	 * i_next_alloc_goal is the *physical* companion to i_next_alloc_block.
-	 * it the the physical block number of the block which was most-recently
+	 * it the physical block number of the block which was most-recently
 	 * allocated to this file.  This give us the goal (target) for the next
 	 * allocation when we detect linearly ascending requests.
 	 */
diff -Nurp linux-2.6.20/fs/jfs/jfs_dmap.c linux-2.6.20-the-the/fs/jfs/jfs_dmap.c
--- linux-2.6.20/fs/jfs/jfs_dmap.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/fs/jfs/jfs_dmap.c	2007-02-22 07:58:16.000000000 +0100
@@ -1507,7 +1507,7 @@ dbAllocAG(struct bmap * bmp, int agno, s
 		if (l2nb < budmin) {
 
 			/* search the lower level dmap control pages to get
-			 * the starting block number of the the dmap that
+			 * the starting block number of the dmap that
 			 * contains or starts off the free space.
 			 */
 			if ((rc =
diff -Nurp linux-2.6.20/fs/jfs/jfs_imap.c linux-2.6.20-the-the/fs/jfs/jfs_imap.c
--- linux-2.6.20/fs/jfs/jfs_imap.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/fs/jfs/jfs_imap.c	2007-02-22 08:01:25.000000000 +0100
@@ -386,7 +386,7 @@ int diRead(struct inode *ip)
 		return -EIO;
 	}
 
-	/* locate the the disk inode requested */
+	/* locate the disk inode requested */
 	dp = (struct dinode *) mp->data;
 	dp += rel_inode;
 
@@ -1407,7 +1407,7 @@ int diAlloc(struct inode *pip, bool dir,
 	inum = pip->i_ino + 1;
 	ino = inum & (INOSPERIAG - 1);
 
-	/* back off the the hint if it is outside of the iag */
+	/* back off the hint if it is outside of the iag */
 	if (ino == 0)
 		inum = pip->i_ino;
 
diff -Nurp linux-2.6.20/fs/jfs/jfs_logmgr.c linux-2.6.20-the-the/fs/jfs/jfs_logmgr.c
--- linux-2.6.20/fs/jfs/jfs_logmgr.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/fs/jfs/jfs_logmgr.c	2007-02-22 08:03:44.000000000 +0100
@@ -1961,7 +1961,7 @@ static void lbmfree(struct lbuf * bp)
 /*
  * NAME:	lbmRedrive
  *
- * FUNCTION:	add a log buffer to the the log redrive list
+ * FUNCTION:	add a log buffer to the log redrive list
  *
  * PARAMETER:
  *     bp	- log buffer
diff -Nurp linux-2.6.20/fs/xfs/xfs_itable.c linux-2.6.20-the-the/fs/xfs/xfs_itable.c
--- linux-2.6.20/fs/xfs/xfs_itable.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/fs/xfs/xfs_itable.c	2007-02-22 08:05:16.000000000 +0100
@@ -809,7 +809,7 @@ xfs_inumbers(
 				xfs_buf_relse(agbp);
 				agbp = NULL;
 				/*
-				 * Move up the the last inode in the current
+				 * Move up the last inode in the current
 				 * chunk.  The lookup_ge will always get
 				 * us the first inode in the next chunk.
 				 */
diff -Nurp linux-2.6.20/include/asm-arm/dma-mapping.h linux-2.6.20-the-the/include/asm-arm/dma-mapping.h
--- linux-2.6.20/include/asm-arm/dma-mapping.h	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/include/asm-arm/dma-mapping.h	2007-02-22 08:03:07.000000000 +0100
@@ -429,7 +429,7 @@ extern void dmabounce_unregister_dev(str
  *
  * The dmabounce routines call this function whenever a dma-mapping
  * is requested to determine whether a given buffer needs to be bounced
- * or not. The function must return 0 if the the buffer is OK for
+ * or not. The function must return 0 if the buffer is OK for
  * DMA access and 1 if the buffer needs to be bounced.
  *
  */
diff -Nurp linux-2.6.20/include/asm-powerpc/ppc-pci.h linux-2.6.20-the-the/include/asm-powerpc/ppc-pci.h
--- linux-2.6.20/include/asm-powerpc/ppc-pci.h	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/include/asm-powerpc/ppc-pci.h	2007-02-22 08:01:55.000000000 +0100
@@ -62,7 +62,7 @@ struct pci_dev *pci_get_device_by_addr(u
  * eeh_slot_error_detail -- record and EEH error condition to the log
  * @severity: 1 if temporary, 2 if permanent failure.
  *
- * Obtains the the EEH error details from the RTAS subsystem,
+ * Obtains the EEH error details from the RTAS subsystem,
  * and then logs these details with the RTAS error log system.
  */
 void eeh_slot_error_detail (struct pci_dn *pdn, int severity);
diff -Nurp linux-2.6.20/include/linux/ext3_fs_i.h linux-2.6.20-the-the/include/linux/ext3_fs_i.h
--- linux-2.6.20/include/linux/ext3_fs_i.h	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/include/linux/ext3_fs_i.h	2007-02-22 07:56:58.000000000 +0100
@@ -54,7 +54,7 @@ struct ext3_block_alloc_info {
 	/*
 	 * Was i_next_alloc_goal in ext3_inode_info
 	 * is the *physical* companion to i_next_alloc_block.
-	 * it the the physical block number of the block which was most-recentl
+	 * it the physical block number of the block which was most-recentl
 	 * allocated to this file.  This give us the goal (target) for the next
 	 * allocation when we detect linearly ascending requests.
 	 */
diff -Nurp linux-2.6.20/include/linux/ext4_fs_i.h linux-2.6.20-the-the/include/linux/ext4_fs_i.h
--- linux-2.6.20/include/linux/ext4_fs_i.h	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/include/linux/ext4_fs_i.h	2007-02-22 08:00:15.000000000 +0100
@@ -52,7 +52,7 @@ struct ext4_block_alloc_info {
 	/*
 	 * Was i_next_alloc_goal in ext4_inode_info
 	 * is the *physical* companion to i_next_alloc_block.
-	 * it the the physical block number of the block which was most-recentl
+	 * it the physical block number of the block which was most-recentl
 	 * allocated to this file.  This give us the goal (target) for the next
 	 * allocation when we detect linearly ascending requests.
 	 */
diff -Nurp linux-2.6.20/include/linux/radix-tree.h linux-2.6.20-the-the/include/linux/radix-tree.h
--- linux-2.6.20/include/linux/radix-tree.h	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/include/linux/radix-tree.h	2007-02-22 08:01:01.000000000 +0100
@@ -87,10 +87,10 @@ do {									\
  * management of their lifetimes must be completely managed by API users.
  *
  * For API usage, in general,
- * - any function _modifying_ the the tree or tags (inserting or deleting
+ * - any function _modifying_ the tree or tags (inserting or deleting
  *   items, setting or clearing tags must exclude other modifications, and
  *   exclude any functions reading the tree.
- * - any function _reading_ the the tree or tags (looking up items or tags,
+ * - any function _reading_ the tree or tags (looking up items or tags,
  *   gang lookups) must exclude modifications to the tree, but may occur
  *   concurrently with other readers.
  *
diff -Nurp linux-2.6.20/include/linux/security.h linux-2.6.20-the-the/include/linux/security.h
--- linux-2.6.20/include/linux/security.h	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/include/linux/security.h	2007-02-22 08:06:37.000000000 +0100
@@ -322,7 +322,7 @@ struct request_sock;
  *	@dir contains the inode structure of parent of the new file.
  *	@dentry contains the dentry structure of the new file.
  *	@mode contains the mode of the new file.
- *	@dev contains the the device number.
+ *	@dev contains the device number.
  *	Return 0 if permission is granted.
  * @inode_rename:
  *	Check for permission to rename a file or directory.
diff -Nurp linux-2.6.20/include/linux/usb.h linux-2.6.20-the-the/include/linux/usb.h
--- linux-2.6.20/include/linux/usb.h	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/include/linux/usb.h	2007-02-22 07:52:59.000000000 +0100
@@ -125,7 +125,7 @@ enum usb_interface_condition {
  * Each interface may have alternate settings.  The initial configuration
  * of a device sets altsetting 0, but the device driver can change
  * that setting using usb_set_interface().  Alternate settings are often
- * used to control the the use of periodic endpoints, such as by having
+ * used to control the use of periodic endpoints, such as by having
  * different endpoints use different amounts of reserved USB bandwidth.
  * All standards-conformant USB devices that use isochronous endpoints
  * will use them in non-default settings.
diff -Nurp linux-2.6.20/initramfs/dummy linux-2.6.20-the-the/initramfs/dummy
--- linux-2.6.20/initramfs/dummy	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.20-the-the/initramfs/dummy	2007-02-06 22:16:46.000000000 +0100
@@ -0,0 +1 @@
+dummy file
diff -Nurp linux-2.6.20/kernel/relay.c linux-2.6.20-the-the/kernel/relay.c
--- linux-2.6.20/kernel/relay.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/kernel/relay.c	2007-02-22 07:57:21.000000000 +0100
@@ -302,7 +302,7 @@ static struct rchan_callbacks default_ch
 
 /**
  *	wakeup_readers - wake up readers waiting on a channel
- *	@work: work struct that contains the the channel buffer
+ *	@work: work struct that contains the channel buffer
  *
  *	This is the work function used to defer reader waking.  The
  *	reason waking is deferred is that calling directly from write
diff -Nurp linux-2.6.20/kernel/wait.c linux-2.6.20-the-the/kernel/wait.c
--- linux-2.6.20/kernel/wait.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/kernel/wait.c	2007-02-22 07:59:39.000000000 +0100
@@ -61,7 +61,7 @@ EXPORT_SYMBOL(remove_wait_queue);
  * The spin_unlock() itself is semi-permeable and only protects
  * one way (it only protects stuff inside the critical region and
  * stops them from bleeding out - it would still allow subsequent
- * loads to move into the the critical region).
+ * loads to move into the critical region).
  */
 void fastcall
 prepare_to_wait(wait_queue_head_t *q, wait_queue_t *wait, int state)
diff -Nurp linux-2.6.20/mm/mmap.c linux-2.6.20-the-the/mm/mmap.c
--- linux-2.6.20/mm/mmap.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/mm/mmap.c	2007-02-22 07:55:33.000000000 +0100
@@ -1729,7 +1729,7 @@ detach_vmas_to_be_unmapped(struct mm_str
 
 /*
  * Split a vma into two pieces at address 'addr', a new vma is allocated
- * either for the first part or the the tail.
+ * either for the first part or the tail.
  */
 int split_vma(struct mm_struct * mm, struct vm_area_struct * vma,
 	      unsigned long addr, int new_below)
diff -Nurp linux-2.6.20/net/decnet/af_decnet.c linux-2.6.20-the-the/net/decnet/af_decnet.c
--- linux-2.6.20/net/decnet/af_decnet.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/net/decnet/af_decnet.c	2007-02-22 08:15:28.000000000 +0100
@@ -1836,7 +1836,7 @@ static inline int dn_queue_too_long(stru
 }
 
 /*
- * The DECnet spec requires the the "routing layer" accepts packets which
+ * The DECnet spec requires that the "routing layer" accepts packets which
  * are at least 230 bytes in size. This excludes any headers which the NSP
  * layer might add, so we always assume that we'll be using the maximal
  * length header on data packets. The variation in length is due to the
diff -Nurp linux-2.6.20/net/ipv4/cipso_ipv4.c linux-2.6.20-the-the/net/ipv4/cipso_ipv4.c
--- linux-2.6.20/net/ipv4/cipso_ipv4.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/net/ipv4/cipso_ipv4.c	2007-02-22 08:11:19.000000000 +0100
@@ -602,7 +602,7 @@ doi_walk_return:
  * @domain: the domain to add
  *
  * Description:
- * Adds the @domain to the the DOI specified by @doi_def, this function
+ * Adds the @domain to the DOI specified by @doi_def, this function
  * should only be called by external functions (i.e. NetLabel).  This function
  * does allocate memory.  Returns zero on success, negative values on failure.
  *
diff -Nurp linux-2.6.20/net/ipv4/ipvs/ip_vs_sed.c linux-2.6.20-the-the/net/ipv4/ipvs/ip_vs_sed.c
--- linux-2.6.20/net/ipv4/ipvs/ip_vs_sed.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/net/ipv4/ipvs/ip_vs_sed.c	2007-02-22 08:12:51.000000000 +0100
@@ -18,7 +18,7 @@
  * The SED algorithm attempts to minimize each job's expected delay until
  * completion. The expected delay that the job will experience is
  * (Ci + 1) / Ui if sent to the ith server, in which Ci is the number of
- * jobs on the the ith server and Ui is the fixed service rate (weight) of
+ * jobs on the ith server and Ui is the fixed service rate (weight) of
  * the ith server. The SED algorithm adopts a greedy policy that each does
  * what is in its own best interest, i.e. to join the queue which would
  * minimize its expected delay of completion.
diff -Nurp linux-2.6.20/net/ipv4/netfilter/ip_conntrack_core.c linux-2.6.20-the-the/net/ipv4/netfilter/ip_conntrack_core.c
--- linux-2.6.20/net/ipv4/netfilter/ip_conntrack_core.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/net/ipv4/netfilter/ip_conntrack_core.c	2007-02-22 08:12:41.000000000 +0100
@@ -910,7 +910,7 @@ void ip_conntrack_unexpect_related(struc
 	struct ip_conntrack_expect *i;
 
 	write_lock_bh(&ip_conntrack_lock);
-	/* choose the the oldest expectation to evict */
+	/* choose the oldest expectation to evict */
 	list_for_each_entry_reverse(i, &ip_conntrack_expect_list, list) {
 		if (expect_matches(i, exp) && del_timer(&i->timeout)) {
 			ip_ct_unlink_expect(i);
diff -Nurp linux-2.6.20/net/ipv4/udp.c linux-2.6.20-the-the/net/ipv4/udp.c
--- linux-2.6.20/net/ipv4/udp.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/net/ipv4/udp.c	2007-02-22 07:59:12.000000000 +0100
@@ -915,7 +915,7 @@ int udp_disconnect(struct sock *sk, int 
 }
 
 /* return:
- * 	1  if the the UDP system should process it
+ * 	1  if the UDP system should process it
  *	0  if we should drop this packet
  * 	-1 if it should get processed by xfrm4_rcv_encap
  */
diff -Nurp linux-2.6.20/net/llc/af_llc.c linux-2.6.20-the-the/net/llc/af_llc.c
--- linux-2.6.20/net/llc/af_llc.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/net/llc/af_llc.c	2007-02-22 07:55:16.000000000 +0100
@@ -324,7 +324,7 @@ static int llc_ui_bind(struct socket *so
 		memset(&laddr, 0, sizeof(laddr));
 		memset(&daddr, 0, sizeof(daddr));
 		/*
-		 * FIXME: check if the the address is multicast,
+		 * FIXME: check if the address is multicast,
 		 * 	  only SOCK_DGRAM can do this.
 		 */
 		memcpy(laddr.mac, addr->sllc_mac, IFHWADDRLEN);
diff -Nurp linux-2.6.20/net/netfilter/nf_conntrack_expect.c linux-2.6.20-the-the/net/netfilter/nf_conntrack_expect.c
--- linux-2.6.20/net/netfilter/nf_conntrack_expect.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/net/netfilter/nf_conntrack_expect.c	2007-02-22 08:11:28.000000000 +0100
@@ -177,7 +177,7 @@ void nf_conntrack_unexpect_related(struc
 	struct nf_conntrack_expect *i;
 
 	write_lock_bh(&nf_conntrack_lock);
-	/* choose the the oldest expectation to evict */
+	/* choose the oldest expectation to evict */
 	list_for_each_entry_reverse(i, &nf_conntrack_expect_list, list) {
 		if (expect_matches(i, exp) && del_timer(&i->timeout)) {
 			nf_ct_unlink_expect(i);
diff -Nurp linux-2.6.20/net/rxrpc/connection.c linux-2.6.20-the-the/net/rxrpc/connection.c
--- linux-2.6.20/net/rxrpc/connection.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/net/rxrpc/connection.c	2007-02-22 08:12:31.000000000 +0100
@@ -496,7 +496,7 @@ void rxrpc_conn_clearall(struct rxrpc_pe
 	}
 	spin_unlock(&peer->conn_gylock);
 
-	/* wait for the the conn graveyard to be completely cleared */
+	/* wait for the conn graveyard to be completely cleared */
 	set_current_state(TASK_UNINTERRUPTIBLE);
 	add_wait_queue(&peer->conn_gy_waitq, &myself);
 
diff -Nurp linux-2.6.20/net/rxrpc/peer.c linux-2.6.20-the-the/net/rxrpc/peer.c
--- linux-2.6.20/net/rxrpc/peer.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/net/rxrpc/peer.c	2007-02-22 07:57:47.000000000 +0100
@@ -343,7 +343,7 @@ void rxrpc_peer_clearall(struct rxrpc_tr
 	}
 	spin_unlock(&trans->peer_gylock);
 
-	/* wait for the the peer graveyard to be completely cleared */
+	/* wait for the peer graveyard to be completely cleared */
 	set_current_state(TASK_UNINTERRUPTIBLE);
 	add_wait_queue(&trans->peer_gy_waitq, &myself);
 
diff -Nurp linux-2.6.20/net/sctp/chunk.c linux-2.6.20-the-the/net/sctp/chunk.c
--- linux-2.6.20/net/sctp/chunk.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/net/sctp/chunk.c	2007-02-22 08:01:14.000000000 +0100
@@ -3,7 +3,7 @@
  *
  * This file is part of the SCTP kernel reference Implementation
  *
- * This file contains the code relating the the chunk abstraction.
+ * This file contains the code relating the chunk abstraction.
  *
  * The SCTP reference implementation is free software;
  * you can redistribute it and/or modify it under the terms of
diff -Nurp linux-2.6.20/net/sctp/socket.c linux-2.6.20-the-the/net/sctp/socket.c
--- linux-2.6.20/net/sctp/socket.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/net/sctp/socket.c	2007-02-22 07:58:06.000000000 +0100
@@ -2538,7 +2538,7 @@ static int sctp_setsockopt_rtoinfo(struc
  *
  * 7.1.2 SCTP_ASSOCINFO
  *
- * This option is used to tune the the maximum retransmission attempts
+ * This option is used to tune the maximum retransmission attempts
  * of the association.
  * Returns an error if the new association retransmission value is
  * greater than the sum of the retransmission value  of the peer.
@@ -4369,7 +4369,7 @@ static int sctp_getsockopt_rtoinfo(struc
  *
  * 7.1.2 SCTP_ASSOCINFO
  *
- * This option is used to tune the the maximum retransmission attempts
+ * This option is used to tune the maximum retransmission attempts
  * of the association.
  * Returns an error if the new association retransmission value is
  * greater than the sum of the retransmission value  of the peer.
diff -Nurp linux-2.6.20/net/sunrpc/svcauth.c linux-2.6.20-the-the/net/sunrpc/svcauth.c
--- linux-2.6.20/net/sunrpc/svcauth.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/net/sunrpc/svcauth.c	2007-02-22 08:02:10.000000000 +0100
@@ -65,7 +65,7 @@ int svc_set_client(struct svc_rqst *rqst
 }
 
 /* A request, which was authenticated, has now executed.
- * Time to finalise the the credentials and verifier
+ * Time to finalise the credentials and verifier
  * and release and resources
  */
 int svc_authorise(struct svc_rqst *rqstp)
diff -Nurp linux-2.6.20/net/tipc/link.c linux-2.6.20-the-the/net/tipc/link.c
--- linux-2.6.20/net/tipc/link.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/net/tipc/link.c	2007-02-22 08:00:39.000000000 +0100
@@ -1128,7 +1128,7 @@ int tipc_link_send_buf(struct link *l_pt
 
 /* 
  * tipc_link_send(): same as tipc_link_send_buf(), but the link to use has 
- * not been selected yet, and the the owner node is not locked
+ * not been selected yet, and the owner node is not locked
  * Called by TIPC internal users, e.g. the name distributor
  */
 
diff -Nurp linux-2.6.20/scripts/basic/docproc.c linux-2.6.20-the-the/scripts/basic/docproc.c
--- linux-2.6.20/scripts/basic/docproc.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/scripts/basic/docproc.c	2007-02-22 08:03:34.000000000 +0100
@@ -211,7 +211,7 @@ void find_export_symbols(char * filename
  * Document all external or internal functions in a file.
  * Call kernel-doc with following parameters:
  * kernel-doc -docbook -nofunction function_name1 filename
- * function names are obtained from all the the src files
+ * function names are obtained from all the src files
  * by find_export_symbols.
  * intfunc uses -nofunction
  * extfunc uses -function
diff -Nurp linux-2.6.20/sound/pci/ac97/ac97_codec.c linux-2.6.20-the-the/sound/pci/ac97/ac97_codec.c
--- linux-2.6.20/sound/pci/ac97/ac97_codec.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-the-the/sound/pci/ac97/ac97_codec.c	2007-02-22 08:03:22.000000000 +0100
@@ -1075,7 +1075,7 @@ static void check_volume_resolution(stru
 		unsigned short val;
 		snd_ac97_write(ac97, reg, 0x8080 | cbit[i] | (cbit[i] << 8));
 		/* Do the read twice due to buffers on some ac97 codecs.
-		 * e.g. The STAC9704 returns exactly what you wrote the the register
+		 * e.g. The STAC9704 returns exactly what you wrote to the register
 		 * if you read it immediately. This causes the detect routine to fail.
 		 */
 		val = snd_ac97_read(ac97, reg);

-- 
Michael Opdenacker, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)
