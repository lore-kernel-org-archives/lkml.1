Return-Path: <linux-kernel-owner+w=401wt.eu-S932117AbZFJWK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117AbZFJWK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 18:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754211AbZFJWKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 18:10:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57842 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851AbZFJWKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 18:10:17 -0400
Date: Thu, 11 Jun 2009 00:09:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] IOMMU changes for v2.6.31
Message-ID: <20090610220959.GA10290@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest iommu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git iommu-for-linus

 - swiotlb changes: PowerPC32 highmem support finishing touches
 - AMD-IOMMU updates
 - dma-debug updates/fixes
 - fixlets

 Thanks,

	Ingo

------------------>
Becky Bruce (7):
      swiotlb: comment corrections
      swiotlb: fix compile warning
      swiotlb: map_page fix for highmem systems
      swiotlb: allow arch override of address_needs_mapping
      swiotlb: rename unmap_single to do_unmap_single
      swiotlb: use swiotlb_sync_single instead of duplicating code
      swiotlb: change swiotlb_bus_to[phys,virt] prototypes

Chris Wright (1):
      amd iommu: properly detach from protection domain on ->remove

FUJITA Tomonori (6):
      x86: calgary: remove IOMMU_DEBUG
      dma-debug: add dma_debug_resize_entries() to adjust the number of dma_debug_entries
      x86 gart: reimplement IOMMU_LEAK feature by using DMA_API_DEBUG
      dma-debug: use sg_dma_address accessor instead of using dma_address directly
      dma-debug: use sg_dma_len accessor
      dma-debug: fix debug_dma_sync_sg_for_cpu and debug_dma_sync_sg_for_device

Jiri Slaby (1):
      amd_iommu: fix lock imbalance

Joerg Roedel (43):
      dma-debug: re-add dma memory leak detection
      amd-iommu: add amd_iommu_dump parameter
      amd-iommu: add dump for iommus described in ivrs table
      amd-iommu: print ivhd information to dmesg when requested
      amd-iommu: print ivmd information to dmesg when requested
      amd-iommu: move protection domain printk to dump code
      x86/iommu: add IOMMU_STRESS Kconfig entry
      amd-iommu: disable device isolation with CONFIG_IOMMU_STRESS
      amd-iommu: make sure only ivmd entries are parsed
      amd-iommu: introduce for_each_iommu* macros
      amd-iommu: consolidate hardware initialization to one function
      amd-iommu: drop pointless iommu-loop in msi setup code
      amd-iommu: remove support for msi-x
      amd-iommu: add function to disable all iommus
      amd-iommu: add function to flush tlb for all domains
      amd-iommu: add function to flush tlb for all devices
      amd_iommu: un __init functions required for suspend/resume
      amd-iommu: implement suspend/resume
      amd-iommu: introduce aperture_range structure
      amd-iommu: move page table allocation code to seperate function
      amd-iommu: handle page table allocation failures in dma_ops code
      amd-iommu: make address allocator aware of multiple aperture ranges
      amd-iommu: change dma_dom->next_bit to dma_dom->next_address
      amd-iommu: move aperture_range allocation code to seperate function
      amd-iommu: handle exlusion ranges and unity mappings in alloc_new_range
      amd-iommu: enlarge the aperture dynamically
      amd-iommu: remove amd_iommu_size kernel parameter
      amd-iommu: disable round-robin allocator for CONFIG_IOMMU_STRESS
      amd-iommu: don't preallocate page tables with CONFIG_IOMMU_STRESS
      amd-iommu: don't free dma adresses below 512MB with CONFIG_IOMMU_STRESS
      dma-debug: add variables and checks for driver filter
      dma-debug: add debugfs file for driver filter
      dma-debug: add dma_debug_driver kernel command line
      dma-debug: add documentation for the driver filter
      dma-debug: change hash_bucket_find from first-fit to best-fit
      dma-debug: comment style fixes
      dma-debug: code style fixes
      dma-debug: use pr_* instead of printk(KERN_* ...)
      dma-debug: disable/enable irqs only once in device_dma_allocations
      dma-debug: simplify logic in driver_filter()
      amd-iommu: remove BUS_NOTIFY_BOUND_DRIVER handling
      amd-iommu: detach device explicitly before attaching it to a new domain
      amd-iommu: remove unnecessary "AMD IOMMU: " prefix

Mark Langsdorf (1):
      x86: enable GART-IOMMU only after setting up protection methods

Neil Turton (2):
      amd-iommu: fix an off-by-one error in the AMD IOMMU driver.
      amd-iommu: fix the handling of device aliases in the AMD IOMMU driver.


 Documentation/DMA-API.txt              |   12 +
 Documentation/kernel-parameters.txt    |   12 +-
 arch/x86/Kconfig.debug                 |   11 +-
 arch/x86/include/asm/amd_iommu.h       |    2 +
 arch/x86/include/asm/amd_iommu_types.h |   55 +++-
 arch/x86/kernel/amd_iommu.c            |  500 +++++++++++++++++++++++---------
 arch/x86/kernel/amd_iommu_init.c       |  273 ++++++++++++------
 arch/x86/kernel/pci-calgary_64.c       |   54 +----
 arch/x86/kernel/pci-gart_64.c          |   55 +---
 arch/x86/kernel/pci-swiotlb.c          |    2 +-
 include/linux/dma-debug.h              |    7 +
 include/linux/swiotlb.h                |    3 +-
 lib/dma-debug.c                        |  432 ++++++++++++++++++++++++---
 lib/swiotlb.c                          |  119 ++++----
 14 files changed, 1099 insertions(+), 438 deletions(-)

diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
index d9aa43d..25fb8bc 100644
--- a/Documentation/DMA-API.txt
+++ b/Documentation/DMA-API.txt
@@ -704,12 +704,24 @@ this directory the following files can currently be found:
 				The current number of free dma_debug_entries
 				in the allocator.
 
+	dma-api/driver-filter
+				You can write a name of a driver into this file
+				to limit the debug output to requests from that
+				particular driver. Write an empty string to
+				that file to disable the filter and see
+				all errors again.
+
 If you have this code compiled into your kernel it will be enabled by default.
 If you want to boot without the bookkeeping anyway you can provide
 'dma_debug=off' as a boot parameter. This will disable DMA-API debugging.
 Notice that you can not enable it again at runtime. You have to reboot to do
 so.
 
+If you want to see debug messages only for a special device driver you can
+specify the dma_debug_driver=<drivername> parameter. This will enable the
+driver filter at boot time. The debug code will only print errors for that
+driver afterwards. This filter can be disabled or changed later using debugfs.
+
 When the code disables itself at runtime this is most likely because it ran
 out of dma_debug_entries. These entries are preallocated at boot. The number
 of preallocated entries is defined per architecture. If it is too low for you
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index fd5cac0..8f9e17c 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -329,11 +329,6 @@ and is between 256 and 4096 characters. It is defined in the file
 				    flushed before they will be reused, which
 				    is a lot of faster
 
-	amd_iommu_size= [HW,X86-64]
-			Define the size of the aperture for the AMD IOMMU
-			driver. Possible values are:
-			'32M', '64M' (default), '128M', '256M', '512M', '1G'
-
 	amijoy.map=	[HW,JOY] Amiga joystick support
 			Map of devices attached to JOY0DAT and JOY1DAT
 			Format: <a>,<b>
@@ -646,6 +641,13 @@ and is between 256 and 4096 characters. It is defined in the file
 			DMA-API debugging code disables itself because the
 			architectural default is too low.
 
+	dma_debug_driver=<driver_name>
+			With this option the DMA-API debugging driver
+			filter feature can be enabled at boot time. Just
+			pass the driver to filter for as the parameter.
+			The filter can be disabled or changed to another
+			driver later using sysfs.
+
 	dscc4.setup=	[NET]
 
 	dtc3181e=	[HW,SCSI]
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index d8359e7..33fac6b 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -159,10 +159,17 @@ config IOMMU_DEBUG
 	  options. See Documentation/x86_64/boot-options.txt for more
 	  details.
 
+config IOMMU_STRESS
+	bool "Enable IOMMU stress-test mode"
+	---help---
+	  This option disables various optimizations in IOMMU related
+	  code to do real stress testing of the IOMMU code. This option
+	  will cause a performance drop and should only be enabled for
+	  testing.
+
 config IOMMU_LEAK
 	bool "IOMMU leak tracing"
-	depends on DEBUG_KERNEL
-	depends on IOMMU_DEBUG
+	depends on IOMMU_DEBUG && DMA_API_DEBUG
 	---help---
 	  Add a simple leak tracer to the IOMMU code. This is useful when you
 	  are debugging a buggy device driver that leaks IOMMU mappings.
diff --git a/arch/x86/include/asm/amd_iommu.h b/arch/x86/include/asm/amd_iommu.h
index f712344..262e028 100644
--- a/arch/x86/include/asm/amd_iommu.h
+++ b/arch/x86/include/asm/amd_iommu.h
@@ -27,6 +27,8 @@ extern int amd_iommu_init(void);
 extern int amd_iommu_init_dma_ops(void);
 extern void amd_iommu_detect(void);
 extern irqreturn_t amd_iommu_int_handler(int irq, void *data);
+extern void amd_iommu_flush_all_domains(void);
+extern void amd_iommu_flush_all_devices(void);
 #else
 static inline int amd_iommu_init(void) { return -ENODEV; }
 static inline void amd_iommu_detect(void) { }
diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 95c8cd9..0c878ca 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -194,6 +194,27 @@
 #define PD_DMA_OPS_MASK		(1UL << 0) /* domain used for dma_ops */
 #define PD_DEFAULT_MASK		(1UL << 1) /* domain is a default dma_ops
 					      domain for an IOMMU */
+extern bool amd_iommu_dump;
+#define DUMP_printk(format, arg...)					\
+	do {								\
+		if (amd_iommu_dump)						\
+			printk(KERN_INFO "AMD IOMMU: " format, ## arg);	\
+	} while(0);
+
+/*
+ * Make iterating over all IOMMUs easier
+ */
+#define for_each_iommu(iommu) \
+	list_for_each_entry((iommu), &amd_iommu_list, list)
+#define for_each_iommu_safe(iommu, next) \
+	list_for_each_entry_safe((iommu), (next), &amd_iommu_list, list)
+
+#define APERTURE_RANGE_SHIFT	27	/* 128 MB */
+#define APERTURE_RANGE_SIZE	(1ULL << APERTURE_RANGE_SHIFT)
+#define APERTURE_RANGE_PAGES	(APERTURE_RANGE_SIZE >> PAGE_SHIFT)
+#define APERTURE_MAX_RANGES	32	/* allows 4GB of DMA address space */
+#define APERTURE_RANGE_INDEX(a)	((a) >> APERTURE_RANGE_SHIFT)
+#define APERTURE_PAGE_INDEX(a)	(((a) >> 21) & 0x3fULL)
 
 /*
  * This structure contains generic data for  IOMMU protection domains
@@ -210,6 +231,26 @@ struct protection_domain {
 };
 
 /*
+ * For dynamic growth the aperture size is split into ranges of 128MB of
+ * DMA address space each. This struct represents one such range.
+ */
+struct aperture_range {
+
+	/* address allocation bitmap */
+	unsigned long *bitmap;
+
+	/*
+	 * Array of PTE pages for the aperture. In this array we save all the
+	 * leaf pages of the domain page table used for the aperture. This way
+	 * we don't need to walk the page table to find a specific PTE. We can
+	 * just calculate its address in constant time.
+	 */
+	u64 *pte_pages[64];
+
+	unsigned long offset;
+};
+
+/*
  * Data container for a dma_ops specific protection domain
  */
 struct dma_ops_domain {
@@ -222,18 +263,10 @@ struct dma_ops_domain {
 	unsigned long aperture_size;
 
 	/* address we start to search for free addresses */
-	unsigned long next_bit;
-
-	/* address allocation bitmap */
-	unsigned long *bitmap;
+	unsigned long next_address;
 
-	/*
-	 * Array of PTE pages for the aperture. In this array we save all the
-	 * leaf pages of the domain page table used for the aperture. This way
-	 * we don't need to walk the page table to find a specific PTE. We can
-	 * just calculate its address in constant time.
-	 */
-	u64 **pte_pages;
+	/* address space relevant data */
+	struct aperture_range *aperture[APERTURE_MAX_RANGES];
 
 	/* This will be set to true when TLB needs to be flushed */
 	bool need_flush;
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index a97db99..1c60554 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -55,7 +55,16 @@ struct iommu_cmd {
 static int dma_ops_unity_map(struct dma_ops_domain *dma_dom,
 			     struct unity_map_entry *e);
 static struct dma_ops_domain *find_protection_domain(u16 devid);
+static u64* alloc_pte(struct protection_domain *dom,
+		      unsigned long address, u64
+		      **pte_page, gfp_t gfp);
+static void dma_ops_reserve_addresses(struct dma_ops_domain *dom,
+				      unsigned long start_page,
+				      unsigned int pages);
 
+#ifndef BUS_NOTIFY_UNBOUND_DRIVER
+#define BUS_NOTIFY_UNBOUND_DRIVER 0x0005
+#endif
 
 #ifdef CONFIG_AMD_IOMMU_STATS
 
@@ -213,7 +222,7 @@ irqreturn_t amd_iommu_int_handler(int irq, void *data)
 {
 	struct amd_iommu *iommu;
 
-	list_for_each_entry(iommu, &amd_iommu_list, list)
+	for_each_iommu(iommu)
 		iommu_poll_events(iommu);
 
 	return IRQ_HANDLED;
@@ -440,7 +449,7 @@ static void iommu_flush_domain(u16 domid)
 	__iommu_build_inv_iommu_pages(&cmd, CMD_INV_IOMMU_ALL_PAGES_ADDRESS,
 				      domid, 1, 1);
 
-	list_for_each_entry(iommu, &amd_iommu_list, list) {
+	for_each_iommu(iommu) {
 		spin_lock_irqsave(&iommu->lock, flags);
 		__iommu_queue_command(iommu, &cmd);
 		__iommu_completion_wait(iommu);
@@ -449,6 +458,35 @@ static void iommu_flush_domain(u16 domid)
 	}
 }
 
+void amd_iommu_flush_all_domains(void)
+{
+	int i;
+
+	for (i = 1; i < MAX_DOMAIN_ID; ++i) {
+		if (!test_bit(i, amd_iommu_pd_alloc_bitmap))
+			continue;
+		iommu_flush_domain(i);
+	}
+}
+
+void amd_iommu_flush_all_devices(void)
+{
+	struct amd_iommu *iommu;
+	int i;
+
+	for (i = 0; i <= amd_iommu_last_bdf; ++i) {
+		if (amd_iommu_pd_table[i] == NULL)
+			continue;
+
+		iommu = amd_iommu_rlookup_table[i];
+		if (!iommu)
+			continue;
+
+		iommu_queue_inv_dev_entry(iommu, i);
+		iommu_completion_wait(iommu);
+	}
+}
+
 /****************************************************************************
  *
  * The functions below are used the create the page table mappings for
@@ -468,7 +506,7 @@ static int iommu_map_page(struct protection_domain *dom,
 			  unsigned long phys_addr,
 			  int prot)
 {
-	u64 __pte, *pte, *page;
+	u64 __pte, *pte;
 
 	bus_addr  = PAGE_ALIGN(bus_addr);
 	phys_addr = PAGE_ALIGN(phys_addr);
@@ -477,27 +515,7 @@ static int iommu_map_page(struct protection_domain *dom,
 	if (bus_addr > IOMMU_MAP_SIZE_L3 || !(prot & IOMMU_PROT_MASK))
 		return -EINVAL;
 
-	pte = &dom->pt_root[IOMMU_PTE_L2_INDEX(bus_addr)];
-
-	if (!IOMMU_PTE_PRESENT(*pte)) {
-		page = (u64 *)get_zeroed_page(GFP_KERNEL);
-		if (!page)
-			return -ENOMEM;
-		*pte = IOMMU_L2_PDE(virt_to_phys(page));
-	}
-
-	pte = IOMMU_PTE_PAGE(*pte);
-	pte = &pte[IOMMU_PTE_L1_INDEX(bus_addr)];
-
-	if (!IOMMU_PTE_PRESENT(*pte)) {
-		page = (u64 *)get_zeroed_page(GFP_KERNEL);
-		if (!page)
-			return -ENOMEM;
-		*pte = IOMMU_L1_PDE(virt_to_phys(page));
-	}
-
-	pte = IOMMU_PTE_PAGE(*pte);
-	pte = &pte[IOMMU_PTE_L0_INDEX(bus_addr)];
+	pte = alloc_pte(dom, bus_addr, NULL, GFP_KERNEL);
 
 	if (IOMMU_PTE_PRESENT(*pte))
 		return -EBUSY;
@@ -595,7 +613,8 @@ static int dma_ops_unity_map(struct dma_ops_domain *dma_dom,
 		 * as allocated in the aperture
 		 */
 		if (addr < dma_dom->aperture_size)
-			__set_bit(addr >> PAGE_SHIFT, dma_dom->bitmap);
+			__set_bit(addr >> PAGE_SHIFT,
+				  dma_dom->aperture[0]->bitmap);
 	}
 
 	return 0;
@@ -632,42 +651,191 @@ static int init_unity_mappings_for_device(struct dma_ops_domain *dma_dom,
  ****************************************************************************/
 
 /*
- * The address allocator core function.
+ * The address allocator core functions.
  *
  * called with domain->lock held
  */
+
+/*
+ * This function checks if there is a PTE for a given dma address. If
+ * there is one, it returns the pointer to it.
+ */
+static u64* fetch_pte(struct protection_domain *domain,
+		      unsigned long address)
+{
+	u64 *pte;
+
+	pte = &domain->pt_root[IOMMU_PTE_L2_INDEX(address)];
+
+	if (!IOMMU_PTE_PRESENT(*pte))
+		return NULL;
+
+	pte = IOMMU_PTE_PAGE(*pte);
+	pte = &pte[IOMMU_PTE_L1_INDEX(address)];
+
+	if (!IOMMU_PTE_PRESENT(*pte))
+		return NULL;
+
+	pte = IOMMU_PTE_PAGE(*pte);
+	pte = &pte[IOMMU_PTE_L0_INDEX(address)];
+
+	return pte;
+}
+
+/*
+ * This function is used to add a new aperture range to an existing
+ * aperture in case of dma_ops domain allocation or address allocation
+ * failure.
+ */
+static int alloc_new_range(struct amd_iommu *iommu,
+			   struct dma_ops_domain *dma_dom,
+			   bool populate, gfp_t gfp)
+{
+	int index = dma_dom->aperture_size >> APERTURE_RANGE_SHIFT;
+	int i;
+
+#ifdef CONFIG_IOMMU_STRESS
+	populate = false;
+#endif
+
+	if (index >= APERTURE_MAX_RANGES)
+		return -ENOMEM;
+
+	dma_dom->aperture[index] = kzalloc(sizeof(struct aperture_range), gfp);
+	if (!dma_dom->aperture[index])
+		return -ENOMEM;
+
+	dma_dom->aperture[index]->bitmap = (void *)get_zeroed_page(gfp);
+	if (!dma_dom->aperture[index]->bitmap)
+		goto out_free;
+
+	dma_dom->aperture[index]->offset = dma_dom->aperture_size;
+
+	if (populate) {
+		unsigned long address = dma_dom->aperture_size;
+		int i, num_ptes = APERTURE_RANGE_PAGES / 512;
+		u64 *pte, *pte_page;
+
+		for (i = 0; i < num_ptes; ++i) {
+			pte = alloc_pte(&dma_dom->domain, address,
+					&pte_page, gfp);
+			if (!pte)
+				goto out_free;
+
+			dma_dom->aperture[index]->pte_pages[i] = pte_page;
+
+			address += APERTURE_RANGE_SIZE / 64;
+		}
+	}
+
+	dma_dom->aperture_size += APERTURE_RANGE_SIZE;
+
+	/* Intialize the exclusion range if necessary */
+	if (iommu->exclusion_start &&
+	    iommu->exclusion_start >= dma_dom->aperture[index]->offset &&
+	    iommu->exclusion_start < dma_dom->aperture_size) {
+		unsigned long startpage = iommu->exclusion_start >> PAGE_SHIFT;
+		int pages = iommu_num_pages(iommu->exclusion_start,
+					    iommu->exclusion_length,
+					    PAGE_SIZE);
+		dma_ops_reserve_addresses(dma_dom, startpage, pages);
+	}
+
+	/*
+	 * Check for areas already mapped as present in the new aperture
+	 * range and mark those pages as reserved in the allocator. Such
+	 * mappings may already exist as a result of requested unity
+	 * mappings for devices.
+	 */
+	for (i = dma_dom->aperture[index]->offset;
+	     i < dma_dom->aperture_size;
+	     i += PAGE_SIZE) {
+		u64 *pte = fetch_pte(&dma_dom->domain, i);
+		if (!pte || !IOMMU_PTE_PRESENT(*pte))
+			continue;
+
+		dma_ops_reserve_addresses(dma_dom, i << PAGE_SHIFT, 1);
+	}
+
+	return 0;
+
+out_free:
+	free_page((unsigned long)dma_dom->aperture[index]->bitmap);
+
+	kfree(dma_dom->aperture[index]);
+	dma_dom->aperture[index] = NULL;
+
+	return -ENOMEM;
+}
+
+static unsigned long dma_ops_area_alloc(struct device *dev,
+					struct dma_ops_domain *dom,
+					unsigned int pages,
+					unsigned long align_mask,
+					u64 dma_mask,
+					unsigned long start)
+{
+	unsigned long next_bit = dom->next_address % APERTURE_RANGE_SIZE;
+	int max_index = dom->aperture_size >> APERTURE_RANGE_SHIFT;
+	int i = start >> APERTURE_RANGE_SHIFT;
+	unsigned long boundary_size;
+	unsigned long address = -1;
+	unsigned long limit;
+
+	next_bit >>= PAGE_SHIFT;
+
+	boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1,
+			PAGE_SIZE) >> PAGE_SHIFT;
+
+	for (;i < max_index; ++i) {
+		unsigned long offset = dom->aperture[i]->offset >> PAGE_SHIFT;
+
+		if (dom->aperture[i]->offset >= dma_mask)
+			break;
+
+		limit = iommu_device_max_index(APERTURE_RANGE_PAGES, offset,
+					       dma_mask >> PAGE_SHIFT);
+
+		address = iommu_area_alloc(dom->aperture[i]->bitmap,
+					   limit, next_bit, pages, 0,
+					    boundary_size, align_mask);
+		if (address != -1) {
+			address = dom->aperture[i]->offset +
+				  (address << PAGE_SHIFT);
+			dom->next_address = address + (pages << PAGE_SHIFT);
+			break;
+		}
+
+		next_bit = 0;
+	}
+
+	return address;
+}
+
 static unsigned long dma_ops_alloc_addresses(struct device *dev,
 					     struct dma_ops_domain *dom,
 					     unsigned int pages,
 					     unsigned long align_mask,
 					     u64 dma_mask)
 {
-	unsigned long limit;
 	unsigned long address;
-	unsigned long boundary_size;
 
-	boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1,
-			PAGE_SIZE) >> PAGE_SHIFT;
-	limit = iommu_device_max_index(dom->aperture_size >> PAGE_SHIFT, 0,
-				       dma_mask >> PAGE_SHIFT);
+#ifdef CONFIG_IOMMU_STRESS
+	dom->next_address = 0;
+	dom->need_flush = true;
+#endif
 
-	if (dom->next_bit >= limit) {
-		dom->next_bit = 0;
-		dom->need_flush = true;
-	}
+	address = dma_ops_area_alloc(dev, dom, pages, align_mask,
+				     dma_mask, dom->next_address);
 
-	address = iommu_area_alloc(dom->bitmap, limit, dom->next_bit, pages,
-				   0 , boundary_size, align_mask);
 	if (address == -1) {
-		address = iommu_area_alloc(dom->bitmap, limit, 0, pages,
-				0, boundary_size, align_mask);
+		dom->next_address = 0;
+		address = dma_ops_area_alloc(dev, dom, pages, align_mask,
+					     dma_mask, 0);
 		dom->need_flush = true;
 	}
 
-	if (likely(address != -1)) {
-		dom->next_bit = address + pages;
-		address <<= PAGE_SHIFT;
-	} else
+	if (unlikely(address == -1))
 		address = bad_dma_address;
 
 	WARN_ON((address + (PAGE_SIZE*pages)) > dom->aperture_size);
@@ -684,11 +852,23 @@ static void dma_ops_free_addresses(struct dma_ops_domain *dom,
 				   unsigned long address,
 				   unsigned int pages)
 {
-	address >>= PAGE_SHIFT;
-	iommu_area_free(dom->bitmap, address, pages);
+	unsigned i = address >> APERTURE_RANGE_SHIFT;
+	struct aperture_range *range = dom->aperture[i];
 
-	if (address >= dom->next_bit)
+	BUG_ON(i >= APERTURE_MAX_RANGES || range == NULL);
+
+#ifdef CONFIG_IOMMU_STRESS
+	if (i < 4)
+		return;
+#endif
+
+	if (address >= dom->next_address)
 		dom->need_flush = true;
+
+	address = (address % APERTURE_RANGE_SIZE) >> PAGE_SHIFT;
+
+	iommu_area_free(range->bitmap, address, pages);
+
 }
 
 /****************************************************************************
@@ -736,12 +916,16 @@ static void dma_ops_reserve_addresses(struct dma_ops_domain *dom,
 				      unsigned long start_page,
 				      unsigned int pages)
 {
-	unsigned int last_page = dom->aperture_size >> PAGE_SHIFT;
+	unsigned int i, last_page = dom->aperture_size >> PAGE_SHIFT;
 
 	if (start_page + pages > last_page)
 		pages = last_page - start_page;
 
-	iommu_area_reserve(dom->bitmap, start_page, pages);
+	for (i = start_page; i < start_page + pages; ++i) {
+		int index = i / APERTURE_RANGE_PAGES;
+		int page  = i % APERTURE_RANGE_PAGES;
+		__set_bit(page, dom->aperture[index]->bitmap);
+	}
 }
 
 static void free_pagetable(struct protection_domain *domain)
@@ -780,14 +964,19 @@ static void free_pagetable(struct protection_domain *domain)
  */
 static void dma_ops_domain_free(struct dma_ops_domain *dom)
 {
+	int i;
+
 	if (!dom)
 		return;
 
 	free_pagetable(&dom->domain);
 
-	kfree(dom->pte_pages);
-
-	kfree(dom->bitmap);
+	for (i = 0; i < APERTURE_MAX_RANGES; ++i) {
+		if (!dom->aperture[i])
+			continue;
+		free_page((unsigned long)dom->aperture[i]->bitmap);
+		kfree(dom->aperture[i]);
+	}
 
 	kfree(dom);
 }
@@ -797,19 +986,9 @@ static void dma_ops_domain_free(struct dma_ops_domain *dom)
  * It also intializes the page table and the address allocator data
  * structures required for the dma_ops interface
  */
-static struct dma_ops_domain *dma_ops_domain_alloc(struct amd_iommu *iommu,
-						   unsigned order)
+static struct dma_ops_domain *dma_ops_domain_alloc(struct amd_iommu *iommu)
 {
 	struct dma_ops_domain *dma_dom;
-	unsigned i, num_pte_pages;
-	u64 *l2_pde;
-	u64 address;
-
-	/*
-	 * Currently the DMA aperture must be between 32 MB and 1GB in size
-	 */
-	if ((order < 25) || (order > 30))
-		return NULL;
 
 	dma_dom = kzalloc(sizeof(struct dma_ops_domain), GFP_KERNEL);
 	if (!dma_dom)
@@ -826,55 +1005,20 @@ static struct dma_ops_domain *dma_ops_domain_alloc(struct amd_iommu *iommu,
 	dma_dom->domain.priv = dma_dom;
 	if (!dma_dom->domain.pt_root)
 		goto free_dma_dom;
-	dma_dom->aperture_size = (1ULL << order);
-	dma_dom->bitmap = kzalloc(dma_dom->aperture_size / (PAGE_SIZE * 8),
-				  GFP_KERNEL);
-	if (!dma_dom->bitmap)
-		goto free_dma_dom;
-	/*
-	 * mark the first page as allocated so we never return 0 as
-	 * a valid dma-address. So we can use 0 as error value
-	 */
-	dma_dom->bitmap[0] = 1;
-	dma_dom->next_bit = 0;
 
 	dma_dom->need_flush = false;
 	dma_dom->target_dev = 0xffff;
 
-	/* Intialize the exclusion range if necessary */
-	if (iommu->exclusion_start &&
-	    iommu->exclusion_start < dma_dom->aperture_size) {
-		unsigned long startpage = iommu->exclusion_start >> PAGE_SHIFT;
-		int pages = iommu_num_pages(iommu->exclusion_start,
-					    iommu->exclusion_length,
-					    PAGE_SIZE);
-		dma_ops_reserve_addresses(dma_dom, startpage, pages);
-	}
+	if (alloc_new_range(iommu, dma_dom, true, GFP_KERNEL))
+		goto free_dma_dom;
 
 	/*
-	 * At the last step, build the page tables so we don't need to
-	 * allocate page table pages in the dma_ops mapping/unmapping
-	 * path.
+	 * mark the first page as allocated so we never return 0 as
+	 * a valid dma-address. So we can use 0 as error value
 	 */
-	num_pte_pages = dma_dom->aperture_size / (PAGE_SIZE * 512);
-	dma_dom->pte_pages = kzalloc(num_pte_pages * sizeof(void *),
-			GFP_KERNEL);
-	if (!dma_dom->pte_pages)
-		goto free_dma_dom;
-
-	l2_pde = (u64 *)get_zeroed_page(GFP_KERNEL);
-	if (l2_pde == NULL)
-		goto free_dma_dom;
+	dma_dom->aperture[0]->bitmap[0] = 1;
+	dma_dom->next_address = 0;
 
-	dma_dom->domain.pt_root[0] = IOMMU_L2_PDE(virt_to_phys(l2_pde));
-
-	for (i = 0; i < num_pte_pages; ++i) {
-		dma_dom->pte_pages[i] = (u64 *)get_zeroed_page(GFP_KERNEL);
-		if (!dma_dom->pte_pages[i])
-			goto free_dma_dom;
-		address = virt_to_phys(dma_dom->pte_pages[i]);
-		l2_pde[i] = IOMMU_L1_PDE(address);
-	}
 
 	return dma_dom;
 
@@ -983,7 +1127,6 @@ static int device_change_notifier(struct notifier_block *nb,
 	struct protection_domain *domain;
 	struct dma_ops_domain *dma_domain;
 	struct amd_iommu *iommu;
-	int order = amd_iommu_aperture_order;
 	unsigned long flags;
 
 	if (devid > amd_iommu_last_bdf)
@@ -1002,17 +1145,7 @@ static int device_change_notifier(struct notifier_block *nb,
 			  "to a non-dma-ops domain\n", dev_name(dev));
 
 	switch (action) {
-	case BUS_NOTIFY_BOUND_DRIVER:
-		if (domain)
-			goto out;
-		dma_domain = find_protection_domain(devid);
-		if (!dma_domain)
-			dma_domain = iommu->default_dom;
-		attach_device(iommu, &dma_domain->domain, devid);
-		printk(KERN_INFO "AMD IOMMU: Using protection domain %d for "
-		       "device %s\n", dma_domain->domain.id, dev_name(dev));
-		break;
-	case BUS_NOTIFY_UNBIND_DRIVER:
+	case BUS_NOTIFY_UNBOUND_DRIVER:
 		if (!domain)
 			goto out;
 		detach_device(domain, devid);
@@ -1022,7 +1155,7 @@ static int device_change_notifier(struct notifier_block *nb,
 		dma_domain = find_protection_domain(devid);
 		if (dma_domain)
 			goto out;
-		dma_domain = dma_ops_domain_alloc(iommu, order);
+		dma_domain = dma_ops_domain_alloc(iommu);
 		if (!dma_domain)
 			goto out;
 		dma_domain->target_dev = devid;
@@ -1133,8 +1266,8 @@ static int get_device_resources(struct device *dev,
 			dma_dom = (*iommu)->default_dom;
 		*domain = &dma_dom->domain;
 		attach_device(*iommu, *domain, *bdf);
-		printk(KERN_INFO "AMD IOMMU: Using protection domain %d for "
-				"device %s\n", (*domain)->id, dev_name(dev));
+		DUMP_printk("Using protection domain %d for device %s\n",
+			    (*domain)->id, dev_name(dev));
 	}
 
 	if (domain_for_device(_bdf) == NULL)
@@ -1144,6 +1277,66 @@ static int get_device_resources(struct device *dev,
 }
 
 /*
+ * If the pte_page is not yet allocated this function is called
+ */
+static u64* alloc_pte(struct protection_domain *dom,
+		      unsigned long address, u64 **pte_page, gfp_t gfp)
+{
+	u64 *pte, *page;
+
+	pte = &dom->pt_root[IOMMU_PTE_L2_INDEX(address)];
+
+	if (!IOMMU_PTE_PRESENT(*pte)) {
+		page = (u64 *)get_zeroed_page(gfp);
+		if (!page)
+			return NULL;
+		*pte = IOMMU_L2_PDE(virt_to_phys(page));
+	}
+
+	pte = IOMMU_PTE_PAGE(*pte);
+	pte = &pte[IOMMU_PTE_L1_INDEX(address)];
+
+	if (!IOMMU_PTE_PRESENT(*pte)) {
+		page = (u64 *)get_zeroed_page(gfp);
+		if (!page)
+			return NULL;
+		*pte = IOMMU_L1_PDE(virt_to_phys(page));
+	}
+
+	pte = IOMMU_PTE_PAGE(*pte);
+
+	if (pte_page)
+		*pte_page = pte;
+
+	pte = &pte[IOMMU_PTE_L0_INDEX(address)];
+
+	return pte;
+}
+
+/*
+ * This function fetches the PTE for a given address in the aperture
+ */
+static u64* dma_ops_get_pte(struct dma_ops_domain *dom,
+			    unsigned long address)
+{
+	struct aperture_range *aperture;
+	u64 *pte, *pte_page;
+
+	aperture = dom->aperture[APERTURE_RANGE_INDEX(address)];
+	if (!aperture)
+		return NULL;
+
+	pte = aperture->pte_pages[APERTURE_PAGE_INDEX(address)];
+	if (!pte) {
+		pte = alloc_pte(&dom->domain, address, &pte_page, GFP_ATOMIC);
+		aperture->pte_pages[APERTURE_PAGE_INDEX(address)] = pte_page;
+	} else
+		pte += IOMMU_PTE_L0_INDEX(address);
+
+	return pte;
+}
+
+/*
  * This is the generic map function. It maps one 4kb page at paddr to
  * the given address in the DMA address space for the domain.
  */
@@ -1159,8 +1352,9 @@ static dma_addr_t dma_ops_domain_map(struct amd_iommu *iommu,
 
 	paddr &= PAGE_MASK;
 
-	pte  = dom->pte_pages[IOMMU_PTE_L1_INDEX(address)];
-	pte += IOMMU_PTE_L0_INDEX(address);
+	pte  = dma_ops_get_pte(dom, address);
+	if (!pte)
+		return bad_dma_address;
 
 	__pte = paddr | IOMMU_PTE_P | IOMMU_PTE_FC;
 
@@ -1185,14 +1379,20 @@ static void dma_ops_domain_unmap(struct amd_iommu *iommu,
 				 struct dma_ops_domain *dom,
 				 unsigned long address)
 {
+	struct aperture_range *aperture;
 	u64 *pte;
 
 	if (address >= dom->aperture_size)
 		return;
 
-	WARN_ON(address & ~PAGE_MASK || address >= dom->aperture_size);
+	aperture = dom->aperture[APERTURE_RANGE_INDEX(address)];
+	if (!aperture)
+		return;
+
+	pte  = aperture->pte_pages[APERTURE_PAGE_INDEX(address)];
+	if (!pte)
+		return;
 
-	pte  = dom->pte_pages[IOMMU_PTE_L1_INDEX(address)];
 	pte += IOMMU_PTE_L0_INDEX(address);
 
 	WARN_ON(!*pte);
@@ -1216,7 +1416,7 @@ static dma_addr_t __map_single(struct device *dev,
 			       u64 dma_mask)
 {
 	dma_addr_t offset = paddr & ~PAGE_MASK;
-	dma_addr_t address, start;
+	dma_addr_t address, start, ret;
 	unsigned int pages;
 	unsigned long align_mask = 0;
 	int i;
@@ -1232,14 +1432,33 @@ static dma_addr_t __map_single(struct device *dev,
 	if (align)
 		align_mask = (1UL << get_order(size)) - 1;
 
+retry:
 	address = dma_ops_alloc_addresses(dev, dma_dom, pages, align_mask,
 					  dma_mask);
-	if (unlikely(address == bad_dma_address))
-		goto out;
+	if (unlikely(address == bad_dma_address)) {
+		/*
+		 * setting next_address here will let the address
+		 * allocator only scan the new allocated range in the
+		 * first run. This is a small optimization.
+		 */
+		dma_dom->next_address = dma_dom->aperture_size;
+
+		if (alloc_new_range(iommu, dma_dom, false, GFP_ATOMIC))
+			goto out;
+
+		/*
+		 * aperture was sucessfully enlarged by 128 MB, try
+		 * allocation again
+		 */
+		goto retry;
+	}
 
 	start = address;
 	for (i = 0; i < pages; ++i) {
-		dma_ops_domain_map(iommu, dma_dom, start, paddr, dir);
+		ret = dma_ops_domain_map(iommu, dma_dom, start, paddr, dir);
+		if (ret == bad_dma_address)
+			goto out_unmap;
+
 		paddr += PAGE_SIZE;
 		start += PAGE_SIZE;
 	}
@@ -1255,6 +1474,17 @@ static dma_addr_t __map_single(struct device *dev,
 
 out:
 	return address;
+
+out_unmap:
+
+	for (--i; i >= 0; --i) {
+		start -= PAGE_SIZE;
+		dma_ops_domain_unmap(iommu, dma_dom, start);
+	}
+
+	dma_ops_free_addresses(dma_dom, address, pages);
+
+	return bad_dma_address;
 }
 
 /*
@@ -1537,8 +1767,10 @@ static void *alloc_coherent(struct device *dev, size_t size,
 	*dma_addr = __map_single(dev, iommu, domain->priv, paddr,
 				 size, DMA_BIDIRECTIONAL, true, dma_mask);
 
-	if (*dma_addr == bad_dma_address)
+	if (*dma_addr == bad_dma_address) {
+		spin_unlock_irqrestore(&domain->lock, flags);
 		goto out_free;
+	}
 
 	iommu_completion_wait(iommu);
 
@@ -1625,7 +1857,6 @@ static void prealloc_protection_domains(void)
 	struct pci_dev *dev = NULL;
 	struct dma_ops_domain *dma_dom;
 	struct amd_iommu *iommu;
-	int order = amd_iommu_aperture_order;
 	u16 devid;
 
 	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
@@ -1638,7 +1869,7 @@ static void prealloc_protection_domains(void)
 		iommu = amd_iommu_rlookup_table[devid];
 		if (!iommu)
 			continue;
-		dma_dom = dma_ops_domain_alloc(iommu, order);
+		dma_dom = dma_ops_domain_alloc(iommu);
 		if (!dma_dom)
 			continue;
 		init_unity_mappings_for_device(dma_dom, devid);
@@ -1664,7 +1895,6 @@ static struct dma_map_ops amd_iommu_dma_ops = {
 int __init amd_iommu_init_dma_ops(void)
 {
 	struct amd_iommu *iommu;
-	int order = amd_iommu_aperture_order;
 	int ret;
 
 	/*
@@ -1672,8 +1902,8 @@ int __init amd_iommu_init_dma_ops(void)
 	 * found in the system. Devices not assigned to any other
 	 * protection domain will be assigned to the default one.
 	 */
-	list_for_each_entry(iommu, &amd_iommu_list, list) {
-		iommu->default_dom = dma_ops_domain_alloc(iommu, order);
+	for_each_iommu(iommu) {
+		iommu->default_dom = dma_ops_domain_alloc(iommu);
 		if (iommu->default_dom == NULL)
 			return -ENOMEM;
 		iommu->default_dom->domain.flags |= PD_DEFAULT_MASK;
@@ -1710,7 +1940,7 @@ int __init amd_iommu_init_dma_ops(void)
 
 free_domains:
 
-	list_for_each_entry(iommu, &amd_iommu_list, list) {
+	for_each_iommu(iommu) {
 		if (iommu->default_dom)
 			dma_ops_domain_free(iommu->default_dom);
 	}
@@ -1842,7 +2072,7 @@ static int amd_iommu_attach_device(struct iommu_domain *dom,
 
 	old_domain = domain_for_device(devid);
 	if (old_domain)
-		return -EBUSY;
+		detach_device(old_domain, devid);
 
 	attach_device(iommu, domain, devid);
 
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 8c0be09..238989e 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -115,15 +115,21 @@ struct ivmd_header {
 	u64 range_length;
 } __attribute__((packed));
 
+bool amd_iommu_dump;
+
 static int __initdata amd_iommu_detected;
 
 u16 amd_iommu_last_bdf;			/* largest PCI device id we have
 					   to handle */
 LIST_HEAD(amd_iommu_unity_map);		/* a list of required unity mappings
 					   we find in ACPI */
-unsigned amd_iommu_aperture_order = 26; /* size of aperture in power of 2 */
+#ifdef CONFIG_IOMMU_STRESS
+bool amd_iommu_isolate = false;
+#else
 bool amd_iommu_isolate = true;		/* if true, device isolation is
 					   enabled */
+#endif
+
 bool amd_iommu_unmap_flush;		/* if true, flush on every unmap */
 
 LIST_HEAD(amd_iommu_list);		/* list of all AMD IOMMUs in the
@@ -175,7 +181,7 @@ static inline void update_last_devid(u16 devid)
 static inline unsigned long tbl_size(int entry_size)
 {
 	unsigned shift = PAGE_SHIFT +
-			 get_order(amd_iommu_last_bdf * entry_size);
+			 get_order(((int)amd_iommu_last_bdf + 1) * entry_size);
 
 	return 1UL << shift;
 }
@@ -193,7 +199,7 @@ static inline unsigned long tbl_size(int entry_size)
  * This function set the exclusion range in the IOMMU. DMA accesses to the
  * exclusion range are passed through untranslated
  */
-static void __init iommu_set_exclusion_range(struct amd_iommu *iommu)
+static void iommu_set_exclusion_range(struct amd_iommu *iommu)
 {
 	u64 start = iommu->exclusion_start & PAGE_MASK;
 	u64 limit = (start + iommu->exclusion_length) & PAGE_MASK;
@@ -225,7 +231,7 @@ static void __init iommu_set_device_table(struct amd_iommu *iommu)
 }
 
 /* Generic functions to enable/disable certain features of the IOMMU. */
-static void __init iommu_feature_enable(struct amd_iommu *iommu, u8 bit)
+static void iommu_feature_enable(struct amd_iommu *iommu, u8 bit)
 {
 	u32 ctrl;
 
@@ -244,7 +250,7 @@ static void __init iommu_feature_disable(struct amd_iommu *iommu, u8 bit)
 }
 
 /* Function to enable the hardware */
-static void __init iommu_enable(struct amd_iommu *iommu)
+static void iommu_enable(struct amd_iommu *iommu)
 {
 	printk(KERN_INFO "AMD IOMMU: Enabling IOMMU at %s cap 0x%hx\n",
 	       dev_name(&iommu->dev->dev), iommu->cap_ptr);
@@ -252,11 +258,9 @@ static void __init iommu_enable(struct amd_iommu *iommu)
 	iommu_feature_enable(iommu, CONTROL_IOMMU_EN);
 }
 
-/* Function to enable IOMMU event logging and event interrupts */
-static void __init iommu_enable_event_logging(struct amd_iommu *iommu)
+static void iommu_disable(struct amd_iommu *iommu)
 {
-	iommu_feature_enable(iommu, CONTROL_EVT_LOG_EN);
-	iommu_feature_enable(iommu, CONTROL_EVT_INT_EN);
+	iommu_feature_disable(iommu, CONTROL_IOMMU_EN);
 }
 
 /*
@@ -413,25 +417,36 @@ static u8 * __init alloc_command_buffer(struct amd_iommu *iommu)
 {
 	u8 *cmd_buf = (u8 *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
 			get_order(CMD_BUFFER_SIZE));
-	u64 entry;
 
 	if (cmd_buf == NULL)
 		return NULL;
 
 	iommu->cmd_buf_size = CMD_BUFFER_SIZE;
 
-	entry = (u64)virt_to_phys(cmd_buf);
+	return cmd_buf;
+}
+
+/*
+ * This function writes the command buffer address to the hardware and
+ * enables it.
+ */
+static void iommu_enable_command_buffer(struct amd_iommu *iommu)
+{
+	u64 entry;
+
+	BUG_ON(iommu->cmd_buf == NULL);
+
+	entry = (u64)virt_to_phys(iommu->cmd_buf);
 	entry |= MMIO_CMD_SIZE_512;
+
 	memcpy_toio(iommu->mmio_base + MMIO_CMD_BUF_OFFSET,
-			&entry, sizeof(entry));
+		    &entry, sizeof(entry));
 
 	/* set head and tail to zero manually */
 	writel(0x00, iommu->mmio_base + MMIO_CMD_HEAD_OFFSET);
 	writel(0x00, iommu->mmio_base + MMIO_CMD_TAIL_OFFSET);
 
 	iommu_feature_enable(iommu, CONTROL_CMDBUF_EN);
-
-	return cmd_buf;
 }
 
 static void __init free_command_buffer(struct amd_iommu *iommu)
@@ -443,20 +458,27 @@ static void __init free_command_buffer(struct amd_iommu *iommu)
 /* allocates the memory where the IOMMU will log its events to */
 static u8 * __init alloc_event_buffer(struct amd_iommu *iommu)
 {
-	u64 entry;
 	iommu->evt_buf = (u8 *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
 						get_order(EVT_BUFFER_SIZE));
 
 	if (iommu->evt_buf == NULL)
 		return NULL;
 
+	return iommu->evt_buf;
+}
+
+static void iommu_enable_event_buffer(struct amd_iommu *iommu)
+{
+	u64 entry;
+
+	BUG_ON(iommu->evt_buf == NULL);
+
 	entry = (u64)virt_to_phys(iommu->evt_buf) | EVT_LEN_MASK;
+
 	memcpy_toio(iommu->mmio_base + MMIO_EVT_BUF_OFFSET,
 		    &entry, sizeof(entry));
 
-	iommu->evt_buf_size = EVT_BUFFER_SIZE;
-
-	return iommu->evt_buf;
+	iommu_feature_enable(iommu, CONTROL_EVT_LOG_EN);
 }
 
 static void __init free_event_buffer(struct amd_iommu *iommu)
@@ -596,32 +618,83 @@ static void __init init_iommu_from_acpi(struct amd_iommu *iommu,
 	p += sizeof(struct ivhd_header);
 	end += h->length;
 
+
 	while (p < end) {
 		e = (struct ivhd_entry *)p;
 		switch (e->type) {
 		case IVHD_DEV_ALL:
+
+			DUMP_printk("  DEV_ALL\t\t\t first devid: %02x:%02x.%x"
+				    " last device %02x:%02x.%x flags: %02x\n",
+				    PCI_BUS(iommu->first_device),
+				    PCI_SLOT(iommu->first_device),
+				    PCI_FUNC(iommu->first_device),
+				    PCI_BUS(iommu->last_device),
+				    PCI_SLOT(iommu->last_device),
+				    PCI_FUNC(iommu->last_device),
+				    e->flags);
+
 			for (dev_i = iommu->first_device;
 					dev_i <= iommu->last_device; ++dev_i)
 				set_dev_entry_from_acpi(iommu, dev_i,
 							e->flags, 0);
 			break;
 		case IVHD_DEV_SELECT:
+
+			DUMP_printk("  DEV_SELECT\t\t\t devid: %02x:%02x.%x "
+				    "flags: %02x\n",
+				    PCI_BUS(e->devid),
+				    PCI_SLOT(e->devid),
+				    PCI_FUNC(e->devid),
+				    e->flags);
+
 			devid = e->devid;
 			set_dev_entry_from_acpi(iommu, devid, e->flags, 0);
 			break;
 		case IVHD_DEV_SELECT_RANGE_START:
+
+			DUMP_printk("  DEV_SELECT_RANGE_START\t "
+				    "devid: %02x:%02x.%x flags: %02x\n",
+				    PCI_BUS(e->devid),
+				    PCI_SLOT(e->devid),
+				    PCI_FUNC(e->devid),
+				    e->flags);
+
 			devid_start = e->devid;
 			flags = e->flags;
 			ext_flags = 0;
 			alias = false;
 			break;
 		case IVHD_DEV_ALIAS:
+
+			DUMP_printk("  DEV_ALIAS\t\t\t devid: %02x:%02x.%x "
+				    "flags: %02x devid_to: %02x:%02x.%x\n",
+				    PCI_BUS(e->devid),
+				    PCI_SLOT(e->devid),
+				    PCI_FUNC(e->devid),
+				    e->flags,
+				    PCI_BUS(e->ext >> 8),
+				    PCI_SLOT(e->ext >> 8),
+				    PCI_FUNC(e->ext >> 8));
+
 			devid = e->devid;
 			devid_to = e->ext >> 8;
-			set_dev_entry_from_acpi(iommu, devid, e->flags, 0);
+			set_dev_entry_from_acpi(iommu, devid_to, e->flags, 0);
 			amd_iommu_alias_table[devid] = devid_to;
 			break;
 		case IVHD_DEV_ALIAS_RANGE:
+
+			DUMP_printk("  DEV_ALIAS_RANGE\t\t "
+				    "devid: %02x:%02x.%x flags: %02x "
+				    "devid_to: %02x:%02x.%x\n",
+				    PCI_BUS(e->devid),
+				    PCI_SLOT(e->devid),
+				    PCI_FUNC(e->devid),
+				    e->flags,
+				    PCI_BUS(e->ext >> 8),
+				    PCI_SLOT(e->ext >> 8),
+				    PCI_FUNC(e->ext >> 8));
+
 			devid_start = e->devid;
 			flags = e->flags;
 			devid_to = e->ext >> 8;
@@ -629,17 +702,39 @@ static void __init init_iommu_from_acpi(struct amd_iommu *iommu,
 			alias = true;
 			break;
 		case IVHD_DEV_EXT_SELECT:
+
+			DUMP_printk("  DEV_EXT_SELECT\t\t devid: %02x:%02x.%x "
+				    "flags: %02x ext: %08x\n",
+				    PCI_BUS(e->devid),
+				    PCI_SLOT(e->devid),
+				    PCI_FUNC(e->devid),
+				    e->flags, e->ext);
+
 			devid = e->devid;
 			set_dev_entry_from_acpi(iommu, devid, e->flags,
 						e->ext);
 			break;
 		case IVHD_DEV_EXT_SELECT_RANGE:
+
+			DUMP_printk("  DEV_EXT_SELECT_RANGE\t devid: "
+				    "%02x:%02x.%x flags: %02x ext: %08x\n",
+				    PCI_BUS(e->devid),
+				    PCI_SLOT(e->devid),
+				    PCI_FUNC(e->devid),
+				    e->flags, e->ext);
+
 			devid_start = e->devid;
 			flags = e->flags;
 			ext_flags = e->ext;
 			alias = false;
 			break;
 		case IVHD_DEV_RANGE_END:
+
+			DUMP_printk("  DEV_RANGE_END\t\t devid: %02x:%02x.%x\n",
+				    PCI_BUS(e->devid),
+				    PCI_SLOT(e->devid),
+				    PCI_FUNC(e->devid));
+
 			devid = e->devid;
 			for (dev_i = devid_start; dev_i <= devid; ++dev_i) {
 				if (alias)
@@ -679,7 +774,7 @@ static void __init free_iommu_all(void)
 {
 	struct amd_iommu *iommu, *next;
 
-	list_for_each_entry_safe(iommu, next, &amd_iommu_list, list) {
+	for_each_iommu_safe(iommu, next) {
 		list_del(&iommu->list);
 		free_iommu_one(iommu);
 		kfree(iommu);
@@ -710,7 +805,6 @@ static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h)
 	if (!iommu->mmio_base)
 		return -ENOMEM;
 
-	iommu_set_device_table(iommu);
 	iommu->cmd_buf = alloc_command_buffer(iommu);
 	if (!iommu->cmd_buf)
 		return -ENOMEM;
@@ -746,6 +840,15 @@ static int __init init_iommu_all(struct acpi_table_header *table)
 		h = (struct ivhd_header *)p;
 		switch (*p) {
 		case ACPI_IVHD_TYPE:
+
+			DUMP_printk("IOMMU: device: %02x:%02x.%01x cap: %04x "
+				    "seg: %d flags: %01x info %04x\n",
+				    PCI_BUS(h->devid), PCI_SLOT(h->devid),
+				    PCI_FUNC(h->devid), h->cap_ptr,
+				    h->pci_seg, h->flags, h->info);
+			DUMP_printk("       mmio-addr: %016llx\n",
+				    h->mmio_phys);
+
 			iommu = kzalloc(sizeof(struct amd_iommu), GFP_KERNEL);
 			if (iommu == NULL)
 				return -ENOMEM;
@@ -773,56 +876,9 @@ static int __init init_iommu_all(struct acpi_table_header *table)
  *
  ****************************************************************************/
 
-static int __init iommu_setup_msix(struct amd_iommu *iommu)
-{
-	struct amd_iommu *curr;
-	struct msix_entry entries[32]; /* only 32 supported by AMD IOMMU */
-	int nvec = 0, i;
-
-	list_for_each_entry(curr, &amd_iommu_list, list) {
-		if (curr->dev == iommu->dev) {
-			entries[nvec].entry = curr->evt_msi_num;
-			entries[nvec].vector = 0;
-			curr->int_enabled = true;
-			nvec++;
-		}
-	}
-
-	if (pci_enable_msix(iommu->dev, entries, nvec)) {
-		pci_disable_msix(iommu->dev);
-		return 1;
-	}
-
-	for (i = 0; i < nvec; ++i) {
-		int r = request_irq(entries->vector, amd_iommu_int_handler,
-				    IRQF_SAMPLE_RANDOM,
-				    "AMD IOMMU",
-				    NULL);
-		if (r)
-			goto out_free;
-	}
-
-	return 0;
-
-out_free:
-	for (i -= 1; i >= 0; --i)
-		free_irq(entries->vector, NULL);
-
-	pci_disable_msix(iommu->dev);
-
-	return 1;
-}
-
 static int __init iommu_setup_msi(struct amd_iommu *iommu)
 {
 	int r;
-	struct amd_iommu *curr;
-
-	list_for_each_entry(curr, &amd_iommu_list, list) {
-		if (curr->dev == iommu->dev)
-			curr->int_enabled = true;
-	}
-
 
 	if (pci_enable_msi(iommu->dev))
 		return 1;
@@ -837,17 +893,18 @@ static int __init iommu_setup_msi(struct amd_iommu *iommu)
 		return 1;
 	}
 
+	iommu->int_enabled = true;
+	iommu_feature_enable(iommu, CONTROL_EVT_INT_EN);
+
 	return 0;
 }
 
-static int __init iommu_init_msi(struct amd_iommu *iommu)
+static int iommu_init_msi(struct amd_iommu *iommu)
 {
 	if (iommu->int_enabled)
 		return 0;
 
-	if (pci_find_capability(iommu->dev, PCI_CAP_ID_MSIX))
-		return iommu_setup_msix(iommu);
-	else if (pci_find_capability(iommu->dev, PCI_CAP_ID_MSI))
+	if (pci_find_capability(iommu->dev, PCI_CAP_ID_MSI))
 		return iommu_setup_msi(iommu);
 
 	return 1;
@@ -899,6 +956,7 @@ static int __init init_exclusion_range(struct ivmd_header *m)
 static int __init init_unity_map_range(struct ivmd_header *m)
 {
 	struct unity_map_entry *e = 0;
+	char *s;
 
 	e = kzalloc(sizeof(*e), GFP_KERNEL);
 	if (e == NULL)
@@ -906,14 +964,19 @@ static int __init init_unity_map_range(struct ivmd_header *m)
 
 	switch (m->type) {
 	default:
+		kfree(e);
+		return 0;
 	case ACPI_IVMD_TYPE:
+		s = "IVMD_TYPEi\t\t\t";
 		e->devid_start = e->devid_end = m->devid;
 		break;
 	case ACPI_IVMD_TYPE_ALL:
+		s = "IVMD_TYPE_ALL\t\t";
 		e->devid_start = 0;
 		e->devid_end = amd_iommu_last_bdf;
 		break;
 	case ACPI_IVMD_TYPE_RANGE:
+		s = "IVMD_TYPE_RANGE\t\t";
 		e->devid_start = m->devid;
 		e->devid_end = m->aux;
 		break;
@@ -922,6 +985,13 @@ static int __init init_unity_map_range(struct ivmd_header *m)
 	e->address_end = e->address_start + PAGE_ALIGN(m->range_length);
 	e->prot = m->flags >> 1;
 
+	DUMP_printk("%s devid_start: %02x:%02x.%x devid_end: %02x:%02x.%x"
+		    " range_start: %016llx range_end: %016llx flags: %x\n", s,
+		    PCI_BUS(e->devid_start), PCI_SLOT(e->devid_start),
+		    PCI_FUNC(e->devid_start), PCI_BUS(e->devid_end),
+		    PCI_SLOT(e->devid_end), PCI_FUNC(e->devid_end),
+		    e->address_start, e->address_end, m->flags);
+
 	list_add_tail(&e->list, &amd_iommu_unity_map);
 
 	return 0;
@@ -967,18 +1037,28 @@ static void init_device_table(void)
  * This function finally enables all IOMMUs found in the system after
  * they have been initialized
  */
-static void __init enable_iommus(void)
+static void enable_iommus(void)
 {
 	struct amd_iommu *iommu;
 
-	list_for_each_entry(iommu, &amd_iommu_list, list) {
+	for_each_iommu(iommu) {
+		iommu_set_device_table(iommu);
+		iommu_enable_command_buffer(iommu);
+		iommu_enable_event_buffer(iommu);
 		iommu_set_exclusion_range(iommu);
 		iommu_init_msi(iommu);
-		iommu_enable_event_logging(iommu);
 		iommu_enable(iommu);
 	}
 }
 
+static void disable_iommus(void)
+{
+	struct amd_iommu *iommu;
+
+	for_each_iommu(iommu)
+		iommu_disable(iommu);
+}
+
 /*
  * Suspend/Resume support
  * disable suspend until real resume implemented
@@ -986,12 +1066,31 @@ static void __init enable_iommus(void)
 
 static int amd_iommu_resume(struct sys_device *dev)
 {
+	/*
+	 * Disable IOMMUs before reprogramming the hardware registers.
+	 * IOMMU is still enabled from the resume kernel.
+	 */
+	disable_iommus();
+
+	/* re-load the hardware */
+	enable_iommus();
+
+	/*
+	 * we have to flush after the IOMMUs are enabled because a
+	 * disabled IOMMU will never execute the commands we send
+	 */
+	amd_iommu_flush_all_domains();
+	amd_iommu_flush_all_devices();
+
 	return 0;
 }
 
 static int amd_iommu_suspend(struct sys_device *dev, pm_message_t state)
 {
-	return -EINVAL;
+	/* disable IOMMUs to go out of the way for BIOS */
+	disable_iommus();
+
+	return 0;
 }
 
 static struct sysdev_class amd_iommu_sysdev_class = {
@@ -1137,9 +1236,6 @@ int __init amd_iommu_init(void)
 
 	enable_iommus();
 
-	printk(KERN_INFO "AMD IOMMU: aperture size is %d MB\n",
-			(1 << (amd_iommu_aperture_order-20)));
-
 	printk(KERN_INFO "AMD IOMMU: device isolation ");
 	if (amd_iommu_isolate)
 		printk("enabled\n");
@@ -1211,6 +1307,13 @@ void __init amd_iommu_detect(void)
  *
  ****************************************************************************/
 
+static int __init parse_amd_iommu_dump(char *str)
+{
+	amd_iommu_dump = true;
+
+	return 1;
+}
+
 static int __init parse_amd_iommu_options(char *str)
 {
 	for (; *str; ++str) {
@@ -1225,15 +1328,5 @@ static int __init parse_amd_iommu_options(char *str)
 	return 1;
 }
 
-static int __init parse_amd_iommu_size_options(char *str)
-{
-	unsigned order = PAGE_SHIFT + get_order(memparse(str, &str));
-
-	if ((order > 24) && (order < 31))
-		amd_iommu_aperture_order = order;
-
-	return 1;
-}
-
+__setup("amd_iommu_dump", parse_amd_iommu_dump);
 __setup("amd_iommu=", parse_amd_iommu_options);
-__setup("amd_iommu_size=", parse_amd_iommu_size_options);
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 755c21e..971a3be 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -186,37 +186,6 @@ static struct cal_chipset_ops calioc2_chip_ops = {
 
 static struct calgary_bus_info bus_info[MAX_PHB_BUS_NUM] = { { NULL, 0, 0 }, };
 
-/* enable this to stress test the chip's TCE cache */
-#ifdef CONFIG_IOMMU_DEBUG
-static int debugging = 1;
-
-static inline unsigned long verify_bit_range(unsigned long* bitmap,
-	int expected, unsigned long start, unsigned long end)
-{
-	unsigned long idx = start;
-
-	BUG_ON(start >= end);
-
-	while (idx < end) {
-		if (!!test_bit(idx, bitmap) != expected)
-			return idx;
-		++idx;
-	}
-
-	/* all bits have the expected value */
-	return ~0UL;
-}
-#else /* debugging is disabled */
-static int debugging;
-
-static inline unsigned long verify_bit_range(unsigned long* bitmap,
-	int expected, unsigned long start, unsigned long end)
-{
-	return ~0UL;
-}
-
-#endif /* CONFIG_IOMMU_DEBUG */
-
 static inline int translation_enabled(struct iommu_table *tbl)
 {
 	/* only PHBs with translation enabled have an IOMMU table */
@@ -228,7 +197,6 @@ static void iommu_range_reserve(struct iommu_table *tbl,
 {
 	unsigned long index;
 	unsigned long end;
-	unsigned long badbit;
 	unsigned long flags;
 
 	index = start_addr >> PAGE_SHIFT;
@@ -243,14 +211,6 @@ static void iommu_range_reserve(struct iommu_table *tbl,
 
 	spin_lock_irqsave(&tbl->it_lock, flags);
 
-	badbit = verify_bit_range(tbl->it_map, 0, index, end);
-	if (badbit != ~0UL) {
-		if (printk_ratelimit())
-			printk(KERN_ERR "Calgary: entry already allocated at "
-			       "0x%lx tbl %p dma 0x%lx npages %u\n",
-			       badbit, tbl, start_addr, npages);
-	}
-
 	iommu_area_reserve(tbl->it_map, index, npages);
 
 	spin_unlock_irqrestore(&tbl->it_lock, flags);
@@ -326,7 +286,6 @@ static void iommu_free(struct iommu_table *tbl, dma_addr_t dma_addr,
 	unsigned int npages)
 {
 	unsigned long entry;
-	unsigned long badbit;
 	unsigned long badend;
 	unsigned long flags;
 
@@ -346,14 +305,6 @@ static void iommu_free(struct iommu_table *tbl, dma_addr_t dma_addr,
 
 	spin_lock_irqsave(&tbl->it_lock, flags);
 
-	badbit = verify_bit_range(tbl->it_map, 1, entry, entry + npages);
-	if (badbit != ~0UL) {
-		if (printk_ratelimit())
-			printk(KERN_ERR "Calgary: bit is off at 0x%lx "
-			       "tbl %p dma 0x%Lx entry 0x%lx npages %u\n",
-			       badbit, tbl, dma_addr, entry, npages);
-	}
-
 	iommu_area_free(tbl->it_map, entry, npages);
 
 	spin_unlock_irqrestore(&tbl->it_lock, flags);
@@ -1488,9 +1439,8 @@ void __init detect_calgary(void)
 		iommu_detected = 1;
 		calgary_detected = 1;
 		printk(KERN_INFO "PCI-DMA: Calgary IOMMU detected.\n");
-		printk(KERN_INFO "PCI-DMA: Calgary TCE table spec is %d, "
-		       "CONFIG_IOMMU_DEBUG is %s.\n", specified_table_size,
-		       debugging ? "enabled" : "disabled");
+		printk(KERN_INFO "PCI-DMA: Calgary TCE table spec is %d\n",
+		       specified_table_size);
 
 		/* swiotlb for devices that aren't behind the Calgary. */
 		if (max_pfn > MAX_DMA32_PFN)
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index b284b58..cfd9f90 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -144,48 +144,21 @@ static void flush_gart(void)
 }
 
 #ifdef CONFIG_IOMMU_LEAK
-
-#define SET_LEAK(x)							\
-	do {								\
-		if (iommu_leak_tab)					\
-			iommu_leak_tab[x] = __builtin_return_address(0);\
-	} while (0)
-
-#define CLEAR_LEAK(x)							\
-	do {								\
-		if (iommu_leak_tab)					\
-			iommu_leak_tab[x] = NULL;			\
-	} while (0)
-
 /* Debugging aid for drivers that don't free their IOMMU tables */
-static void **iommu_leak_tab;
 static int leak_trace;
 static int iommu_leak_pages = 20;
 
 static void dump_leak(void)
 {
-	int i;
 	static int dump;
 
-	if (dump || !iommu_leak_tab)
+	if (dump)
 		return;
 	dump = 1;
-	show_stack(NULL, NULL);
 
-	/* Very crude. dump some from the end of the table too */
-	printk(KERN_DEBUG "Dumping %d pages from end of IOMMU:\n",
-	       iommu_leak_pages);
-	for (i = 0; i < iommu_leak_pages; i += 2) {
-		printk(KERN_DEBUG "%lu: ", iommu_pages-i);
-		printk_address((unsigned long) iommu_leak_tab[iommu_pages-i],
-				0);
-		printk(KERN_CONT "%c", (i+1)%2 == 0 ? '\n' : ' ');
-	}
-	printk(KERN_DEBUG "\n");
+	show_stack(NULL, NULL);
+	debug_dma_dump_mappings(NULL);
 }
-#else
-# define SET_LEAK(x)
-# define CLEAR_LEAK(x)
 #endif
 
 static void iommu_full(struct device *dev, size_t size, int dir)
@@ -248,7 +221,6 @@ static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
 
 	for (i = 0; i < npages; i++) {
 		iommu_gatt_base[iommu_page + i] = GPTE_ENCODE(phys_mem);
-		SET_LEAK(iommu_page + i);
 		phys_mem += PAGE_SIZE;
 	}
 	return iommu_bus_base + iommu_page*PAGE_SIZE + (phys_mem & ~PAGE_MASK);
@@ -294,7 +266,6 @@ static void gart_unmap_page(struct device *dev, dma_addr_t dma_addr,
 	npages = iommu_num_pages(dma_addr, size, PAGE_SIZE);
 	for (i = 0; i < npages; i++) {
 		iommu_gatt_base[iommu_page + i] = gart_unmapped_entry;
-		CLEAR_LEAK(iommu_page + i);
 	}
 	free_iommu(iommu_page, npages);
 }
@@ -377,7 +348,6 @@ static int __dma_map_cont(struct device *dev, struct scatterlist *start,
 		pages = iommu_num_pages(s->offset, s->length, PAGE_SIZE);
 		while (pages--) {
 			iommu_gatt_base[iommu_page] = GPTE_ENCODE(addr);
-			SET_LEAK(iommu_page);
 			addr += PAGE_SIZE;
 			iommu_page++;
 		}
@@ -688,8 +658,6 @@ static __init int init_k8_gatt(struct agp_kern_info *info)
 
 	agp_gatt_table = gatt;
 
-	enable_gart_translations();
-
 	error = sysdev_class_register(&gart_sysdev_class);
 	if (!error)
 		error = sysdev_register(&device_gart);
@@ -801,11 +769,12 @@ void __init gart_iommu_init(void)
 
 #ifdef CONFIG_IOMMU_LEAK
 	if (leak_trace) {
-		iommu_leak_tab = (void *)__get_free_pages(GFP_KERNEL|__GFP_ZERO,
-				  get_order(iommu_pages*sizeof(void *)));
-		if (!iommu_leak_tab)
+		int ret;
+
+		ret = dma_debug_resize_entries(iommu_pages);
+		if (ret)
 			printk(KERN_DEBUG
-			       "PCI-DMA: Cannot allocate leak trace area\n");
+			       "PCI-DMA: Cannot trace all the entries\n");
 	}
 #endif
 
@@ -845,6 +814,14 @@ void __init gart_iommu_init(void)
 	 * the pages as Not-Present:
 	 */
 	wbinvd();
+	
+	/*
+	 * Now all caches are flushed and we can safely enable
+	 * GART hardware.  Doing it early leaves the possibility
+	 * of stale cache entries that can lead to GART PTE
+	 * errors.
+	 */
+	enable_gart_translations();
 
 	/*
 	 * Try to workaround a bug (thanks to BenH):
diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index 221a385..a1712f2 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -28,7 +28,7 @@ dma_addr_t swiotlb_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
 	return paddr;
 }
 
-phys_addr_t swiotlb_bus_to_phys(dma_addr_t baddr)
+phys_addr_t swiotlb_bus_to_phys(struct device *hwdev, dma_addr_t baddr)
 {
 	return baddr;
 }
diff --git a/include/linux/dma-debug.h b/include/linux/dma-debug.h
index 28d53cb..171ad8a 100644
--- a/include/linux/dma-debug.h
+++ b/include/linux/dma-debug.h
@@ -32,6 +32,8 @@ extern void dma_debug_add_bus(struct bus_type *bus);
 
 extern void dma_debug_init(u32 num_entries);
 
+extern int dma_debug_resize_entries(u32 num_entries);
+
 extern void debug_dma_map_page(struct device *dev, struct page *page,
 			       size_t offset, size_t size,
 			       int direction, dma_addr_t dma_addr,
@@ -91,6 +93,11 @@ static inline void dma_debug_init(u32 num_entries)
 {
 }
 
+static inline int dma_debug_resize_entries(u32 num_entries)
+{
+	return 0;
+}
+
 static inline void debug_dma_map_page(struct device *dev, struct page *page,
 				      size_t offset, size_t size,
 				      int direction, dma_addr_t dma_addr,
diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index ac9ff54..cb1a663 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -29,7 +29,8 @@ extern void *swiotlb_alloc(unsigned order, unsigned long nslabs);
 
 extern dma_addr_t swiotlb_phys_to_bus(struct device *hwdev,
 				      phys_addr_t address);
-extern phys_addr_t swiotlb_bus_to_phys(dma_addr_t address);
+extern phys_addr_t swiotlb_bus_to_phys(struct device *hwdev,
+				       dma_addr_t address);
 
 extern int swiotlb_arch_range_needs_mapping(phys_addr_t paddr, size_t size);
 
diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 69da09a..ad65fc0 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -23,9 +23,11 @@
 #include <linux/dma-debug.h>
 #include <linux/spinlock.h>
 #include <linux/debugfs.h>
+#include <linux/uaccess.h>
 #include <linux/device.h>
 #include <linux/types.h>
 #include <linux/sched.h>
+#include <linux/ctype.h>
 #include <linux/list.h>
 #include <linux/slab.h>
 
@@ -85,6 +87,7 @@ static u32 show_num_errors = 1;
 
 static u32 num_free_entries;
 static u32 min_free_entries;
+static u32 nr_total_entries;
 
 /* number of preallocated entries requested by kernel cmdline */
 static u32 req_entries;
@@ -97,6 +100,16 @@ static struct dentry *show_all_errors_dent  __read_mostly;
 static struct dentry *show_num_errors_dent  __read_mostly;
 static struct dentry *num_free_entries_dent __read_mostly;
 static struct dentry *min_free_entries_dent __read_mostly;
+static struct dentry *filter_dent           __read_mostly;
+
+/* per-driver filter related state */
+
+#define NAME_MAX_LEN	64
+
+static char                  current_driver_name[NAME_MAX_LEN] __read_mostly;
+static struct device_driver *current_driver                    __read_mostly;
+
+static DEFINE_RWLOCK(driver_name_lock);
 
 static const char *type2name[4] = { "single", "page",
 				    "scather-gather", "coherent" };
@@ -104,6 +117,11 @@ static const char *type2name[4] = { "single", "page",
 static const char *dir2name[4] = { "DMA_BIDIRECTIONAL", "DMA_TO_DEVICE",
 				   "DMA_FROM_DEVICE", "DMA_NONE" };
 
+/* little merge helper - remove it after the merge window */
+#ifndef BUS_NOTIFY_UNBOUND_DRIVER
+#define BUS_NOTIFY_UNBOUND_DRIVER 0x0005
+#endif
+
 /*
  * The access to some variables in this macro is racy. We can't use atomic_t
  * here because all these variables are exported to debugfs. Some of them even
@@ -121,15 +139,54 @@ static inline void dump_entry_trace(struct dma_debug_entry *entry)
 {
 #ifdef CONFIG_STACKTRACE
 	if (entry) {
-		printk(KERN_WARNING "Mapped at:\n");
+		pr_warning("Mapped at:\n");
 		print_stack_trace(&entry->stacktrace, 0);
 	}
 #endif
 }
 
+static bool driver_filter(struct device *dev)
+{
+	struct device_driver *drv;
+	unsigned long flags;
+	bool ret;
+
+	/* driver filter off */
+	if (likely(!current_driver_name[0]))
+		return true;
+
+	/* driver filter on and initialized */
+	if (current_driver && dev->driver == current_driver)
+		return true;
+
+	if (current_driver || !current_driver_name[0])
+		return false;
+
+	/* driver filter on but not yet initialized */
+	drv = get_driver(dev->driver);
+	if (!drv)
+		return false;
+
+	/* lock to protect against change of current_driver_name */
+	read_lock_irqsave(&driver_name_lock, flags);
+
+	ret = false;
+	if (drv->name &&
+	    strncmp(current_driver_name, drv->name, NAME_MAX_LEN - 1) == 0) {
+		current_driver = drv;
+		ret = true;
+	}
+
+	read_unlock_irqrestore(&driver_name_lock, flags);
+	put_driver(drv);
+
+	return ret;
+}
+
 #define err_printk(dev, entry, format, arg...) do {		\
 		error_count += 1;				\
-		if (show_all_errors || show_num_errors > 0) {	\
+		if (driver_filter(dev) &&			\
+		    (show_all_errors || show_num_errors > 0)) {	\
 			WARN(1, "%s %s: " format,		\
 			     dev_driver_string(dev),		\
 			     dev_name(dev) , ## arg);		\
@@ -185,15 +242,50 @@ static void put_hash_bucket(struct hash_bucket *bucket,
 static struct dma_debug_entry *hash_bucket_find(struct hash_bucket *bucket,
 						struct dma_debug_entry *ref)
 {
-	struct dma_debug_entry *entry;
+	struct dma_debug_entry *entry, *ret = NULL;
+	int matches = 0, match_lvl, last_lvl = 0;
 
 	list_for_each_entry(entry, &bucket->list, list) {
-		if ((entry->dev_addr == ref->dev_addr) &&
-		    (entry->dev == ref->dev))
+		if ((entry->dev_addr != ref->dev_addr) ||
+		    (entry->dev != ref->dev))
+			continue;
+
+		/*
+		 * Some drivers map the same physical address multiple
+		 * times. Without a hardware IOMMU this results in the
+		 * same device addresses being put into the dma-debug
+		 * hash multiple times too. This can result in false
+		 * positives being reported. Therfore we implement a
+		 * best-fit algorithm here which returns the entry from
+		 * the hash which fits best to the reference value
+		 * instead of the first-fit.
+		 */
+		matches += 1;
+		match_lvl = 0;
+		entry->size      == ref->size      ? ++match_lvl : match_lvl;
+		entry->type      == ref->type      ? ++match_lvl : match_lvl;
+		entry->direction == ref->direction ? ++match_lvl : match_lvl;
+
+		if (match_lvl == 3) {
+			/* perfect-fit - return the result */
 			return entry;
+		} else if (match_lvl > last_lvl) {
+			/*
+			 * We found an entry that fits better then the
+			 * previous one
+			 */
+			last_lvl = match_lvl;
+			ret      = entry;
+		}
 	}
 
-	return NULL;
+	/*
+	 * If we have multiple matches but no perfect-fit, just return
+	 * NULL.
+	 */
+	ret = (matches == 1) ? ret : NULL;
+
+	return ret;
 }
 
 /*
@@ -257,6 +349,21 @@ static void add_dma_entry(struct dma_debug_entry *entry)
 	put_hash_bucket(bucket, &flags);
 }
 
+static struct dma_debug_entry *__dma_entry_alloc(void)
+{
+	struct dma_debug_entry *entry;
+
+	entry = list_entry(free_entries.next, struct dma_debug_entry, list);
+	list_del(&entry->list);
+	memset(entry, 0, sizeof(*entry));
+
+	num_free_entries -= 1;
+	if (num_free_entries < min_free_entries)
+		min_free_entries = num_free_entries;
+
+	return entry;
+}
+
 /* struct dma_entry allocator
  *
  * The next two functions implement the allocator for
@@ -270,15 +377,12 @@ static struct dma_debug_entry *dma_entry_alloc(void)
 	spin_lock_irqsave(&free_entries_lock, flags);
 
 	if (list_empty(&free_entries)) {
-		printk(KERN_ERR "DMA-API: debugging out of memory "
-				"- disabling\n");
+		pr_err("DMA-API: debugging out of memory - disabling\n");
 		global_disable = true;
 		goto out;
 	}
 
-	entry = list_entry(free_entries.next, struct dma_debug_entry, list);
-	list_del(&entry->list);
-	memset(entry, 0, sizeof(*entry));
+	entry = __dma_entry_alloc();
 
 #ifdef CONFIG_STACKTRACE
 	entry->stacktrace.max_entries = DMA_DEBUG_STACKTRACE_ENTRIES;
@@ -286,9 +390,6 @@ static struct dma_debug_entry *dma_entry_alloc(void)
 	entry->stacktrace.skip = 2;
 	save_stack_trace(&entry->stacktrace);
 #endif
-	num_free_entries -= 1;
-	if (num_free_entries < min_free_entries)
-		min_free_entries = num_free_entries;
 
 out:
 	spin_unlock_irqrestore(&free_entries_lock, flags);
@@ -310,6 +411,53 @@ static void dma_entry_free(struct dma_debug_entry *entry)
 	spin_unlock_irqrestore(&free_entries_lock, flags);
 }
 
+int dma_debug_resize_entries(u32 num_entries)
+{
+	int i, delta, ret = 0;
+	unsigned long flags;
+	struct dma_debug_entry *entry;
+	LIST_HEAD(tmp);
+
+	spin_lock_irqsave(&free_entries_lock, flags);
+
+	if (nr_total_entries < num_entries) {
+		delta = num_entries - nr_total_entries;
+
+		spin_unlock_irqrestore(&free_entries_lock, flags);
+
+		for (i = 0; i < delta; i++) {
+			entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+			if (!entry)
+				break;
+
+			list_add_tail(&entry->list, &tmp);
+		}
+
+		spin_lock_irqsave(&free_entries_lock, flags);
+
+		list_splice(&tmp, &free_entries);
+		nr_total_entries += i;
+		num_free_entries += i;
+	} else {
+		delta = nr_total_entries - num_entries;
+
+		for (i = 0; i < delta && !list_empty(&free_entries); i++) {
+			entry = __dma_entry_alloc();
+			kfree(entry);
+		}
+
+		nr_total_entries -= i;
+	}
+
+	if (nr_total_entries != num_entries)
+		ret = 1;
+
+	spin_unlock_irqrestore(&free_entries_lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(dma_debug_resize_entries);
+
 /*
  * DMA-API debugging init code
  *
@@ -334,8 +482,7 @@ static int prealloc_memory(u32 num_entries)
 	num_free_entries = num_entries;
 	min_free_entries = num_entries;
 
-	printk(KERN_INFO "DMA-API: preallocated %d debug entries\n",
-			num_entries);
+	pr_info("DMA-API: preallocated %d debug entries\n", num_entries);
 
 	return 0;
 
@@ -349,11 +496,102 @@ out_err:
 	return -ENOMEM;
 }
 
+static ssize_t filter_read(struct file *file, char __user *user_buf,
+			   size_t count, loff_t *ppos)
+{
+	char buf[NAME_MAX_LEN + 1];
+	unsigned long flags;
+	int len;
+
+	if (!current_driver_name[0])
+		return 0;
+
+	/*
+	 * We can't copy to userspace directly because current_driver_name can
+	 * only be read under the driver_name_lock with irqs disabled. So
+	 * create a temporary copy first.
+	 */
+	read_lock_irqsave(&driver_name_lock, flags);
+	len = scnprintf(buf, NAME_MAX_LEN + 1, "%s\n", current_driver_name);
+	read_unlock_irqrestore(&driver_name_lock, flags);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t filter_write(struct file *file, const char __user *userbuf,
+			    size_t count, loff_t *ppos)
+{
+	char buf[NAME_MAX_LEN];
+	unsigned long flags;
+	size_t len;
+	int i;
+
+	/*
+	 * We can't copy from userspace directly. Access to
+	 * current_driver_name is protected with a write_lock with irqs
+	 * disabled. Since copy_from_user can fault and may sleep we
+	 * need to copy to temporary buffer first
+	 */
+	len = min(count, (size_t)(NAME_MAX_LEN - 1));
+	if (copy_from_user(buf, userbuf, len))
+		return -EFAULT;
+
+	buf[len] = 0;
+
+	write_lock_irqsave(&driver_name_lock, flags);
+
+	/*
+	 * Now handle the string we got from userspace very carefully.
+	 * The rules are:
+	 *         - only use the first token we got
+	 *         - token delimiter is everything looking like a space
+	 *           character (' ', '\n', '\t' ...)
+	 *
+	 */
+	if (!isalnum(buf[0])) {
+		/*
+		 * If the first character userspace gave us is not
+		 * alphanumerical then assume the filter should be
+		 * switched off.
+		 */
+		if (current_driver_name[0])
+			pr_info("DMA-API: switching off dma-debug driver filter\n");
+		current_driver_name[0] = 0;
+		current_driver = NULL;
+		goto out_unlock;
+	}
+
+	/*
+	 * Now parse out the first token and use it as the name for the
+	 * driver to filter for.
+	 */
+	for (i = 0; i < NAME_MAX_LEN; ++i) {
+		current_driver_name[i] = buf[i];
+		if (isspace(buf[i]) || buf[i] == ' ' || buf[i] == 0)
+			break;
+	}
+	current_driver_name[i] = 0;
+	current_driver = NULL;
+
+	pr_info("DMA-API: enable driver filter for driver [%s]\n",
+		current_driver_name);
+
+out_unlock:
+	write_unlock_irqrestore(&driver_name_lock, flags);
+
+	return count;
+}
+
+const struct file_operations filter_fops = {
+	.read  = filter_read,
+	.write = filter_write,
+};
+
 static int dma_debug_fs_init(void)
 {
 	dma_debug_dent = debugfs_create_dir("dma-api", NULL);
 	if (!dma_debug_dent) {
-		printk(KERN_ERR "DMA-API: can not create debugfs directory\n");
+		pr_err("DMA-API: can not create debugfs directory\n");
 		return -ENOMEM;
 	}
 
@@ -392,6 +630,11 @@ static int dma_debug_fs_init(void)
 	if (!min_free_entries_dent)
 		goto out_err;
 
+	filter_dent = debugfs_create_file("driver_filter", 0644,
+					  dma_debug_dent, NULL, &filter_fops);
+	if (!filter_dent)
+		goto out_err;
+
 	return 0;
 
 out_err:
@@ -400,9 +643,64 @@ out_err:
 	return -ENOMEM;
 }
 
+static int device_dma_allocations(struct device *dev)
+{
+	struct dma_debug_entry *entry;
+	unsigned long flags;
+	int count = 0, i;
+
+	local_irq_save(flags);
+
+	for (i = 0; i < HASH_SIZE; ++i) {
+		spin_lock(&dma_entry_hash[i].lock);
+		list_for_each_entry(entry, &dma_entry_hash[i].list, list) {
+			if (entry->dev == dev)
+				count += 1;
+		}
+		spin_unlock(&dma_entry_hash[i].lock);
+	}
+
+	local_irq_restore(flags);
+
+	return count;
+}
+
+static int dma_debug_device_change(struct notifier_block *nb,
+				    unsigned long action, void *data)
+{
+	struct device *dev = data;
+	int count;
+
+
+	switch (action) {
+	case BUS_NOTIFY_UNBOUND_DRIVER:
+		count = device_dma_allocations(dev);
+		if (count == 0)
+			break;
+		err_printk(dev, NULL, "DMA-API: device driver has pending "
+				"DMA allocations while released from device "
+				"[count=%d]\n", count);
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
 void dma_debug_add_bus(struct bus_type *bus)
 {
-	/* FIXME: register notifier */
+	struct notifier_block *nb;
+
+	nb = kzalloc(sizeof(struct notifier_block), GFP_KERNEL);
+	if (nb == NULL) {
+		pr_err("dma_debug_add_bus: out of memory\n");
+		return;
+	}
+
+	nb->notifier_call = dma_debug_device_change;
+
+	bus_register_notifier(bus, nb);
 }
 
 /*
@@ -421,8 +719,7 @@ void dma_debug_init(u32 num_entries)
 	}
 
 	if (dma_debug_fs_init() != 0) {
-		printk(KERN_ERR "DMA-API: error creating debugfs entries "
-				"- disabling\n");
+		pr_err("DMA-API: error creating debugfs entries - disabling\n");
 		global_disable = true;
 
 		return;
@@ -432,14 +729,15 @@ void dma_debug_init(u32 num_entries)
 		num_entries = req_entries;
 
 	if (prealloc_memory(num_entries) != 0) {
-		printk(KERN_ERR "DMA-API: debugging out of memory error "
-				"- disabled\n");
+		pr_err("DMA-API: debugging out of memory error - disabled\n");
 		global_disable = true;
 
 		return;
 	}
 
-	printk(KERN_INFO "DMA-API: debugging enabled by kernel config\n");
+	nr_total_entries = num_free_entries;
+
+	pr_info("DMA-API: debugging enabled by kernel config\n");
 }
 
 static __init int dma_debug_cmdline(char *str)
@@ -448,8 +746,7 @@ static __init int dma_debug_cmdline(char *str)
 		return -EINVAL;
 
 	if (strncmp(str, "off", 3) == 0) {
-		printk(KERN_INFO "DMA-API: debugging disabled on kernel "
-				 "command line\n");
+		pr_info("DMA-API: debugging disabled on kernel command line\n");
 		global_disable = true;
 	}
 
@@ -723,15 +1020,15 @@ void debug_dma_map_sg(struct device *dev, struct scatterlist *sg,
 		entry->type           = dma_debug_sg;
 		entry->dev            = dev;
 		entry->paddr          = sg_phys(s);
-		entry->size           = s->length;
-		entry->dev_addr       = s->dma_address;
+		entry->size           = sg_dma_len(s);
+		entry->dev_addr       = sg_dma_address(s);
 		entry->direction      = direction;
 		entry->sg_call_ents   = nents;
 		entry->sg_mapped_ents = mapped_ents;
 
 		if (!PageHighMem(sg_page(s))) {
 			check_for_stack(dev, sg_virt(s));
-			check_for_illegal_area(dev, sg_virt(s), s->length);
+			check_for_illegal_area(dev, sg_virt(s), sg_dma_len(s));
 		}
 
 		add_dma_entry(entry);
@@ -739,13 +1036,33 @@ void debug_dma_map_sg(struct device *dev, struct scatterlist *sg,
 }
 EXPORT_SYMBOL(debug_dma_map_sg);
 
+static int get_nr_mapped_entries(struct device *dev, struct scatterlist *s)
+{
+	struct dma_debug_entry *entry, ref;
+	struct hash_bucket *bucket;
+	unsigned long flags;
+	int mapped_ents;
+
+	ref.dev      = dev;
+	ref.dev_addr = sg_dma_address(s);
+	ref.size     = sg_dma_len(s),
+
+	bucket       = get_hash_bucket(&ref, &flags);
+	entry        = hash_bucket_find(bucket, &ref);
+	mapped_ents  = 0;
+
+	if (entry)
+		mapped_ents = entry->sg_mapped_ents;
+	put_hash_bucket(bucket, &flags);
+
+	return mapped_ents;
+}
+
 void debug_dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
 			int nelems, int dir)
 {
-	struct dma_debug_entry *entry;
 	struct scatterlist *s;
 	int mapped_ents = 0, i;
-	unsigned long flags;
 
 	if (unlikely(global_disable))
 		return;
@@ -756,8 +1073,8 @@ void debug_dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
 			.type           = dma_debug_sg,
 			.dev            = dev,
 			.paddr          = sg_phys(s),
-			.dev_addr       = s->dma_address,
-			.size           = s->length,
+			.dev_addr       = sg_dma_address(s),
+			.size           = sg_dma_len(s),
 			.direction      = dir,
 			.sg_call_ents   = 0,
 		};
@@ -765,14 +1082,9 @@ void debug_dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
 		if (mapped_ents && i >= mapped_ents)
 			break;
 
-		if (mapped_ents == 0) {
-			struct hash_bucket *bucket;
+		if (!i) {
 			ref.sg_call_ents = nelems;
-			bucket = get_hash_bucket(&ref, &flags);
-			entry = hash_bucket_find(bucket, &ref);
-			if (entry)
-				mapped_ents = entry->sg_mapped_ents;
-			put_hash_bucket(bucket, &flags);
+			mapped_ents = get_nr_mapped_entries(dev, s);
 		}
 
 		check_unmap(&ref);
@@ -874,14 +1186,20 @@ void debug_dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
 			       int nelems, int direction)
 {
 	struct scatterlist *s;
-	int i;
+	int mapped_ents = 0, i;
 
 	if (unlikely(global_disable))
 		return;
 
 	for_each_sg(sg, s, nelems, i) {
-		check_sync(dev, s->dma_address, s->dma_length, 0,
-				direction, true);
+		if (!i)
+			mapped_ents = get_nr_mapped_entries(dev, s);
+
+		if (i >= mapped_ents)
+			break;
+
+		check_sync(dev, sg_dma_address(s), sg_dma_len(s), 0,
+			   direction, true);
 	}
 }
 EXPORT_SYMBOL(debug_dma_sync_sg_for_cpu);
@@ -890,15 +1208,39 @@ void debug_dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 				  int nelems, int direction)
 {
 	struct scatterlist *s;
-	int i;
+	int mapped_ents = 0, i;
 
 	if (unlikely(global_disable))
 		return;
 
 	for_each_sg(sg, s, nelems, i) {
-		check_sync(dev, s->dma_address, s->dma_length, 0,
-				direction, false);
+		if (!i)
+			mapped_ents = get_nr_mapped_entries(dev, s);
+
+		if (i >= mapped_ents)
+			break;
+
+		check_sync(dev, sg_dma_address(s), sg_dma_len(s), 0,
+			   direction, false);
 	}
 }
 EXPORT_SYMBOL(debug_dma_sync_sg_for_device);
 
+static int __init dma_debug_driver_setup(char *str)
+{
+	int i;
+
+	for (i = 0; i < NAME_MAX_LEN - 1; ++i, ++str) {
+		current_driver_name[i] = *str;
+		if (*str == 0)
+			break;
+	}
+
+	if (current_driver_name[0])
+		pr_info("DMA-API: enable driver filter for driver [%s]\n",
+			current_driver_name);
+
+
+	return 1;
+}
+__setup("dma_debug_driver=", dma_debug_driver_setup);
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 2b0b5a7..bffe6d7 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -60,8 +60,8 @@ enum dma_sync_target {
 int swiotlb_force;
 
 /*
- * Used to do a quick range check in swiotlb_unmap_single and
- * swiotlb_sync_single_*, to see if the memory was in fact allocated by this
+ * Used to do a quick range check in unmap_single and
+ * sync_single_*, to see if the memory was in fact allocated by this
  * API.
  */
 static char *io_tlb_start, *io_tlb_end;
@@ -129,7 +129,7 @@ dma_addr_t __weak swiotlb_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
 	return paddr;
 }
 
-phys_addr_t __weak swiotlb_bus_to_phys(dma_addr_t baddr)
+phys_addr_t __weak swiotlb_bus_to_phys(struct device *hwdev, dma_addr_t baddr)
 {
 	return baddr;
 }
@@ -140,9 +140,15 @@ static dma_addr_t swiotlb_virt_to_bus(struct device *hwdev,
 	return swiotlb_phys_to_bus(hwdev, virt_to_phys(address));
 }
 
-static void *swiotlb_bus_to_virt(dma_addr_t address)
+void * __weak swiotlb_bus_to_virt(struct device *hwdev, dma_addr_t address)
 {
-	return phys_to_virt(swiotlb_bus_to_phys(address));
+	return phys_to_virt(swiotlb_bus_to_phys(hwdev, address));
+}
+
+int __weak swiotlb_arch_address_needs_mapping(struct device *hwdev,
+					       dma_addr_t addr, size_t size)
+{
+	return !is_buffer_dma_capable(dma_get_mask(hwdev), addr, size);
 }
 
 int __weak swiotlb_arch_range_needs_mapping(phys_addr_t paddr, size_t size)
@@ -309,10 +315,10 @@ cleanup1:
 	return -ENOMEM;
 }
 
-static int
+static inline int
 address_needs_mapping(struct device *hwdev, dma_addr_t addr, size_t size)
 {
-	return !is_buffer_dma_capable(dma_get_mask(hwdev), addr, size);
+	return swiotlb_arch_address_needs_mapping(hwdev, addr, size);
 }
 
 static inline int range_needs_mapping(phys_addr_t paddr, size_t size)
@@ -341,7 +347,7 @@ static void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
 		unsigned long flags;
 
 		while (size) {
-			sz = min(PAGE_SIZE - offset, size);
+			sz = min_t(size_t, PAGE_SIZE - offset, size);
 
 			local_irq_save(flags);
 			buffer = kmap_atomic(pfn_to_page(pfn),
@@ -476,7 +482,7 @@ found:
  * dma_addr is the kernel virtual address of the bounce buffer to unmap.
  */
 static void
-unmap_single(struct device *hwdev, char *dma_addr, size_t size, int dir)
+do_unmap_single(struct device *hwdev, char *dma_addr, size_t size, int dir)
 {
 	unsigned long flags;
 	int i, count, nslots = ALIGN(size, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
@@ -560,7 +566,6 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 				   size)) {
 		/*
 		 * The allocated memory isn't reachable by the device.
-		 * Fall back on swiotlb_map_single().
 		 */
 		free_pages((unsigned long) ret, order);
 		ret = NULL;
@@ -568,9 +573,8 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 	if (!ret) {
 		/*
 		 * We are either out of memory or the device can't DMA
-		 * to GFP_DMA memory; fall back on
-		 * swiotlb_map_single(), which will grab memory from
-		 * the lowest available address range.
+		 * to GFP_DMA memory; fall back on map_single(), which
+		 * will grab memory from the lowest available address range.
 		 */
 		ret = map_single(hwdev, 0, size, DMA_FROM_DEVICE);
 		if (!ret)
@@ -587,7 +591,7 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 		       (unsigned long long)dev_addr);
 
 		/* DMA_TO_DEVICE to avoid memcpy in unmap_single */
-		unmap_single(hwdev, ret, size, DMA_TO_DEVICE);
+		do_unmap_single(hwdev, ret, size, DMA_TO_DEVICE);
 		return NULL;
 	}
 	*dma_handle = dev_addr;
@@ -604,7 +608,7 @@ swiotlb_free_coherent(struct device *hwdev, size_t size, void *vaddr,
 		free_pages((unsigned long) vaddr, get_order(size));
 	else
 		/* DMA_TO_DEVICE to avoid memcpy in unmap_single */
-		unmap_single(hwdev, vaddr, size, DMA_TO_DEVICE);
+		do_unmap_single(hwdev, vaddr, size, DMA_TO_DEVICE);
 }
 EXPORT_SYMBOL(swiotlb_free_coherent);
 
@@ -634,7 +638,7 @@ swiotlb_full(struct device *dev, size_t size, int dir, int do_panic)
  * physical address to use is returned.
  *
  * Once the device is given the dma address, the device owns this memory until
- * either swiotlb_unmap_single or swiotlb_dma_sync_single is performed.
+ * either swiotlb_unmap_page or swiotlb_dma_sync_single is performed.
  */
 dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 			    unsigned long offset, size_t size,
@@ -642,18 +646,17 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 			    struct dma_attrs *attrs)
 {
 	phys_addr_t phys = page_to_phys(page) + offset;
-	void *ptr = page_address(page) + offset;
 	dma_addr_t dev_addr = swiotlb_phys_to_bus(dev, phys);
 	void *map;
 
 	BUG_ON(dir == DMA_NONE);
 	/*
-	 * If the pointer passed in happens to be in the device's DMA window,
+	 * If the address happens to be in the device's DMA window,
 	 * we can safely return the device addr and not worry about bounce
 	 * buffering it.
 	 */
 	if (!address_needs_mapping(dev, dev_addr, size) &&
-	    !range_needs_mapping(virt_to_phys(ptr), size))
+	    !range_needs_mapping(phys, size))
 		return dev_addr;
 
 	/*
@@ -679,23 +682,35 @@ EXPORT_SYMBOL_GPL(swiotlb_map_page);
 
 /*
  * Unmap a single streaming mode DMA translation.  The dma_addr and size must
- * match what was provided for in a previous swiotlb_map_single call.  All
+ * match what was provided for in a previous swiotlb_map_page call.  All
  * other usages are undefined.
  *
  * After this call, reads by the cpu to the buffer are guaranteed to see
  * whatever the device wrote there.
  */
+static void unmap_single(struct device *hwdev, dma_addr_t dev_addr,
+			 size_t size, int dir)
+{
+	char *dma_addr = swiotlb_bus_to_virt(hwdev, dev_addr);
+
+	BUG_ON(dir == DMA_NONE);
+
+	if (is_swiotlb_buffer(dma_addr)) {
+		do_unmap_single(hwdev, dma_addr, size, dir);
+		return;
+	}
+
+	if (dir != DMA_FROM_DEVICE)
+		return;
+
+	dma_mark_clean(dma_addr, size);
+}
+
 void swiotlb_unmap_page(struct device *hwdev, dma_addr_t dev_addr,
 			size_t size, enum dma_data_direction dir,
 			struct dma_attrs *attrs)
 {
-	char *dma_addr = swiotlb_bus_to_virt(dev_addr);
-
-	BUG_ON(dir == DMA_NONE);
-	if (is_swiotlb_buffer(dma_addr))
-		unmap_single(hwdev, dma_addr, size, dir);
-	else if (dir == DMA_FROM_DEVICE)
-		dma_mark_clean(dma_addr, size);
+	unmap_single(hwdev, dev_addr, size, dir);
 }
 EXPORT_SYMBOL_GPL(swiotlb_unmap_page);
 
@@ -703,7 +718,7 @@ EXPORT_SYMBOL_GPL(swiotlb_unmap_page);
  * Make physical memory consistent for a single streaming mode DMA translation
  * after a transfer.
  *
- * If you perform a swiotlb_map_single() but wish to interrogate the buffer
+ * If you perform a swiotlb_map_page() but wish to interrogate the buffer
  * using the cpu, yet do not wish to teardown the dma mapping, you must
  * call this function before doing so.  At the next point you give the dma
  * address back to the card, you must first perform a
@@ -713,13 +728,19 @@ static void
 swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
 		    size_t size, int dir, int target)
 {
-	char *dma_addr = swiotlb_bus_to_virt(dev_addr);
+	char *dma_addr = swiotlb_bus_to_virt(hwdev, dev_addr);
 
 	BUG_ON(dir == DMA_NONE);
-	if (is_swiotlb_buffer(dma_addr))
+
+	if (is_swiotlb_buffer(dma_addr)) {
 		sync_single(hwdev, dma_addr, size, dir, target);
-	else if (dir == DMA_FROM_DEVICE)
-		dma_mark_clean(dma_addr, size);
+		return;
+	}
+
+	if (dir != DMA_FROM_DEVICE)
+		return;
+
+	dma_mark_clean(dma_addr, size);
 }
 
 void
@@ -746,13 +767,7 @@ swiotlb_sync_single_range(struct device *hwdev, dma_addr_t dev_addr,
 			  unsigned long offset, size_t size,
 			  int dir, int target)
 {
-	char *dma_addr = swiotlb_bus_to_virt(dev_addr) + offset;
-
-	BUG_ON(dir == DMA_NONE);
-	if (is_swiotlb_buffer(dma_addr))
-		sync_single(hwdev, dma_addr, size, dir, target);
-	else if (dir == DMA_FROM_DEVICE)
-		dma_mark_clean(dma_addr, size);
+	swiotlb_sync_single(hwdev, dev_addr + offset, size, dir, target);
 }
 
 void
@@ -777,7 +792,7 @@ EXPORT_SYMBOL_GPL(swiotlb_sync_single_range_for_device);
 
 /*
  * Map a set of buffers described by scatterlist in streaming mode for DMA.
- * This is the scatter-gather version of the above swiotlb_map_single
+ * This is the scatter-gather version of the above swiotlb_map_page
  * interface.  Here the scatter gather list elements are each tagged with the
  * appropriate dma address and length.  They are obtained via
  * sg_dma_{address,length}(SG).
@@ -788,7 +803,7 @@ EXPORT_SYMBOL_GPL(swiotlb_sync_single_range_for_device);
  *       The routine returns the number of addr/length pairs actually
  *       used, at most nents.
  *
- * Device ownership issues as mentioned above for swiotlb_map_single are the
+ * Device ownership issues as mentioned above for swiotlb_map_page are the
  * same here.
  */
 int
@@ -836,7 +851,7 @@ EXPORT_SYMBOL(swiotlb_map_sg);
 
 /*
  * Unmap a set of streaming mode DMA translations.  Again, cpu read rules
- * concerning calls here are the same as for swiotlb_unmap_single() above.
+ * concerning calls here are the same as for swiotlb_unmap_page() above.
  */
 void
 swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
@@ -847,13 +862,9 @@ swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 
 	BUG_ON(dir == DMA_NONE);
 
-	for_each_sg(sgl, sg, nelems, i) {
-		if (sg->dma_address != swiotlb_phys_to_bus(hwdev, sg_phys(sg)))
-			unmap_single(hwdev, swiotlb_bus_to_virt(sg->dma_address),
-				     sg->dma_length, dir);
-		else if (dir == DMA_FROM_DEVICE)
-			dma_mark_clean(swiotlb_bus_to_virt(sg->dma_address), sg->dma_length);
-	}
+	for_each_sg(sgl, sg, nelems, i)
+		unmap_single(hwdev, sg->dma_address, sg->dma_length, dir);
+
 }
 EXPORT_SYMBOL(swiotlb_unmap_sg_attrs);
 
@@ -879,15 +890,9 @@ swiotlb_sync_sg(struct device *hwdev, struct scatterlist *sgl,
 	struct scatterlist *sg;
 	int i;
 
-	BUG_ON(dir == DMA_NONE);
-
-	for_each_sg(sgl, sg, nelems, i) {
-		if (sg->dma_address != swiotlb_phys_to_bus(hwdev, sg_phys(sg)))
-			sync_single(hwdev, swiotlb_bus_to_virt(sg->dma_address),
+	for_each_sg(sgl, sg, nelems, i)
+		swiotlb_sync_single(hwdev, sg->dma_address,
 				    sg->dma_length, dir, target);
-		else if (dir == DMA_FROM_DEVICE)
-			dma_mark_clean(swiotlb_bus_to_virt(sg->dma_address), sg->dma_length);
-	}
 }
 
 void
