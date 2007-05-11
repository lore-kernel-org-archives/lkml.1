Return-Path: <linux-kernel-owner+w=401wt.eu-S1031562AbXEKTxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031562AbXEKTxn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030459AbXEKTor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:44:47 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:46661 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762296AbXEKToo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:44:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=arlott.org;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:X-Enigmail-Version:OpenPGP:Content-Type:Content-Transfer-Encoding;
	b=HUR55AjHgihGsOLPnjwcDvaWTf9OlTX/JcSRQiweIv9zoJJL7X+YAqEFneZnRlGvVwgYWMGt2xBKVVmHrdHwqq0l9BOvwfZtzXrSv75AZ7OoFqS91MBu6illFTYkrmFs;
Message-ID: <4644C7A4.6000008@simon.arlott.org.uk>
Date: Fri, 11 May 2007 20:44:36 +0100
From: Simon Arlott <simon@arlott.org>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trivial@kernel.org
Subject: [PATCH] spelling fixes: mm/
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Spelling fixes in mm/.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 mm/filemap.h        |    2 +-
 mm/hugetlb.c        |    2 +-
 mm/memory.c         |    2 +-
 mm/memory_hotplug.c |    2 +-
 mm/mempool.c        |    2 +-
 mm/page-writeback.c |    2 +-
 mm/page_alloc.c     |    8 ++++----
 mm/prio_tree.c      |    2 +-
 mm/readahead.c      |    8 ++++----
 mm/slab.c           |    6 +++---
 mm/slub.c           |    2 +-
 mm/sparse.c         |    4 ++--
 mm/swap.c           |    2 +-
 mm/vmalloc.c        |    6 +++---
 mm/vmscan.c         |    2 +-
 15 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/mm/filemap.h b/mm/filemap.h
index c2bff04..bfa76e1 100644
--- a/mm/filemap.h
+++ b/mm/filemap.h
@@ -22,7 +22,7 @@ __filemap_copy_from_user_iovec_inatomic(char *vaddr,
 
 /*
  * Copy as much as we can into the page and return the number of bytes which
- * were sucessfully copied.  If a fault is encountered then clear the page
+ * were successfully copied.  If a fault is encountered then clear the page
  * out to (offset+bytes) and return the number of bytes which were copied.
  *
  * NOTE: For this to work reliably we really want copy_from_user_inatomic_nocache
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index eb7180d..f74f432 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -743,7 +743,7 @@ static long region_chg(struct list_head *head, long f, long t)
 
 	/* If we are below the current region then a new region is required.
 	 * Subtle, allocate a new region at the position but make it zero
-	 * size such that we can guarentee to record the reservation. */
+	 * size such that we can guarantee to record the reservation. */
 	if (&rg->link == head || t < rg->from) {
 		nrg = kmalloc(sizeof(*nrg), GFP_KERNEL);
 		if (nrg == 0)
diff --git a/mm/memory.c b/mm/memory.c
index 1d647ab..eaa3ddb 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2783,7 +2783,7 @@ int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, in
 		return 0;
 
 	down_read(&mm->mmap_sem);
-	/* ignore errors, just check how much was sucessfully transfered */
+	/* ignore errors, just check how much was successfully transferred */
 	while (len) {
 		int bytes, ret, offset;
 		void *maddr;
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 8427912..bcd9841 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -118,7 +118,7 @@ int __add_pages(struct zone *zone, unsigned long phys_start_pfn,
 		err = __add_section(zone, i << PFN_SECTION_SHIFT);
 
 		/*
-		 * EEXIST is finally dealed with by ioresource collision
+		 * EEXIST is finally dealt with by ioresource collision
 		 * check. see add_memory() => register_memory_resource()
 		 * Warning will be printed if there is collision.
 		 */
diff --git a/mm/mempool.c b/mm/mempool.c
index cc1ca86..37570cb 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -297,7 +297,7 @@ EXPORT_SYMBOL(mempool_free_slab);
 
 /*
  * A commonly used alloc and free fn that kmalloc/kfrees the amount of memory
- * specfied by pool_data
+ * specified by pool_data
  */
 void *mempool_kmalloc(gfp_t gfp_mask, void *pool_data)
 {
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 63cd888..059d56e 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -790,7 +790,7 @@ int __set_page_dirty_no_writeback(struct page *page)
  * mapping is pinned by the vma's ->vm_file reference.
  *
  * We take care to handle the case where the page was truncated from the
- * mapping by re-checking page_mapping() insode tree_lock.
+ * mapping by re-checking page_mapping() inside tree_lock.
  */
 int __set_page_dirty_nobuffers(struct page *page)
 {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ae96dd8..e3699e8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -107,7 +107,7 @@ static unsigned long __meminitdata dma_reserve;
 
 #ifdef CONFIG_ARCH_POPULATES_NODE_MAP
   /*
-   * MAX_ACTIVE_REGIONS determines the maxmimum number of distinct
+   * MAX_ACTIVE_REGIONS determines the maximum number of distinct
    * ranges of memory (RAM) that may be registered with add_active_range().
    * Ranges passed to add_active_range() will be merged if possible
    * so the number of times add_active_range() can be called is
@@ -1031,7 +1031,7 @@ int zone_watermark_ok(struct zone *z, int order, unsigned long mark,
  * skip over zones that are not allowed by the cpuset, or that have
  * been recently (in last second) found to be nearly full.  See further
  * comments in mmzone.h.  Reduces cache footprint of zonelist scans
- * that have to skip over alot of full or unallowed zones.
+ * that have to skip over a lot of full or unallowed zones.
  *
  * If the zonelist cache is present in the passed in zonelist, then
  * returns a pointer to the allowed node mask (either the current
@@ -1852,7 +1852,7 @@ void __meminit build_all_zonelists(void)
 		__build_all_zonelists(NULL);
 		cpuset_init_current_mems_allowed();
 	} else {
-		/* we have to stop all cpus to guaranntee there is no user
+		/* we have to stop all cpus to guarantee there is no user
 		   of zonelist */
 		stop_machine_run(__build_all_zonelists, NULL, NR_CPUS);
 		/* cpuset refresh routine should be here */
@@ -2266,7 +2266,7 @@ static int __meminit first_active_region_index_in_nid(int nid)
 
 /*
  * Basic iterator support. Return the next active range of PFNs for a node
- * Note: nid == MAX_NUMNODES returns next region regardles of node
+ * Note: nid == MAX_NUMNODES returns next region regardless of node
  */
 static int __meminit next_active_region_index_in_nid(int index, int nid)
 {
diff --git a/mm/prio_tree.c b/mm/prio_tree.c
index b4e76c2..603ae98 100644
--- a/mm/prio_tree.c
+++ b/mm/prio_tree.c
@@ -34,7 +34,7 @@
  * Radix priority search tree for address_space->i_mmap
  *
  * For each vma that map a unique set of file pages i.e., unique [radix_index,
- * heap_index] value, we have a corresponing priority search tree node. If
+ * heap_index] value, we have a corresponding priority search tree node. If
  * multiple vmas have identical [radix_index, heap_index] value, then one of
  * them is used as a tree node and others are stored in a vm_set list. The tree
  * node points to the first vma (head) of the list using vm_set.head.
diff --git a/mm/readahead.c b/mm/readahead.c
index 9861e88..974fc90 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -96,7 +96,7 @@ static unsigned long get_init_ra_size(unsigned long size, unsigned long max)
 
 /*
  * Set the new window size, this is called only when I/O is to be submitted,
- * not for each call to readahead.  If a cache miss occured, reduce next I/O
+ * not for each call to readahead.  If a cache miss occurred, reduce next I/O
  * size, else increase depending on how close to max we are.
  */
 static inline unsigned long get_next_ra_size(struct file_ra_state *ra)
@@ -235,7 +235,7 @@ out:
  *
  * A `readahead hit' occurs when a read request is made against a page which is
  * the next sequential page. Ahead window calculations are done only when it
- * is time to submit a new IO.  The code ramps up the size agressively at first,
+ * is time to submit a new IO.  The code ramps up the size aggressively at first,
  * but slow down as it approaches max_readhead.
  *
  * Any seek/ramdom IO will result in readahead being turned off.  It will resume
@@ -501,7 +501,7 @@ page_cache_readahead(struct address_space *mapping, struct file_ra_state *ra,
 		/*
 		 * If the request size is larger than our max readahead, we
 		 * at least want to be sure that we get 2 IOs in flight and
-		 * we know that we will definitly need the new I/O.
+		 * we know that we will definitely need the new I/O.
 		 * once we do this, subsequent calls should be able to overlap
 		 * IOs,* thus preventing stalls. so issue the ahead window
 		 * immediately.
@@ -526,7 +526,7 @@ page_cache_readahead(struct address_space *mapping, struct file_ra_state *ra,
 
 	/*
 	 * If we get here we are doing sequential IO and this was not the first
-	 * occurence (ie we have an existing window)
+	 * occurrence (ie we have an existing window)
 	 */
 	if (ra->ahead_start == 0) {	 /* no ahead window yet */
 		if (!make_ahead_window(mapping, filp, ra, 0))
diff --git a/mm/slab.c b/mm/slab.c
index 944b205..f19adfd 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -26,7 +26,7 @@
  * initialized objects.
  *
  * This means, that your constructor is used only for newly allocated
- * slabs and you must pass objects with the same intializations to
+ * slabs and you must pass objects with the same initializations to
  * kmem_cache_free.
  *
  * Each cache can only support one memory type (GFP_DMA, GFP_HIGHMEM,
@@ -1301,7 +1301,7 @@ static int __cpuinit cpuup_callback(struct notifier_block *nfb,
 		 * structure is usually allocated from kmem_cache_create() and
 		 * gets destroyed at kmem_cache_destroy().
 		 */
-		/* fall thru */
+		/* fall through */
 #endif
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
@@ -3856,7 +3856,7 @@ const char *kmem_cache_name(struct kmem_cache *cachep)
 EXPORT_SYMBOL_GPL(kmem_cache_name);
 
 /*
- * This initializes kmem_list3 or resizes varioius caches for all nodes.
+ * This initializes kmem_list3 or resizes various caches for all nodes.
  */
 static int alloc_kmemlist(struct kmem_cache *cachep)
 {
diff --git a/mm/slub.c b/mm/slub.c
index b39c8a6..355651b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1780,7 +1780,7 @@ static struct kmem_cache_node * __init early_kmem_cache_node_alloc(gfp_t gfpflag
 	BUG_ON(kmalloc_caches->size < sizeof(struct kmem_cache_node));
 
 	page = new_slab(kmalloc_caches, gfpflags | GFP_THISNODE, node);
-	/* new_slab() disables interupts */
+	/* new_slab() disables interrupts */
 	local_irq_enable();
 
 	BUG_ON(!page);
diff --git a/mm/sparse.c b/mm/sparse.c
index 6f3fff9..46c9fa8 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -101,7 +101,7 @@ static inline int sparse_index_init(unsigned long section_nr, int nid)
 
 /*
  * Although written for the SPARSEMEM_EXTREME case, this happens
- * to also work for the flat array case becase
+ * to also work for the flat array case because
  * NR_SECTION_ROOTS==NR_MEM_SECTIONS.
  */
 int __section_nr(struct mem_section* ms)
@@ -157,7 +157,7 @@ void __init memory_present(int nid, unsigned long start, unsigned long end)
 }
 
 /*
- * Only used by the i386 NUMA architecures, but relatively
+ * Only used by the i386 NUMA architectures, but relatively
  * generic code.
  */
 unsigned long __init node_memmap_size_bytes(int nid, unsigned long start_pfn,
diff --git a/mm/swap.c b/mm/swap.c
index d3cb966..0c09a51 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -5,7 +5,7 @@
  */
 
 /*
- * This file contains the default values for the opereation of the
+ * This file contains the default values for the operation of the
  * Linux VM subsystem. Fine-tuning documentation can be found in
  * Documentation/sysctl/vm.txt.
  * Started 18.12.91
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index faa2a52..1de2e9e 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -239,7 +239,7 @@ struct vm_struct *__get_vm_area(unsigned long size, unsigned long flags,
 }
 
 /**
- *	get_vm_area  -  reserve a contingous kernel virtual area
+ *	get_vm_area  -  reserve a contiguous kernel virtual area
  *	@size:		size of the area
  *	@flags:		%VM_IOREMAP for I/O mappings or VM_ALLOC
  *
@@ -295,7 +295,7 @@ found:
 }
 
 /**
- *	remove_vm_area  -  find and remove a contingous kernel virtual area
+ *	remove_vm_area  -  find and remove a continuous kernel virtual area
  *	@addr:		base address
  *
  *	Search for the kernel VM area starting at @addr, and remove it.
@@ -356,7 +356,7 @@ void __vunmap(void *addr, int deallocate_pages)
  *	vfree  -  release memory allocated by vmalloc()
  *	@addr:		memory base address
  *
- *	Free the virtually contiguous memory area starting at @addr, as
+ *	Free the virtually continuous memory area starting at @addr, as
  *	obtained from vmalloc(), vmalloc_32() or __vmalloc(). If @addr is
  *	NULL, no operation is performed.
  *
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 1be5a63..6381692 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -159,7 +159,7 @@ EXPORT_SYMBOL(remove_shrinker);
  * percentages of the lru and ageable caches.  This should balance the seeks
  * generated by these structures.
  *
- * If the vm encounted mapped pages on the LRU it increase the pressure on
+ * If the vm encountered mapped pages on the LRU it increase the pressure on
  * slab to avoid swapping.
  *
  * We do weird things to avoid (scanned*seeks*entries) overflowing 32 bits.
-- 
1.5.0.1

-- 
Simon Arlott
