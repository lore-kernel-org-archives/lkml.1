Return-Path: <linux-kernel-owner+w=401wt.eu-S1760622AbYAZQFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760622AbYAZQFs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 11:05:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757212AbYAZP4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 10:56:31 -0500
Received: from 206-47-31-89.wifiinternet.cz ([89.31.47.206]:1177 "EHLO
	monstr.monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757128AbYAZP43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 10:56:29 -0500
From: monstr@monstr.eu
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH 31/52] [microblaze] pci header files
Date: Thu, 24 Jan 2008 16:03:06 +0100
Message-Id: <d67010417928d04766e6dd74820b12c249d61814.1201107832.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.rc4.14.g6fc74
In-Reply-To: <2f3db7ba4fe41cb9888adabf0e4e052d4da5c37c.1201107832.git.monstr@monstr.eu>
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
In-Reply-To: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
References: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/pci-bridge.h |  146 +++++++++++++++++++++++++++++++++++
 include/asm-microblaze/pci.h        |  139 +++++++++++++++++++++++++++++++++
 2 files changed, 285 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-microblaze/pci-bridge.h
 create mode 100644 include/asm-microblaze/pci.h

diff --git a/include/asm-microblaze/pci-bridge.h b/include/asm-microblaze/pci-bridge.h
new file mode 100644
index 0000000..49d5dc4
--- /dev/null
+++ b/include/asm-microblaze/pci-bridge.h
@@ -0,0 +1,146 @@
+/*
+ * include/asm-microblaze/pci-bridge.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_PCI_BRIDGE_H
+#define _ASM_PCI_BRIDGE_H
+#ifdef __KERNEL__
+
+#include <linux/ioport.h>
+#include <linux/pci.h>
+
+struct device_node;
+struct pci_controller;
+
+/*
+ * pci_io_base returns the memory address at which you can access
+ * the I/O space for PCI bus number `bus' (or NULL on error).
+ */
+extern void __iomem *pci_bus_io_base(unsigned int bus);
+extern unsigned long pci_bus_io_base_phys(unsigned int bus);
+extern unsigned long pci_bus_mem_base_phys(unsigned int bus);
+
+/* Allocate a new PCI host bridge structure */
+extern struct pci_controller *pcibios_alloc_controller(void);
+
+/* Helper function for setting up resources */
+extern void pci_init_resource(struct resource *res, unsigned long start,
+			unsigned long end, int flags, char *name);
+
+/* Get the PCI host controller for a bus */
+extern struct pci_controller *pci_bus_to_hose(int bus);
+
+/* Get the PCI host controller for an OF device */
+extern struct pci_controller
+*pci_find_hose_for_OF_device(struct device_node *node);
+
+/* Fill up host controller resources from the OF node */
+extern void
+pci_process_bridge_OF_ranges(struct pci_controller *hose,
+			struct device_node *dev, int primary);
+
+/*
+ * Structure of a PCI controller (host bridge)
+ */
+struct pci_controller {
+	int index; /* PCI domain number */
+	struct pci_controller *next;
+	struct pci_bus *bus;
+	void *arch_data;
+
+	int first_busno;
+	int last_busno;
+	int bus_offset;
+
+	void __iomem *io_base_virt;
+	unsigned long io_base_phys;
+
+	/* Some machines (PReP) have a non 1:1 mapping of
+	 * the PCI memory space in the CPU bus space
+	 */
+	unsigned long pci_mem_offset;
+
+	struct pci_ops *ops;
+	volatile unsigned int __iomem *cfg_addr;
+	volatile void __iomem *cfg_data;
+	/*
+	 * If set, indirect method will set the cfg_type bit as
+	 * needed to generate type 1 configuration transactions.
+	 */
+	int set_cfg_type;
+
+	/* Currently, we limit ourselves to 1 IO range and 3 mem
+	 * ranges since the common pci_bus structure can't handle more
+	 */
+	struct resource	io_resource;
+	struct resource mem_resources[3];
+	int mem_resource_count;
+
+	/* Host bridge I/O and Memory space
+	 * Used for BAR placement algorithms
+	 */
+	struct resource io_space;
+	struct resource mem_space;
+};
+
+/* These are used for config access before all the PCI probing
+ has been done. */
+int early_read_config_byte(struct pci_controller *hose, int bus, int dev_fn,
+			int where, u8 *val);
+int early_read_config_word(struct pci_controller *hose, int bus, int dev_fn,
+			int where, u16 *val);
+int early_read_config_dword(struct pci_controller *hose, int bus, int dev_fn,
+			int where, u32 *val);
+int early_write_config_byte(struct pci_controller *hose, int bus, int dev_fn,
+			int where, u8 val);
+int early_write_config_word(struct pci_controller *hose, int bus, int dev_fn,
+			int where, u16 val);
+int early_write_config_dword(struct pci_controller *hose, int bus, int dev_fn,
+			int where, u32 val);
+
+extern void setup_indirect_pci_nomap(struct pci_controller *hose,
+			void __iomem *cfg_addr, void __iomem *cfg_data);
+extern void setup_indirect_pci(struct pci_controller *hose,
+			u32 cfg_addr, u32 cfg_data);
+extern void setup_grackle(struct pci_controller *hose);
+
+extern unsigned char common_swizzle(struct pci_dev *, unsigned char *);
+
+/*
+ * The following code swizzles for exactly one bridge. The routine
+ * common_swizzle below handles multiple bridges. But there are a
+ * some boards that don't follow the PCI spec's suggestion so we
+ * break this piece out separately.
+ */
+static inline unsigned char bridge_swizzle(unsigned char pin,
+		unsigned char idsel)
+{
+	return (((pin-1) + idsel) % 4) + 1;
+}
+
+/*
+ * The following macro is used to lookup irqs in a standard table
+ * format for those PPC systems that do not already have PCI
+ * interrupts properly routed.
+ */
+/* FIXME - double check this */
+#define PCI_IRQ_TABLE_LOOKUP						\
+({ long _ctl_ = -1;							\
+ if (idsel >= min_idsel && idsel <= max_idsel && pin <= irqs_per_slot)	\
+	_ctl_ = pci_irq_table[idsel - min_idsel][pin-1];		\
+	_ctl_; })
+
+/*
+ * Scan the buses below a given PCI host bridge and assign suitable
+ * resources to all devices found.
+ */
+extern int pciauto_bus_scan(struct pci_controller *, int);
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_PCI_BRIDGE_H */
diff --git a/include/asm-microblaze/pci.h b/include/asm-microblaze/pci.h
new file mode 100644
index 0000000..c7dac52
--- /dev/null
+++ b/include/asm-microblaze/pci.h
@@ -0,0 +1,139 @@
+/*
+ * include/asm-microblaze/pci.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _MICROBLAZE_PCI_H
+#define _MICROBLAZE_PCI_H
+#ifdef __KERNEL__
+
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/mm.h>
+#include <asm/scatterlist.h>
+#include <asm/io.h>
+#include <asm/pci-bridge.h>
+#include <asm-generic/pci-dma-compat.h>
+
+struct pci_dev;
+
+/* Values for the `which' argument to sys_pciconfig_iobase syscall. */
+#define IOBASE_BRIDGE_NUMBER	0
+#define IOBASE_MEMORY		1
+#define IOBASE_IO		2
+#define IOBASE_ISA_IO		3
+#define IOBASE_ISA_MEM		4
+
+/*
+ * Set this to 1 if you want the kernel to re-assign all PCI
+ * bus numbers
+ */
+extern int pci_assign_all_busses;
+
+#define pcibios_assign_all_busses()	(pci_assign_all_busses)
+#define pcibios_scan_all_fns(a, b)	0
+
+#define PCIBIOS_MIN_IO		0x1000
+#define PCIBIOS_MIN_MEM		0x10000000
+
+extern inline void pcibios_set_master(struct pci_dev *dev)
+{
+	/* No special bus mastering setup handling */
+}
+
+extern inline void pcibios_penalize_isa_irq(int irq, int active)
+{
+	/* We don't do dynamic PCI IRQ allocation */
+}
+
+extern unsigned long pci_resource_to_bus(struct pci_dev *pdev,
+						struct resource *res);
+
+/*
+ * The PCI bus bridge can translate addresses issued by the processor(s)
+ * into a different address on the PCI bus. On 32-bit cpus, we assume
+ * this mapping is 1-1, but on 64-bit systems it often isn't.
+ *
+ * Obsolete ! Drivers should now use pci_resource_to_bus
+ */
+extern unsigned long phys_to_bus(unsigned long pa);
+extern unsigned long pci_phys_to_bus(unsigned long pa, int busnr);
+extern unsigned long pci_bus_to_phys(unsigned int ba, int busnr);
+
+/* The PCI address space does equal the physical memory
+ * address space. The networking and block device layers use
+ * this boolean for bounce buffer decisions.
+ */
+#define PCI_DMA_BUS_IS_PHYS	(1)
+
+/* pci_unmap_{page,single} is a nop so... */
+#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)
+#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)
+#define pci_unmap_addr(PTR, ADDR_NAME)		(0)
+#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)	do { } while (0)
+#define pci_unmap_len(PTR, LEN_NAME)		(0)
+#define pci_unmap_len_set(PTR, LEN_NAME, VAL)	do { } while (0)
+
+#ifdef CONFIG_PCI
+static inline void pci_dma_burst_advice(struct pci_dev *pdev,
+					enum pci_dma_burst_strategy *strat,
+					unsigned long *strategy_parameter)
+{
+	*strat = PCI_DMA_BURST_INFINITY;
+	*strategy_parameter = ~0UL;
+}
+#endif
+
+/*
+ * At present there are very few 32-bit PPC machines that can have
+ * memory above the 4GB point, and we don't support that.
+ */
+#define pci_dac_dma_supported(pci_dev, mask)	(0)
+
+/* Return the index of the PCI controller for device PDEV. */
+#define pci_domain_nr(bus) ((struct pci_controller *)(bus)->sysdata)->index
+
+/* Set the name of the bus as it appears in /proc/bus/pci */
+static inline int pci_proc_domain(struct pci_bus *bus)
+{
+	return 0;
+}
+
+/* Map a range of PCI memory or I/O space for a device into user space */
+int pci_mmap_page_range(struct pci_dev *pdev, struct vm_area_struct *vma,
+			enum pci_mmap_state mmap_state, int write_combine);
+
+/* Tell drivers/pci/proc.c that we have pci_mmap_page_range() */
+#define HAVE_PCI_MMAP	1
+
+extern void
+pcibios_resource_to_bus(struct pci_dev *dev, struct pci_bus_region *region,
+			struct resource *res);
+
+extern void
+pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
+			struct pci_bus_region *region);
+
+/* extern void pcibios_add_platform_entries(struct pci_dev *dev); */
+
+struct file;
+extern pgprot_t	pci_phys_mem_access_prot(struct file *file,
+					unsigned long offset,
+					unsigned long size,
+					pgprot_t prot);
+
+#define HAVE_ARCH_PCI_RESOURCE_TO_USER
+extern void pci_resource_to_user(const struct pci_dev *dev, int bar,
+				const struct resource *rsrc,
+				u64 *start, u64 *end);
+
+
+#endif /* __KERNEL__ */
+
+#endif /* _MICROBLAZE_PCI_H */
-- 
1.5.4.rc4.14.g6fc74

