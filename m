Return-Path: <linux-kernel-owner+w=401wt.eu-S1759329AbZA2EML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329AbZA2EML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 23:12:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbZA2ELz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 23:11:55 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:47862 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507AbZA2ELy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 23:11:54 -0500
Subject: [RFC][PATCH 10/10] Remove CONFIG_GENERIC_TIME
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: rmk+lkml@arm.linux.org.uk, cooloney@kernel.org, starvik@axis.com,
       takata@linux-m32r.org, geert@linux-m68k.org,
       Roman Zippel <zippel@linux-m68k.org>, lethal@linux-sh.org,
       Magnus Damm <magnus.damm@gmail.com>, wli@holomorphy.com,
       chris@zankel.net, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1233202273.6895.47.camel@localhost.localdomain>
References: <1233201926.6895.25.camel@localhost.localdomain>
	 <1233201995.6895.27.camel@localhost.localdomain>
	 <1233202037.6895.30.camel@localhost.localdomain>
	 <1233202074.6895.33.camel@localhost.localdomain>
	 <1233202104.6895.35.camel@localhost.localdomain>
	 <1233202139.6895.38.camel@localhost.localdomain>
	 <1233202175.6895.40.camel@localhost.localdomain>
	 <1233202206.6895.43.camel@localhost.localdomain>
	 <1233202241.6895.45.camel@localhost.localdomain>
	 <1233202273.6895.47.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 28 Jan 2009 20:11:48 -0800
Message-Id: <1233202308.6895.50.camel@localhost.localdomain>
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
index 3c04f80..00774f8 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -36,10 +36,6 @@ config GENERIC_GPIO
 	bool
 	default n
 
-config GENERIC_TIME
-	bool
-	default y
-
 config GENERIC_CLOCKEVENTS
 	bool
 	default n
diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index b189680..905f5cf 100644
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
index ebe5e28..1754b80 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -575,12 +575,8 @@ comment "Kernel Timer/Scheduler"
 
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
index 8082352..8265e78 100644
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
index 9420648..3bf6e51 100644
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
index 6183aec..339a368 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -77,10 +77,6 @@ config GENERIC_CALIBRATE_DELAY
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
index c41234f..32ad821 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -41,9 +41,6 @@ config HZ
 	int
 	default 100
 
-config GENERIC_TIME
-	def_bool y
-
 config ARCH_USES_GETTIMEOFFSET
 	def_bool y
 
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 29dd848..7b0f880 100644
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
index 4beb59d..2806400 100644
--- a/arch/m68knommu/Kconfig
+++ b/arch/m68knommu/Kconfig
@@ -58,10 +58,6 @@ config GENERIC_CALIBRATE_DELAY
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
index 52c80c2..a5a4e9c 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -684,10 +684,6 @@ config GENERIC_CLOCKEVENTS
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
index aacf11d..36d0e9d 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -60,10 +60,6 @@ config GENERIC_CALIBRATE_DELAY
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
index 74cc312..dcbabd8 100644
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
index 6b0a353..11eeb9b 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -40,9 +40,6 @@ config ARCH_HAS_ILOG2_U64
 config GENERIC_HWEIGHT
 	def_bool y
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_TIME_VSYSCALL
 	def_bool y
 
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index c48ab20..390f13c 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -71,9 +71,6 @@ config GENERIC_CALIBRATE_DELAY
 config GENERIC_IOMAP
 	bool
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_CLOCKEVENTS
 	def_bool n
 
@@ -401,7 +398,6 @@ config SH_TMU
 	def_bool y
 	prompt "TMU timer support"
 	depends on CPU_SH3 || CPU_SH4
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	help
 	  This enables the use of the TMU as the system timer.
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index a5b465f..eeba45a 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -54,9 +54,6 @@ config BITS
 	default 32 if SPARC32
 	default 64 if SPARC64
 
-config GENERIC_TIME
-	def_bool y
-
 config ARCH_USES_GETTIMEOFFSET
 	bool
 	default y if SPARC32
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
index 73f7fe8..a110cd2 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -46,9 +46,6 @@ config ARCH_DEFCONFIG
 	default "arch/x86/configs/i386_defconfig" if X86_32
 	default "arch/x86/configs/x86_64_defconfig" if X86_64
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_CMOS_UPDATE
 	def_bool y
 
@@ -1892,7 +1889,7 @@ config SCx200
 
 config SCx200HR_TIMER
 	tristate "NatSemi SCx200 27MHz High-Resolution Timer Support"
-	depends on SCx200 && GENERIC_TIME
+	depends on SCx200
 	default y
 	help
 	  This driver provides a clocksource built upon the on-chip
@@ -1904,7 +1901,7 @@ config SCx200HR_TIMER
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
index c1bf417..7703ae5 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -96,7 +96,9 @@ obj-$(CONFIG_SGI_SN)		+= sn/
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
index 66a9d81..3a17f3d 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -370,7 +370,7 @@ int acpi_processor_resume(struct acpi_device * device)
 	return 0;
 }
 
-#if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
+#if defined(CONFIG_X86)
 static int tsc_halts_in_c(int state)
 {
 	switch (boot_cpu_data.x86_vendor) {
@@ -553,7 +553,7 @@ static void acpi_processor_idle(void)
 		/* Get end time (ticks) */
 		t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
 
-#if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
+#if defined(CONFIG_X86)
 		/* TSC halts in C2, so notify users */
 		if (tsc_halts_in_c(ACPI_STATE_C2))
 			mark_tsc_unstable("possible TSC halt in C2");
@@ -618,7 +618,7 @@ static void acpi_processor_idle(void)
 			acpi_set_register(ACPI_BITREG_ARB_DISABLE, 0);
 		}
 
-#if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
+#if defined(CONFIG_X86)
 		/* TSC halts in C3, so notify users */
 		if (tsc_halts_in_c(ACPI_STATE_C3))
 			mark_tsc_unstable("TSC halts in C3");
@@ -1539,7 +1539,7 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
 	acpi_idle_do_entry(cx);
 	t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
 
-#if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
+#if defined(CONFIG_X86)
 	/* TSC could halt in idle, so notify users */
 	if (tsc_halts_in_c(cx->type))
 		mark_tsc_unstable("TSC halts in idle");;
@@ -1656,7 +1656,7 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 		spin_unlock(&c3_lock);
 	}
 
-#if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
+#if defined(CONFIG_X86)
 	/* TSC could halt in idle, so notify users */
 	if (tsc_halts_in_c(ACPI_STATE_C3))
 		mark_tsc_unstable("TSC halts in idle");
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 5607319..72baa20 100644
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
index 2951194..f001888 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -302,22 +302,6 @@ struct timespec timespec_trunc(struct timespec t, unsigned gran)
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
index 45d777f..7b0575c 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -59,7 +59,6 @@ void update_xtime_cache(u64 nsec)
 struct clocksource *clock;
 
 
-#ifdef CONFIG_GENERIC_TIME
 /**
  * clocksource_forward_now - update clock to the current time
  *
@@ -182,6 +181,7 @@ int do_settimeofday(struct timespec *tv)
 
 EXPORT_SYMBOL(do_settimeofday);
 
+#ifndef CONFIG_ARCH_USES_GETTIMEOFFSET
 /**
  * change_clocksource - Swaps clocksources if a new one is available
  *
@@ -217,7 +217,6 @@ static void change_clocksource(void)
 	 */
 }
 #else
-static inline void clocksource_forward_now(void) { }
 static inline void change_clocksource(void) { }
 #endif
 
@@ -492,10 +491,10 @@ void update_wall_time(void)
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
index e2a4ff6..3adb233 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -81,7 +81,7 @@ config IRQSOFF_TRACER
 	bool "Interrupts-off Latency Tracer"
 	default n
 	depends on TRACE_IRQFLAGS_SUPPORT
-	depends on GENERIC_TIME
+	depends on !ARCH_USES_GETTIMEOFFSET
 	depends on DEBUG_KERNEL
 	select TRACE_IRQFLAGS
 	select TRACING
@@ -103,7 +103,7 @@ config IRQSOFF_TRACER
 config PREEMPT_TRACER
 	bool "Preemption-off Latency Tracer"
 	default n
-	depends on GENERIC_TIME
+	depends on !ARCH_USES_GETTIMEOFFSET
 	depends on PREEMPT
 	depends on DEBUG_KERNEL
 	select TRACING


