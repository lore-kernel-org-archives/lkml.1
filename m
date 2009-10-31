Return-Path: <linux-kernel-owner+w=401wt.eu-S932230AbZJaJlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230AbZJaJlb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 05:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757588AbZJaJlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 05:41:25 -0400
Received: from mail-vw0-f192.google.com ([209.85.212.192]:35835 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757573AbZJaJlV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 05:41:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=ZCwtRSdfOHAFILntfdG+sWYZcO/7hFr8SP3+1M5TsiT6NWlEbflc/jFaEvaxP1u7OU
         3hHHI1hTfk31EuBUIP4eaE6ZofoYwoi2o+iYSEfZyOZkd8a7tuvQ3BEjj/LbqcKa5OrH
         +qBRBNCAdleoH5dqEz53UgcD16MdhyuPzn3X0=
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Sat, 31 Oct 2009 07:41:06 -0200
Message-ID: <b8bf37780910310241o4f880fa8w5e888ec4e9da6e73@mail.gmail.com>
Subject: [PATCH 06/16] trivial: fix assorted "access" typos
To: trivial@kernel.org, linux list <linux-kernel@vger.kernel.org>
Cc: me <andre.goddard@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4209a3729836111f4c397e40a96cc1af66400f1d Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Date: Fri, 30 Oct 2009 06:42:26 -0200
Subject: [PATCH 06/16] trivial: fix assorted "access" typos
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>

diff --git a/Documentation/spi/spi-summary b/Documentation/spi/spi-summary
index deab51d..4884cb3 100644
--- a/Documentation/spi/spi-summary
+++ b/Documentation/spi/spi-summary
@@ -538,7 +538,7 @@ SPI MESSAGE QUEUE
 The bulk of the driver will be managing the I/O queue fed by transfer().

 That queue could be purely conceptual.  For example, a driver used only
-for low-frequency sensor acess might be fine using synchronous PIO.
+for low-frequency sensor access might be fine using synchronous PIO.

 But the queue will probably be very real, using message->queue, PIO,
 often DMA (especially if the root filesystem is in SPI flash), and
diff --git a/arch/cris/mm/fault.c b/arch/cris/mm/fault.c
index 4a7cdd9..380df1a 100644
--- a/arch/cris/mm/fault.c
+++ b/arch/cris/mm/fault.c
@@ -209,7 +209,7 @@ do_page_fault(unsigned long address, struct pt_regs *regs,
 	/* Are we prepared to handle this kernel fault?
 	 *
 	 * (The kernel has valid exception-points in the source
-	 *  when it acesses user-memory. When it fails in one
+	 *  when it accesses user-memory. When it fails in one
 	 *  of those points, we find it in a table and do a jump
 	 *  to some fixup code that loads an appropriate error
 	 *  code)
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_pci.c
b/arch/powerpc/platforms/52xx/mpc52xx_pci.c
index dd43114..da110bd 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_pci.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_pci.c
@@ -100,7 +100,7 @@ const struct of_device_id mpc52xx_pci_ids[] __initdata = {
 };

 /* ======================================================================== */
-/* PCI configuration acess                                                  */
+/* PCI configuration access                                                 */
 /* ======================================================================== */

 static int
diff --git a/arch/x86/include/asm/desc_defs.h b/arch/x86/include/asm/desc_defs.h
index 9d66848..278441f 100644
--- a/arch/x86/include/asm/desc_defs.h
+++ b/arch/x86/include/asm/desc_defs.h
@@ -12,9 +12,9 @@
 #include <linux/types.h>

 /*
- * FIXME: Acessing the desc_struct through its fields is more elegant,
+ * FIXME: Accessing the desc_struct through its fields is more elegant,
  * and should be the one valid thing to do. However, a lot of open code
- * still touches the a and b acessors, and doing this allow us to do it
+ * still touches the a and b accessors, and doing this allow us to do it
  * incrementally. We keep the signature as a struct, rather than an union,
  * so we can get rid of it transparently in the future -- glommer
  */
diff --git a/drivers/infiniband/hw/ipath/ipath_sd7220.c
b/drivers/infiniband/hw/ipath/ipath_sd7220.c
index aa47eb5..cdd0b32 100644
--- a/drivers/infiniband/hw/ipath/ipath_sd7220.c
+++ b/drivers/infiniband/hw/ipath/ipath_sd7220.c
@@ -614,7 +614,7 @@ static int epb_trans(struct ipath_devdata *dd, u16
reg, u64 i_val, u64 *o_vp)
  * @wd: Write Data - value to set in register
  * @mask: ones where data should be spliced into reg.
  *
- * Basic register read/modify/write, with un-needed acesses elided. That is,
+ * Basic register read/modify/write, with un-needed accesses elided. That is,
  * a mask of zero will prevent write, while a mask of 0xFF will prevent read.
  * returns current (presumed, if a write was done) contents of selected
  * register, or <0 if errors.
diff --git a/drivers/net/e1000e/82571.c b/drivers/net/e1000e/82571.c
index 61c083a..b7ce406 100644
--- a/drivers/net/e1000e/82571.c
+++ b/drivers/net/e1000e/82571.c
@@ -282,7 +282,7 @@ static s32 e1000_init_mac_params_82571(struct
e1000_adapter *adapter)

 	/*
 	 * Ensure that the inter-port SWSM.SMBI lock bit is clear before
-	 * first NVM or PHY acess. This should be done for single-port
+	 * first NVM or PHY access. This should be done for single-port
 	 * devices, and for one port only on dual-port devices so that
 	 * for those devices we can still use the SMBI lock to synchronize
 	 * inter-port accesses to the PHY & NVM.
diff --git a/drivers/platform/x86/thinkpad_acpi.c
b/drivers/platform/x86/thinkpad_acpi.c
index b408189..7e7da18 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -6535,7 +6535,7 @@ static struct ibm_struct volume_driver_data = {
  * 	The speeds are stored on handles
  * 	(FANA:FAN9), (FANC:FANB), (FANE:FAND).
  *
- * 	There are three default speed sets, acessible as handles:
+ * 	There are three default speed sets, accessible as handles:
  * 	FS1L,FS1M,FS1H; FS2L,FS2M,FS2H; FS3L,FS3M,FS3H
  *
  * 	ACPI DSDT switches which set is in use depending on various
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index f5a9add..07ce9bf 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -1491,7 +1491,7 @@ NCR_700_intr(int irq, void *dev_id)
 	unsigned long flags;
 	int handled = 0;

-	/* Use the host lock to serialise acess to the 53c700
+	/* Use the host lock to serialise access to the 53c700
 	 * hardware.  Note: In future, we may need to take the queue
 	 * lock to enter the done routines.  When that happens, we
 	 * need to ensure that for this driver, the host lock and the
diff --git a/drivers/serial/pmac_zilog.h b/drivers/serial/pmac_zilog.h
index 570b0d9..f6e77f1 100644
--- a/drivers/serial/pmac_zilog.h
+++ b/drivers/serial/pmac_zilog.h
@@ -73,7 +73,7 @@ static inline struct uart_pmac_port
*pmz_get_port_A(struct uart_pmac_port *uap)
 }

 /*
- * Register acessors. Note that we don't need to enforce a recovery
+ * Register accessors. Note that we don't need to enforce a recovery
  * delay on PCI PowerMac hardware, it's dealt in HW by the MacIO chip,
  * though if we try to use this driver on older machines, we might have
  * to add it back
diff --git a/drivers/usb/atm/ueagle-atm.c b/drivers/usb/atm/ueagle-atm.c
index 9df9242..30e49f3 100644
--- a/drivers/usb/atm/ueagle-atm.c
+++ b/drivers/usb/atm/ueagle-atm.c
@@ -1958,7 +1958,7 @@ static void uea_dispatch_cmv_e1(struct uea_softc
*sc, struct intr_pkt *intr)
 		goto bad1;

 	/* FIXME : ADI930 reply wrong preambule (func = 2, sub = 2) to
-	 * the first MEMACESS cmv. Ignore it...
+	 * the first MEMACCESS cmv. Ignore it...
 	 */
 	if (cmv->bFunction != dsc->function) {
 		if (UEA_CHIP_VERSION(sc) == ADI930
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 5e24925..3b861eb 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -917,8 +917,8 @@ undo_setattr:
 /*
  * If dentry->d_inode is null (usually meaning the cached dentry
  * is a negative dentry) then we would attempt a standard SMB delete, but
- * if that fails we can not attempt the fall back mechanisms on EACESS
- * but will return the EACESS to the caller.  Note that the VFS does not call
+ * if that fails we can not attempt the fall back mechanisms on EACCESS
+ * but will return the EACCESS to the caller.  Note that the VFS does not call
  * unlink on negative dentries currently.
  */
 int cifs_unlink(struct inode *dir, struct dentry *dentry)
diff --git a/include/linux/mfd/ezx-pcap.h b/include/linux/mfd/ezx-pcap.h
index e5124ce..3402042 100644
--- a/include/linux/mfd/ezx-pcap.h
+++ b/include/linux/mfd/ezx-pcap.h
@@ -45,7 +45,7 @@ void pcap_set_ts_bits(struct pcap_chip *, u32);
 #define PCAP_CLEAR_INTERRUPT_REGISTER	0x01ffffff
 #define PCAP_MASK_ALL_INTERRUPT		0x01ffffff

-/* registers acessible by both pcap ports */
+/* registers accessible by both pcap ports */
 #define PCAP_REG_ISR		0x0	/* Interrupt Status */
 #define PCAP_REG_MSR		0x1	/* Interrupt Mask */
 #define PCAP_REG_PSTAT		0x2	/* Processor Status */
@@ -67,7 +67,7 @@ void pcap_set_ts_bits(struct pcap_chip *, u32);
 #define PCAP_REG_VENDOR_TEST1	0x1e
 #define PCAP_REG_VENDOR_TEST2	0x1f

-/* registers acessible by pcap port 1 only (a1200, e2 & e6) */
+/* registers accessible by pcap port 1 only (a1200, e2 & e6) */
 #define PCAP_REG_INT_SEL	0x3	/* Interrupt Select */
 #define PCAP_REG_SWCTRL		0x4	/* Switching Regulator Control */
 #define PCAP_REG_VREG1		0x5	/* Regulator Bank 1 Control */
-- 
1.6.5.2.101.gcd0f8
