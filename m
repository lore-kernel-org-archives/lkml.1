Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbYLIDwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbYLIDwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 22:52:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbYLIDv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 22:51:56 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:34613 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbYLIDvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 22:51:54 -0500
Subject: [RFC][PATCH 3/3] Remove CONFIG_GENERIC_TIME
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: rmk+lkml@arm.linux.org.uk, cooloney@kernel.org, starvik@axis.com,
       takata@linux-m32r.org, geert@linux-m68k.org,
       Roman Zippel <zippel@linux-m68k.org>, lethal@linux-sh.org,
       Magnus Damm <magnus.damm@gmail.com>, wli@holomorphy.com,
       chris@zankel.net, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1228794667.6918.61.camel@localhost.localdomain>
References: <1228794561.6918.57.camel@localhost.localdomain>
	 <1228794627.6918.59.camel@localhost.localdomain>
	 <1228794667.6918.61.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 08 Dec 2008 19:51:47 -0800
Message-Id: <1228794707.6918.63.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes all references to CONFIG_GENERIC_TIME in the timekeeping
core as well as the arch Kconfig files.

Arch defconfig files were left alone.

Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index ed4c53b..a859f28 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -36,10 +36,6 @@ config GENERIC_GPIO
 	bool
 	default n
 
-config GENERIC_TIME
-	bool
-	default y
-
 config USES_CLOCKSOURCES
 	bool
 	default n
diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index 26eca87..f856283 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -45,9 +45,6 @@ config GENERIC_IRQ_PROBE
 config RWSEM_GENERIC_SPINLOCK
 	def_bool y
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_CLOCKEVENTS
 	def_bool y
 
diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 38e8996..c724053 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -457,12 +457,8 @@ comment "Kernel Timer/Scheduler"
 
 source kernel/Kconfig.hz
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_CLOCKEVENTS
 	bool "Generic clock events"
-	depends on GENERIC_TIME
 	default y
 
 config CYCLES_CLOCKSOURCE
diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index edf8f7f..a859438 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -20,9 +20,6 @@ config RWSEM_GENERIC_SPINLOCK
 config RWSEM_XCHGADD_ALGORITHM
 	bool
 
-config GENERIC_TIME
-	def_bool y
-
 config ARCH_USES_GETTIMEOFFSET
 	def_bool y
 
diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index 9d1552a..42c3497 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -38,10 +38,6 @@ config GENERIC_HARDIRQS_NO__DO_IRQ
 	bool
 	default y
 
-config GENERIC_TIME
-	bool
-	default y
-
 config TIME_LOW_RES
 	bool
 	default y
diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index 28f06fd..da58658 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -58,10 +58,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config GENERIC_TIME
-	bool
-	default y
-
 config GENERIC_BUG
         bool
         depends on BUG
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 6bd91ed..aa9f1a2 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -76,10 +76,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config GENERIC_TIME
-	bool
-	default y
-
 config GENERIC_TIME_VSYSCALL
 	bool
 	default y
diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index f10e315..f2f8883 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -40,9 +40,6 @@ config HZ
 	int
 	default 100
 
-config GENERIC_TIME
-	def_bool y
-
 config ARCH_USES_GETTIMEOFFSET
 	def_bool y
 
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 9fd83da..988a734 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -58,9 +58,6 @@ config HZ
 	int
 	default 100
 
-config GENERIC_TIME
-	def_bool y
-
 config ARCH_USES_GETTIMEOFFSET
 	def_bool y
 
diff --git a/arch/m68knommu/Kconfig b/arch/m68knommu/Kconfig
index 76b66fe..cc673c3 100644
--- a/arch/m68knommu/Kconfig
+++ b/arch/m68knommu/Kconfig
@@ -54,10 +54,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config GENERIC_TIME
-	bool
-	default y
-
 config GENERIC_CMOS_UPDATE
 	bool
 	default y
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index f4af967..cc3754b 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -645,10 +645,6 @@ config GENERIC_CLOCKEVENTS
 	bool
 	default y
 
-config GENERIC_TIME
-	bool
-	default y
-
 config GENERIC_CMOS_UPDATE
 	bool
 	default y
diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index 9a9f433..0792a47 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -41,9 +41,6 @@ config GENERIC_FIND_NEXT_BIT
 config GENERIC_HWEIGHT
 	def_bool y
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_BUG
 	def_bool y
 
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 644a70b..d6140de 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -59,10 +59,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config GENERIC_TIME
-	bool
-	default y
-
 config TIME_LOW_RES
 	bool
 	depends on SMP
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 525c13a..68d165a 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -29,9 +29,6 @@ config MMU
 config GENERIC_CMOS_UPDATE
 	def_bool y
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_TIME_VSYSCALL
 	def_bool y
 
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 8116a33..e9db7c6 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -40,9 +40,6 @@ config ARCH_HAS_ILOG2_U64
 config GENERIC_HWEIGHT
 	def_bool y
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_CLOCKEVENTS
 	def_bool y
 
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 2bc451f..b358f10 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -68,9 +68,6 @@ config GENERIC_CALIBRATE_DELAY
 config GENERIC_IOMAP
 	bool
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_CLOCKEVENTS
 	def_bool n
 
@@ -386,7 +383,6 @@ config SH_TMU
 	def_bool y
 	prompt "TMU timer support"
 	depends on CPU_SH3 || CPU_SH4
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	help
 	  This enables the use of the TMU as the system timer.
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 76b5008..8508a59 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -35,9 +35,6 @@ config HZ
 	int
 	default 100
 
-config GENERIC_TIME
-	def_bool y
-
 config ARCH_USES_GETTIMEOFFSET
 	def_bool y
 
diff --git a/arch/sparc64/Kconfig b/arch/sparc64/Kconfig
index 3b96e70..45d2546 100644
--- a/arch/sparc64/Kconfig
+++ b/arch/sparc64/Kconfig
@@ -25,10 +25,6 @@ config SPARC64
 	select RTC_DRV_SUN4V
 	select RTC_DRV_STARFIRE
 
-config GENERIC_TIME
-	bool
-	default y
-
 config GENERIC_CMOS_UPDATE
 	bool
 	default y
diff --git a/arch/um/Kconfig.common b/arch/um/Kconfig.common
index 0d207e7..7c8e277 100644
--- a/arch/um/Kconfig.common
+++ b/arch/um/Kconfig.common
@@ -55,10 +55,6 @@ config GENERIC_BUG
 	default y
 	depends on BUG
 
-config GENERIC_TIME
-	bool
-	default y
-
 config GENERIC_CLOCKEVENTS
 	bool
 	default y
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ac22bb7..8307f0a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -40,9 +40,6 @@ config ARCH_DEFCONFIG
 	default "arch/x86/configs/i386_defconfig" if X86_32
 	default "arch/x86/configs/x86_64_defconfig" if X86_64
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_CMOS_UPDATE
 	def_bool y
 
@@ -1824,7 +1821,7 @@ config SCx200
 
 config SCx200HR_TIMER
 	tristate "NatSemi SCx200 27MHz High-Resolution Timer Support"
-	depends on SCx200 && GENERIC_TIME
+	depends on SCx200
 	default y
 	help
 	  This driver provides a clocksource built upon the on-chip
@@ -1836,7 +1833,7 @@ config SCx200HR_TIMER
 config GEODE_MFGPT_TIMER
 	def_bool y
 	prompt "Geode Multi-Function General Purpose Timer (MFGPT) events"
-	depends on MGEODE_LX && GENERIC_TIME && GENERIC_CLOCKEVENTS
+	depends on MGEODE_LX && GENERIC_CLOCKEVENTS
 	help
 	  This driver provides a clock event source based on the MFGPT
 	  timer(s) in the CS5535 and CS5536 companion chip for the geode.
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index ea3fdfe..95b6061 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -54,9 +54,6 @@ config HZ
 	int
 	default 100
 
-config GENERIC_TIME
-	def_bool y
-
 config ARCH_USES_GETTIMEOFFSET
 	def_bool y
 
diff --git a/drivers/Makefile b/drivers/Makefile
index fceb71a..6fc16fe 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -92,7 +92,9 @@ obj-$(CONFIG_SGI_SN)		+= sn/
 obj-y				+= firmware/
 obj-$(CONFIG_CRYPTO)		+= crypto/
 obj-$(CONFIG_SUPERH)		+= sh/
-obj-$(CONFIG_GENERIC_TIME)	+= clocksource/
+ifndef CONFIG_ARCH_USES_GETTIMEOFFSET
+obj-y				+= clocksource/
+endif
 obj-$(CONFIG_DMA_ENGINE)	+= dma/
 obj-$(CONFIG_DCA)		+= dca/
 obj-$(CONFIG_HID)		+= hid/
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 5f8d746..14bdeee 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -369,7 +369,7 @@ int acpi_processor_resume(struct acpi_device * device)
 	return 0;
 }
 
-#if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
+#if defined(CONFIG_X86)
 static int tsc_halts_in_c(int state)
 {
 	switch (boot_cpu_data.x86_vendor) {
@@ -552,7 +552,7 @@ static void acpi_processor_idle(void)
 		/* Get end time (ticks) */
 		t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
 
-#if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
+#if defined(CONFIG_X86)
 		/* TSC halts in C2, so notify users */
 		if (tsc_halts_in_c(ACPI_STATE_C2))
 			mark_tsc_unstable("possible TSC halt in C2");
@@ -617,7 +617,7 @@ static void acpi_processor_idle(void)
 			acpi_set_register(ACPI_BITREG_ARB_DISABLE, 0);
 		}
 
-#if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
+#if defined(CONFIG_X86)
 		/* TSC halts in C3, so notify users */
 		if (tsc_halts_in_c(ACPI_STATE_C3))
 			mark_tsc_unstable("TSC halts in C3");
@@ -1538,7 +1538,7 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
 	acpi_idle_do_entry(cx);
 	t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
 
-#if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
+#if defined(CONFIG_X86)
 	/* TSC could halt in idle, so notify users */
 	if (tsc_halts_in_c(cx->type))
 		mark_tsc_unstable("TSC halts in idle");;
@@ -1655,7 +1655,7 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 		spin_unlock(&c3_lock);
 	}
 
-#if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
+#if defined(CONFIG_X86)
 	/* TSC could halt in idle, so notify users */
 	if (tsc_halts_in_c(ACPI_STATE_C3))
 		mark_tsc_unstable("TSC halts in idle");
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index fee7304..7fccb27 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -32,7 +32,7 @@ config ATMEL_TCLIB
 
 config ATMEL_TCB_CLKSRC
 	bool "TC Block Clocksource"
-	depends on ATMEL_TCLIB && GENERIC_TIME
+	depends on ATMEL_TCLIB
 	default y
 	help
 	  Select this to get a high precision clocksource based on a
diff --git a/kernel/time.c b/kernel/time.c
index d63a433..1e610cd 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -300,22 +300,6 @@ struct timespec timespec_trunc(struct timespec t, unsigned gran)
 }
 EXPORT_SYMBOL(timespec_trunc);
 
-#ifndef CONFIG_GENERIC_TIME
-/*
- * Simulate gettimeofday using do_gettimeofday which only allows a timeval
- * and therefore only yields usec accuracy
- */
-void getnstimeofday(struct timespec *tv)
-{
-	struct timeval x;
-
-	do_gettimeofday(&x);
-	tv->tv_sec = x.tv_sec;
-	tv->tv_nsec = x.tv_usec * NSEC_PER_USEC;
-}
-EXPORT_SYMBOL_GPL(getnstimeofday);
-#endif
-
 /* Converts Gregorian date to seconds since 1970-01-01 00:00:00.
  * Assumes input in normal date format, i.e. 1980-12-31 23:59:59
  * => year=1980, mon=12, day=31, hour=23, min=59, sec=59.
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 95ed429..f06a8a3 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -6,7 +6,7 @@ config TICK_ONESHOT
 
 config NO_HZ
 	bool "Tickless System (Dynamic Ticks)"
-	depends on GENERIC_TIME && GENERIC_CLOCKEVENTS
+	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
 	select TICK_ONESHOT
 	help
 	  This option enables a tickless system: timer interrupts will
@@ -15,7 +15,7 @@ config NO_HZ
 
 config HIGH_RES_TIMERS
 	bool "High Resolution Timer Support"
-	depends on GENERIC_TIME && GENERIC_CLOCKEVENTS
+	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
 	select TICK_ONESHOT
 	help
 	  This option enables high resolution timer support. If your
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 087a783..e07ca9c 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -56,7 +56,6 @@ void update_xtime_cache(u64 nsec)
 struct clocksource *clock;
 
 
-#ifdef CONFIG_GENERIC_TIME
 /**
  * clocksource_forward_now - update clock to the current time
  *
@@ -177,6 +176,7 @@ int do_settimeofday(struct timespec *tv)
 
 EXPORT_SYMBOL(do_settimeofday);
 
+#ifndef CONFIG_ARCH_USES_GETTIMEOFFSET
 /**
  * change_clocksource - Swaps clocksources if a new one is available
  *
@@ -212,7 +212,6 @@ static void change_clocksource(void)
 	 */
 }
 #else
-static inline void clocksource_forward_now(void) { }
 static inline void change_clocksource(void) { }
 #endif
 
@@ -489,10 +488,10 @@ void update_wall_time(void)
 	if (unlikely(timekeeping_suspended))
 		return;
 
-#ifdef CONFIG_GENERIC_TIME
-	offset = (clocksource_read(clock) - clock->cycle_last) & clock->mask;
-#else
+#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
 	offset = clock->cycle_interval;
+#else
+	offset = (clocksource_read(clock) - clock->cycle_last) & clock->mask;
 #endif
 	clock->xtime_nsec = (s64)xtime.tv_nsec << clock->shift;
 
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 33dbefd..20cd333 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -51,7 +51,7 @@ config IRQSOFF_TRACER
 	bool "Interrupts-off Latency Tracer"
 	default n
 	depends on TRACE_IRQFLAGS_SUPPORT
-	depends on GENERIC_TIME
+	depends on !ARCH_USES_GETTIMEOFFSET
 	depends on DEBUG_KERNEL
 	select TRACE_IRQFLAGS
 	select TRACING
@@ -73,7 +73,7 @@ config IRQSOFF_TRACER
 config PREEMPT_TRACER
 	bool "Preemption-off Latency Tracer"
 	default n
-	depends on GENERIC_TIME
+	depends on !ARCH_USES_GETTIMEOFFSET
 	depends on PREEMPT
 	depends on DEBUG_KERNEL
 	select TRACING


