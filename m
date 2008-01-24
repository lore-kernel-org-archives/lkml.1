Return-Path: <linux-kernel-owner+w=401wt.eu-S1762281AbYAZQMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762281AbYAZQMn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 11:12:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759980AbYAZQDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 11:03:37 -0500
Received: from 206-47-31-89.wifiinternet.cz ([89.31.47.206]:1189 "EHLO
	monstr.monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760288AbYAZQDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 11:03:34 -0500
From: monstr@monstr.eu
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au,
       microblaze <microblaze@localhost.localdomain.monstr.eu>
Subject: [PATCH 03/52] [microblaze] Cpuinfo handling
Date: Thu, 24 Jan 2008 16:03:28 +0100
Message-Id: <62a6eb3ffa457cd0c126320a0e46509f06e00511.1201107832.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.rc4.14.g6fc74
In-Reply-To: <e22e05ebd297de6f7d5dd0bf2eecf20d6749d571.1201107832.git.monstr@monstr.eu>
References: <1201187014-3979-1-git-send-email-monstr@monstr.eu>
 <dbff6b883dbcb108db53e5093994c473946e1240.1201107832.git.monstr@monstr.eu>
 <ac0947adfe718fcb4c0dc5f6f7ab64f8155541fb.1201107832.git.monstr@monstr.eu>
 <873c2bf1f67696aa11014886470f6ba46f04e8d2.1201107832.git.monstr@monstr.eu>
 <516d173b1789ea533431e8f5ad05751c6a353c88.1201107832.git.monstr@monstr.eu>
 <068508828aac6298b4cc65b0cd7b2737a61c466c.1201107832.git.monstr@monstr.eu>
 <010fc233f82a8f7a591c9f8315ae03f9951139aa.1201107832.git.monstr@monstr.eu>
 <68faaf69ea03196d4a56a263707355e7e7eb5c6a.1201107832.git.monstr@monstr.eu>
 <4b7d90fc1b9bcb3c0b1b308c6460390f7bdf3824.1201107832.git.monstr@monstr.eu>
 <eb28582e845efb4f2f26054630895f26fa69866e.1201107832.git.monstr@monstr.eu>
 <64e6e541db30cc4f1ee5cd85da4bdea6024f75b8.1201107832.git.monstr@monstr.eu>
 <90badb264d0e4ec49fdaa76842a5e5f259681299.1201107832.git.monstr@monstr.eu>
 <a013a2b7044186c64d55cdafc8c9b29bc73a7fc5.1201107832.git.monstr@monstr.eu>
 <60642f04ebcf9f76da50a1d40191755f258edcc5.1201107832.git.monstr@monstr.eu>
 <240998be1af3774635995fd19248f8b3a9e8a702.1201107832.git.monstr@monstr.eu>
 <3bcb9581bc512fdd0a124ac8322af9e2a8adc975.1201107832.git.monstr@monstr.eu>
 <db7f441df21cfe296a44744747b28f379e75fd49.1201107832.git.monstr@monstr.eu>
 <e6309af7cc6550ef5b399fc0902f1926f9e52e58.1201107832.git.monstr@monstr.eu>
 <2d11eef3abada1f41658a532a483c6121ded8054.1201107832.git.monstr@monstr.eu>
 <48db19662b808ab6f5455dd7f2116e6544c50e95.1201107832.git.monstr@monstr.eu>
 <7b0cfa6ae11749e20c941d0a4f03577141e022f8.1201107832.git.monstr@monstr.eu>
 <2f3db7ba4fe41cb9888adabf0e4e052d4da5c37c.1201107832.git.monstr@monstr.eu>
 <d67010417928d04766e6dd74820b12c249d61814.1201107832.git.monstr@monstr.eu>
 <37627293f081fa40f21234944ddb878d5e711740.1201107832.git.monstr@monstr.eu>
 <105791d33ea12564c70be0dd3fafef386f8e1b55.1201107832.git.monstr@monstr.eu>
 <b501d439bdfabddbdef5935db86b6f64c83d55c4.1201107832.git.monstr@monstr.eu>
 <43f77bd3045d72346eb39d3170de727050c835c1.1201107832.git.monstr@monstr.eu>
 <c09d54c49393bedbe4ca43df0e35cefa5fcc649c.1201107832.git.monstr@monstr.eu>
 <29ee870c02ea5d4c409644d7f0eb09cfbb1ec816.1201107832.git.monstr@monstr.eu>
 <99bfbc3fdb53003c11414681b2c73561d533c3ef.1201107832.git.monstr@monstr.eu>
 <1b21abdff6128297a902060b07a0c7ca6d8db633.1201107832.git.monstr@monstr.eu>
 <e173c10560cdf883ba3c7e639ca930f0627a2260.1201107832.git.monstr@monstr.eu>
 <155ee14d990137f7eb6fa76beee06c880c97e790.1201107832.git.monstr@monstr.eu>
 <34f2199d631406fbdf6b325a164e0d1899a3acb5.1201107832.git.monstr@monstr.eu>
 <14243bf49d44d1dbd6e377813f2635defcb82c4e.1201107832.git.monstr@monstr.eu>
 <01e493efdc1c8cb7ee0d5f8b7c73244e04680e71.1201107832.git.monstr@monstr.eu>
 <739e189a03021d2804f23d0774637a15038098bc.1201107832.git.monstr@monstr.eu>
 <d4eec3db9f6e6e86994444b8035d5e41db3f085b.1201107832.git.monstr@monstr.eu>
 <e445f6b37baf09d6469a0ad4eba189a7ca7ef7c3.1201107832.git.monstr@monstr.eu>
 <807d570db44eeed03e3211b933a207f42cf569f0.1201107832.git.monstr@monstr.eu>
 <990835fa238b139deac273e0573bcf5060e3ee80.1201107832.git.monstr@monstr.eu>
 <993cd20fd7ee4ec891f1354690f93ca62d7871ec.1201107832.git.monstr@monstr.eu>
 <e83ad9fcfb12993d8d20ce6663e563b8b496273e.1201107832.git.monstr@monstr.eu>
 <e22e05ebd297de6f7d5dd0bf2eecf20d6749d571.1201107832.git.monstr@monstr.eu>
In-Reply-To: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
References: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: microblaze <microblaze@localhost.localdomain>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c |   83 +++++++++++++++++
 arch/microblaze/kernel/cpu/cpuinfo-static.c   |  123 +++++++++++++++++++++++++
 arch/microblaze/kernel/cpu/cpuinfo.c          |   93 +++++++++++++++++++
 include/asm-microblaze/cpuinfo.h              |  114 +++++++++++++++++++++++
 4 files changed, 413 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c
 create mode 100644 arch/microblaze/kernel/cpu/cpuinfo-static.c
 create mode 100644 arch/microblaze/kernel/cpu/cpuinfo.c
 create mode 100644 include/asm-microblaze/cpuinfo.h

diff --git a/arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c b/arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c
new file mode 100644
index 0000000..ea5f958
--- /dev/null
+++ b/arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c
@@ -0,0 +1,83 @@
+/*
+ * arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c
+ *
+ * Support for MicroBlaze PVR (processor version register)
+ *
+ * (c) 2007 John Williams <john.williams@petalogix.com>
+ * (c) 2007 PetaLogix
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/string.h>
+#include <linux/autoconf.h>
+#include <asm/pvr.h>
+#include <asm/cpuinfo.h>
+
+/*
+ * Helper macro to map between fields in our struct cpuinfo, and
+ * the PVR macros in pvr.h.
+ */
+
+#define CI(c, p) ci->c = PVR_##p(pvr)
+
+void set_cpuinfo_pvr_full(struct cpuinfo *ci)
+{
+	struct pvr_s pvr;
+	get_pvr(&pvr);
+
+	CI(use_barrel, USE_BARREL);
+	CI(use_divider, USE_DIV);
+	CI(use_mult, USE_HW_MUL);
+	CI(use_fpu, USE_FPU);
+
+	CI(use_mul_64, USE_MUL64);
+	CI(use_msr_instr, USE_MSR_INSTR);
+	CI(use_pcmp_instr, USE_PCMP_INSTR);
+	CI(ver_code, VERSION);
+
+	CI(use_icache, USE_ICACHE);
+	CI(icache_tagbits, ICACHE_ADDR_TAG_BITS);
+	CI(icache_write, ICACHE_ALLOW_WR);
+	CI(icache_line, ICACHE_LINE_LEN);
+	CI(icache_size, ICACHE_BYTE_SIZE);
+	CI(icache_base, ICACHE_BASEADDR);
+	CI(icache_high, ICACHE_HIGHADDR);
+
+	CI(use_dcache, USE_DCACHE);
+	CI(dcache_tagbits, DCACHE_ADDR_TAG_BITS);
+	CI(dcache_write, DCACHE_ALLOW_WR);
+	CI(dcache_line, DCACHE_LINE_LEN);
+	CI(dcache_size, DCACHE_BYTE_SIZE);
+	CI(dcache_base, DCACHE_BASEADDR);
+	CI(dcache_high, DCACHE_HIGHADDR);
+
+	CI(use_dopb, D_OPB);
+	CI(use_iopb, I_OPB);
+	CI(use_dlmb, D_LMB);
+	CI(use_ilmb, I_LMB);
+	CI(num_fsl, FSL_LINKS);
+
+	CI(irq_edge, INTERRUPT_IS_EDGE);
+	CI(irq_positive, EDGE_IS_POSITIVE);
+
+	CI(area_optimised, AREA_OPTIMISED);
+	CI(opcode_0_illegal, OPCODE_0x0_ILLEGAL);
+	CI(exc_unaligned, UNALIGNED_EXCEPTION);
+	CI(exc_ill_opcode, ILL_OPCODE_EXCEPTION);
+	CI(exc_iopb, IOPB_BUS_EXCEPTION);
+	CI(exc_dopb, DOPB_BUS_EXCEPTION);
+	CI(exc_div_zero, DIV_ZERO_EXCEPTION);
+	CI(exc_fpu, FPU_EXCEPTION);
+
+	CI(hw_debug, DEBUG_ENABLED);
+	CI(num_pc_brk, NUMBER_OF_PC_BRK);
+	CI(num_rd_brk, NUMBER_OF_RD_ADDR_BRK);
+	CI(num_wr_brk, NUMBER_OF_WR_ADDR_BRK);
+
+	CI(fpga_family_code, TARGET_FAMILY);
+}
diff --git a/arch/microblaze/kernel/cpu/cpuinfo-static.c b/arch/microblaze/kernel/cpu/cpuinfo-static.c
new file mode 100644
index 0000000..2d35ff5
--- /dev/null
+++ b/arch/microblaze/kernel/cpu/cpuinfo-static.c
@@ -0,0 +1,123 @@
+/*
+ * arch/microblaze/kernel/cpu/cpuinfo-static.c
+ *
+ * (c) 2007 Michal Simek <monstr@monstr.eu>
+ * (c) 2007 John Williams <john.williams@petalogix.com>
+ * (c) 2007 PetaLogix
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/string.h>
+#include <linux/autoconf.h>
+#include <asm/cpuinfo.h>
+
+static char family_string[] = CONFIG_XILINX_MICROBLAZE0_FAMILY;
+static char cpu_ver_string[] = CONFIG_XILINX_MICROBLAZE0_HW_VER;
+
+void __init set_cpuinfo_static(struct cpuinfo *ci, struct device_node *cpu)
+{
+	int i;
+	struct cpuinfo cs;
+
+	memset(&cs, 0, sizeof(struct cpuinfo));
+
+	cs.use_barrel = fcpu(cpu, "xlnx,use-barrel");
+	cs.use_divider = fcpu(cpu, "xlnx,use-div");
+	cs.use_mult = fcpu(cpu, "xlnx,use-hw-mul");
+	cs.use_fpu = fcpu(cpu, "xlnx,use-fpu");
+	cs.use_mul_64 = (cs.use_mult == 2 ? 1 : 0);
+	cs.use_msr_instr = fcpu(cpu, "xlnx,use-msr-instr");
+	cs.use_pcmp_instr = fcpu(cpu, "xlnx,use-pcmp-instr");
+
+	cs.use_exception = fcpu(cpu, "xlnx,unaligned-exceptions") ||
+			fcpu(cpu, "xlnx,ill-opcode-exception") ||
+			fcpu(cpu, "xlnx,iopb-bus-exception") ||
+			fcpu(cpu, "xlnx,dopb-bus-exception") ||
+			fcpu(cpu, "xlnx,div-zero-exception") ||
+			fcpu(cpu, "xlnx,fpu-exception");
+
+	cs.exc_unaligned = fcpu(cpu, "xlnx,unaligned-exceptions");
+	cs.exc_unaligned = fcpu(cpu, "xlnx,ill-opcode-exception");
+	cs.exc_iopb = fcpu(cpu, "xlnx,iopb-bus-exception");
+	cs.exc_dopb = fcpu(cpu, "xlnx,dopb-bus-exception");
+	cs.exc_fpu = fcpu(cpu, "xlnx,fpu-exception");
+	cs.exc_div_zero = fcpu(cpu, "xlnx,div-zero-exception");
+	cs.opcode_0_illegal = fcpu(cpu, "xlnx,opcode-0x0-illegal");
+
+	cs.use_icache = fcpu(cpu, "xlnx,use-icache");
+	cs.icache_tagbits = fcpu(cpu, "xlnx,addr-tag-bits");
+	cs.icache_write = fcpu(cpu, "xlnx,allow-icache-wr");
+	cs.icache_line = fcpu(cpu, "xlnx,icache-line-len") << 2;
+	if (!cs.icache_line) {
+		if (fcpu(cpu, "xlnx,icache-use-fsl"))
+			cs.icache_line = 4 << 2;
+		else
+			cs.icache_line = 1 << 2;
+	}
+	cs.icache_size = fcpu(cpu, "i-cache-size");
+	cs.icache_base = fcpu(cpu, "i-cache-baseaddr");
+	cs.icache_high = fcpu(cpu, "i-cache-highaddr");
+
+	cs.use_dcache = fcpu(cpu, "xlnx,use-dcache");
+	cs.dcache_tagbits = fcpu(cpu, "xlnx,dcache-addr-tag");
+	cs.dcache_write = fcpu(cpu, "xlnx,allow-dcache-wr");
+	cs.dcache_line = fcpu(cpu, "xlnx,dcache-line-len") << 2;
+	if (!cs.dcache_line) {
+		if (fcpu(cpu, "xlnx,dcache-use-fsl"))
+			cs.dcache_line = 4 << 2;
+		else
+			cs.dcache_line = 1 << 2;
+	}
+	cs.dcache_size = fcpu(cpu, "d-cache-size");
+	cs.dcache_base = fcpu(cpu, "d-cache-baseaddr");
+	cs.dcache_high = fcpu(cpu, "d-cache-highaddr");
+
+	cs.use_dopb = fcpu(cpu, "xlnx,d-opb");
+	cs.use_iopb = fcpu(cpu, "xlnx,i-opb");
+	cs.use_dlmb = fcpu(cpu, "xlnx,d-lmb");
+	cs.use_ilmb = fcpu(cpu, "xlnx,i-lmb");
+
+	cs.num_fsl = fcpu(cpu, "xlnx,fsl-links");
+	cs.irq_edge = fcpu(cpu, "xlnx,interrupt-is-edge");
+	cs.irq_positive = fcpu(cpu, "xlnx,edge-is-positive");
+	cs.area_optimised = 0;
+
+	cs.hw_debug = fcpu(cpu, "xlnx,debug-enabled");
+	cs.num_pc_brk = fcpu(cpu, "xlnx,number-of-pc-brk");
+	cs.num_rd_brk = fcpu(cpu, "xlnx,number-of-rd-addr-brk");
+	cs.num_wr_brk = fcpu(cpu, "xlnx,number-of-wr-addr-brk");
+
+	cs.cpu_clock_freq = fcpu(cpu, "timebase-frequency");
+
+	cs.ver_code = 0;
+	cs.fpga_family_code = 0;
+
+	/* Do various fixups based on CPU version and FPGA family strings */
+
+	/* Resolved the CPU version code */
+	for (i = 0; cpu_ver_lookup[i].s != NULL; i++) {
+		if (strcmp(cpu_ver_lookup[i].s, cpu_ver_string) == 0)
+			cs.ver_code = cpu_ver_lookup[i].k;
+	}
+
+	/* Resolved the fpga family code */
+	for (i = 0; family_string_lookup[i].s != NULL; i++) {
+		if (strcmp(family_string_lookup[i].s, family_string) == 0)
+			cs.fpga_family_code = family_string_lookup[i].k;
+	}
+
+	/* FIXME - mb3 and spartan2 do not exist in PVR */
+	/* This is mb3 and on a non Spartan2 */
+	if (cs.ver_code == 0x20 && cs.fpga_family_code != 0xf0)
+		/* Hardware Multiplier in use */
+		cs.use_mult = 1;
+
+	/* Copy our static CPUINFO descriptor into place */
+	memcpy(ci, &cs, sizeof(struct cpuinfo));
+}
diff --git a/arch/microblaze/kernel/cpu/cpuinfo.c b/arch/microblaze/kernel/cpu/cpuinfo.c
new file mode 100644
index 0000000..97c3294
--- /dev/null
+++ b/arch/microblaze/kernel/cpu/cpuinfo.c
@@ -0,0 +1,93 @@
+/*
+ * arch/microblaze/kernel/cpu/cpuinfo.c
+ *
+ * (c) 2007 Michal Simek <monstr@monstr.eu>
+ * (c) 2007 John Williams <john.williams@petalogix.com>
+ * (c) 2007 PetaLogix
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/autoconf.h>
+#include <asm/cpuinfo.h>
+#include <asm/pvr.h>
+
+static struct cpuinfo the_cpuinfo;
+struct cpuinfo *cpuinfo = &the_cpuinfo;
+
+static struct cpu_ver_key the_cpu_ver_lookup[] = {
+	/* These key value are as per MBV field in PVR0 */
+	{"5.00.a", 0x01},
+	{"5.00.b", 0x02},
+	{"5.00.c", 0x03},
+	{"6.00.a", 0x04},
+	{"6.00.b", 0x06},
+	{"7.00.a", 0x05},
+	/* FIXME There is no keycode defined in MBV for these versions */
+	{"2.10.a", 0x10},
+	{"3.00.a", 0x20},
+	{"4.00.a", 0x30},
+	{"4.00.b", 0x40},
+	{NULL, 0},
+};
+struct cpu_ver_key *cpu_ver_lookup =
+	(struct cpu_ver_key *) the_cpu_ver_lookup;
+
+/*
+ * FIXME Not sure if the actual key is defined by Xilinx in the PVR
+ */
+static struct family_string_key the_family_string_lookup[] = {
+	{"virtex2", 0x4},
+	{"virtex2pro", 0x5},
+	{"spartan3", 0x6},
+	{"virtex4", 0x7},
+	{"virtex5", 0x8},
+	{"spartan3e", 0x9},
+	{"spartan3a", 0xa},
+	{"spartan3an", 0xb},
+	/* FIXME There is no key code defined for spartan2 */
+	{"spartan2", 0xf0},
+	{NULL, 0},
+};
+struct family_string_key *family_string_lookup =
+	(struct family_string_key *) the_family_string_lookup;
+
+void __init setup_cpuinfo(void)
+{
+	struct device_node *cpu = NULL;
+	int pvr_level = cpu_has_pvr();
+
+	cpu = (struct device_node *) of_find_node_by_type(NULL, "cpu");
+	if (!cpu)
+		printk(KERN_ERR "You don't have cpu!!!\n");
+
+	printk(KERN_INFO "%s: initialising\n", __FUNCTION__);
+
+	switch (pvr_level) {
+	case 0:
+		printk(KERN_WARNING
+			"%s: No PVR support. Using static CPU info from FDT\n",
+			__FUNCTION__);
+			set_cpuinfo_static(cpuinfo, cpu);
+		break;
+#if 0
+	case 1:
+		set_cpuinfo_pvr_partial(cpuinfo);
+		break;
+#endif
+	case 2:
+		printk(KERN_INFO "%s: Using full CPU PVR support\n",
+			__FUNCTION__);
+		set_cpuinfo_pvr_full(cpuinfo);
+		cpuinfo->cpu_clock_freq = fcpu(cpu, "timebase-frequency");
+		break;
+	default:
+		WARN_ON(1);
+		set_cpuinfo_static(cpuinfo, cpu);
+	}
+}
diff --git a/include/asm-microblaze/cpuinfo.h b/include/asm-microblaze/cpuinfo.h
new file mode 100644
index 0000000..0e1621b
--- /dev/null
+++ b/include/asm-microblaze/cpuinfo.h
@@ -0,0 +1,114 @@
+/*
+ * include/asm-microblaze/cpuinfo.h
+ *
+ * Generic support for queying CPU info
+ *
+ * Copyright (C) 2007 John Williams <john.williams@petalogix.com>
+ * Copyright (C) 2007 PetaLogix
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License. See the file COPYING in the main directory of this
+ * archive for more details.
+ *
+ */
+
+#ifndef _ASM_CPUINFO_H
+#define _ASM_CPUINFO_H
+
+#include <asm/prom.h>
+
+extern unsigned long loops_per_jiffy;
+
+/* CPU Version and FPGA Family code conversion table type */
+struct cpu_ver_key {
+	char *s;
+	unsigned k;
+};
+
+struct family_string_key {
+	char *s;
+	unsigned k;
+};
+
+struct cpuinfo {
+	/* Core CPU configuration */
+	int use_barrel;
+	int use_divider;
+	int use_mult;
+	int use_fpu;
+	int use_exception;
+	int use_mul_64;
+	int use_msr_instr;
+	int use_pcmp_instr;
+
+	int ver_code;
+
+	/* CPU caches */
+	int use_icache;
+	int icache_tagbits;
+	int icache_write;
+	int icache_line;
+	int icache_size;
+	unsigned long icache_base;
+	unsigned long icache_high;
+
+	int use_dcache;
+	int dcache_tagbits;
+	int dcache_write;
+	int dcache_line;
+	int dcache_size;
+	unsigned long dcache_base;
+	unsigned long dcache_high;
+
+	/* Bus connections */
+	int use_dopb;
+	int use_iopb;
+	int use_dlmb;
+	int use_ilmb;
+	int num_fsl;
+
+	/* CPU interrupt line info */
+	int irq_edge;
+	int irq_positive;
+
+	int area_optimised;
+
+	/* HW support for CPU exceptions */
+	int opcode_0_illegal;
+	int exc_unaligned;
+	int exc_ill_opcode;
+	int exc_iopb;
+	int exc_dopb;
+	int exc_div_zero;
+	int exc_fpu;
+
+	/* HW debug support */
+	int hw_debug;
+	int num_pc_brk;
+	int num_rd_brk;
+	int num_wr_brk;
+	int cpu_clock_freq;
+
+	/* FPGA family */
+	int fpga_family_code;
+};
+
+/* Declare a global instance of the cpuinfo_ops */
+extern struct cpuinfo *cpuinfo;
+extern struct cpu_ver_key *cpu_ver_lookup;
+extern struct family_string_key *family_string_lookup;
+
+/* fwd declarations of the various CPUinfo populators */
+void setup_cpuinfo(void);
+
+void set_cpuinfo_static(struct cpuinfo *ci, struct device_node *cpu);
+void set_cpuinfo_pvr_partial(struct cpuinfo *ci);
+void set_cpuinfo_pvr_full(struct cpuinfo *ci);
+
+static inline unsigned int fcpu(struct device_node *cpu, char *n)
+{
+	int *val;
+	return ((val = (int *) of_get_property(cpu, n, NULL)) ? *val : 0);
+}
+
+#endif /* _ASM_CPUINFO_H */
-- 
1.5.4.rc4.14.g6fc74

