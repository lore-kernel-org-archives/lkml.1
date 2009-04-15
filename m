Return-Path: <linux-kernel-owner+w=401wt.eu-S1758317AbZDOBxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758317AbZDOBxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 21:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754176AbZDOBxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 21:53:40 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:55008 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbZDOBxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 21:53:38 -0400
Subject: [RFC][PATCH 8/8] Remove CONFIG_GENERIC_TIME
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: rmk+lkml@arm.linux.org.uk, cooloney@kernel.org, starvik@axis.com,
       takata@linux-m32r.org, geert@linux-m68k.org,
       Roman Zippel <zippel@linux-m68k.org>, lethal@linux-sh.org,
       Magnus Damm <magnus.damm@gmail.com>, wli@holomorphy.com,
       rth@twiddle.net
In-Reply-To: <1239760286.6064.44.camel@localhost>
References: <1239759163.6064.25.camel@localhost>
	 <1239759251.6064.27.camel@localhost>  <1239759393.6064.30.camel@localhost>
	 <1239759551.6064.33.camel@localhost>  <1239759668.6064.35.camel@localhost>
	 <1239759805.6064.36.camel@localhost>  <1239759877.6064.37.camel@localhost>
	 <1239759929.6064.38.camel@localhost>  <1239760000.6064.39.camel@localhost>
	 <1239760286.6064.44.camel@localhost>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 18:53:22 -0700
Message-Id: <1239760402.6064.46.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes all references to CONFIG_GENERIC_TIME in the timekeeping
core as well as the arch Kconfig files.

Arch defconfig files were left alone.

Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 6172e43..d6769ff 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -64,7 +64,6 @@ parameter is applicable:
 	MTD	MTD (Memory Technology Device) support is enabled.
 	NET	Appropriate network support is enabled.
 	NUMA	NUMA support is enabled.
-	GENERIC_TIME The generic timeofday code is enabled.
 	NFS	Appropriate NFS support is enabled.
 	OSS	OSS sound support is enabled.
 	PV_OPS	A paravirtualized kernel is enabled.
@@ -426,7 +425,7 @@ and is between 256 and 4096 characters. It is defined in the file
 			clocksource is not available, it defaults to PIT.
 			Format: { pit | tsc | cyclone | pmtmr }
 
-	clocksource=	[GENERIC_TIME] Override the default clocksource
+	clocksource=	Override the default clocksource
 			Format: <string>
 			Override the default clocksource and use the clocksource
 			with the name specified.
diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 4434481..e2251b5 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -45,10 +45,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config GENERIC_TIME
-	bool
-	default y
-
 config ARCH_USES_GETTIMEOFFSET
 	bool
 	default y
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 61c88e1..37f3bda 100644
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
index 35e3bd9..0b1e70d 100644
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
index 2b41547..7be2b94 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -605,12 +605,8 @@ comment "Kernel Timer/Scheduler"
 
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
index 059eac6..a668ce1 100644
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
index 294a3b1..5e1df8c 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -80,10 +80,6 @@ config GENERIC_CALIBRATE_DELAY
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
diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index 8cc312b..73d9963 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -37,9 +37,6 @@ config GENERIC_IRQ_PROBE
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_TIME_VSYSCALL
 	def_bool n
 
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 998e5db..8e1be85 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -680,10 +680,6 @@ config GENERIC_CLOCKEVENTS
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
index 3559267..bab6c1f 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -42,9 +42,6 @@ config GENERIC_FIND_NEXT_BIT
 config GENERIC_HWEIGHT
 	def_bool y
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_BUG
 	def_bool y
 
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 9038f39..c42c0b4 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -64,10 +64,6 @@ config GENERIC_CALIBRATE_DELAY
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
index 5b50e1a..c3f6489 100644
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
index 2eca5fe..dae9e1b 100644
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
index 8a13c1a..23ffcae 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -73,9 +73,6 @@ config GENERIC_CALIBRATE_DELAY
 config GENERIC_IOMAP
 	bool
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_CLOCKEVENTS
 	def_bool n
 
@@ -446,7 +443,6 @@ config SH_TMU
 	bool "TMU timer support"
 	depends on CPU_SH3 || CPU_SH4
 	default y
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	help
 	  This enables the use of the TMU as the system timer.
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 1358aab..527efea 100644
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
index bc25b9f..c73cb50 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -52,9 +52,6 @@ config ARCH_DEFCONFIG
 	default "arch/x86/configs/i386_defconfig" if X86_32
 	default "arch/x86/configs/x86_64_defconfig" if X86_64
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_CMOS_UPDATE
 	def_bool y
 
@@ -1942,7 +1939,7 @@ config SCx200
 
 config SCx200HR_TIMER
 	tristate "NatSemi SCx200 27MHz High-Resolution Timer Support"
-	depends on SCx200 && GENERIC_TIME
+	depends on SCx200
 	default y
 	---help---
 	  This driver provides a clocksource built upon the on-chip
@@ -1954,7 +1951,7 @@ config SCx200HR_TIMER
 config GEODE_MFGPT_TIMER
 	def_bool y
 	prompt "Geode Multi-Function General Purpose Timer (MFGPT) events"
-	depends on MGEODE_LX && GENERIC_TIME && GENERIC_CLOCKEVENTS
+	depends on MGEODE_LX && GENERIC_CLOCKEVENTS
 	---help---
 	  This driver provides a clock event source based on the MFGPT
 	  timer(s) in the CS5535 and CS5536 companion chip for the geode.
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index fa6dc4d..7bbc6c1 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -48,9 +48,6 @@ config HZ
 	int
 	default 100
 
-config GENERIC_TIME
-	def_bool y
-
 source "init/Kconfig"
 source "kernel/Kconfig.freezer"
 
diff --git a/drivers/Makefile b/drivers/Makefile
index 2618a61..953bc52 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -97,7 +97,9 @@ obj-$(CONFIG_SGI_SN)		+= sn/
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
index 6fe1214..84bee72 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -215,7 +215,7 @@ int acpi_processor_resume(struct acpi_device * device)
 	return 0;
 }
 
-#if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
+#if defined (CONFIG_X86)
 static int tsc_halts_in_c(int state)
 {
 	switch (boot_cpu_data.x86_vendor) {
@@ -871,7 +871,7 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
 	kt2 = ktime_get_real();
 	idle_time =  ktime_to_us(ktime_sub(kt2, kt1));
 
-#if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
+#if defined (CONFIG_X86)
 	/* TSC could halt in idle, so notify users */
 	if (tsc_halts_in_c(cx->type))
 		mark_tsc_unstable("TSC halts in idle");;
@@ -989,7 +989,7 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 		spin_unlock(&c3_lock);
 	}
 
-#if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
+#if defined (CONFIG_X86)
 	/* TSC could halt in idle, so notify users */
 	if (tsc_halts_in_c(ACPI_STATE_C3))
 		mark_tsc_unstable("TSC halts in idle");
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 6d1ac18..1a2be66 100644
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
index 417d198..b156fee 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -108,7 +108,7 @@ config IRQSOFF_TRACER
 	bool "Interrupts-off Latency Tracer"
 	default n
 	depends on TRACE_IRQFLAGS_SUPPORT
-	depends on GENERIC_TIME
+	depends on !ARCH_USES_GETTIMEOFFSET
 	select TRACE_IRQFLAGS
 	select TRACING
 	select TRACER_MAX_TRACE
@@ -129,7 +129,7 @@ config IRQSOFF_TRACER
 config PREEMPT_TRACER
 	bool "Preemption-off Latency Tracer"
 	default n
-	depends on GENERIC_TIME
+	depends on !ARCH_USES_GETTIMEOFFSET
 	depends on PREEMPT
 	select TRACING
 	select TRACER_MAX_TRACE


