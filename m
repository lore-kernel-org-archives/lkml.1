Return-Path: <linux-kernel-owner+w=401wt.eu-S1031147AbXEKTus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031147AbXEKTus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763150AbXEKTnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:43:46 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:45984 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030812AbXEKTno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:43:44 -0400
Message-ID: <4644C769.4000605@simon.arlott.org.uk>
Date: Fri, 11 May 2007 20:43:37 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       sparclinux@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] spelling fixes: arch/sparc64/
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Spelling fixes in arch/sparc64/.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 arch/sparc64/kernel/devices.c   |    2 +-
 arch/sparc64/kernel/of_device.c |    4 ++--
 arch/sparc64/kernel/pci_iommu.c |    2 +-
 arch/sparc64/kernel/pci_sun4v.c |    2 +-
 arch/sparc64/kernel/process.c   |    2 +-
 arch/sparc64/kernel/prom.c      |    2 +-
 arch/sparc64/mm/init.c          |    2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/sparc64/kernel/devices.c b/arch/sparc64/kernel/devices.c
index ec10f7e..0e03c8e 100644
--- a/arch/sparc64/kernel/devices.c
+++ b/arch/sparc64/kernel/devices.c
@@ -21,7 +21,7 @@
 #include <asm/timer.h>
 #include <asm/cpudata.h>
 
-/* Used to synchronize acceses to NatSemi SUPER I/O chip configure
+/* Used to synchronize accesses to NatSemi SUPER I/O chip configure
  * operations in asm/ns87303.h
  */
 DEFINE_SPINLOCK(ns87303_lock);
diff --git a/arch/sparc64/kernel/of_device.c b/arch/sparc64/kernel/of_device.c
index 9ac9a30..7455f5d 100644
--- a/arch/sparc64/kernel/of_device.c
+++ b/arch/sparc64/kernel/of_device.c
@@ -596,7 +596,7 @@ static void __init build_device_resources(struct of_device *op,
 	/* Convert to num-entries.  */
 	num_reg /= na + ns;
 
-	/* Prevent overruning the op->resources[] array.  */
+	/* Prevent overrunning the op->resources[] array.  */
 	if (num_reg > PROMREG_MAX) {
 		printk(KERN_WARNING "%s: Too many regs (%d), "
 		       "limiting to %d.\n",
@@ -904,7 +904,7 @@ static struct of_device * __init scan_one_device(struct device_node *dp,
 		op->num_irqs = 0;
 	}
 
-	/* Prevent overruning the op->irqs[] array.  */
+	/* Prevent overrunning the op->irqs[] array.  */
 	if (op->num_irqs > PROMINTR_MAX) {
 		printk(KERN_WARNING "%s: Too many irqs (%d), "
 		       "limiting to %d.\n",
diff --git a/arch/sparc64/kernel/pci_iommu.c b/arch/sparc64/kernel/pci_iommu.c
index dfd6f9f..70d2364 100644
--- a/arch/sparc64/kernel/pci_iommu.c
+++ b/arch/sparc64/kernel/pci_iommu.c
@@ -542,7 +542,7 @@ static inline void fill_sg(iopte_t *iopte, struct scatterlist *sg,
 /* Map a set of buffers described by SGLIST with NELEMS array
  * elements in streaming mode for PCI DMA.
  * When making changes here, inspect the assembly output. I was having
- * hard time to kepp this routine out of using stack slots for holding variables.
+ * hard time to keep this routine out of using stack slots for holding variables.
  */
 static int pci_4u_map_sg(struct pci_dev *pdev, struct scatterlist *sglist, int nelems, int direction)
 {
diff --git a/arch/sparc64/kernel/pci_sun4v.c b/arch/sparc64/kernel/pci_sun4v.c
index 34df404..044e8ec 100644
--- a/arch/sparc64/kernel/pci_sun4v.c
+++ b/arch/sparc64/kernel/pci_sun4v.c
@@ -731,7 +731,7 @@ struct pci_sun4v_msiq_entry {
 
 	u64		msi_address;
 
-	/* The format of this value is message type dependant.
+	/* The format of this value is message type dependent.
 	 * For MSI bits 15:0 are the data from the MSI packet.
 	 * For MSI-X bits 31:0 are the data from the MSI packet.
 	 * For MSG, the message code and message routing code where:
diff --git a/arch/sparc64/kernel/process.c b/arch/sparc64/kernel/process.c
index 8e3c6e4..952762b 100644
--- a/arch/sparc64/kernel/process.c
+++ b/arch/sparc64/kernel/process.c
@@ -677,7 +677,7 @@ int copy_thread(int nr, unsigned long clone_flags, unsigned long sp,
  * NOTE! Only a kernel-only process(ie the swapper or direct descendants
  * who haven't done an "execve()") should use this: it will work within
  * a system call from a "real" process, but the process memory space will
- * not be free'd until both the parent and the child have exited.
+ * not be freed until both the parent and the child have exited.
  */
 pid_t kernel_thread(int (*fn)(void *), void * arg, unsigned long flags)
 {
diff --git a/arch/sparc64/kernel/prom.c b/arch/sparc64/kernel/prom.c
index b7976b1..02830e4 100644
--- a/arch/sparc64/kernel/prom.c
+++ b/arch/sparc64/kernel/prom.c
@@ -899,7 +899,7 @@ static unsigned int fire_irq_build(struct device_node *dp,
 	/* The interrupt map registers do not have an INO field
 	 * like other chips do.  They return zero in the INO
 	 * field, and the interrupt controller number is controlled
-	 * in bits 6 thru 9.  So in order for build_irq() to get
+	 * in bits 6 to 9.  So in order for build_irq() to get
 	 * the INO right we pass it in as part of the fixup
 	 * which will get added to the map register zero value
 	 * read by build_irq().
diff --git a/arch/sparc64/mm/init.c b/arch/sparc64/mm/init.c
index d7004ea..6e5b01d 100644
--- a/arch/sparc64/mm/init.c
+++ b/arch/sparc64/mm/init.c
@@ -1008,7 +1008,7 @@ static unsigned long __init bootmem_init(unsigned long *pages_avail,
 	if (initrd_start) {
 		size = initrd_end - initrd_start;
 
-		/* Resert the initrd image area. */
+		/* Reserve the initrd image area. */
 #ifdef CONFIG_DEBUG_BOOTMEM
 		prom_printf("reserve_bootmem(initrd): base[%llx] size[%lx]\n",
 			initrd_start, initrd_end);
-- 
1.5.0.1

-- 
Simon Arlott
