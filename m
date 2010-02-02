Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab0BCDqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 22:46:16 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:45807 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430Ab0BCDqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 22:46:04 -0500
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Jiri Kosina <trivial@kernel.org>,
       Junio C Hamano <gitster@pobox.com>
Subject: [PATCH 07/11] tree-wide: Fix spelling of 'address'
Date: Wed,  3 Feb 2010 00:48:23 +0800
Message-Id: <1265129307-18201-7-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1265129307-18201-6-git-send-email-daniel@caiaq.de>
References: <1265129307-18201-1-git-send-email-daniel@caiaq.de>
 <1265129307-18201-2-git-send-email-daniel@caiaq.de>
 <1265129307-18201-3-git-send-email-daniel@caiaq.de>
 <1265129307-18201-4-git-send-email-daniel@caiaq.de>
 <1265129307-18201-5-git-send-email-daniel@caiaq.de>
 <1265129307-18201-6-git-send-email-daniel@caiaq.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Jiri Kosina <trivial@kernel.org>
Cc: Junio C Hamano <gitster@pobox.com>
---
 arch/arm/mach-nomadik/board-nhk8815.c         |    2 +-
 arch/arm/mach-u300/core.c                     |    4 ++--
 arch/arm/mach-u300/include/mach/debug-macro.S |    2 +-
 arch/s390/include/asm/cio.h                   |    2 +-
 arch/s390/kernel/sclp.S                       |    2 +-
 arch/x86/crypto/twofish-i586-asm_32.S         |   10 +++++-----
 arch/x86/crypto/twofish-x86_64-asm_64.S       |   20 ++++++++++----------
 arch/x86/kernel/head_64.S                     |    2 +-
 arch/x86/kernel/pci-calgary_64.c              |    2 +-
 arch/xtensa/kernel/entry.S                    |    4 ++--
 drivers/block/drbd/drbd_int.h                 |    2 +-
 drivers/char/applicom.c                       |    2 +-
 drivers/dma/coh901318_lli.h                   |    2 +-
 drivers/gpu/drm/nouveau/nouveau_drv.h         |    2 +-
 drivers/infiniband/hw/ehca/ehca_qes.h         |    4 ++--
 drivers/infiniband/hw/ehca/ehca_reqs.c        |    2 +-
 drivers/media/video/sn9c102/sn9c102_sensor.h  |    2 +-
 drivers/media/video/tea6420.c                 |    2 +-
 drivers/mtd/nand/bcm_umi_nand.c               |    4 ++--
 drivers/mtd/nand/mxc_nand.c                   |    2 +-
 drivers/net/atlx/atl2.h                       |    2 +-
 drivers/net/spider_net.c                      |    4 ++--
 drivers/net/wimax/i2400m/i2400m.h             |    2 +-
 drivers/net/wireless/iwmc3200wifi/lmac.h      |    2 +-
 drivers/video/s1d13xxxfb.c                    |    4 ++--
 include/linux/sched.h                         |    2 +-
 sound/pci/es1968.c                            |    2 +-
 27 files changed, 46 insertions(+), 46 deletions(-)

diff --git a/arch/arm/mach-nomadik/board-nhk8815.c b/arch/arm/mach-nomadik/board-nhk8815.c
index 9438bf6..ab3712c 100644
--- a/arch/arm/mach-nomadik/board-nhk8815.c
+++ b/arch/arm/mach-nomadik/board-nhk8815.c
@@ -38,7 +38,7 @@
 #define SRC_CR_INIT_MASK	0x00007fff
 #define SRC_CR_INIT_VAL		0x2aaa8000
 
-/* These adresses span 16MB, so use three individual pages */
+/* These addresses span 16MB, so use three individual pages */
 static struct resource nhk8815_nand_resources[] = {
 	{
 		.name = "nand_addr",
diff --git a/arch/arm/mach-u300/core.c b/arch/arm/mach-u300/core.c
index 653e25b..d0cb5e9 100644
--- a/arch/arm/mach-u300/core.c
+++ b/arch/arm/mach-u300/core.c
@@ -356,7 +356,7 @@ static struct resource ave_resources[] = {
 	/*
 	 * The AVE3e requires two regions of 256MB that it considers
 	 * "invisible". The hardware will not be able to access these
-	 * adresses, so they should never point to system RAM.
+	 * addresses, so they should never point to system RAM.
 	 */
 	{
 		.name  = "AVE3e Reserved 0",
@@ -571,7 +571,7 @@ static void __init u300_init_check_chip(void)
 /*
  * Some devices and their resources require reserved physical memory from
  * the end of the available RAM. This function traverses the list of devices
- * and assigns actual adresses to these.
+ * and assigns actual addresses to these.
  */
 static void __init u300_assign_physmem(void)
 {
diff --git a/arch/arm/mach-u300/include/mach/debug-macro.S b/arch/arm/mach-u300/include/mach/debug-macro.S
index f3a1cbb..d591fe1 100644
--- a/arch/arm/mach-u300/include/mach/debug-macro.S
+++ b/arch/arm/mach-u300/include/mach/debug-macro.S
@@ -11,7 +11,7 @@
 #include <mach/hardware.h>
 
 	.macro	addruart,rx
-	/* If we move the adress using MMU, use this. */
+	/* If we move the address using MMU, use this. */
 	mrc	p15, 0, \rx, c1, c0
 	tst	\rx, #1			@ MMU enabled?
 	ldreq	\rx,	  = U300_SLOW_PER_PHYS_BASE @ MMU off, physical address
diff --git a/arch/s390/include/asm/cio.h b/arch/s390/include/asm/cio.h
index e85679a..e34347d 100644
--- a/arch/s390/include/asm/cio.h
+++ b/arch/s390/include/asm/cio.h
@@ -20,7 +20,7 @@
 /**
  * struct ccw1 - channel command word
  * @cmd_code: command code
- * @flags: flags, like IDA adressing, etc.
+ * @flags: flags, like IDA addressing, etc.
  * @count: byte count
  * @cda: data address
  *
diff --git a/arch/s390/kernel/sclp.S b/arch/s390/kernel/sclp.S
index e27ca63..27c1a2e 100644
--- a/arch/s390/kernel/sclp.S
+++ b/arch/s390/kernel/sclp.S
@@ -221,7 +221,7 @@ _sclp_print:
 	lh	%r9,0(%r8)			# update sccb length
 	ar	%r9,%r6
 	sth	%r9,0(%r8)
-	ar	%r7,%r6				# update current mto adress
+	ar	%r7,%r6				# update current mto address
 	ltr	%r0,%r0				# more characters?
 	jnz	.LinitmtoS4
 	l	%r2,.LwritedataS4-.LbaseS4(%r13)# write data
diff --git a/arch/x86/crypto/twofish-i586-asm_32.S b/arch/x86/crypto/twofish-i586-asm_32.S
index 39b98ed..575331c 100644
--- a/arch/x86/crypto/twofish-i586-asm_32.S
+++ b/arch/x86/crypto/twofish-i586-asm_32.S
@@ -22,7 +22,7 @@
 
 #include <asm/asm-offsets.h>
 
-/* return adress at 0 */
+/* return address at 0 */
 
 #define in_blk    12  /* input byte array address parameter*/
 #define out_blk   8  /* output byte array address parameter*/
@@ -230,8 +230,8 @@ twofish_enc_blk:
 	push    %edi
 
 	mov	tfm + 16(%esp),	%ebp	/* abuse the base pointer: set new base bointer to the crypto tfm */
-	add	$crypto_tfm_ctx_offset, %ebp	/* ctx adress */
-	mov     in_blk+16(%esp),%edi	/* input adress in edi */
+	add	$crypto_tfm_ctx_offset, %ebp	/* ctx address */
+	mov     in_blk+16(%esp),%edi	/* input address in edi */
 
 	mov	(%edi),		%eax
 	mov	b_offset(%edi),	%ebx
@@ -286,8 +286,8 @@ twofish_dec_blk:
 
 
 	mov	tfm + 16(%esp),	%ebp	/* abuse the base pointer: set new base bointer to the crypto tfm */
-	add	$crypto_tfm_ctx_offset, %ebp	/* ctx adress */
-	mov     in_blk+16(%esp),%edi	/* input adress in edi */
+	add	$crypto_tfm_ctx_offset, %ebp	/* ctx address */
+	mov     in_blk+16(%esp),%edi	/* input address in edi */
 
 	mov	(%edi),		%eax
 	mov	b_offset(%edi),	%ebx
diff --git a/arch/x86/crypto/twofish-x86_64-asm_64.S b/arch/x86/crypto/twofish-x86_64-asm_64.S
index 35974a5..573aa10 100644
--- a/arch/x86/crypto/twofish-x86_64-asm_64.S
+++ b/arch/x86/crypto/twofish-x86_64-asm_64.S
@@ -221,11 +221,11 @@
 twofish_enc_blk:
 	pushq    R1
 
-	/* %rdi contains the crypto tfm adress */
-	/* %rsi contains the output adress */
-	/* %rdx contains the input adress */
-	add	$crypto_tfm_ctx_offset, %rdi	/* set ctx adress */
-	/* ctx adress is moved to free one non-rex register
+	/* %rdi contains the crypto tfm address */
+	/* %rsi contains the output address */
+	/* %rdx contains the input address */
+	add	$crypto_tfm_ctx_offset, %rdi	/* set ctx address */
+	/* ctx address is moved to free one non-rex register
 	as target for the 8bit high operations */
 	mov	%rdi,		%r11
 
@@ -274,11 +274,11 @@ twofish_enc_blk:
 twofish_dec_blk:
 	pushq    R1
 
-	/* %rdi contains the crypto tfm adress */
-	/* %rsi contains the output adress */
-	/* %rdx contains the input adress */
-	add	$crypto_tfm_ctx_offset, %rdi	/* set ctx adress */
-	/* ctx adress is moved to free one non-rex register
+	/* %rdi contains the crypto tfm address */
+	/* %rsi contains the output address */
+	/* %rdx contains the input address */
+	add	$crypto_tfm_ctx_offset, %rdi	/* set ctx address */
+	/* ctx address is moved to free one non-rex register
 	as target for the 8bit high operations */
 	mov	%rdi,		%r11
 
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 2d8b503..3d1e6f1 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -27,7 +27,7 @@
 #define GET_CR2_INTO_RCX movq %cr2, %rcx
 #endif
 
-/* we are not able to switch in one step to the final KERNEL ADRESS SPACE
+/* we are not able to switch in one step to the final KERNEL ADDRESS SPACE
  * because we need identity-mapped pages.
  *
  */
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 2bbde60..fb99f7e 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -1309,7 +1309,7 @@ static void calgary_init_bitmap_from_tce_table(struct iommu_table *tbl)
 /*
  * get_tce_space_from_tar():
  * Function for kdump case. Get the tce tables from first kernel
- * by reading the contents of the base adress register of calgary iommu
+ * by reading the contents of the base address register of calgary iommu
  */
 static void __init get_tce_space_from_tar(void)
 {
diff --git a/arch/xtensa/kernel/entry.S b/arch/xtensa/kernel/entry.S
index 80d24c4..77fc9f6 100644
--- a/arch/xtensa/kernel/entry.S
+++ b/arch/xtensa/kernel/entry.S
@@ -104,7 +104,7 @@
  *   excsave has been restored, and
  *   stack pointer (a1) has been set.
  *
- * Note: _user_exception might be at an odd adress. Don't use call0..call12
+ * Note: _user_exception might be at an odd address. Don't use call0..call12
  */
 
 ENTRY(user_exception)
@@ -244,7 +244,7 @@ _user_exception:
  *   excsave has been restored, and
  *   stack pointer (a1) has been set.
  *
- * Note: _kernel_exception might be at an odd adress. Don't use call0..call12
+ * Note: _kernel_exception might be at an odd address. Don't use call0..call12
  */
 
 ENTRY(kernel_exception)
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 2bf3a6e..8e149de 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -95,7 +95,7 @@ extern char usermode_helper[];
 
 /* All EEs on the free list should have ID_VACANT (== 0)
  * freshly allocated EEs get !ID_VACANT (== 1)
- * so if it says "cannot dereference null pointer at adress 0x00000001",
+ * so if it says "cannot dereference null pointer at address 0x00000001",
  * it is most likely one of these :( */
 
 #define ID_IN_SYNC      (4711ULL)
diff --git a/drivers/char/applicom.c b/drivers/char/applicom.c
index fe2cb2f..a7424bf 100644
--- a/drivers/char/applicom.c
+++ b/drivers/char/applicom.c
@@ -14,7 +14,7 @@
 /* et passe en argument a acinit, mais est scrute sur le bus pour s'adapter  */
 /* au nombre de cartes presentes sur le bus. IOCL code 6 affichait V2.4.3    */
 /* F.LAFORSE 28/11/95 creation de fichiers acXX.o avec les differentes       */
-/* adresses de base des cartes, IOCTL 6 plus complet                         */
+/* addresses de base des cartes, IOCTL 6 plus complet                         */
 /* J.PAGET le 19/08/96 copie de la version V2.6 en V2.8.0 sans modification  */
 /* de code autre que le texte V2.6.1 en V2.8.0                               */
 /*****************************************************************************/
diff --git a/drivers/dma/coh901318_lli.h b/drivers/dma/coh901318_lli.h
index 7bf713b..7a5c809 100644
--- a/drivers/dma/coh901318_lli.h
+++ b/drivers/dma/coh901318_lli.h
@@ -30,7 +30,7 @@ struct device;
  * @pool: pool handle
  * @dev: dma device
  * @lli_nbr: number of lli:s in the pool
- * @algin: adress alignemtn of lli:s
+ * @algin: address alignemtn of lli:s
  * returns 0 on success otherwise none zero
  */
 int coh901318_pool_create(struct coh901318_pool *pool,
diff --git a/drivers/gpu/drm/nouveau/nouveau_drv.h b/drivers/gpu/drm/nouveau/nouveau_drv.h
index 6b96904..2366405 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drv.h
+++ b/drivers/gpu/drm/nouveau/nouveau_drv.h
@@ -544,7 +544,7 @@ struct drm_nouveau_private {
 	uint32_t ramro_offset;
 	uint32_t ramro_size;
 
-	/* base physical adresses */
+	/* base physical addresses */
 	uint64_t fb_phys;
 	uint64_t fb_available_size;
 	uint64_t fb_mappable_pages;
diff --git a/drivers/infiniband/hw/ehca/ehca_qes.h b/drivers/infiniband/hw/ehca/ehca_qes.h
index 5d28e3e..90c4efa 100644
--- a/drivers/infiniband/hw/ehca/ehca_qes.h
+++ b/drivers/infiniband/hw/ehca/ehca_qes.h
@@ -46,7 +46,7 @@
 
 #include "ehca_tools.h"
 
-/* virtual scatter gather entry to specify remote adresses with length */
+/* virtual scatter gather entry to specify remote addresses with length */
 struct ehca_vsgentry {
 	u64 vaddr;
 	u32 lkey;
@@ -148,7 +148,7 @@ struct ehca_wqe {
 	u32 immediate_data;
 	union {
 		struct {
-			u64 remote_virtual_adress;
+			u64 remote_virtual_address;
 			u32 rkey;
 			u32 reserved;
 			u64 atomic_1st_op_dma_len;
diff --git a/drivers/infiniband/hw/ehca/ehca_reqs.c b/drivers/infiniband/hw/ehca/ehca_reqs.c
index e3ec7fd..9a3fbfc 100644
--- a/drivers/infiniband/hw/ehca/ehca_reqs.c
+++ b/drivers/infiniband/hw/ehca/ehca_reqs.c
@@ -269,7 +269,7 @@ static inline int ehca_write_swqe(struct ehca_qp *qp,
 		/* no break is intentional here */
 	case IB_QPT_RC:
 		/* TODO: atomic not implemented */
-		wqe_p->u.nud.remote_virtual_adress =
+		wqe_p->u.nud.remote_virtual_address =
 			send_wr->wr.rdma.remote_addr;
 		wqe_p->u.nud.rkey = send_wr->wr.rdma.rkey;
 
diff --git a/drivers/media/video/sn9c102/sn9c102_sensor.h b/drivers/media/video/sn9c102/sn9c102_sensor.h
index 4af7382..494957b 100644
--- a/drivers/media/video/sn9c102/sn9c102_sensor.h
+++ b/drivers/media/video/sn9c102/sn9c102_sensor.h
@@ -120,7 +120,7 @@ extern int sn9c102_write_regs(struct sn9c102_device*, const u8 valreg[][2],
 /*
    Write multiple registers with constant values. For example:
    sn9c102_write_const_regs(cam, {0x00, 0x14}, {0x60, 0x17}, {0x0f, 0x18});
-   Register adresses must be < 256.
+   Register addresses must be < 256.
 */
 #define sn9c102_write_const_regs(sn9c102_device, data...)                     \
 	({ static const u8 _valreg[][2] = {data};                             \
diff --git a/drivers/media/video/tea6420.c b/drivers/media/video/tea6420.c
index 0446524..6bf6bc7 100644
--- a/drivers/media/video/tea6420.c
+++ b/drivers/media/video/tea6420.c
@@ -6,7 +6,7 @@
 
     The tea6420 is a bus controlled audio-matrix with 5 stereo inputs,
     4 stereo outputs and gain control for each output.
-    It is cascadable, i.e. it can be found at the adresses 0x98
+    It is cascadable, i.e. it can be found at the addresses 0x98
     and 0x9a on the i2c-bus.
 
     For detailed informations download the specifications directly
diff --git a/drivers/mtd/nand/bcm_umi_nand.c b/drivers/mtd/nand/bcm_umi_nand.c
index 087bcd7..7d1cca7 100644
--- a/drivers/mtd/nand/bcm_umi_nand.c
+++ b/drivers/mtd/nand/bcm_umi_nand.c
@@ -381,7 +381,7 @@ static int __devinit bcm_umi_nand_probe(struct platform_device *pdev)
 	if (!r)
 		return -ENXIO;
 
-	/* map physical adress */
+	/* map physical address */
 	bcm_umi_io_base = ioremap(r->start, r->end - r->start + 1);
 
 	if (!bcm_umi_io_base) {
@@ -525,7 +525,7 @@ static int bcm_umi_nand_remove(struct platform_device *pdev)
 	/* Release resources, unregister device */
 	nand_release(board_mtd);
 
-	/* unmap physical adress */
+	/* unmap physical address */
 	iounmap(bcm_umi_io_base);
 
 	/* Free the MTD device structure */
diff --git a/drivers/mtd/nand/mxc_nand.c b/drivers/mtd/nand/mxc_nand.c
index 45dec57..b2900d8 100644
--- a/drivers/mtd/nand/mxc_nand.c
+++ b/drivers/mtd/nand/mxc_nand.c
@@ -507,7 +507,7 @@ static void mxc_do_addr_cycle(struct mtd_info *mtd, int column, int page_addr)
 		 * MXC NANDFC can only perform full page+spare or
 		 * spare-only read/write.  When the upper layers
 		 * layers perform a read/write buf operation,
-		 * we will used the saved column adress to index into
+		 * we will used the saved column address to index into
 		 * the full page.
 		 */
 		send_addr(host, 0, page_addr == -1);
diff --git a/drivers/net/atlx/atl2.h b/drivers/net/atlx/atl2.h
index d918bbe..927e4de 100644
--- a/drivers/net/atlx/atl2.h
+++ b/drivers/net/atlx/atl2.h
@@ -442,7 +442,7 @@ struct atl2_hw {
 struct atl2_ring_header {
     /* pointer to the descriptor ring memory */
     void *desc;
-    /* physical adress of the descriptor ring */
+    /* physical address of the descriptor ring */
     dma_addr_t dma;
     /* length of descriptor ring in bytes */
     unsigned int size;
diff --git a/drivers/net/spider_net.c b/drivers/net/spider_net.c
index 2185248..839b1f0 100644
--- a/drivers/net/spider_net.c
+++ b/drivers/net/spider_net.c
@@ -474,7 +474,7 @@ spider_net_prepare_rx_descr(struct spider_net_card *card,
  * spider_net_enable_rxchtails - sets RX dmac chain tail addresses
  * @card: card structure
  *
- * spider_net_enable_rxchtails sets the RX DMAC chain tail adresses in the
+ * spider_net_enable_rxchtails sets the RX DMAC chain tail addresses in the
  * chip by writing to the appropriate register. DMA is enabled in
  * spider_net_enable_rxdmac.
  */
@@ -1820,7 +1820,7 @@ spider_net_enable_card(struct spider_net_card *card)
 
 	spider_net_write_reg(card, SPIDER_NET_ECMODE, SPIDER_NET_ECMODE_VALUE);
 
-	/* set chain tail adress for RX chains and
+	/* set chain tail address for RX chains and
 	 * enable DMA */
 	spider_net_enable_rxchtails(card);
 	spider_net_enable_rxdmac(card);
diff --git a/drivers/net/wimax/i2400m/i2400m.h b/drivers/net/wimax/i2400m/i2400m.h
index 04df9bb..820b128 100644
--- a/drivers/net/wimax/i2400m/i2400m.h
+++ b/drivers/net/wimax/i2400m/i2400m.h
@@ -627,7 +627,7 @@ enum i2400m_bm_cmd_flags {
  * @I2400M_BRI_NO_REBOOT: Do not reboot the device and proceed
  *     directly to wait for a reboot barker from the device.
  * @I2400M_BRI_MAC_REINIT: We need to reinitialize the boot
- *     rom after reading the MAC adress. This is quite a dirty hack,
+ *     rom after reading the MAC address. This is quite a dirty hack,
  *     if you ask me -- the device requires the bootrom to be
  *     intialized after reading the MAC address.
  */
diff --git a/drivers/net/wireless/iwmc3200wifi/lmac.h b/drivers/net/wireless/iwmc3200wifi/lmac.h
index a3a79b5..a855a99 100644
--- a/drivers/net/wireless/iwmc3200wifi/lmac.h
+++ b/drivers/net/wireless/iwmc3200wifi/lmac.h
@@ -262,7 +262,7 @@ struct iwm_ct_kill_cfg_cmd {
 
 /* Power Management */
 #define POWER_TABLE_CMD			0x77
-#define SAVE_RESTORE_ADRESS_CMD		0x78
+#define SAVE_RESTORE_ADDRESS_CMD		0x78
 #define REPLY_WATERMARK_CMD		0x79
 #define PM_DEBUG_STATISTIC_NOTIFIC	0x7B
 #define PD_FLUSH_N_NOTIFICATION		0x7C
diff --git a/drivers/video/s1d13xxxfb.c b/drivers/video/s1d13xxxfb.c
index 0deb0a8..7b63429 100644
--- a/drivers/video/s1d13xxxfb.c
+++ b/drivers/video/s1d13xxxfb.c
@@ -517,12 +517,12 @@ s1d13xxxfb_bitblt_copyarea(struct fb_info *info, const struct fb_copyarea *area)
 		src = (sy * stride) + (bpp * sx);
 	}
 
-	/* set source adress */
+	/* set source address */
 	s1d13xxxfb_writereg(info->par, S1DREG_BBLT_SRC_START0, (src & 0xff));
 	s1d13xxxfb_writereg(info->par, S1DREG_BBLT_SRC_START1, (src >> 8) & 0x00ff);
 	s1d13xxxfb_writereg(info->par, S1DREG_BBLT_SRC_START2, (src >> 16) & 0x00ff);
 
-	/* set destination adress */
+	/* set destination address */
 	s1d13xxxfb_writereg(info->par, S1DREG_BBLT_DST_START0, (dst & 0xff));
 	s1d13xxxfb_writereg(info->par, S1DREG_BBLT_DST_START1, (dst >> 8) & 0x00ff);
 	s1d13xxxfb_writereg(info->par, S1DREG_BBLT_DST_START2, (dst >> 16) & 0x00ff);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index abdfacc..a70957b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1533,7 +1533,7 @@ struct task_struct {
 
 	struct list_head	*scm_work_list;
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-	/* Index of current stored adress in ret_stack */
+	/* Index of current stored address in ret_stack */
 	int curr_ret_stack;
 	/* Stack of return addresses for return function tracing */
 	struct ftrace_ret_stack	*ret_stack;
diff --git a/sound/pci/es1968.c b/sound/pci/es1968.c
index a11f453..39cc3d2 100644
--- a/sound/pci/es1968.c
+++ b/sound/pci/es1968.c
@@ -180,7 +180,7 @@ MODULE_PARM_DESC(joystick, "Enable joystick.");
 
 #define ESS_DISABLE_AUDIO	0x8000
 #define ESS_ENABLE_SERIAL_IRQ	0x4000
-#define IO_ADRESS_ALIAS		0x0020
+#define IO_ADDRESS_ALIAS		0x0020
 #define MPU401_IRQ_ENABLE	0x0010
 #define MPU401_IO_ENABLE	0x0008
 #define GAME_IO_ENABLE		0x0004
-- 
1.6.3.3

