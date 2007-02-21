Return-Path: <linux-kernel-owner+w=401wt.eu-S1422695AbXBUROG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422695AbXBUROG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 12:14:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422675AbXBUROG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 12:14:06 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:35819 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422695AbXBUROC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 12:14:02 -0500
X-Originating-Ip: 74.108.223.9
Date: Wed, 21 Feb 2007 12:10:44 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org
Subject: [PATCH] Fix misspellings collected by members of KJ list.
Message-ID: <Pine.LNX.4.64.0702211208490.9074@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.492, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, TW_DB 0.08, TW_DV 0.08, TW_SN 0.08, TW_XF 0.08)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Fix the misspellings of "propogate", "writting" and (oh, the shame
:-) "kenrel" in the source tree.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

 Documentation/sysctl/kernel.txt           |    2 +-
 arch/powerpc/oprofile/op_model_cell.c     |    2 +-
 arch/x86_64/kernel/io_apic.c              |    2 +-
 drivers/char/tty_io.c                     |    8 ++++----
 drivers/media/dvb/frontends/dib7000m.c    |    2 +-
 drivers/media/dvb/frontends/dib7000p.c    |    2 +-
 drivers/media/video/em28xx/em28xx-i2c.c   |    2 +-
 drivers/net/irda/donauboe.h               |    2 +-
 drivers/net/wireless/prism54/islpci_dev.c |    2 +-
 drivers/net/wireless/wavelan_cs.c         |    4 ++--
 drivers/net/wireless/wavelan_cs.p.h       |    2 +-
 drivers/sbus/char/bpp.c                   |    2 +-
 drivers/usb/serial/aircable.c             |    4 ++--
 drivers/usb/serial/io_edgeport.c          |    4 ++--
 drivers/video/matrox/matroxfb_Ti3026.c    |    2 +-
 drivers/video/matrox/matroxfb_accel.c     |    2 +-
 drivers/video/matrox/matroxfb_base.c      |    2 +-
 drivers/video/matrox/matroxfb_misc.c      |    2 +-
 fs/direct-io.c                            |    2 +-
 fs/dlm/lock.c                             |    2 +-
 fs/reiserfs/journal.c                     |    4 ++--
 include/asm-generic/bitops/atomic.h       |    2 +-
 include/asm-i386/bitops.h                 |    2 +-
 include/asm-i386/boot.h                   |    2 +-
 include/asm-i386/sync_bitops.h            |    2 +-
 include/asm-m32r/system.h                 |    2 +-
 include/asm-mips/bootinfo.h               |    2 +-
 include/linux/mount.h                     |    2 +-
 sound/pci/ice1712/delta.h                 |    4 ++--
 sound/sparc/dbri.c                        |    2 +-
 30 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 5922e84..d3d3c25 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -228,7 +228,7 @@ Controls the kernel's behaviour when an oops or BUG is encountered.

 pid_max:

-PID allocation wrap value.  When the kenrel's next PID value
+PID allocation wrap value.  When the kernel's next PID value
 reaches this value, it wraps back to a minimum PID value.
 PIDs of value pid_max or larger are not allocated.

diff --git a/arch/powerpc/oprofile/op_model_cell.c b/arch/powerpc/oprofile/op_model_cell.c
index e08e1d7..17ece4a 100644
--- a/arch/powerpc/oprofile/op_model_cell.c
+++ b/arch/powerpc/oprofile/op_model_cell.c
@@ -746,7 +746,7 @@ cell_handle_interrupt(struct pt_regs *regs, struct op_counter_config *ctr)
 		 * counter value etc.) are not copied to the actual registers
 		 * until the performance monitor is enabled.  In order to get
 		 * this to work as desired, the permormance monitor needs to
-		 * be disabled while writting to the latches.  This is a
+		 * be disabled while writing to the latches.  This is a
 		 * HW design issue.
 		 */
 		cbe_enable_pm(cpu);
diff --git a/arch/x86_64/kernel/io_apic.c b/arch/x86_64/kernel/io_apic.c
index 950682f..3b8d932 100644
--- a/arch/x86_64/kernel/io_apic.c
+++ b/arch/x86_64/kernel/io_apic.c
@@ -1417,7 +1417,7 @@ static void ack_apic_level(unsigned int irq)

 	/*
 	 * We must acknowledge the irq before we move it or the acknowledge will
-	 * not propogate properly.
+	 * not propagate properly.
 	 */
 	ack_APIC_irq();

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index f24c26d..68e0230 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1562,11 +1562,11 @@ void disassociate_ctty(int on_exit)


 /**
- *	stop_tty	-	propogate flow control
+ *	stop_tty	-	propagate flow control
  *	@tty: tty to stop
  *
  *	Perform flow control to the driver. For PTY/TTY pairs we
- *	must also propogate the TIOCKPKT status. May be called
+ *	must also propagate the TIOCKPKT status. May be called
  *	on an already stopped device and will not re-call the driver
  *	method.
  *
@@ -1596,11 +1596,11 @@ void stop_tty(struct tty_struct *tty)
 EXPORT_SYMBOL(stop_tty);

 /**
- *	start_tty	-	propogate flow control
+ *	start_tty	-	propagate flow control
  *	@tty: tty to start
  *
  *	Start a tty that has been stopped if at all possible. Perform
- *	any neccessary wakeups and propogate the TIOCPKT status. If this
+ *	any neccessary wakeups and propagate the TIOCPKT status. If this
  *	is the tty was previous stopped and is being started then the
  *	driver start method is invoked and the line discipline woken.
  *
diff --git a/drivers/media/dvb/frontends/dib7000m.c b/drivers/media/dvb/frontends/dib7000m.c
index f5d40aa..f64546c 100644
--- a/drivers/media/dvb/frontends/dib7000m.c
+++ b/drivers/media/dvb/frontends/dib7000m.c
@@ -266,7 +266,7 @@ static int dib7000m_sad_calib(struct dib7000m_state *state)
 {

 /* internal */
-//	dib7000m_write_word(state, 928, (3 << 14) | (1 << 12) | (524 << 0)); // sampling clock of the SAD is writting in set_bandwidth
+//	dib7000m_write_word(state, 928, (3 << 14) | (1 << 12) | (524 << 0)); // sampling clock of the SAD is written in set_bandwidth
 	dib7000m_write_word(state, 929, (0 << 1) | (0 << 0));
 	dib7000m_write_word(state, 930, 776); // 0.625*3.3 / 4096

diff --git a/drivers/media/dvb/frontends/dib7000p.c b/drivers/media/dvb/frontends/dib7000p.c
index 0349a4b..aece458 100644
--- a/drivers/media/dvb/frontends/dib7000p.c
+++ b/drivers/media/dvb/frontends/dib7000p.c
@@ -223,7 +223,7 @@ static int dib7000p_set_bandwidth(struct dvb_frontend *demod, u8 BW_Idx)
 static int dib7000p_sad_calib(struct dib7000p_state *state)
 {
 /* internal */
-//	dib7000p_write_word(state, 72, (3 << 14) | (1 << 12) | (524 << 0)); // sampling clock of the SAD is writting in set_bandwidth
+//	dib7000p_write_word(state, 72, (3 << 14) | (1 << 12) | (524 << 0)); // sampling clock of the SAD is written in set_bandwidth
 	dib7000p_write_word(state, 73, (0 << 1) | (0 << 0));
 	dib7000p_write_word(state, 74, 776); // 0.625*3.3 / 4096

diff --git a/drivers/media/video/em28xx/em28xx-i2c.c b/drivers/media/video/em28xx/em28xx-i2c.c
index d829d8f..f280733 100644
--- a/drivers/media/video/em28xx/em28xx-i2c.c
+++ b/drivers/media/video/em28xx/em28xx-i2c.c
@@ -70,7 +70,7 @@ static int em2800_i2c_send_max4(struct em28xx *dev, unsigned char addr,

 	ret = dev->em28xx_write_regs(dev, 4 - len, &b2[4 - len], 2 + len);
 	if (ret != 2 + len) {
-		em28xx_warn("writting to i2c device failed (error=%i)\n", ret);
+		em28xx_warn("writing to i2c device failed (error=%i)\n", ret);
 		return -EIO;
 	}
 	for (write_timeout = EM2800_I2C_WRITE_TIMEOUT; write_timeout > 0;
diff --git a/drivers/net/irda/donauboe.h b/drivers/net/irda/donauboe.h
index 2ab173d..1e67720 100644
--- a/drivers/net/irda/donauboe.h
+++ b/drivers/net/irda/donauboe.h
@@ -113,7 +113,7 @@
 /* RxOver  overflow in Recv FIFO                                */
 /* SipRcv  received serial gap  (or other condition you set)    */
 /* Interrupts are enabled by writing a one to the IER register  */
-/* Interrupts are cleared by writting a one to the ISR register */
+/* Interrupts are cleared by writing a one to the ISR register */
 /*                                                              */
 /* 6. The remaining registers: 0x6 and 0x3 appear to be         */
 /*    reserved parts of 16 or 32 bit registersthe remainder     */
diff --git a/drivers/net/wireless/prism54/islpci_dev.c b/drivers/net/wireless/prism54/islpci_dev.c
index a037b11..0847953 100644
--- a/drivers/net/wireless/prism54/islpci_dev.c
+++ b/drivers/net/wireless/prism54/islpci_dev.c
@@ -115,7 +115,7 @@ isl_upload_firmware(islpci_private *priv)
 			    ISL38XX_MEMORY_WINDOW_SIZE : fw_len;
 			u32 __iomem *dev_fw_ptr = device_base + ISL38XX_DIRECT_MEM_WIN;

-			/* set the cards base address for writting the data */
+			/* set the card's base address for writing the data */
 			isl38xx_w32_flush(device_base, reg,
 					  ISL38XX_DIR_MEM_BASE_REG);
 			wmb();	/* be paranoid */
diff --git a/drivers/net/wireless/wavelan_cs.c b/drivers/net/wireless/wavelan_cs.c
index b042397..354a9ca 100644
--- a/drivers/net/wireless/wavelan_cs.c
+++ b/drivers/net/wireless/wavelan_cs.c
@@ -176,7 +176,7 @@ psa_write(struct net_device *	dev,
   volatile u_char __iomem *verify = lp->mem + PSA_ADDR +
     (psaoff(0, psa_comp_number) << 1);

-  /* Authorize writting to PSA */
+  /* Authorize writing to PSA */
   hacr_write(base, HACR_PWR_STAT | HACR_ROM_WEN);

   while(n-- > 0)
@@ -1676,7 +1676,7 @@ wv_set_frequency(u_long		base,	/* i/o port of the card */
       fee_write(base, 0x60,
 		dac, 2);

-      /* We now should verify here that the EEprom writting was ok */
+      /* We now should verify here that the EEprom writing was ok */

       /* ReRead the first area */
       fee_read(base, 0x00,
diff --git a/drivers/net/wireless/wavelan_cs.p.h b/drivers/net/wireless/wavelan_cs.p.h
index 4d1c490..4b9de00 100644
--- a/drivers/net/wireless/wavelan_cs.p.h
+++ b/drivers/net/wireless/wavelan_cs.p.h
@@ -120,7 +120,7 @@
  * the Wavelan itself (NCR -> AT&T -> Lucent).
  *
  * All started with Anders Klemets <klemets@paul.rutgers.edu>,
- * writting a Wavelan ISA driver for the MACH microkernel. Girish
+ * writing a Wavelan ISA driver for the MACH microkernel. Girish
  * Welling <welling@paul.rutgers.edu> had also worked on it.
  * Keith Moore modify this for the Pcmcia hardware.
  *
diff --git a/drivers/sbus/char/bpp.c b/drivers/sbus/char/bpp.c
index a39ee80..54b2db2 100644
--- a/drivers/sbus/char/bpp.c
+++ b/drivers/sbus/char/bpp.c
@@ -157,7 +157,7 @@ static unsigned short get_pins(unsigned minor)
 #define BPP_ICR      0x18
 #define BPP_SIZE     0x1A

-/* BPP_CSR.  Bits of type RW1 are cleared with writting '1'. */
+/* BPP_CSR.  Bits of type RW1 are cleared with writing '1'. */
 #define P_DEV_ID_MASK   0xf0000000      /* R   */
 #define P_DEV_ID_ZEBRA  0x40000000
 #define P_DEV_ID_L64854 0xa0000000      /*      == NCR 89C100+89C105. Pity. */
diff --git a/drivers/usb/serial/aircable.c b/drivers/usb/serial/aircable.c
index 11dad42..3016acf 100644
--- a/drivers/usb/serial/aircable.c
+++ b/drivers/usb/serial/aircable.c
@@ -9,7 +9,7 @@
  * The device works as an standard CDC device, it has 2 interfaces, the first
  * one is for firmware access and the second is the serial one.
  * The protocol is very simply, there are two posibilities reading or writing.
- * When writting the first urb must have a Header that starts with 0x20 0x29 the
+ * When writing the first urb must have a Header that starts with 0x20 0x29 the
  * next two bytes must say how much data will be sended.
  * When reading the process is almost equal except that the header starts with
  * 0x00 0x20.
@@ -18,7 +18,7 @@
  * buffer: The First and Second byte is used for a Header, the Third and Fourth
  * tells the  device the amount of information the package holds.
  * Packages are 60 bytes long Header Stuff.
- * When writting to the device the first two bytes of the header are 0x20 0x29
+ * When writing to the device the first two bytes of the header are 0x20 0x29
  * When reading the bytes are 0x00 0x20, or 0x00 0x10, there is an strange
  * situation, when too much data arrives to the device because it sends the data
  * but with out the header. I will use a simply hack to override this situation,
diff --git a/drivers/usb/serial/io_edgeport.c b/drivers/usb/serial/io_edgeport.c
index 6a26a2e..8da8a51 100644
--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -2465,7 +2465,7 @@ static int send_cmd_write_uart_register (struct edgeport_port *edge_port, __u8 r
 	    ((edge_serial->is_epic) &&
 	     (!edge_serial->epic_descriptor.Supports.IOSPWriteMCR) &&
 	     (regNum == MCR))) {
-		dbg("SendCmdWriteUartReg - Not writting to MCR Register");
+		dbg("SendCmdWriteUartReg - Not writing to MCR Register");
 		return 0;
 	}

@@ -2473,7 +2473,7 @@ static int send_cmd_write_uart_register (struct edgeport_port *edge_port, __u8 r
 	    ((edge_serial->is_epic) &&
 	     (!edge_serial->epic_descriptor.Supports.IOSPWriteLCR) &&
 	     (regNum == LCR))) {
-		dbg ("SendCmdWriteUartReg - Not writting to LCR Register");
+		dbg ("SendCmdWriteUartReg - Not writing to LCR Register");
 		return 0;
 	}

diff --git a/drivers/video/matrox/matroxfb_Ti3026.c b/drivers/video/matrox/matroxfb_Ti3026.c
index a5690a5..9445cdb 100644
--- a/drivers/video/matrox/matroxfb_Ti3026.c
+++ b/drivers/video/matrox/matroxfb_Ti3026.c
@@ -72,7 +72,7 @@
  *     (c) 1998 Gerd Knorr <kraxel@cs.tu-berlin.de>
  *
  * (following author is not in any relation with this code, but his ideas
- *  were used when writting this driver)
+ *  were used when writing this driver)
  *
  *		 FreeVBE/AF (Matrox), "Shawn Hargreaves" <shawn@talula.demon.co.uk>
  *
diff --git a/drivers/video/matrox/matroxfb_accel.c b/drivers/video/matrox/matroxfb_accel.c
index a5c825d..c57aaad 100644
--- a/drivers/video/matrox/matroxfb_accel.c
+++ b/drivers/video/matrox/matroxfb_accel.c
@@ -70,7 +70,7 @@
  *     (c) 1998 Gerd Knorr <kraxel@cs.tu-berlin.de>
  *
  * (following author is not in any relation with this code, but his ideas
- *  were used when writting this driver)
+ *  were used when writing this driver)
  *
  *		 FreeVBE/AF (Matrox), "Shawn Hargreaves" <shawn@talula.demon.co.uk>
  *
diff --git a/drivers/video/matrox/matroxfb_base.c b/drivers/video/matrox/matroxfb_base.c
index cb2aa40..c8559a7 100644
--- a/drivers/video/matrox/matroxfb_base.c
+++ b/drivers/video/matrox/matroxfb_base.c
@@ -93,7 +93,7 @@
  *     (c) 1998 Gerd Knorr <kraxel@cs.tu-berlin.de>
  *
  * (following author is not in any relation with this code, but his ideas
- *  were used when writting this driver)
+ *  were used when writing this driver)
  *
  *		 FreeVBE/AF (Matrox), "Shawn Hargreaves" <shawn@talula.demon.co.uk>
  *
diff --git a/drivers/video/matrox/matroxfb_misc.c b/drivers/video/matrox/matroxfb_misc.c
index 18886b6..5948e54 100644
--- a/drivers/video/matrox/matroxfb_misc.c
+++ b/drivers/video/matrox/matroxfb_misc.c
@@ -78,7 +78,7 @@
  *     (c) 1998 Gerd Knorr <kraxel@cs.tu-berlin.de>
  *
  * (following author is not in any relation with this code, but his ideas
- *  were used when writting this driver)
+ *  were used when writing this driver)
  *
  *		 FreeVBE/AF (Matrox), "Shawn Hargreaves" <shawn@talula.demon.co.uk>
  *
diff --git a/fs/direct-io.c b/fs/direct-io.c
index d9d0833..1e88d8d 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -439,7 +439,7 @@ static int dio_bio_complete(struct dio *dio, struct bio *bio)
  * Wait on and process all in-flight BIOs.  This must only be called once
  * all bios have been issued so that the refcount can only decrease.
  * This just waits for all bios to make it through dio_bio_complete.  IO
- * errors are propogated through dio->io_error and should be propogated via
+ * errors are propagated through dio->io_error and should be propagated via
  * dio_complete().
  */
 static void dio_await_completion(struct dio *dio)
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index e725005..c885657 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -3840,7 +3840,7 @@ static int orphan_proc_lock(struct dlm_ls *ls, struct dlm_lkb *lkb)
 	kfree(ua);
 	lkb->lkb_astparam = (long)NULL;

-	/* TODO: propogate to master if needed */
+	/* TODO: propagate to master if needed */
 	return 0;
 }

diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index 7280a23..3399416 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -1110,7 +1110,7 @@ static int flush_commit_list(struct super_block *s,
 	if (!barrier) {
 		/* If there was a write error in the journal - we can't commit
 		 * this transaction - it will be invalid and, if successful,
-		 * will just end up propogating the write error out to
+		 * will just end up propagating the write error out to
 		 * the file system. */
 		if (likely(!retval && !reiserfs_is_journal_aborted (journal))) {
 			if (buffer_dirty(jl->j_commit_bh))
@@ -1125,7 +1125,7 @@ static int flush_commit_list(struct super_block *s,

 	/* If there was a write error in the journal - we can't commit this
 	 * transaction - it will be invalid and, if successful, will just end
-	 * up propogating the write error out to the filesystem. */
+	 * up propagating the write error out to the filesystem. */
 	if (unlikely(!buffer_uptodate(jl->j_commit_bh))) {
 #ifdef CONFIG_REISERFS_CHECK
 		reiserfs_warning(s, "journal-615: buffer write failed");
diff --git a/include/asm-generic/bitops/atomic.h b/include/asm-generic/bitops/atomic.h
index 7833931..cd8a964 100644
--- a/include/asm-generic/bitops/atomic.h
+++ b/include/asm-generic/bitops/atomic.h
@@ -58,7 +58,7 @@ extern raw_spinlock_t __atomic_hash[ATOMIC_HASH_SIZE] __lock_aligned;
  * if you do not require the atomic guarantees.
  *
  * Note: there are no guarantees that this function will not be reordered
- * on non x86 architectures, so if you are writting portable code,
+ * on non x86 architectures, so if you are writing portable code,
  * make sure not to rely on its reordering guarantees.
  *
  * Note that @nr may be almost arbitrarily large; this function is not
diff --git a/include/asm-i386/bitops.h b/include/asm-i386/bitops.h
index 273b506..a20fe98 100644
--- a/include/asm-i386/bitops.h
+++ b/include/asm-i386/bitops.h
@@ -27,7 +27,7 @@
  * if you do not require the atomic guarantees.
  *
  * Note: there are no guarantees that this function will not be reordered
- * on non x86 architectures, so if you are writting portable code,
+ * on non x86 architectures, so if you are writing portable code,
  * make sure not to rely on its reordering guarantees.
  *
  * Note that @nr may be almost arbitrarily large; this function is not
diff --git a/include/asm-i386/boot.h b/include/asm-i386/boot.h
index e7686d0..bd024ab 100644
--- a/include/asm-i386/boot.h
+++ b/include/asm-i386/boot.h
@@ -12,7 +12,7 @@
 #define EXTENDED_VGA	0xfffe		/* 80x50 mode */
 #define ASK_VGA		0xfffd		/* ask for it at bootup */

-/* Physical address where kenrel should be loaded. */
+/* Physical address where kernel should be loaded. */
 #define LOAD_PHYSICAL_ADDR ((CONFIG_PHYSICAL_START \
 				+ (CONFIG_PHYSICAL_ALIGN - 1)) \
 				& ~(CONFIG_PHYSICAL_ALIGN - 1))
diff --git a/include/asm-i386/sync_bitops.h b/include/asm-i386/sync_bitops.h
index c94d51c..2e6d672 100644
--- a/include/asm-i386/sync_bitops.h
+++ b/include/asm-i386/sync_bitops.h
@@ -24,7 +24,7 @@
  * if you do not require the atomic guarantees.
  *
  * Note: there are no guarantees that this function will not be reordered
- * on non x86 architectures, so if you are writting portable code,
+ * on non-x86 architectures, so if you are writing portable code,
  * make sure not to rely on its reordering guarantees.
  *
  * Note that @nr may be almost arbitrarily large; this function is not
diff --git a/include/asm-m32r/system.h b/include/asm-m32r/system.h
index 99ee098..5894c26 100644
--- a/include/asm-m32r/system.h
+++ b/include/asm-m32r/system.h
@@ -138,7 +138,7 @@ extern void  __xchg_called_with_bad_pointer(void);
 	"add3	"reg0", "addr", #0x2000;		\n\t"	\
 	"ld	"reg0", @"reg0";			\n\t"	\
 	"unlock	"reg0", @"reg1";			\n\t"
-	/* FIXME: This workaround code cannot handle kenrel modules
+	/* FIXME: This workaround code cannot handle kernel modules
 	 * correctly under SMP environment.
 	 */
 #else	/* CONFIG_CHIP_M32700_TS1 */
diff --git a/include/asm-mips/bootinfo.h b/include/asm-mips/bootinfo.h
index c7c945b..dbf834f 100644
--- a/include/asm-mips/bootinfo.h
+++ b/include/asm-mips/bootinfo.h
@@ -254,7 +254,7 @@ extern void free_init_pages(const char *what,
 extern char arcs_cmdline[CL_SIZE];

 /*
- * Registers a0, a1, a3 and a4 as passed to the kenrel entry by firmware
+ * Registers a0, a1, a3 and a4 as passed to the kernel entry by firmware
  */
 extern unsigned long fw_arg0, fw_arg1, fw_arg2, fw_arg3;

diff --git a/include/linux/mount.h b/include/linux/mount.h
index dab69af..6d3047d 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -33,7 +33,7 @@ struct mnt_namespace;

 #define MNT_SHARED	0x1000	/* if the vfsmount is a shared mount */
 #define MNT_UNBINDABLE	0x2000	/* if the vfsmount is a unbindable mount */
-#define MNT_PNODE_MASK	0x3000	/* propogation flag mask */
+#define MNT_PNODE_MASK	0x3000	/* propagation flag mask */

 struct vfsmount {
 	struct list_head mnt_hash;
diff --git a/sound/pci/ice1712/delta.h b/sound/pci/ice1712/delta.h
index e65d669..e47861c 100644
--- a/sound/pci/ice1712/delta.h
+++ b/sound/pci/ice1712/delta.h
@@ -63,7 +63,7 @@ extern const struct snd_ice1712_card_info snd_ice1712_delta_cards[];
 					/* look to CS8414 datasheet */
 #define ICE1712_DELTA_SPDIF_OUT_STAT_CLOCK 0x04
 					/* S/PDIF output status clock */
-					/* (writting on rising edge - 0->1) */
+					/* (writing on rising edge - 0->1) */
 					/* all except Delta44 */
 					/* look to CS8404A datasheet */
 #define ICE1712_DELTA_SPDIF_OUT_STAT_DATA 0x08
@@ -100,7 +100,7 @@ extern const struct snd_ice1712_card_info snd_ice1712_delta_cards[];
 					/* AKM4524 serial data */
 #define ICE1712_DELTA_CODEC_SERIAL_CLOCK 0x20
 					/* AKM4524 serial clock */
-					/* (writting on rising edge - 0->1 */
+					/* (writing on rising edge - 0->1 */
 #define ICE1712_DELTA_CODEC_CHIP_A	0x40
 #define ICE1712_DELTA_CODEC_CHIP_B	0x80
 					/* 1 - select chip A or B */
diff --git a/sound/sparc/dbri.c b/sound/sparc/dbri.c
index 25a2a73..e07085a 100644
--- a/sound/sparc/dbri.c
+++ b/sound/sparc/dbri.c
@@ -673,7 +673,7 @@ static s32 *dbri_cmdlock(struct snd_dbri * dbri, int len)
 }

 /*
- * Send prepared cmd string. It works by writting a JUMP cmd into
+ * Send prepared cmd string. It works by writing a JUMP cmd into
  * the last WAIT cmd and force DBRI to reread the cmd.
  * The JUMP cmd points to the new cmd string.
  * It also releases the cmdlock spinlock.
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
