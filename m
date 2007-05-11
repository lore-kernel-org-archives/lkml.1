Return-Path: <linux-kernel-owner+w=401wt.eu-S1763227AbXEKTnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763227AbXEKTnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760847AbXEKTlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:41:19 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:45927 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762784AbXEKTlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:41:16 -0400
Message-ID: <4644C6D6.9010101@simon.arlott.org.uk>
Date: Fri, 11 May 2007 20:41:10 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dev-etrax@axis.com, trivial@kernel.org
Subject: [PATCH] spelling fixes: arch/cris/
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Spelling fixes in arch/cris/.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 arch/cris/arch-v10/boot/compressed/misc.c |    2 +-
 arch/cris/arch-v10/kernel/debugport.c     |    2 +-
 arch/cris/arch-v10/kernel/fasttimer.c     |    2 +-
 arch/cris/arch-v10/kernel/irq.c           |    2 +-
 arch/cris/arch-v10/kernel/kgdb.c          |    2 +-
 arch/cris/arch-v10/kernel/process.c       |    2 +-
 arch/cris/arch-v10/kernel/shadows.c       |    2 +-
 arch/cris/arch-v10/lib/string.c           |    2 +-
 arch/cris/arch-v10/lib/usercopy.c         |    6 +++---
 arch/cris/arch-v32/boot/compressed/misc.c |    6 +++---
 arch/cris/arch-v32/drivers/axisflashmap.c |    2 +-
 arch/cris/arch-v32/drivers/i2c.c          |    2 +-
 arch/cris/arch-v32/drivers/nandflash.c    |    2 +-
 arch/cris/arch-v32/drivers/pcf8563.c      |    2 +-
 arch/cris/arch-v32/kernel/fasttimer.c     |    2 +-
 arch/cris/arch-v32/kernel/irq.c           |    8 ++++----
 arch/cris/arch-v32/kernel/process.c       |    2 +-
 arch/cris/arch-v32/kernel/signal.c        |    4 ++--
 arch/cris/arch-v32/kernel/smp.c           |    2 +-
 arch/cris/arch-v32/kernel/time.c          |    2 +-
 arch/cris/arch-v32/kernel/traps.c         |    2 +-
 arch/cris/arch-v32/lib/string.c           |    2 +-
 arch/cris/arch-v32/lib/usercopy.c         |    6 +++---
 arch/cris/arch-v32/mm/tlb.c               |    6 +++---
 arch/cris/kernel/irq.c                    |    8 ++++----
 arch/cris/mm/fault.c                      |    4 ++--
 arch/cris/mm/init.c                       |    2 +-
 arch/cris/mm/tlb.c                        |    2 +-
 28 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/arch/cris/arch-v10/boot/compressed/misc.c b/arch/cris/arch-v10/boot/compressed/misc.c
index ffb8d21..e205d2e 100644
--- a/arch/cris/arch-v10/boot/compressed/misc.c
+++ b/arch/cris/arch-v10/boot/compressed/misc.c
@@ -8,7 +8,7 @@
  *
  * malloc by Hannu Savolainen 1993 and Matthias Urlichs 1994
  * puts by Nick Holloway 1993, better puts by Martin Mares 1995
- * adoptation for Linux/CRIS Axis Communications AB, 1999
+ * adaptation for Linux/CRIS Axis Communications AB, 1999
  * 
  */
 
diff --git a/arch/cris/arch-v10/kernel/debugport.c b/arch/cris/arch-v10/kernel/debugport.c
index 2b536ca..93679a4 100644
--- a/arch/cris/arch-v10/kernel/debugport.c
+++ b/arch/cris/arch-v10/kernel/debugport.c
@@ -83,7 +83,7 @@
  *
  * Revision 1.4  2002/11/19 14:35:24  starvik
  * Changes from linux 2.4
- * Changed struct initializer syntax to the currently prefered notation
+ * Changed struct initializer syntax to the currently preferred notation
  *
  * Revision 1.3  2002/11/06 09:47:03  starvik
  * Modified for new interrupt macros
diff --git a/arch/cris/arch-v10/kernel/fasttimer.c b/arch/cris/arch-v10/kernel/fasttimer.c
index 8cbdf59..d3ea052 100644
--- a/arch/cris/arch-v10/kernel/fasttimer.c
+++ b/arch/cris/arch-v10/kernel/fasttimer.c
@@ -84,7 +84,7 @@
  * with time based on jiffies and *R_TIMER0_DATA, uses a table
  * for fast conversion of timer value to microseconds.
  * (Much faster the standard do_gettimeofday() and we don't really
- * wan't to use the true time - we wan't the "uptime" so timers don't screw up
+ * want to use the true time - we want the "uptime" so timers don't screw up
  * when we change the time.
  * TODO: Add efficient support for continuous timers as well.
  *
diff --git a/arch/cris/arch-v10/kernel/irq.c b/arch/cris/arch-v10/kernel/irq.c
index 96094cb..845c95f 100644
--- a/arch/cris/arch-v10/kernel/irq.c
+++ b/arch/cris/arch-v10/kernel/irq.c
@@ -169,7 +169,7 @@ init_IRQ(void)
         for (i = 0; i < 256; i++)
                etrax_irv->v[i] = weird_irq;
 
-	/* Initialize IRQ handler descriptiors. */
+	/* Initialize IRQ handler descriptors. */
 	for(i = 2; i < NR_IRQS; i++) {
 		irq_desc[i].chip = &crisv10_irq_type;
 		set_int_vector(i, interrupt[i]);
diff --git a/arch/cris/arch-v10/kernel/kgdb.c b/arch/cris/arch-v10/kernel/kgdb.c
index 07628a1..21b17f2 100644
--- a/arch/cris/arch-v10/kernel/kgdb.c
+++ b/arch/cris/arch-v10/kernel/kgdb.c
@@ -959,7 +959,7 @@ stub_is_stopped(int sigval)
 
 	/* Send register contents. We probably only need to send the
 	 * PC, frame pointer and stack pointer here. Other registers will be
-	 * explicitely asked for. But for now, send all. 
+	 * explicitly asked for. But for now, send all. 
 	 */
 	
 	for (regno = R0; regno <= USP; regno++) {
diff --git a/arch/cris/arch-v10/kernel/process.c b/arch/cris/arch-v10/kernel/process.c
index b6831ce..1a3760c 100644
--- a/arch/cris/arch-v10/kernel/process.c
+++ b/arch/cris/arch-v10/kernel/process.c
@@ -64,7 +64,7 @@ void hard_reset_now (void)
 #if defined(CONFIG_ETRAX_WATCHDOG) && !defined(CONFIG_SVINTO_SIM)
 	cause_of_death = 0xbedead;
 #else
-	/* Since we dont plan to keep on reseting the watchdog,
+	/* Since we dont plan to keep on resetting the watchdog,
 	   the key can be arbitrary hence three */
 	*R_WATCHDOG = IO_FIELD(R_WATCHDOG, key, 3) |
 		IO_STATE(R_WATCHDOG, enable, start);
diff --git a/arch/cris/arch-v10/kernel/shadows.c b/arch/cris/arch-v10/kernel/shadows.c
index 38fd44d..326178a 100644
--- a/arch/cris/arch-v10/kernel/shadows.c
+++ b/arch/cris/arch-v10/kernel/shadows.c
@@ -20,7 +20,7 @@ unsigned long r_timer_ctrl_shadow;
  * These are only usable if there actually IS a latch connected
  * to the corresponding external chip-select pin.
  *
- * A common usage is that CSP0 controls LED's and CSP4 video chips.
+ * A common usage is that CSP0 controls LEDs and CSP4 video chips.
  */
 
 unsigned long port_cse1_shadow;
diff --git a/arch/cris/arch-v10/lib/string.c b/arch/cris/arch-v10/lib/string.c
index 8ffde49..15d6662 100644
--- a/arch/cris/arch-v10/lib/string.c
+++ b/arch/cris/arch-v10/lib/string.c
@@ -41,7 +41,7 @@ void *memcpy(void *pdst,
      Make sure the compiler is able to make something useful of this.
       As it is now: r10 -> r13; r11 -> r11 (nop); r12 -> r12 (nop).
 
-     If gcc was allright, it really would need no temporaries, and no
+     If gcc was alright, it really would need no temporaries, and no
      stack space to save stuff on. */
 
   register void *return_dst __asm__ ("r10") = pdst;
diff --git a/arch/cris/arch-v10/lib/usercopy.c b/arch/cris/arch-v10/lib/usercopy.c
index 43778d5..a12c708 100644
--- a/arch/cris/arch-v10/lib/usercopy.c
+++ b/arch/cris/arch-v10/lib/usercopy.c
@@ -38,7 +38,7 @@ __copy_user (void __user *pdst, const void *psrc, unsigned long pn)
      As it is now: r10 -> r13; r11 -> r11 (nop); r12 -> r12 (nop).
 
      FIXME: Comment for old gcc version.  Check.
-     If gcc was allright, it really would need no temporaries, and no
+     If gcc was alright, it really would need no temporaries, and no
      stack space to save stuff on. */
 
   register char *dst __asm__ ("r13") = pdst;
@@ -200,7 +200,7 @@ __copy_user_zeroing (void __user *pdst, const void *psrc, unsigned long pn)
      As it is now: r10 -> r13; r11 -> r11 (nop); r12 -> r12 (nop).
 
      FIXME: Comment for old gcc version.  Check.
-     If gcc was allright, it really would need no temporaries, and no
+     If gcc was alright, it really would need no temporaries, and no
      stack space to save stuff on.  */
 
   register char *dst __asm__ ("r13") = pdst;
@@ -380,7 +380,7 @@ __do_clear_user (void __user *pto, unsigned long pn)
       As it is now: r10 -> r13; r11 -> r11 (nop); r12 -> r12 (nop).
 
      FIXME: Comment for old gcc version.  Check.
-     If gcc was allright, it really would need no temporaries, and no
+     If gcc was alright, it really would need no temporaries, and no
      stack space to save stuff on. */
 
   register char *dst __asm__ ("r13") = pto;
diff --git a/arch/cris/arch-v32/boot/compressed/misc.c b/arch/cris/arch-v32/boot/compressed/misc.c
index 1190269..0169ba1 100644
--- a/arch/cris/arch-v32/boot/compressed/misc.c
+++ b/arch/cris/arch-v32/boot/compressed/misc.c
@@ -8,7 +8,7 @@
  *
  * malloc by Hannu Savolainen 1993 and Matthias Urlichs 1994
  * puts by Nick Holloway 1993, better puts by Martin Mares 1995
- * adoptation for Linux/CRIS Axis Communications AB, 1999
+ * adaptation for Linux/CRIS Axis Communications AB, 1999
  *
  */
 
@@ -151,7 +151,7 @@ serout(const char *s, reg_scope_instances regi_ser)
 	do {
 		rs = REG_RD(ser, regi_ser, rs_stat_din);
 	}
-	while (!rs.tr_rdy);/* Wait for tranceiver. */
+	while (!rs.tr_rdy);/* Wait for transceiver. */
 
 	REG_WR(ser, regi_ser, rw_dout, dout);
 }
@@ -264,7 +264,7 @@ serial_setup(reg_scope_instances regi_ser)
 	tr_ctrl.stop_bits = 1;	/* 2 stop bits. */
 
 	/*
-	 * The baudrate setup is a bit fishy, but in the end the tranceiver is
+	 * The baudrate setup is a bit fishy, but in the end the transceiver is
 	 * set to 4800 and the receiver to 115200. The magic value is
 	 * 29.493 MHz.
 	 */
diff --git a/arch/cris/arch-v32/drivers/axisflashmap.c b/arch/cris/arch-v32/drivers/axisflashmap.c
index 5180d45..3ec12ea 100644
--- a/arch/cris/arch-v32/drivers/axisflashmap.c
+++ b/arch/cris/arch-v32/drivers/axisflashmap.c
@@ -205,7 +205,7 @@ static struct mtd_info *probe_cs(struct map_info *map_cs)
 /*
  * Probe each chip select individually for flash chips. If there are chips on
  * both cse0 and cse1, the mtd_info structs will be concatenated to one struct
- * so that MTD partitions can cross chip boundries.
+ * so that MTD partitions can cross chip boundaries.
  *
  * The only known restriction to how you can mount your chips is that each
  * chip select must hold similar flash chips. But you need external hardware
diff --git a/arch/cris/arch-v32/drivers/i2c.c b/arch/cris/arch-v32/drivers/i2c.c
index 5d6c527..6ab7434 100644
--- a/arch/cris/arch-v32/drivers/i2c.c
+++ b/arch/cris/arch-v32/drivers/i2c.c
@@ -275,7 +275,7 @@ i2c_getack(void)
 		ack = 0;
 	i2c_delay(CLOCK_HIGH_TIME/2);
 	if(!ack){
-		if(!i2c_getbit()) /* receiver pulld SDA low */
+		if(!i2c_getbit()) /* receiver pulled SDA low */
 			ack = 1;
 		i2c_delay(CLOCK_HIGH_TIME/2);
 	}
diff --git a/arch/cris/arch-v32/drivers/nandflash.c b/arch/cris/arch-v32/drivers/nandflash.c
index 93ddea4..5ce015c 100644
--- a/arch/cris/arch-v32/drivers/nandflash.c
+++ b/arch/cris/arch-v32/drivers/nandflash.c
@@ -138,7 +138,7 @@ struct mtd_info* __init crisv32_nand_flash_probe (void)
 	/* Enable the following for a flash based bad block table */
 	this->options = NAND_USE_FLASH_BBT;
 
-	/* Scan to find existance of the device */
+	/* Scan to find existence of the device */
 	if (nand_scan (crisv32_mtd, 1)) {
 		err = -ENXIO;
 		goto out_ior;
diff --git a/arch/cris/arch-v32/drivers/pcf8563.c b/arch/cris/arch-v32/drivers/pcf8563.c
index 24b919b..e6f1eff 100644
--- a/arch/cris/arch-v32/drivers/pcf8563.c
+++ b/arch/cris/arch-v32/drivers/pcf8563.c
@@ -4,7 +4,7 @@
  * From Phillips' datasheet:
  *
  * The PCF8563 is a CMOS real-time clock/calendar optimized for low power
- * consumption. A programmable clock output, interupt output and voltage
+ * consumption. A programmable clock output, interrupt output and voltage
  * low detector are also provided. All address and data are transferred
  * serially via two-line bidirectional I2C-bus. Maximum bus speed is
  * 400 kbits/s. The built-in word address register is incremented
diff --git a/arch/cris/arch-v32/kernel/fasttimer.c b/arch/cris/arch-v32/kernel/fasttimer.c
index 79e1e4c..b40551f 100644
--- a/arch/cris/arch-v32/kernel/fasttimer.c
+++ b/arch/cris/arch-v32/kernel/fasttimer.c
@@ -97,7 +97,7 @@
  * with time based on jiffies and *R_TIMER0_DATA, uses a table
  * for fast conversion of timer value to microseconds.
  * (Much faster the standard do_gettimeofday() and we don't really
- * wan't to use the true time - we wan't the "uptime" so timers don't screw up
+ * want to use the true time - we want the "uptime" so timers don't screw up
  * when we change the time.
  * TODO: Add efficient support for continuous timers as well.
  *
diff --git a/arch/cris/arch-v32/kernel/irq.c b/arch/cris/arch-v32/kernel/irq.c
index cc361bf..a9acaa2 100644
--- a/arch/cris/arch-v32/kernel/irq.c
+++ b/arch/cris/arch-v32/kernel/irq.c
@@ -140,7 +140,7 @@ block_irq(int irq, int cpu)
         spin_lock_irqsave(&irq_lock, flags);
         intr_mask = REG_RD_INT(intr_vect, irq_regs[cpu], rw_mask);
 
-	/* Remember; 1 let thru, 0 block. */
+	/* Remember; 1 let through, 0 block. */
 	intr_mask &= ~(1 << (irq - FIRST_IRQ));
 
 	REG_WR_INT(intr_vect, irq_regs[cpu], rw_mask, intr_mask);
@@ -156,7 +156,7 @@ unblock_irq(int irq, int cpu)
         spin_lock_irqsave(&irq_lock, flags);
         intr_mask = REG_RD_INT(intr_vect, irq_regs[cpu], rw_mask);
 
-	/* Remember; 1 let thru, 0 block. */
+	/* Remember; 1 let through, 0 block. */
 	intr_mask |= (1 << (irq - FIRST_IRQ));
 
 	REG_WR_INT(intr_vect, irq_regs[cpu], rw_mask, intr_mask);
@@ -308,7 +308,7 @@ crisv32_do_multiple(struct pt_regs* regs)
 	 */
 	irq_enter();
 
-	/* Get which IRQs that happend. */
+	/* Get which IRQs that happened. */
 	masked = REG_RD_INT(intr_vect, irq_regs[cpu], r_masked_vect);
 
 	/* Calculate new IRQ mask with these IRQs disabled. */
@@ -366,7 +366,7 @@ init_IRQ(void)
 	for (i = 0; i < 256; i++)
 		etrax_irv->v[i] = weird_irq;
 
-	/* Point all IRQ's to bad handlers. */
+	/* Point all IRQs to bad handlers. */
 	for (i = FIRST_IRQ, j = 0; j < NR_IRQS; i++, j++) {
 		irq_desc[j].chip = &crisv32_irq_type;
 		set_exception_vector(i, interrupt[j]);
diff --git a/arch/cris/arch-v32/kernel/process.c b/arch/cris/arch-v32/kernel/process.c
index 6326351..b72a155 100644
--- a/arch/cris/arch-v32/kernel/process.c
+++ b/arch/cris/arch-v32/kernel/process.c
@@ -162,7 +162,7 @@ copy_thread(int nr, unsigned long clone_flags, unsigned long usp,
 	/* Put the switch stack right below the pt_regs. */
 	swstack = ((struct switch_stack *) childregs) - 1;
 
-	/* Paramater to ret_from_sys_call. 0 is don't restart the syscall. */
+	/* Parameter to ret_from_sys_call. 0 is don't restart the syscall. */
 	swstack->r9 = 0;
 
 	/*
diff --git a/arch/cris/arch-v32/kernel/signal.c b/arch/cris/arch-v32/kernel/signal.c
index 7cd6ac8..024cc69 100644
--- a/arch/cris/arch-v32/kernel/signal.c
+++ b/arch/cris/arch-v32/kernel/signal.c
@@ -347,7 +347,7 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs * regs, size_t frame_size)
 /* Grab and setup a signal frame.
  *
  * Basically a lot of state-info is stacked, and arranged for the
- * user-mode program to return to the kernel using either a trampiline
+ * user-mode program to return to the kernel using either a trampoline
  * which performs the syscall sigreturn(), or a provided user-mode
  * trampoline.
   */
@@ -641,7 +641,7 @@ ugdb_trap_user(struct thread_info *ti, int sig)
 		user_regs(ti)->spc = 0;
 	}
 	/* FIXME: Filter out false h/w breakpoint hits (i.e. EDA
-	   not withing any configured h/w breakpoint range). Synchronize with
+	   not within any configured h/w breakpoint range). Synchronize with
 	   what already exists for kernel debugging.  */
 	if (((user_regs(ti)->exs & 0xff00) >> 8) == BREAK_8_INTR_VECT) {
 		/* Break 8: subtract 2 from ERP unless in a delay slot. */
diff --git a/arch/cris/arch-v32/kernel/smp.c b/arch/cris/arch-v32/kernel/smp.c
index 77e655f..b8c67f0 100644
--- a/arch/cris/arch-v32/kernel/smp.c
+++ b/arch/cris/arch-v32/kernel/smp.c
@@ -138,7 +138,7 @@ smp_boot_one_cpu(int cpuid)
 	return -1;
 }
 
-/* Secondary CPUs starts uing C here. Here we need to setup CPU
+/* Secondary CPUs starts using C here. Here we need to setup CPU
  * specific stuff such as the local timer and the MMU. */
 void __init smp_callin(void)
 {
diff --git a/arch/cris/arch-v32/kernel/time.c b/arch/cris/arch-v32/kernel/time.c
index be0a016..2f7e8e2 100644
--- a/arch/cris/arch-v32/kernel/time.c
+++ b/arch/cris/arch-v32/kernel/time.c
@@ -99,7 +99,7 @@ unsigned long do_slow_gettimeoffset(void)
 /* From timer MDS describing the hardware watchdog:
  * 4.3.1 Watchdog Operation
  * The watchdog timer is an 8-bit timer with a configurable start value.
- * Once started the whatchdog counts downwards with a frequency of 763 Hz
+ * Once started the watchdog counts downwards with a frequency of 763 Hz
  * (100/131072 MHz). When the watchdog counts down to 1, it generates an
  * NMI (Non Maskable Interrupt), and when it counts down to 0, it resets the
  * chip.
diff --git a/arch/cris/arch-v32/kernel/traps.c b/arch/cris/arch-v32/kernel/traps.c
index 2462b1e..17fd3db 100644
--- a/arch/cris/arch-v32/kernel/traps.c
+++ b/arch/cris/arch-v32/kernel/traps.c
@@ -105,7 +105,7 @@ bad_value:
 
 /*
  * This gets called from entry.S when the watchdog has bitten. Show something
- * similiar to an Oops dump, and if the kernel if configured to be a nice doggy;
+ * similar to an Oops dump, and if the kernel is configured to be a nice doggy;
  * halt instead of reboot.
  */
 void
diff --git a/arch/cris/arch-v32/lib/string.c b/arch/cris/arch-v32/lib/string.c
index 98e282a..6740b2c 100644
--- a/arch/cris/arch-v32/lib/string.c
+++ b/arch/cris/arch-v32/lib/string.c
@@ -41,7 +41,7 @@ void *memcpy(void *pdst,
      Make sure the compiler is able to make something useful of this.
       As it is now: r10 -> r13; r11 -> r11 (nop); r12 -> r12 (nop).
 
-     If gcc was allright, it really would need no temporaries, and no
+     If gcc was alright, it really would need no temporaries, and no
      stack space to save stuff on. */
 
   register void *return_dst __asm__ ("r10") = pdst;
diff --git a/arch/cris/arch-v32/lib/usercopy.c b/arch/cris/arch-v32/lib/usercopy.c
index f0b0846..04d0cf3 100644
--- a/arch/cris/arch-v32/lib/usercopy.c
+++ b/arch/cris/arch-v32/lib/usercopy.c
@@ -34,7 +34,7 @@ __copy_user (void __user *pdst, const void *psrc, unsigned long pn)
      As it is now: r10 -> r13; r11 -> r11 (nop); r12 -> r12 (nop).
 
      FIXME: Comment for old gcc version.  Check.
-     If gcc was allright, it really would need no temporaries, and no
+     If gcc was alright, it really would need no temporaries, and no
      stack space to save stuff on. */
 
   register char *dst __asm__ ("r13") = pdst;
@@ -168,7 +168,7 @@ __copy_user_zeroing (void __user *pdst, const void *psrc, unsigned long pn)
      As it is now: r10 -> r13; r11 -> r11 (nop); r12 -> r12 (nop).
 
      FIXME: Comment for old gcc version.  Check.
-     If gcc was allright, it really would need no temporaries, and no
+     If gcc was alright, it really would need no temporaries, and no
      stack space to save stuff on.  */
 
   register char *dst __asm__ ("r13") = pdst;
@@ -332,7 +332,7 @@ __do_clear_user (void __user *pto, unsigned long pn)
       As it is now: r10 -> r13; r11 -> r11 (nop); r12 -> r12 (nop).
 
      FIXME: Comment for old gcc version.  Check.
-     If gcc was allright, it really would need no temporaries, and no
+     If gcc was alright, it really would need no temporaries, and no
      stack space to save stuff on. */
 
   register char *dst __asm__ ("r13") = pto;
diff --git a/arch/cris/arch-v32/mm/tlb.c b/arch/cris/arch-v32/mm/tlb.c
index c2d12e9..a076ef6 100644
--- a/arch/cris/arch-v32/mm/tlb.c
+++ b/arch/cris/arch-v32/mm/tlb.c
@@ -30,8 +30,8 @@ do {						\
  * The TLB can host up to 256 different mm contexts at the same time. The running
  * context is found in the PID register. Each TLB entry contains a page_id that
  * has to match the PID register to give a hit. page_id_map keeps track of which
- * mm's is assigned to which page_id's, making sure it's known when to
- * invalidate TLB entries.
+ * mm is assigned to which page_id, making sure it's known when to invalidate TLB
+ * entries.
  *
  * The last page_id is never running, it is used as an invalid page_id so that
  * it's possible to make TLB entries that will nerver match.
@@ -188,7 +188,7 @@ switch_mm(struct mm_struct *prev, struct mm_struct *next,
 	spin_unlock(&mmu_context_lock);
 
 	/*
-	 * Remember the pgd for the fault handlers. Keep a seperate copy of it
+	 * Remember the pgd for the fault handlers. Keep a separate copy of it
 	 * because current and active_mm might be invalid at points where
 	 * there's still a need to derefer the pgd.
 	 */
diff --git a/arch/cris/kernel/irq.c b/arch/cris/kernel/irq.c
index 903ea62..5c27ff8 100644
--- a/arch/cris/kernel/irq.c
+++ b/arch/cris/kernel/irq.c
@@ -7,7 +7,7 @@
  *      Authors: Bjorn Wesen (bjornw@axis.com)
  *
  * This file contains the code used by various IRQ handling routines:
- * asking for different IRQ's should be done through these routines
+ * asking for different IRQs should be done through these routines
  * instead of just grabbing them. Thus setups with different IRQ numbers
  * shouldn't result in any weird surprises, and installing new handlers
  * should be easier.
@@ -15,7 +15,7 @@
  */
 
 /*
- * IRQ's are in fact implemented a bit like signal handlers for the kernel.
+ * IRQs are in fact implemented a bit like signal handlers for the kernel.
  * Naturally it's not a 1:1 relation, but there are similarities.
  */
 
@@ -83,9 +83,9 @@ skip:
 
 
 /* called by the assembler IRQ entry functions defined in irq.h
- * to dispatch the interrupts to registred handlers
+ * to dispatch the interrupts to registered handlers
  * interrupts are disabled upon entry - depending on if the
- * interrupt was registred with IRQF_DISABLED or not, interrupts
+ * interrupt was registered with IRQF_DISABLED or not, interrupts
  * are re-enabled or not.
  */
 
diff --git a/arch/cris/mm/fault.c b/arch/cris/mm/fault.c
index c73e91f..01ff7c3 100644
--- a/arch/cris/mm/fault.c
+++ b/arch/cris/mm/fault.c
@@ -13,7 +13,7 @@
  *  Fixed warning.
  *
  *  Revision 1.18  2005/01/12 08:10:14  starvik
- *  Readded the change of frametype when handling kernel page fault fixup
+ *  Re-added the change of frametype when handling kernel page fault fixup
  *  for v10. This is necessary to avoid that the CPU remakes the faulting
  *  access.
  *
@@ -49,7 +49,7 @@
  *
  *  Revision 1.8  2003/07/04 13:02:48  tobiasa
  *  Moved code snippet from arch/cris/mm/fault.c that searches for fixup code
- *  to seperate function in arch-specific files.
+ *  to separate function in arch-specific files.
  *
  *  Revision 1.7  2003/01/22 06:48:38  starvik
  *  Fixed warnings issued by GCC 3.2.1
diff --git a/arch/cris/mm/init.c b/arch/cris/mm/init.c
index b7842ff..0c833d1 100644
--- a/arch/cris/mm/init.c
+++ b/arch/cris/mm/init.c
@@ -8,7 +8,7 @@
  *
  *  $Log: init.c,v $
  *  Revision 1.11  2004/05/28 09:28:56  starvik
- *  Calculation of loops_per_usec moved because initalization order has changed
+ *  Calculation of loops_per_usec moved because initialization order has changed
  *  in Linux 2.6.
  *
  *  Revision 1.10  2004/05/14 07:58:05  starvik
diff --git a/arch/cris/mm/tlb.c b/arch/cris/mm/tlb.c
index c4a98e2..b7f8de5 100644
--- a/arch/cris/mm/tlb.c
+++ b/arch/cris/mm/tlb.c
@@ -16,7 +16,7 @@
 /* The TLB can host up to 64 different mm contexts at the same time.
  * The running context is R_MMU_CONTEXT, and each TLB entry contains a
  * page_id that has to match to give a hit. In page_id_map, we keep track
- * of which mm's we have assigned which page_id's, so that we know when
+ * of which mm we have assigned to which page_id, so that we know when
  * to invalidate TLB entries.
  *
  * The last page_id is never running - it is used as an invalid page_id
-- 
1.5.0.1

-- 
Simon Arlott
