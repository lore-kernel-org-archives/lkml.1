Return-Path: <linux-kernel-owner+w=401wt.eu-S1759597AbYAZQBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759597AbYAZQBu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 11:01:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755382AbYAZPz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 10:55:28 -0500
Received: from 206-47-31-89.wifiinternet.cz ([89.31.47.206]:1177 "EHLO
	monstr.monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755316AbYAZPzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 10:55:23 -0500
From: monstr@monstr.eu
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH 49/52] [microblaze] device.h param.h topology.h
Date: Thu, 24 Jan 2008 16:03:24 +0100
Message-Id: <990835fa238b139deac273e0573bcf5060e3ee80.1201107832.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.rc4.14.g6fc74
In-Reply-To: <807d570db44eeed03e3211b933a207f42cf569f0.1201107832.git.monstr@monstr.eu>
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
In-Reply-To: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
References: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/device.h   |   27 ++++++++
 include/asm-microblaze/param.h    |   36 +++++++++++
 include/asm-microblaze/topology.h |  124 +++++++++++++++++++++++++++++++++++++
 3 files changed, 187 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-microblaze/device.h
 create mode 100644 include/asm-microblaze/param.h
 create mode 100644 include/asm-microblaze/topology.h

diff --git a/include/asm-microblaze/device.h b/include/asm-microblaze/device.h
new file mode 100644
index 0000000..c0e203c
--- /dev/null
+++ b/include/asm-microblaze/device.h
@@ -0,0 +1,27 @@
+/*
+ * Arch specific extensions to struct device
+ *
+ * This file is released under the GPLv2
+ */
+
+#ifndef _ASM_MICROBLAZE_DEVICE_H
+#define _ASM_MICROBLAZE_DEVICE_H
+
+struct dma_mapping_ops;
+struct device_node;
+
+struct dev_archdata {
+	/* Optional pointer to an OF device node */
+	struct device_node	*of_node;
+
+	/* DMA operations on that device */
+	struct dma_mapping_ops	*dma_ops;
+	void			*dma_data;
+
+	/* NUMA node if applicable */
+	int			numa_node;
+};
+
+#endif /* _ASM_MICROBLAZE_DEVICE_H */
+
+
diff --git a/include/asm-microblaze/param.h b/include/asm-microblaze/param.h
new file mode 100644
index 0000000..b79d739
--- /dev/null
+++ b/include/asm-microblaze/param.h
@@ -0,0 +1,36 @@
+/*
+ * include/asm-microblaze/param.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_PARAM_H
+#define _ASM_PARAM_H
+
+#ifdef __KERNEL__
+# define HZ		100 /* internal timer frequency */
+# define USER_HZ	100 /* for user interfaces in "ticks" */
+# define CLOCKS_PER_SEC (USER_HZ) /* frequnzy at which times() counts */
+#endif
+
+#ifndef NGROUPS
+#define NGROUPS		32
+#endif
+
+#ifndef NOGROUP
+#define NOGROUP		(-1)
+#endif
+
+#define EXEC_PAGESIZE	4096
+
+#ifndef HZ
+#define HZ 100
+#endif
+
+#define MAXHOSTNAMELEN	64 /* max length of hostname */
+
+#endif /* _ASM_PARAM_H */
diff --git a/include/asm-microblaze/topology.h b/include/asm-microblaze/topology.h
new file mode 100644
index 0000000..4d3e2e7
--- /dev/null
+++ b/include/asm-microblaze/topology.h
@@ -0,0 +1,124 @@
+/*
+ * include/asm-microblaze/topology.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_TOPOLOGY_H
+#define _ASM_TOPOLOGY_H
+#ifdef __KERNEL__
+
+struct sys_device;
+struct device_node;
+
+#ifdef CONFIG_NUMA
+
+#include <asm/mmzone.h>
+
+static inline int cpu_to_node(int cpu)
+{
+	return numa_cpu_lookup_table[cpu];
+}
+
+#define parent_node(node)	(node)
+
+static inline cpumask_t node_to_cpumask(int node)
+{
+	return numa_cpumask_lookup_table[node];
+}
+
+static inline int node_to_first_cpu(int node)
+{
+	cpumask_t tmp;
+	tmp = node_to_cpumask(node);
+	return first_cpu(tmp);
+}
+
+int of_node_to_nid(struct device_node *device);
+
+struct pci_bus;
+#ifdef CONFIG_PCI
+extern int pcibus_to_node(struct pci_bus *bus);
+#else
+static inline int pcibus_to_node(struct pci_bus *bus)
+{
+	return -1;
+}
+#endif
+
+#define pcibus_to_cpumask(bus)	(pcibus_to_node(bus) == -1 ? \
+					CPU_MASK_ALL : \
+					node_to_cpumask(pcibus_to_node(bus)) \
+				)
+
+/* sched_domains SD_NODE_INIT for PPC64 machines */
+#define SD_NODE_INIT (struct sched_domain) {		\
+	.span			= CPU_MASK_NONE,	\
+	.parent			= NULL,			\
+	.child			= NULL,			\
+	.groups			= NULL,			\
+	.min_interval		= 8,			\
+	.max_interval		= 32,			\
+	.busy_factor		= 32,			\
+	.imbalance_pct		= 125,			\
+	.cache_nice_tries	= 1,			\
+	.busy_idx		= 3,			\
+	.idle_idx		= 1,			\
+	.newidle_idx		= 2,			\
+	.wake_idx		= 1,			\
+	.flags			= SD_LOAD_BALANCE	\
+				| SD_BALANCE_EXEC	\
+				| SD_BALANCE_NEWIDLE	\
+				| SD_WAKE_IDLE		\
+				| SD_SERIALIZE		\
+				| SD_WAKE_BALANCE,	\
+	.last_balance		= jiffies,		\
+	.balance_interval	= 1,			\
+	.nr_balance_failed	= 0,			\
+}
+
+extern void __init dump_numa_cpu_topology(void);
+
+extern int sysfs_add_device_to_node(struct sys_device *dev, int nid);
+extern void sysfs_remove_device_from_node(struct sys_device *dev, int nid);
+
+#else
+
+static inline int of_node_to_nid(struct device_node *device)
+{
+	return 0;
+}
+
+static inline void dump_numa_cpu_topology(void) {}
+
+static inline int sysfs_add_device_to_node(struct sys_device *dev, int nid)
+{
+	return 0;
+}
+
+static inline void sysfs_remove_device_from_node(struct sys_device *dev,
+						int nid)
+{
+}
+
+#include <asm-generic/topology.h>
+
+#endif /* CONFIG_NUMA */
+
+#ifdef CONFIG_SMP
+#include <asm/cputable.h>
+#define smt_capable()		(cpu_has_feature(CPU_FTR_SMT))
+
+#ifdef CONFIG_PPC64
+#include <asm/smp.h>
+
+#define topology_thread_siblings(cpu)	(cpu_sibling_map[cpu])
+#endif
+#endif
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_TOPOLOGY_H */
-- 
1.5.4.rc4.14.g6fc74

