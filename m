Return-Path: <linux-kernel-owner+w=401wt.eu-S1756126AbYEDRAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbYEDRAt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 13:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbYEDRAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 13:00:36 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:54637 "EHLO
	seznam.cz" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754755AbYEDRAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 13:00:30 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 47/56] microblaze_v2: device.h param.h topology.h
Date: Sun,  4 May 2008 13:41:36 +0200
Message-Id: <eff9f144fc70b87a9ff6767e9ab92d3d55eebbae.1209897267.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <5b1319d426b1f55e08402790b4bc16a33ec7c00c.1209897267.git.monstr@monstr.eu>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>
 <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
 <c805caeb1dd7f6d1349c4a463cb88a5342a170d2.1209897266.git.monstr@monstr.eu>
 <f120ababf2bade9aab7199bffb3014aa606e5a1c.1209897266.git.monstr@monstr.eu>
 <684c36e5ad3f598e5079e88ec195545c4a7150c2.1209897266.git.monstr@monstr.eu>
 <ed3695121faf485d491cecdd96d5d4dcc498411d.1209897266.git.monstr@monstr.eu>
 <0674b1f7abb9a3d564b68c95bc28adc2c2fe9551.1209897266.git.monstr@monstr.eu>
 <9a7c6646e5dd9724c1cf34767adec181481fa3ef.1209897266.git.monstr@monstr.eu>
 <932956128c9c655a218a940eaf02017a5dd0bdf9.1209897266.git.monstr@monstr.eu>
 <2f801c33caee22e112af51ae927c264ce99ead01.1209897266.git.monstr@monstr.eu>
 <2391e49379fb6639f57d9d6e5811f3d49a4c6fda.1209897266.git.monstr@monstr.eu>
 <0873f3a1f3b72591735c6461b51964693cac52e5.1209897266.git.monstr@monstr.eu>
 <0ba1f259d3c17eba54e334622493577493f5065f.1209897266.git.monstr@monstr.eu>
 <694451053534fea7b78fb9d618b53a2b5ebeb602.1209897266.git.monstr@monstr.eu>
 <f0c837df4106a31c1a81917596603918f722ea7b.1209897266.git.monstr@monstr.eu>
 <d883a8d8da812d77fefd47730d28d0bdb7b504e0.1209897266.git.monstr@monstr.eu>
 <625ef466cf121d655539eedc919dd39166087e0c.1209897266.git.monstr@monstr.eu>
 <b5067a1846075ddd1035966ea1edc908579e2e88.1209897266.git.monstr@monstr.eu>
 <378157891bac535dbc55e658d5f03fdd332e85cf.1209897266.git.monstr@monstr.eu>
 <eadcc6f4754df78b69d6d54c404624d0390c8558.1209897266.git.monstr@monstr.eu>
 <4df4022e06b9056202cc2fdf0b99deb01563a0fa.1209897266.git.monstr@monstr.eu>
 <6b0c9864dc80776ae48d6488a6892e5d698751b7.1209897266.git.monstr@monstr.eu>
 <ea5cbbca49c38c506960fddba29cbd8cb24e1a8d.1209897266.git.monstr@monstr.eu>
 <4f4d6ed3fce9b21cdd6dcacb2d72fff7e9830628.1209897266.git.monstr@monstr.eu>
 <35e662a81eb86c7ffb2aaa6141ca38a07789f382.1209897266.git.monstr@monstr.eu>
 <b41fcf3dd830f4ba82692a9bec2406ed0c290e7e.1209897266.git.monstr@monstr.eu>
 <14acb31da2794d2d5916da3db3d75fe2285ac055.1209897266.git.monstr@monstr.eu>
 <598221ce2159046614d7b158ea62d5af51907af3.1209897266.git.monstr@monstr.eu>
 <41c1f410eaafd875246362d10ef9866d8cc2a934.1209897266.git.monstr@monstr.eu>
 <09ce2baf0c8308d3fbca98e7eb36a6aab59112a7.1209897266.git.monstr@monstr.eu>
 <c9418c683be99ae12abb89575c362d586c026bad.1209897266.git.monstr@monstr.eu>
 <cfde3796e95bdd17c32e4fd7762d0aee55967707.1209897266.git.monstr@monstr.eu>
 <8aba2d82c85cd1d5b56de328c1fd080ee51f0211.1209897266.git.monstr@monstr.eu>
 <c4000ff625bd217f9bb683e3bf8c7193a82bd744.1209897266.git.monstr@monstr.eu>
 <491f823fac6c03cc36834ec569a45d30a03a72cf.1209897266.git.monstr@monstr.eu>
 <96f2004535c34a0c762bf2012c299cbf9f89ab32.1209897266.git.monstr@monstr.eu>
 <92cd3a27b393bb394d48902594152351a92c59bb.1209897266.git.monstr@monstr.eu>
 <4e20213f5f296268a24955df8c951f7fba279816.1209897266.git.monstr@monstr.eu>
 <49eccf3408b90a5ebb42635493bbeef3b584acb9.1209897266.git.monstr@monstr.eu>
 <d1e4a572d2add458e1dc7c4f5a3039ae4faa2c04.1209897266.git.monstr@monstr.eu>
 <27d6acda14c492aae35d8bb1343a122624560418.1209897266.git.monstr@monstr.eu>
 <64e6fc7378cd5c714fcceef7d4965c1fb3d1b288.1209897266.git.monstr@monstr.eu>
 <9cc0d54a98f25748dc3f16fc3250524d7cd00877.1209897266.git.monstr@monstr.eu>
 <5d240127ee05c28d5156bfbf305329f9540f6c14.1209897267.git.monstr@monstr.eu>
 <59b5238f7a259dcac4c9ca6513756a188625462e.1209897267.git.monstr@monstr.eu>
 <8e1d421649250f7a3f638cd552bc46e5f5845890.1209897267.git.monstr@monstr.eu>
 <5b1319d426b1f55e08402790b4bc16a33ec7c00c.1209897267.git.monstr@monstr.eu>
In-Reply-To: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/device.h   |   27 ++++++++
 include/asm-microblaze/param.h    |   36 +++++++++++
 include/asm-microblaze/topology.h |  119 +++++++++++++++++++++++++++++++++++++
 3 files changed, 182 insertions(+), 0 deletions(-)
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
index 0000000..e6873a9
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
+#ifndef _ASM_MICROBLAZE_PARAM_H
+#define _ASM_MICROBLAZE_PARAM_H
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
+#endif /* _ASM_MICROBLAZE_PARAM_H */
diff --git a/include/asm-microblaze/topology.h b/include/asm-microblaze/topology.h
new file mode 100644
index 0000000..07fa28a
--- /dev/null
+++ b/include/asm-microblaze/topology.h
@@ -0,0 +1,119 @@
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
+#ifndef _ASM_MICROBLAZE_TOPOLOGY_H
+#define _ASM_MICROBLAZE_TOPOLOGY_H
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
+#endif
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_MICROBLAZE_TOPOLOGY_H */
-- 
1.5.4.GIT

