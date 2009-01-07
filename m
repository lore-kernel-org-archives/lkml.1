Return-Path: <linux-kernel-owner+w=401wt.eu-S932105AbZAGSQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105AbZAGSQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 13:16:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbZAGSQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 13:16:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55428 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620AbZAGSQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 13:16:05 -0500
Date: Wed, 7 Jan 2009 19:15:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 updates
Message-ID: <20090107181541.GA14718@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

Cleanups and fixlets - and the change that makes FRAME_POINTERS more 
prominent on x86. (this also touches lib/Kconfig.debug)

 Thanks,

	Ingo

------------------>
Alan Cox (1):
      x86: update Alan Cox's email addresses

Baodong Chen (1):
      Documentation/x86/boot.txt: payload length was changed to payload_length

Huang Weiyi (1):
      x86: remove duplicated #include's

Ingo Molnar (1):
      x86: offer frame pointers in all build modes

Jaswinder Singh Rajput (28):
      x86: rename mp_config_table to mpc_table
      x86: rename mpc_config_bus to mpc_bus
      x86: rename mpc_config_processor to mpc_cpu
      x86: rename mpc_config_ioapic to mpc_ioapic
      x86: rename mpc_config_intsrc to mpc_intsrc
      x86: rename mpc_config_lintsrc to mpc_lintsrc
      x86: rename mpc_config_oemtable to mpc_oemtable
      x86: apic.c fix style problems
      x86: process_32.c fix style problems
      x86: traps.c fix style problems
      x86: irq.c fix style problems
      x86: irq_64.c fix style problems
      x86: time_32.c fix style problems
      x86: time_64.c fix style problems
      x86: ioport.c fix style problems
      x86: irq_32.c fix style problems
      x86: i8259.c fix style problems
      x86: irqinit_32.c fix style problems
      x86: irqinit_64.c fix style problems
      x86: setup_percpu.c fix style problems
      x86: irqinit_64.c init_ISA_irqs should be static
      x86: rename all fields of mpc_iopic mpc_X to X
      x86: rename all fields of mpc_lintsrc mpc_X to X
      x86: rename all fields of mpc_intsrc mpc_X to X
      x86: rename all fields of mpc_cpu mpc_X to X
      x86: rename all fields of mpc_bus mpc_X to X
      x86: rename all fields of mpc_oemtable oem_X to X
      x86: rename all fields of mpc_table mpc_X to X

Jiri Slaby (1):
      x86: fix RIP printout in early_idt_handler

Leonardo Potenza (1):
      x86: fix section mismatch warnings in mcheck/mce_amd_64.c

Markus Trippelsdorf (1):
      x86: remove debug printks (io_apic.c)

Yinghai Lu (1):
      x86: k8 numa register active regions later


 Documentation/x86/boot.txt                       |    2 +-
 arch/x86/Kconfig                                 |    1 +
 arch/x86/include/asm/es7000/mpparse.h            |    3 +-
 arch/x86/include/asm/genapic_32.h                |    8 +-
 arch/x86/include/asm/mach-default/mach_mpparse.h |    4 +-
 arch/x86/include/asm/mach-generic/mach_mpparse.h |    5 +-
 arch/x86/include/asm/mach-generic/mach_mpspec.h  |    4 +-
 arch/x86/include/asm/mpspec_def.h                |  102 ++++----
 arch/x86/include/asm/numaq/mpparse.h             |    3 +-
 arch/x86/include/asm/setup.h                     |   14 +-
 arch/x86/include/asm/summit/mpparse.h            |    2 +-
 arch/x86/kernel/apic.c                           |   14 +-
 arch/x86/kernel/apm_32.c                         |    4 +-
 arch/x86/kernel/cpu/mcheck/mce_32.c              |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c          |    2 +-
 arch/x86/kernel/cpu/mcheck/p5.c                  |    2 +-
 arch/x86/kernel/cpu/mcheck/p6.c                  |    2 +-
 arch/x86/kernel/cpu/mcheck/winchip.c             |    2 +-
 arch/x86/kernel/head_64.S                        |    2 +-
 arch/x86/kernel/i8259.c                          |    8 +-
 arch/x86/kernel/io_apic.c                        |    2 -
 arch/x86/kernel/ioport.c                         |    4 +-
 arch/x86/kernel/irq.c                            |    2 +-
 arch/x86/kernel/irq_32.c                         |   10 +-
 arch/x86/kernel/irq_64.c                         |   22 +-
 arch/x86/kernel/irqinit_32.c                     |   12 +-
 arch/x86/kernel/irqinit_64.c                     |    8 +-
 arch/x86/kernel/mpparse.c                        |  350 +++++++++++-----------
 arch/x86/kernel/nmi.c                            |    1 -
 arch/x86/kernel/numaq_32.c                       |   38 ++--
 arch/x86/kernel/process_32.c                     |   19 +-
 arch/x86/kernel/setup_percpu.c                   |   11 +-
 arch/x86/kernel/smp.c                            |    2 +-
 arch/x86/kernel/smpboot.c                        |    2 +-
 arch/x86/kernel/time_32.c                        |    4 +-
 arch/x86/kernel/time_64.c                        |    2 +-
 arch/x86/kernel/traps.c                          |    3 -
 arch/x86/kernel/visws_quirks.c                   |   32 +-
 arch/x86/mach-generic/es7000.c                   |   10 +-
 arch/x86/mach-generic/numaq.c                    |    3 +-
 arch/x86/mach-generic/probe.c                    |    3 +-
 arch/x86/mm/k8topology_64.c                      |   20 +-
 lib/Kconfig.debug                                |   16 +-
 43 files changed, 363 insertions(+), 399 deletions(-)

diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index fcdc62b..7b4596a 100644
--- a/Documentation/x86/boot.txt
+++ b/Documentation/x86/boot.txt
@@ -44,7 +44,7 @@ Protocol 2.07:	(Kernel 2.6.24) Added paravirtualised boot protocol.
 		and KEEP_SEGMENTS flag in load_flags.
 
 Protocol 2.08:	(Kernel 2.6.26) Added crc32 checksum and ELF format
-		payload. Introduced payload_offset and payload length
+		payload. Introduced payload_offset and payload_length
 		fields to aid in locating the payload.
 
 Protocol 2.09:	(Kernel 2.6.26) Added a field of 64-bit physical
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 862adb9..73f7fe8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -27,6 +27,7 @@ config X86
 	select HAVE_IOREMAP_PROT
 	select HAVE_KPROBES
 	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_WANT_FRAME_POINTERS
 	select HAVE_KRETPROBES
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_DYNAMIC_FTRACE
diff --git a/arch/x86/include/asm/es7000/mpparse.h b/arch/x86/include/asm/es7000/mpparse.h
index ed5a3ca..c1629b0 100644
--- a/arch/x86/include/asm/es7000/mpparse.h
+++ b/arch/x86/include/asm/es7000/mpparse.h
@@ -10,8 +10,7 @@ extern void setup_unisys(void);
 
 #ifndef CONFIG_X86_GENERICARCH
 extern int acpi_madt_oem_check(char *oem_id, char *oem_table_id);
-extern int mps_oem_check(struct mp_config_table *mpc, char *oem,
-				char *productid);
+extern int mps_oem_check(struct mpc_table *mpc, char *oem, char *productid);
 #endif
 
 #ifdef CONFIG_ACPI
diff --git a/arch/x86/include/asm/genapic_32.h b/arch/x86/include/asm/genapic_32.h
index 746f37a..2c05b73 100644
--- a/arch/x86/include/asm/genapic_32.h
+++ b/arch/x86/include/asm/genapic_32.h
@@ -15,9 +15,9 @@
  * Copyright 2003 Andi Kleen, SuSE Labs.
  */
 
-struct mpc_config_bus;
-struct mp_config_table;
-struct mpc_config_processor;
+struct mpc_bus;
+struct mpc_table;
+struct mpc_cpu;
 
 struct genapic {
 	char *name;
@@ -51,7 +51,7 @@ struct genapic {
 	/* When one of the next two hooks returns 1 the genapic
 	   is switched to this. Essentially they are additional probe
 	   functions. */
-	int (*mps_oem_check)(struct mp_config_table *mpc, char *oem,
+	int (*mps_oem_check)(struct mpc_table *mpc, char *oem,
 			     char *productid);
 	int (*acpi_madt_oem_check)(char *oem_id, char *oem_table_id);
 
diff --git a/arch/x86/include/asm/mach-default/mach_mpparse.h b/arch/x86/include/asm/mach-default/mach_mpparse.h
index 8c1ea21..c70a263 100644
--- a/arch/x86/include/asm/mach-default/mach_mpparse.h
+++ b/arch/x86/include/asm/mach-default/mach_mpparse.h
@@ -1,8 +1,8 @@
 #ifndef _ASM_X86_MACH_DEFAULT_MACH_MPPARSE_H
 #define _ASM_X86_MACH_DEFAULT_MACH_MPPARSE_H
 
-static inline int mps_oem_check(struct mp_config_table *mpc, char *oem, 
-		char *productid)
+static inline int
+mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
 {
 	return 0;
 }
diff --git a/arch/x86/include/asm/mach-generic/mach_mpparse.h b/arch/x86/include/asm/mach-generic/mach_mpparse.h
index 048f1d4..9444ab8 100644
--- a/arch/x86/include/asm/mach-generic/mach_mpparse.h
+++ b/arch/x86/include/asm/mach-generic/mach_mpparse.h
@@ -2,9 +2,8 @@
 #define _ASM_X86_MACH_GENERIC_MACH_MPPARSE_H
 
 
-extern int mps_oem_check(struct mp_config_table *mpc, char *oem,
-			 char *productid);
+extern int mps_oem_check(struct mpc_table *, char *, char *);
 
-extern int acpi_madt_oem_check(char *oem_id, char *oem_table_id);
+extern int acpi_madt_oem_check(char *, char *);
 
 #endif /* _ASM_X86_MACH_GENERIC_MACH_MPPARSE_H */
diff --git a/arch/x86/include/asm/mach-generic/mach_mpspec.h b/arch/x86/include/asm/mach-generic/mach_mpspec.h
index bbab5cc..3bc4072 100644
--- a/arch/x86/include/asm/mach-generic/mach_mpspec.h
+++ b/arch/x86/include/asm/mach-generic/mach_mpspec.h
@@ -7,6 +7,6 @@
 /* Maximum 256 PCI busses, plus 1 ISA bus in each of 4 cabinets. */
 #define MAX_MP_BUSSES 260
 
-extern void numaq_mps_oem_check(struct mp_config_table *mpc, char *oem,
-				char *productid);
+extern void numaq_mps_oem_check(struct mpc_table *, char *, char *);
+
 #endif /* _ASM_X86_MACH_GENERIC_MACH_MPSPEC_H */
diff --git a/arch/x86/include/asm/mpspec_def.h b/arch/x86/include/asm/mpspec_def.h
index e3ace7d..59568bc 100644
--- a/arch/x86/include/asm/mpspec_def.h
+++ b/arch/x86/include/asm/mpspec_def.h
@@ -39,17 +39,17 @@ struct intel_mp_floating {
 
 #define MPC_SIGNATURE "PCMP"
 
-struct mp_config_table {
-	char mpc_signature[4];
-	unsigned short mpc_length;	/* Size of table */
-	char mpc_spec;			/* 0x01 */
-	char mpc_checksum;
-	char mpc_oem[8];
-	char mpc_productid[12];
-	unsigned int mpc_oemptr;	/* 0 if not present */
-	unsigned short mpc_oemsize;	/* 0 if not present */
-	unsigned short mpc_oemcount;
-	unsigned int mpc_lapic;	/* APIC address */
+struct mpc_table {
+	char signature[4];
+	unsigned short length;		/* Size of table */
+	char spec;			/* 0x01 */
+	char checksum;
+	char oem[8];
+	char productid[12];
+	unsigned int oemptr;		/* 0 if not present */
+	unsigned short oemsize;		/* 0 if not present */
+	unsigned short oemcount;
+	unsigned int lapic;		/* APIC address */
 	unsigned int reserved;
 };
 
@@ -70,20 +70,20 @@ struct mp_config_table {
 #define CPU_MODEL_MASK		0x00F0
 #define CPU_FAMILY_MASK		0x0F00
 
-struct mpc_config_processor {
-	unsigned char mpc_type;
-	unsigned char mpc_apicid;	/* Local APIC number */
-	unsigned char mpc_apicver;	/* Its versions */
-	unsigned char mpc_cpuflag;
-	unsigned int mpc_cpufeature;
-	unsigned int mpc_featureflag;	/* CPUID feature value */
-	unsigned int mpc_reserved[2];
+struct mpc_cpu {
+	unsigned char type;
+	unsigned char apicid;		/* Local APIC number */
+	unsigned char apicver;		/* Its versions */
+	unsigned char cpuflag;
+	unsigned int cpufeature;
+	unsigned int featureflag;	/* CPUID feature value */
+	unsigned int reserved[2];
 };
 
-struct mpc_config_bus {
-	unsigned char mpc_type;
-	unsigned char mpc_busid;
-	unsigned char mpc_bustype[6];
+struct mpc_bus {
+	unsigned char type;
+	unsigned char busid;
+	unsigned char bustype[6];
 };
 
 /* List of Bus Type string values, Intel MP Spec. */
@@ -108,22 +108,22 @@ struct mpc_config_bus {
 
 #define MPC_APIC_USABLE		0x01
 
-struct mpc_config_ioapic {
-	unsigned char mpc_type;
-	unsigned char mpc_apicid;
-	unsigned char mpc_apicver;
-	unsigned char mpc_flags;
-	unsigned int mpc_apicaddr;
+struct mpc_ioapic {
+	unsigned char type;
+	unsigned char apicid;
+	unsigned char apicver;
+	unsigned char flags;
+	unsigned int apicaddr;
 };
 
-struct mpc_config_intsrc {
-	unsigned char mpc_type;
-	unsigned char mpc_irqtype;
-	unsigned short mpc_irqflag;
-	unsigned char mpc_srcbus;
-	unsigned char mpc_srcbusirq;
-	unsigned char mpc_dstapic;
-	unsigned char mpc_dstirq;
+struct mpc_intsrc {
+	unsigned char type;
+	unsigned char irqtype;
+	unsigned short irqflag;
+	unsigned char srcbus;
+	unsigned char srcbusirq;
+	unsigned char dstapic;
+	unsigned char dstirq;
 };
 
 enum mp_irq_source_types {
@@ -139,24 +139,24 @@ enum mp_irq_source_types {
 
 #define MP_APIC_ALL	0xFF
 
-struct mpc_config_lintsrc {
-	unsigned char mpc_type;
-	unsigned char mpc_irqtype;
-	unsigned short mpc_irqflag;
-	unsigned char mpc_srcbusid;
-	unsigned char mpc_srcbusirq;
-	unsigned char mpc_destapic;
-	unsigned char mpc_destapiclint;
+struct mpc_lintsrc {
+	unsigned char type;
+	unsigned char irqtype;
+	unsigned short irqflag;
+	unsigned char srcbusid;
+	unsigned char srcbusirq;
+	unsigned char destapic;
+	unsigned char destapiclint;
 };
 
 #define MPC_OEM_SIGNATURE "_OEM"
 
-struct mp_config_oemtable {
-	char oem_signature[4];
-	unsigned short oem_length;	/* Size of table */
-	char  oem_rev;			/* 0x01 */
-	char  oem_checksum;
-	char  mpc_oem[8];
+struct mpc_oemtable {
+	char signature[4];
+	unsigned short length;		/* Size of table */
+	char  rev;			/* 0x01 */
+	char  checksum;
+	char  mpc[8];
 };
 
 /*
diff --git a/arch/x86/include/asm/numaq/mpparse.h b/arch/x86/include/asm/numaq/mpparse.h
index 252292e..a2eeefc 100644
--- a/arch/x86/include/asm/numaq/mpparse.h
+++ b/arch/x86/include/asm/numaq/mpparse.h
@@ -1,7 +1,6 @@
 #ifndef __ASM_NUMAQ_MPPARSE_H
 #define __ASM_NUMAQ_MPPARSE_H
 
-extern void numaq_mps_oem_check(struct mp_config_table *mpc, char *oem,
-				char *productid);
+extern void numaq_mps_oem_check(struct mpc_table *, char *, char *);
 
 #endif /* __ASM_NUMAQ_MPPARSE_H */
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 4fcd53f..ebe858c 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -25,9 +25,9 @@ extern int wakeup_secondary_cpu_via_init(int apicid, unsigned long start_eip);
 /*
  * Any setup quirks to be performed?
  */
-struct mpc_config_processor;
-struct mpc_config_bus;
-struct mp_config_oemtable;
+struct mpc_cpu;
+struct mpc_bus;
+struct mpc_oemtable;
 struct x86_quirks {
 	int (*arch_pre_time_init)(void);
 	int (*arch_time_init)(void);
@@ -39,10 +39,10 @@ struct x86_quirks {
 	int (*mach_find_smp_config)(unsigned int reserve);
 
 	int *mpc_record;
-	int (*mpc_apic_id)(struct mpc_config_processor *m);
-	void (*mpc_oem_bus_info)(struct mpc_config_bus *m, char *name);
-	void (*mpc_oem_pci_bus)(struct mpc_config_bus *m);
-	void (*smp_read_mpc_oem)(struct mp_config_oemtable *oemtable,
+	int (*mpc_apic_id)(struct mpc_cpu *m);
+	void (*mpc_oem_bus_info)(struct mpc_bus *m, char *name);
+	void (*mpc_oem_pci_bus)(struct mpc_bus *m);
+	void (*smp_read_mpc_oem)(struct mpc_oemtable *oemtable,
                                     unsigned short oemsize);
 	int (*setup_ioapic_ids)(void);
 	int (*update_genapic)(void);
diff --git a/arch/x86/include/asm/summit/mpparse.h b/arch/x86/include/asm/summit/mpparse.h
index 013ce6f..380e86c 100644
--- a/arch/x86/include/asm/summit/mpparse.h
+++ b/arch/x86/include/asm/summit/mpparse.h
@@ -11,7 +11,7 @@ extern void setup_summit(void);
 #define setup_summit()	{}
 #endif
 
-static inline int mps_oem_check(struct mp_config_table *mpc, char *oem,
+static inline int mps_oem_check(struct mpc_table *mpc, char *oem,
 		char *productid)
 {
 	if (!strncmp(oem, "IBM ENSW", 8) &&
diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index b13d3c4..566a084 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -31,9 +31,11 @@
 #include <linux/dmi.h>
 #include <linux/dmar.h>
 #include <linux/ftrace.h>
+#include <linux/smp.h>
+#include <linux/nmi.h>
+#include <linux/timex.h>
 
 #include <asm/atomic.h>
-#include <asm/smp.h>
 #include <asm/mtrr.h>
 #include <asm/mpspec.h>
 #include <asm/desc.h>
@@ -41,10 +43,8 @@
 #include <asm/hpet.h>
 #include <asm/pgalloc.h>
 #include <asm/i8253.h>
-#include <asm/nmi.h>
 #include <asm/idle.h>
 #include <asm/proto.h>
-#include <asm/timex.h>
 #include <asm/apic.h>
 #include <asm/i8259.h>
 
@@ -687,7 +687,7 @@ static int __init calibrate_APIC_clock(void)
 		local_irq_enable();
 
 	if (levt->features & CLOCK_EVT_FEAT_DUMMY) {
-		pr_warning("APIC timer disabled due to verification failure.\n");
+		pr_warning("APIC timer disabled due to verification failure\n");
 			return -1;
 	}
 
@@ -2087,14 +2087,12 @@ __cpuinit int apic_is_clustered_box(void)
 		/* are we being called early in kernel startup? */
 		if (bios_cpu_apicid) {
 			id = bios_cpu_apicid[i];
-		}
-		else if (i < nr_cpu_ids) {
+		} else if (i < nr_cpu_ids) {
 			if (cpu_present(i))
 				id = per_cpu(x86_bios_cpu_apicid, i);
 			else
 				continue;
-		}
-		else
+		} else
 			break;
 
 		if (id != BAD_APICID)
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 3a26525..98807bb 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -160,9 +160,9 @@
  *         Work around byte swap bug in one of the Vaio's BIOS's
  *         (Marc Boucher <marc@mbsi.ca>).
  *         Exposed the disable flag to dmi so that we can handle known
- *         broken APM (Alan Cox <alan@redhat.com>).
+ *         broken APM (Alan Cox <alan@lxorguk.ukuu.org.uk>).
  *   1.14ac: If the BIOS says "I slowed the CPU down" then don't spin
- *         calling it - instead idle. (Alan Cox <alan@redhat.com>)
+ *         calling it - instead idle. (Alan Cox <alan@lxorguk.ukuu.org.uk>)
  *         If an APM idle fails log it and idle sensibly
  *   1.15: Don't queue events to clients who open the device O_WRONLY.
  *         Don't expect replies from clients who open the device O_RDONLY.
diff --git a/arch/x86/kernel/cpu/mcheck/mce_32.c b/arch/x86/kernel/cpu/mcheck/mce_32.c
index 0ebf3fc..dfaebce 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_32.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_32.c
@@ -1,6 +1,6 @@
 /*
  * mce.c - x86 Machine Check Exception Reporting
- * (c) 2002 Alan Cox <alan@redhat.com>, Dave Jones <davej@redhat.com>
+ * (c) 2002 Alan Cox <alan@lxorguk.ukuu.org.uk>, Dave Jones <davej@redhat.com>
  */
 
 #include <linux/init.h>
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
index a5a5e05..8ae8c4f 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -462,7 +462,7 @@ out_free:
 	return err;
 }
 
-static long local_allocate_threshold_blocks(void *_bank)
+static __cpuinit long local_allocate_threshold_blocks(void *_bank)
 {
 	unsigned int *bank = _bank;
 
diff --git a/arch/x86/kernel/cpu/mcheck/p5.c b/arch/x86/kernel/cpu/mcheck/p5.c
index bfa5817..c9f77ea 100644
--- a/arch/x86/kernel/cpu/mcheck/p5.c
+++ b/arch/x86/kernel/cpu/mcheck/p5.c
@@ -1,6 +1,6 @@
 /*
  * P5 specific Machine Check Exception Reporting
- * (C) Copyright 2002 Alan Cox <alan@redhat.com>
+ * (C) Copyright 2002 Alan Cox <alan@lxorguk.ukuu.org.uk>
  */
 
 #include <linux/init.h>
diff --git a/arch/x86/kernel/cpu/mcheck/p6.c b/arch/x86/kernel/cpu/mcheck/p6.c
index 62efc9c..2ac52d7 100644
--- a/arch/x86/kernel/cpu/mcheck/p6.c
+++ b/arch/x86/kernel/cpu/mcheck/p6.c
@@ -1,6 +1,6 @@
 /*
  * P6 specific Machine Check Exception Reporting
- * (C) Copyright 2002 Alan Cox <alan@redhat.com>
+ * (C) Copyright 2002 Alan Cox <alan@lxorguk.ukuu.org.uk>
  */
 
 #include <linux/init.h>
diff --git a/arch/x86/kernel/cpu/mcheck/winchip.c b/arch/x86/kernel/cpu/mcheck/winchip.c
index f2be3e1..2a043d8 100644
--- a/arch/x86/kernel/cpu/mcheck/winchip.c
+++ b/arch/x86/kernel/cpu/mcheck/winchip.c
@@ -1,6 +1,6 @@
 /*
  * IDT Winchip specific Machine Check Exception Reporting
- * (C) Copyright 2002 Alan Cox <alan@redhat.com>
+ * (C) Copyright 2002 Alan Cox <alan@lxorguk.ukuu.org.uk>
  */
 
 #include <linux/init.h>
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 26cfdc1..0e275d4 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -305,7 +305,7 @@ ENTRY(early_idt_handler)
 	call dump_stack
 #ifdef CONFIG_KALLSYMS	
 	leaq early_idt_ripmsg(%rip),%rdi
-	movq 8(%rsp),%rsi	# get rip again
+	movq 0(%rsp),%rsi	# get rip again
 	call __print_symbol
 #endif
 #endif /* EARLY_PRINTK */
diff --git a/arch/x86/kernel/i8259.c b/arch/x86/kernel/i8259.c
index 4b8a53d..11d5093 100644
--- a/arch/x86/kernel/i8259.c
+++ b/arch/x86/kernel/i8259.c
@@ -11,15 +11,15 @@
 #include <linux/kernel_stat.h>
 #include <linux/sysdev.h>
 #include <linux/bitops.h>
+#include <linux/acpi.h>
+#include <linux/io.h>
+#include <linux/delay.h>
 
-#include <asm/acpi.h>
 #include <asm/atomic.h>
 #include <asm/system.h>
-#include <asm/io.h>
 #include <asm/timer.h>
 #include <asm/hw_irq.h>
 #include <asm/pgtable.h>
-#include <asm/delay.h>
 #include <asm/desc.h>
 #include <asm/apic.h>
 #include <asm/arch_hooks.h>
@@ -323,7 +323,7 @@ void init_8259A(int auto_eoi)
 	outb_pic(0x11, PIC_MASTER_CMD);	/* ICW1: select 8259A-1 init */
 
 	/* ICW2: 8259A-1 IR0-7 mapped to 0x30-0x37 on x86-64,
-	                       to 0x20-0x27 on i386 */
+	   to 0x20-0x27 on i386 */
 	outb_pic(IRQ0_VECTOR, PIC_MASTER_IMR);
 
 	/* 8259A-1 (the master) has a slave on IR2 */
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 3639442..1c4a130 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -129,7 +129,6 @@ static struct irq_pin_list *get_one_free_irq_2_pin(int cpu)
 	node = cpu_to_node(cpu);
 
 	pin = kzalloc_node(sizeof(*pin), GFP_ATOMIC, node);
-	printk(KERN_DEBUG "  alloc irq_2_pin on cpu %d node %d\n", cpu, node);
 
 	return pin;
 }
@@ -227,7 +226,6 @@ static struct irq_cfg *get_one_free_irq_cfg(int cpu)
 			cpumask_clear(cfg->old_domain);
 		}
 	}
-	printk(KERN_DEBUG "  alloc irq_cfg on cpu %d node %d\n", cpu, node);
 
 	return cfg;
 }
diff --git a/arch/x86/kernel/ioport.c b/arch/x86/kernel/ioport.c
index 1919143..b12208f 100644
--- a/arch/x86/kernel/ioport.c
+++ b/arch/x86/kernel/ioport.c
@@ -35,8 +35,8 @@ static void set_bitmap(unsigned long *bitmap, unsigned int base,
  */
 asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on)
 {
-	struct thread_struct * t = &current->thread;
-	struct tss_struct * tss;
+	struct thread_struct *t = &current->thread;
+	struct tss_struct *tss;
 	unsigned int i, max_long, bytes, bytes_updated;
 
 	if ((from + num <= from) || (from + num > IO_BITMAP_BITS))
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index bce53e1..3973e2d 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -5,10 +5,10 @@
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
 #include <linux/seq_file.h>
+#include <linux/smp.h>
 
 #include <asm/apic.h>
 #include <asm/io_apic.h>
-#include <asm/smp.h>
 #include <asm/irq.h>
 
 atomic_t irq_err_count;
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 9dc5588..74b9ff7 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -15,9 +15,9 @@
 #include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <linux/delay.h>
+#include <linux/uaccess.h>
 
 #include <asm/apic.h>
-#include <asm/uaccess.h>
 
 DEFINE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
 EXPORT_PER_CPU_SYMBOL(irq_stat);
@@ -93,7 +93,7 @@ execute_on_irq_stack(int overflow, struct irq_desc *desc, int irq)
 		return 0;
 
 	/* build the stack frame on the IRQ stack */
-	isp = (u32 *) ((char*)irqctx + sizeof(*irqctx));
+	isp = (u32 *) ((char *)irqctx + sizeof(*irqctx));
 	irqctx->tinfo.task = curctx->tinfo.task;
 	irqctx->tinfo.previous_esp = current_stack_pointer;
 
@@ -137,7 +137,7 @@ void __cpuinit irq_ctx_init(int cpu)
 
 	hardirq_ctx[cpu] = irqctx;
 
-	irqctx = (union irq_ctx*) &softirq_stack[cpu*THREAD_SIZE];
+	irqctx = (union irq_ctx *) &softirq_stack[cpu*THREAD_SIZE];
 	irqctx->tinfo.task		= NULL;
 	irqctx->tinfo.exec_domain	= NULL;
 	irqctx->tinfo.cpu		= cpu;
@@ -147,7 +147,7 @@ void __cpuinit irq_ctx_init(int cpu)
 	softirq_ctx[cpu] = irqctx;
 
 	printk(KERN_DEBUG "CPU %u irqstacks, hard=%p soft=%p\n",
-	       cpu,hardirq_ctx[cpu],softirq_ctx[cpu]);
+	       cpu, hardirq_ctx[cpu], softirq_ctx[cpu]);
 }
 
 void irq_ctx_exit(int cpu)
@@ -174,7 +174,7 @@ asmlinkage void do_softirq(void)
 		irqctx->tinfo.previous_esp = current_stack_pointer;
 
 		/* build the stack frame on the softirq stack */
-		isp = (u32*) ((char*)irqctx + sizeof(*irqctx));
+		isp = (u32 *) ((char *)irqctx + sizeof(*irqctx));
 
 		call_on_stack(__do_softirq, isp);
 		/*
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index 6383d50..63c88e6 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -14,10 +14,10 @@
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/ftrace.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
+#include <linux/smp.h>
 #include <asm/io_apic.h>
 #include <asm/idle.h>
-#include <asm/smp.h>
 
 /*
  * Probabilistic stack overflow check:
@@ -142,18 +142,18 @@ extern void call_softirq(void);
 
 asmlinkage void do_softirq(void)
 {
- 	__u32 pending;
- 	unsigned long flags;
+	__u32 pending;
+	unsigned long flags;
 
- 	if (in_interrupt())
- 		return;
+	if (in_interrupt())
+		return;
 
- 	local_irq_save(flags);
- 	pending = local_softirq_pending();
- 	/* Switch to interrupt stack */
- 	if (pending) {
+	local_irq_save(flags);
+	pending = local_softirq_pending();
+	/* Switch to interrupt stack */
+	if (pending) {
 		call_softirq();
 		WARN_ON_ONCE(softirq_count());
 	}
- 	local_irq_restore(flags);
+	local_irq_restore(flags);
 }
diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
index 8472329..1507ad4 100644
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit_32.c
@@ -9,18 +9,18 @@
 #include <linux/kernel_stat.h>
 #include <linux/sysdev.h>
 #include <linux/bitops.h>
+#include <linux/io.h>
+#include <linux/delay.h>
 
 #include <asm/atomic.h>
 #include <asm/system.h>
-#include <asm/io.h>
 #include <asm/timer.h>
 #include <asm/pgtable.h>
-#include <asm/delay.h>
 #include <asm/desc.h>
 #include <asm/apic.h>
 #include <asm/arch_hooks.h>
 #include <asm/i8259.h>
-
+#include <asm/traps.h>
 
 
 /*
@@ -34,12 +34,10 @@
  * leads to races. IBM designers who came up with it should
  * be shot.
  */
- 
 
 static irqreturn_t math_error_irq(int cpl, void *dev_id)
 {
-	extern void math_error(void __user *);
-	outb(0,0xF0);
+	outb(0, 0xF0);
 	if (ignore_fpu_irq || !boot_cpu_data.hard_math)
 		return IRQ_NONE;
 	math_error((void __user *)get_irq_regs()->ip);
@@ -56,7 +54,7 @@ static struct irqaction fpu_irq = {
 	.name = "fpu",
 };
 
-void __init init_ISA_irqs (void)
+void __init init_ISA_irqs(void)
 {
 	int i;
 
diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
index 31ebfe3..da481a1 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -11,14 +11,14 @@
 #include <linux/kernel_stat.h>
 #include <linux/sysdev.h>
 #include <linux/bitops.h>
+#include <linux/acpi.h>
+#include <linux/io.h>
+#include <linux/delay.h>
 
-#include <asm/acpi.h>
 #include <asm/atomic.h>
 #include <asm/system.h>
-#include <asm/io.h>
 #include <asm/hw_irq.h>
 #include <asm/pgtable.h>
-#include <asm/delay.h>
 #include <asm/desc.h>
 #include <asm/apic.h>
 #include <asm/i8259.h>
@@ -81,7 +81,7 @@ int vector_used_by_percpu_irq(unsigned int vector)
 	return 0;
 }
 
-void __init init_ISA_irqs(void)
+static void __init init_ISA_irqs(void)
 {
 	int i;
 
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index c5c5b8d..c0601c2 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -2,7 +2,7 @@
  *	Intel Multiprocessor Specification 1.1 and 1.4
  *	compliant MP-table parsing routines.
  *
- *	(c) 1995 Alan Cox, Building #3 <alan@redhat.com>
+ *	(c) 1995 Alan Cox, Building #3 <alan@lxorguk.ukuu.org.uk>
  *	(c) 1998, 1999, 2000 Ingo Molnar <mingo@redhat.com>
  *      (c) 2008 Alexey Starikovskiy <astarikovskiy@suse.de>
  */
@@ -17,7 +17,6 @@
 #include <linux/acpi.h>
 #include <linux/module.h>
 #include <linux/smp.h>
-#include <linux/acpi.h>
 
 #include <asm/mtrr.h>
 #include <asm/mpspec.h>
@@ -49,12 +48,12 @@ static int __init mpf_checksum(unsigned char *mp, int len)
 	return sum & 0xFF;
 }
 
-static void __init MP_processor_info(struct mpc_config_processor *m)
+static void __init MP_processor_info(struct mpc_cpu *m)
 {
 	int apicid;
 	char *bootup_cpu = "";
 
-	if (!(m->mpc_cpuflag & CPU_ENABLED)) {
+	if (!(m->cpuflag & CPU_ENABLED)) {
 		disabled_cpus++;
 		return;
 	}
@@ -62,54 +61,54 @@ static void __init MP_processor_info(struct mpc_config_processor *m)
 	if (x86_quirks->mpc_apic_id)
 		apicid = x86_quirks->mpc_apic_id(m);
 	else
-		apicid = m->mpc_apicid;
+		apicid = m->apicid;
 
-	if (m->mpc_cpuflag & CPU_BOOTPROCESSOR) {
+	if (m->cpuflag & CPU_BOOTPROCESSOR) {
 		bootup_cpu = " (Bootup-CPU)";
-		boot_cpu_physical_apicid = m->mpc_apicid;
+		boot_cpu_physical_apicid = m->apicid;
 	}
 
-	printk(KERN_INFO "Processor #%d%s\n", m->mpc_apicid, bootup_cpu);
-	generic_processor_info(apicid, m->mpc_apicver);
+	printk(KERN_INFO "Processor #%d%s\n", m->apicid, bootup_cpu);
+	generic_processor_info(apicid, m->apicver);
 }
 
 #ifdef CONFIG_X86_IO_APIC
-static void __init MP_bus_info(struct mpc_config_bus *m)
+static void __init MP_bus_info(struct mpc_bus *m)
 {
 	char str[7];
-	memcpy(str, m->mpc_bustype, 6);
+	memcpy(str, m->bustype, 6);
 	str[6] = 0;
 
 	if (x86_quirks->mpc_oem_bus_info)
 		x86_quirks->mpc_oem_bus_info(m, str);
 	else
-		apic_printk(APIC_VERBOSE, "Bus #%d is %s\n", m->mpc_busid, str);
+		apic_printk(APIC_VERBOSE, "Bus #%d is %s\n", m->busid, str);
 
 #if MAX_MP_BUSSES < 256
-	if (m->mpc_busid >= MAX_MP_BUSSES) {
+	if (m->busid >= MAX_MP_BUSSES) {
 		printk(KERN_WARNING "MP table busid value (%d) for bustype %s "
 		       " is too large, max. supported is %d\n",
-		       m->mpc_busid, str, MAX_MP_BUSSES - 1);
+		       m->busid, str, MAX_MP_BUSSES - 1);
 		return;
 	}
 #endif
 
 	if (strncmp(str, BUSTYPE_ISA, sizeof(BUSTYPE_ISA) - 1) == 0) {
-		set_bit(m->mpc_busid, mp_bus_not_pci);
+		set_bit(m->busid, mp_bus_not_pci);
 #if defined(CONFIG_EISA) || defined(CONFIG_MCA)
-		mp_bus_id_to_type[m->mpc_busid] = MP_BUS_ISA;
+		mp_bus_id_to_type[m->busid] = MP_BUS_ISA;
 #endif
 	} else if (strncmp(str, BUSTYPE_PCI, sizeof(BUSTYPE_PCI) - 1) == 0) {
 		if (x86_quirks->mpc_oem_pci_bus)
 			x86_quirks->mpc_oem_pci_bus(m);
 
-		clear_bit(m->mpc_busid, mp_bus_not_pci);
+		clear_bit(m->busid, mp_bus_not_pci);
 #if defined(CONFIG_EISA) || defined(CONFIG_MCA)
-		mp_bus_id_to_type[m->mpc_busid] = MP_BUS_PCI;
+		mp_bus_id_to_type[m->busid] = MP_BUS_PCI;
 	} else if (strncmp(str, BUSTYPE_EISA, sizeof(BUSTYPE_EISA) - 1) == 0) {
-		mp_bus_id_to_type[m->mpc_busid] = MP_BUS_EISA;
+		mp_bus_id_to_type[m->busid] = MP_BUS_EISA;
 	} else if (strncmp(str, BUSTYPE_MCA, sizeof(BUSTYPE_MCA) - 1) == 0) {
-		mp_bus_id_to_type[m->mpc_busid] = MP_BUS_MCA;
+		mp_bus_id_to_type[m->busid] = MP_BUS_MCA;
 #endif
 	} else
 		printk(KERN_WARNING "Unknown bustype %s - ignoring\n", str);
@@ -133,32 +132,31 @@ static int bad_ioapic(unsigned long address)
 	return 0;
 }
 
-static void __init MP_ioapic_info(struct mpc_config_ioapic *m)
+static void __init MP_ioapic_info(struct mpc_ioapic *m)
 {
-	if (!(m->mpc_flags & MPC_APIC_USABLE))
+	if (!(m->flags & MPC_APIC_USABLE))
 		return;
 
 	printk(KERN_INFO "I/O APIC #%d Version %d at 0x%X.\n",
-	       m->mpc_apicid, m->mpc_apicver, m->mpc_apicaddr);
+	       m->apicid, m->apicver, m->apicaddr);
 
-	if (bad_ioapic(m->mpc_apicaddr))
+	if (bad_ioapic(m->apicaddr))
 		return;
 
-	mp_ioapics[nr_ioapics].mp_apicaddr = m->mpc_apicaddr;
-	mp_ioapics[nr_ioapics].mp_apicid = m->mpc_apicid;
-	mp_ioapics[nr_ioapics].mp_type = m->mpc_type;
-	mp_ioapics[nr_ioapics].mp_apicver = m->mpc_apicver;
-	mp_ioapics[nr_ioapics].mp_flags = m->mpc_flags;
+	mp_ioapics[nr_ioapics].mp_apicaddr = m->apicaddr;
+	mp_ioapics[nr_ioapics].mp_apicid = m->apicid;
+	mp_ioapics[nr_ioapics].mp_type = m->type;
+	mp_ioapics[nr_ioapics].mp_apicver = m->apicver;
+	mp_ioapics[nr_ioapics].mp_flags = m->flags;
 	nr_ioapics++;
 }
 
-static void print_MP_intsrc_info(struct mpc_config_intsrc *m)
+static void print_MP_intsrc_info(struct mpc_intsrc *m)
 {
 	apic_printk(APIC_VERBOSE, "Int: type %d, pol %d, trig %d, bus %02x,"
 		" IRQ %02x, APIC ID %x, APIC INT %02x\n",
-		m->mpc_irqtype, m->mpc_irqflag & 3,
-		(m->mpc_irqflag >> 2) & 3, m->mpc_srcbus,
-		m->mpc_srcbusirq, m->mpc_dstapic, m->mpc_dstirq);
+		m->irqtype, m->irqflag & 3, (m->irqflag >> 2) & 3, m->srcbus,
+		m->srcbusirq, m->dstapic, m->dstirq);
 }
 
 static void __init print_mp_irq_info(struct mp_config_intsrc *mp_irq)
@@ -170,52 +168,52 @@ static void __init print_mp_irq_info(struct mp_config_intsrc *mp_irq)
 		mp_irq->mp_srcbusirq, mp_irq->mp_dstapic, mp_irq->mp_dstirq);
 }
 
-static void __init assign_to_mp_irq(struct mpc_config_intsrc *m,
+static void __init assign_to_mp_irq(struct mpc_intsrc *m,
 				    struct mp_config_intsrc *mp_irq)
 {
-	mp_irq->mp_dstapic = m->mpc_dstapic;
-	mp_irq->mp_type = m->mpc_type;
-	mp_irq->mp_irqtype = m->mpc_irqtype;
-	mp_irq->mp_irqflag = m->mpc_irqflag;
-	mp_irq->mp_srcbus = m->mpc_srcbus;
-	mp_irq->mp_srcbusirq = m->mpc_srcbusirq;
-	mp_irq->mp_dstirq = m->mpc_dstirq;
+	mp_irq->mp_dstapic = m->dstapic;
+	mp_irq->mp_type = m->type;
+	mp_irq->mp_irqtype = m->irqtype;
+	mp_irq->mp_irqflag = m->irqflag;
+	mp_irq->mp_srcbus = m->srcbus;
+	mp_irq->mp_srcbusirq = m->srcbusirq;
+	mp_irq->mp_dstirq = m->dstirq;
 }
 
 static void __init assign_to_mpc_intsrc(struct mp_config_intsrc *mp_irq,
-					struct mpc_config_intsrc *m)
+					struct mpc_intsrc *m)
 {
-	m->mpc_dstapic = mp_irq->mp_dstapic;
-	m->mpc_type = mp_irq->mp_type;
-	m->mpc_irqtype = mp_irq->mp_irqtype;
-	m->mpc_irqflag = mp_irq->mp_irqflag;
-	m->mpc_srcbus = mp_irq->mp_srcbus;
-	m->mpc_srcbusirq = mp_irq->mp_srcbusirq;
-	m->mpc_dstirq = mp_irq->mp_dstirq;
+	m->dstapic = mp_irq->mp_dstapic;
+	m->type = mp_irq->mp_type;
+	m->irqtype = mp_irq->mp_irqtype;
+	m->irqflag = mp_irq->mp_irqflag;
+	m->srcbus = mp_irq->mp_srcbus;
+	m->srcbusirq = mp_irq->mp_srcbusirq;
+	m->dstirq = mp_irq->mp_dstirq;
 }
 
 static int __init mp_irq_mpc_intsrc_cmp(struct mp_config_intsrc *mp_irq,
-					struct mpc_config_intsrc *m)
+					struct mpc_intsrc *m)
 {
-	if (mp_irq->mp_dstapic != m->mpc_dstapic)
+	if (mp_irq->mp_dstapic != m->dstapic)
 		return 1;
-	if (mp_irq->mp_type != m->mpc_type)
+	if (mp_irq->mp_type != m->type)
 		return 2;
-	if (mp_irq->mp_irqtype != m->mpc_irqtype)
+	if (mp_irq->mp_irqtype != m->irqtype)
 		return 3;
-	if (mp_irq->mp_irqflag != m->mpc_irqflag)
+	if (mp_irq->mp_irqflag != m->irqflag)
 		return 4;
-	if (mp_irq->mp_srcbus != m->mpc_srcbus)
+	if (mp_irq->mp_srcbus != m->srcbus)
 		return 5;
-	if (mp_irq->mp_srcbusirq != m->mpc_srcbusirq)
+	if (mp_irq->mp_srcbusirq != m->srcbusirq)
 		return 6;
-	if (mp_irq->mp_dstirq != m->mpc_dstirq)
+	if (mp_irq->mp_dstirq != m->dstirq)
 		return 7;
 
 	return 0;
 }
 
-static void __init MP_intsrc_info(struct mpc_config_intsrc *m)
+static void __init MP_intsrc_info(struct mpc_intsrc *m)
 {
 	int i;
 
@@ -233,57 +231,55 @@ static void __init MP_intsrc_info(struct mpc_config_intsrc *m)
 
 #endif
 
-static void __init MP_lintsrc_info(struct mpc_config_lintsrc *m)
+static void __init MP_lintsrc_info(struct mpc_lintsrc *m)
 {
 	apic_printk(APIC_VERBOSE, "Lint: type %d, pol %d, trig %d, bus %02x,"
 		" IRQ %02x, APIC ID %x, APIC LINT %02x\n",
-		m->mpc_irqtype, m->mpc_irqflag & 3,
-		(m->mpc_irqflag >> 2) & 3, m->mpc_srcbusid,
-		m->mpc_srcbusirq, m->mpc_destapic, m->mpc_destapiclint);
+		m->irqtype, m->irqflag & 3, (m->irqflag >> 2) & 3, m->srcbusid,
+		m->srcbusirq, m->destapic, m->destapiclint);
 }
 
 /*
  * Read/parse the MPC
  */
 
-static int __init smp_check_mpc(struct mp_config_table *mpc, char *oem,
-				char *str)
+static int __init smp_check_mpc(struct mpc_table *mpc, char *oem, char *str)
 {
 
-	if (memcmp(mpc->mpc_signature, MPC_SIGNATURE, 4)) {
+	if (memcmp(mpc->signature, MPC_SIGNATURE, 4)) {
 		printk(KERN_ERR "MPTABLE: bad signature [%c%c%c%c]!\n",
-		       mpc->mpc_signature[0], mpc->mpc_signature[1],
-		       mpc->mpc_signature[2], mpc->mpc_signature[3]);
+		       mpc->signature[0], mpc->signature[1],
+		       mpc->signature[2], mpc->signature[3]);
 		return 0;
 	}
-	if (mpf_checksum((unsigned char *)mpc, mpc->mpc_length)) {
+	if (mpf_checksum((unsigned char *)mpc, mpc->length)) {
 		printk(KERN_ERR "MPTABLE: checksum error!\n");
 		return 0;
 	}
-	if (mpc->mpc_spec != 0x01 && mpc->mpc_spec != 0x04) {
+	if (mpc->spec != 0x01 && mpc->spec != 0x04) {
 		printk(KERN_ERR "MPTABLE: bad table version (%d)!!\n",
-		       mpc->mpc_spec);
+		       mpc->spec);
 		return 0;
 	}
-	if (!mpc->mpc_lapic) {
+	if (!mpc->lapic) {
 		printk(KERN_ERR "MPTABLE: null local APIC address!\n");
 		return 0;
 	}
-	memcpy(oem, mpc->mpc_oem, 8);
+	memcpy(oem, mpc->oem, 8);
 	oem[8] = 0;
 	printk(KERN_INFO "MPTABLE: OEM ID: %s\n", oem);
 
-	memcpy(str, mpc->mpc_productid, 12);
+	memcpy(str, mpc->productid, 12);
 	str[12] = 0;
 
 	printk(KERN_INFO "MPTABLE: Product ID: %s\n", str);
 
-	printk(KERN_INFO "MPTABLE: APIC at: 0x%X\n", mpc->mpc_lapic);
+	printk(KERN_INFO "MPTABLE: APIC at: 0x%X\n", mpc->lapic);
 
 	return 1;
 }
 
-static int __init smp_read_mpc(struct mp_config_table *mpc, unsigned early)
+static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 {
 	char str[16];
 	char oem[10];
@@ -308,14 +304,14 @@ static int __init smp_read_mpc(struct mp_config_table *mpc, unsigned early)
 #endif
 	/* save the local APIC address, it might be non-default */
 	if (!acpi_lapic)
-		mp_lapic_addr = mpc->mpc_lapic;
+		mp_lapic_addr = mpc->lapic;
 
 	if (early)
 		return 1;
 
-	if (mpc->mpc_oemptr && x86_quirks->smp_read_mpc_oem) {
-		struct mp_config_oemtable *oem_table = (struct mp_config_oemtable *)(unsigned long)mpc->mpc_oemptr;
-		x86_quirks->smp_read_mpc_oem(oem_table, mpc->mpc_oemsize);
+	if (mpc->oemptr && x86_quirks->smp_read_mpc_oem) {
+		struct mpc_oemtable *oem_table = (void *)(long)mpc->oemptr;
+		x86_quirks->smp_read_mpc_oem(oem_table, mpc->oemsize);
 	}
 
 	/*
@@ -324,12 +320,11 @@ static int __init smp_read_mpc(struct mp_config_table *mpc, unsigned early)
 	if (x86_quirks->mpc_record)
 		*x86_quirks->mpc_record = 0;
 
-	while (count < mpc->mpc_length) {
+	while (count < mpc->length) {
 		switch (*mpt) {
 		case MP_PROCESSOR:
 			{
-				struct mpc_config_processor *m =
-				    (struct mpc_config_processor *)mpt;
+				struct mpc_cpu *m = (struct mpc_cpu *)mpt;
 				/* ACPI may have already provided this data */
 				if (!acpi_lapic)
 					MP_processor_info(m);
@@ -339,8 +334,7 @@ static int __init smp_read_mpc(struct mp_config_table *mpc, unsigned early)
 			}
 		case MP_BUS:
 			{
-				struct mpc_config_bus *m =
-				    (struct mpc_config_bus *)mpt;
+				struct mpc_bus *m = (struct mpc_bus *)mpt;
 #ifdef CONFIG_X86_IO_APIC
 				MP_bus_info(m);
 #endif
@@ -351,30 +345,28 @@ static int __init smp_read_mpc(struct mp_config_table *mpc, unsigned early)
 		case MP_IOAPIC:
 			{
 #ifdef CONFIG_X86_IO_APIC
-				struct mpc_config_ioapic *m =
-				    (struct mpc_config_ioapic *)mpt;
+				struct mpc_ioapic *m = (struct mpc_ioapic *)mpt;
 				MP_ioapic_info(m);
 #endif
-				mpt += sizeof(struct mpc_config_ioapic);
-				count += sizeof(struct mpc_config_ioapic);
+				mpt += sizeof(struct mpc_ioapic);
+				count += sizeof(struct mpc_ioapic);
 				break;
 			}
 		case MP_INTSRC:
 			{
 #ifdef CONFIG_X86_IO_APIC
-				struct mpc_config_intsrc *m =
-				    (struct mpc_config_intsrc *)mpt;
+				struct mpc_intsrc *m = (struct mpc_intsrc *)mpt;
 
 				MP_intsrc_info(m);
 #endif
-				mpt += sizeof(struct mpc_config_intsrc);
-				count += sizeof(struct mpc_config_intsrc);
+				mpt += sizeof(struct mpc_intsrc);
+				count += sizeof(struct mpc_intsrc);
 				break;
 			}
 		case MP_LINTSRC:
 			{
-				struct mpc_config_lintsrc *m =
-				    (struct mpc_config_lintsrc *)mpt;
+				struct mpc_lintsrc *m =
+				    (struct mpc_lintsrc *)mpt;
 				MP_lintsrc_info(m);
 				mpt += sizeof(*m);
 				count += sizeof(*m);
@@ -385,8 +377,8 @@ static int __init smp_read_mpc(struct mp_config_table *mpc, unsigned early)
 			printk(KERN_ERR "Your mptable is wrong, contact your HW vendor!\n");
 			printk(KERN_ERR "type %x\n", *mpt);
 			print_hex_dump(KERN_ERR, "  ", DUMP_PREFIX_ADDRESS, 16,
-					1, mpc, mpc->mpc_length, 1);
-			count = mpc->mpc_length;
+					1, mpc, mpc->length, 1);
+			count = mpc->length;
 			break;
 		}
 		if (x86_quirks->mpc_record)
@@ -417,16 +409,16 @@ static int __init ELCR_trigger(unsigned int irq)
 
 static void __init construct_default_ioirq_mptable(int mpc_default_type)
 {
-	struct mpc_config_intsrc intsrc;
+	struct mpc_intsrc intsrc;
 	int i;
 	int ELCR_fallback = 0;
 
-	intsrc.mpc_type = MP_INTSRC;
-	intsrc.mpc_irqflag = 0;	/* conforming */
-	intsrc.mpc_srcbus = 0;
-	intsrc.mpc_dstapic = mp_ioapics[0].mp_apicid;
+	intsrc.type = MP_INTSRC;
+	intsrc.irqflag = 0;	/* conforming */
+	intsrc.srcbus = 0;
+	intsrc.dstapic = mp_ioapics[0].mp_apicid;
 
-	intsrc.mpc_irqtype = mp_INT;
+	intsrc.irqtype = mp_INT;
 
 	/*
 	 *  If true, we have an ISA/PCI system with no IRQ entries
@@ -469,30 +461,30 @@ static void __init construct_default_ioirq_mptable(int mpc_default_type)
 			 *  irqflag field (level sensitive, active high polarity).
 			 */
 			if (ELCR_trigger(i))
-				intsrc.mpc_irqflag = 13;
+				intsrc.irqflag = 13;
 			else
-				intsrc.mpc_irqflag = 0;
+				intsrc.irqflag = 0;
 		}
 
-		intsrc.mpc_srcbusirq = i;
-		intsrc.mpc_dstirq = i ? i : 2;	/* IRQ0 to INTIN2 */
+		intsrc.srcbusirq = i;
+		intsrc.dstirq = i ? i : 2;	/* IRQ0 to INTIN2 */
 		MP_intsrc_info(&intsrc);
 	}
 
-	intsrc.mpc_irqtype = mp_ExtINT;
-	intsrc.mpc_srcbusirq = 0;
-	intsrc.mpc_dstirq = 0;	/* 8259A to INTIN0 */
+	intsrc.irqtype = mp_ExtINT;
+	intsrc.srcbusirq = 0;
+	intsrc.dstirq = 0;	/* 8259A to INTIN0 */
 	MP_intsrc_info(&intsrc);
 }
 
 
 static void __init construct_ioapic_table(int mpc_default_type)
 {
-	struct mpc_config_ioapic ioapic;
-	struct mpc_config_bus bus;
+	struct mpc_ioapic ioapic;
+	struct mpc_bus bus;
 
-	bus.mpc_type = MP_BUS;
-	bus.mpc_busid = 0;
+	bus.type = MP_BUS;
+	bus.busid = 0;
 	switch (mpc_default_type) {
 	default:
 		printk(KERN_ERR "???\nUnknown standard configuration %d\n",
@@ -500,29 +492,29 @@ static void __init construct_ioapic_table(int mpc_default_type)
 		/* fall through */
 	case 1:
 	case 5:
-		memcpy(bus.mpc_bustype, "ISA   ", 6);
+		memcpy(bus.bustype, "ISA   ", 6);
 		break;
 	case 2:
 	case 6:
 	case 3:
-		memcpy(bus.mpc_bustype, "EISA  ", 6);
+		memcpy(bus.bustype, "EISA  ", 6);
 		break;
 	case 4:
 	case 7:
-		memcpy(bus.mpc_bustype, "MCA   ", 6);
+		memcpy(bus.bustype, "MCA   ", 6);
 	}
 	MP_bus_info(&bus);
 	if (mpc_default_type > 4) {
-		bus.mpc_busid = 1;
-		memcpy(bus.mpc_bustype, "PCI   ", 6);
+		bus.busid = 1;
+		memcpy(bus.bustype, "PCI   ", 6);
 		MP_bus_info(&bus);
 	}
 
-	ioapic.mpc_type = MP_IOAPIC;
-	ioapic.mpc_apicid = 2;
-	ioapic.mpc_apicver = mpc_default_type > 4 ? 0x10 : 0x01;
-	ioapic.mpc_flags = MPC_APIC_USABLE;
-	ioapic.mpc_apicaddr = 0xFEC00000;
+	ioapic.type = MP_IOAPIC;
+	ioapic.apicid = 2;
+	ioapic.apicver = mpc_default_type > 4 ? 0x10 : 0x01;
+	ioapic.flags = MPC_APIC_USABLE;
+	ioapic.apicaddr = 0xFEC00000;
 	MP_ioapic_info(&ioapic);
 
 	/*
@@ -536,8 +528,8 @@ static inline void __init construct_ioapic_table(int mpc_default_type) { }
 
 static inline void __init construct_default_ISA_mptable(int mpc_default_type)
 {
-	struct mpc_config_processor processor;
-	struct mpc_config_lintsrc lintsrc;
+	struct mpc_cpu processor;
+	struct mpc_lintsrc lintsrc;
 	int linttypes[2] = { mp_ExtINT, mp_NMI };
 	int i;
 
@@ -549,30 +541,30 @@ static inline void __init construct_default_ISA_mptable(int mpc_default_type)
 	/*
 	 * 2 CPUs, numbered 0 & 1.
 	 */
-	processor.mpc_type = MP_PROCESSOR;
+	processor.type = MP_PROCESSOR;
 	/* Either an integrated APIC or a discrete 82489DX. */
-	processor.mpc_apicver = mpc_default_type > 4 ? 0x10 : 0x01;
-	processor.mpc_cpuflag = CPU_ENABLED;
-	processor.mpc_cpufeature = (boot_cpu_data.x86 << 8) |
+	processor.apicver = mpc_default_type > 4 ? 0x10 : 0x01;
+	processor.cpuflag = CPU_ENABLED;
+	processor.cpufeature = (boot_cpu_data.x86 << 8) |
 	    (boot_cpu_data.x86_model << 4) | boot_cpu_data.x86_mask;
-	processor.mpc_featureflag = boot_cpu_data.x86_capability[0];
-	processor.mpc_reserved[0] = 0;
-	processor.mpc_reserved[1] = 0;
+	processor.featureflag = boot_cpu_data.x86_capability[0];
+	processor.reserved[0] = 0;
+	processor.reserved[1] = 0;
 	for (i = 0; i < 2; i++) {
-		processor.mpc_apicid = i;
+		processor.apicid = i;
 		MP_processor_info(&processor);
 	}
 
 	construct_ioapic_table(mpc_default_type);
 
-	lintsrc.mpc_type = MP_LINTSRC;
-	lintsrc.mpc_irqflag = 0;	/* conforming */
-	lintsrc.mpc_srcbusid = 0;
-	lintsrc.mpc_srcbusirq = 0;
-	lintsrc.mpc_destapic = MP_APIC_ALL;
+	lintsrc.type = MP_LINTSRC;
+	lintsrc.irqflag = 0;		/* conforming */
+	lintsrc.srcbusid = 0;
+	lintsrc.srcbusirq = 0;
+	lintsrc.destapic = MP_APIC_ALL;
 	for (i = 0; i < 2; i++) {
-		lintsrc.mpc_irqtype = linttypes[i];
-		lintsrc.mpc_destapiclint = i;
+		lintsrc.irqtype = linttypes[i];
+		lintsrc.destapiclint = i;
 		MP_lintsrc_info(&lintsrc);
 	}
 }
@@ -657,15 +649,15 @@ static void __init __get_smp_config(unsigned int early)
 		 * ISA defaults and hope it will work.
 		 */
 		if (!mp_irq_entries) {
-			struct mpc_config_bus bus;
+			struct mpc_bus bus;
 
 			printk(KERN_ERR "BIOS bug, no explicit IRQ entries, "
 			       "using default mptable. "
 			       "(tell your hw vendor)\n");
 
-			bus.mpc_type = MP_BUS;
-			bus.mpc_busid = 0;
-			memcpy(bus.mpc_bustype, "ISA   ", 6);
+			bus.type = MP_BUS;
+			bus.busid = 0;
+			memcpy(bus.bustype, "ISA   ", 6);
 			MP_bus_info(&bus);
 
 			construct_default_ioirq_mptable(0);
@@ -803,14 +795,14 @@ void __init find_smp_config(void)
 #ifdef CONFIG_X86_IO_APIC
 static u8 __initdata irq_used[MAX_IRQ_SOURCES];
 
-static int  __init get_MP_intsrc_index(struct mpc_config_intsrc *m)
+static int  __init get_MP_intsrc_index(struct mpc_intsrc *m)
 {
 	int i;
 
-	if (m->mpc_irqtype != mp_INT)
+	if (m->irqtype != mp_INT)
 		return 0;
 
-	if (m->mpc_irqflag != 0x0f)
+	if (m->irqflag != 0x0f)
 		return 0;
 
 	/* not legacy */
@@ -822,9 +814,9 @@ static int  __init get_MP_intsrc_index(struct mpc_config_intsrc *m)
 		if (mp_irqs[i].mp_irqflag != 0x0f)
 			continue;
 
-		if (mp_irqs[i].mp_srcbus != m->mpc_srcbus)
+		if (mp_irqs[i].mp_srcbus != m->srcbus)
 			continue;
-		if (mp_irqs[i].mp_srcbusirq != m->mpc_srcbusirq)
+		if (mp_irqs[i].mp_srcbusirq != m->srcbusirq)
 			continue;
 		if (irq_used[i]) {
 			/* already claimed */
@@ -840,10 +832,10 @@ static int  __init get_MP_intsrc_index(struct mpc_config_intsrc *m)
 
 #define SPARE_SLOT_NUM 20
 
-static struct mpc_config_intsrc __initdata *m_spare[SPARE_SLOT_NUM];
+static struct mpc_intsrc __initdata *m_spare[SPARE_SLOT_NUM];
 #endif
 
-static int  __init replace_intsrc_all(struct mp_config_table *mpc,
+static int  __init replace_intsrc_all(struct mpc_table *mpc,
 					unsigned long mpc_new_phys,
 					unsigned long mpc_new_length)
 {
@@ -855,36 +847,33 @@ static int  __init replace_intsrc_all(struct mp_config_table *mpc,
 	int count = sizeof(*mpc);
 	unsigned char *mpt = ((unsigned char *)mpc) + count;
 
-	printk(KERN_INFO "mpc_length %x\n", mpc->mpc_length);
-	while (count < mpc->mpc_length) {
+	printk(KERN_INFO "mpc_length %x\n", mpc->length);
+	while (count < mpc->length) {
 		switch (*mpt) {
 		case MP_PROCESSOR:
 			{
-				struct mpc_config_processor *m =
-				    (struct mpc_config_processor *)mpt;
+				struct mpc_cpu *m = (struct mpc_cpu *)mpt;
 				mpt += sizeof(*m);
 				count += sizeof(*m);
 				break;
 			}
 		case MP_BUS:
 			{
-				struct mpc_config_bus *m =
-				    (struct mpc_config_bus *)mpt;
+				struct mpc_bus *m = (struct mpc_bus *)mpt;
 				mpt += sizeof(*m);
 				count += sizeof(*m);
 				break;
 			}
 		case MP_IOAPIC:
 			{
-				mpt += sizeof(struct mpc_config_ioapic);
-				count += sizeof(struct mpc_config_ioapic);
+				mpt += sizeof(struct mpc_ioapic);
+				count += sizeof(struct mpc_ioapic);
 				break;
 			}
 		case MP_INTSRC:
 			{
 #ifdef CONFIG_X86_IO_APIC
-				struct mpc_config_intsrc *m =
-				    (struct mpc_config_intsrc *)mpt;
+				struct mpc_intsrc *m = (struct mpc_intsrc *)mpt;
 
 				printk(KERN_INFO "OLD ");
 				print_MP_intsrc_info(m);
@@ -905,14 +894,14 @@ static int  __init replace_intsrc_all(struct mp_config_table *mpc,
 					nr_m_spare++;
 				}
 #endif
-				mpt += sizeof(struct mpc_config_intsrc);
-				count += sizeof(struct mpc_config_intsrc);
+				mpt += sizeof(struct mpc_intsrc);
+				count += sizeof(struct mpc_intsrc);
 				break;
 			}
 		case MP_LINTSRC:
 			{
-				struct mpc_config_lintsrc *m =
-				    (struct mpc_config_lintsrc *)mpt;
+				struct mpc_lintsrc *m =
+				    (struct mpc_lintsrc *)mpt;
 				mpt += sizeof(*m);
 				count += sizeof(*m);
 				break;
@@ -922,7 +911,7 @@ static int  __init replace_intsrc_all(struct mp_config_table *mpc,
 			printk(KERN_ERR "Your mptable is wrong, contact your HW vendor!\n");
 			printk(KERN_ERR "type %x\n", *mpt);
 			print_hex_dump(KERN_ERR, "  ", DUMP_PREFIX_ADDRESS, 16,
-					1, mpc, mpc->mpc_length, 1);
+					1, mpc, mpc->length, 1);
 			goto out;
 		}
 	}
@@ -944,9 +933,8 @@ static int  __init replace_intsrc_all(struct mp_config_table *mpc,
 			assign_to_mpc_intsrc(&mp_irqs[i], m_spare[nr_m_spare]);
 			m_spare[nr_m_spare] = NULL;
 		} else {
-			struct mpc_config_intsrc *m =
-			    (struct mpc_config_intsrc *)mpt;
-			count += sizeof(struct mpc_config_intsrc);
+			struct mpc_intsrc *m = (struct mpc_intsrc *)mpt;
+			count += sizeof(struct mpc_intsrc);
 			if (!mpc_new_phys) {
 				printk(KERN_INFO "No spare slots, try to append...take your risk, new mpc_length %x\n", count);
 			} else {
@@ -958,17 +946,16 @@ static int  __init replace_intsrc_all(struct mp_config_table *mpc,
 				}
 			}
 			assign_to_mpc_intsrc(&mp_irqs[i], m);
-			mpc->mpc_length = count;
-			mpt += sizeof(struct mpc_config_intsrc);
+			mpc->length = count;
+			mpt += sizeof(struct mpc_intsrc);
 		}
 		print_mp_irq_info(&mp_irqs[i]);
 	}
 #endif
 out:
 	/* update checksum */
-	mpc->mpc_checksum = 0;
-	mpc->mpc_checksum -= mpf_checksum((unsigned char *)mpc,
-					   mpc->mpc_length);
+	mpc->checksum = 0;
+	mpc->checksum -= mpf_checksum((unsigned char *)mpc, mpc->length);
 
 	return 0;
 }
@@ -1014,8 +1001,7 @@ static int __init update_mp_table(void)
 	char str[16];
 	char oem[10];
 	struct intel_mp_floating *mpf;
-	struct mp_config_table *mpc;
-	struct mp_config_table *mpc_new;
+	struct mpc_table *mpc, *mpc_new;
 
 	if (!enable_update_mptable)
 		return 0;
@@ -1041,7 +1027,7 @@ static int __init update_mp_table(void)
 	printk(KERN_INFO "mpf: %lx\n", virt_to_phys(mpf));
 	printk(KERN_INFO "mpf_physptr: %x\n", mpf->mpf_physptr);
 
-	if (mpc_new_phys && mpc->mpc_length > mpc_new_length) {
+	if (mpc_new_phys && mpc->length > mpc_new_length) {
 		mpc_new_phys = 0;
 		printk(KERN_INFO "mpc_new_length is %ld, please use alloc_mptable=8k\n",
 			 mpc_new_length);
@@ -1050,10 +1036,10 @@ static int __init update_mp_table(void)
 	if (!mpc_new_phys) {
 		unsigned char old, new;
 		/* check if we can change the postion */
-		mpc->mpc_checksum = 0;
-		old = mpf_checksum((unsigned char *)mpc, mpc->mpc_length);
-		mpc->mpc_checksum = 0xff;
-		new = mpf_checksum((unsigned char *)mpc, mpc->mpc_length);
+		mpc->checksum = 0;
+		old = mpf_checksum((unsigned char *)mpc, mpc->length);
+		mpc->checksum = 0xff;
+		new = mpf_checksum((unsigned char *)mpc, mpc->length);
 		if (old == new) {
 			printk(KERN_INFO "mpc is readonly, please try alloc_mptable instead\n");
 			return 0;
@@ -1062,7 +1048,7 @@ static int __init update_mp_table(void)
 	} else {
 		mpf->mpf_physptr = mpc_new_phys;
 		mpc_new = phys_to_virt(mpc_new_phys);
-		memcpy(mpc_new, mpc, mpc->mpc_length);
+		memcpy(mpc_new, mpc, mpc->length);
 		mpc = mpc_new;
 		/* check if we can modify that */
 		if (mpc_new_phys - mpf->mpf_physptr) {
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 45a09cc..7228979 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -26,7 +26,6 @@
 #include <linux/kernel_stat.h>
 #include <linux/kdebug.h>
 #include <linux/smp.h>
-#include <linux/nmi.h>
 
 #include <asm/i8259.h>
 #include <asm/io_apic.h>
diff --git a/arch/x86/kernel/numaq_32.c b/arch/x86/kernel/numaq_32.c
index 0deea37..f2191d4 100644
--- a/arch/x86/kernel/numaq_32.c
+++ b/arch/x86/kernel/numaq_32.c
@@ -117,16 +117,15 @@ static inline int generate_logical_apicid(int quad, int phys_apicid)
 }
 
 /* x86_quirks member */
-static int mpc_apic_id(struct mpc_config_processor *m)
+static int mpc_apic_id(struct mpc_cpu *m)
 {
 	int quad = translation_table[mpc_record]->trans_quad;
-	int logical_apicid = generate_logical_apicid(quad, m->mpc_apicid);
+	int logical_apicid = generate_logical_apicid(quad, m->apicid);
 
 	printk(KERN_DEBUG "Processor #%d %u:%u APIC version %d (quad %d, apic %d)\n",
-	       m->mpc_apicid,
-	       (m->mpc_cpufeature & CPU_FAMILY_MASK) >> 8,
-	       (m->mpc_cpufeature & CPU_MODEL_MASK) >> 4,
-	       m->mpc_apicver, quad, logical_apicid);
+	       m->apicid, (m->cpufeature & CPU_FAMILY_MASK) >> 8,
+	       (m->cpufeature & CPU_MODEL_MASK) >> 4,
+	       m->apicver, quad, logical_apicid);
 	return logical_apicid;
 }
 
@@ -135,26 +134,26 @@ int mp_bus_id_to_node[MAX_MP_BUSSES];
 int mp_bus_id_to_local[MAX_MP_BUSSES];
 
 /* x86_quirks member */
-static void mpc_oem_bus_info(struct mpc_config_bus *m, char *name)
+static void mpc_oem_bus_info(struct mpc_bus *m, char *name)
 {
 	int quad = translation_table[mpc_record]->trans_quad;
 	int local = translation_table[mpc_record]->trans_local;
 
-	mp_bus_id_to_node[m->mpc_busid] = quad;
-	mp_bus_id_to_local[m->mpc_busid] = local;
+	mp_bus_id_to_node[m->busid] = quad;
+	mp_bus_id_to_local[m->busid] = local;
 	printk(KERN_INFO "Bus #%d is %s (node %d)\n",
-	       m->mpc_busid, name, quad);
+	       m->busid, name, quad);
 }
 
 int quad_local_to_mp_bus_id [NR_CPUS/4][4];
 
 /* x86_quirks member */
-static void mpc_oem_pci_bus(struct mpc_config_bus *m)
+static void mpc_oem_pci_bus(struct mpc_bus *m)
 {
 	int quad = translation_table[mpc_record]->trans_quad;
 	int local = translation_table[mpc_record]->trans_local;
 
-	quad_local_to_mp_bus_id[quad][local] = m->mpc_busid;
+	quad_local_to_mp_bus_id[quad][local] = m->busid;
 }
 
 static void __init MP_translation_info(struct mpc_config_translation *m)
@@ -186,7 +185,7 @@ static int __init mpf_checksum(unsigned char *mp, int len)
  * Read/parse the MPC oem tables
  */
 
-static void __init smp_read_mpc_oem(struct mp_config_oemtable *oemtable,
+static void __init smp_read_mpc_oem(struct mpc_oemtable *oemtable,
 				    unsigned short oemsize)
 {
 	int count = sizeof(*oemtable);	/* the header size */
@@ -195,18 +194,18 @@ static void __init smp_read_mpc_oem(struct mp_config_oemtable *oemtable,
 	mpc_record = 0;
 	printk(KERN_INFO "Found an OEM MPC table at %8p - parsing it ... \n",
 	       oemtable);
-	if (memcmp(oemtable->oem_signature, MPC_OEM_SIGNATURE, 4)) {
+	if (memcmp(oemtable->signature, MPC_OEM_SIGNATURE, 4)) {
 		printk(KERN_WARNING
 		       "SMP mpc oemtable: bad signature [%c%c%c%c]!\n",
-		       oemtable->oem_signature[0], oemtable->oem_signature[1],
-		       oemtable->oem_signature[2], oemtable->oem_signature[3]);
+		       oemtable->signature[0], oemtable->signature[1],
+		       oemtable->signature[2], oemtable->signature[3]);
 		return;
 	}
-	if (mpf_checksum((unsigned char *)oemtable, oemtable->oem_length)) {
+	if (mpf_checksum((unsigned char *)oemtable, oemtable->length)) {
 		printk(KERN_WARNING "SMP oem mptable: checksum error!\n");
 		return;
 	}
-	while (count < oemtable->oem_length) {
+	while (count < oemtable->length) {
 		switch (*oemptr) {
 		case MP_TRANSLATION:
 			{
@@ -260,8 +259,7 @@ static struct x86_quirks numaq_x86_quirks __initdata = {
 	.update_genapic		= numaq_update_genapic,
 };
 
-void numaq_mps_oem_check(struct mp_config_table *mpc, char *oem,
-				 char *productid)
+void numaq_mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
 {
 	if (strncmp(oem, "IBM NUMA", 8))
 		printk("Warning!  Not a NUMA-Q system!\n");
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 3ba155d..a546f55 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -39,11 +39,12 @@
 #include <linux/prctl.h>
 #include <linux/dmi.h>
 #include <linux/ftrace.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
+#include <linux/kdebug.h>
 
-#include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/system.h>
-#include <asm/io.h>
 #include <asm/ldt.h>
 #include <asm/processor.h>
 #include <asm/i387.h>
@@ -56,10 +57,8 @@
 
 #include <asm/tlbflush.h>
 #include <asm/cpu.h>
-#include <asm/kdebug.h>
 #include <asm/idle.h>
 #include <asm/syscalls.h>
-#include <asm/smp.h>
 #include <asm/ds.h>
 
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
@@ -205,7 +204,7 @@ extern void kernel_thread_helper(void);
 /*
  * Create a kernel thread
  */
-int kernel_thread(int (*fn)(void *), void * arg, unsigned long flags)
+int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
 {
 	struct pt_regs regs;
 
@@ -266,7 +265,7 @@ void flush_thread(void)
 	tsk->thread.debugreg3 = 0;
 	tsk->thread.debugreg6 = 0;
 	tsk->thread.debugreg7 = 0;
-	memset(tsk->thread.tls_array, 0, sizeof(tsk->thread.tls_array));	
+	memset(tsk->thread.tls_array, 0, sizeof(tsk->thread.tls_array));
 	clear_tsk_thread_flag(tsk, TIF_DEBUG);
 	/*
 	 * Forget coprocessor state..
@@ -293,9 +292,9 @@ void prepare_to_copy(struct task_struct *tsk)
 
 int copy_thread(int nr, unsigned long clone_flags, unsigned long sp,
 	unsigned long unused,
-	struct task_struct * p, struct pt_regs * regs)
+	struct task_struct *p, struct pt_regs *regs)
 {
-	struct pt_regs * childregs;
+	struct pt_regs *childregs;
 	struct task_struct *tsk;
 	int err;
 
@@ -347,7 +346,7 @@ int copy_thread(int nr, unsigned long clone_flags, unsigned long sp,
 void
 start_thread(struct pt_regs *regs, unsigned long new_ip, unsigned long new_sp)
 {
-	__asm__("movl %0, %%gs" :: "r"(0));
+	__asm__("movl %0, %%gs" : : "r"(0));
 	regs->fs		= 0;
 	set_fs(USER_DS);
 	regs->ds		= __USER_DS;
@@ -638,7 +637,7 @@ asmlinkage int sys_vfork(struct pt_regs regs)
 asmlinkage int sys_execve(struct pt_regs regs)
 {
 	int error;
-	char * filename;
+	char *filename;
 
 	filename = getname((char __user *) regs.bx);
 	error = PTR_ERR(filename);
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index a4b619c..e4433bf 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -5,12 +5,11 @@
 #include <linux/percpu.h>
 #include <linux/kexec.h>
 #include <linux/crash_dump.h>
-#include <asm/smp.h>
-#include <asm/percpu.h>
+#include <linux/smp.h>
+#include <linux/topology.h>
 #include <asm/sections.h>
 #include <asm/processor.h>
 #include <asm/setup.h>
-#include <asm/topology.h>
 #include <asm/mpspec.h>
 #include <asm/apicdef.h>
 #include <asm/highmem.h>
@@ -20,8 +19,8 @@ unsigned int num_processors;
 unsigned disabled_cpus __cpuinitdata;
 /* Processor that is doing the boot up */
 unsigned int boot_cpu_physical_apicid = -1U;
-unsigned int max_physical_apicid;
 EXPORT_SYMBOL(boot_cpu_physical_apicid);
+unsigned int max_physical_apicid;
 
 /* Bitmask of physically existing CPUs */
 physid_mask_t phys_cpu_present_map;
@@ -280,8 +279,8 @@ static void __cpuinit numa_set_cpumask(int cpu, int enable)
 
 	cpulist_scnprintf(buf, sizeof(buf), mask);
 	printk(KERN_DEBUG "%s cpu %d node %d: mask now %s\n",
-		enable? "numa_add_cpu":"numa_remove_cpu", cpu, node, buf);
- }
+		enable ? "numa_add_cpu" : "numa_remove_cpu", cpu, node, buf);
+}
 
 void __cpuinit numa_add_cpu(int cpu)
 {
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index beea264..cf1f075 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -1,7 +1,7 @@
 /*
  *	Intel SMP support routines.
  *
- *	(c) 1995 Alan Cox, Building #3 <alan@redhat.com>
+ *	(c) 1995 Alan Cox, Building #3 <alan@lxorguk.ukuu.org.uk>
  *	(c) 1998-99, 2000 Ingo Molnar <mingo@redhat.com>
  *      (c) 2002,2003 Andi Kleen, SuSE Labs.
  *
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 6bd4d9b..07576be 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1,7 +1,7 @@
 /*
  *	x86 SMP booting functions
  *
- *	(c) 1995 Alan Cox, Building #3 <alan@redhat.com>
+ *	(c) 1995 Alan Cox, Building #3 <alan@lxorguk.ukuu.org.uk>
  *	(c) 1998, 1999, 2000 Ingo Molnar <mingo@redhat.com>
  *	Copyright 2001 Andi Kleen, SuSE Labs.
  *
diff --git a/arch/x86/kernel/time_32.c b/arch/x86/kernel/time_32.c
index 65309e4..3985cac 100644
--- a/arch/x86/kernel/time_32.c
+++ b/arch/x86/kernel/time_32.c
@@ -105,8 +105,8 @@ irqreturn_t timer_interrupt(int irq, void *dev_id)
 		high bit of the PPI port B (0x61).  Note that some PS/2s,
 		notably the 55SX, work fine if this is removed.  */
 
-		u8 irq_v = inb_p( 0x61 );	/* read the current state */
-		outb_p( irq_v|0x80, 0x61 );	/* reset the IRQ */
+		u8 irq_v = inb_p(0x61);		/* read the current state */
+		outb_p(irq_v | 0x80, 0x61);	/* reset the IRQ */
 	}
 #endif
 
diff --git a/arch/x86/kernel/time_64.c b/arch/x86/kernel/time_64.c
index 891e7a7..e6e695a 100644
--- a/arch/x86/kernel/time_64.c
+++ b/arch/x86/kernel/time_64.c
@@ -17,10 +17,10 @@
 #include <linux/module.h>
 #include <linux/time.h>
 #include <linux/mca.h>
+#include <linux/nmi.h>
 
 #include <asm/i8253.h>
 #include <asm/hpet.h>
-#include <asm/nmi.h>
 #include <asm/vgtod.h>
 #include <asm/time.h>
 #include <asm/timer.h>
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index ce6650e..25d5c30 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -65,9 +65,6 @@
 #else
 #include <asm/processor-flags.h>
 #include <asm/arch_hooks.h>
-#include <asm/nmi.h>
-#include <asm/smp.h>
-#include <asm/io.h>
 #include <asm/traps.h>
 
 #include "cpu/mcheck/mce.h"
diff --git a/arch/x86/kernel/visws_quirks.c b/arch/x86/kernel/visws_quirks.c
index 0c9667f..d801d06 100644
--- a/arch/x86/kernel/visws_quirks.c
+++ b/arch/x86/kernel/visws_quirks.c
@@ -176,33 +176,31 @@ static int __init visws_get_smp_config(unsigned int early)
  * No problem for Linux.
  */
 
-static void __init MP_processor_info(struct mpc_config_processor *m)
+static void __init MP_processor_info(struct mpc_cpu *m)
 {
 	int ver, logical_apicid;
 	physid_mask_t apic_cpus;
 
-	if (!(m->mpc_cpuflag & CPU_ENABLED))
+	if (!(m->cpuflag & CPU_ENABLED))
 		return;
 
-	logical_apicid = m->mpc_apicid;
+	logical_apicid = m->apicid;
 	printk(KERN_INFO "%sCPU #%d %u:%u APIC version %d\n",
-	       m->mpc_cpuflag & CPU_BOOTPROCESSOR ? "Bootup " : "",
-	       m->mpc_apicid,
-	       (m->mpc_cpufeature & CPU_FAMILY_MASK) >> 8,
-	       (m->mpc_cpufeature & CPU_MODEL_MASK) >> 4,
-	       m->mpc_apicver);
+	       m->cpuflag & CPU_BOOTPROCESSOR ? "Bootup " : "",
+	       m->apicid, (m->cpufeature & CPU_FAMILY_MASK) >> 8,
+	       (m->cpufeature & CPU_MODEL_MASK) >> 4, m->apicver);
 
-	if (m->mpc_cpuflag & CPU_BOOTPROCESSOR)
-		boot_cpu_physical_apicid = m->mpc_apicid;
+	if (m->cpuflag & CPU_BOOTPROCESSOR)
+		boot_cpu_physical_apicid = m->apicid;
 
-	ver = m->mpc_apicver;
-	if ((ver >= 0x14 && m->mpc_apicid >= 0xff) || m->mpc_apicid >= 0xf) {
+	ver = m->apicver;
+	if ((ver >= 0x14 && m->apicid >= 0xff) || m->apicid >= 0xf) {
 		printk(KERN_ERR "Processor #%d INVALID. (Max ID: %d).\n",
-			m->mpc_apicid, MAX_APICS);
+			m->apicid, MAX_APICS);
 		return;
 	}
 
-	apic_cpus = apicid_to_cpu_present(m->mpc_apicid);
+	apic_cpus = apicid_to_cpu_present(m->apicid);
 	physids_or(phys_cpu_present_map, phys_cpu_present_map, apic_cpus);
 	/*
 	 * Validate version
@@ -210,15 +208,15 @@ static void __init MP_processor_info(struct mpc_config_processor *m)
 	if (ver == 0x0) {
 		printk(KERN_ERR "BIOS bug, APIC version is 0 for CPU#%d! "
 			"fixing up to 0x10. (tell your hw vendor)\n",
-			m->mpc_apicid);
+			m->apicid);
 		ver = 0x10;
 	}
-	apic_version[m->mpc_apicid] = ver;
+	apic_version[m->apicid] = ver;
 }
 
 static int __init visws_find_smp_config(unsigned int reserve)
 {
-	struct mpc_config_processor *mp = phys_to_virt(CO_CPU_TAB_PHYS);
+	struct mpc_cpu *mp = phys_to_virt(CO_CPU_TAB_PHYS);
 	unsigned short ncpus = readw(phys_to_virt(CO_CPU_NUM_PHYS));
 
 	if (ncpus > CO_CPU_MAX) {
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index 4ba5cca..c2ded14 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -43,12 +43,12 @@ static void __init enable_apic_mode(void)
 	return;
 }
 
-static __init int mps_oem_check(struct mp_config_table *mpc, char *oem,
-		char *productid)
+static __init int
+mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
 {
-	if (mpc->mpc_oemptr) {
-		struct mp_config_oemtable *oem_table =
-			(struct mp_config_oemtable *)mpc->mpc_oemptr;
+	if (mpc->oemptr) {
+		struct mpc_oemtable *oem_table =
+			(struct mpc_oemtable *)mpc->oemptr;
 		if (!strncmp(oem, "UNISYS", 6))
 			return parse_unisys_oem((char *)oem_table);
 	}
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index 511d794..3679e22 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -19,8 +19,7 @@
 #include <asm/numaq/wakecpu.h>
 #include <asm/numaq.h>
 
-static int mps_oem_check(struct mp_config_table *mpc, char *oem,
-		char *productid)
+static int mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
 {
 	numaq_mps_oem_check(mpc, oem, productid);
 	return found_numaq;
diff --git a/arch/x86/mach-generic/probe.c b/arch/x86/mach-generic/probe.c
index c346d9d..15a38da 100644
--- a/arch/x86/mach-generic/probe.c
+++ b/arch/x86/mach-generic/probe.c
@@ -110,8 +110,7 @@ void __init generic_apic_probe(void)
 
 /* These functions can switch the APIC even after the initial ->probe() */
 
-int __init mps_oem_check(struct mp_config_table *mpc, char *oem,
-				 char *productid)
+int __init mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
 {
 	int i;
 	for (i = 0; apic_probe[i]; ++i) {
diff --git a/arch/x86/mm/k8topology_64.c b/arch/x86/mm/k8topology_64.c
index 41f1b5c..268f825 100644
--- a/arch/x86/mm/k8topology_64.c
+++ b/arch/x86/mm/k8topology_64.c
@@ -81,7 +81,6 @@ int __init k8_scan_nodes(unsigned long start, unsigned long end)
 	unsigned numnodes, cores, bits, apicid_base;
 	unsigned long prevbase;
 	struct bootnode nodes[8];
-	unsigned char nodeids[8];
 	int i, j, nb, found = 0;
 	u32 nodeid, reg;
 
@@ -110,7 +109,6 @@ int __init k8_scan_nodes(unsigned long start, unsigned long end)
 		limit = read_pci_config(0, nb, 1, 0x44 + i*8);
 
 		nodeid = limit & 7;
-		nodeids[i] = nodeid;
 		if ((base & 3) == 0) {
 			if (i < numnodes)
 				printk("Skipping disabled node %d\n", i);
@@ -179,9 +177,6 @@ int __init k8_scan_nodes(unsigned long start, unsigned long end)
 
 		nodes[nodeid].start = base;
 		nodes[nodeid].end = limit;
-		e820_register_active_regions(nodeid,
-				nodes[nodeid].start >> PAGE_SHIFT,
-				nodes[nodeid].end >> PAGE_SHIFT);
 
 		prevbase = base;
 
@@ -211,12 +206,15 @@ int __init k8_scan_nodes(unsigned long start, unsigned long end)
 	}
 
 	for (i = 0; i < 8; i++) {
-		if (nodes[i].start != nodes[i].end) {
-			nodeid = nodeids[i];
-			for (j = apicid_base; j < cores + apicid_base; j++)
-				apicid_to_node[(nodeid << bits) + j] = i;
-			setup_node_bootmem(i, nodes[i].start, nodes[i].end);
-		}
+		if (nodes[i].start == nodes[i].end)
+			continue;
+
+		e820_register_active_regions(i,
+				nodes[i].start >> PAGE_SHIFT,
+				nodes[i].end >> PAGE_SHIFT);
+		for (j = apicid_base; j < cores + apicid_base; j++)
+			apicid_to_node[(i << bits) + j] = i;
+		setup_node_bootmem(i, nodes[i].start, nodes[i].end);
 	}
 
 	numa_init_array();
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 2e75478..2d0f144 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -566,14 +566,14 @@ config DEBUG_NOTIFIERS
 config FRAME_POINTER
 	bool "Compile the kernel with frame pointers"
 	depends on DEBUG_KERNEL && \
-		(X86 || CRIS || M68K || M68KNOMMU || FRV || UML || S390 || \
-		 AVR32 || SUPERH || BLACKFIN || MN10300)
-	default y if DEBUG_INFO && UML
-	help
-	  If you say Y here the resulting kernel image will be slightly larger
-	  and slower, but it might give very useful debugging information on
-	  some architectures or if you use external debuggers.
-	  If you don't debug the kernel, you can say N.
+		(CRIS || M68K || M68KNOMMU || FRV || UML || S390 || \
+		 AVR32 || SUPERH || BLACKFIN || MN10300) || \
+		ARCH_WANT_FRAME_POINTERS
+	default y if (DEBUG_INFO && UML) || ARCH_WANT_FRAME_POINTERS
+	help
+	  If you say Y here the resulting kernel image will be slightly
+	  larger and slower, but it gives very useful debugging information
+	  in case of kernel bugs. (precise oopses/stacktraces/warnings)
 
 config BOOT_PRINTK_DELAY
 	bool "Delay each boot printk message by N milliseconds"
