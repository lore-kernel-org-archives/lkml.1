Return-Path: <linux-kernel-owner+w=401wt.eu-S932515AbZACTjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515AbZACTjx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 14:39:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759127AbZACTjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 14:39:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39495 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571AbZACTjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 14:39:33 -0500
Date: Sat, 3 Jan 2009 20:38:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [git pull] cpus4096 tree, part 3
Message-ID: <20090103193859.GB9805@elte.hu>
References: <200901011149.18401.rusty@rustcorp.com.au> <alpine.LFD.2.00.0901021149020.5086@localhost.localdomain> <20090102203839.GA26850@elte.hu> <alpine.LFD.2.00.0901021531140.3179@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901021531140.3179@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_00,URIBL_BLACK autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	2.0 URIBL_BLACK            Contains an URL listed in the URIBL blacklist
	[URIs: csd.info]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 2 Jan 2009, Ingo Molnar wrote:
> > 
> > Linus, would you like to pull that, despite the pending regressions? 
> > Can send a pull request right away.
> 
> No, if there are known pending regressions, please get those fixed 
> first.

ok. The pending regressions are all fixed now, and i've just finished my 
standard tests on the latest tree and all the tests passed fine.

Please pull the cpus4096-for-linus-3 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git cpus4096-for-linus-3

 Thanks,

	Ingo

------------------>
Cyrill Gorcunov (1):
      x86: setup_per_cpu_areas() cleanup

Ingo Molnar (2):
      cpumask: convert RCU implementations, fix
      ia64: cpumask fix for is_affinity_mask_valid()

Li Zefan (1):
      cpumask: fix bogus kernel-doc

Mike Travis (9):
      cpumask: Add alloc_cpumask_var_node()
      cpumask: documentation for cpumask_var_t
      cpumask: add sysfs displays for configured and disabled cpu maps
      sysfs: add documentation to cputopology.txt for system cpumasks
      x86: enable cpus display of kernel_max and offlined cpus
      sched: put back some stack hog changes that were undone in kernel/sched.c
      x86: cleanup some remaining usages of NR_CPUS where s/b nr_cpu_ids
      cpumask: use alloc_cpumask_var_node where appropriate
      cpumask: fix compile error when CONFIG_NR_CPUS is not defined

Rusty Russell (63):
      cpumask: x86: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask
      cpumask: sparc: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask
      cpumask: sh: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask
      cpumask: powerpc: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask
      cpumask: IA64: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask
      cpumask: Mips: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask
      cpumask: alpha: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask
      cpumask: cpu_coregroup_mask(): x86
      cpumask: cpu_coregroup_mask(): sparc
      cpumask: cpu_coregroup_mask(): s390
      cpumask: Replace cpu_coregroup_map with cpu_coregroup_mask
      cpumask: make CONFIG_NR_CPUS always valid.
      bitmap: test for constant as well as small size for inline versions
      bitmap: fix seq_bitmap and seq_cpumask to take const pointer
      cpumask: switch over to cpu_online/possible/active/present_mask: core
      cpumask: make cpumask.h eat its own dogfood.
      cpumask: make set_cpu_*/init_cpu_* out-of-line
      cpumask: smp_call_function_many()
      cpumask: arch_send_call_function_ipi_mask: core
      cpumask: use for_each_online_cpu() in drivers/infiniband/hw/ehca/ehca_irq.c
      cpumask: use new cpumask API in drivers/infiniband/hw/ehca
      cpumask: use new cpumask API in drivers/infiniband/hw/ipath
      cpumask: Use nr_cpu_ids in seq_cpumask
      cpumask: Remove IA64 definition of total_cpus now it's in core code
      percpu: fix percpu accessors to potentially !cpu_possible() cpus: pnpbios
      percpu: fix percpu accessors to potentially !cpu_possible() cpus: m32r
      cpumask: prepare for iterators to only go to nr_cpu_ids/nr_cpumask_bits.: core
      cpumask: Use accessors code in core
      parisc: remove gratuitous cpu_online_map declaration.
      avr32: define __fls
      blackfin: define __fls
      m68k: define __fls
      m68knommu: define __fls
      bitmap: find_last_bit()
      cpumask: Use find_last_bit()
      cpumask: Introduce topology_core_cpumask()/topology_thread_cpumask(): sparc
      cpumask: Introduce topology_core_cpumask()/topology_thread_cpumask(): s390
      cpumask: Introduce topology_core_cpumask()/topology_thread_cpumask(): powerpc
      cpumask: Introduce topology_core_cpumask()/topology_thread_cpumask(): ia64
      cpumask: convert kernel trace functions
      cpumask: convert kernel trace functions further
      cpumask: remove any_online_cpu() users: kernel/
      cpumask: remove any_online_cpu() users: mm/
      cpumask: convert kernel/compat.c
      cpumask: convert kernel/workqueue.c
      cpumask: convert kernel time functions
      cpumask: convert kernel/irq
      cpumask: convert RCU implementations
      cpumask: convert kernel/profile.c
      cpumask: convert kernel/cpu.c
      cpumask: convert rest of files in kernel/
      cpumask: convert mm/
      cpumask: replace for_each_cpu_mask_nr with for_each_cpu in kernel/time/
      cpumask: zero extra bits in alloc_cpumask_var_node
      cpumask: CONFIG_DISABLE_OBSOLETE_CPUMASK_FUNCTIONS
      cris: define __fls
      frv: define __fls
      h8300: define __fls
      m32r: define __fls
      mn10300: define __fls
      xtensa: define __fls
      x86: use cpumask_var_t in acpi/boot.c
      cpumask: convert shared_cpu_map in acpi_processor* structs to cpumask_var_t

Sergio Luis (1):
      x86: mark get_cpu_leaves() with __cpuinit annotation


 Documentation/cputopology.txt                |   48 ++++++
 arch/alpha/include/asm/topology.h            |   17 ++
 arch/alpha/kernel/irq.c                      |    3 +-
 arch/alpha/kernel/setup.c                    |    5 +
 arch/avr32/include/asm/bitops.h              |    5 +
 arch/blackfin/include/asm/bitops.h           |    1 +
 arch/cris/include/asm/bitops.h               |    1 +
 arch/h8300/include/asm/bitops.h              |    1 +
 arch/ia64/include/asm/irq.h                  |    2 +-
 arch/ia64/include/asm/topology.h             |    9 +-
 arch/ia64/kernel/acpi.c                      |    3 +-
 arch/ia64/kernel/iosapic.c                   |   23 ++--
 arch/ia64/kernel/irq.c                       |    4 +-
 arch/ia64/sn/kernel/sn2/sn_hwperf.c          |   27 ++--
 arch/m32r/kernel/smpboot.c                   |    2 +-
 arch/m68knommu/include/asm/bitops.h          |    1 +
 arch/mips/include/asm/mach-ip27/topology.h   |    4 +-
 arch/parisc/include/asm/smp.h                |    2 -
 arch/powerpc/include/asm/topology.h          |   12 +-
 arch/powerpc/platforms/cell/spu_priv1_mmio.c |    6 +-
 arch/powerpc/platforms/cell/spufs/sched.c    |    4 +-
 arch/s390/include/asm/topology.h             |    2 +
 arch/s390/kernel/topology.c                  |    5 +
 arch/sh/include/asm/topology.h               |    1 +
 arch/sparc/include/asm/topology_64.h         |   13 +-
 arch/sparc/kernel/of_device_64.c             |    2 +-
 arch/sparc/kernel/pci_msi.c                  |    2 +-
 arch/x86/include/asm/es7000/apic.h           |   32 +----
 arch/x86/include/asm/lguest.h                |    2 +-
 arch/x86/include/asm/numaq/apic.h            |    4 +-
 arch/x86/include/asm/pci.h                   |   10 +-
 arch/x86/include/asm/summit/apic.h           |   42 +----
 arch/x86/include/asm/topology.h              |   36 +++--
 arch/x86/kernel/acpi/boot.c                  |   31 +++-
 arch/x86/kernel/apic.c                       |    4 +-
 arch/x86/kernel/cpu/common.c                 |    2 +-
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c   |   28 +++-
 arch/x86/kernel/cpu/cpufreq/powernow-k7.c    |    9 +
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c    |   24 ++-
 arch/x86/kernel/cpu/intel_cacheinfo.c        |    2 +-
 arch/x86/kernel/cpuid.c                      |    2 +-
 arch/x86/kernel/io_apic.c                    |    6 +-
 arch/x86/kernel/msr.c                        |    2 +-
 arch/x86/kernel/reboot.c                     |    4 +-
 arch/x86/kernel/setup_percpu.c               |   33 ++---
 arch/x86/kernel/smpboot.c                    |   15 ++-
 arch/x86/mach-voyager/voyager_smp.c          |    7 +-
 block/blk.h                                  |    4 +-
 drivers/acpi/processor_core.c                |   14 ++-
 drivers/acpi/processor_perflib.c             |   28 ++--
 drivers/acpi/processor_throttling.c          |   80 ++++++----
 drivers/base/cpu.c                           |   44 +++++
 drivers/infiniband/hw/ehca/ehca_irq.c        |   17 +-
 drivers/infiniband/hw/ipath/ipath_file_ops.c |    8 +-
 drivers/pnp/pnpbios/bioscalls.c              |    2 +-
 fs/seq_file.c                                |    3 +-
 include/acpi/processor.h                     |    4 +-
 include/asm-frv/bitops.h                     |   13 ++
 include/asm-m32r/bitops.h                    |    1 +
 include/asm-m68k/bitops.h                    |    5 +
 include/asm-mn10300/bitops.h                 |   11 ++
 include/asm-xtensa/bitops.h                  |   11 ++
 include/linux/bitmap.h                       |   35 +++--
 include/linux/bitops.h                       |   13 ++-
 include/linux/cpumask.h                      |  221 +++++++++++---------------
 include/linux/interrupt.h                    |    2 +-
 include/linux/rcuclassic.h                   |    4 +-
 include/linux/seq_file.h                     |    7 +-
 include/linux/smp.h                          |   18 ++-
 include/linux/stop_machine.h                 |    6 +-
 include/linux/threads.h                      |   16 +-
 include/linux/tick.h                         |    4 +-
 init/main.c                                  |   13 +-
 kernel/compat.c                              |   49 ++++---
 kernel/cpu.c                                 |  144 ++++++++++++------
 kernel/irq/manage.c                          |   11 +-
 kernel/irq/proc.c                            |   34 +++--
 kernel/kexec.c                               |    2 +-
 kernel/power/poweroff.c                      |    2 +-
 kernel/profile.c                             |   38 +++--
 kernel/rcuclassic.c                          |   32 ++--
 kernel/rcupreempt.c                          |   19 ++-
 kernel/rcutorture.c                          |   27 ++--
 kernel/sched.c                               |   53 ++-----
 kernel/sched_rt.c                            |    3 +-
 kernel/smp.c                                 |  145 +++++++-----------
 kernel/softirq.c                             |    2 +-
 kernel/softlockup.c                          |   10 +-
 kernel/stop_machine.c                        |    8 +-
 kernel/taskstats.c                           |   39 +++--
 kernel/time/clocksource.c                    |    9 +-
 kernel/time/tick-broadcast.c                 |  115 +++++++-------
 kernel/time/tick-common.c                    |    6 +-
 kernel/trace/ring_buffer.c                   |   42 +++--
 kernel/trace/trace.c                         |   72 ++++++---
 kernel/trace/trace.h                         |    2 +-
 kernel/trace/trace_boot.c                    |    2 +-
 kernel/trace/trace_functions_graph.c         |    2 +-
 kernel/trace/trace_hw_branches.c             |    6 +-
 kernel/trace/trace_power.c                   |    2 +-
 kernel/trace/trace_sysprof.c                 |   13 +--
 kernel/workqueue.c                           |   26 ++--
 lib/Kconfig                                  |    8 +
 lib/Makefile                                 |    1 +
 lib/cpumask.c                                |   62 +++++++-
 lib/find_last_bit.c                          |   45 ++++++
 mm/pdflush.c                                 |   16 ++-
 mm/slab.c                                    |    2 +-
 mm/slub.c                                    |   20 ++-
 mm/vmscan.c                                  |    4 +-
 mm/vmstat.c                                  |    4 +-
 security/selinux/selinuxfs.c                 |    2 +-
 112 files changed, 1285 insertions(+), 878 deletions(-)
 create mode 100644 lib/find_last_bit.c

diff --git a/Documentation/cputopology.txt b/Documentation/cputopology.txt
index bd699da..45932ec 100644
--- a/Documentation/cputopology.txt
+++ b/Documentation/cputopology.txt
@@ -31,3 +31,51 @@ not defined by include/asm-XXX/topology.h:
 2) core_id: 0
 3) thread_siblings: just the given CPU
 4) core_siblings: just the given CPU
+
+Additionally, cpu topology information is provided under
+/sys/devices/system/cpu and includes these files.  The internal
+source for the output is in brackets ("[]").
+
+    kernel_max: the maximum cpu index allowed by the kernel configuration.
+		[NR_CPUS-1]
+
+    offline:	cpus that are not online because they have been
+		HOTPLUGGED off (see cpu-hotplug.txt) or exceed the limit
+		of cpus allowed by the kernel configuration (kernel_max
+		above). [~cpu_online_mask + cpus >= NR_CPUS]
+
+    online:	cpus that are online and being scheduled [cpu_online_mask]
+
+    possible:	cpus that have been allocated resources and can be
+		brought online if they are present. [cpu_possible_mask]
+
+    present:	cpus that have been identified as being present in the
+		system. [cpu_present_mask]
+
+The format for the above output is compatible with cpulist_parse()
+[see <linux/cpumask.h>].  Some examples follow.
+
+In this example, there are 64 cpus in the system but cpus 32-63 exceed
+the kernel max which is limited to 0..31 by the NR_CPUS config option
+being 32.  Note also that cpus 2 and 4-31 are not online but could be
+brought online as they are both present and possible.
+
+     kernel_max: 31
+        offline: 2,4-31,32-63
+         online: 0-1,3
+       possible: 0-31
+        present: 0-31
+
+In this example, the NR_CPUS config option is 128, but the kernel was
+started with possible_cpus=144.  There are 4 cpus in the system and cpu2
+was manually taken offline (and is the only cpu that can be brought
+online.)
+
+     kernel_max: 127
+        offline: 2,4-127,128-143
+         online: 0-1,3
+       possible: 0-127
+        present: 0-3
+
+See cpu-hotplug.txt for the possible_cpus=NUM kernel start parameter
+as well as more information on the various cpumask's.
diff --git a/arch/alpha/include/asm/topology.h b/arch/alpha/include/asm/topology.h
index 149532e..b4f284c 100644
--- a/arch/alpha/include/asm/topology.h
+++ b/arch/alpha/include/asm/topology.h
@@ -39,7 +39,24 @@ static inline cpumask_t node_to_cpumask(int node)
 	return node_cpu_mask;
 }
 
+extern struct cpumask node_to_cpumask_map[];
+/* FIXME: This is dumb, recalculating every time.  But simple. */
+static const struct cpumask *cpumask_of_node(int node)
+{
+	int cpu;
+
+	cpumask_clear(&node_to_cpumask_map[node]);
+
+	for_each_online_cpu(cpu) {
+		if (cpu_to_node(cpu) == node)
+			cpumask_set_cpu(cpu, node_to_cpumask_map[node]);
+	}
+
+	return &node_to_cpumask_map[node];
+}
+
 #define pcibus_to_cpumask(bus)	(cpu_online_map)
+#define cpumask_of_pcibus(bus)	(cpu_online_mask)
 
 #endif /* !CONFIG_NUMA */
 # include <asm-generic/topology.h>
diff --git a/arch/alpha/kernel/irq.c b/arch/alpha/kernel/irq.c
index d0f1620..703731a 100644
--- a/arch/alpha/kernel/irq.c
+++ b/arch/alpha/kernel/irq.c
@@ -50,7 +50,8 @@ int irq_select_affinity(unsigned int irq)
 	if (!irq_desc[irq].chip->set_affinity || irq_user_affinity[irq])
 		return 1;
 
-	while (!cpu_possible(cpu) || !cpu_isset(cpu, irq_default_affinity))
+	while (!cpu_possible(cpu) ||
+	       !cpumask_test_cpu(cpu, irq_default_affinity))
 		cpu = (cpu < (NR_CPUS-1) ? cpu + 1 : 0);
 	last_cpu = cpu;
 
diff --git a/arch/alpha/kernel/setup.c b/arch/alpha/kernel/setup.c
index a449e99..02bee69 100644
--- a/arch/alpha/kernel/setup.c
+++ b/arch/alpha/kernel/setup.c
@@ -79,6 +79,11 @@ int alpha_l3_cacheshape;
 unsigned long alpha_verbose_mcheck = CONFIG_VERBOSE_MCHECK_ON;
 #endif
 
+#ifdef CONFIG_NUMA
+struct cpumask node_to_cpumask_map[MAX_NUMNODES] __read_mostly;
+EXPORT_SYMBOL(node_to_cpumask_map);
+#endif
+
 /* Which processor we booted from.  */
 int boot_cpuid;
 
diff --git a/arch/avr32/include/asm/bitops.h b/arch/avr32/include/asm/bitops.h
index 1a50b69..f7dd5f7 100644
--- a/arch/avr32/include/asm/bitops.h
+++ b/arch/avr32/include/asm/bitops.h
@@ -263,6 +263,11 @@ static inline int fls(unsigned long word)
 	return 32 - result;
 }
 
+static inline int __fls(unsigned long word)
+{
+	return fls(word) - 1;
+}
+
 unsigned long find_first_zero_bit(const unsigned long *addr,
 				  unsigned long size);
 unsigned long find_next_zero_bit(const unsigned long *addr,
diff --git a/arch/blackfin/include/asm/bitops.h b/arch/blackfin/include/asm/bitops.h
index b39a175..c428e41 100644
--- a/arch/blackfin/include/asm/bitops.h
+++ b/arch/blackfin/include/asm/bitops.h
@@ -213,6 +213,7 @@ static __inline__ int __test_bit(int nr, const void *addr)
 #endif				/* __KERNEL__ */
 
 #include <asm-generic/bitops/fls.h>
+#include <asm-generic/bitops/__fls.h>
 #include <asm-generic/bitops/fls64.h>
 
 #endif				/* _BLACKFIN_BITOPS_H */
diff --git a/arch/cris/include/asm/bitops.h b/arch/cris/include/asm/bitops.h
index c0e62f8..9e69cfb 100644
--- a/arch/cris/include/asm/bitops.h
+++ b/arch/cris/include/asm/bitops.h
@@ -148,6 +148,7 @@ static inline int test_and_change_bit(int nr, volatile unsigned long *addr)
 #define ffs kernel_ffs
 
 #include <asm-generic/bitops/fls.h>
+#include <asm-generic/bitops/__fls.h>
 #include <asm-generic/bitops/fls64.h>
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/find.h>
diff --git a/arch/h8300/include/asm/bitops.h b/arch/h8300/include/asm/bitops.h
index cb18e3b..cb9ddf5 100644
--- a/arch/h8300/include/asm/bitops.h
+++ b/arch/h8300/include/asm/bitops.h
@@ -207,6 +207,7 @@ static __inline__ unsigned long __ffs(unsigned long word)
 #endif /* __KERNEL__ */
 
 #include <asm-generic/bitops/fls.h>
+#include <asm-generic/bitops/__fls.h>
 #include <asm-generic/bitops/fls64.h>
 
 #endif /* _H8300_BITOPS_H */
diff --git a/arch/ia64/include/asm/irq.h b/arch/ia64/include/asm/irq.h
index 3627116..36429a5 100644
--- a/arch/ia64/include/asm/irq.h
+++ b/arch/ia64/include/asm/irq.h
@@ -27,7 +27,7 @@ irq_canonicalize (int irq)
 }
 
 extern void set_irq_affinity_info (unsigned int irq, int dest, int redir);
-bool is_affinity_mask_valid(cpumask_t cpumask);
+bool is_affinity_mask_valid(cpumask_var_t cpumask);
 
 #define is_affinity_mask_valid is_affinity_mask_valid
 
diff --git a/arch/ia64/include/asm/topology.h b/arch/ia64/include/asm/topology.h
index a3cc9f6..76a33a9 100644
--- a/arch/ia64/include/asm/topology.h
+++ b/arch/ia64/include/asm/topology.h
@@ -34,6 +34,7 @@
  * Returns a bitmask of CPUs on Node 'node'.
  */
 #define node_to_cpumask(node) (node_to_cpu_mask[node])
+#define cpumask_of_node(node) (&node_to_cpu_mask[node])
 
 /*
  * Returns the number of the node containing Node 'nid'.
@@ -45,7 +46,7 @@
 /*
  * Returns the number of the first CPU on Node 'node'.
  */
-#define node_to_first_cpu(node) (first_cpu(node_to_cpumask(node)))
+#define node_to_first_cpu(node) (cpumask_first(cpumask_of_node(node)))
 
 /*
  * Determines the node for a given pci bus
@@ -109,6 +110,8 @@ void build_cpu_to_node_map(void);
 #define topology_core_id(cpu)			(cpu_data(cpu)->core_id)
 #define topology_core_siblings(cpu)		(cpu_core_map[cpu])
 #define topology_thread_siblings(cpu)		(per_cpu(cpu_sibling_map, cpu))
+#define topology_core_cpumask(cpu)		(&cpu_core_map[cpu])
+#define topology_thread_cpumask(cpu)		(&per_cpu(cpu_sibling_map, cpu))
 #define smt_capable() 				(smp_num_siblings > 1)
 #endif
 
@@ -119,6 +122,10 @@ extern void arch_fix_phys_package_id(int num, u32 slot);
 					node_to_cpumask(pcibus_to_node(bus)) \
 				)
 
+#define cpumask_of_pcibus(bus)	(pcibus_to_node(bus) == -1 ?		\
+				 cpu_all_mask :				\
+				 cpumask_from_node(pcibus_to_node(bus)))
+
 #include <asm-generic/topology.h>
 
 #endif /* _ASM_IA64_TOPOLOGY_H */
diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
index bd7acc7..0553648 100644
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -202,7 +202,6 @@ char *__init __acpi_map_table(unsigned long phys_addr, unsigned long size)
                             Boot-time Table Parsing
    -------------------------------------------------------------------------- */
 
-static int total_cpus __initdata;
 static int available_cpus __initdata;
 struct acpi_table_madt *acpi_madt __initdata;
 static u8 has_8259;
@@ -1001,7 +1000,7 @@ acpi_map_iosapic(acpi_handle handle, u32 depth, void *context, void **ret)
 	node = pxm_to_node(pxm);
 
 	if (node >= MAX_NUMNODES || !node_online(node) ||
-	    cpus_empty(node_to_cpumask(node)))
+	    cpumask_empty(cpumask_of_node(node)))
 		return AE_OK;
 
 	/* We know a gsi to node mapping! */
diff --git a/arch/ia64/kernel/iosapic.c b/arch/ia64/kernel/iosapic.c
index c8adecd..5cfd3d9 100644
--- a/arch/ia64/kernel/iosapic.c
+++ b/arch/ia64/kernel/iosapic.c
@@ -695,32 +695,31 @@ get_target_cpu (unsigned int gsi, int irq)
 #ifdef CONFIG_NUMA
 	{
 		int num_cpus, cpu_index, iosapic_index, numa_cpu, i = 0;
-		cpumask_t cpu_mask;
+		const struct cpumask *cpu_mask;
 
 		iosapic_index = find_iosapic(gsi);
 		if (iosapic_index < 0 ||
 		    iosapic_lists[iosapic_index].node == MAX_NUMNODES)
 			goto skip_numa_setup;
 
-		cpu_mask = node_to_cpumask(iosapic_lists[iosapic_index].node);
-		cpus_and(cpu_mask, cpu_mask, domain);
-		for_each_cpu_mask(numa_cpu, cpu_mask) {
-			if (!cpu_online(numa_cpu))
-				cpu_clear(numa_cpu, cpu_mask);
+		cpu_mask = cpumask_of_node(iosapic_lists[iosapic_index].node);
+		num_cpus = 0;
+		for_each_cpu_and(numa_cpu, cpu_mask, &domain) {
+			if (cpu_online(numa_cpu))
+				num_cpus++;
 		}
 
-		num_cpus = cpus_weight(cpu_mask);
-
 		if (!num_cpus)
 			goto skip_numa_setup;
 
 		/* Use irq assignment to distribute across cpus in node */
 		cpu_index = irq % num_cpus;
 
-		for (numa_cpu = first_cpu(cpu_mask) ; i < cpu_index ; i++)
-			numa_cpu = next_cpu(numa_cpu, cpu_mask);
+		for_each_cpu_and(numa_cpu, cpu_mask, &domain)
+			if (cpu_online(numa_cpu) && i++ >= cpu_index)
+				break;
 
-		if (numa_cpu != NR_CPUS)
+		if (numa_cpu < nr_cpu_ids)
 			return cpu_physical_id(numa_cpu);
 	}
 skip_numa_setup:
@@ -731,7 +730,7 @@ skip_numa_setup:
 	 * case of NUMA.)
 	 */
 	do {
-		if (++cpu >= NR_CPUS)
+		if (++cpu >= nr_cpu_ids)
 			cpu = 0;
 	} while (!cpu_online(cpu) || !cpu_isset(cpu, domain));
 
diff --git a/arch/ia64/kernel/irq.c b/arch/ia64/kernel/irq.c
index 0b6db53..95ff16c 100644
--- a/arch/ia64/kernel/irq.c
+++ b/arch/ia64/kernel/irq.c
@@ -112,11 +112,11 @@ void set_irq_affinity_info (unsigned int irq, int hwid, int redir)
 	}
 }
 
-bool is_affinity_mask_valid(cpumask_t cpumask)
+bool is_affinity_mask_valid(cpumask_var_t cpumask)
 {
 	if (ia64_platform_is("sn2")) {
 		/* Only allow one CPU to be specified in the smp_affinity mask */
-		if (cpus_weight(cpumask) != 1)
+		if (cpumask_weight(cpumask) != 1)
 			return false;
 	}
 	return true;
diff --git a/arch/ia64/sn/kernel/sn2/sn_hwperf.c b/arch/ia64/sn/kernel/sn2/sn_hwperf.c
index 636588e..be33947 100644
--- a/arch/ia64/sn/kernel/sn2/sn_hwperf.c
+++ b/arch/ia64/sn/kernel/sn2/sn_hwperf.c
@@ -385,7 +385,6 @@ static int sn_topology_show(struct seq_file *s, void *d)
 	int j;
 	const char *slabname;
 	int ordinal;
-	cpumask_t cpumask;
 	char slice;
 	struct cpuinfo_ia64 *c;
 	struct sn_hwperf_port_info *ptdata;
@@ -473,23 +472,21 @@ static int sn_topology_show(struct seq_file *s, void *d)
 		 * CPUs on this node, if any
 		 */
 		if (!SN_HWPERF_IS_IONODE(obj)) {
-			cpumask = node_to_cpumask(ordinal);
-			for_each_online_cpu(i) {
-				if (cpu_isset(i, cpumask)) {
-					slice = 'a' + cpuid_to_slice(i);
-					c = cpu_data(i);
-					seq_printf(s, "cpu %d %s%c local"
-						" freq %luMHz, arch ia64",
-						i, obj->location, slice,
-						c->proc_freq / 1000000);
-					for_each_online_cpu(j) {
-						seq_printf(s, j ? ":%d" : ", dist %d",
-							node_distance(
+			for_each_cpu_and(i, cpu_online_mask,
+					 cpumask_of_node(ordinal)) {
+				slice = 'a' + cpuid_to_slice(i);
+				c = cpu_data(i);
+				seq_printf(s, "cpu %d %s%c local"
+					   " freq %luMHz, arch ia64",
+					   i, obj->location, slice,
+					   c->proc_freq / 1000000);
+				for_each_online_cpu(j) {
+					seq_printf(s, j ? ":%d" : ", dist %d",
+						   node_distance(
 						    	cpu_to_node(i),
 						    	cpu_to_node(j)));
-					}
-					seq_putc(s, '\n');
 				}
+				seq_putc(s, '\n');
 			}
 		}
 	}
diff --git a/arch/m32r/kernel/smpboot.c b/arch/m32r/kernel/smpboot.c
index 0f06b37..2547d6c 100644
--- a/arch/m32r/kernel/smpboot.c
+++ b/arch/m32r/kernel/smpboot.c
@@ -592,7 +592,7 @@ int setup_profiling_timer(unsigned int multiplier)
 	 * accounting. At that time they also adjust their APIC timers
 	 * accordingly.
 	 */
-	for (i = 0; i < NR_CPUS; ++i)
+	for_each_possible_cpu(i)
 		per_cpu(prof_multiplier, i) = multiplier;
 
 	return 0;
diff --git a/arch/m68knommu/include/asm/bitops.h b/arch/m68knommu/include/asm/bitops.h
index 6f3685e..9d3cbe5 100644
--- a/arch/m68knommu/include/asm/bitops.h
+++ b/arch/m68knommu/include/asm/bitops.h
@@ -331,6 +331,7 @@ found_middle:
 #endif /* __KERNEL__ */
 
 #include <asm-generic/bitops/fls.h>
+#include <asm-generic/bitops/__fls.h>
 #include <asm-generic/bitops/fls64.h>
 
 #endif /* _M68KNOMMU_BITOPS_H */
diff --git a/arch/mips/include/asm/mach-ip27/topology.h b/arch/mips/include/asm/mach-ip27/topology.h
index 1fb959f..55d4815 100644
--- a/arch/mips/include/asm/mach-ip27/topology.h
+++ b/arch/mips/include/asm/mach-ip27/topology.h
@@ -25,11 +25,13 @@ extern struct cpuinfo_ip27 sn_cpu_info[NR_CPUS];
 #define cpu_to_node(cpu)	(sn_cpu_info[(cpu)].p_nodeid)
 #define parent_node(node)	(node)
 #define node_to_cpumask(node)	(hub_data(node)->h_cpus)
-#define node_to_first_cpu(node)	(first_cpu(node_to_cpumask(node)))
+#define cpumask_of_node(node)	(&hub_data(node)->h_cpus)
+#define node_to_first_cpu(node)	(cpumask_first(cpumask_of_node(node)))
 struct pci_bus;
 extern int pcibus_to_node(struct pci_bus *);
 
 #define pcibus_to_cpumask(bus)	(cpu_online_map)
+#define cpumask_of_pcibus(bus)	(cpu_online_mask)
 
 extern unsigned char __node_distances[MAX_COMPACT_NODES][MAX_COMPACT_NODES];
 
diff --git a/arch/parisc/include/asm/smp.h b/arch/parisc/include/asm/smp.h
index 409e698..6ef4b78 100644
--- a/arch/parisc/include/asm/smp.h
+++ b/arch/parisc/include/asm/smp.h
@@ -16,8 +16,6 @@
 #include <linux/cpumask.h>
 typedef unsigned long address_t;
 
-extern cpumask_t cpu_online_map;
-
 
 /*
  *	Private routines/data
diff --git a/arch/powerpc/include/asm/topology.h b/arch/powerpc/include/asm/topology.h
index 373fca3..3752585 100644
--- a/arch/powerpc/include/asm/topology.h
+++ b/arch/powerpc/include/asm/topology.h
@@ -22,11 +22,11 @@ static inline cpumask_t node_to_cpumask(int node)
 	return numa_cpumask_lookup_table[node];
 }
 
+#define cpumask_of_node(node) (&numa_cpumask_lookup_table[node])
+
 static inline int node_to_first_cpu(int node)
 {
-	cpumask_t tmp;
-	tmp = node_to_cpumask(node);
-	return first_cpu(tmp);
+	return cpumask_first(cpumask_of_node(node));
 }
 
 int of_node_to_nid(struct device_node *device);
@@ -46,6 +46,10 @@ static inline int pcibus_to_node(struct pci_bus *bus)
 					node_to_cpumask(pcibus_to_node(bus)) \
 				)
 
+#define cpumask_of_pcibus(bus)	(pcibus_to_node(bus) == -1 ?		\
+				 cpu_all_mask :				\
+				 cpumask_of_node(pcibus_to_node(bus)))
+
 /* sched_domains SD_NODE_INIT for PPC64 machines */
 #define SD_NODE_INIT (struct sched_domain) {		\
 	.parent			= NULL,			\
@@ -108,6 +112,8 @@ static inline void sysfs_remove_device_from_node(struct sys_device *dev,
 
 #define topology_thread_siblings(cpu)	(per_cpu(cpu_sibling_map, cpu))
 #define topology_core_siblings(cpu)	(per_cpu(cpu_core_map, cpu))
+#define topology_thread_cpumask(cpu)	(&per_cpu(cpu_sibling_map, cpu))
+#define topology_core_cpumask(cpu)	(&per_cpu(cpu_core_map, cpu))
 #define topology_core_id(cpu)		(cpu_to_core_id(cpu))
 #endif
 #endif
diff --git a/arch/powerpc/platforms/cell/spu_priv1_mmio.c b/arch/powerpc/platforms/cell/spu_priv1_mmio.c
index 906a0a2..1410443 100644
--- a/arch/powerpc/platforms/cell/spu_priv1_mmio.c
+++ b/arch/powerpc/platforms/cell/spu_priv1_mmio.c
@@ -80,10 +80,10 @@ static void cpu_affinity_set(struct spu *spu, int cpu)
 	u64 route;
 
 	if (nr_cpus_node(spu->node)) {
-		cpumask_t spumask = node_to_cpumask(spu->node);
-		cpumask_t cpumask = node_to_cpumask(cpu_to_node(cpu));
+		const struct cpumask *spumask = cpumask_of_node(spu->node),
+			*cpumask = cpumask_of_node(cpu_to_node(cpu));
 
-		if (!cpus_intersects(spumask, cpumask))
+		if (!cpumask_intersects(spumask, cpumask))
 			return;
 	}
 
diff --git a/arch/powerpc/platforms/cell/spufs/sched.c b/arch/powerpc/platforms/cell/spufs/sched.c
index 2ad914c..6a0ad19 100644
--- a/arch/powerpc/platforms/cell/spufs/sched.c
+++ b/arch/powerpc/platforms/cell/spufs/sched.c
@@ -166,9 +166,9 @@ void spu_update_sched_info(struct spu_context *ctx)
 static int __node_allowed(struct spu_context *ctx, int node)
 {
 	if (nr_cpus_node(node)) {
-		cpumask_t mask = node_to_cpumask(node);
+		const struct cpumask *mask = cpumask_of_node(node);
 
-		if (cpus_intersects(mask, ctx->cpus_allowed))
+		if (cpumask_intersects(mask, &ctx->cpus_allowed))
 			return 1;
 	}
 
diff --git a/arch/s390/include/asm/topology.h b/arch/s390/include/asm/topology.h
index d96c916..c93eb50 100644
--- a/arch/s390/include/asm/topology.h
+++ b/arch/s390/include/asm/topology.h
@@ -6,10 +6,12 @@
 #define mc_capable()	(1)
 
 cpumask_t cpu_coregroup_map(unsigned int cpu);
+const struct cpumask *cpu_coregroup_mask(unsigned int cpu);
 
 extern cpumask_t cpu_core_map[NR_CPUS];
 
 #define topology_core_siblings(cpu)	(cpu_core_map[cpu])
+#define topology_core_cpumask(cpu)	(&cpu_core_map[cpu])
 
 int topology_set_cpu_management(int fc);
 void topology_schedule_update(void);
diff --git a/arch/s390/kernel/topology.c b/arch/s390/kernel/topology.c
index 90e9ba1..cc362c9 100644
--- a/arch/s390/kernel/topology.c
+++ b/arch/s390/kernel/topology.c
@@ -97,6 +97,11 @@ cpumask_t cpu_coregroup_map(unsigned int cpu)
 	return mask;
 }
 
+const struct cpumask *cpu_coregroup_mask(unsigned int cpu)
+{
+	return &cpu_core_map[cpu];
+}
+
 static void add_cpus_to_core(struct tl_cpu *tl_cpu, struct core_info *core)
 {
 	unsigned int cpu;
diff --git a/arch/sh/include/asm/topology.h b/arch/sh/include/asm/topology.h
index 279d9cc..066f0fb 100644
--- a/arch/sh/include/asm/topology.h
+++ b/arch/sh/include/asm/topology.h
@@ -32,6 +32,7 @@
 #define parent_node(node)	((void)(node),0)
 
 #define node_to_cpumask(node)	((void)node, cpu_online_map)
+#define cpumask_of_node(node)	((void)node, cpu_online_mask)
 #define node_to_first_cpu(node)	((void)(node),0)
 
 #define pcibus_to_node(bus)	((void)(bus), -1)
diff --git a/arch/sparc/include/asm/topology_64.h b/arch/sparc/include/asm/topology_64.h
index 001c040..b8a65b6 100644
--- a/arch/sparc/include/asm/topology_64.h
+++ b/arch/sparc/include/asm/topology_64.h
@@ -16,8 +16,12 @@ static inline cpumask_t node_to_cpumask(int node)
 {
 	return numa_cpumask_lookup_table[node];
 }
+#define cpumask_of_node(node) (&numa_cpumask_lookup_table[node])
 
-/* Returns a pointer to the cpumask of CPUs on Node 'node'. */
+/*
+ * Returns a pointer to the cpumask of CPUs on Node 'node'.
+ * Deprecated: use "const struct cpumask *mask = cpumask_of_node(node)"
+ */
 #define node_to_cpumask_ptr(v, node)		\
 		cpumask_t *v = &(numa_cpumask_lookup_table[node])
 
@@ -26,9 +30,7 @@ static inline cpumask_t node_to_cpumask(int node)
 
 static inline int node_to_first_cpu(int node)
 {
-	cpumask_t tmp;
-	tmp = node_to_cpumask(node);
-	return first_cpu(tmp);
+	return cpumask_first(cpumask_of_node(node));
 }
 
 struct pci_bus;
@@ -77,10 +79,13 @@ static inline int pcibus_to_node(struct pci_bus *pbus)
 #define topology_core_id(cpu)			(cpu_data(cpu).core_id)
 #define topology_core_siblings(cpu)		(cpu_core_map[cpu])
 #define topology_thread_siblings(cpu)		(per_cpu(cpu_sibling_map, cpu))
+#define topology_core_cpumask(cpu)		(&cpu_core_map[cpu])
+#define topology_thread_cpumask(cpu)		(&per_cpu(cpu_sibling_map, cpu))
 #define mc_capable()				(sparc64_multi_core)
 #define smt_capable()				(sparc64_multi_core)
 #endif /* CONFIG_SMP */
 
 #define cpu_coregroup_map(cpu)			(cpu_core_map[cpu])
+#define cpu_coregroup_mask(cpu)			(&cpu_core_map[cpu])
 
 #endif /* _ASM_SPARC64_TOPOLOGY_H */
diff --git a/arch/sparc/kernel/of_device_64.c b/arch/sparc/kernel/of_device_64.c
index 322046c..4873f28 100644
--- a/arch/sparc/kernel/of_device_64.c
+++ b/arch/sparc/kernel/of_device_64.c
@@ -778,7 +778,7 @@ static unsigned int __init build_one_device_irq(struct of_device *op,
 out:
 	nid = of_node_to_nid(dp);
 	if (nid != -1) {
-		cpumask_t numa_mask = node_to_cpumask(nid);
+		cpumask_t numa_mask = *cpumask_of_node(nid);
 
 		irq_set_affinity(irq, &numa_mask);
 	}
diff --git a/arch/sparc/kernel/pci_msi.c b/arch/sparc/kernel/pci_msi.c
index 0d0cd81..4ef282e 100644
--- a/arch/sparc/kernel/pci_msi.c
+++ b/arch/sparc/kernel/pci_msi.c
@@ -286,7 +286,7 @@ static int bringup_one_msi_queue(struct pci_pbm_info *pbm,
 
 	nid = pbm->numa_node;
 	if (nid != -1) {
-		cpumask_t numa_mask = node_to_cpumask(nid);
+		cpumask_t numa_mask = *cpumask_of_node(nid);
 
 		irq_set_affinity(irq, &numa_mask);
 	}
diff --git a/arch/x86/include/asm/es7000/apic.h b/arch/x86/include/asm/es7000/apic.h
index 51ac123..bc53d5e 100644
--- a/arch/x86/include/asm/es7000/apic.h
+++ b/arch/x86/include/asm/es7000/apic.h
@@ -157,7 +157,7 @@ cpu_mask_to_apicid_cluster(const struct cpumask *cpumask)
 
 	num_bits_set = cpumask_weight(cpumask);
 	/* Return id to all */
-	if (num_bits_set == NR_CPUS)
+	if (num_bits_set == nr_cpu_ids)
 		return 0xFF;
 	/*
 	 * The cpus in the mask must all be on the apic cluster.  If are not
@@ -190,7 +190,7 @@ static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
 
 	num_bits_set = cpus_weight(*cpumask);
 	/* Return id to all */
-	if (num_bits_set == NR_CPUS)
+	if (num_bits_set == nr_cpu_ids)
 		return cpu_to_logical_apicid(0);
 	/*
 	 * The cpus in the mask must all be on the apic cluster.  If are not
@@ -218,9 +218,6 @@ static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
 static inline unsigned int cpu_mask_to_apicid_and(const struct cpumask *inmask,
 						  const struct cpumask *andmask)
 {
-	int num_bits_set;
-	int cpus_found = 0;
-	int cpu;
 	int apicid = cpu_to_logical_apicid(0);
 	cpumask_var_t cpumask;
 
@@ -229,31 +226,8 @@ static inline unsigned int cpu_mask_to_apicid_and(const struct cpumask *inmask,
 
 	cpumask_and(cpumask, inmask, andmask);
 	cpumask_and(cpumask, cpumask, cpu_online_mask);
+	apicid = cpu_mask_to_apicid(cpumask);
 
-	num_bits_set = cpumask_weight(cpumask);
-	/* Return id to all */
-	if (num_bits_set == NR_CPUS)
-		goto exit;
-	/*
-	 * The cpus in the mask must all be on the apic cluster.  If are not
-	 * on the same apicid cluster return default value of TARGET_CPUS.
-	 */
-	cpu = cpumask_first(cpumask);
-	apicid = cpu_to_logical_apicid(cpu);
-	while (cpus_found < num_bits_set) {
-		if (cpumask_test_cpu(cpu, cpumask)) {
-			int new_apicid = cpu_to_logical_apicid(cpu);
-			if (apicid_cluster(apicid) !=
-					apicid_cluster(new_apicid)){
-				printk ("%s: Not a valid mask!\n", __func__);
-				return cpu_to_logical_apicid(0);
-			}
-			apicid = new_apicid;
-			cpus_found++;
-		}
-		cpu++;
-	}
-exit:
 	free_cpumask_var(cpumask);
 	return apicid;
 }
diff --git a/arch/x86/include/asm/lguest.h b/arch/x86/include/asm/lguest.h
index d28a507..1caf576 100644
--- a/arch/x86/include/asm/lguest.h
+++ b/arch/x86/include/asm/lguest.h
@@ -15,7 +15,7 @@
 #define SHARED_SWITCHER_PAGES \
 	DIV_ROUND_UP(end_switcher_text - start_switcher_text, PAGE_SIZE)
 /* Pages for switcher itself, then two pages per cpu */
-#define TOTAL_SWITCHER_PAGES (SHARED_SWITCHER_PAGES + 2 * NR_CPUS)
+#define TOTAL_SWITCHER_PAGES (SHARED_SWITCHER_PAGES + 2 * nr_cpu_ids)
 
 /* We map at -4M for ease of mapping into the guest (one PTE page). */
 #define SWITCHER_ADDR 0xFFC00000
diff --git a/arch/x86/include/asm/numaq/apic.h b/arch/x86/include/asm/numaq/apic.h
index c80f00d..bf37bc4 100644
--- a/arch/x86/include/asm/numaq/apic.h
+++ b/arch/x86/include/asm/numaq/apic.h
@@ -63,8 +63,8 @@ static inline physid_mask_t ioapic_phys_id_map(physid_mask_t phys_map)
 extern u8 cpu_2_logical_apicid[];
 static inline int cpu_to_logical_apicid(int cpu)
 {
-       if (cpu >= NR_CPUS)
-	       return BAD_APICID;
+	if (cpu >= nr_cpu_ids)
+		return BAD_APICID;
 	return (int)cpu_2_logical_apicid[cpu];
 }
 
diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index 66834c4..a977de2 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -102,9 +102,9 @@ extern void pci_iommu_alloc(void);
 
 #ifdef CONFIG_NUMA
 /* Returns the node based on pci bus */
-static inline int __pcibus_to_node(struct pci_bus *bus)
+static inline int __pcibus_to_node(const struct pci_bus *bus)
 {
-	struct pci_sysdata *sd = bus->sysdata;
+	const struct pci_sysdata *sd = bus->sysdata;
 
 	return sd->node;
 }
@@ -113,6 +113,12 @@ static inline cpumask_t __pcibus_to_cpumask(struct pci_bus *bus)
 {
 	return node_to_cpumask(__pcibus_to_node(bus));
 }
+
+static inline const struct cpumask *
+cpumask_of_pcibus(const struct pci_bus *bus)
+{
+	return cpumask_of_node(__pcibus_to_node(bus));
+}
 #endif
 
 #endif /* _ASM_X86_PCI_H */
diff --git a/arch/x86/include/asm/summit/apic.h b/arch/x86/include/asm/summit/apic.h
index 99327d1..4bb5fb3 100644
--- a/arch/x86/include/asm/summit/apic.h
+++ b/arch/x86/include/asm/summit/apic.h
@@ -52,7 +52,7 @@ static inline void init_apic_ldr(void)
 	int i;
 
 	/* Create logical APIC IDs by counting CPUs already in cluster. */
-	for (count = 0, i = NR_CPUS; --i >= 0; ) {
+	for (count = 0, i = nr_cpu_ids; --i >= 0; ) {
 		lid = cpu_2_logical_apicid[i];
 		if (lid != BAD_APICID && apicid_cluster(lid) == my_cluster)
 			++count;
@@ -97,8 +97,8 @@ static inline int apicid_to_node(int logical_apicid)
 static inline int cpu_to_logical_apicid(int cpu)
 {
 #ifdef CONFIG_SMP
-       if (cpu >= NR_CPUS)
-	       return BAD_APICID;
+	if (cpu >= nr_cpu_ids)
+		return BAD_APICID;
 	return (int)cpu_2_logical_apicid[cpu];
 #else
 	return logical_smp_processor_id();
@@ -107,7 +107,7 @@ static inline int cpu_to_logical_apicid(int cpu)
 
 static inline int cpu_present_to_apicid(int mps_cpu)
 {
-	if (mps_cpu < NR_CPUS)
+	if (mps_cpu < nr_cpu_ids)
 		return (int)per_cpu(x86_bios_cpu_apicid, mps_cpu);
 	else
 		return BAD_APICID;
@@ -146,7 +146,7 @@ static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
 
 	num_bits_set = cpus_weight(*cpumask);
 	/* Return id to all */
-	if (num_bits_set == NR_CPUS)
+	if (num_bits_set >= nr_cpu_ids)
 		return (int) 0xFF;
 	/*
 	 * The cpus in the mask must all be on the apic cluster.  If are not
@@ -173,42 +173,16 @@ static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
 static inline unsigned int cpu_mask_to_apicid_and(const struct cpumask *inmask,
 						  const struct cpumask *andmask)
 {
-	int num_bits_set;
-	int cpus_found = 0;
-	int cpu;
-	int apicid = 0xFF;
+	int apicid = cpu_to_logical_apicid(0);
 	cpumask_var_t cpumask;
 
 	if (!alloc_cpumask_var(&cpumask, GFP_ATOMIC))
-		return (int) 0xFF;
+		return apicid;
 
 	cpumask_and(cpumask, inmask, andmask);
 	cpumask_and(cpumask, cpumask, cpu_online_mask);
+	apicid = cpu_mask_to_apicid(cpumask);
 
-	num_bits_set = cpumask_weight(cpumask);
-	/* Return id to all */
-	if (num_bits_set == nr_cpu_ids)
-		goto exit;
-	/*
-	 * The cpus in the mask must all be on the apic cluster.  If are not
-	 * on the same apicid cluster return default value of TARGET_CPUS.
-	 */
-	cpu = cpumask_first(cpumask);
-	apicid = cpu_to_logical_apicid(cpu);
-	while (cpus_found < num_bits_set) {
-		if (cpumask_test_cpu(cpu, cpumask)) {
-			int new_apicid = cpu_to_logical_apicid(cpu);
-			if (apicid_cluster(apicid) !=
-					apicid_cluster(new_apicid)){
-				printk ("%s: Not a valid mask!\n", __func__);
-				return 0xFF;
-			}
-			apicid = apicid | new_apicid;
-			cpus_found++;
-		}
-		cpu++;
-	}
-exit:
 	free_cpumask_var(cpumask);
 	return apicid;
 }
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 79e31e9..4e2f2e0 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -61,13 +61,19 @@ static inline int cpu_to_node(int cpu)
  *
  * Side note: this function creates the returned cpumask on the stack
  * so with a high NR_CPUS count, excessive stack space is used.  The
- * node_to_cpumask_ptr function should be used whenever possible.
+ * cpumask_of_node function should be used whenever possible.
  */
 static inline cpumask_t node_to_cpumask(int node)
 {
 	return node_to_cpumask_map[node];
 }
 
+/* Returns a bitmask of CPUs on Node 'node'. */
+static inline const struct cpumask *cpumask_of_node(int node)
+{
+	return &node_to_cpumask_map[node];
+}
+
 #else /* CONFIG_X86_64 */
 
 /* Mappings between node number and cpus on that node. */
@@ -82,7 +88,7 @@ DECLARE_EARLY_PER_CPU(int, x86_cpu_to_node_map);
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
 extern int cpu_to_node(int cpu);
 extern int early_cpu_to_node(int cpu);
-extern const cpumask_t *_node_to_cpumask_ptr(int node);
+extern const cpumask_t *cpumask_of_node(int node);
 extern cpumask_t node_to_cpumask(int node);
 
 #else	/* !CONFIG_DEBUG_PER_CPU_MAPS */
@@ -103,7 +109,7 @@ static inline int early_cpu_to_node(int cpu)
 }
 
 /* Returns a pointer to the cpumask of CPUs on Node 'node'. */
-static inline const cpumask_t *_node_to_cpumask_ptr(int node)
+static inline const cpumask_t *cpumask_of_node(int node)
 {
 	return &node_to_cpumask_map[node];
 }
@@ -116,12 +122,15 @@ static inline cpumask_t node_to_cpumask(int node)
 
 #endif /* !CONFIG_DEBUG_PER_CPU_MAPS */
 
-/* Replace default node_to_cpumask_ptr with optimized version */
+/*
+ * Replace default node_to_cpumask_ptr with optimized version
+ * Deprecated: use "const struct cpumask *mask = cpumask_of_node(node)"
+ */
 #define node_to_cpumask_ptr(v, node)		\
-		const cpumask_t *v = _node_to_cpumask_ptr(node)
+		const cpumask_t *v = cpumask_of_node(node)
 
 #define node_to_cpumask_ptr_next(v, node)	\
-			   v = _node_to_cpumask_ptr(node)
+			   v = cpumask_of_node(node)
 
 #endif /* CONFIG_X86_64 */
 
@@ -187,7 +196,7 @@ extern int __node_distance(int, int);
 #define	cpu_to_node(cpu)	0
 #define	early_cpu_to_node(cpu)	0
 
-static inline const cpumask_t *_node_to_cpumask_ptr(int node)
+static inline const cpumask_t *cpumask_of_node(int node)
 {
 	return &cpu_online_map;
 }
@@ -200,12 +209,15 @@ static inline int node_to_first_cpu(int node)
 	return first_cpu(cpu_online_map);
 }
 
-/* Replace default node_to_cpumask_ptr with optimized version */
+/*
+ * Replace default node_to_cpumask_ptr with optimized version
+ * Deprecated: use "const struct cpumask *mask = cpumask_of_node(node)"
+ */
 #define node_to_cpumask_ptr(v, node)		\
-		const cpumask_t *v = _node_to_cpumask_ptr(node)
+		const cpumask_t *v = cpumask_of_node(node)
 
 #define node_to_cpumask_ptr_next(v, node)	\
-			   v = _node_to_cpumask_ptr(node)
+			   v = cpumask_of_node(node)
 #endif
 
 #include <asm-generic/topology.h>
@@ -214,12 +226,12 @@ static inline int node_to_first_cpu(int node)
 /* Returns the number of the first CPU on Node 'node'. */
 static inline int node_to_first_cpu(int node)
 {
-	node_to_cpumask_ptr(mask, node);
-	return first_cpu(*mask);
+	return cpumask_first(cpumask_of_node(node));
 }
 #endif
 
 extern cpumask_t cpu_coregroup_map(int cpu);
+extern const struct cpumask *cpu_coregroup_mask(int cpu);
 
 #ifdef ENABLE_TOPO_DEFINES
 #define topology_physical_package_id(cpu)	(cpu_data(cpu).phys_proc_id)
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 65d0b72..29dc0c8 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -538,9 +538,10 @@ static int __cpuinit _acpi_map_lsapic(acpi_handle handle, int *pcpu)
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 	union acpi_object *obj;
 	struct acpi_madt_local_apic *lapic;
-	cpumask_t tmp_map, new_map;
+	cpumask_var_t tmp_map, new_map;
 	u8 physid;
 	int cpu;
+	int retval = -ENOMEM;
 
 	if (ACPI_FAILURE(acpi_evaluate_object(handle, "_MAT", NULL, &buffer)))
 		return -EINVAL;
@@ -569,23 +570,37 @@ static int __cpuinit _acpi_map_lsapic(acpi_handle handle, int *pcpu)
 	buffer.length = ACPI_ALLOCATE_BUFFER;
 	buffer.pointer = NULL;
 
-	tmp_map = cpu_present_map;
+	if (!alloc_cpumask_var(&tmp_map, GFP_KERNEL))
+		goto out;
+
+	if (!alloc_cpumask_var(&new_map, GFP_KERNEL))
+		goto free_tmp_map;
+
+	cpumask_copy(tmp_map, cpu_present_mask);
 	acpi_register_lapic(physid, lapic->lapic_flags & ACPI_MADT_ENABLED);
 
 	/*
 	 * If mp_register_lapic successfully generates a new logical cpu
 	 * number, then the following will get us exactly what was mapped
 	 */
-	cpus_andnot(new_map, cpu_present_map, tmp_map);
-	if (cpus_empty(new_map)) {
+	cpumask_andnot(new_map, cpu_present_mask, tmp_map);
+	if (cpumask_empty(new_map)) {
 		printk ("Unable to map lapic to logical cpu number\n");
-		return -EINVAL;
+		retval = -EINVAL;
+		goto free_new_map;
 	}
 
-	cpu = first_cpu(new_map);
+	cpu = cpumask_first(new_map);
 
 	*pcpu = cpu;
-	return 0;
+	retval = 0;
+
+free_new_map:
+	free_cpumask_var(new_map);
+free_tmp_map:
+	free_cpumask_var(tmp_map);
+out:
+	return retval;
 }
 
 /* wrapper to silence section mismatch warning */
@@ -598,7 +613,7 @@ EXPORT_SYMBOL(acpi_map_lsapic);
 int acpi_unmap_lsapic(int cpu)
 {
 	per_cpu(x86_cpu_to_apicid, cpu) = -1;
-	cpu_clear(cpu, cpu_present_map);
+	set_cpu_present(cpu, false);
 	num_processors--;
 
 	return (0);
diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index 6b7f824..9958924 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -140,7 +140,7 @@ static int lapic_next_event(unsigned long delta,
 			    struct clock_event_device *evt);
 static void lapic_timer_setup(enum clock_event_mode mode,
 			      struct clock_event_device *evt);
-static void lapic_timer_broadcast(const cpumask_t *mask);
+static void lapic_timer_broadcast(const struct cpumask *mask);
 static void apic_pm_activate(void);
 
 /*
@@ -453,7 +453,7 @@ static void lapic_timer_setup(enum clock_event_mode mode,
 /*
  * Local APIC timer broadcast function
  */
-static void lapic_timer_broadcast(const cpumask_t *mask)
+static void lapic_timer_broadcast(const struct cpumask *mask)
 {
 #ifdef CONFIG_SMP
 	send_IPI_mask(mask, LOCAL_TIMER_VECTOR);
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 42e0853..3f95a40 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -355,7 +355,7 @@ void __cpuinit detect_ht(struct cpuinfo_x86 *c)
 		printk(KERN_INFO  "CPU: Hyper-Threading is disabled\n");
 	} else if (smp_num_siblings > 1) {
 
-		if (smp_num_siblings > NR_CPUS) {
+		if (smp_num_siblings > nr_cpu_ids) {
 			printk(KERN_WARNING "CPU: Unsupported number of siblings %d",
 					smp_num_siblings);
 			smp_num_siblings = 1;
diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 88ea02d..28102ad 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -517,6 +517,17 @@ acpi_cpufreq_guess_freq(struct acpi_cpufreq_data *data, unsigned int cpu)
 	}
 }
 
+static void free_acpi_perf_data(void)
+{
+	unsigned int i;
+
+	/* Freeing a NULL pointer is OK, and alloc_percpu zeroes. */
+	for_each_possible_cpu(i)
+		free_cpumask_var(per_cpu_ptr(acpi_perf_data, i)
+				 ->shared_cpu_map);
+	free_percpu(acpi_perf_data);
+}
+
 /*
  * acpi_cpufreq_early_init - initialize ACPI P-States library
  *
@@ -527,6 +538,7 @@ acpi_cpufreq_guess_freq(struct acpi_cpufreq_data *data, unsigned int cpu)
  */
 static int __init acpi_cpufreq_early_init(void)
 {
+	unsigned int i;
 	dprintk("acpi_cpufreq_early_init\n");
 
 	acpi_perf_data = alloc_percpu(struct acpi_processor_performance);
@@ -534,6 +546,16 @@ static int __init acpi_cpufreq_early_init(void)
 		dprintk("Memory allocation error for acpi_perf_data.\n");
 		return -ENOMEM;
 	}
+	for_each_possible_cpu(i) {
+		if (!alloc_cpumask_var_node(
+			&per_cpu_ptr(acpi_perf_data, i)->shared_cpu_map,
+			GFP_KERNEL, cpu_to_node(i))) {
+
+			/* Freeing a NULL pointer is OK: alloc_percpu zeroes. */
+			free_acpi_perf_data();
+			return -ENOMEM;
+		}
+	}
 
 	/* Do initialization in ACPI core */
 	acpi_processor_preregister_performance(acpi_perf_data);
@@ -604,9 +626,9 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	 */
 	if (policy->shared_type == CPUFREQ_SHARED_TYPE_ALL ||
 	    policy->shared_type == CPUFREQ_SHARED_TYPE_ANY) {
-		policy->cpus = perf->shared_cpu_map;
+		cpumask_copy(&policy->cpus, perf->shared_cpu_map);
 	}
-	policy->related_cpus = perf->shared_cpu_map;
+	cpumask_copy(&policy->related_cpus, perf->shared_cpu_map);
 
 #ifdef CONFIG_SMP
 	dmi_check_system(sw_any_bug_dmi_table);
@@ -795,7 +817,7 @@ static int __init acpi_cpufreq_init(void)
 
 	ret = cpufreq_register_driver(&acpi_cpufreq_driver);
 	if (ret)
-		free_percpu(acpi_perf_data);
+		free_acpi_perf_data();
 
 	return ret;
 }
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k7.c b/arch/x86/kernel/cpu/cpufreq/powernow-k7.c
index 7c7d56b..1b446d7 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k7.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k7.c
@@ -310,6 +310,12 @@ static int powernow_acpi_init(void)
 		goto err0;
 	}
 
+	if (!alloc_cpumask_var(&acpi_processor_perf->shared_cpu_map,
+								GFP_KERNEL)) {
+		retval = -ENOMEM;
+		goto err05;
+	}
+
 	if (acpi_processor_register_performance(acpi_processor_perf, 0)) {
 		retval = -EIO;
 		goto err1;
@@ -412,6 +418,8 @@ static int powernow_acpi_init(void)
 err2:
 	acpi_processor_unregister_performance(acpi_processor_perf, 0);
 err1:
+	free_cpumask_var(acpi_processor_perf->shared_cpu_map);
+err05:
 	kfree(acpi_processor_perf);
 err0:
 	printk(KERN_WARNING PFX "ACPI perflib can not be used in this platform\n");
@@ -652,6 +660,7 @@ static int powernow_cpu_exit (struct cpufreq_policy *policy) {
 #ifdef CONFIG_X86_POWERNOW_K7_ACPI
 	if (acpi_processor_perf) {
 		acpi_processor_unregister_performance(acpi_processor_perf, 0);
+		free_cpumask_var(acpi_processor_perf->shared_cpu_map);
 		kfree(acpi_processor_perf);
 	}
 #endif
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 7f05f44..c3c9adb 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -766,7 +766,7 @@ static void powernow_k8_acpi_pst_values(struct powernow_k8_data *data, unsigned
 static int powernow_k8_cpu_init_acpi(struct powernow_k8_data *data)
 {
 	struct cpufreq_frequency_table *powernow_table;
-	int ret_val;
+	int ret_val = -ENODEV;
 
 	if (acpi_processor_register_performance(&data->acpi_data, data->cpu)) {
 		dprintk("register performance failed: bad ACPI data\n");
@@ -815,6 +815,13 @@ static int powernow_k8_cpu_init_acpi(struct powernow_k8_data *data)
 	/* notify BIOS that we exist */
 	acpi_processor_notify_smm(THIS_MODULE);
 
+	if (!alloc_cpumask_var(&data->acpi_data.shared_cpu_map, GFP_KERNEL)) {
+		printk(KERN_ERR PFX
+				"unable to alloc powernow_k8_data cpumask\n");
+		ret_val = -ENOMEM;
+		goto err_out_mem;
+	}
+
 	return 0;
 
 err_out_mem:
@@ -826,7 +833,7 @@ err_out:
 	/* data->acpi_data.state_count informs us at ->exit() whether ACPI was used */
 	data->acpi_data.state_count = 0;
 
-	return -ENODEV;
+	return ret_val;
 }
 
 static int fill_powernow_table_pstate(struct powernow_k8_data *data, struct cpufreq_frequency_table *powernow_table)
@@ -929,6 +936,7 @@ static void powernow_k8_cpu_exit_acpi(struct powernow_k8_data *data)
 {
 	if (data->acpi_data.state_count)
 		acpi_processor_unregister_performance(&data->acpi_data, data->cpu);
+	free_cpumask_var(data->acpi_data.shared_cpu_map);
 }
 
 #else
@@ -1134,7 +1142,8 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 	data->cpu = pol->cpu;
 	data->currpstate = HW_PSTATE_INVALID;
 
-	if (powernow_k8_cpu_init_acpi(data)) {
+	rc = powernow_k8_cpu_init_acpi(data);
+	if (rc) {
 		/*
 		 * Use the PSB BIOS structure. This is only availabe on
 		 * an UP version, and is deprecated by AMD.
@@ -1152,20 +1161,17 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 			       "ACPI maintainers and complain to your BIOS "
 			       "vendor.\n");
 #endif
-			kfree(data);
-			return -ENODEV;
+			goto err_out;
 		}
 		if (pol->cpu != 0) {
 			printk(KERN_ERR FW_BUG PFX "No ACPI _PSS objects for "
 			       "CPU other than CPU0. Complain to your BIOS "
 			       "vendor.\n");
-			kfree(data);
-			return -ENODEV;
+			goto err_out;
 		}
 		rc = find_psb_table(data);
 		if (rc) {
-			kfree(data);
-			return -ENODEV;
+			goto err_out;
 		}
 	}
 
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index c6ecda6..48533d7 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -534,7 +534,7 @@ static void __cpuinit free_cache_attributes(unsigned int cpu)
 	per_cpu(cpuid4_info, cpu) = NULL;
 }
 
-static void get_cpu_leaves(void *_retval)
+static void __cpuinit get_cpu_leaves(void *_retval)
 {
 	int j, *retval = _retval, cpu = smp_processor_id();
 
diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
index 72cefd1..62a3c23 100644
--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -121,7 +121,7 @@ static int cpuid_open(struct inode *inode, struct file *file)
 	lock_kernel();
 
 	cpu = iminor(file->f_path.dentry->d_inode);
-	if (cpu >= NR_CPUS || !cpu_online(cpu)) {
+	if (cpu >= nr_cpu_ids || !cpu_online(cpu)) {
 		ret = -ENXIO;	/* No such CPU */
 		goto out;
 	}
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 62ecfc9..37715bb 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -214,11 +214,11 @@ static struct irq_cfg *get_one_free_irq_cfg(int cpu)
 
 	cfg = kzalloc_node(sizeof(*cfg), GFP_ATOMIC, node);
 	if (cfg) {
-		/* FIXME: needs alloc_cpumask_var_node() */
-		if (!alloc_cpumask_var(&cfg->domain, GFP_ATOMIC)) {
+		if (!alloc_cpumask_var_node(&cfg->domain, GFP_ATOMIC, node)) {
 			kfree(cfg);
 			cfg = NULL;
-		} else if (!alloc_cpumask_var(&cfg->old_domain, GFP_ATOMIC)) {
+		} else if (!alloc_cpumask_var_node(&cfg->old_domain,
+							  GFP_ATOMIC, node)) {
 			free_cpumask_var(cfg->domain);
 			kfree(cfg);
 			cfg = NULL;
diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 82a7c7e..7262666 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -136,7 +136,7 @@ static int msr_open(struct inode *inode, struct file *file)
 	lock_kernel();
 	cpu = iminor(file->f_path.dentry->d_inode);
 
-	if (cpu >= NR_CPUS || !cpu_online(cpu)) {
+	if (cpu >= nr_cpu_ids || !cpu_online(cpu)) {
 		ret = -ENXIO;	/* No such CPU */
 		goto out;
 	}
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 39643b1..bc1535e 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -501,7 +501,7 @@ void native_machine_shutdown(void)
 
 #ifdef CONFIG_X86_32
 	/* See if there has been given a command line override */
-	if ((reboot_cpu != -1) && (reboot_cpu < NR_CPUS) &&
+	if ((reboot_cpu != -1) && (reboot_cpu < nr_cpu_ids) &&
 		cpu_online(reboot_cpu))
 		reboot_cpu_id = reboot_cpu;
 #endif
@@ -511,7 +511,7 @@ void native_machine_shutdown(void)
 		reboot_cpu_id = smp_processor_id();
 
 	/* Make certain I only run on the appropriate processor */
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(reboot_cpu_id));
+	set_cpus_allowed_ptr(current, cpumask_of(reboot_cpu_id));
 
 	/* O.K Now that I'm on the appropriate processor,
 	 * stop all of the others.
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 0b63b08..a4b619c 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -153,12 +153,10 @@ void __init setup_per_cpu_areas(void)
 	align = max_t(unsigned long, PAGE_SIZE, align);
 	size = roundup(old_size, align);
 
-	printk(KERN_INFO
-		"NR_CPUS:%d nr_cpumask_bits:%d nr_cpu_ids:%d nr_node_ids:%d\n",
+	pr_info("NR_CPUS:%d nr_cpumask_bits:%d nr_cpu_ids:%d nr_node_ids:%d\n",
 		NR_CPUS, nr_cpumask_bits, nr_cpu_ids, nr_node_ids);
 
-	printk(KERN_INFO "PERCPU: Allocating %zd bytes of per cpu data\n",
-			  size);
+	pr_info("PERCPU: Allocating %zd bytes of per cpu data\n", size);
 
 	for_each_possible_cpu(cpu) {
 #ifndef CONFIG_NEED_MULTIPLE_NODES
@@ -169,22 +167,15 @@ void __init setup_per_cpu_areas(void)
 		if (!node_online(node) || !NODE_DATA(node)) {
 			ptr = __alloc_bootmem(size, align,
 					 __pa(MAX_DMA_ADDRESS));
-			printk(KERN_INFO
-			       "cpu %d has no node %d or node-local memory\n",
+			pr_info("cpu %d has no node %d or node-local memory\n",
 				cpu, node);
-			if (ptr)
-				printk(KERN_DEBUG
-					"per cpu data for cpu%d at %016lx\n",
-					 cpu, __pa(ptr));
-		}
-		else {
+			pr_debug("per cpu data for cpu%d at %016lx\n",
+				 cpu, __pa(ptr));
+		} else {
 			ptr = __alloc_bootmem_node(NODE_DATA(node), size, align,
 							__pa(MAX_DMA_ADDRESS));
-			if (ptr)
-				printk(KERN_DEBUG
-					"per cpu data for cpu%d on node%d "
-					"at %016lx\n",
-					cpu, node, __pa(ptr));
+			pr_debug("per cpu data for cpu%d on node%d at %016lx\n",
+				cpu, node, __pa(ptr));
 		}
 #endif
 		per_cpu_offset(cpu) = ptr - __per_cpu_start;
@@ -339,25 +330,25 @@ static const cpumask_t cpu_mask_none;
 /*
  * Returns a pointer to the bitmask of CPUs on Node 'node'.
  */
-const cpumask_t *_node_to_cpumask_ptr(int node)
+const cpumask_t *cpumask_of_node(int node)
 {
 	if (node_to_cpumask_map == NULL) {
 		printk(KERN_WARNING
-			"_node_to_cpumask_ptr(%d): no node_to_cpumask_map!\n",
+			"cpumask_of_node(%d): no node_to_cpumask_map!\n",
 			node);
 		dump_stack();
 		return (const cpumask_t *)&cpu_online_map;
 	}
 	if (node >= nr_node_ids) {
 		printk(KERN_WARNING
-			"_node_to_cpumask_ptr(%d): node > nr_node_ids(%d)\n",
+			"cpumask_of_node(%d): node > nr_node_ids(%d)\n",
 			node, nr_node_ids);
 		dump_stack();
 		return &cpu_mask_none;
 	}
 	return &node_to_cpumask_map[node];
 }
-EXPORT_SYMBOL(_node_to_cpumask_ptr);
+EXPORT_SYMBOL(cpumask_of_node);
 
 /*
  * Returns a bitmask of CPUs on Node 'node'.
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 31869bf..6bd4d9b 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -496,7 +496,7 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 }
 
 /* maps the cpu to the sched domain representing multi-core */
-cpumask_t cpu_coregroup_map(int cpu)
+const struct cpumask *cpu_coregroup_mask(int cpu)
 {
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	/*
@@ -504,9 +504,14 @@ cpumask_t cpu_coregroup_map(int cpu)
 	 * And for power savings, we return cpu_core_map
 	 */
 	if (sched_mc_power_savings || sched_smt_power_savings)
-		return per_cpu(cpu_core_map, cpu);
+		return &per_cpu(cpu_core_map, cpu);
 	else
-		return c->llc_shared_map;
+		return &c->llc_shared_map;
+}
+
+cpumask_t cpu_coregroup_map(int cpu)
+{
+	return *cpu_coregroup_mask(cpu);
 }
 
 static void impress_friends(void)
@@ -1149,7 +1154,7 @@ static void __init smp_cpu_index_default(void)
 	for_each_possible_cpu(i) {
 		c = &cpu_data(i);
 		/* mark all to hotplug */
-		c->cpu_index = NR_CPUS;
+		c->cpu_index = nr_cpu_ids;
 	}
 }
 
@@ -1293,6 +1298,8 @@ __init void prefill_possible_map(void)
 	else
 		possible = setup_possible_cpus;
 
+	total_cpus = max_t(int, possible, num_processors + disabled_cpus);
+
 	if (possible > CONFIG_NR_CPUS) {
 		printk(KERN_WARNING
 			"%d Processors exceeds NR_CPUS limit of %d\n",
diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index a5bc054..9840b7e 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -357,9 +357,8 @@ void __init find_smp_config(void)
 	printk("VOYAGER SMP: Boot cpu is %d\n", boot_cpu_id);
 
 	/* initialize the CPU structures (moved from smp_boot_cpus) */
-	for (i = 0; i < NR_CPUS; i++) {
+	for (i = 0; i < nr_cpu_ids; i++)
 		cpu_irq_affinity[i] = ~0;
-	}
 	cpu_online_map = cpumask_of_cpu(boot_cpu_id);
 
 	/* The boot CPU must be extended */
@@ -1227,7 +1226,7 @@ int setup_profiling_timer(unsigned int multiplier)
 	 * new values until the next timer interrupt in which they do process
 	 * accounting.
 	 */
-	for (i = 0; i < NR_CPUS; ++i)
+	for (i = 0; i < nr_cpu_ids; ++i)
 		per_cpu(prof_multiplier, i) = multiplier;
 
 	return 0;
@@ -1257,7 +1256,7 @@ void __init voyager_smp_intr_init(void)
 	int i;
 
 	/* initialize the per cpu irq mask to all disabled */
-	for (i = 0; i < NR_CPUS; i++)
+	for (i = 0; i < nr_cpu_ids; i++)
 		vic_irq_mask[i] = 0xFFFF;
 
 	VIC_SET_GATE(VIC_CPI_LEVEL0, vic_cpi_interrupt);
diff --git a/block/blk.h b/block/blk.h
index d2e49af..6e1ed40 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -99,8 +99,8 @@ static inline int queue_congestion_off_threshold(struct request_queue *q)
 static inline int blk_cpu_to_group(int cpu)
 {
 #ifdef CONFIG_SCHED_MC
-	cpumask_t mask = cpu_coregroup_map(cpu);
-	return first_cpu(mask);
+	const struct cpumask *mask = cpu_coregroup_mask(cpu);
+	return cpumask_first(mask);
 #elif defined(CONFIG_SCHED_SMT)
 	return first_cpu(per_cpu(cpu_sibling_map, cpu));
 #else
diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 3494836..0cc2fd3 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -826,6 +826,11 @@ static int acpi_processor_add(struct acpi_device *device)
 	if (!pr)
 		return -ENOMEM;
 
+	if (!alloc_cpumask_var(&pr->throttling.shared_cpu_map, GFP_KERNEL)) {
+		kfree(pr);
+		return -ENOMEM;
+	}
+
 	pr->handle = device->handle;
 	strcpy(acpi_device_name(device), ACPI_PROCESSOR_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_PROCESSOR_CLASS);
@@ -845,10 +850,8 @@ static int acpi_processor_remove(struct acpi_device *device, int type)
 
 	pr = acpi_driver_data(device);
 
-	if (pr->id >= nr_cpu_ids) {
-		kfree(pr);
-		return 0;
-	}
+	if (pr->id >= nr_cpu_ids)
+		goto free;
 
 	if (type == ACPI_BUS_REMOVAL_EJECT) {
 		if (acpi_processor_handle_eject(pr))
@@ -873,6 +876,9 @@ static int acpi_processor_remove(struct acpi_device *device, int type)
 
 	per_cpu(processors, pr->id) = NULL;
 	per_cpu(processor_device_array, pr->id) = NULL;
+
+free:
+	free_cpumask_var(pr->throttling.shared_cpu_map);
 	kfree(pr);
 
 	return 0;
diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
index 0d7b772..846e227 100644
--- a/drivers/acpi/processor_perflib.c
+++ b/drivers/acpi/processor_perflib.c
@@ -588,12 +588,15 @@ int acpi_processor_preregister_performance(
 	int count, count_target;
 	int retval = 0;
 	unsigned int i, j;
-	cpumask_t covered_cpus;
+	cpumask_var_t covered_cpus;
 	struct acpi_processor *pr;
 	struct acpi_psd_package *pdomain;
 	struct acpi_processor *match_pr;
 	struct acpi_psd_package *match_pdomain;
 
+	if (!alloc_cpumask_var(&covered_cpus, GFP_KERNEL))
+		return -ENOMEM;
+
 	mutex_lock(&performance_mutex);
 
 	retval = 0;
@@ -617,7 +620,7 @@ int acpi_processor_preregister_performance(
 		}
 
 		pr->performance = percpu_ptr(performance, i);
-		cpu_set(i, pr->performance->shared_cpu_map);
+		cpumask_set_cpu(i, pr->performance->shared_cpu_map);
 		if (acpi_processor_get_psd(pr)) {
 			retval = -EINVAL;
 			continue;
@@ -650,18 +653,18 @@ int acpi_processor_preregister_performance(
 		}
 	}
 
-	cpus_clear(covered_cpus);
+	cpumask_clear(covered_cpus);
 	for_each_possible_cpu(i) {
 		pr = per_cpu(processors, i);
 		if (!pr)
 			continue;
 
-		if (cpu_isset(i, covered_cpus))
+		if (cpumask_test_cpu(i, covered_cpus))
 			continue;
 
 		pdomain = &(pr->performance->domain_info);
-		cpu_set(i, pr->performance->shared_cpu_map);
-		cpu_set(i, covered_cpus);
+		cpumask_set_cpu(i, pr->performance->shared_cpu_map);
+		cpumask_set_cpu(i, covered_cpus);
 		if (pdomain->num_processors <= 1)
 			continue;
 
@@ -699,8 +702,8 @@ int acpi_processor_preregister_performance(
 				goto err_ret;
 			}
 
-			cpu_set(j, covered_cpus);
-			cpu_set(j, pr->performance->shared_cpu_map);
+			cpumask_set_cpu(j, covered_cpus);
+			cpumask_set_cpu(j, pr->performance->shared_cpu_map);
 			count++;
 		}
 
@@ -718,8 +721,8 @@ int acpi_processor_preregister_performance(
 
 			match_pr->performance->shared_type = 
 					pr->performance->shared_type;
-			match_pr->performance->shared_cpu_map =
-				pr->performance->shared_cpu_map;
+			cpumask_copy(match_pr->performance->shared_cpu_map,
+				     pr->performance->shared_cpu_map);
 		}
 	}
 
@@ -731,14 +734,15 @@ err_ret:
 
 		/* Assume no coordination on any error parsing domain info */
 		if (retval) {
-			cpus_clear(pr->performance->shared_cpu_map);
-			cpu_set(i, pr->performance->shared_cpu_map);
+			cpumask_clear(pr->performance->shared_cpu_map);
+			cpumask_set_cpu(i, pr->performance->shared_cpu_map);
 			pr->performance->shared_type = CPUFREQ_SHARED_TYPE_ALL;
 		}
 		pr->performance = NULL; /* Will be set for real in register */
 	}
 
 	mutex_unlock(&performance_mutex);
+	free_cpumask_var(covered_cpus);
 	return retval;
 }
 EXPORT_SYMBOL(acpi_processor_preregister_performance);
diff --git a/drivers/acpi/processor_throttling.c b/drivers/acpi/processor_throttling.c
index a0c38c9..d278381 100644
--- a/drivers/acpi/processor_throttling.c
+++ b/drivers/acpi/processor_throttling.c
@@ -61,11 +61,14 @@ static int acpi_processor_update_tsd_coord(void)
 	int count, count_target;
 	int retval = 0;
 	unsigned int i, j;
-	cpumask_t covered_cpus;
+	cpumask_var_t covered_cpus;
 	struct acpi_processor *pr, *match_pr;
 	struct acpi_tsd_package *pdomain, *match_pdomain;
 	struct acpi_processor_throttling *pthrottling, *match_pthrottling;
 
+	if (!alloc_cpumask_var(&covered_cpus, GFP_KERNEL))
+		return -ENOMEM;
+
 	/*
 	 * Now that we have _TSD data from all CPUs, lets setup T-state
 	 * coordination between all CPUs.
@@ -91,19 +94,19 @@ static int acpi_processor_update_tsd_coord(void)
 	if (retval)
 		goto err_ret;
 
-	cpus_clear(covered_cpus);
+	cpumask_clear(covered_cpus);
 	for_each_possible_cpu(i) {
 		pr = per_cpu(processors, i);
 		if (!pr)
 			continue;
 
-		if (cpu_isset(i, covered_cpus))
+		if (cpumask_test_cpu(i, covered_cpus))
 			continue;
 		pthrottling = &pr->throttling;
 
 		pdomain = &(pthrottling->domain_info);
-		cpu_set(i, pthrottling->shared_cpu_map);
-		cpu_set(i, covered_cpus);
+		cpumask_set_cpu(i, pthrottling->shared_cpu_map);
+		cpumask_set_cpu(i, covered_cpus);
 		/*
 		 * If the number of processor in the TSD domain is 1, it is
 		 * unnecessary to parse the coordination for this CPU.
@@ -144,8 +147,8 @@ static int acpi_processor_update_tsd_coord(void)
 				goto err_ret;
 			}
 
-			cpu_set(j, covered_cpus);
-			cpu_set(j, pthrottling->shared_cpu_map);
+			cpumask_set_cpu(j, covered_cpus);
+			cpumask_set_cpu(j, pthrottling->shared_cpu_map);
 			count++;
 		}
 		for_each_possible_cpu(j) {
@@ -165,12 +168,14 @@ static int acpi_processor_update_tsd_coord(void)
 			 * If some CPUS have the same domain, they
 			 * will have the same shared_cpu_map.
 			 */
-			match_pthrottling->shared_cpu_map =
-				pthrottling->shared_cpu_map;
+			cpumask_copy(match_pthrottling->shared_cpu_map,
+				     pthrottling->shared_cpu_map);
 		}
 	}
 
 err_ret:
+	free_cpumask_var(covered_cpus);
+
 	for_each_possible_cpu(i) {
 		pr = per_cpu(processors, i);
 		if (!pr)
@@ -182,8 +187,8 @@ err_ret:
 		 */
 		if (retval) {
 			pthrottling = &(pr->throttling);
-			cpus_clear(pthrottling->shared_cpu_map);
-			cpu_set(i, pthrottling->shared_cpu_map);
+			cpumask_clear(pthrottling->shared_cpu_map);
+			cpumask_set_cpu(i, pthrottling->shared_cpu_map);
 			pthrottling->shared_type = DOMAIN_COORD_TYPE_SW_ALL;
 		}
 	}
@@ -567,7 +572,7 @@ static int acpi_processor_get_tsd(struct acpi_processor *pr)
 	pthrottling = &pr->throttling;
 	pthrottling->tsd_valid_flag = 1;
 	pthrottling->shared_type = pdomain->coord_type;
-	cpu_set(pr->id, pthrottling->shared_cpu_map);
+	cpumask_set_cpu(pr->id, pthrottling->shared_cpu_map);
 	/*
 	 * If the coordination type is not defined in ACPI spec,
 	 * the tsd_valid_flag will be clear and coordination type
@@ -826,7 +831,7 @@ static int acpi_processor_get_throttling_ptc(struct acpi_processor *pr)
 
 static int acpi_processor_get_throttling(struct acpi_processor *pr)
 {
-	cpumask_t saved_mask;
+	cpumask_var_t saved_mask;
 	int ret;
 
 	if (!pr)
@@ -834,14 +839,20 @@ static int acpi_processor_get_throttling(struct acpi_processor *pr)
 
 	if (!pr->flags.throttling)
 		return -ENODEV;
+
+	if (!alloc_cpumask_var(&saved_mask, GFP_KERNEL))
+		return -ENOMEM;
+
 	/*
 	 * Migrate task to the cpu pointed by pr.
 	 */
-	saved_mask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(pr->id));
+	cpumask_copy(saved_mask, &current->cpus_allowed);
+	/* FIXME: use work_on_cpu() */
+	set_cpus_allowed_ptr(current, cpumask_of(pr->id));
 	ret = pr->throttling.acpi_processor_get_throttling(pr);
 	/* restore the previous state */
-	set_cpus_allowed_ptr(current, &saved_mask);
+	set_cpus_allowed_ptr(current, saved_mask);
+	free_cpumask_var(saved_mask);
 
 	return ret;
 }
@@ -986,13 +997,13 @@ static int acpi_processor_set_throttling_ptc(struct acpi_processor *pr,
 
 int acpi_processor_set_throttling(struct acpi_processor *pr, int state)
 {
-	cpumask_t saved_mask;
+	cpumask_var_t saved_mask;
 	int ret = 0;
 	unsigned int i;
 	struct acpi_processor *match_pr;
 	struct acpi_processor_throttling *p_throttling;
 	struct throttling_tstate t_state;
-	cpumask_t online_throttling_cpus;
+	cpumask_var_t online_throttling_cpus;
 
 	if (!pr)
 		return -EINVAL;
@@ -1003,17 +1014,25 @@ int acpi_processor_set_throttling(struct acpi_processor *pr, int state)
 	if ((state < 0) || (state > (pr->throttling.state_count - 1)))
 		return -EINVAL;
 
-	saved_mask = current->cpus_allowed;
+	if (!alloc_cpumask_var(&saved_mask, GFP_KERNEL))
+		return -ENOMEM;
+
+	if (!alloc_cpumask_var(&online_throttling_cpus, GFP_KERNEL)) {
+		free_cpumask_var(saved_mask);
+		return -ENOMEM;
+	}
+
+	cpumask_copy(saved_mask, &current->cpus_allowed);
 	t_state.target_state = state;
 	p_throttling = &(pr->throttling);
-	cpus_and(online_throttling_cpus, cpu_online_map,
-			p_throttling->shared_cpu_map);
+	cpumask_and(online_throttling_cpus, cpu_online_mask,
+		    p_throttling->shared_cpu_map);
 	/*
 	 * The throttling notifier will be called for every
 	 * affected cpu in order to get one proper T-state.
 	 * The notifier event is THROTTLING_PRECHANGE.
 	 */
-	for_each_cpu_mask_nr(i, online_throttling_cpus) {
+	for_each_cpu(i, online_throttling_cpus) {
 		t_state.cpu = i;
 		acpi_processor_throttling_notifier(THROTTLING_PRECHANGE,
 							&t_state);
@@ -1025,7 +1044,8 @@ int acpi_processor_set_throttling(struct acpi_processor *pr, int state)
 	 * it can be called only for the cpu pointed by pr.
 	 */
 	if (p_throttling->shared_type == DOMAIN_COORD_TYPE_SW_ANY) {
-		set_cpus_allowed_ptr(current, &cpumask_of_cpu(pr->id));
+		/* FIXME: use work_on_cpu() */
+		set_cpus_allowed_ptr(current, cpumask_of(pr->id));
 		ret = p_throttling->acpi_processor_set_throttling(pr,
 						t_state.target_state);
 	} else {
@@ -1034,7 +1054,7 @@ int acpi_processor_set_throttling(struct acpi_processor *pr, int state)
 		 * it is necessary to set T-state for every affected
 		 * cpus.
 		 */
-		for_each_cpu_mask_nr(i, online_throttling_cpus) {
+		for_each_cpu(i, online_throttling_cpus) {
 			match_pr = per_cpu(processors, i);
 			/*
 			 * If the pointer is invalid, we will report the
@@ -1056,7 +1076,8 @@ int acpi_processor_set_throttling(struct acpi_processor *pr, int state)
 				continue;
 			}
 			t_state.cpu = i;
-			set_cpus_allowed_ptr(current, &cpumask_of_cpu(i));
+			/* FIXME: use work_on_cpu() */
+			set_cpus_allowed_ptr(current, cpumask_of(i));
 			ret = match_pr->throttling.
 				acpi_processor_set_throttling(
 				match_pr, t_state.target_state);
@@ -1068,13 +1089,16 @@ int acpi_processor_set_throttling(struct acpi_processor *pr, int state)
 	 * affected cpu to update the T-states.
 	 * The notifier event is THROTTLING_POSTCHANGE
 	 */
-	for_each_cpu_mask_nr(i, online_throttling_cpus) {
+	for_each_cpu(i, online_throttling_cpus) {
 		t_state.cpu = i;
 		acpi_processor_throttling_notifier(THROTTLING_POSTCHANGE,
 							&t_state);
 	}
 	/* restore the previous state */
-	set_cpus_allowed_ptr(current, &saved_mask);
+	/* FIXME: use work_on_cpu() */
+	set_cpus_allowed_ptr(current, saved_mask);
+	free_cpumask_var(online_throttling_cpus);
+	free_cpumask_var(saved_mask);
 	return ret;
 }
 
@@ -1120,7 +1144,7 @@ int acpi_processor_get_throttling_info(struct acpi_processor *pr)
 	if (acpi_processor_get_tsd(pr)) {
 		pthrottling = &pr->throttling;
 		pthrottling->tsd_valid_flag = 0;
-		cpu_set(pr->id, pthrottling->shared_cpu_map);
+		cpumask_set_cpu(pr->id, pthrottling->shared_cpu_map);
 		pthrottling->shared_type = DOMAIN_COORD_TYPE_SW_ALL;
 	}
 
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 4259072..719ee5c 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -128,10 +128,54 @@ print_cpus_func(online);
 print_cpus_func(possible);
 print_cpus_func(present);
 
+/*
+ * Print values for NR_CPUS and offlined cpus
+ */
+static ssize_t print_cpus_kernel_max(struct sysdev_class *class, char *buf)
+{
+	int n = snprintf(buf, PAGE_SIZE-2, "%d\n", NR_CPUS - 1);
+	return n;
+}
+static SYSDEV_CLASS_ATTR(kernel_max, 0444, print_cpus_kernel_max, NULL);
+
+/* arch-optional setting to enable display of offline cpus >= nr_cpu_ids */
+unsigned int total_cpus;
+
+static ssize_t print_cpus_offline(struct sysdev_class *class, char *buf)
+{
+	int n = 0, len = PAGE_SIZE-2;
+	cpumask_var_t offline;
+
+	/* display offline cpus < nr_cpu_ids */
+	if (!alloc_cpumask_var(&offline, GFP_KERNEL))
+		return -ENOMEM;
+	cpumask_complement(offline, cpu_online_mask);
+	n = cpulist_scnprintf(buf, len, offline);
+	free_cpumask_var(offline);
+
+	/* display offline cpus >= nr_cpu_ids */
+	if (total_cpus && nr_cpu_ids < total_cpus) {
+		if (n && n < len)
+			buf[n++] = ',';
+
+		if (nr_cpu_ids == total_cpus-1)
+			n += snprintf(&buf[n], len - n, "%d", nr_cpu_ids);
+		else
+			n += snprintf(&buf[n], len - n, "%d-%d",
+						      nr_cpu_ids, total_cpus-1);
+	}
+
+	n += snprintf(&buf[n], len - n, "\n");
+	return n;
+}
+static SYSDEV_CLASS_ATTR(offline, 0444, print_cpus_offline, NULL);
+
 static struct sysdev_class_attribute *cpu_state_attr[] = {
 	&attr_online_map,
 	&attr_possible_map,
 	&attr_present_map,
+	&attr_kernel_max,
+	&attr_offline,
 };
 
 static int cpu_states_init(void)
diff --git a/drivers/infiniband/hw/ehca/ehca_irq.c b/drivers/infiniband/hw/ehca/ehca_irq.c
index 757035e..3128a50 100644
--- a/drivers/infiniband/hw/ehca/ehca_irq.c
+++ b/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -659,12 +659,12 @@ static inline int find_next_online_cpu(struct ehca_comp_pool *pool)
 
 	WARN_ON_ONCE(!in_interrupt());
 	if (ehca_debug_level >= 3)
-		ehca_dmp(&cpu_online_map, sizeof(cpumask_t), "");
+		ehca_dmp(cpu_online_mask, cpumask_size(), "");
 
 	spin_lock_irqsave(&pool->last_cpu_lock, flags);
-	cpu = next_cpu_nr(pool->last_cpu, cpu_online_map);
+	cpu = cpumask_next(pool->last_cpu, cpu_online_mask);
 	if (cpu >= nr_cpu_ids)
-		cpu = first_cpu(cpu_online_map);
+		cpu = cpumask_first(cpu_online_mask);
 	pool->last_cpu = cpu;
 	spin_unlock_irqrestore(&pool->last_cpu_lock, flags);
 
@@ -855,7 +855,7 @@ static int __cpuinit comp_pool_callback(struct notifier_block *nfb,
 	case CPU_UP_CANCELED_FROZEN:
 		ehca_gen_dbg("CPU: %x (CPU_CANCELED)", cpu);
 		cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu);
-		kthread_bind(cct->task, any_online_cpu(cpu_online_map));
+		kthread_bind(cct->task, cpumask_any(cpu_online_mask));
 		destroy_comp_task(pool, cpu);
 		break;
 	case CPU_ONLINE:
@@ -902,7 +902,7 @@ int ehca_create_comp_pool(void)
 		return -ENOMEM;
 
 	spin_lock_init(&pool->last_cpu_lock);
-	pool->last_cpu = any_online_cpu(cpu_online_map);
+	pool->last_cpu = cpumask_any(cpu_online_mask);
 
 	pool->cpu_comp_tasks = alloc_percpu(struct ehca_cpu_comp_task);
 	if (pool->cpu_comp_tasks == NULL) {
@@ -934,10 +934,9 @@ void ehca_destroy_comp_pool(void)
 
 	unregister_hotcpu_notifier(&comp_pool_callback_nb);
 
-	for (i = 0; i < NR_CPUS; i++) {
-		if (cpu_online(i))
-			destroy_comp_task(pool, i);
-	}
+	for_each_online_cpu(i)
+		destroy_comp_task(pool, i);
+
 	free_percpu(pool->cpu_comp_tasks);
 	kfree(pool);
 }
diff --git a/drivers/infiniband/hw/ipath/ipath_file_ops.c b/drivers/infiniband/hw/ipath/ipath_file_ops.c
index 239d4e8..2317398 100644
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c
+++ b/drivers/infiniband/hw/ipath/ipath_file_ops.c
@@ -1679,7 +1679,7 @@ static int find_best_unit(struct file *fp,
 	 * InfiniPath chip to that processor (we assume reasonable connectivity,
 	 * for now).  This code assumes that if affinity has been set
 	 * before this point, that at most one cpu is set; for now this
-	 * is reasonable.  I check for both cpus_empty() and cpus_full(),
+	 * is reasonable.  I check for both cpumask_empty() and cpumask_full(),
 	 * in case some kernel variant sets none of the bits when no
 	 * affinity is set.  2.6.11 and 12 kernels have all present
 	 * cpus set.  Some day we'll have to fix it up further to handle
@@ -1688,11 +1688,11 @@ static int find_best_unit(struct file *fp,
 	 * information.  There may be some issues with dual core numbering
 	 * as well.  This needs more work prior to release.
 	 */
-	if (!cpus_empty(current->cpus_allowed) &&
-	    !cpus_full(current->cpus_allowed)) {
+	if (!cpumask_empty(&current->cpus_allowed) &&
+	    !cpumask_full(&current->cpus_allowed)) {
 		int ncpus = num_online_cpus(), curcpu = -1, nset = 0;
 		for (i = 0; i < ncpus; i++)
-			if (cpu_isset(i, current->cpus_allowed)) {
+			if (cpumask_test_cpu(i, &current->cpus_allowed)) {
 				ipath_cdbg(PROC, "%s[%u] affinity set for "
 					   "cpu %d/%d\n", current->comm,
 					   current->pid, i, ncpus);
diff --git a/drivers/pnp/pnpbios/bioscalls.c b/drivers/pnp/pnpbios/bioscalls.c
index 7ff8244..7e6b5a3 100644
--- a/drivers/pnp/pnpbios/bioscalls.c
+++ b/drivers/pnp/pnpbios/bioscalls.c
@@ -481,7 +481,7 @@ void pnpbios_calls_init(union pnp_bios_install_struct *header)
 
 	set_base(bad_bios_desc, __va((unsigned long)0x40 << 4));
 	_set_limit((char *)&bad_bios_desc, 4095 - (0x40 << 4));
-	for (i = 0; i < NR_CPUS; i++) {
+	for_each_possible_cpu(i) {
 		struct desc_struct *gdt = get_cpu_gdt_table(i);
 		if (!gdt)
 			continue;
diff --git a/fs/seq_file.c b/fs/seq_file.c
index 99d8b8c..b569ff1 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -468,7 +468,8 @@ int seq_dentry(struct seq_file *m, struct dentry *dentry, char *esc)
 	return -1;
 }
 
-int seq_bitmap(struct seq_file *m, unsigned long *bits, unsigned int nr_bits)
+int seq_bitmap(struct seq_file *m, const unsigned long *bits,
+				   unsigned int nr_bits)
 {
 	if (m->count < m->size) {
 		int len = bitmap_scnprintf(m->buf + m->count,
diff --git a/include/acpi/processor.h b/include/acpi/processor.h
index 3795590..0574add 100644
--- a/include/acpi/processor.h
+++ b/include/acpi/processor.h
@@ -127,7 +127,7 @@ struct acpi_processor_performance {
 	unsigned int state_count;
 	struct acpi_processor_px *states;
 	struct acpi_psd_package domain_info;
-	cpumask_t shared_cpu_map;
+	cpumask_var_t shared_cpu_map;
 	unsigned int shared_type;
 };
 
@@ -172,7 +172,7 @@ struct acpi_processor_throttling {
 	unsigned int state_count;
 	struct acpi_processor_tx_tss *states_tss;
 	struct acpi_tsd_package domain_info;
-	cpumask_t shared_cpu_map;
+	cpumask_var_t shared_cpu_map;
 	int (*acpi_processor_get_throttling) (struct acpi_processor * pr);
 	int (*acpi_processor_set_throttling) (struct acpi_processor * pr,
 					      int state);
diff --git a/include/asm-frv/bitops.h b/include/asm-frv/bitops.h
index 39456ba..287f6f6 100644
--- a/include/asm-frv/bitops.h
+++ b/include/asm-frv/bitops.h
@@ -339,6 +339,19 @@ int __ffs(unsigned long x)
 	return 31 - bit;
 }
 
+/**
+ * __fls - find last (most-significant) set bit in a long word
+ * @word: the word to search
+ *
+ * Undefined if no set bit exists, so code should check against 0 first.
+ */
+static inline unsigned long __fls(unsigned long word)
+{
+	unsigned long bit;
+	asm("scan %1,gr0,%0" : "=r"(bit) : "r"(word));
+	return bit;
+}
+
 /*
  * special slimline version of fls() for calculating ilog2_u32()
  * - note: no protection against n == 0
diff --git a/include/asm-m32r/bitops.h b/include/asm-m32r/bitops.h
index 6dc9b81..aaddf0d 100644
--- a/include/asm-m32r/bitops.h
+++ b/include/asm-m32r/bitops.h
@@ -251,6 +251,7 @@ static __inline__ int test_and_change_bit(int nr, volatile void * addr)
 #include <asm-generic/bitops/ffz.h>
 #include <asm-generic/bitops/__ffs.h>
 #include <asm-generic/bitops/fls.h>
+#include <asm-generic/bitops/__fls.h>
 #include <asm-generic/bitops/fls64.h>
 
 #ifdef __KERNEL__
diff --git a/include/asm-m68k/bitops.h b/include/asm-m68k/bitops.h
index 3e81064..9bde784 100644
--- a/include/asm-m68k/bitops.h
+++ b/include/asm-m68k/bitops.h
@@ -315,6 +315,11 @@ static inline int fls(int x)
 	return 32 - cnt;
 }
 
+static inline int __fls(int x)
+{
+	return fls(x) - 1;
+}
+
 #include <asm-generic/bitops/fls64.h>
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/hweight.h>
diff --git a/include/asm-mn10300/bitops.h b/include/asm-mn10300/bitops.h
index cc6d40c..0b610f4 100644
--- a/include/asm-mn10300/bitops.h
+++ b/include/asm-mn10300/bitops.h
@@ -196,6 +196,17 @@ int fls(int x)
 }
 
 /**
+ * __fls - find last (most-significant) set bit in a long word
+ * @word: the word to search
+ *
+ * Undefined if no set bit exists, so code should check against 0 first.
+ */
+static inline unsigned long __fls(unsigned long word)
+{
+	return __ilog2_u32(word);
+}
+
+/**
  * ffs - find first bit set
  * @x: the word to search
  *
diff --git a/include/asm-xtensa/bitops.h b/include/asm-xtensa/bitops.h
index 23261e8..6c39303 100644
--- a/include/asm-xtensa/bitops.h
+++ b/include/asm-xtensa/bitops.h
@@ -82,6 +82,16 @@ static inline int fls (unsigned int x)
 	return 32 - __cntlz(x);
 }
 
+/**
+ * __fls - find last (most-significant) set bit in a long word
+ * @word: the word to search
+ *
+ * Undefined if no set bit exists, so code should check against 0 first.
+ */
+static inline unsigned long __fls(unsigned long word)
+{
+	return 31 - __cntlz(word);
+}
 #else
 
 /* Use the generic implementation if we don't have the nsa/nsau instructions. */
@@ -90,6 +100,7 @@ static inline int fls (unsigned int x)
 # include <asm-generic/bitops/__ffs.h>
 # include <asm-generic/bitops/ffz.h>
 # include <asm-generic/bitops/fls.h>
+# include <asm-generic/bitops/__fls.h>
 
 #endif
 
diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index a08c33a..2878811 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -137,9 +137,12 @@ extern void bitmap_copy_le(void *dst, const unsigned long *src, int nbits);
 		(1UL<<((nbits) % BITS_PER_LONG))-1 : ~0UL		\
 )
 
+#define small_const_nbits(nbits) \
+	(__builtin_constant_p(nbits) && (nbits) <= BITS_PER_LONG)
+
 static inline void bitmap_zero(unsigned long *dst, int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		*dst = 0UL;
 	else {
 		int len = BITS_TO_LONGS(nbits) * sizeof(unsigned long);
@@ -150,7 +153,7 @@ static inline void bitmap_zero(unsigned long *dst, int nbits)
 static inline void bitmap_fill(unsigned long *dst, int nbits)
 {
 	size_t nlongs = BITS_TO_LONGS(nbits);
-	if (nlongs > 1) {
+	if (!small_const_nbits(nbits)) {
 		int len = (nlongs - 1) * sizeof(unsigned long);
 		memset(dst, 0xff,  len);
 	}
@@ -160,7 +163,7 @@ static inline void bitmap_fill(unsigned long *dst, int nbits)
 static inline void bitmap_copy(unsigned long *dst, const unsigned long *src,
 			int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		*dst = *src;
 	else {
 		int len = BITS_TO_LONGS(nbits) * sizeof(unsigned long);
@@ -171,7 +174,7 @@ static inline void bitmap_copy(unsigned long *dst, const unsigned long *src,
 static inline void bitmap_and(unsigned long *dst, const unsigned long *src1,
 			const unsigned long *src2, int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		*dst = *src1 & *src2;
 	else
 		__bitmap_and(dst, src1, src2, nbits);
@@ -180,7 +183,7 @@ static inline void bitmap_and(unsigned long *dst, const unsigned long *src1,
 static inline void bitmap_or(unsigned long *dst, const unsigned long *src1,
 			const unsigned long *src2, int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		*dst = *src1 | *src2;
 	else
 		__bitmap_or(dst, src1, src2, nbits);
@@ -189,7 +192,7 @@ static inline void bitmap_or(unsigned long *dst, const unsigned long *src1,
 static inline void bitmap_xor(unsigned long *dst, const unsigned long *src1,
 			const unsigned long *src2, int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		*dst = *src1 ^ *src2;
 	else
 		__bitmap_xor(dst, src1, src2, nbits);
@@ -198,7 +201,7 @@ static inline void bitmap_xor(unsigned long *dst, const unsigned long *src1,
 static inline void bitmap_andnot(unsigned long *dst, const unsigned long *src1,
 			const unsigned long *src2, int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		*dst = *src1 & ~(*src2);
 	else
 		__bitmap_andnot(dst, src1, src2, nbits);
@@ -207,7 +210,7 @@ static inline void bitmap_andnot(unsigned long *dst, const unsigned long *src1,
 static inline void bitmap_complement(unsigned long *dst, const unsigned long *src,
 			int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		*dst = ~(*src) & BITMAP_LAST_WORD_MASK(nbits);
 	else
 		__bitmap_complement(dst, src, nbits);
@@ -216,7 +219,7 @@ static inline void bitmap_complement(unsigned long *dst, const unsigned long *sr
 static inline int bitmap_equal(const unsigned long *src1,
 			const unsigned long *src2, int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		return ! ((*src1 ^ *src2) & BITMAP_LAST_WORD_MASK(nbits));
 	else
 		return __bitmap_equal(src1, src2, nbits);
@@ -225,7 +228,7 @@ static inline int bitmap_equal(const unsigned long *src1,
 static inline int bitmap_intersects(const unsigned long *src1,
 			const unsigned long *src2, int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		return ((*src1 & *src2) & BITMAP_LAST_WORD_MASK(nbits)) != 0;
 	else
 		return __bitmap_intersects(src1, src2, nbits);
@@ -234,7 +237,7 @@ static inline int bitmap_intersects(const unsigned long *src1,
 static inline int bitmap_subset(const unsigned long *src1,
 			const unsigned long *src2, int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		return ! ((*src1 & ~(*src2)) & BITMAP_LAST_WORD_MASK(nbits));
 	else
 		return __bitmap_subset(src1, src2, nbits);
@@ -242,7 +245,7 @@ static inline int bitmap_subset(const unsigned long *src1,
 
 static inline int bitmap_empty(const unsigned long *src, int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		return ! (*src & BITMAP_LAST_WORD_MASK(nbits));
 	else
 		return __bitmap_empty(src, nbits);
@@ -250,7 +253,7 @@ static inline int bitmap_empty(const unsigned long *src, int nbits)
 
 static inline int bitmap_full(const unsigned long *src, int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		return ! (~(*src) & BITMAP_LAST_WORD_MASK(nbits));
 	else
 		return __bitmap_full(src, nbits);
@@ -258,7 +261,7 @@ static inline int bitmap_full(const unsigned long *src, int nbits)
 
 static inline int bitmap_weight(const unsigned long *src, int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		return hweight_long(*src & BITMAP_LAST_WORD_MASK(nbits));
 	return __bitmap_weight(src, nbits);
 }
@@ -266,7 +269,7 @@ static inline int bitmap_weight(const unsigned long *src, int nbits)
 static inline void bitmap_shift_right(unsigned long *dst,
 			const unsigned long *src, int n, int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		*dst = *src >> n;
 	else
 		__bitmap_shift_right(dst, src, n, nbits);
@@ -275,7 +278,7 @@ static inline void bitmap_shift_right(unsigned long *dst,
 static inline void bitmap_shift_left(unsigned long *dst,
 			const unsigned long *src, int n, int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		*dst = (*src << n) & BITMAP_LAST_WORD_MASK(nbits);
 	else
 		__bitmap_shift_left(dst, src, n, nbits);
diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 024f2b0..6182913 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -134,9 +134,20 @@ extern unsigned long find_first_bit(const unsigned long *addr,
  */
 extern unsigned long find_first_zero_bit(const unsigned long *addr,
 					 unsigned long size);
-
 #endif /* CONFIG_GENERIC_FIND_FIRST_BIT */
 
+#ifdef CONFIG_GENERIC_FIND_LAST_BIT
+/**
+ * find_last_bit - find the last set bit in a memory region
+ * @addr: The address to start the search at
+ * @size: The maximum size to search
+ *
+ * Returns the bit number of the first set bit, or size.
+ */
+extern unsigned long find_last_bit(const unsigned long *addr,
+				   unsigned long size);
+#endif /* CONFIG_GENERIC_FIND_LAST_BIT */
+
 #ifdef CONFIG_GENERIC_FIND_NEXT_BIT
 
 /**
diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index d4bf526..9f31538 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -144,6 +144,7 @@
 typedef struct cpumask { DECLARE_BITMAP(bits, NR_CPUS); } cpumask_t;
 extern cpumask_t _unused_cpumask_arg_;
 
+#ifndef CONFIG_DISABLE_OBSOLETE_CPUMASK_FUNCTIONS
 #define cpu_set(cpu, dst) __cpu_set((cpu), &(dst))
 static inline void __cpu_set(int cpu, volatile cpumask_t *dstp)
 {
@@ -267,6 +268,26 @@ static inline void __cpus_shift_left(cpumask_t *dstp,
 {
 	bitmap_shift_left(dstp->bits, srcp->bits, n, nbits);
 }
+#endif /* !CONFIG_DISABLE_OBSOLETE_CPUMASK_FUNCTIONS */
+
+/**
+ * to_cpumask - convert an NR_CPUS bitmap to a struct cpumask *
+ * @bitmap: the bitmap
+ *
+ * There are a few places where cpumask_var_t isn't appropriate and
+ * static cpumasks must be used (eg. very early boot), yet we don't
+ * expose the definition of 'struct cpumask'.
+ *
+ * This does the conversion, and can be used as a constant initializer.
+ */
+#define to_cpumask(bitmap)						\
+	((struct cpumask *)(1 ? (bitmap)				\
+			    : (void *)sizeof(__check_is_bitmap(bitmap))))
+
+static inline int __check_is_bitmap(const unsigned long *bitmap)
+{
+	return 1;
+}
 
 /*
  * Special-case data structure for "single bit set only" constant CPU masks.
@@ -278,13 +299,14 @@ static inline void __cpus_shift_left(cpumask_t *dstp,
 extern const unsigned long
 	cpu_bit_bitmap[BITS_PER_LONG+1][BITS_TO_LONGS(NR_CPUS)];
 
-static inline const cpumask_t *get_cpu_mask(unsigned int cpu)
+static inline const struct cpumask *get_cpu_mask(unsigned int cpu)
 {
 	const unsigned long *p = cpu_bit_bitmap[1 + cpu % BITS_PER_LONG];
 	p -= cpu / BITS_PER_LONG;
-	return (const cpumask_t *)p;
+	return to_cpumask(p);
 }
 
+#ifndef CONFIG_DISABLE_OBSOLETE_CPUMASK_FUNCTIONS
 /*
  * In cases where we take the address of the cpumask immediately,
  * gcc optimizes it out (it's a constant) and there's no huge stack
@@ -370,19 +392,22 @@ static inline void __cpus_fold(cpumask_t *dstp, const cpumask_t *origp,
 {
 	bitmap_fold(dstp->bits, origp->bits, sz, nbits);
 }
+#endif /* !CONFIG_DISABLE_OBSOLETE_CPUMASK_FUNCTIONS */
 
 #if NR_CPUS == 1
 
 #define nr_cpu_ids		1
+#ifndef CONFIG_DISABLE_OBSOLETE_CPUMASK_FUNCTIONS
 #define first_cpu(src)		({ (void)(src); 0; })
 #define next_cpu(n, src)	({ (void)(src); 1; })
 #define any_online_cpu(mask)	0
 #define for_each_cpu_mask(cpu, mask)	\
 	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask)
-
+#endif /* !CONFIG_DISABLE_OBSOLETE_CPUMASK_FUNCTIONS */
 #else /* NR_CPUS > 1 */
 
 extern int nr_cpu_ids;
+#ifndef CONFIG_DISABLE_OBSOLETE_CPUMASK_FUNCTIONS
 int __first_cpu(const cpumask_t *srcp);
 int __next_cpu(int n, const cpumask_t *srcp);
 int __any_online_cpu(const cpumask_t *mask);
@@ -394,8 +419,10 @@ int __any_online_cpu(const cpumask_t *mask);
 	for ((cpu) = -1;				\
 		(cpu) = next_cpu((cpu), (mask)),	\
 		(cpu) < NR_CPUS; )
+#endif /* !CONFIG_DISABLE_OBSOLETE_CPUMASK_FUNCTIONS */
 #endif
 
+#ifndef CONFIG_DISABLE_OBSOLETE_CPUMASK_FUNCTIONS
 #if NR_CPUS <= 64
 
 #define next_cpu_nr(n, src)		next_cpu(n, src)
@@ -413,77 +440,67 @@ int __next_cpu_nr(int n, const cpumask_t *srcp);
 		(cpu) < nr_cpu_ids; )
 
 #endif /* NR_CPUS > 64 */
+#endif /* !CONFIG_DISABLE_OBSOLETE_CPUMASK_FUNCTIONS */
 
 /*
  * The following particular system cpumasks and operations manage
- * possible, present, active and online cpus.  Each of them is a fixed size
- * bitmap of size NR_CPUS.
+ * possible, present, active and online cpus.
  *
- *  #ifdef CONFIG_HOTPLUG_CPU
- *     cpu_possible_map - has bit 'cpu' set iff cpu is populatable
- *     cpu_present_map  - has bit 'cpu' set iff cpu is populated
- *     cpu_online_map   - has bit 'cpu' set iff cpu available to scheduler
- *     cpu_active_map   - has bit 'cpu' set iff cpu available to migration
- *  #else
- *     cpu_possible_map - has bit 'cpu' set iff cpu is populated
- *     cpu_present_map  - copy of cpu_possible_map
- *     cpu_online_map   - has bit 'cpu' set iff cpu available to scheduler
- *  #endif
+ *     cpu_possible_mask- has bit 'cpu' set iff cpu is populatable
+ *     cpu_present_mask - has bit 'cpu' set iff cpu is populated
+ *     cpu_online_mask  - has bit 'cpu' set iff cpu available to scheduler
+ *     cpu_active_mask  - has bit 'cpu' set iff cpu available to migration
  *
- *  In either case, NR_CPUS is fixed at compile time, as the static
- *  size of these bitmaps.  The cpu_possible_map is fixed at boot
- *  time, as the set of CPU id's that it is possible might ever
- *  be plugged in at anytime during the life of that system boot.
- *  The cpu_present_map is dynamic(*), representing which CPUs
- *  are currently plugged in.  And cpu_online_map is the dynamic
- *  subset of cpu_present_map, indicating those CPUs available
- *  for scheduling.
+ *  If !CONFIG_HOTPLUG_CPU, present == possible, and active == online.
  *
- *  If HOTPLUG is enabled, then cpu_possible_map is forced to have
+ *  The cpu_possible_mask is fixed at boot time, as the set of CPU id's
+ *  that it is possible might ever be plugged in at anytime during the
+ *  life of that system boot.  The cpu_present_mask is dynamic(*),
+ *  representing which CPUs are currently plugged in.  And
+ *  cpu_online_mask is the dynamic subset of cpu_present_mask,
+ *  indicating those CPUs available for scheduling.
+ *
+ *  If HOTPLUG is enabled, then cpu_possible_mask is forced to have
  *  all NR_CPUS bits set, otherwise it is just the set of CPUs that
  *  ACPI reports present at boot.
  *
- *  If HOTPLUG is enabled, then cpu_present_map varies dynamically,
+ *  If HOTPLUG is enabled, then cpu_present_mask varies dynamically,
  *  depending on what ACPI reports as currently plugged in, otherwise
- *  cpu_present_map is just a copy of cpu_possible_map.
+ *  cpu_present_mask is just a copy of cpu_possible_mask.
  *
- *  (*) Well, cpu_present_map is dynamic in the hotplug case.  If not
- *      hotplug, it's a copy of cpu_possible_map, hence fixed at boot.
+ *  (*) Well, cpu_present_mask is dynamic in the hotplug case.  If not
+ *      hotplug, it's a copy of cpu_possible_mask, hence fixed at boot.
  *
  * Subtleties:
  * 1) UP arch's (NR_CPUS == 1, CONFIG_SMP not defined) hardcode
  *    assumption that their single CPU is online.  The UP
- *    cpu_{online,possible,present}_maps are placebos.  Changing them
+ *    cpu_{online,possible,present}_masks are placebos.  Changing them
  *    will have no useful affect on the following num_*_cpus()
  *    and cpu_*() macros in the UP case.  This ugliness is a UP
  *    optimization - don't waste any instructions or memory references
  *    asking if you're online or how many CPUs there are if there is
  *    only one CPU.
- * 2) Most SMP arch's #define some of these maps to be some
- *    other map specific to that arch.  Therefore, the following
- *    must be #define macros, not inlines.  To see why, examine
- *    the assembly code produced by the following.  Note that
- *    set1() writes phys_x_map, but set2() writes x_map:
- *        int x_map, phys_x_map;
- *        #define set1(a) x_map = a
- *        inline void set2(int a) { x_map = a; }
- *        #define x_map phys_x_map
- *        main(){ set1(3); set2(5); }
  */
 
-extern cpumask_t cpu_possible_map;
-extern cpumask_t cpu_online_map;
-extern cpumask_t cpu_present_map;
-extern cpumask_t cpu_active_map;
+extern const struct cpumask *const cpu_possible_mask;
+extern const struct cpumask *const cpu_online_mask;
+extern const struct cpumask *const cpu_present_mask;
+extern const struct cpumask *const cpu_active_mask;
+
+/* These strip const, as traditionally they weren't const. */
+#define cpu_possible_map	(*(cpumask_t *)cpu_possible_mask)
+#define cpu_online_map		(*(cpumask_t *)cpu_online_mask)
+#define cpu_present_map		(*(cpumask_t *)cpu_present_mask)
+#define cpu_active_map		(*(cpumask_t *)cpu_active_mask)
 
 #if NR_CPUS > 1
-#define num_online_cpus()	cpus_weight_nr(cpu_online_map)
-#define num_possible_cpus()	cpus_weight_nr(cpu_possible_map)
-#define num_present_cpus()	cpus_weight_nr(cpu_present_map)
-#define cpu_online(cpu)		cpu_isset((cpu), cpu_online_map)
-#define cpu_possible(cpu)	cpu_isset((cpu), cpu_possible_map)
-#define cpu_present(cpu)	cpu_isset((cpu), cpu_present_map)
-#define cpu_active(cpu)		cpu_isset((cpu), cpu_active_map)
+#define num_online_cpus()	cpumask_weight(cpu_online_mask)
+#define num_possible_cpus()	cpumask_weight(cpu_possible_mask)
+#define num_present_cpus()	cpumask_weight(cpu_present_mask)
+#define cpu_online(cpu)		cpumask_test_cpu((cpu), cpu_online_mask)
+#define cpu_possible(cpu)	cpumask_test_cpu((cpu), cpu_possible_mask)
+#define cpu_present(cpu)	cpumask_test_cpu((cpu), cpu_present_mask)
+#define cpu_active(cpu)		cpumask_test_cpu((cpu), cpu_active_mask)
 #else
 #define num_online_cpus()	1
 #define num_possible_cpus()	1
@@ -496,10 +513,6 @@ extern cpumask_t cpu_active_map;
 
 #define cpu_is_offline(cpu)	unlikely(!cpu_online(cpu))
 
-#define for_each_possible_cpu(cpu) for_each_cpu_mask_nr((cpu), cpu_possible_map)
-#define for_each_online_cpu(cpu)   for_each_cpu_mask_nr((cpu), cpu_online_map)
-#define for_each_present_cpu(cpu)  for_each_cpu_mask_nr((cpu), cpu_present_map)
-
 /* These are the new versions of the cpumask operators: passed by pointer.
  * The older versions will be implemented in terms of these, then deleted. */
 #define cpumask_bits(maskp) ((maskp)->bits)
@@ -687,7 +700,7 @@ static inline void cpumask_clear_cpu(int cpu, struct cpumask *dstp)
  * No static inline type checking - see Subtlety (1) above.
  */
 #define cpumask_test_cpu(cpu, cpumask) \
-	test_bit(cpumask_check(cpu), (cpumask)->bits)
+	test_bit(cpumask_check(cpu), cpumask_bits((cpumask)))
 
 /**
  * cpumask_test_and_set_cpu - atomically test and set a cpu in a cpumask
@@ -930,7 +943,7 @@ static inline void cpumask_copy(struct cpumask *dstp,
 static inline int cpumask_scnprintf(char *buf, int len,
 				    const struct cpumask *srcp)
 {
-	return bitmap_scnprintf(buf, len, srcp->bits, nr_cpumask_bits);
+	return bitmap_scnprintf(buf, len, cpumask_bits(srcp), nr_cpumask_bits);
 }
 
 /**
@@ -944,7 +957,7 @@ static inline int cpumask_scnprintf(char *buf, int len,
 static inline int cpumask_parse_user(const char __user *buf, int len,
 				     struct cpumask *dstp)
 {
-	return bitmap_parse_user(buf, len, dstp->bits, nr_cpumask_bits);
+	return bitmap_parse_user(buf, len, cpumask_bits(dstp), nr_cpumask_bits);
 }
 
 /**
@@ -959,7 +972,8 @@ static inline int cpumask_parse_user(const char __user *buf, int len,
 static inline int cpulist_scnprintf(char *buf, int len,
 				    const struct cpumask *srcp)
 {
-	return bitmap_scnlistprintf(buf, len, srcp->bits, nr_cpumask_bits);
+	return bitmap_scnlistprintf(buf, len, cpumask_bits(srcp),
+				    nr_cpumask_bits);
 }
 
 /**
@@ -972,26 +986,7 @@ static inline int cpulist_scnprintf(char *buf, int len,
  */
 static inline int cpulist_parse(const char *buf, struct cpumask *dstp)
 {
-	return bitmap_parselist(buf, dstp->bits, nr_cpumask_bits);
-}
-
-/**
- * to_cpumask - convert an NR_CPUS bitmap to a struct cpumask *
- * @bitmap: the bitmap
- *
- * There are a few places where cpumask_var_t isn't appropriate and
- * static cpumasks must be used (eg. very early boot), yet we don't
- * expose the definition of 'struct cpumask'.
- *
- * This does the conversion, and can be used as a constant initializer.
- */
-#define to_cpumask(bitmap)						\
-	((struct cpumask *)(1 ? (bitmap)				\
-			    : (void *)sizeof(__check_is_bitmap(bitmap))))
-
-static inline int __check_is_bitmap(const unsigned long *bitmap)
-{
-	return 1;
+	return bitmap_parselist(buf, cpumask_bits(dstp), nr_cpumask_bits);
 }
 
 /**
@@ -1025,6 +1020,7 @@ static inline size_t cpumask_size(void)
 #ifdef CONFIG_CPUMASK_OFFSTACK
 typedef struct cpumask *cpumask_var_t;
 
+bool alloc_cpumask_var_node(cpumask_var_t *mask, gfp_t flags, int node);
 bool alloc_cpumask_var(cpumask_var_t *mask, gfp_t flags);
 void alloc_bootmem_cpumask_var(cpumask_var_t *mask);
 void free_cpumask_var(cpumask_var_t mask);
@@ -1038,6 +1034,12 @@ static inline bool alloc_cpumask_var(cpumask_var_t *mask, gfp_t flags)
 	return true;
 }
 
+static inline bool alloc_cpumask_var_node(cpumask_var_t *mask, gfp_t flags,
+					  int node)
+{
+	return true;
+}
+
 static inline void alloc_bootmem_cpumask_var(cpumask_var_t *mask)
 {
 }
@@ -1051,12 +1053,6 @@ static inline void free_bootmem_cpumask_var(cpumask_var_t mask)
 }
 #endif /* CONFIG_CPUMASK_OFFSTACK */
 
-/* The pointer versions of the maps, these will become the primary versions. */
-#define cpu_possible_mask ((const struct cpumask *)&cpu_possible_map)
-#define cpu_online_mask ((const struct cpumask *)&cpu_online_map)
-#define cpu_present_mask ((const struct cpumask *)&cpu_present_map)
-#define cpu_active_mask ((const struct cpumask *)&cpu_active_map)
-
 /* It's common to want to use cpu_all_mask in struct member initializers,
  * so it has to refer to an address rather than a pointer. */
 extern const DECLARE_BITMAP(cpu_all_bits, NR_CPUS);
@@ -1065,51 +1061,16 @@ extern const DECLARE_BITMAP(cpu_all_bits, NR_CPUS);
 /* First bits of cpu_bit_bitmap are in fact unset. */
 #define cpu_none_mask to_cpumask(cpu_bit_bitmap[0])
 
-/* Wrappers for arch boot code to manipulate normally-constant masks */
-static inline void set_cpu_possible(unsigned int cpu, bool possible)
-{
-	if (possible)
-		cpumask_set_cpu(cpu, &cpu_possible_map);
-	else
-		cpumask_clear_cpu(cpu, &cpu_possible_map);
-}
-
-static inline void set_cpu_present(unsigned int cpu, bool present)
-{
-	if (present)
-		cpumask_set_cpu(cpu, &cpu_present_map);
-	else
-		cpumask_clear_cpu(cpu, &cpu_present_map);
-}
-
-static inline void set_cpu_online(unsigned int cpu, bool online)
-{
-	if (online)
-		cpumask_set_cpu(cpu, &cpu_online_map);
-	else
-		cpumask_clear_cpu(cpu, &cpu_online_map);
-}
+#define for_each_possible_cpu(cpu) for_each_cpu((cpu), cpu_possible_mask)
+#define for_each_online_cpu(cpu)   for_each_cpu((cpu), cpu_online_mask)
+#define for_each_present_cpu(cpu)  for_each_cpu((cpu), cpu_present_mask)
 
-static inline void set_cpu_active(unsigned int cpu, bool active)
-{
-	if (active)
-		cpumask_set_cpu(cpu, &cpu_active_map);
-	else
-		cpumask_clear_cpu(cpu, &cpu_active_map);
-}
-
-static inline void init_cpu_present(const struct cpumask *src)
-{
-	cpumask_copy(&cpu_present_map, src);
-}
-
-static inline void init_cpu_possible(const struct cpumask *src)
-{
-	cpumask_copy(&cpu_possible_map, src);
-}
-
-static inline void init_cpu_online(const struct cpumask *src)
-{
-	cpumask_copy(&cpu_online_map, src);
-}
+/* Wrappers for arch boot code to manipulate normally-constant masks */
+void set_cpu_possible(unsigned int cpu, bool possible);
+void set_cpu_present(unsigned int cpu, bool present);
+void set_cpu_online(unsigned int cpu, bool online);
+void set_cpu_active(unsigned int cpu, bool active);
+void init_cpu_present(const struct cpumask *src);
+void init_cpu_possible(const struct cpumask *src);
+void init_cpu_online(const struct cpumask *src);
 #endif /* __LINUX_CPUMASK_H */
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 990355f..0702c4d 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -109,7 +109,7 @@ extern void enable_irq(unsigned int irq);
 
 #if defined(CONFIG_SMP) && defined(CONFIG_GENERIC_HARDIRQS)
 
-extern cpumask_t irq_default_affinity;
+extern cpumask_var_t irq_default_affinity;
 
 extern int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask);
 extern int irq_can_set_affinity(unsigned int irq);
diff --git a/include/linux/rcuclassic.h b/include/linux/rcuclassic.h
index 301dda8..f3f697d 100644
--- a/include/linux/rcuclassic.h
+++ b/include/linux/rcuclassic.h
@@ -59,8 +59,8 @@ struct rcu_ctrlblk {
 	int	signaled;
 
 	spinlock_t	lock	____cacheline_internodealigned_in_smp;
-	cpumask_t	cpumask; /* CPUs that need to switch in order    */
-				 /* for current batch to proceed.        */
+	DECLARE_BITMAP(cpumask, NR_CPUS); /* CPUs that need to switch for */
+					  /* current batch to proceed.     */
 } ____cacheline_internodealigned_in_smp;
 
 /* Is batch a before batch b ? */
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index b3dfa72..40ea505 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -50,10 +50,11 @@ int seq_path(struct seq_file *, struct path *, char *);
 int seq_dentry(struct seq_file *, struct dentry *, char *);
 int seq_path_root(struct seq_file *m, struct path *path, struct path *root,
 		  char *esc);
-int seq_bitmap(struct seq_file *m, unsigned long *bits, unsigned int nr_bits);
-static inline int seq_cpumask(struct seq_file *m, cpumask_t *mask)
+int seq_bitmap(struct seq_file *m, const unsigned long *bits,
+				   unsigned int nr_bits);
+static inline int seq_cpumask(struct seq_file *m, const struct cpumask *mask)
 {
-	return seq_bitmap(m, mask->bits, NR_CPUS);
+	return seq_bitmap(m, mask->bits, nr_cpu_ids);
 }
 
 static inline int seq_nodemask(struct seq_file *m, nodemask_t *mask)
diff --git a/include/linux/smp.h b/include/linux/smp.h
index 6e7ba16..b824669 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -21,6 +21,9 @@ struct call_single_data {
 	u16 priv;
 };
 
+/* total number of cpus in this system (may exceed NR_CPUS) */
+extern unsigned int total_cpus;
+
 #ifdef CONFIG_SMP
 
 #include <linux/preempt.h>
@@ -64,15 +67,16 @@ extern void smp_cpus_done(unsigned int max_cpus);
  * Call a function on all other processors
  */
 int smp_call_function(void(*func)(void *info), void *info, int wait);
-/* Deprecated: use smp_call_function_many() which uses a cpumask ptr. */
-int smp_call_function_mask(cpumask_t mask, void(*func)(void *info), void *info,
-				int wait);
+void smp_call_function_many(const struct cpumask *mask,
+			    void (*func)(void *info), void *info, bool wait);
 
-static inline void smp_call_function_many(const struct cpumask *mask,
-					  void (*func)(void *info), void *info,
-					  int wait)
+/* Deprecated: Use smp_call_function_many which takes a pointer to the mask. */
+static inline int
+smp_call_function_mask(cpumask_t mask, void(*func)(void *info), void *info,
+		       int wait)
 {
-	smp_call_function_mask(*mask, func, info, wait);
+	smp_call_function_many(&mask, func, info, wait);
+	return 0;
 }
 
 int smp_call_function_single(int cpuid, void (*func) (void *info), void *info,
diff --git a/include/linux/stop_machine.h b/include/linux/stop_machine.h
index faf1519..74d59a6 100644
--- a/include/linux/stop_machine.h
+++ b/include/linux/stop_machine.h
@@ -23,7 +23,7 @@
  *
  * This can be thought of as a very heavy write lock, equivalent to
  * grabbing every spinlock in the kernel. */
-int stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus);
+int stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus);
 
 /**
  * __stop_machine: freeze the machine on all CPUs and run this function
@@ -34,11 +34,11 @@ int stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus);
  * Description: This is a special version of the above, which assumes cpus
  * won't come or go while it's being called.  Used by hotplug cpu.
  */
-int __stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus);
+int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus);
 #else
 
 static inline int stop_machine(int (*fn)(void *), void *data,
-			       const cpumask_t *cpus)
+			       const struct cpumask *cpus)
 {
 	int ret;
 	local_irq_disable();
diff --git a/include/linux/threads.h b/include/linux/threads.h
index 38d1a5d..052b12b 100644
--- a/include/linux/threads.h
+++ b/include/linux/threads.h
@@ -8,17 +8,17 @@
  */
 
 /*
- * Maximum supported processors that can run under SMP.  This value is
- * set via configure setting.  The maximum is equal to the size of the
- * bitmasks used on that platform, i.e. 32 or 64.  Setting this smaller
- * saves quite a bit of memory.
+ * Maximum supported processors.  Setting this smaller saves quite a
+ * bit of memory.  Use nr_cpu_ids instead of this except for static bitmaps.
  */
-#ifdef CONFIG_SMP
-#define NR_CPUS		CONFIG_NR_CPUS
-#else
-#define NR_CPUS		1
+#ifndef CONFIG_NR_CPUS
+/* FIXME: This should be fixed in the arch's Kconfig */
+#define CONFIG_NR_CPUS	1
 #endif
 
+/* Places which use this should consider cpumask_var_t. */
+#define NR_CPUS		CONFIG_NR_CPUS
+
 #define MIN_THREADS_LEFT_FOR_ROOT 4
 
 /*
diff --git a/include/linux/tick.h b/include/linux/tick.h
index b6ec818..469b82d 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -84,10 +84,10 @@ static inline void tick_cancel_sched_timer(int cpu) { }
 
 # ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
 extern struct tick_device *tick_get_broadcast_device(void);
-extern cpumask_t *tick_get_broadcast_mask(void);
+extern struct cpumask *tick_get_broadcast_mask(void);
 
 #  ifdef CONFIG_TICK_ONESHOT
-extern cpumask_t *tick_get_broadcast_oneshot_mask(void);
+extern struct cpumask *tick_get_broadcast_oneshot_mask(void);
 #  endif
 
 # endif /* BROADCAST */
diff --git a/init/main.c b/init/main.c
index ad8f9f5..cd168eb 100644
--- a/init/main.c
+++ b/init/main.c
@@ -371,12 +371,7 @@ EXPORT_SYMBOL(nr_cpu_ids);
 /* An arch may set nr_cpu_ids earlier if needed, so this would be redundant */
 static void __init setup_nr_cpu_ids(void)
 {
-	int cpu, highest_cpu = 0;
-
-	for_each_possible_cpu(cpu)
-		highest_cpu = cpu;
-
-	nr_cpu_ids = highest_cpu + 1;
+	nr_cpu_ids = find_last_bit(cpumask_bits(cpu_possible_mask),NR_CPUS) + 1;
 }
 
 #ifndef CONFIG_HAVE_SETUP_PER_CPU_AREA
@@ -518,9 +513,9 @@ static void __init boot_cpu_init(void)
 {
 	int cpu = smp_processor_id();
 	/* Mark the boot cpu "present", "online" etc for SMP and UP case */
-	cpu_set(cpu, cpu_online_map);
-	cpu_set(cpu, cpu_present_map);
-	cpu_set(cpu, cpu_possible_map);
+	set_cpu_online(cpu, true);
+	set_cpu_present(cpu, true);
+	set_cpu_possible(cpu, true);
 }
 
 void __init __weak smp_setup_processor_id(void)
diff --git a/kernel/compat.c b/kernel/compat.c
index 8eafe3e..d52e2ec 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -454,16 +454,16 @@ asmlinkage long compat_sys_waitid(int which, compat_pid_t pid,
 }
 
 static int compat_get_user_cpu_mask(compat_ulong_t __user *user_mask_ptr,
-				    unsigned len, cpumask_t *new_mask)
+				    unsigned len, struct cpumask *new_mask)
 {
 	unsigned long *k;
 
-	if (len < sizeof(cpumask_t))
-		memset(new_mask, 0, sizeof(cpumask_t));
-	else if (len > sizeof(cpumask_t))
-		len = sizeof(cpumask_t);
+	if (len < cpumask_size())
+		memset(new_mask, 0, cpumask_size());
+	else if (len > cpumask_size())
+		len = cpumask_size();
 
-	k = cpus_addr(*new_mask);
+	k = cpumask_bits(new_mask);
 	return compat_get_bitmap(k, user_mask_ptr, len * 8);
 }
 
@@ -471,40 +471,51 @@ asmlinkage long compat_sys_sched_setaffinity(compat_pid_t pid,
 					     unsigned int len,
 					     compat_ulong_t __user *user_mask_ptr)
 {
-	cpumask_t new_mask;
+	cpumask_var_t new_mask;
 	int retval;
 
-	retval = compat_get_user_cpu_mask(user_mask_ptr, len, &new_mask);
+	if (!alloc_cpumask_var(&new_mask, GFP_KERNEL))
+		return -ENOMEM;
+
+	retval = compat_get_user_cpu_mask(user_mask_ptr, len, new_mask);
 	if (retval)
-		return retval;
+		goto out;
 
-	return sched_setaffinity(pid, &new_mask);
+	retval = sched_setaffinity(pid, new_mask);
+out:
+	free_cpumask_var(new_mask);
+	return retval;
 }
 
 asmlinkage long compat_sys_sched_getaffinity(compat_pid_t pid, unsigned int len,
 					     compat_ulong_t __user *user_mask_ptr)
 {
 	int ret;
-	cpumask_t mask;
+	cpumask_var_t mask;
 	unsigned long *k;
-	unsigned int min_length = sizeof(cpumask_t);
+	unsigned int min_length = cpumask_size();
 
-	if (NR_CPUS <= BITS_PER_COMPAT_LONG)
+	if (nr_cpu_ids <= BITS_PER_COMPAT_LONG)
 		min_length = sizeof(compat_ulong_t);
 
 	if (len < min_length)
 		return -EINVAL;
 
-	ret = sched_getaffinity(pid, &mask);
+	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
+		return -ENOMEM;
+
+	ret = sched_getaffinity(pid, mask);
 	if (ret < 0)
-		return ret;
+		goto out;
 
-	k = cpus_addr(mask);
+	k = cpumask_bits(mask);
 	ret = compat_put_bitmap(user_mask_ptr, k, min_length * 8);
-	if (ret)
-		return ret;
+	if (ret == 0)
+		ret = min_length;
 
-	return min_length;
+out:
+	free_cpumask_var(mask);
+	return ret;
 }
 
 int get_compat_itimerspec(struct itimerspec *dst,
diff --git a/kernel/cpu.c b/kernel/cpu.c
index bae131a..47fff3b 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -15,30 +15,8 @@
 #include <linux/stop_machine.h>
 #include <linux/mutex.h>
 
-/*
- * Represents all cpu's present in the system
- * In systems capable of hotplug, this map could dynamically grow
- * as new cpu's are detected in the system via any platform specific
- * method, such as ACPI for e.g.
- */
-cpumask_t cpu_present_map __read_mostly;
-EXPORT_SYMBOL(cpu_present_map);
-
-/*
- * Represents all cpu's that are currently online.
- */
-cpumask_t cpu_online_map __read_mostly;
-EXPORT_SYMBOL(cpu_online_map);
-
-#ifdef CONFIG_INIT_ALL_POSSIBLE
-cpumask_t cpu_possible_map __read_mostly = CPU_MASK_ALL;
-#else
-cpumask_t cpu_possible_map __read_mostly;
-#endif
-EXPORT_SYMBOL(cpu_possible_map);
-
 #ifdef CONFIG_SMP
-/* Serializes the updates to cpu_online_map, cpu_present_map */
+/* Serializes the updates to cpu_online_mask, cpu_present_mask */
 static DEFINE_MUTEX(cpu_add_remove_lock);
 
 static __cpuinitdata RAW_NOTIFIER_HEAD(cpu_chain);
@@ -65,8 +43,6 @@ void __init cpu_hotplug_init(void)
 	cpu_hotplug.refcount = 0;
 }
 
-cpumask_t cpu_active_map;
-
 #ifdef CONFIG_HOTPLUG_CPU
 
 void get_online_cpus(void)
@@ -97,7 +73,7 @@ EXPORT_SYMBOL_GPL(put_online_cpus);
 
 /*
  * The following two API's must be used when attempting
- * to serialize the updates to cpu_online_map, cpu_present_map.
+ * to serialize the updates to cpu_online_mask, cpu_present_mask.
  */
 void cpu_maps_update_begin(void)
 {
@@ -218,7 +194,7 @@ static int __ref take_cpu_down(void *_param)
 static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 {
 	int err, nr_calls = 0;
-	cpumask_t old_allowed, tmp;
+	cpumask_var_t old_allowed;
 	void *hcpu = (void *)(long)cpu;
 	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
 	struct take_cpu_down_param tcd_param = {
@@ -232,6 +208,9 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	if (!cpu_online(cpu))
 		return -EINVAL;
 
+	if (!alloc_cpumask_var(&old_allowed, GFP_KERNEL))
+		return -ENOMEM;
+
 	cpu_hotplug_begin();
 	err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE | mod,
 					hcpu, -1, &nr_calls);
@@ -246,13 +225,11 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	}
 
 	/* Ensure that we are not runnable on dying cpu */
-	old_allowed = current->cpus_allowed;
-	cpus_setall(tmp);
-	cpu_clear(cpu, tmp);
-	set_cpus_allowed_ptr(current, &tmp);
-	tmp = cpumask_of_cpu(cpu);
+	cpumask_copy(old_allowed, &current->cpus_allowed);
+	set_cpus_allowed_ptr(current,
+			     cpumask_of(cpumask_any_but(cpu_online_mask, cpu)));
 
-	err = __stop_machine(take_cpu_down, &tcd_param, &tmp);
+	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
 	if (err) {
 		/* CPU didn't die: tell everyone.  Can't complain. */
 		if (raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED | mod,
@@ -278,7 +255,7 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	check_for_tasks(cpu);
 
 out_allowed:
-	set_cpus_allowed_ptr(current, &old_allowed);
+	set_cpus_allowed_ptr(current, old_allowed);
 out_release:
 	cpu_hotplug_done();
 	if (!err) {
@@ -286,6 +263,7 @@ out_release:
 					    hcpu) == NOTIFY_BAD)
 			BUG();
 	}
+	free_cpumask_var(old_allowed);
 	return err;
 }
 
@@ -304,7 +282,7 @@ int __ref cpu_down(unsigned int cpu)
 
 	/*
 	 * Make sure the all cpus did the reschedule and are not
-	 * using stale version of the cpu_active_map.
+	 * using stale version of the cpu_active_mask.
 	 * This is not strictly necessary becuase stop_machine()
 	 * that we run down the line already provides the required
 	 * synchronization. But it's really a side effect and we do not
@@ -368,7 +346,7 @@ out_notify:
 int __cpuinit cpu_up(unsigned int cpu)
 {
 	int err = 0;
-	if (!cpu_isset(cpu, cpu_possible_map)) {
+	if (!cpu_possible(cpu)) {
 		printk(KERN_ERR "can't online cpu %d because it is not "
 			"configured as may-hotadd at boot time\n", cpu);
 #if defined(CONFIG_IA64) || defined(CONFIG_X86_64)
@@ -393,25 +371,25 @@ out:
 }
 
 #ifdef CONFIG_PM_SLEEP_SMP
-static cpumask_t frozen_cpus;
+static cpumask_var_t frozen_cpus;
 
 int disable_nonboot_cpus(void)
 {
 	int cpu, first_cpu, error = 0;
 
 	cpu_maps_update_begin();
-	first_cpu = first_cpu(cpu_online_map);
+	first_cpu = cpumask_first(cpu_online_mask);
 	/* We take down all of the non-boot CPUs in one shot to avoid races
 	 * with the userspace trying to use the CPU hotplug at the same time
 	 */
-	cpus_clear(frozen_cpus);
+	cpumask_clear(frozen_cpus);
 	printk("Disabling non-boot CPUs ...\n");
 	for_each_online_cpu(cpu) {
 		if (cpu == first_cpu)
 			continue;
 		error = _cpu_down(cpu, 1);
 		if (!error) {
-			cpu_set(cpu, frozen_cpus);
+			cpumask_set_cpu(cpu, frozen_cpus);
 			printk("CPU%d is down\n", cpu);
 		} else {
 			printk(KERN_ERR "Error taking CPU%d down: %d\n",
@@ -437,11 +415,11 @@ void __ref enable_nonboot_cpus(void)
 	/* Allow everyone to use the CPU hotplug again */
 	cpu_maps_update_begin();
 	cpu_hotplug_disabled = 0;
-	if (cpus_empty(frozen_cpus))
+	if (cpumask_empty(frozen_cpus))
 		goto out;
 
 	printk("Enabling non-boot CPUs ...\n");
-	for_each_cpu_mask_nr(cpu, frozen_cpus) {
+	for_each_cpu(cpu, frozen_cpus) {
 		error = _cpu_up(cpu, 1);
 		if (!error) {
 			printk("CPU%d is up\n", cpu);
@@ -449,10 +427,18 @@ void __ref enable_nonboot_cpus(void)
 		}
 		printk(KERN_WARNING "Error taking CPU%d up: %d\n", cpu, error);
 	}
-	cpus_clear(frozen_cpus);
+	cpumask_clear(frozen_cpus);
 out:
 	cpu_maps_update_done();
 }
+
+static int alloc_frozen_cpus(void)
+{
+	if (!alloc_cpumask_var(&frozen_cpus, GFP_KERNEL|__GFP_ZERO))
+		return -ENOMEM;
+	return 0;
+}
+core_initcall(alloc_frozen_cpus);
 #endif /* CONFIG_PM_SLEEP_SMP */
 
 /**
@@ -468,7 +454,7 @@ void __cpuinit notify_cpu_starting(unsigned int cpu)
 	unsigned long val = CPU_STARTING;
 
 #ifdef CONFIG_PM_SLEEP_SMP
-	if (cpu_isset(cpu, frozen_cpus))
+	if (frozen_cpus != NULL && cpumask_test_cpu(cpu, frozen_cpus))
 		val = CPU_STARTING_FROZEN;
 #endif /* CONFIG_PM_SLEEP_SMP */
 	raw_notifier_call_chain(&cpu_chain, val, (void *)(long)cpu);
@@ -480,7 +466,7 @@ void __cpuinit notify_cpu_starting(unsigned int cpu)
  * cpu_bit_bitmap[] is a special, "compressed" data structure that
  * represents all NR_CPUS bits binary values of 1<<nr.
  *
- * It is used by cpumask_of_cpu() to get a constant address to a CPU
+ * It is used by cpumask_of() to get a constant address to a CPU
  * mask value that has a single bit set only.
  */
 
@@ -503,3 +489,71 @@ EXPORT_SYMBOL_GPL(cpu_bit_bitmap);
 
 const DECLARE_BITMAP(cpu_all_bits, NR_CPUS) = CPU_BITS_ALL;
 EXPORT_SYMBOL(cpu_all_bits);
+
+#ifdef CONFIG_INIT_ALL_POSSIBLE
+static DECLARE_BITMAP(cpu_possible_bits, CONFIG_NR_CPUS) __read_mostly
+	= CPU_BITS_ALL;
+#else
+static DECLARE_BITMAP(cpu_possible_bits, CONFIG_NR_CPUS) __read_mostly;
+#endif
+const struct cpumask *const cpu_possible_mask = to_cpumask(cpu_possible_bits);
+EXPORT_SYMBOL(cpu_possible_mask);
+
+static DECLARE_BITMAP(cpu_online_bits, CONFIG_NR_CPUS) __read_mostly;
+const struct cpumask *const cpu_online_mask = to_cpumask(cpu_online_bits);
+EXPORT_SYMBOL(cpu_online_mask);
+
+static DECLARE_BITMAP(cpu_present_bits, CONFIG_NR_CPUS) __read_mostly;
+const struct cpumask *const cpu_present_mask = to_cpumask(cpu_present_bits);
+EXPORT_SYMBOL(cpu_present_mask);
+
+static DECLARE_BITMAP(cpu_active_bits, CONFIG_NR_CPUS) __read_mostly;
+const struct cpumask *const cpu_active_mask = to_cpumask(cpu_active_bits);
+EXPORT_SYMBOL(cpu_active_mask);
+
+void set_cpu_possible(unsigned int cpu, bool possible)
+{
+	if (possible)
+		cpumask_set_cpu(cpu, to_cpumask(cpu_possible_bits));
+	else
+		cpumask_clear_cpu(cpu, to_cpumask(cpu_possible_bits));
+}
+
+void set_cpu_present(unsigned int cpu, bool present)
+{
+	if (present)
+		cpumask_set_cpu(cpu, to_cpumask(cpu_present_bits));
+	else
+		cpumask_clear_cpu(cpu, to_cpumask(cpu_present_bits));
+}
+
+void set_cpu_online(unsigned int cpu, bool online)
+{
+	if (online)
+		cpumask_set_cpu(cpu, to_cpumask(cpu_online_bits));
+	else
+		cpumask_clear_cpu(cpu, to_cpumask(cpu_online_bits));
+}
+
+void set_cpu_active(unsigned int cpu, bool active)
+{
+	if (active)
+		cpumask_set_cpu(cpu, to_cpumask(cpu_active_bits));
+	else
+		cpumask_clear_cpu(cpu, to_cpumask(cpu_active_bits));
+}
+
+void init_cpu_present(const struct cpumask *src)
+{
+	cpumask_copy(to_cpumask(cpu_present_bits), src);
+}
+
+void init_cpu_possible(const struct cpumask *src)
+{
+	cpumask_copy(to_cpumask(cpu_possible_bits), src);
+}
+
+void init_cpu_online(const struct cpumask *src)
+{
+	cpumask_copy(to_cpumask(cpu_online_bits), src);
+}
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 61c4a9b..cd0cd8d 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -16,8 +16,15 @@
 #include "internals.h"
 
 #ifdef CONFIG_SMP
+cpumask_var_t irq_default_affinity;
 
-cpumask_t irq_default_affinity = CPU_MASK_ALL;
+static int init_irq_default_affinity(void)
+{
+	alloc_cpumask_var(&irq_default_affinity, GFP_KERNEL);
+	cpumask_setall(irq_default_affinity);
+	return 0;
+}
+core_initcall(init_irq_default_affinity);
 
 /**
  *	synchronize_irq - wait for pending IRQ handlers (on other CPUs)
@@ -127,7 +134,7 @@ int do_irq_select_affinity(unsigned int irq, struct irq_desc *desc)
 			desc->status &= ~IRQ_AFFINITY_SET;
 	}
 
-	cpumask_and(&desc->affinity, cpu_online_mask, &irq_default_affinity);
+	cpumask_and(&desc->affinity, cpu_online_mask, irq_default_affinity);
 set_affinity:
 	desc->chip->set_affinity(irq, &desc->affinity);
 
diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index d2c0e5e..aae3f74 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -20,7 +20,7 @@ static struct proc_dir_entry *root_irq_dir;
 static int irq_affinity_proc_show(struct seq_file *m, void *v)
 {
 	struct irq_desc *desc = irq_to_desc((long)m->private);
-	cpumask_t *mask = &desc->affinity;
+	const struct cpumask *mask = &desc->affinity;
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	if (desc->status & IRQ_MOVE_PENDING)
@@ -54,7 +54,7 @@ static ssize_t irq_affinity_proc_write(struct file *file,
 	if (err)
 		goto free_cpumask;
 
-	if (!is_affinity_mask_valid(*new_value)) {
+	if (!is_affinity_mask_valid(new_value)) {
 		err = -EINVAL;
 		goto free_cpumask;
 	}
@@ -93,7 +93,7 @@ static const struct file_operations irq_affinity_proc_fops = {
 
 static int default_affinity_show(struct seq_file *m, void *v)
 {
-	seq_cpumask(m, &irq_default_affinity);
+	seq_cpumask(m, irq_default_affinity);
 	seq_putc(m, '\n');
 	return 0;
 }
@@ -101,27 +101,37 @@ static int default_affinity_show(struct seq_file *m, void *v)
 static ssize_t default_affinity_write(struct file *file,
 		const char __user *buffer, size_t count, loff_t *ppos)
 {
-	cpumask_t new_value;
+	cpumask_var_t new_value;
 	int err;
 
-	err = cpumask_parse_user(buffer, count, &new_value);
+	if (!alloc_cpumask_var(&new_value, GFP_KERNEL))
+		return -ENOMEM;
+
+	err = cpumask_parse_user(buffer, count, new_value);
 	if (err)
-		return err;
+		goto out;
 
-	if (!is_affinity_mask_valid(new_value))
-		return -EINVAL;
+	if (!is_affinity_mask_valid(new_value)) {
+		err = -EINVAL;
+		goto out;
+	}
 
 	/*
 	 * Do not allow disabling IRQs completely - it's a too easy
 	 * way to make the system unusable accidentally :-) At least
 	 * one online CPU still has to be targeted.
 	 */
-	if (!cpus_intersects(new_value, cpu_online_map))
-		return -EINVAL;
+	if (!cpumask_intersects(new_value, cpu_online_mask)) {
+		err = -EINVAL;
+		goto out;
+	}
 
-	irq_default_affinity = new_value;
+	cpumask_copy(irq_default_affinity, new_value);
+	err = count;
 
-	return count;
+out:
+	free_cpumask_var(new_value);
+	return err;
 }
 
 static int default_affinity_open(struct inode *inode, struct file *file)
diff --git a/kernel/kexec.c b/kernel/kexec.c
index ac0fde7..3fb855a 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1116,7 +1116,7 @@ void crash_save_cpu(struct pt_regs *regs, int cpu)
 	struct elf_prstatus prstatus;
 	u32 *buf;
 
-	if ((cpu < 0) || (cpu >= NR_CPUS))
+	if ((cpu < 0) || (cpu >= nr_cpu_ids))
 		return;
 
 	/* Using ELF notes here is opportunistic.
diff --git a/kernel/power/poweroff.c b/kernel/power/poweroff.c
index 72016f0..9789083 100644
--- a/kernel/power/poweroff.c
+++ b/kernel/power/poweroff.c
@@ -27,7 +27,7 @@ static DECLARE_WORK(poweroff_work, do_poweroff);
 static void handle_poweroff(int key, struct tty_struct *tty)
 {
 	/* run sysrq poweroff on boot cpu */
-	schedule_work_on(first_cpu(cpu_online_map), &poweroff_work);
+	schedule_work_on(cpumask_first(cpu_online_mask), &poweroff_work);
 }
 
 static struct sysrq_key_op	sysrq_poweroff_op = {
diff --git a/kernel/profile.c b/kernel/profile.c
index 4cb7d68..d18e2d2 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -45,7 +45,7 @@ static unsigned long prof_len, prof_shift;
 int prof_on __read_mostly;
 EXPORT_SYMBOL_GPL(prof_on);
 
-static cpumask_t prof_cpu_mask = CPU_MASK_ALL;
+static cpumask_var_t prof_cpu_mask;
 #ifdef CONFIG_SMP
 static DEFINE_PER_CPU(struct profile_hit *[2], cpu_profile_hits);
 static DEFINE_PER_CPU(int, cpu_profile_flip);
@@ -113,9 +113,13 @@ int __ref profile_init(void)
 	buffer_bytes = prof_len*sizeof(atomic_t);
 	if (!slab_is_available()) {
 		prof_buffer = alloc_bootmem(buffer_bytes);
+		alloc_bootmem_cpumask_var(&prof_cpu_mask);
 		return 0;
 	}
 
+	if (!alloc_cpumask_var(&prof_cpu_mask, GFP_KERNEL))
+		return -ENOMEM;
+
 	prof_buffer = kzalloc(buffer_bytes, GFP_KERNEL);
 	if (prof_buffer)
 		return 0;
@@ -128,6 +132,7 @@ int __ref profile_init(void)
 	if (prof_buffer)
 		return 0;
 
+	free_cpumask_var(prof_cpu_mask);
 	return -ENOMEM;
 }
 
@@ -386,13 +391,15 @@ out_free:
 		return NOTIFY_BAD;
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
-		cpu_set(cpu, prof_cpu_mask);
+		if (prof_cpu_mask != NULL)
+			cpumask_set_cpu(cpu, prof_cpu_mask);
 		break;
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-		cpu_clear(cpu, prof_cpu_mask);
+		if (prof_cpu_mask != NULL)
+			cpumask_clear_cpu(cpu, prof_cpu_mask);
 		if (per_cpu(cpu_profile_hits, cpu)[0]) {
 			page = virt_to_page(per_cpu(cpu_profile_hits, cpu)[0]);
 			per_cpu(cpu_profile_hits, cpu)[0] = NULL;
@@ -430,7 +437,8 @@ void profile_tick(int type)
 
 	if (type == CPU_PROFILING && timer_hook)
 		timer_hook(regs);
-	if (!user_mode(regs) && cpu_isset(smp_processor_id(), prof_cpu_mask))
+	if (!user_mode(regs) && prof_cpu_mask != NULL &&
+	    cpumask_test_cpu(smp_processor_id(), prof_cpu_mask))
 		profile_hit(type, (void *)profile_pc(regs));
 }
 
@@ -442,7 +450,7 @@ void profile_tick(int type)
 static int prof_cpu_mask_read_proc(char *page, char **start, off_t off,
 			int count, int *eof, void *data)
 {
-	int len = cpumask_scnprintf(page, count, (cpumask_t *)data);
+	int len = cpumask_scnprintf(page, count, data);
 	if (count - len < 2)
 		return -EINVAL;
 	len += sprintf(page + len, "\n");
@@ -452,16 +460,20 @@ static int prof_cpu_mask_read_proc(char *page, char **start, off_t off,
 static int prof_cpu_mask_write_proc(struct file *file,
 	const char __user *buffer,  unsigned long count, void *data)
 {
-	cpumask_t *mask = (cpumask_t *)data;
+	struct cpumask *mask = data;
 	unsigned long full_count = count, err;
-	cpumask_t new_value;
+	cpumask_var_t new_value;
 
-	err = cpumask_parse_user(buffer, count, &new_value);
-	if (err)
-		return err;
+	if (!alloc_cpumask_var(&new_value, GFP_KERNEL))
+		return -ENOMEM;
 
-	*mask = new_value;
-	return full_count;
+	err = cpumask_parse_user(buffer, count, new_value);
+	if (!err) {
+		cpumask_copy(mask, new_value);
+		err = full_count;
+	}
+	free_cpumask_var(new_value);
+	return err;
 }
 
 void create_prof_cpu_mask(struct proc_dir_entry *root_irq_dir)
@@ -472,7 +484,7 @@ void create_prof_cpu_mask(struct proc_dir_entry *root_irq_dir)
 	entry = create_proc_entry("prof_cpu_mask", 0600, root_irq_dir);
 	if (!entry)
 		return;
-	entry->data = (void *)&prof_cpu_mask;
+	entry->data = prof_cpu_mask;
 	entry->read_proc = prof_cpu_mask_read_proc;
 	entry->write_proc = prof_cpu_mask_write_proc;
 }
diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index c03ca3e..490934f 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -63,14 +63,14 @@ static struct rcu_ctrlblk rcu_ctrlblk = {
 	.completed = -300,
 	.pending = -300,
 	.lock = __SPIN_LOCK_UNLOCKED(&rcu_ctrlblk.lock),
-	.cpumask = CPU_MASK_NONE,
+	.cpumask = CPU_BITS_NONE,
 };
 static struct rcu_ctrlblk rcu_bh_ctrlblk = {
 	.cur = -300,
 	.completed = -300,
 	.pending = -300,
 	.lock = __SPIN_LOCK_UNLOCKED(&rcu_bh_ctrlblk.lock),
-	.cpumask = CPU_MASK_NONE,
+	.cpumask = CPU_BITS_NONE,
 };
 
 DEFINE_PER_CPU(struct rcu_data, rcu_data) = { 0L };
@@ -85,7 +85,6 @@ static void force_quiescent_state(struct rcu_data *rdp,
 			struct rcu_ctrlblk *rcp)
 {
 	int cpu;
-	cpumask_t cpumask;
 	unsigned long flags;
 
 	set_need_resched();
@@ -96,10 +95,10 @@ static void force_quiescent_state(struct rcu_data *rdp,
 		 * Don't send IPI to itself. With irqs disabled,
 		 * rdp->cpu is the current cpu.
 		 *
-		 * cpu_online_map is updated by the _cpu_down()
+		 * cpu_online_mask is updated by the _cpu_down()
 		 * using __stop_machine(). Since we're in irqs disabled
 		 * section, __stop_machine() is not exectuting, hence
-		 * the cpu_online_map is stable.
+		 * the cpu_online_mask is stable.
 		 *
 		 * However,  a cpu might have been offlined _just_ before
 		 * we disabled irqs while entering here.
@@ -107,13 +106,14 @@ static void force_quiescent_state(struct rcu_data *rdp,
 		 * notification, leading to the offlined cpu's bit
 		 * being set in the rcp->cpumask.
 		 *
-		 * Hence cpumask = (rcp->cpumask & cpu_online_map) to prevent
+		 * Hence cpumask = (rcp->cpumask & cpu_online_mask) to prevent
 		 * sending smp_reschedule() to an offlined CPU.
 		 */
-		cpus_and(cpumask, rcp->cpumask, cpu_online_map);
-		cpu_clear(rdp->cpu, cpumask);
-		for_each_cpu_mask_nr(cpu, cpumask)
-			smp_send_reschedule(cpu);
+		for_each_cpu_and(cpu,
+				  to_cpumask(rcp->cpumask), cpu_online_mask) {
+			if (cpu != rdp->cpu)
+				smp_send_reschedule(cpu);
+		}
 	}
 	spin_unlock_irqrestore(&rcp->lock, flags);
 }
@@ -193,7 +193,7 @@ static void print_other_cpu_stall(struct rcu_ctrlblk *rcp)
 
 	printk(KERN_ERR "INFO: RCU detected CPU stalls:");
 	for_each_possible_cpu(cpu) {
-		if (cpu_isset(cpu, rcp->cpumask))
+		if (cpumask_test_cpu(cpu, to_cpumask(rcp->cpumask)))
 			printk(" %d", cpu);
 	}
 	printk(" (detected by %d, t=%ld jiffies)\n",
@@ -221,7 +221,8 @@ static void check_cpu_stall(struct rcu_ctrlblk *rcp)
 	long delta;
 
 	delta = jiffies - rcp->jiffies_stall;
-	if (cpu_isset(smp_processor_id(), rcp->cpumask) && delta >= 0) {
+	if (cpumask_test_cpu(smp_processor_id(), to_cpumask(rcp->cpumask)) &&
+		delta >= 0) {
 
 		/* We haven't checked in, so go dump stack. */
 		print_cpu_stall(rcp);
@@ -393,7 +394,8 @@ static void rcu_start_batch(struct rcu_ctrlblk *rcp)
 		 * unnecessarily.
 		 */
 		smp_mb();
-		cpumask_andnot(&rcp->cpumask, cpu_online_mask, nohz_cpu_mask);
+		cpumask_andnot(to_cpumask(rcp->cpumask),
+			       cpu_online_mask, nohz_cpu_mask);
 
 		rcp->signaled = 0;
 	}
@@ -406,8 +408,8 @@ static void rcu_start_batch(struct rcu_ctrlblk *rcp)
  */
 static void cpu_quiet(int cpu, struct rcu_ctrlblk *rcp)
 {
-	cpu_clear(cpu, rcp->cpumask);
-	if (cpus_empty(rcp->cpumask)) {
+	cpumask_clear_cpu(cpu, to_cpumask(rcp->cpumask));
+	if (cpumask_empty(to_cpumask(rcp->cpumask))) {
 		/* batch completed ! */
 		rcp->completed = rcp->cur;
 		rcu_start_batch(rcp);
diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index 0498265..f9dc8f3 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -164,7 +164,8 @@ static char *rcu_try_flip_state_names[] =
 	{ "idle", "waitack", "waitzero", "waitmb" };
 #endif /* #ifdef CONFIG_RCU_TRACE */
 
-static cpumask_t rcu_cpu_online_map __read_mostly = CPU_MASK_NONE;
+static DECLARE_BITMAP(rcu_cpu_online_map, NR_CPUS) __read_mostly
+	= CPU_BITS_NONE;
 
 /*
  * Enum and per-CPU flag to determine when each CPU has seen
@@ -758,7 +759,7 @@ rcu_try_flip_idle(void)
 
 	/* Now ask each CPU for acknowledgement of the flip. */
 
-	for_each_cpu_mask_nr(cpu, rcu_cpu_online_map) {
+	for_each_cpu(cpu, to_cpumask(rcu_cpu_online_map)) {
 		per_cpu(rcu_flip_flag, cpu) = rcu_flipped;
 		dyntick_save_progress_counter(cpu);
 	}
@@ -776,7 +777,7 @@ rcu_try_flip_waitack(void)
 	int cpu;
 
 	RCU_TRACE_ME(rcupreempt_trace_try_flip_a1);
-	for_each_cpu_mask_nr(cpu, rcu_cpu_online_map)
+	for_each_cpu(cpu, to_cpumask(rcu_cpu_online_map))
 		if (rcu_try_flip_waitack_needed(cpu) &&
 		    per_cpu(rcu_flip_flag, cpu) != rcu_flip_seen) {
 			RCU_TRACE_ME(rcupreempt_trace_try_flip_ae1);
@@ -808,7 +809,7 @@ rcu_try_flip_waitzero(void)
 	/* Check to see if the sum of the "last" counters is zero. */
 
 	RCU_TRACE_ME(rcupreempt_trace_try_flip_z1);
-	for_each_cpu_mask_nr(cpu, rcu_cpu_online_map)
+	for_each_cpu(cpu, to_cpumask(rcu_cpu_online_map))
 		sum += RCU_DATA_CPU(cpu)->rcu_flipctr[lastidx];
 	if (sum != 0) {
 		RCU_TRACE_ME(rcupreempt_trace_try_flip_ze1);
@@ -823,7 +824,7 @@ rcu_try_flip_waitzero(void)
 	smp_mb();  /*  ^^^^^^^^^^^^ */
 
 	/* Call for a memory barrier from each CPU. */
-	for_each_cpu_mask_nr(cpu, rcu_cpu_online_map) {
+	for_each_cpu(cpu, to_cpumask(rcu_cpu_online_map)) {
 		per_cpu(rcu_mb_flag, cpu) = rcu_mb_needed;
 		dyntick_save_progress_counter(cpu);
 	}
@@ -843,7 +844,7 @@ rcu_try_flip_waitmb(void)
 	int cpu;
 
 	RCU_TRACE_ME(rcupreempt_trace_try_flip_m1);
-	for_each_cpu_mask_nr(cpu, rcu_cpu_online_map)
+	for_each_cpu(cpu, to_cpumask(rcu_cpu_online_map))
 		if (rcu_try_flip_waitmb_needed(cpu) &&
 		    per_cpu(rcu_mb_flag, cpu) != rcu_mb_done) {
 			RCU_TRACE_ME(rcupreempt_trace_try_flip_me1);
@@ -1032,7 +1033,7 @@ void rcu_offline_cpu(int cpu)
 	RCU_DATA_CPU(cpu)->rcu_flipctr[0] = 0;
 	RCU_DATA_CPU(cpu)->rcu_flipctr[1] = 0;
 
-	cpu_clear(cpu, rcu_cpu_online_map);
+	cpumask_clear_cpu(cpu, to_cpumask(rcu_cpu_online_map));
 
 	spin_unlock_irqrestore(&rcu_ctrlblk.fliplock, flags);
 
@@ -1072,7 +1073,7 @@ void __cpuinit rcu_online_cpu(int cpu)
 	struct rcu_data *rdp;
 
 	spin_lock_irqsave(&rcu_ctrlblk.fliplock, flags);
-	cpu_set(cpu, rcu_cpu_online_map);
+	cpumask_set_cpu(cpu, to_cpumask(rcu_cpu_online_map));
 	spin_unlock_irqrestore(&rcu_ctrlblk.fliplock, flags);
 
 	/*
@@ -1430,7 +1431,7 @@ void __init __rcu_init(void)
 	 * We don't need protection against CPU-Hotplug here
 	 * since
 	 * a) If a CPU comes online while we are iterating over the
-	 *    cpu_online_map below, we would only end up making a
+	 *    cpu_online_mask below, we would only end up making a
 	 *    duplicate call to rcu_online_cpu() which sets the corresponding
 	 *    CPU's mask in the rcu_cpu_online_map.
 	 *
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index b310655..3245b40 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -868,49 +868,52 @@ static int rcu_idle_cpu;	/* Force all torture tasks off this CPU */
  */
 static void rcu_torture_shuffle_tasks(void)
 {
-	cpumask_t tmp_mask;
+	cpumask_var_t tmp_mask;
 	int i;
 
-	cpus_setall(tmp_mask);
+	if (!alloc_cpumask_var(&tmp_mask, GFP_KERNEL))
+		BUG();
+
+	cpumask_setall(tmp_mask);
 	get_online_cpus();
 
 	/* No point in shuffling if there is only one online CPU (ex: UP) */
-	if (num_online_cpus() == 1) {
-		put_online_cpus();
-		return;
-	}
+	if (num_online_cpus() == 1)
+		goto out;
 
 	if (rcu_idle_cpu != -1)
-		cpu_clear(rcu_idle_cpu, tmp_mask);
+		cpumask_clear_cpu(rcu_idle_cpu, tmp_mask);
 
-	set_cpus_allowed_ptr(current, &tmp_mask);
+	set_cpus_allowed_ptr(current, tmp_mask);
 
 	if (reader_tasks) {
 		for (i = 0; i < nrealreaders; i++)
 			if (reader_tasks[i])
 				set_cpus_allowed_ptr(reader_tasks[i],
-						     &tmp_mask);
+						     tmp_mask);
 	}
 
 	if (fakewriter_tasks) {
 		for (i = 0; i < nfakewriters; i++)
 			if (fakewriter_tasks[i])
 				set_cpus_allowed_ptr(fakewriter_tasks[i],
-						     &tmp_mask);
+						     tmp_mask);
 	}
 
 	if (writer_task)
-		set_cpus_allowed_ptr(writer_task, &tmp_mask);
+		set_cpus_allowed_ptr(writer_task, tmp_mask);
 
 	if (stats_task)
-		set_cpus_allowed_ptr(stats_task, &tmp_mask);
+		set_cpus_allowed_ptr(stats_task, tmp_mask);
 
 	if (rcu_idle_cpu == -1)
 		rcu_idle_cpu = num_online_cpus() - 1;
 	else
 		rcu_idle_cpu--;
 
+out:
 	put_online_cpus();
+	free_cpumask_var(tmp_mask);
 }
 
 /* Shuffle tasks across CPUs, with the intent of allowing each CPU in the
diff --git a/kernel/sched.c b/kernel/sched.c
index 27ba1d6..dd862d7 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3715,7 +3715,7 @@ redo:
 		 * don't kick the migration_thread, if the curr
 		 * task on busiest cpu can't be moved to this_cpu
 		 */
-		if (!cpu_isset(this_cpu, busiest->curr->cpus_allowed)) {
+		if (!cpumask_test_cpu(this_cpu, &busiest->curr->cpus_allowed)) {
 			double_unlock_balance(this_rq, busiest);
 			all_pinned = 1;
 			return ld_moved;
@@ -6220,9 +6220,7 @@ static int __migrate_task_irq(struct task_struct *p, int src_cpu, int dest_cpu)
 static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
 {
 	int dest_cpu;
-	/* FIXME: Use cpumask_of_node here. */
-	cpumask_t _nodemask = node_to_cpumask(cpu_to_node(dead_cpu));
-	const struct cpumask *nodemask = &_nodemask;
+	const struct cpumask *nodemask = cpumask_of_node(cpu_to_node(dead_cpu));
 
 again:
 	/* Look for allowed, online CPU in same node. */
@@ -7133,21 +7131,18 @@ static int find_next_best_node(int node, nodemask_t *used_nodes)
 static void sched_domain_node_span(int node, struct cpumask *span)
 {
 	nodemask_t used_nodes;
-	/* FIXME: use cpumask_of_node() */
-	node_to_cpumask_ptr(nodemask, node);
 	int i;
 
-	cpus_clear(*span);
+	cpumask_clear(span);
 	nodes_clear(used_nodes);
 
-	cpus_or(*span, *span, *nodemask);
+	cpumask_or(span, span, cpumask_of_node(node));
 	node_set(node, used_nodes);
 
 	for (i = 1; i < SD_NODES_PER_DOMAIN; i++) {
 		int next_node = find_next_best_node(node, &used_nodes);
 
-		node_to_cpumask_ptr_next(nodemask, next_node);
-		cpus_or(*span, *span, *nodemask);
+		cpumask_or(span, span, cpumask_of_node(next_node));
 	}
 }
 #endif /* CONFIG_NUMA */
@@ -7227,9 +7222,7 @@ cpu_to_phys_group(int cpu, const struct cpumask *cpu_map,
 {
 	int group;
 #ifdef CONFIG_SCHED_MC
-	/* FIXME: Use cpu_coregroup_mask. */
-	*mask = cpu_coregroup_map(cpu);
-	cpus_and(*mask, *mask, *cpu_map);
+	cpumask_and(mask, cpu_coregroup_mask(cpu), cpu_map);
 	group = cpumask_first(mask);
 #elif defined(CONFIG_SCHED_SMT)
 	cpumask_and(mask, &per_cpu(cpu_sibling_map, cpu), cpu_map);
@@ -7259,10 +7252,8 @@ static int cpu_to_allnodes_group(int cpu, const struct cpumask *cpu_map,
 				 struct cpumask *nodemask)
 {
 	int group;
-	/* FIXME: use cpumask_of_node */
-	node_to_cpumask_ptr(pnodemask, cpu_to_node(cpu));
 
-	cpumask_and(nodemask, pnodemask, cpu_map);
+	cpumask_and(nodemask, cpumask_of_node(cpu_to_node(cpu)), cpu_map);
 	group = cpumask_first(nodemask);
 
 	if (sg)
@@ -7313,10 +7304,8 @@ static void free_sched_groups(const struct cpumask *cpu_map,
 
 		for (i = 0; i < nr_node_ids; i++) {
 			struct sched_group *oldsg, *sg = sched_group_nodes[i];
-			/* FIXME: Use cpumask_of_node */
-			node_to_cpumask_ptr(pnodemask, i);
 
-			cpus_and(*nodemask, *pnodemask, *cpu_map);
+			cpumask_and(nodemask, cpumask_of_node(i), cpu_map);
 			if (cpumask_empty(nodemask))
 				continue;
 
@@ -7525,9 +7514,7 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 	for_each_cpu(i, cpu_map) {
 		struct sched_domain *sd = NULL, *p;
 
-		/* FIXME: use cpumask_of_node */
-		*nodemask = node_to_cpumask(cpu_to_node(i));
-		cpus_and(*nodemask, *nodemask, *cpu_map);
+		cpumask_and(nodemask, cpumask_of_node(cpu_to_node(i)), cpu_map);
 
 #ifdef CONFIG_NUMA
 		if (cpumask_weight(cpu_map) >
@@ -7568,9 +7555,8 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 		sd = &per_cpu(core_domains, i).sd;
 		SD_INIT(sd, MC);
 		set_domain_attribute(sd, attr);
-		*sched_domain_span(sd) = cpu_coregroup_map(i);
-		cpumask_and(sched_domain_span(sd),
-			    sched_domain_span(sd), cpu_map);
+		cpumask_and(sched_domain_span(sd), cpu_map,
+						   cpu_coregroup_mask(i));
 		sd->parent = p;
 		p->child = sd;
 		cpu_to_core_group(i, cpu_map, &sd->groups, tmpmask);
@@ -7606,9 +7592,7 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 #ifdef CONFIG_SCHED_MC
 	/* Set up multi-core groups */
 	for_each_cpu(i, cpu_map) {
-		/* FIXME: Use cpu_coregroup_mask */
-		*this_core_map = cpu_coregroup_map(i);
-		cpus_and(*this_core_map, *this_core_map, *cpu_map);
+		cpumask_and(this_core_map, cpu_coregroup_mask(i), cpu_map);
 		if (i != cpumask_first(this_core_map))
 			continue;
 
@@ -7620,9 +7604,7 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 
 	/* Set up physical groups */
 	for (i = 0; i < nr_node_ids; i++) {
-		/* FIXME: Use cpumask_of_node */
-		*nodemask = node_to_cpumask(i);
-		cpus_and(*nodemask, *nodemask, *cpu_map);
+		cpumask_and(nodemask, cpumask_of_node(i), cpu_map);
 		if (cpumask_empty(nodemask))
 			continue;
 
@@ -7644,11 +7626,8 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 		struct sched_group *sg, *prev;
 		int j;
 
-		/* FIXME: Use cpumask_of_node */
-		*nodemask = node_to_cpumask(i);
 		cpumask_clear(covered);
-
-		cpus_and(*nodemask, *nodemask, *cpu_map);
+		cpumask_and(nodemask, cpumask_of_node(i), cpu_map);
 		if (cpumask_empty(nodemask)) {
 			sched_group_nodes[i] = NULL;
 			continue;
@@ -7679,8 +7658,6 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 
 		for (j = 0; j < nr_node_ids; j++) {
 			int n = (i + j) % nr_node_ids;
-			/* FIXME: Use cpumask_of_node */
-			node_to_cpumask_ptr(pnodemask, n);
 
 			cpumask_complement(notcovered, covered);
 			cpumask_and(tmpmask, notcovered, cpu_map);
@@ -7688,7 +7665,7 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 			if (cpumask_empty(tmpmask))
 				break;
 
-			cpumask_and(tmpmask, tmpmask, pnodemask);
+			cpumask_and(tmpmask, tmpmask, cpumask_of_node(n));
 			if (cpumask_empty(tmpmask))
 				continue;
 
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 833b6d4..954e1a8 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1383,7 +1383,8 @@ static inline void init_sched_rt_class(void)
 	unsigned int i;
 
 	for_each_possible_cpu(i)
-		alloc_cpumask_var(&per_cpu(local_cpu_mask, i), GFP_KERNEL);
+		alloc_cpumask_var_node(&per_cpu(local_cpu_mask, i),
+					GFP_KERNEL, cpu_to_node(i));
 }
 #endif /* CONFIG_SMP */
 
diff --git a/kernel/smp.c b/kernel/smp.c
index 75c8dde..5cfa0e5 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -24,8 +24,8 @@ struct call_function_data {
 	struct call_single_data csd;
 	spinlock_t lock;
 	unsigned int refs;
-	cpumask_t cpumask;
 	struct rcu_head rcu_head;
+	unsigned long cpumask_bits[];
 };
 
 struct call_single_queue {
@@ -110,13 +110,13 @@ void generic_smp_call_function_interrupt(void)
 	list_for_each_entry_rcu(data, &call_function_queue, csd.list) {
 		int refs;
 
-		if (!cpu_isset(cpu, data->cpumask))
+		if (!cpumask_test_cpu(cpu, to_cpumask(data->cpumask_bits)))
 			continue;
 
 		data->csd.func(data->csd.info);
 
 		spin_lock(&data->lock);
-		cpu_clear(cpu, data->cpumask);
+		cpumask_clear_cpu(cpu, to_cpumask(data->cpumask_bits));
 		WARN_ON(data->refs == 0);
 		data->refs--;
 		refs = data->refs;
@@ -223,7 +223,7 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 		local_irq_save(flags);
 		func(info);
 		local_irq_restore(flags);
-	} else if ((unsigned)cpu < NR_CPUS && cpu_online(cpu)) {
+	} else if ((unsigned)cpu < nr_cpu_ids && cpu_online(cpu)) {
 		struct call_single_data *data = NULL;
 
 		if (!wait) {
@@ -266,51 +266,19 @@ void __smp_call_function_single(int cpu, struct call_single_data *data)
 	generic_exec_single(cpu, data);
 }
 
-/* Dummy function */
-static void quiesce_dummy(void *unused)
-{
-}
-
-/*
- * Ensure stack based data used in call function mask is safe to free.
- *
- * This is needed by smp_call_function_mask when using on-stack data, because
- * a single call function queue is shared by all CPUs, and any CPU may pick up
- * the data item on the queue at any time before it is deleted. So we need to
- * ensure that all CPUs have transitioned through a quiescent state after
- * this call.
- *
- * This is a very slow function, implemented by sending synchronous IPIs to
- * all possible CPUs. For this reason, we have to alloc data rather than use
- * stack based data even in the case of synchronous calls. The stack based
- * data is then just used for deadlock/oom fallback which will be very rare.
- *
- * If a faster scheme can be made, we could go back to preferring stack based
- * data -- the data allocation/free is non-zero cost.
- */
-static void smp_call_function_mask_quiesce_stack(cpumask_t mask)
-{
-	struct call_single_data data;
-	int cpu;
-
-	data.func = quiesce_dummy;
-	data.info = NULL;
-
-	for_each_cpu_mask(cpu, mask) {
-		data.flags = CSD_FLAG_WAIT;
-		generic_exec_single(cpu, &data);
-	}
-}
+/* FIXME: Shim for archs using old arch_send_call_function_ipi API. */
+#ifndef arch_send_call_function_ipi_mask
+#define arch_send_call_function_ipi_mask(maskp) \
+	arch_send_call_function_ipi(*(maskp))
+#endif
 
 /**
- * smp_call_function_mask(): Run a function on a set of other CPUs.
- * @mask: The set of cpus to run on.
+ * smp_call_function_many(): Run a function on a set of other CPUs.
+ * @mask: The set of cpus to run on (only runs on online subset).
  * @func: The function to run. This must be fast and non-blocking.
  * @info: An arbitrary pointer to pass to the function.
  * @wait: If true, wait (atomically) until function has completed on other CPUs.
  *
- * Returns 0 on success, else a negative status code.
- *
  * If @wait is true, then returns once @func has returned. Note that @wait
  * will be implicitly turned on in case of allocation failures, since
  * we fall back to on-stack allocation.
@@ -319,53 +287,57 @@ static void smp_call_function_mask_quiesce_stack(cpumask_t mask)
  * hardware interrupt handler or from a bottom half handler. Preemption
  * must be disabled when calling this function.
  */
-int smp_call_function_mask(cpumask_t mask, void (*func)(void *), void *info,
-			   int wait)
+void smp_call_function_many(const struct cpumask *mask,
+			    void (*func)(void *), void *info,
+			    bool wait)
 {
-	struct call_function_data d;
-	struct call_function_data *data = NULL;
-	cpumask_t allbutself;
+	struct call_function_data *data;
 	unsigned long flags;
-	int cpu, num_cpus;
-	int slowpath = 0;
+	int cpu, next_cpu;
 
 	/* Can deadlock when called with interrupts disabled */
 	WARN_ON(irqs_disabled());
 
-	cpu = smp_processor_id();
-	allbutself = cpu_online_map;
-	cpu_clear(cpu, allbutself);
-	cpus_and(mask, mask, allbutself);
-	num_cpus = cpus_weight(mask);
-
-	/*
-	 * If zero CPUs, return. If just a single CPU, turn this request
-	 * into a targetted single call instead since it's faster.
-	 */
-	if (!num_cpus)
-		return 0;
-	else if (num_cpus == 1) {
-		cpu = first_cpu(mask);
-		return smp_call_function_single(cpu, func, info, wait);
+	/* So, what's a CPU they want?  Ignoring this one. */
+	cpu = cpumask_first_and(mask, cpu_online_mask);
+	if (cpu == smp_processor_id())
+		cpu = cpumask_next_and(cpu, mask, cpu_online_mask);
+	/* No online cpus?  We're done. */
+	if (cpu >= nr_cpu_ids)
+		return;
+
+	/* Do we have another CPU which isn't us? */
+	next_cpu = cpumask_next_and(cpu, mask, cpu_online_mask);
+	if (next_cpu == smp_processor_id())
+		next_cpu = cpumask_next_and(next_cpu, mask, cpu_online_mask);
+
+	/* Fastpath: do that cpu by itself. */
+	if (next_cpu >= nr_cpu_ids) {
+		smp_call_function_single(cpu, func, info, wait);
+		return;
 	}
 
-	data = kmalloc(sizeof(*data), GFP_ATOMIC);
-	if (data) {
-		data->csd.flags = CSD_FLAG_ALLOC;
-		if (wait)
-			data->csd.flags |= CSD_FLAG_WAIT;
-	} else {
-		data = &d;
-		data->csd.flags = CSD_FLAG_WAIT;
-		wait = 1;
-		slowpath = 1;
+	data = kmalloc(sizeof(*data) + cpumask_size(), GFP_ATOMIC);
+	if (unlikely(!data)) {
+		/* Slow path. */
+		for_each_online_cpu(cpu) {
+			if (cpu == smp_processor_id())
+				continue;
+			if (cpumask_test_cpu(cpu, mask))
+				smp_call_function_single(cpu, func, info, wait);
+		}
+		return;
 	}
 
 	spin_lock_init(&data->lock);
+	data->csd.flags = CSD_FLAG_ALLOC;
+	if (wait)
+		data->csd.flags |= CSD_FLAG_WAIT;
 	data->csd.func = func;
 	data->csd.info = info;
-	data->refs = num_cpus;
-	data->cpumask = mask;
+	cpumask_and(to_cpumask(data->cpumask_bits), mask, cpu_online_mask);
+	cpumask_clear_cpu(smp_processor_id(), to_cpumask(data->cpumask_bits));
+	data->refs = cpumask_weight(to_cpumask(data->cpumask_bits));
 
 	spin_lock_irqsave(&call_function_lock, flags);
 	list_add_tail_rcu(&data->csd.list, &call_function_queue);
@@ -377,18 +349,13 @@ int smp_call_function_mask(cpumask_t mask, void (*func)(void *), void *info,
 	smp_mb();
 
 	/* Send a message to all CPUs in the map */
-	arch_send_call_function_ipi(mask);
+	arch_send_call_function_ipi_mask(to_cpumask(data->cpumask_bits));
 
 	/* optionally wait for the CPUs to complete */
-	if (wait) {
+	if (wait)
 		csd_flag_wait(&data->csd);
-		if (unlikely(slowpath))
-			smp_call_function_mask_quiesce_stack(mask);
-	}
-
-	return 0;
 }
-EXPORT_SYMBOL(smp_call_function_mask);
+EXPORT_SYMBOL(smp_call_function_many);
 
 /**
  * smp_call_function(): Run a function on all other CPUs.
@@ -396,7 +363,7 @@ EXPORT_SYMBOL(smp_call_function_mask);
  * @info: An arbitrary pointer to pass to the function.
  * @wait: If true, wait (atomically) until function has completed on other CPUs.
  *
- * Returns 0 on success, else a negative status code.
+ * Returns 0.
  *
  * If @wait is true, then returns once @func has returned; otherwise
  * it returns just before the target cpu calls @func. In case of allocation
@@ -407,12 +374,10 @@ EXPORT_SYMBOL(smp_call_function_mask);
  */
 int smp_call_function(void (*func)(void *), void *info, int wait)
 {
-	int ret;
-
 	preempt_disable();
-	ret = smp_call_function_mask(cpu_online_map, func, info, wait);
+	smp_call_function_many(cpu_online_mask, func, info, wait);
 	preempt_enable();
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL(smp_call_function);
 
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 670c1ec..bdbe9de 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -733,7 +733,7 @@ static int __cpuinit cpu_callback(struct notifier_block *nfb,
 			break;
 		/* Unbind so it can run.  Fall thru. */
 		kthread_bind(per_cpu(ksoftirqd, hotcpu),
-			     any_online_cpu(cpu_online_map));
+			     cpumask_any(cpu_online_mask));
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN: {
 		struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index 1ab790c..d9188c6 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -303,17 +303,15 @@ cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		break;
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
-		check_cpu = any_online_cpu(cpu_online_map);
+		check_cpu = cpumask_any(cpu_online_mask);
 		wake_up_process(per_cpu(watchdog_task, hotcpu));
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
 		if (hotcpu == check_cpu) {
-			cpumask_t temp_cpu_online_map = cpu_online_map;
-
-			cpu_clear(hotcpu, temp_cpu_online_map);
-			check_cpu = any_online_cpu(temp_cpu_online_map);
+			/* Pick any other online cpu. */
+			check_cpu = cpumask_any_but(cpu_online_mask, hotcpu);
 		}
 		break;
 
@@ -323,7 +321,7 @@ cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 			break;
 		/* Unbind so it can run.  Fall thru. */
 		kthread_bind(per_cpu(watchdog_task, hotcpu),
-			     any_online_cpu(cpu_online_map));
+			     cpumask_any(cpu_online_mask));
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		p = per_cpu(watchdog_task, hotcpu);
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 24e8cea..286c417 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -69,10 +69,10 @@ static void stop_cpu(struct work_struct *unused)
 	int err;
 
 	if (!active_cpus) {
-		if (cpu == first_cpu(cpu_online_map))
+		if (cpu == cpumask_first(cpu_online_mask))
 			smdata = &active;
 	} else {
-		if (cpu_isset(cpu, *active_cpus))
+		if (cpumask_test_cpu(cpu, active_cpus))
 			smdata = &active;
 	}
 	/* Simple state machine */
@@ -109,7 +109,7 @@ static int chill(void *unused)
 	return 0;
 }
 
-int __stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus)
+int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
 {
 	struct work_struct *sm_work;
 	int i, ret;
@@ -142,7 +142,7 @@ int __stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus)
 	return ret;
 }
 
-int stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus)
+int stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
 {
 	int ret;
 
diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index 6d7dc4e..888adbc 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -290,18 +290,17 @@ ret:
 	return;
 }
 
-static int add_del_listener(pid_t pid, cpumask_t *maskp, int isadd)
+static int add_del_listener(pid_t pid, const struct cpumask *mask, int isadd)
 {
 	struct listener_list *listeners;
 	struct listener *s, *tmp;
 	unsigned int cpu;
-	cpumask_t mask = *maskp;
 
-	if (!cpus_subset(mask, cpu_possible_map))
+	if (!cpumask_subset(mask, cpu_possible_mask))
 		return -EINVAL;
 
 	if (isadd == REGISTER) {
-		for_each_cpu_mask_nr(cpu, mask) {
+		for_each_cpu(cpu, mask) {
 			s = kmalloc_node(sizeof(struct listener), GFP_KERNEL,
 					 cpu_to_node(cpu));
 			if (!s)
@@ -320,7 +319,7 @@ static int add_del_listener(pid_t pid, cpumask_t *maskp, int isadd)
 
 	/* Deregister or cleanup */
 cleanup:
-	for_each_cpu_mask_nr(cpu, mask) {
+	for_each_cpu(cpu, mask) {
 		listeners = &per_cpu(listener_array, cpu);
 		down_write(&listeners->sem);
 		list_for_each_entry_safe(s, tmp, &listeners->list, list) {
@@ -335,7 +334,7 @@ cleanup:
 	return 0;
 }
 
-static int parse(struct nlattr *na, cpumask_t *mask)
+static int parse(struct nlattr *na, struct cpumask *mask)
 {
 	char *data;
 	int len;
@@ -428,23 +427,33 @@ err:
 
 static int taskstats_user_cmd(struct sk_buff *skb, struct genl_info *info)
 {
-	int rc = 0;
+	int rc;
 	struct sk_buff *rep_skb;
 	struct taskstats *stats;
 	size_t size;
-	cpumask_t mask;
+	cpumask_var_t mask;
+
+	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
+		return -ENOMEM;
 
-	rc = parse(info->attrs[TASKSTATS_CMD_ATTR_REGISTER_CPUMASK], &mask);
+	rc = parse(info->attrs[TASKSTATS_CMD_ATTR_REGISTER_CPUMASK], mask);
 	if (rc < 0)
-		return rc;
-	if (rc == 0)
-		return add_del_listener(info->snd_pid, &mask, REGISTER);
+		goto free_return_rc;
+	if (rc == 0) {
+		rc = add_del_listener(info->snd_pid, mask, REGISTER);
+		goto free_return_rc;
+	}
 
-	rc = parse(info->attrs[TASKSTATS_CMD_ATTR_DEREGISTER_CPUMASK], &mask);
+	rc = parse(info->attrs[TASKSTATS_CMD_ATTR_DEREGISTER_CPUMASK], mask);
 	if (rc < 0)
+		goto free_return_rc;
+	if (rc == 0) {
+		rc = add_del_listener(info->snd_pid, mask, DEREGISTER);
+free_return_rc:
+		free_cpumask_var(mask);
 		return rc;
-	if (rc == 0)
-		return add_del_listener(info->snd_pid, &mask, DEREGISTER);
+	}
+	free_cpumask_var(mask);
 
 	/*
 	 * Size includes space for nested attributes
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 9ed2eec..ca89e15 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -145,10 +145,11 @@ static void clocksource_watchdog(unsigned long data)
 		 * Cycle through CPUs to check if the CPUs stay
 		 * synchronized to each other.
 		 */
-		int next_cpu = next_cpu_nr(raw_smp_processor_id(), cpu_online_map);
+		int next_cpu = cpumask_next(raw_smp_processor_id(),
+					    cpu_online_mask);
 
 		if (next_cpu >= nr_cpu_ids)
-			next_cpu = first_cpu(cpu_online_map);
+			next_cpu = cpumask_first(cpu_online_mask);
 		watchdog_timer.expires += WATCHDOG_INTERVAL;
 		add_timer_on(&watchdog_timer, next_cpu);
 	}
@@ -173,7 +174,7 @@ static void clocksource_check_watchdog(struct clocksource *cs)
 			watchdog_last = watchdog->read();
 			watchdog_timer.expires = jiffies + WATCHDOG_INTERVAL;
 			add_timer_on(&watchdog_timer,
-				     first_cpu(cpu_online_map));
+				     cpumask_first(cpu_online_mask));
 		}
 	} else {
 		if (cs->flags & CLOCK_SOURCE_IS_CONTINUOUS)
@@ -195,7 +196,7 @@ static void clocksource_check_watchdog(struct clocksource *cs)
 				watchdog_timer.expires =
 					jiffies + WATCHDOG_INTERVAL;
 				add_timer_on(&watchdog_timer,
-					     first_cpu(cpu_online_map));
+					     cpumask_first(cpu_online_mask));
 			}
 		}
 	}
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 9590af2..118a3b3 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -28,7 +28,9 @@
  */
 
 struct tick_device tick_broadcast_device;
-static cpumask_t tick_broadcast_mask;
+/* FIXME: Use cpumask_var_t. */
+static DECLARE_BITMAP(tick_broadcast_mask, NR_CPUS);
+static DECLARE_BITMAP(tmpmask, NR_CPUS);
 static DEFINE_SPINLOCK(tick_broadcast_lock);
 static int tick_broadcast_force;
 
@@ -46,9 +48,9 @@ struct tick_device *tick_get_broadcast_device(void)
 	return &tick_broadcast_device;
 }
 
-cpumask_t *tick_get_broadcast_mask(void)
+struct cpumask *tick_get_broadcast_mask(void)
 {
-	return &tick_broadcast_mask;
+	return to_cpumask(tick_broadcast_mask);
 }
 
 /*
@@ -72,7 +74,7 @@ int tick_check_broadcast_device(struct clock_event_device *dev)
 
 	clockevents_exchange_device(NULL, dev);
 	tick_broadcast_device.evtdev = dev;
-	if (!cpus_empty(tick_broadcast_mask))
+	if (!cpumask_empty(tick_get_broadcast_mask()))
 		tick_broadcast_start_periodic(dev);
 	return 1;
 }
@@ -104,7 +106,7 @@ int tick_device_uses_broadcast(struct clock_event_device *dev, int cpu)
 	 */
 	if (!tick_device_is_functional(dev)) {
 		dev->event_handler = tick_handle_periodic;
-		cpu_set(cpu, tick_broadcast_mask);
+		cpumask_set_cpu(cpu, tick_get_broadcast_mask());
 		tick_broadcast_start_periodic(tick_broadcast_device.evtdev);
 		ret = 1;
 	} else {
@@ -116,7 +118,7 @@ int tick_device_uses_broadcast(struct clock_event_device *dev, int cpu)
 		if (!(dev->features & CLOCK_EVT_FEAT_C3STOP)) {
 			int cpu = smp_processor_id();
 
-			cpu_clear(cpu, tick_broadcast_mask);
+			cpumask_clear_cpu(cpu, tick_get_broadcast_mask());
 			tick_broadcast_clear_oneshot(cpu);
 		}
 	}
@@ -125,9 +127,9 @@ int tick_device_uses_broadcast(struct clock_event_device *dev, int cpu)
 }
 
 /*
- * Broadcast the event to the cpus, which are set in the mask
+ * Broadcast the event to the cpus, which are set in the mask (mangled).
  */
-static void tick_do_broadcast(cpumask_t mask)
+static void tick_do_broadcast(struct cpumask *mask)
 {
 	int cpu = smp_processor_id();
 	struct tick_device *td;
@@ -135,22 +137,21 @@ static void tick_do_broadcast(cpumask_t mask)
 	/*
 	 * Check, if the current cpu is in the mask
 	 */
-	if (cpu_isset(cpu, mask)) {
-		cpu_clear(cpu, mask);
+	if (cpumask_test_cpu(cpu, mask)) {
+		cpumask_clear_cpu(cpu, mask);
 		td = &per_cpu(tick_cpu_device, cpu);
 		td->evtdev->event_handler(td->evtdev);
 	}
 
-	if (!cpus_empty(mask)) {
+	if (!cpumask_empty(mask)) {
 		/*
 		 * It might be necessary to actually check whether the devices
 		 * have different broadcast functions. For now, just use the
 		 * one of the first device. This works as long as we have this
 		 * misfeature only on x86 (lapic)
 		 */
-		cpu = first_cpu(mask);
-		td = &per_cpu(tick_cpu_device, cpu);
-		td->evtdev->broadcast(&mask);
+		td = &per_cpu(tick_cpu_device, cpumask_first(mask));
+		td->evtdev->broadcast(mask);
 	}
 }
 
@@ -160,12 +161,11 @@ static void tick_do_broadcast(cpumask_t mask)
  */
 static void tick_do_periodic_broadcast(void)
 {
-	cpumask_t mask;
-
 	spin_lock(&tick_broadcast_lock);
 
-	cpus_and(mask, cpu_online_map, tick_broadcast_mask);
-	tick_do_broadcast(mask);
+	cpumask_and(to_cpumask(tmpmask),
+		    cpu_online_mask, tick_get_broadcast_mask());
+	tick_do_broadcast(to_cpumask(tmpmask));
 
 	spin_unlock(&tick_broadcast_lock);
 }
@@ -228,13 +228,13 @@ static void tick_do_broadcast_on_off(void *why)
 	if (!tick_device_is_functional(dev))
 		goto out;
 
-	bc_stopped = cpus_empty(tick_broadcast_mask);
+	bc_stopped = cpumask_empty(tick_get_broadcast_mask());
 
 	switch (*reason) {
 	case CLOCK_EVT_NOTIFY_BROADCAST_ON:
 	case CLOCK_EVT_NOTIFY_BROADCAST_FORCE:
-		if (!cpu_isset(cpu, tick_broadcast_mask)) {
-			cpu_set(cpu, tick_broadcast_mask);
+		if (!cpumask_test_cpu(cpu, tick_get_broadcast_mask())) {
+			cpumask_set_cpu(cpu, tick_get_broadcast_mask());
 			if (tick_broadcast_device.mode ==
 			    TICKDEV_MODE_PERIODIC)
 				clockevents_shutdown(dev);
@@ -244,8 +244,8 @@ static void tick_do_broadcast_on_off(void *why)
 		break;
 	case CLOCK_EVT_NOTIFY_BROADCAST_OFF:
 		if (!tick_broadcast_force &&
-		    cpu_isset(cpu, tick_broadcast_mask)) {
-			cpu_clear(cpu, tick_broadcast_mask);
+		    cpumask_test_cpu(cpu, tick_get_broadcast_mask())) {
+			cpumask_clear_cpu(cpu, tick_get_broadcast_mask());
 			if (tick_broadcast_device.mode ==
 			    TICKDEV_MODE_PERIODIC)
 				tick_setup_periodic(dev, 0);
@@ -253,7 +253,7 @@ static void tick_do_broadcast_on_off(void *why)
 		break;
 	}
 
-	if (cpus_empty(tick_broadcast_mask)) {
+	if (cpumask_empty(tick_get_broadcast_mask())) {
 		if (!bc_stopped)
 			clockevents_shutdown(bc);
 	} else if (bc_stopped) {
@@ -272,7 +272,7 @@ out:
  */
 void tick_broadcast_on_off(unsigned long reason, int *oncpu)
 {
-	if (!cpu_isset(*oncpu, cpu_online_map))
+	if (!cpumask_test_cpu(*oncpu, cpu_online_mask))
 		printk(KERN_ERR "tick-broadcast: ignoring broadcast for "
 		       "offline CPU #%d\n", *oncpu);
 	else
@@ -303,10 +303,10 @@ void tick_shutdown_broadcast(unsigned int *cpup)
 	spin_lock_irqsave(&tick_broadcast_lock, flags);
 
 	bc = tick_broadcast_device.evtdev;
-	cpu_clear(cpu, tick_broadcast_mask);
+	cpumask_clear_cpu(cpu, tick_get_broadcast_mask());
 
 	if (tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC) {
-		if (bc && cpus_empty(tick_broadcast_mask))
+		if (bc && cpumask_empty(tick_get_broadcast_mask()))
 			clockevents_shutdown(bc);
 	}
 
@@ -342,10 +342,10 @@ int tick_resume_broadcast(void)
 
 		switch (tick_broadcast_device.mode) {
 		case TICKDEV_MODE_PERIODIC:
-			if(!cpus_empty(tick_broadcast_mask))
+			if (!cpumask_empty(tick_get_broadcast_mask()))
 				tick_broadcast_start_periodic(bc);
-			broadcast = cpu_isset(smp_processor_id(),
-					      tick_broadcast_mask);
+			broadcast = cpumask_test_cpu(smp_processor_id(),
+						     tick_get_broadcast_mask());
 			break;
 		case TICKDEV_MODE_ONESHOT:
 			broadcast = tick_resume_broadcast_oneshot(bc);
@@ -360,14 +360,15 @@ int tick_resume_broadcast(void)
 
 #ifdef CONFIG_TICK_ONESHOT
 
-static cpumask_t tick_broadcast_oneshot_mask;
+/* FIXME: use cpumask_var_t. */
+static DECLARE_BITMAP(tick_broadcast_oneshot_mask, NR_CPUS);
 
 /*
- * Debugging: see timer_list.c
+ * Exposed for debugging: see timer_list.c
  */
-cpumask_t *tick_get_broadcast_oneshot_mask(void)
+struct cpumask *tick_get_broadcast_oneshot_mask(void)
 {
-	return &tick_broadcast_oneshot_mask;
+	return to_cpumask(tick_broadcast_oneshot_mask);
 }
 
 static int tick_broadcast_set_event(ktime_t expires, int force)
@@ -389,7 +390,7 @@ int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
  */
 void tick_check_oneshot_broadcast(int cpu)
 {
-	if (cpu_isset(cpu, tick_broadcast_oneshot_mask)) {
+	if (cpumask_test_cpu(cpu, to_cpumask(tick_broadcast_oneshot_mask))) {
 		struct tick_device *td = &per_cpu(tick_cpu_device, cpu);
 
 		clockevents_set_mode(td->evtdev, CLOCK_EVT_MODE_ONESHOT);
@@ -402,7 +403,6 @@ void tick_check_oneshot_broadcast(int cpu)
 static void tick_handle_oneshot_broadcast(struct clock_event_device *dev)
 {
 	struct tick_device *td;
-	cpumask_t mask;
 	ktime_t now, next_event;
 	int cpu;
 
@@ -410,13 +410,13 @@ static void tick_handle_oneshot_broadcast(struct clock_event_device *dev)
 again:
 	dev->next_event.tv64 = KTIME_MAX;
 	next_event.tv64 = KTIME_MAX;
-	mask = CPU_MASK_NONE;
+	cpumask_clear(to_cpumask(tmpmask));
 	now = ktime_get();
 	/* Find all expired events */
-	for_each_cpu_mask_nr(cpu, tick_broadcast_oneshot_mask) {
+	for_each_cpu(cpu, tick_get_broadcast_oneshot_mask()) {
 		td = &per_cpu(tick_cpu_device, cpu);
 		if (td->evtdev->next_event.tv64 <= now.tv64)
-			cpu_set(cpu, mask);
+			cpumask_set_cpu(cpu, to_cpumask(tmpmask));
 		else if (td->evtdev->next_event.tv64 < next_event.tv64)
 			next_event.tv64 = td->evtdev->next_event.tv64;
 	}
@@ -424,7 +424,7 @@ again:
 	/*
 	 * Wakeup the cpus which have an expired event.
 	 */
-	tick_do_broadcast(mask);
+	tick_do_broadcast(to_cpumask(tmpmask));
 
 	/*
 	 * Two reasons for reprogram:
@@ -476,15 +476,16 @@ void tick_broadcast_oneshot_control(unsigned long reason)
 		goto out;
 
 	if (reason == CLOCK_EVT_NOTIFY_BROADCAST_ENTER) {
-		if (!cpu_isset(cpu, tick_broadcast_oneshot_mask)) {
-			cpu_set(cpu, tick_broadcast_oneshot_mask);
+		if (!cpumask_test_cpu(cpu, tick_get_broadcast_oneshot_mask())) {
+			cpumask_set_cpu(cpu, tick_get_broadcast_oneshot_mask());
 			clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
 			if (dev->next_event.tv64 < bc->next_event.tv64)
 				tick_broadcast_set_event(dev->next_event, 1);
 		}
 	} else {
-		if (cpu_isset(cpu, tick_broadcast_oneshot_mask)) {
-			cpu_clear(cpu, tick_broadcast_oneshot_mask);
+		if (cpumask_test_cpu(cpu, tick_get_broadcast_oneshot_mask())) {
+			cpumask_clear_cpu(cpu,
+					  tick_get_broadcast_oneshot_mask());
 			clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
 			if (dev->next_event.tv64 != KTIME_MAX)
 				tick_program_event(dev->next_event, 1);
@@ -502,15 +503,16 @@ out:
  */
 static void tick_broadcast_clear_oneshot(int cpu)
 {
-	cpu_clear(cpu, tick_broadcast_oneshot_mask);
+	cpumask_clear_cpu(cpu, tick_get_broadcast_oneshot_mask());
 }
 
-static void tick_broadcast_init_next_event(cpumask_t *mask, ktime_t expires)
+static void tick_broadcast_init_next_event(struct cpumask *mask,
+					   ktime_t expires)
 {
 	struct tick_device *td;
 	int cpu;
 
-	for_each_cpu_mask_nr(cpu, *mask) {
+	for_each_cpu(cpu, mask) {
 		td = &per_cpu(tick_cpu_device, cpu);
 		if (td->evtdev)
 			td->evtdev->next_event = expires;
@@ -526,7 +528,6 @@ void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 	if (bc->event_handler != tick_handle_oneshot_broadcast) {
 		int was_periodic = bc->mode == CLOCK_EVT_MODE_PERIODIC;
 		int cpu = smp_processor_id();
-		cpumask_t mask;
 
 		bc->event_handler = tick_handle_oneshot_broadcast;
 		clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
@@ -540,13 +541,15 @@ void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 		 * oneshot_mask bits for those and program the
 		 * broadcast device to fire.
 		 */
-		mask = tick_broadcast_mask;
-		cpu_clear(cpu, mask);
-		cpus_or(tick_broadcast_oneshot_mask,
-			tick_broadcast_oneshot_mask, mask);
-
-		if (was_periodic && !cpus_empty(mask)) {
-			tick_broadcast_init_next_event(&mask, tick_next_period);
+		cpumask_copy(to_cpumask(tmpmask), tick_get_broadcast_mask());
+		cpumask_clear_cpu(cpu, to_cpumask(tmpmask));
+		cpumask_or(tick_get_broadcast_oneshot_mask(),
+			   tick_get_broadcast_oneshot_mask(),
+			   to_cpumask(tmpmask));
+
+		if (was_periodic && !cpumask_empty(to_cpumask(tmpmask))) {
+			tick_broadcast_init_next_event(to_cpumask(tmpmask),
+						       tick_next_period);
 			tick_broadcast_set_event(tick_next_period, 1);
 		} else
 			bc->next_event.tv64 = KTIME_MAX;
@@ -585,7 +588,7 @@ void tick_shutdown_broadcast_oneshot(unsigned int *cpup)
 	 * Clear the broadcast mask flag for the dead cpu, but do not
 	 * stop the broadcast device!
 	 */
-	cpu_clear(cpu, tick_broadcast_oneshot_mask);
+	cpumask_clear_cpu(cpu, tick_get_broadcast_oneshot_mask());
 
 	spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index f8372be..63e05d4 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -254,7 +254,7 @@ static int tick_check_new_device(struct clock_event_device *newdev)
 		curdev = NULL;
 	}
 	clockevents_exchange_device(curdev, newdev);
-	tick_setup_device(td, newdev, cpu, &cpumask_of_cpu(cpu));
+	tick_setup_device(td, newdev, cpu, cpumask_of(cpu));
 	if (newdev->features & CLOCK_EVT_FEAT_ONESHOT)
 		tick_oneshot_notify();
 
@@ -299,9 +299,9 @@ static void tick_shutdown(unsigned int *cpup)
 	}
 	/* Transfer the do_timer job away from this cpu */
 	if (*cpup == tick_do_timer_cpu) {
-		int cpu = first_cpu(cpu_online_map);
+		int cpu = cpumask_first(cpu_online_mask);
 
-		tick_do_timer_cpu = (cpu != NR_CPUS) ? cpu :
+		tick_do_timer_cpu = (cpu < nr_cpu_ids) ? cpu :
 			TICK_DO_TIMER_NONE;
 	}
 	spin_unlock_irqrestore(&tick_device_lock, flags);
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 1d601a7..a9d9760 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -195,7 +195,7 @@ void *ring_buffer_event_data(struct ring_buffer_event *event)
 EXPORT_SYMBOL_GPL(ring_buffer_event_data);
 
 #define for_each_buffer_cpu(buffer, cpu)		\
-	for_each_cpu_mask(cpu, buffer->cpumask)
+	for_each_cpu(cpu, buffer->cpumask)
 
 #define TS_SHIFT	27
 #define TS_MASK		((1ULL << TS_SHIFT) - 1)
@@ -267,7 +267,7 @@ struct ring_buffer {
 	unsigned			pages;
 	unsigned			flags;
 	int				cpus;
-	cpumask_t			cpumask;
+	cpumask_var_t			cpumask;
 	atomic_t			record_disabled;
 
 	struct mutex			mutex;
@@ -458,6 +458,9 @@ struct ring_buffer *ring_buffer_alloc(unsigned long size, unsigned flags)
 	if (!buffer)
 		return NULL;
 
+	if (!alloc_cpumask_var(&buffer->cpumask, GFP_KERNEL))
+		goto fail_free_buffer;
+
 	buffer->pages = DIV_ROUND_UP(size, BUF_PAGE_SIZE);
 	buffer->flags = flags;
 
@@ -465,14 +468,14 @@ struct ring_buffer *ring_buffer_alloc(unsigned long size, unsigned flags)
 	if (buffer->pages == 1)
 		buffer->pages++;
 
-	buffer->cpumask = cpu_possible_map;
+	cpumask_copy(buffer->cpumask, cpu_possible_mask);
 	buffer->cpus = nr_cpu_ids;
 
 	bsize = sizeof(void *) * nr_cpu_ids;
 	buffer->buffers = kzalloc(ALIGN(bsize, cache_line_size()),
 				  GFP_KERNEL);
 	if (!buffer->buffers)
-		goto fail_free_buffer;
+		goto fail_free_cpumask;
 
 	for_each_buffer_cpu(buffer, cpu) {
 		buffer->buffers[cpu] =
@@ -492,6 +495,9 @@ struct ring_buffer *ring_buffer_alloc(unsigned long size, unsigned flags)
 	}
 	kfree(buffer->buffers);
 
+ fail_free_cpumask:
+	free_cpumask_var(buffer->cpumask);
+
  fail_free_buffer:
 	kfree(buffer);
 	return NULL;
@@ -510,6 +516,8 @@ ring_buffer_free(struct ring_buffer *buffer)
 	for_each_buffer_cpu(buffer, cpu)
 		rb_free_cpu_buffer(buffer->buffers[cpu]);
 
+	free_cpumask_var(buffer->cpumask);
+
 	kfree(buffer);
 }
 EXPORT_SYMBOL_GPL(ring_buffer_free);
@@ -1283,7 +1291,7 @@ ring_buffer_lock_reserve(struct ring_buffer *buffer,
 
 	cpu = raw_smp_processor_id();
 
-	if (!cpu_isset(cpu, buffer->cpumask))
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		goto out;
 
 	cpu_buffer = buffer->buffers[cpu];
@@ -1396,7 +1404,7 @@ int ring_buffer_write(struct ring_buffer *buffer,
 
 	cpu = raw_smp_processor_id();
 
-	if (!cpu_isset(cpu, buffer->cpumask))
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		goto out;
 
 	cpu_buffer = buffer->buffers[cpu];
@@ -1478,7 +1486,7 @@ void ring_buffer_record_disable_cpu(struct ring_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 
-	if (!cpu_isset(cpu, buffer->cpumask))
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return;
 
 	cpu_buffer = buffer->buffers[cpu];
@@ -1498,7 +1506,7 @@ void ring_buffer_record_enable_cpu(struct ring_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 
-	if (!cpu_isset(cpu, buffer->cpumask))
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return;
 
 	cpu_buffer = buffer->buffers[cpu];
@@ -1515,7 +1523,7 @@ unsigned long ring_buffer_entries_cpu(struct ring_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 
-	if (!cpu_isset(cpu, buffer->cpumask))
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return 0;
 
 	cpu_buffer = buffer->buffers[cpu];
@@ -1532,7 +1540,7 @@ unsigned long ring_buffer_overrun_cpu(struct ring_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 
-	if (!cpu_isset(cpu, buffer->cpumask))
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return 0;
 
 	cpu_buffer = buffer->buffers[cpu];
@@ -1850,7 +1858,7 @@ rb_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 	struct buffer_page *reader;
 	int nr_loops = 0;
 
-	if (!cpu_isset(cpu, buffer->cpumask))
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return NULL;
 
 	cpu_buffer = buffer->buffers[cpu];
@@ -2025,7 +2033,7 @@ ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts)
 	struct ring_buffer_event *event;
 	unsigned long flags;
 
-	if (!cpu_isset(cpu, buffer->cpumask))
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return NULL;
 
 	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
@@ -2062,7 +2070,7 @@ ring_buffer_read_start(struct ring_buffer *buffer, int cpu)
 	struct ring_buffer_iter *iter;
 	unsigned long flags;
 
-	if (!cpu_isset(cpu, buffer->cpumask))
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return NULL;
 
 	iter = kmalloc(sizeof(*iter), GFP_KERNEL);
@@ -2172,7 +2180,7 @@ void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu)
 	struct ring_buffer_per_cpu *cpu_buffer = buffer->buffers[cpu];
 	unsigned long flags;
 
-	if (!cpu_isset(cpu, buffer->cpumask))
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return;
 
 	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
@@ -2228,7 +2236,7 @@ int ring_buffer_empty_cpu(struct ring_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 
-	if (!cpu_isset(cpu, buffer->cpumask))
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return 1;
 
 	cpu_buffer = buffer->buffers[cpu];
@@ -2252,8 +2260,8 @@ int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
 	struct ring_buffer_per_cpu *cpu_buffer_a;
 	struct ring_buffer_per_cpu *cpu_buffer_b;
 
-	if (!cpu_isset(cpu, buffer_a->cpumask) ||
-	    !cpu_isset(cpu, buffer_b->cpumask))
+	if (!cpumask_test_cpu(cpu, buffer_a->cpumask) ||
+	    !cpumask_test_cpu(cpu, buffer_b->cpumask))
 		return -EINVAL;
 
 	/* At least make sure the two buffers are somewhat the same */
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 0e91f43..c580233 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -89,10 +89,10 @@ static inline void ftrace_enable_cpu(void)
 	preempt_enable();
 }
 
-static cpumask_t __read_mostly		tracing_buffer_mask;
+static cpumask_var_t __read_mostly	tracing_buffer_mask;
 
 #define for_each_tracing_cpu(cpu)	\
-	for_each_cpu_mask(cpu, tracing_buffer_mask)
+	for_each_cpu(cpu, tracing_buffer_mask)
 
 /*
  * ftrace_dump_on_oops - variable to dump ftrace buffer on oops
@@ -1811,10 +1811,10 @@ static void test_cpu_buff_start(struct trace_iterator *iter)
 	if (!(iter->iter_flags & TRACE_FILE_ANNOTATE))
 		return;
 
-	if (cpu_isset(iter->cpu, iter->started))
+	if (cpumask_test_cpu(iter->cpu, iter->started))
 		return;
 
-	cpu_set(iter->cpu, iter->started);
+	cpumask_set_cpu(iter->cpu, iter->started);
 	trace_seq_printf(s, "##### CPU %u buffer started ####\n", iter->cpu);
 }
 
@@ -2646,13 +2646,7 @@ static struct file_operations show_traces_fops = {
 /*
  * Only trace on a CPU if the bitmask is set:
  */
-static cpumask_t tracing_cpumask = CPU_MASK_ALL;
-
-/*
- * When tracing/tracing_cpu_mask is modified then this holds
- * the new bitmask we are about to install:
- */
-static cpumask_t tracing_cpumask_new;
+static cpumask_var_t tracing_cpumask;
 
 /*
  * The tracer itself will not take this lock, but still we want
@@ -2674,7 +2668,7 @@ tracing_cpumask_read(struct file *filp, char __user *ubuf,
 
 	mutex_lock(&tracing_cpumask_update_lock);
 
-	len = cpumask_scnprintf(mask_str, count, &tracing_cpumask);
+	len = cpumask_scnprintf(mask_str, count, tracing_cpumask);
 	if (count - len < 2) {
 		count = -EINVAL;
 		goto out_err;
@@ -2693,9 +2687,13 @@ tracing_cpumask_write(struct file *filp, const char __user *ubuf,
 		      size_t count, loff_t *ppos)
 {
 	int err, cpu;
+	cpumask_var_t tracing_cpumask_new;
+
+	if (!alloc_cpumask_var(&tracing_cpumask_new, GFP_KERNEL))
+		return -ENOMEM;
 
 	mutex_lock(&tracing_cpumask_update_lock);
-	err = cpumask_parse_user(ubuf, count, &tracing_cpumask_new);
+	err = cpumask_parse_user(ubuf, count, tracing_cpumask_new);
 	if (err)
 		goto err_unlock;
 
@@ -2706,26 +2704,28 @@ tracing_cpumask_write(struct file *filp, const char __user *ubuf,
 		 * Increase/decrease the disabled counter if we are
 		 * about to flip a bit in the cpumask:
 		 */
-		if (cpu_isset(cpu, tracing_cpumask) &&
-				!cpu_isset(cpu, tracing_cpumask_new)) {
+		if (cpumask_test_cpu(cpu, tracing_cpumask) &&
+				!cpumask_test_cpu(cpu, tracing_cpumask_new)) {
 			atomic_inc(&global_trace.data[cpu]->disabled);
 		}
-		if (!cpu_isset(cpu, tracing_cpumask) &&
-				cpu_isset(cpu, tracing_cpumask_new)) {
+		if (!cpumask_test_cpu(cpu, tracing_cpumask) &&
+				cpumask_test_cpu(cpu, tracing_cpumask_new)) {
 			atomic_dec(&global_trace.data[cpu]->disabled);
 		}
 	}
 	__raw_spin_unlock(&ftrace_max_lock);
 	local_irq_enable();
 
-	tracing_cpumask = tracing_cpumask_new;
+	cpumask_copy(tracing_cpumask, tracing_cpumask_new);
 
 	mutex_unlock(&tracing_cpumask_update_lock);
+	free_cpumask_var(tracing_cpumask_new);
 
 	return count;
 
 err_unlock:
 	mutex_unlock(&tracing_cpumask_update_lock);
+	free_cpumask_var(tracing_cpumask);
 
 	return err;
 }
@@ -3114,10 +3114,15 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
 	if (!iter)
 		return -ENOMEM;
 
+	if (!alloc_cpumask_var(&iter->started, GFP_KERNEL)) {
+		kfree(iter);
+		return -ENOMEM;
+	}
+
 	mutex_lock(&trace_types_lock);
 
 	/* trace pipe does not show start of buffer */
-	cpus_setall(iter->started);
+	cpumask_setall(iter->started);
 
 	iter->tr = &global_trace;
 	iter->trace = current_trace;
@@ -3134,6 +3139,7 @@ static int tracing_release_pipe(struct inode *inode, struct file *file)
 {
 	struct trace_iterator *iter = file->private_data;
 
+	free_cpumask_var(iter->started);
 	kfree(iter);
 	atomic_dec(&tracing_reader);
 
@@ -3752,7 +3758,6 @@ void ftrace_dump(void)
 	static DEFINE_SPINLOCK(ftrace_dump_lock);
 	/* use static because iter can be a bit big for the stack */
 	static struct trace_iterator iter;
-	static cpumask_t mask;
 	static int dump_ran;
 	unsigned long flags;
 	int cnt = 0, cpu;
@@ -3786,8 +3791,6 @@ void ftrace_dump(void)
 	 * and then release the locks again.
 	 */
 
-	cpus_clear(mask);
-
 	while (!trace_empty(&iter)) {
 
 		if (!cnt)
@@ -3823,19 +3826,28 @@ __init static int tracer_alloc_buffers(void)
 {
 	struct trace_array_cpu *data;
 	int i;
+	int ret = -ENOMEM;
 
-	/* TODO: make the number of buffers hot pluggable with CPUS */
-	tracing_buffer_mask = cpu_possible_map;
+	if (!alloc_cpumask_var(&tracing_buffer_mask, GFP_KERNEL))
+		goto out;
+
+	if (!alloc_cpumask_var(&tracing_cpumask, GFP_KERNEL))
+		goto out_free_buffer_mask;
+
+	cpumask_copy(tracing_buffer_mask, cpu_possible_mask);
+	cpumask_copy(tracing_cpumask, cpu_all_mask);
 
+	/* TODO: make the number of buffers hot pluggable with CPUS */
 	global_trace.buffer = ring_buffer_alloc(trace_buf_size,
 						   TRACE_BUFFER_FLAGS);
 	if (!global_trace.buffer) {
 		printk(KERN_ERR "tracer: failed to allocate ring buffer!\n");
 		WARN_ON(1);
-		return 0;
+		goto out_free_cpumask;
 	}
 	global_trace.entries = ring_buffer_size(global_trace.buffer);
 
+
 #ifdef CONFIG_TRACER_MAX_TRACE
 	max_tr.buffer = ring_buffer_alloc(trace_buf_size,
 					     TRACE_BUFFER_FLAGS);
@@ -3843,7 +3855,7 @@ __init static int tracer_alloc_buffers(void)
 		printk(KERN_ERR "tracer: failed to allocate max ring buffer!\n");
 		WARN_ON(1);
 		ring_buffer_free(global_trace.buffer);
-		return 0;
+		goto out_free_cpumask;
 	}
 	max_tr.entries = ring_buffer_size(max_tr.buffer);
 	WARN_ON(max_tr.entries != global_trace.entries);
@@ -3873,8 +3885,14 @@ __init static int tracer_alloc_buffers(void)
 				       &trace_panic_notifier);
 
 	register_die_notifier(&trace_die_notifier);
+	ret = 0;
 
-	return 0;
+out_free_cpumask:
+	free_cpumask_var(tracing_cpumask);
+out_free_buffer_mask:
+	free_cpumask_var(tracing_buffer_mask);
+out:
+	return ret;
 }
 early_initcall(tracer_alloc_buffers);
 fs_initcall(tracer_init_debugfs);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index cc7a4f8..4d3d381 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -368,7 +368,7 @@ struct trace_iterator {
 	loff_t			pos;
 	long			idx;
 
-	cpumask_t		started;
+	cpumask_var_t		started;
 };
 
 int tracing_is_enabled(void);
diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index 3ccebde..366c8c3 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -42,7 +42,7 @@ static int boot_trace_init(struct trace_array *tr)
 	int cpu;
 	boot_trace = tr;
 
-	for_each_cpu_mask(cpu, cpu_possible_map)
+	for_each_cpu(cpu, cpu_possible_mask)
 		tracing_reset(tr, cpu);
 
 	tracing_sched_switch_assign_trace(tr);
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 4bf39fc..930c08e 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -79,7 +79,7 @@ print_graph_cpu(struct trace_seq *s, int cpu)
 	int i;
 	int ret;
 	int log10_this = log10_cpu(cpu);
-	int log10_all = log10_cpu(cpus_weight_nr(cpu_online_map));
+	int log10_all = log10_cpu(cpumask_weight(cpu_online_mask));
 
 
 	/*
diff --git a/kernel/trace/trace_hw_branches.c b/kernel/trace/trace_hw_branches.c
index b6a3e20..649df22 100644
--- a/kernel/trace/trace_hw_branches.c
+++ b/kernel/trace/trace_hw_branches.c
@@ -46,7 +46,7 @@ static void bts_trace_start(struct trace_array *tr)
 
 	tracing_reset_online_cpus(tr);
 
-	for_each_cpu_mask(cpu, cpu_possible_map)
+	for_each_cpu(cpu, cpu_possible_mask)
 		smp_call_function_single(cpu, bts_trace_start_cpu, NULL, 1);
 }
 
@@ -62,7 +62,7 @@ static void bts_trace_stop(struct trace_array *tr)
 {
 	int cpu;
 
-	for_each_cpu_mask(cpu, cpu_possible_map)
+	for_each_cpu(cpu, cpu_possible_mask)
 		smp_call_function_single(cpu, bts_trace_stop_cpu, NULL, 1);
 }
 
@@ -172,7 +172,7 @@ static void trace_bts_prepare(struct trace_iterator *iter)
 {
 	int cpu;
 
-	for_each_cpu_mask(cpu, cpu_possible_map)
+	for_each_cpu(cpu, cpu_possible_mask)
 		smp_call_function_single(cpu, trace_bts_cpu, iter->tr, 1);
 }
 
diff --git a/kernel/trace/trace_power.c b/kernel/trace/trace_power.c
index a7172a3..7bda248 100644
--- a/kernel/trace/trace_power.c
+++ b/kernel/trace/trace_power.c
@@ -39,7 +39,7 @@ static int power_trace_init(struct trace_array *tr)
 
 	trace_power_enabled = 1;
 
-	for_each_cpu_mask(cpu, cpu_possible_map)
+	for_each_cpu(cpu, cpu_possible_mask)
 		tracing_reset(tr, cpu);
 	return 0;
 }
diff --git a/kernel/trace/trace_sysprof.c b/kernel/trace/trace_sysprof.c
index a5779bd..eaca5ad 100644
--- a/kernel/trace/trace_sysprof.c
+++ b/kernel/trace/trace_sysprof.c
@@ -196,9 +196,9 @@ static enum hrtimer_restart stack_trace_timer_fn(struct hrtimer *hrtimer)
 	return HRTIMER_RESTART;
 }
 
-static void start_stack_timer(int cpu)
+static void start_stack_timer(void *unused)
 {
-	struct hrtimer *hrtimer = &per_cpu(stack_trace_hrtimer, cpu);
+	struct hrtimer *hrtimer = &__get_cpu_var(stack_trace_hrtimer);
 
 	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	hrtimer->function = stack_trace_timer_fn;
@@ -208,14 +208,7 @@ static void start_stack_timer(int cpu)
 
 static void start_stack_timers(void)
 {
-	cpumask_t saved_mask = current->cpus_allowed;
-	int cpu;
-
-	for_each_online_cpu(cpu) {
-		set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
-		start_stack_timer(cpu);
-	}
-	set_cpus_allowed_ptr(current, &saved_mask);
+	on_each_cpu(start_stack_timer, NULL, 1);
 }
 
 static void stop_stack_timer(int cpu)
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 4952322..2f44583 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -73,7 +73,7 @@ static DEFINE_SPINLOCK(workqueue_lock);
 static LIST_HEAD(workqueues);
 
 static int singlethread_cpu __read_mostly;
-static cpumask_t cpu_singlethread_map __read_mostly;
+static const struct cpumask *cpu_singlethread_map __read_mostly;
 /*
  * _cpu_down() first removes CPU from cpu_online_map, then CPU_DEAD
  * flushes cwq->worklist. This means that flush_workqueue/wait_on_work
@@ -81,7 +81,7 @@ static cpumask_t cpu_singlethread_map __read_mostly;
  * use cpu_possible_map, the cpumask below is more a documentation
  * than optimization.
  */
-static cpumask_t cpu_populated_map __read_mostly;
+static cpumask_var_t cpu_populated_map __read_mostly;
 
 /* If it's single threaded, it isn't in the list of workqueues. */
 static inline int is_wq_single_threaded(struct workqueue_struct *wq)
@@ -89,10 +89,10 @@ static inline int is_wq_single_threaded(struct workqueue_struct *wq)
 	return wq->singlethread;
 }
 
-static const cpumask_t *wq_cpu_map(struct workqueue_struct *wq)
+static const struct cpumask *wq_cpu_map(struct workqueue_struct *wq)
 {
 	return is_wq_single_threaded(wq)
-		? &cpu_singlethread_map : &cpu_populated_map;
+		? cpu_singlethread_map : cpu_populated_map;
 }
 
 static
@@ -410,7 +410,7 @@ static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
  */
 void flush_workqueue(struct workqueue_struct *wq)
 {
-	const cpumask_t *cpu_map = wq_cpu_map(wq);
+	const struct cpumask *cpu_map = wq_cpu_map(wq);
 	int cpu;
 
 	might_sleep();
@@ -532,7 +532,7 @@ static void wait_on_work(struct work_struct *work)
 {
 	struct cpu_workqueue_struct *cwq;
 	struct workqueue_struct *wq;
-	const cpumask_t *cpu_map;
+	const struct cpumask *cpu_map;
 	int cpu;
 
 	might_sleep();
@@ -903,7 +903,7 @@ static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq)
  */
 void destroy_workqueue(struct workqueue_struct *wq)
 {
-	const cpumask_t *cpu_map = wq_cpu_map(wq);
+	const struct cpumask *cpu_map = wq_cpu_map(wq);
 	int cpu;
 
 	cpu_maps_update_begin();
@@ -933,7 +933,7 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 
 	switch (action) {
 	case CPU_UP_PREPARE:
-		cpu_set(cpu, cpu_populated_map);
+		cpumask_set_cpu(cpu, cpu_populated_map);
 	}
 undo:
 	list_for_each_entry(wq, &workqueues, list) {
@@ -964,7 +964,7 @@ undo:
 	switch (action) {
 	case CPU_UP_CANCELED:
 	case CPU_POST_DEAD:
-		cpu_clear(cpu, cpu_populated_map);
+		cpumask_clear_cpu(cpu, cpu_populated_map);
 	}
 
 	return ret;
@@ -1017,9 +1017,11 @@ EXPORT_SYMBOL_GPL(work_on_cpu);
 
 void __init init_workqueues(void)
 {
-	cpu_populated_map = cpu_online_map;
-	singlethread_cpu = first_cpu(cpu_possible_map);
-	cpu_singlethread_map = cpumask_of_cpu(singlethread_cpu);
+	alloc_cpumask_var(&cpu_populated_map, GFP_KERNEL);
+
+	cpumask_copy(cpu_populated_map, cpu_online_mask);
+	singlethread_cpu = cpumask_first(cpu_possible_mask);
+	cpu_singlethread_map = cpumask_of(singlethread_cpu);
 	hotcpu_notifier(workqueue_cpu_callback, 0);
 	keventd_wq = create_workqueue("events");
 	BUG_ON(!keventd_wq);
diff --git a/lib/Kconfig b/lib/Kconfig
index 2ba43c4..03c2c24 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -13,6 +13,10 @@ config GENERIC_FIND_FIRST_BIT
 config GENERIC_FIND_NEXT_BIT
 	bool
 
+config GENERIC_FIND_LAST_BIT
+	bool
+	default y
+
 config CRC_CCITT
 	tristate "CRC-CCITT functions"
 	help
@@ -166,4 +170,8 @@ config CPUMASK_OFFSTACK
 	  them on the stack.  This is a bit more expensive, but avoids
 	  stack overflow.
 
+config DISABLE_OBSOLETE_CPUMASK_FUNCTIONS
+       bool "Disable obsolete cpumask functions" if DEBUG_PER_CPU_MAPS
+       depends on EXPERIMENTAL && BROKEN
+
 endmenu
diff --git a/lib/Makefile b/lib/Makefile
index 80fe8a3..32b0e64 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -37,6 +37,7 @@ lib-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
 lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
 lib-$(CONFIG_GENERIC_FIND_FIRST_BIT) += find_next_bit.o
 lib-$(CONFIG_GENERIC_FIND_NEXT_BIT) += find_next_bit.o
+lib-$(CONFIG_GENERIC_FIND_LAST_BIT) += find_last_bit.o
 obj-$(CONFIG_GENERIC_HWEIGHT) += hweight.o
 obj-$(CONFIG_LOCK_KERNEL) += kernel_lock.o
 obj-$(CONFIG_PLIST) += plist.o
diff --git a/lib/cpumask.c b/lib/cpumask.c
index 8d03f22..3389e24 100644
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -76,15 +76,28 @@ int cpumask_any_but(const struct cpumask *mask, unsigned int cpu)
 
 /* These are not inline because of header tangles. */
 #ifdef CONFIG_CPUMASK_OFFSTACK
-bool alloc_cpumask_var(cpumask_var_t *mask, gfp_t flags)
+/**
+ * alloc_cpumask_var_node - allocate a struct cpumask on a given node
+ * @mask: pointer to cpumask_var_t where the cpumask is returned
+ * @flags: GFP_ flags
+ *
+ * Only defined when CONFIG_CPUMASK_OFFSTACK=y, otherwise is
+ * a nop returning a constant 1 (in <linux/cpumask.h>)
+ * Returns TRUE if memory allocation succeeded, FALSE otherwise.
+ *
+ * In addition, mask will be NULL if this fails.  Note that gcc is
+ * usually smart enough to know that mask can never be NULL if
+ * CONFIG_CPUMASK_OFFSTACK=n, so does code elimination in that case
+ * too.
+ */
+bool alloc_cpumask_var_node(cpumask_var_t *mask, gfp_t flags, int node)
 {
 	if (likely(slab_is_available()))
-		*mask = kmalloc(cpumask_size(), flags);
+		*mask = kmalloc_node(cpumask_size(), flags, node);
 	else {
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
 		printk(KERN_ERR
 			"=> alloc_cpumask_var: kmalloc not available!\n");
-		dump_stack();
 #endif
 		*mask = NULL;
 	}
@@ -94,21 +107,64 @@ bool alloc_cpumask_var(cpumask_var_t *mask, gfp_t flags)
 		dump_stack();
 	}
 #endif
+	/* FIXME: Bandaid to save us from old primitives which go to NR_CPUS. */
+	if (*mask) {
+		unsigned int tail;
+		tail = BITS_TO_LONGS(NR_CPUS - nr_cpumask_bits) * sizeof(long);
+		memset(cpumask_bits(*mask) + cpumask_size() - tail,
+		       0, tail);
+	}
+
 	return *mask != NULL;
 }
+EXPORT_SYMBOL(alloc_cpumask_var_node);
+
+/**
+ * alloc_cpumask_var - allocate a struct cpumask
+ * @mask: pointer to cpumask_var_t where the cpumask is returned
+ * @flags: GFP_ flags
+ *
+ * Only defined when CONFIG_CPUMASK_OFFSTACK=y, otherwise is
+ * a nop returning a constant 1 (in <linux/cpumask.h>).
+ *
+ * See alloc_cpumask_var_node.
+ */
+bool alloc_cpumask_var(cpumask_var_t *mask, gfp_t flags)
+{
+	return alloc_cpumask_var_node(mask, flags, numa_node_id());
+}
 EXPORT_SYMBOL(alloc_cpumask_var);
 
+/**
+ * alloc_bootmem_cpumask_var - allocate a struct cpumask from the bootmem arena.
+ * @mask: pointer to cpumask_var_t where the cpumask is returned
+ *
+ * Only defined when CONFIG_CPUMASK_OFFSTACK=y, otherwise is
+ * a nop (in <linux/cpumask.h>).
+ * Either returns an allocated (zero-filled) cpumask, or causes the
+ * system to panic.
+ */
 void __init alloc_bootmem_cpumask_var(cpumask_var_t *mask)
 {
 	*mask = alloc_bootmem(cpumask_size());
 }
 
+/**
+ * free_cpumask_var - frees memory allocated for a struct cpumask.
+ * @mask: cpumask to free
+ *
+ * This is safe on a NULL mask.
+ */
 void free_cpumask_var(cpumask_var_t mask)
 {
 	kfree(mask);
 }
 EXPORT_SYMBOL(free_cpumask_var);
 
+/**
+ * free_bootmem_cpumask_var - frees result of alloc_bootmem_cpumask_var
+ * @mask: cpumask to free
+ */
 void __init free_bootmem_cpumask_var(cpumask_var_t mask)
 {
 	free_bootmem((unsigned long)mask, cpumask_size());
diff --git a/lib/find_last_bit.c b/lib/find_last_bit.c
new file mode 100644
index 0000000..5d202e3
--- /dev/null
+++ b/lib/find_last_bit.c
@@ -0,0 +1,45 @@
+/* find_last_bit.c: fallback find next bit implementation
+ *
+ * Copyright (C) 2008 IBM Corporation
+ * Written by Rusty Russell <rusty@rustcorp.com.au>
+ * (Inspired by David Howell's find_next_bit implementation)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/bitops.h>
+#include <linux/module.h>
+#include <asm/types.h>
+#include <asm/byteorder.h>
+
+unsigned long find_last_bit(const unsigned long *addr, unsigned long size)
+{
+	unsigned long words;
+	unsigned long tmp;
+
+	/* Start at final word. */
+	words = size / BITS_PER_LONG;
+
+	/* Partial final word? */
+	if (size & (BITS_PER_LONG-1)) {
+		tmp = (addr[words] & (~0UL >> (BITS_PER_LONG
+					 - (size & (BITS_PER_LONG-1)))));
+		if (tmp)
+			goto found;
+	}
+
+	while (words) {
+		tmp = addr[--words];
+		if (tmp) {
+found:
+			return words * BITS_PER_LONG + __fls(tmp);
+		}
+	}
+
+	/* Not found */
+	return size;
+}
+EXPORT_SYMBOL(find_last_bit);
diff --git a/mm/pdflush.c b/mm/pdflush.c
index a0a14c4..15de509 100644
--- a/mm/pdflush.c
+++ b/mm/pdflush.c
@@ -172,7 +172,16 @@ static int __pdflush(struct pdflush_work *my_work)
 static int pdflush(void *dummy)
 {
 	struct pdflush_work my_work;
-	cpumask_t cpus_allowed;
+	cpumask_var_t cpus_allowed;
+
+	/*
+	 * Since the caller doesn't even check kthread_run() worked, let's not
+	 * freak out too much if this fails.
+	 */
+	if (!alloc_cpumask_var(&cpus_allowed, GFP_KERNEL)) {
+		printk(KERN_WARNING "pdflush failed to allocate cpumask\n");
+		return 0;
+	}
 
 	/*
 	 * pdflush can spend a lot of time doing encryption via dm-crypt.  We
@@ -187,8 +196,9 @@ static int pdflush(void *dummy)
 	 * This is needed as pdflush's are dynamically created and destroyed.
 	 * The boottime pdflush's are easily placed w/o these 2 lines.
 	 */
-	cpuset_cpus_allowed(current, &cpus_allowed);
-	set_cpus_allowed_ptr(current, &cpus_allowed);
+	cpuset_cpus_allowed(current, cpus_allowed);
+	set_cpus_allowed_ptr(current, cpus_allowed);
+	free_cpumask_var(cpus_allowed);
 
 	return __pdflush(&my_work);
 }
diff --git a/mm/slab.c b/mm/slab.c
index f97e564..ddc41f3 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2157,7 +2157,7 @@ kmem_cache_create (const char *name, size_t size, size_t align,
 
 	/*
 	 * We use cache_chain_mutex to ensure a consistent view of
-	 * cpu_online_map as well.  Please see cpuup_callback
+	 * cpu_online_mask as well.  Please see cpuup_callback
 	 */
 	get_online_cpus();
 	mutex_lock(&cache_chain_mutex);
diff --git a/mm/slub.c b/mm/slub.c
index 0d861c3..f0e2892 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1970,7 +1970,7 @@ static DEFINE_PER_CPU(struct kmem_cache_cpu,
 				kmem_cache_cpu)[NR_KMEM_CACHE_CPU];
 
 static DEFINE_PER_CPU(struct kmem_cache_cpu *, kmem_cache_cpu_free);
-static cpumask_t kmem_cach_cpu_free_init_once = CPU_MASK_NONE;
+static DECLARE_BITMAP(kmem_cach_cpu_free_init_once, CONFIG_NR_CPUS);
 
 static struct kmem_cache_cpu *alloc_kmem_cache_cpu(struct kmem_cache *s,
 							int cpu, gfp_t flags)
@@ -2045,13 +2045,13 @@ static void init_alloc_cpu_cpu(int cpu)
 {
 	int i;
 
-	if (cpu_isset(cpu, kmem_cach_cpu_free_init_once))
+	if (cpumask_test_cpu(cpu, to_cpumask(kmem_cach_cpu_free_init_once)))
 		return;
 
 	for (i = NR_KMEM_CACHE_CPU - 1; i >= 0; i--)
 		free_kmem_cache_cpu(&per_cpu(kmem_cache_cpu, cpu)[i], cpu);
 
-	cpu_set(cpu, kmem_cach_cpu_free_init_once);
+	cpumask_set_cpu(cpu, to_cpumask(kmem_cach_cpu_free_init_once));
 }
 
 static void __init init_alloc_cpu(void)
@@ -3451,7 +3451,7 @@ struct location {
 	long max_time;
 	long min_pid;
 	long max_pid;
-	cpumask_t cpus;
+	DECLARE_BITMAP(cpus, NR_CPUS);
 	nodemask_t nodes;
 };
 
@@ -3526,7 +3526,8 @@ static int add_location(struct loc_track *t, struct kmem_cache *s,
 				if (track->pid > l->max_pid)
 					l->max_pid = track->pid;
 
-				cpu_set(track->cpu, l->cpus);
+				cpumask_set_cpu(track->cpu,
+						to_cpumask(l->cpus));
 			}
 			node_set(page_to_nid(virt_to_page(track)), l->nodes);
 			return 1;
@@ -3556,8 +3557,8 @@ static int add_location(struct loc_track *t, struct kmem_cache *s,
 	l->max_time = age;
 	l->min_pid = track->pid;
 	l->max_pid = track->pid;
-	cpus_clear(l->cpus);
-	cpu_set(track->cpu, l->cpus);
+	cpumask_clear(to_cpumask(l->cpus));
+	cpumask_set_cpu(track->cpu, to_cpumask(l->cpus));
 	nodes_clear(l->nodes);
 	node_set(page_to_nid(virt_to_page(track)), l->nodes);
 	return 1;
@@ -3638,11 +3639,12 @@ static int list_locations(struct kmem_cache *s, char *buf,
 			len += sprintf(buf + len, " pid=%ld",
 				l->min_pid);
 
-		if (num_online_cpus() > 1 && !cpus_empty(l->cpus) &&
+		if (num_online_cpus() > 1 &&
+				!cpumask_empty(to_cpumask(l->cpus)) &&
 				len < PAGE_SIZE - 60) {
 			len += sprintf(buf + len, " cpus=");
 			len += cpulist_scnprintf(buf + len, PAGE_SIZE - len - 50,
-					&l->cpus);
+						 to_cpumask(l->cpus));
 		}
 
 		if (num_online_nodes() > 1 && !nodes_empty(l->nodes) &&
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 62e7f62..d196f46 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1902,7 +1902,7 @@ static int kswapd(void *p)
 	};
 	node_to_cpumask_ptr(cpumask, pgdat->node_id);
 
-	if (!cpus_empty(*cpumask))
+	if (!cpumask_empty(cpumask))
 		set_cpus_allowed_ptr(tsk, cpumask);
 	current->reclaim_state = &reclaim_state;
 
@@ -2141,7 +2141,7 @@ static int __devinit cpu_callback(struct notifier_block *nfb,
 			pg_data_t *pgdat = NODE_DATA(nid);
 			node_to_cpumask_ptr(mask, pgdat->node_id);
 
-			if (any_online_cpu(*mask) < nr_cpu_ids)
+			if (cpumask_any_and(cpu_online_mask, mask) < nr_cpu_ids)
 				/* One of our CPUs online: restore mask */
 				set_cpus_allowed_ptr(pgdat->kswapd, mask);
 		}
diff --git a/mm/vmstat.c b/mm/vmstat.c
index c3ccfda..9114974 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -20,7 +20,7 @@
 DEFINE_PER_CPU(struct vm_event_state, vm_event_states) = {{0}};
 EXPORT_PER_CPU_SYMBOL(vm_event_states);
 
-static void sum_vm_events(unsigned long *ret, cpumask_t *cpumask)
+static void sum_vm_events(unsigned long *ret, const struct cpumask *cpumask)
 {
 	int cpu;
 	int i;
@@ -43,7 +43,7 @@ static void sum_vm_events(unsigned long *ret, cpumask_t *cpumask)
 void all_vm_events(unsigned long *ret)
 {
 	get_online_cpus();
-	sum_vm_events(ret, &cpu_online_map);
+	sum_vm_events(ret, cpu_online_mask);
 	put_online_cpus();
 }
 EXPORT_SYMBOL_GPL(all_vm_events);
diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index c863036..e552099 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -1211,7 +1211,7 @@ static struct avc_cache_stats *sel_avc_get_stat_idx(loff_t *idx)
 {
 	int cpu;
 
-	for (cpu = *idx; cpu < NR_CPUS; ++cpu) {
+	for (cpu = *idx; cpu < nr_cpu_ids; ++cpu) {
 		if (!cpu_possible(cpu))
 			continue;
 		*idx = cpu + 1;
