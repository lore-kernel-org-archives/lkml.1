Return-Path: <linux-kernel-owner+w=401wt.eu-S1757573AbZJaJlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573AbZJaJlZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 05:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757371AbZJaJlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 05:41:22 -0400
Received: from mail-vw0-f192.google.com ([209.85.212.192]:33643 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757497AbZJaJlP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 05:41:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=vbElo43x3NP/ayiINizpNGHp66F/ElOh6yZ2f1ILlBSHx7PTusNnhU1EQtQ07au7Vu
         V+tyWidwkjku72mjfJ+sElfQWm2jjw4CkGB+XSYLgVW3NsYaM6eY1t1guSYyJbI2BYHe
         wb2hk0z1+GaOjOLkX/0/fNFXAL0JBE9aWcvpM=
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Sat, 31 Oct 2009 07:41:00 -0200
Message-ID: <b8bf37780910310241o751ac523i87de85a8fe88481f@mail.gmail.com>
Subject: [PATCH 05/16] trivial: fix assorted "[re|un]mapping" typos
To: trivial@kernel.org, linux list <linux-kernel@vger.kernel.org>
Cc: me <andre.goddard@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9df77a53a0ce5198a2efb06ed91ba11885283a9c Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Date: Fri, 30 Oct 2009 06:36:08 -0200
Subject: [PATCH 05/16] trivial: fix assorted "[re|un]mapping" typos
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>

diff --git a/Documentation/lguest/lguest.c b/Documentation/lguest/lguest.c
index 098de5b..4220851 100644
--- a/Documentation/lguest/lguest.c
+++ b/Documentation/lguest/lguest.c
@@ -304,7 +304,7 @@ static void *map_zeroed_pages(unsigned int num)
 	addr = mmap(NULL, getpagesize() * num,
 		    PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE, fd, 0);
 	if (addr == MAP_FAILED)
-		err(1, "Mmaping %u pages of /dev/zero", num);
+		err(1, "Mmapping %u pages of /dev/zero", num);

 	/*
 	 * One neat mmap feature is that you can close the fd, and it
diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index a6e360d..fc5790d 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -370,7 +370,7 @@ The default is 1 percent.
 mmap_min_addr

 This file indicates the amount of address space  which a user process will
-be restricted from mmaping.  Since kernel null dereference bugs could
+be restricted from mmapping.  Since kernel null dereference bugs could
 accidentally operate based on the information in the first couple of pages
 of memory userspace processes should not be allowed to write to them.  By
 default this value is set to 0 and no protections will be enforced by the
diff --git a/arch/arm/mach-orion5x/pci.c b/arch/arm/mach-orion5x/pci.c
index 36dc541..bdf96eb 100644
--- a/arch/arm/mach-orion5x/pci.c
+++ b/arch/arm/mach-orion5x/pci.c
@@ -463,7 +463,7 @@ static void __init orion5x_setup_pci_wins(struct
mbus_dram_target_info *dram)
 	writel(win_enable, PCI_BAR_ENABLE);

 	/*
-	 * Disable automatic update of address remaping when writing to BARs.
+	 * Disable automatic update of address remapping when writing to BARs.
 	 */
 	orion5x_setbits(PCI_ADDR_DECODE_CTRL, 1);
 }
diff --git a/arch/arm/plat-omap/include/mach/omap16xx.h
b/arch/arm/plat-omap/include/mach/omap16xx.h
index 0e69b50..7560b4d 100644
--- a/arch/arm/plat-omap/include/mach/omap16xx.h
+++ b/arch/arm/plat-omap/include/mach/omap16xx.h
@@ -124,7 +124,7 @@
 #define TIPB_SWITCH_BASE		 (0xfffbc800)
 #define OMAP16XX_MMCSD2_SSW_MPU_CONF	(TIPB_SWITCH_BASE + 0x160)

-/* UART3 Registers Maping through MPU bus */
+/* UART3 Registers Mapping through MPU bus */
 #define UART3_RHR               (OMAP_UART3_BASE + 0)
 #define UART3_THR               (OMAP_UART3_BASE + 0)
 #define UART3_DLL               (OMAP_UART3_BASE + 0)
diff --git a/arch/arm/plat-s3c24xx/include/plat/map.h
b/arch/arm/plat-s3c24xx/include/plat/map.h
index c4d1334..bd534d3 100644
--- a/arch/arm/plat-s3c24xx/include/plat/map.h
+++ b/arch/arm/plat-s3c24xx/include/plat/map.h
@@ -64,7 +64,7 @@
 /* the calculation for the VA of this must ensure that
  * it is the same distance apart from the UART in the
  * phsyical address space, as the initial mapping for the IO
- * is done as a 1:1 maping. This puts it (currently) at
+ * is done as a 1:1 mapping. This puts it (currently) at
  * 0xFA800000, which is not in the way of any current mapping
  * by the base system.
 */
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 87eee07..fb1035c 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1123,7 +1123,7 @@ static int __init acpi_parse_madt_ioapic_entries(void)
 	if (!acpi_sci_override_gsi)
 		acpi_sci_ioapic_setup(acpi_gbl_FADT.sci_interrupt, 0, 0);

-	/* Fill in identity legacy mapings where no override */
+	/* Fill in identity legacy mappings where no override */
 	mp_config_acpi_legacy_irqs();

 	count =
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index ad82ec9..30eff80 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -5,7 +5,7 @@
  *
  *  Added devfs support.
  *    Jan-11-1998, C. Scott Ananian <cananian@alumni.princeton.edu>
- *  Shared /dev/zero mmaping support, Feb 2000, Kanoj Sarcar <kanoj@sgi.com>
+ *  Shared /dev/zero mmapping support, Feb 2000, Kanoj Sarcar <kanoj@sgi.com>
  */

 #include <linux/mm.h>
diff --git a/drivers/char/mspec.c b/drivers/char/mspec.c
index 1997270..ecb89d7 100644
--- a/drivers/char/mspec.c
+++ b/drivers/char/mspec.c
@@ -248,7 +248,7 @@ static const struct vm_operations_struct mspec_vm_ops = {
 /*
  * mspec_mmap
  *
- * Called when mmaping the device.  Initializes the vma with a fault handler
+ * Called when mmapping the device.  Initializes the vma with a fault handler
  * and private data structure necessary to allocate, track, and free the
  * underlying pages.
  */
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index abfc27b..a2a3fa5 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1309,7 +1309,7 @@ out_free_list:
  * i915_gem_release_mmap - remove physical page mappings
  * @obj: obj in question
  *
- * Preserve the reservation of the mmaping with the DRM core code, but
+ * Preserve the reservation of the mmapping with the DRM core code, but
  * relinquish ownership of the pages back to the system.
  *
  * It is vital that we remove the page mapping if we have mapped a tiled
diff --git a/drivers/misc/sgi-gru/grufile.c b/drivers/misc/sgi-gru/grufile.c
index 41c8fe2..ce5eda9 100644
--- a/drivers/misc/sgi-gru/grufile.c
+++ b/drivers/misc/sgi-gru/grufile.c
@@ -92,7 +92,7 @@ static void gru_vma_close(struct vm_area_struct *vma)
 /*
  * gru_file_mmap
  *
- * Called when mmaping the device.  Initializes the vma with a fault handler
+ * Called when mmapping the device.  Initializes the vma with a fault handler
  * and private data structure necessary to allocate, track, and free the
  * underlying pages.
  */
diff --git a/drivers/net/mlx4/en_rx.c b/drivers/net/mlx4/en_rx.c
index 03b781a..829b9ec 100644
--- a/drivers/net/mlx4/en_rx.c
+++ b/drivers/net/mlx4/en_rx.c
@@ -204,7 +204,7 @@ static void mlx4_en_free_rx_desc(struct mlx4_en_priv *priv,
 		en_dbg(DRV, priv, "Freeing fragment:%d\n", nr);
 		dma = be64_to_cpu(rx_desc->data[nr].addr);

-		en_dbg(DRV, priv, "Unmaping buffer at dma:0x%llx\n", (u64) dma);
+		en_dbg(DRV, priv, "Unmapping buffer at dma:0x%llx\n", (u64) dma);
 		pci_unmap_single(mdev->pdev, dma, skb_frags[nr].size,
 				 PCI_DMA_FROMDEVICE);
 		put_page(skb_frags[nr].page);
diff --git a/drivers/net/wireless/ath/ath5k/phy.c
b/drivers/net/wireless/ath/ath5k/phy.c
index 1a039f2..6464e31 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -2675,7 +2675,7 @@ ath5k_setup_channel_powertable(struct ath5k_hw *ah,
 		/* Fill curves in reverse order
 		 * from lower power (max gain)
 		 * to higher power. Use curve -> idx
-		 * backmaping we did on eeprom init */
+		 * backmapping we did on eeprom init */
 		u8 idx = pdg_curve_to_idx[pdg];

 		/* Grab the needed curves by index */
@@ -2777,7 +2777,7 @@ ath5k_setup_channel_powertable(struct ath5k_hw *ah,
 	/* Now we have a set of curves for this
 	 * channel on tmpL (x range is table_max - table_min
 	 * and y values are tmpL[pdg][]) sorted in the same
-	 * order as EEPROM (because we've used the backmaping).
+	 * order as EEPROM (because we've used the backmapping).
 	 * So for RF5112 it's from higher power to lower power
 	 * and for RF2413 it's from lower power to higher power.
 	 * For RF5111 we only have one curve. */
diff --git a/drivers/staging/vt6656/channel.c b/drivers/staging/vt6656/channel.c
index e49796f..f7136b0 100644
--- a/drivers/staging/vt6656/channel.c
+++ b/drivers/staging/vt6656/channel.c
@@ -19,7 +19,7 @@
  *
  * File: channel.c
  *
- * Purpose: Channel number maping
+ * Purpose: Channel number mapping
  *
  * Author: Lucas Lin
  *
diff --git a/drivers/video/console/sticore.c b/drivers/video/console/sticore.c
index 857b366..6468a29 100644
--- a/drivers/video/console/sticore.c
+++ b/drivers/video/console/sticore.c
@@ -436,7 +436,7 @@ sti_init_glob_cfg(struct sti_struct *sti,
 			    (offs < PCI_BASE_ADDRESS_0 ||
 			     offs > PCI_BASE_ADDRESS_5)) {
 				printk (KERN_WARNING
-					"STI pci region maping for region %d (%02x) can't be mapped\n",
+					"STI pci region mapping for region %d (%02x) can't be mapped\n",
 					i,sti->rm_entry[i]);
 				continue;
 			}
diff --git a/drivers/video/tdfxfb.c b/drivers/video/tdfxfb.c
index ff43c88..9805483 100644
--- a/drivers/video/tdfxfb.c
+++ b/drivers/video/tdfxfb.c
@@ -52,7 +52,7 @@
  *
  * 0.1.3 (released 1999-11-02)	added Attila's panning support, code
  *				reorg, hwcursor address page size alignment
- *				(for mmaping both frame buffer and regs),
+ *				(for mmapping both frame buffer and regs),
  *				and my changes to get rid of hardcoded
  *				VGA i/o register locations (uses PCI
  *				configuration info now)
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index b9b3bb5..d15ea17 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -767,7 +767,7 @@ static int load_elf_binary(struct linux_binprm
*bprm, struct pt_regs *regs)
 	
 	current->mm->start_stack = bprm->p;

-	/* Now we do a little grungy work by mmaping the ELF image into
+	/* Now we do a little grungy work by mmapping the ELF image into
 	   the correct location in memory. */
 	for(i = 0, elf_ppnt = elf_phdata;
 	    i < loc->elf_ex.e_phnum; i++, elf_ppnt++) {
diff --git a/fs/cifs/README b/fs/cifs/README
index 79c1a93..a727b7c 100644
--- a/fs/cifs/README
+++ b/fs/cifs/README
@@ -423,7 +423,7 @@ A partial list of the supported mount options follows:
 		source name to use to represent the client netbios machine
 		name when doing the RFC1001 netbios session initialize.
   direct        Do not do inode data caching on files opened on this mount.
-		This precludes mmaping files on this mount. In some cases
+		This precludes mmapping files on this mount. In some cases
 		with fast networks and little or no caching benefits on the
 		client (e.g. when the application is doing large sequential
 		reads bigger than page size without rereading the same data)
diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index 5397396..43179dd 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -399,7 +399,7 @@ static inline void
ntfs_fault_in_pages_readable_iovec(const struct iovec *iov,
  * @cached_page: allocated but as yet unused page
  * @lru_pvec:	lru-buffering pagevec of caller
  *
- * Obtain @nr_pages locked page cache pages from the mapping @maping and
+ * Obtain @nr_pages locked page cache pages from the mapping @mapping and
  * starting at index @index.
  *
  * If a page is newly created, increment its refcount and add it to the
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index dacc641..1ac49fe 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -174,7 +174,7 @@ static void kill_procs_ao(struct list_head
*to_kill, int doit, int trapno,
 	list_for_each_entry_safe (tk, next, to_kill, nd) {
 		if (doit) {
 			/*
-			 * In case something went wrong with munmaping
+			 * In case something went wrong with munmapping
 			 * make sure the process doesn't catch the
 			 * signal and then access the memory. Just kill it.
 			 * the signal handlers
-- 
1.6.5.2.101.gcd0f8
