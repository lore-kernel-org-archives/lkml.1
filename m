Return-Path: <linux-kernel-owner+w=401wt.eu-S1758178AbXLQTeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178AbXLQTeP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:34:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760240AbXLQTba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:31:30 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2944 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758461AbXLQTb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:31:27 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
Subject: [PATCH] arch/mips/: Spelling fixes
Date: Mon, 17 Dec 2007 11:30:08 -0800
Message-Id: <1197919875-5288-9-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918889.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/mips/au1000/mtx-1/board_setup.c |    2 +-
 arch/mips/kernel/binfmt_elfn32.c     |    2 +-
 arch/mips/kernel/binfmt_elfo32.c     |    2 +-
 arch/mips/kernel/kspd.c              |    2 +-
 arch/mips/kernel/setup.c             |    4 ++--
 arch/mips/kernel/smtc.c              |    6 +++---
 arch/mips/mm/c-r4k.c                 |    2 +-
 arch/mips/sgi-ip27/ip27-hubio.c      |    2 +-
 8 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/mips/au1000/mtx-1/board_setup.c b/arch/mips/au1000/mtx-1/board_setup.c
index abfc4bc..310d5df 100644
--- a/arch/mips/au1000/mtx-1/board_setup.c
+++ b/arch/mips/au1000/mtx-1/board_setup.c
@@ -99,7 +99,7 @@ mtx1_pci_idsel(unsigned int devsel, int assert)
 #endif
 
        if (assert && devsel != 0) {
-               // supress signal to cardbus
+               // suppress signal to cardbus
                au_writel( 0x00000002, SYS_OUTPUTCLR ); // set EXT_IO3 OFF
        }
        else {
diff --git a/arch/mips/kernel/binfmt_elfn32.c b/arch/mips/kernel/binfmt_elfn32.c
index 9b34238..77db347 100644
--- a/arch/mips/kernel/binfmt_elfn32.c
+++ b/arch/mips/kernel/binfmt_elfn32.c
@@ -98,7 +98,7 @@ static __inline__ void
 jiffies_to_compat_timeval(unsigned long jiffies, struct compat_timeval *value)
 {
 	/*
-	 * Convert jiffies to nanoseconds and seperate with
+	 * Convert jiffies to nanoseconds and separate with
 	 * one divide.
 	 */
 	u64 nsec = (u64)jiffies * TICK_NSEC;
diff --git a/arch/mips/kernel/binfmt_elfo32.c b/arch/mips/kernel/binfmt_elfo32.c
index da41eac..08f4cd7 100644
--- a/arch/mips/kernel/binfmt_elfo32.c
+++ b/arch/mips/kernel/binfmt_elfo32.c
@@ -100,7 +100,7 @@ static inline void
 jiffies_to_compat_timeval(unsigned long jiffies, struct compat_timeval *value)
 {
 	/*
-	 * Convert jiffies to nanoseconds and seperate with
+	 * Convert jiffies to nanoseconds and separate with
 	 * one divide.
 	 */
 	u64 nsec = (u64)jiffies * TICK_NSEC;
diff --git a/arch/mips/kernel/kspd.c b/arch/mips/kernel/kspd.c
index d2c2e00..1630784 100644
--- a/arch/mips/kernel/kspd.c
+++ b/arch/mips/kernel/kspd.c
@@ -222,7 +222,7 @@ void sp_work_handle_request(void)
 		}
 	}
 
-	/* Run the syscall at the priviledge of the user who loaded the
+	/* Run the syscall at the privilege of the user who loaded the
 	   SP program */
 
 	if (vpe_getuid(tclimit))
diff --git a/arch/mips/kernel/setup.c b/arch/mips/kernel/setup.c
index 7f6ddcb..ddc2d6d 100644
--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -423,13 +423,13 @@ static void __init bootmem_init(void)
 #endif	/* CONFIG_SGI_IP27 */
 
 /*
- * arch_mem_init - initialize memory managment subsystem
+ * arch_mem_init - initialize memory management subsystem
  *
  *  o plat_mem_setup() detects the memory configuration and will record detected
  *    memory areas using add_memory_region.
  *
  * At this stage the memory configuration of the system is known to the
- * kernel but generic memory managment system is still entirely uninitialized.
+ * kernel but generic memory management system is still entirely uninitialized.
  *
  *  o bootmem_init()
  *  o sparse_init()
diff --git a/arch/mips/kernel/smtc.c b/arch/mips/kernel/smtc.c
index 9c92d42..37ee189 100644
--- a/arch/mips/kernel/smtc.c
+++ b/arch/mips/kernel/smtc.c
@@ -66,7 +66,7 @@ asiduse smtc_live_asid[MAX_SMTC_TLBS][MAX_SMTC_ASIDS];
 static atomic_t ipi_timer_latch[NR_CPUS];
 
 /*
- * Number of InterProcessor Interupt (IPI) message buffers to allocate
+ * Number of InterProcessor Interrupt (IPI) message buffers to allocate
  */
 
 #define IPIBUF_PER_CPU 4
@@ -781,7 +781,7 @@ void smtc_send_ipi(int cpu, int type, unsigned int action)
 	if (cpu_data[cpu].vpe_id != cpu_data[smp_processor_id()].vpe_id) {
 		if (type == SMTC_CLOCK_TICK)
 			atomic_inc(&ipi_timer_latch[cpu]);
-		/* If not on same VPE, enqueue and send cross-VPE interupt */
+		/* If not on same VPE, enqueue and send cross-VPE interrupt */
 		smtc_ipi_nq(&IPIQ[cpu], pipi);
 		LOCK_CORE_PRA();
 		settc(cpu_data[cpu].tc_id);
@@ -1064,7 +1064,7 @@ static void setup_cross_vpe_interrupts(unsigned int nvpe)
 		return;
 
 	if (!cpu_has_vint)
-		panic("SMTC Kernel requires Vectored Interupt support");
+		panic("SMTC Kernel requires Vectored Interrupt support");
 
 	set_vi_handler(MIPS_CPU_IPI_IRQ, ipi_irq_dispatch);
 
diff --git a/arch/mips/mm/c-r4k.c b/arch/mips/mm/c-r4k.c
index 9355f1c..049ba7f 100644
--- a/arch/mips/mm/c-r4k.c
+++ b/arch/mips/mm/c-r4k.c
@@ -1108,7 +1108,7 @@ static void __init setup_scache(void)
 	/*
 	 * Do the probing thing on R4000SC and R4400SC processors.  Other
 	 * processors don't have a S-cache that would be relevant to the
-	 * Linux memory managment.
+	 * Linux memory management.
 	 */
 	switch (c->cputype) {
 	case CPU_R4000SC:
diff --git a/arch/mips/sgi-ip27/ip27-hubio.c b/arch/mips/sgi-ip27/ip27-hubio.c
index 524b371..a1fa4ab 100644
--- a/arch/mips/sgi-ip27/ip27-hubio.c
+++ b/arch/mips/sgi-ip27/ip27-hubio.c
@@ -168,7 +168,7 @@ static void hub_set_piomode(nasid_t nasid)
 }
 
 /*
- * hub_pio_init  -  PIO-related hub initalization
+ * hub_pio_init  -  PIO-related hub initialization
  *
  * @hub:	hubinfo structure for our hub
  */
-- 
1.5.3.7.949.g2221a6

