Return-Path: <linux-kernel-owner+w=401wt.eu-S1757860AbZF1SpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860AbZF1SpW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 14:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbZF1SpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 14:45:09 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1606 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439AbZF1SpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 14:45:03 -0400
Subject: [PATCH] Remove unnecessary semicolons
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org, trivial@kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <20090628.113325.244931913.davem@davemloft.net>
References: <cover.1246173664.git.joe@perches.com>
	 <1ee6dd55768ebbbeb505c47e2944b683633be630.1246173680.git.joe@perches.com>
	 <20090628185102.47663e61@lxorguk.ukuu.org.uk>
	 <20090628.113325.244931913.davem@davemloft.net>
Content-Type: text/plain
Date: Sun, 28 Jun 2009 11:44:38 -0700
Message-Id: <1246214678.13673.31.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-28 at 11:33 -0700, David Miller wrote:
> I'm all for this, to be honest, and I'm very
> much for rolling this into one single patch too :)

Here's just the single one, but doesn't a patch
that span multiple arches make it a bit more
troublesome for the arch maintainers?

Signed-off-by: Joe Perches <joe@perches.com>

 arch/arm/mach-at91/at91cap9_devices.c              |    2 +-
 arch/arm/mach-at91/at91sam9rl_devices.c            |    2 +-
 arch/arm/mach-w90x900/w90p910.c                    |    2 +-
 arch/arm/plat-mxc/irq.c                            |    2 +-
 arch/ia64/kernel/esi.c                             |    2 +-
 arch/ia64/kvm/process.c                            |    6 +++---
 arch/ia64/kvm/vcpu.c                               |    2 +-
 arch/ia64/kvm/vtlb.c                               |    4 ++--
 arch/m68knommu/kernel/time.c                       |    2 +-
 arch/mips/kernel/vpe.c                             |    2 +-
 arch/powerpc/mm/tlb_hash64.c                       |    2 +-
 arch/powerpc/oprofile/cell/vma_map.c               |    2 +-
 arch/powerpc/platforms/powermac/cpufreq_64.c       |    2 +-
 arch/powerpc/platforms/powermac/pic.c              |    2 +-
 arch/powerpc/platforms/ps3/system-bus.c            |    1 -
 arch/powerpc/sysdev/fsl_rio.c                      |    2 +-
 arch/powerpc/sysdev/ppc4xx_pci.c                   |    4 ++--
 arch/s390/hypfs/inode.c                            |    2 +-
 arch/s390/kvm/interrupt.c                          |    2 +-
 arch/sh/boards/mach-se/7206/io.c                   |    2 +-
 arch/sparc/kernel/irq_64.c                         |    2 +-
 arch/um/drivers/net_kern.c                         |    2 +-
 arch/x86/kernel/ds.c                               |    2 +-
 drivers/ata/pata_octeon_cf.c                       |    2 +-
 drivers/ata/sata_inic162x.c                        |    2 +-
 drivers/block/DAC960.c                             |    4 ++--
 drivers/block/swim3.c                              |    2 +-
 drivers/char/epca.c                                |    2 +-
 drivers/dma/dmatest.c                              |    2 +-
 drivers/dma/fsldma.c                               |    2 +-
 drivers/dma/mv_xor.c                               |    2 +-
 drivers/gpu/drm/i915/intel_dp.c                    |    2 +-
 drivers/gpu/drm/radeon/r300.c                      |    4 ++--
 drivers/hwmon/sht15.c                              |    2 +-
 drivers/ide/ide-probe.c                            |    2 +-
 drivers/ide/umc8672.c                              |    4 ++--
 drivers/isdn/capi/capiutil.c                       |    2 +-
 drivers/macintosh/rack-meter.c                     |    2 +-
 drivers/media/dvb/b2c2/flexcop-fe-tuner.c          |    2 +-
 drivers/media/dvb/dvb-usb/dib0700_devices.c        |    2 +-
 drivers/media/dvb/frontends/cx24123.c              |    2 +-
 drivers/media/dvb/frontends/dib0070.c              |    2 +-
 drivers/media/dvb/frontends/stv0900_sw.c           |    2 +-
 drivers/media/video/cx18/cx18-fileops.c            |    2 +-
 drivers/media/video/cx231xx/cx231xx-video.c        |    4 ++--
 drivers/media/video/cx23885/cx23885.h              |    2 +-
 drivers/media/video/ivtv/ivtv-driver.c             |    2 +-
 drivers/mfd/twl4030-irq.c                          |    2 +-
 drivers/mmc/host/imxmmc.c                          |    2 +-
 drivers/net/arcnet/arc-rawmode.c                   |    1 -
 drivers/net/arcnet/capmode.c                       |    1 -
 drivers/net/bnx2x_link.c                           |    2 +-
 drivers/net/gianfar_ethtool.c                      |    2 +-
 drivers/net/ibm_newemac/core.c                     |    8 ++++----
 drivers/net/igb/igb_main.c                         |    4 ++--
 drivers/net/ll_temac_main.c                        |    2 +-
 drivers/net/ni52.c                                 |    4 ++--
 drivers/net/qlge/qlge_main.c                       |    4 ++--
 drivers/net/skfp/pcmplc.c                          |    2 +-
 drivers/net/skfp/pmf.c                             |    8 ++++----
 drivers/net/skge.c                                 |    2 +-
 drivers/net/sky2.c                                 |    2 +-
 drivers/net/vxge/vxge-config.h                     |    2 +-
 drivers/net/vxge/vxge-main.c                       |    2 +-
 drivers/net/wireless/ath/ath9k/eeprom.c            |    2 --
 drivers/net/wireless/ath/ath9k/hw.c                |    2 +-
 drivers/net/wireless/iwmc3200wifi/rx.c             |    8 ++++----
 drivers/pci/pcie/aer/ecrc.c                        |    2 +-
 drivers/pcmcia/pcmcia_resource.c                   |    2 +-
 drivers/regulator/pcf50633-regulator.c             |    2 +-
 drivers/rtc/rtc-omap.c                             |    2 +-
 drivers/s390/block/dasd_eckd.c                     |    2 +-
 drivers/s390/net/netiucv.c                         |    2 +-
 drivers/s390/scsi/zfcp_scsi.c                      |    2 +-
 drivers/scsi/bnx2i/bnx2i_hwi.c                     |    2 +-
 drivers/scsi/lpfc/lpfc_ct.c                        |    2 +-
 drivers/spi/omap_uwire.c                           |    2 +-
 drivers/spi/spi_s3c24xx.c                          |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Tor.c        |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1500.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1516.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3501.c      |    2 +-
 drivers/staging/comedi/drivers/amplc_pci230.c      |    2 +-
 drivers/staging/comedi/drivers/comedi_bond.c       |    2 +-
 drivers/staging/go7007/go7007-driver.c             |    2 +-
 drivers/staging/otus/80211core/cmmsta.c            |    2 +-
 drivers/staging/otus/hal/hpmain.c                  |    2 +-
 drivers/staging/rt2860/common/cmm_data_2860.c      |    8 ++++----
 drivers/staging/rt2860/rt_linux.c                  |    2 +-
 drivers/staging/rt2860/rtmp.h                      |    3 +--
 drivers/staging/rt2860/sta/aironet.c               |    2 +-
 drivers/staging/rtl8187se/r8185b_init.c            |    2 +-
 drivers/staging/rtl8192su/ieee80211/ieee80211_tx.c |    2 +-
 drivers/staging/rtl8192su/r8192U_core.c            |    6 +++---
 drivers/staging/rtl8192su/r819xU_phy.c             |    2 +-
 drivers/staging/vt6655/card.c                      |    2 +-
 drivers/staging/vt6655/iwctl.c                     |    2 +-
 drivers/staging/vt6655/wpa2.c                      |    4 ++--
 drivers/usb/class/cdc-wdm.c                        |    2 --
 drivers/usb/serial/spcp8x5.c                       |    2 +-
 drivers/uwb/i1480/i1480u-wlp/netdev.c              |    2 +-
 drivers/video/cfbcopyarea.c                        |    2 +-
 drivers/video/imxfb.c                              |    2 +-
 drivers/video/s3c2410fb.c                          |    2 +-
 drivers/watchdog/bcm47xx_wdt.c                     |    2 +-
 drivers/xen/balloon.c                              |    2 +-
 fs/autofs/dirhash.c                                |    2 +-
 fs/btrfs/tree-log.c                                |    2 +-
 fs/cifs/cifs_dfs_ref.c                             |    2 +-
 fs/ext4/mballoc.c                                  |    2 +-
 fs/nfs/callback_xdr.c                              |    2 +-
 fs/ocfs2/quota_global.c                            |    2 +-
 include/scsi/fc/fc_fc2.h                           |    3 +--
 kernel/trace/trace_hw_branches.c                   |    2 +-
 net/wireless/wext-compat.c                         |    2 +-
 sound/oss/sys_timer.c                              |    3 ---
 sound/soc/codecs/wm9081.c                          |    2 +-
 sound/soc/pxa/pxa-ssp.c                            |    2 +-
 sound/soc/s3c24xx/s3c24xx_uda134x.c                |    2 +-
 119 files changed, 139 insertions(+), 151 deletions(-)

diff --git a/arch/arm/mach-at91/at91cap9_devices.c b/arch/arm/mach-at91/at91cap9_devices.c
index 412aa49..799c11e 100644
--- a/arch/arm/mach-at91/at91cap9_devices.c
+++ b/arch/arm/mach-at91/at91cap9_devices.c
@@ -171,7 +171,7 @@ void __init at91_add_device_usba(struct usba_platform_data *data)
 	 */
 	usba_udc_data.pdata.vbus_pin = -EINVAL;
 	usba_udc_data.pdata.num_ep = ARRAY_SIZE(usba_udc_ep);
-	memcpy(usba_udc_data.ep, usba_udc_ep, sizeof(usba_udc_ep));;
+	memcpy(usba_udc_data.ep, usba_udc_ep, sizeof(usba_udc_ep));
 
 	if (data && data->vbus_pin > 0) {
 		at91_set_gpio_input(data->vbus_pin, 0);
diff --git a/arch/arm/mach-at91/at91sam9rl_devices.c b/arch/arm/mach-at91/at91sam9rl_devices.c
index 7281865..e87237b 100644
--- a/arch/arm/mach-at91/at91sam9rl_devices.c
+++ b/arch/arm/mach-at91/at91sam9rl_devices.c
@@ -99,7 +99,7 @@ void __init at91_add_device_usba(struct usba_platform_data *data)
 	 */
 	usba_udc_data.pdata.vbus_pin = -EINVAL;
 	usba_udc_data.pdata.num_ep = ARRAY_SIZE(usba_udc_ep);
-	memcpy(usba_udc_data.ep, usba_udc_ep, sizeof(usba_udc_ep));;
+	memcpy(usba_udc_data.ep, usba_udc_ep, sizeof(usba_udc_ep));
 
 	if (data && data->vbus_pin > 0) {
 		at91_set_gpio_input(data->vbus_pin, 0);
diff --git a/arch/arm/mach-w90x900/w90p910.c b/arch/arm/mach-w90x900/w90p910.c
index 1c97e49..0399a24 100644
--- a/arch/arm/mach-w90x900/w90p910.c
+++ b/arch/arm/mach-w90x900/w90p910.c
@@ -62,7 +62,7 @@ static DEFINE_CLK(atapi, 6);
 static DEFINE_CLK(emc, 7);
 static DEFINE_CLK(usbd, 8);
 static DEFINE_CLK(usbh, 9);
-static DEFINE_CLK(g2d, 10);;
+static DEFINE_CLK(g2d, 10);
 static DEFINE_CLK(pwm, 18);
 static DEFINE_CLK(ps2, 24);
 static DEFINE_CLK(kpi, 25);
diff --git a/arch/arm/plat-mxc/irq.c b/arch/arm/plat-mxc/irq.c
index 8aee763..c2106d5 100644
--- a/arch/arm/plat-mxc/irq.c
+++ b/arch/arm/plat-mxc/irq.c
@@ -53,7 +53,7 @@ int imx_irq_set_priority(unsigned char irq, unsigned char prio)
 	unsigned int mask = 0x0F << irq % 8 * 4;
 
 	if (irq >= MXC_INTERNAL_IRQS)
-		return -EINVAL;;
+		return -EINVAL;
 
 	temp = __raw_readl(avic_base + AVIC_NIPRIORITY(irq / 8));
 	temp &= ~mask;
diff --git a/arch/ia64/kernel/esi.c b/arch/ia64/kernel/esi.c
index ebf4e98..d5764a3 100644
--- a/arch/ia64/kernel/esi.c
+++ b/arch/ia64/kernel/esi.c
@@ -65,7 +65,7 @@ static int __init esi_init (void)
 	}
 
 	if (!esi)
-		return -ENODEV;;
+		return -ENODEV;
 
 	systab = __va(esi);
 
diff --git a/arch/ia64/kvm/process.c b/arch/ia64/kvm/process.c
index a8f84da..bb862fb 100644
--- a/arch/ia64/kvm/process.c
+++ b/arch/ia64/kvm/process.c
@@ -130,7 +130,7 @@ static void collect_interruption(struct kvm_vcpu *vcpu)
 	if (vdcr & IA64_DCR_PP) {
 		vpsr |= IA64_PSR_PP;
 	} else {
-		vpsr &= ~IA64_PSR_PP;;
+		vpsr &= ~IA64_PSR_PP;
 	}
 
 	vcpu_set_psr(vcpu, vpsr);
@@ -594,11 +594,11 @@ static void set_pal_call_data(struct kvm_vcpu *vcpu)
 		p->u.pal_data.gr30 = vcpu_get_gr(vcpu, 30);
 		break;
 	case PAL_BRAND_INFO:
-		p->u.pal_data.gr29 = gr29;;
+		p->u.pal_data.gr29 = gr29;
 		p->u.pal_data.gr30 = kvm_trans_pal_call_args(vcpu, gr30);
 		break;
 	default:
-		p->u.pal_data.gr29 = gr29;;
+		p->u.pal_data.gr29 = gr29;
 		p->u.pal_data.gr30 = vcpu_get_gr(vcpu, 30);
 	}
 	p->u.pal_data.gr28 = gr28;
diff --git a/arch/ia64/kvm/vcpu.c b/arch/ia64/kvm/vcpu.c
index a2c6c15..46b02cb 100644
--- a/arch/ia64/kvm/vcpu.c
+++ b/arch/ia64/kvm/vcpu.c
@@ -406,7 +406,7 @@ void getreg(unsigned long regnum, unsigned long *val,
 	 * Now look at registers in [0-31] range and init correct UNAT
 	 */
 	addr = (unsigned long)regs;
-	unat = &regs->eml_unat;;
+	unat = &regs->eml_unat;
 
 	addr += gr_info[regnum];
 
diff --git a/arch/ia64/kvm/vtlb.c b/arch/ia64/kvm/vtlb.c
index 4290a42..20b3852 100644
--- a/arch/ia64/kvm/vtlb.c
+++ b/arch/ia64/kvm/vtlb.c
@@ -135,7 +135,7 @@ struct thash_data *__vtr_lookup(struct kvm_vcpu *vcpu, u64 va, int type)
 	u64 rid;
 
 	rid = vcpu_get_rr(vcpu, va);
-	rid = rid & RR_RID_MASK;;
+	rid = rid & RR_RID_MASK;
 	if (type == D_TLB) {
 		if (vcpu_quick_region_check(vcpu->arch.dtr_regions, va)) {
 			for (trp = (struct thash_data *)&vcpu->arch.dtrs, i = 0;
@@ -518,7 +518,7 @@ struct thash_data *vtlb_lookup(struct kvm_vcpu *v, u64 va, int is_data)
 
 	struct thash_cb *hcb = &v->arch.vtlb;
 
-	cch = __vtr_lookup(v, va, is_data);;
+	cch = __vtr_lookup(v, va, is_data);
 	if (cch)
 		return cch;
 
diff --git a/arch/m68knommu/kernel/time.c b/arch/m68knommu/kernel/time.c
index d182b2f..c2aa717 100644
--- a/arch/m68knommu/kernel/time.c
+++ b/arch/m68knommu/kernel/time.c
@@ -69,7 +69,7 @@ static unsigned long read_rtc_mmss(void)
 	if ((year += 1900) < 1970)
 		year += 100;
 
-	return  mktime(year, mon, day, hour, min, sec);;
+	return  mktime(year, mon, day, hour, min, sec);
 }
 
 unsigned long read_persistent_clock(void)
diff --git a/arch/mips/kernel/vpe.c b/arch/mips/kernel/vpe.c
index 3ca5f42..07b9ec2 100644
--- a/arch/mips/kernel/vpe.c
+++ b/arch/mips/kernel/vpe.c
@@ -1387,7 +1387,7 @@ static ssize_t store_ntcs(struct device *dev, struct device_attribute *attr,
 	return len;
 
 out_einval:
-	return -EINVAL;;
+	return -EINVAL;
 }
 
 static struct device_attribute vpe_class_attributes[] = {
diff --git a/arch/powerpc/mm/tlb_hash64.c b/arch/powerpc/mm/tlb_hash64.c
index 1be1b5e..937eb90 100644
--- a/arch/powerpc/mm/tlb_hash64.c
+++ b/arch/powerpc/mm/tlb_hash64.c
@@ -72,7 +72,7 @@ void hpte_need_flush(struct mm_struct *mm, unsigned long addr,
 	 */
 	if (huge) {
 #ifdef CONFIG_HUGETLB_PAGE
-		psize = get_slice_psize(mm, addr);;
+		psize = get_slice_psize(mm, addr);
 #else
 		BUG();
 		psize = pte_pagesize_index(mm, addr, pte); /* shutup gcc */
diff --git a/arch/powerpc/oprofile/cell/vma_map.c b/arch/powerpc/oprofile/cell/vma_map.c
index 258fa44..c591339 100644
--- a/arch/powerpc/oprofile/cell/vma_map.c
+++ b/arch/powerpc/oprofile/cell/vma_map.c
@@ -185,7 +185,7 @@ struct vma_to_fileoffset_map *create_vma_map(const struct spu *aSpu,
 			goto fail;
 
 		if (shdr_str.sh_type != SHT_STRTAB)
-			goto fail;;
+			goto fail;
 
 		for (j = 0; j < shdr.sh_size / sizeof (sym); j++) {
 			if (copy_from_user(&sym, spu_elf_start +
diff --git a/arch/powerpc/platforms/powermac/cpufreq_64.c b/arch/powerpc/platforms/powermac/cpufreq_64.c
index 22ecfbe..708c751 100644
--- a/arch/powerpc/platforms/powermac/cpufreq_64.c
+++ b/arch/powerpc/platforms/powermac/cpufreq_64.c
@@ -251,7 +251,7 @@ static void g5_pfunc_switch_volt(int speed_mode)
 static struct pmf_function *pfunc_cpu_setfreq_high;
 static struct pmf_function *pfunc_cpu_setfreq_low;
 static struct pmf_function *pfunc_cpu_getfreq;
-static struct pmf_function *pfunc_slewing_done;;
+static struct pmf_function *pfunc_slewing_done;
 
 static int g5_pfunc_switch_freq(int speed_mode)
 {
diff --git a/arch/powerpc/platforms/powermac/pic.c b/arch/powerpc/platforms/powermac/pic.c
index dce7363..d212006 100644
--- a/arch/powerpc/platforms/powermac/pic.c
+++ b/arch/powerpc/platforms/powermac/pic.c
@@ -609,7 +609,7 @@ static int pmacpic_find_viaint(void)
 	np = of_find_node_by_name(NULL, "via-pmu");
 	if (np == NULL)
 		goto not_found;
-	viaint = irq_of_parse_and_map(np, 0);;
+	viaint = irq_of_parse_and_map(np, 0);
 
 not_found:
 #endif /* CONFIG_ADB_PMU */
diff --git a/arch/powerpc/platforms/ps3/system-bus.c b/arch/powerpc/platforms/ps3/system-bus.c
index 9fead0f..3f763c5 100644
--- a/arch/powerpc/platforms/ps3/system-bus.c
+++ b/arch/powerpc/platforms/ps3/system-bus.c
@@ -284,7 +284,6 @@ static int ps3_sb_free_mmio_region(struct ps3_mmio_region *r)
 	int result;
 
 	dump_mmio_region(r);
-;
 	result = lv1_unmap_device_mmio_region(r->dev->bus_id, r->dev->dev_id,
 		r->lpar_addr);
 
diff --git a/arch/powerpc/sysdev/fsl_rio.c b/arch/powerpc/sysdev/fsl_rio.c
index 39db9d1..cbb3bed 100644
--- a/arch/powerpc/sysdev/fsl_rio.c
+++ b/arch/powerpc/sysdev/fsl_rio.c
@@ -965,7 +965,7 @@ static inline void fsl_rio_info(struct device *dev, u32 ccsr)
 			break;
 		default:
 			str = "Unknown";
-			break;;
+			break;
 		}
 		dev_info(dev, "Hardware port width: %s\n", str);
 
diff --git a/arch/powerpc/sysdev/ppc4xx_pci.c b/arch/powerpc/sysdev/ppc4xx_pci.c
index daefc93..6ff9d71 100644
--- a/arch/powerpc/sysdev/ppc4xx_pci.c
+++ b/arch/powerpc/sysdev/ppc4xx_pci.c
@@ -1531,7 +1531,7 @@ static void __init ppc4xx_configure_pciex_PIMs(struct ppc4xx_pciex_port *port,
 		 */
 
 		/* Calculate window size */
-		sa = (0xffffffffffffffffull << ilog2(ep_size));;
+		sa = (0xffffffffffffffffull << ilog2(ep_size));
 
 		/* Setup BAR0 */
 		out_le32(mbase + PECFG_BAR0HMPA, RES_TO_U32_HIGH(sa));
@@ -1550,7 +1550,7 @@ static void __init ppc4xx_configure_pciex_PIMs(struct ppc4xx_pciex_port *port,
 		out_le32(mbase + PCI_BASE_ADDRESS_1, RES_TO_U32_HIGH(ep_addr));
 	} else {
 		/* Calculate window size */
-		sa = (0xffffffffffffffffull << ilog2(size));;
+		sa = (0xffffffffffffffffull << ilog2(size));
 		if (res->flags & IORESOURCE_PREFETCH)
 			sa |= 0x8;
 
diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index 5a805df..ad0a1dd 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -500,7 +500,7 @@ static int __init hypfs_init(void)
 	}
 	s390_kobj = kobject_create_and_add("s390", hypervisor_kobj);
 	if (!s390_kobj) {
-		rc = -ENOMEM;;
+		rc = -ENOMEM;
 		goto fail_sysfs;
 	}
 	rc = register_filesystem(&hypfs_type);
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index f04f530..dc94adb 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -484,7 +484,7 @@ int kvm_s390_inject_program_int(struct kvm_vcpu *vcpu, u16 code)
 	if (!inti)
 		return -ENOMEM;
 
-	inti->type = KVM_S390_PROGRAM_INT;;
+	inti->type = KVM_S390_PROGRAM_INT;
 	inti->pgm.code = code;
 
 	VCPU_EVENT(vcpu, 3, "inject: program check %d (from kernel)", code);
diff --git a/arch/sh/boards/mach-se/7206/io.c b/arch/sh/boards/mach-se/7206/io.c
index 9c3a332..1804556 100644
--- a/arch/sh/boards/mach-se/7206/io.c
+++ b/arch/sh/boards/mach-se/7206/io.c
@@ -50,7 +50,7 @@ unsigned char se7206_inb_p(unsigned long port)
 
 unsigned short se7206_inw(unsigned long port)
 {
-	return *port2adr(port);;
+	return *port2adr(port);
 }
 
 void se7206_outb(unsigned char value, unsigned long port)
diff --git a/arch/sparc/kernel/irq_64.c b/arch/sparc/kernel/irq_64.c
index f0ee790..ea183b9 100644
--- a/arch/sparc/kernel/irq_64.c
+++ b/arch/sparc/kernel/irq_64.c
@@ -229,7 +229,7 @@ static unsigned int sun4u_compute_tid(unsigned long imap, unsigned long cpuid)
 				tid = ((a << IMAP_AID_SHIFT) |
 				       (n << IMAP_NID_SHIFT));
 				tid &= (IMAP_AID_SAFARI |
-					IMAP_NID_SAFARI);;
+					IMAP_NID_SAFARI);
 			}
 		} else {
 			tid = cpuid << IMAP_TID_SHIFT;
diff --git a/arch/um/drivers/net_kern.c b/arch/um/drivers/net_kern.c
index 3b44b47..5072d4b 100644
--- a/arch/um/drivers/net_kern.c
+++ b/arch/um/drivers/net_kern.c
@@ -533,7 +533,7 @@ static int eth_parse(char *str, int *index_out, char **str_out,
 		     char **error_out)
 {
 	char *end;
-	int n, err = -EINVAL;;
+	int n, err = -EINVAL;
 
 	n = simple_strtoul(str, &end, 0);
 	if (end == str) {
diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
index 48bfe13..8025e2d 100644
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -517,7 +517,7 @@ static inline unsigned long bts_get(const char *base, enum bts_field field)
 
 static inline void bts_set(char *base, enum bts_field field, unsigned long val)
 {
-	base += (ds_cfg.sizeof_ptr_field * field);;
+	base += (ds_cfg.sizeof_ptr_field * field);
 	(*(unsigned long *)base) = val;
 }
 
diff --git a/drivers/ata/pata_octeon_cf.c b/drivers/ata/pata_octeon_cf.c
index 8d9343a..fc50dec 100644
--- a/drivers/ata/pata_octeon_cf.c
+++ b/drivers/ata/pata_octeon_cf.c
@@ -213,7 +213,7 @@ static void octeon_cf_set_dmamode(struct ata_port *ap, struct ata_device *dev)
 	 * This is tI, C.F. spec. says 0, but Sony CF card requires
 	 * more, we use 20 nS.
 	 */
-	dma_tim.s.dmack_s = ns_to_tim_reg(tim_mult, 20);;
+	dma_tim.s.dmack_s = ns_to_tim_reg(tim_mult, 20);
 	dma_tim.s.dmack_h = ns_to_tim_reg(tim_mult, dma_ackh);
 
 	dma_tim.s.dmarq = dma_arq;
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index 8d890cc..4406902 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -405,7 +405,7 @@ static irqreturn_t inic_interrupt(int irq, void *dev_instance)
 	struct ata_host *host = dev_instance;
 	struct inic_host_priv *hpriv = host->private_data;
 	u16 host_irq_stat;
-	int i, handled = 0;;
+	int i, handled = 0;
 
 	host_irq_stat = readw(hpriv->mmio_base + HOST_IRQ_STAT);
 
diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index 668dc23..c0e3449 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -6652,7 +6652,7 @@ static long DAC960_gam_ioctl(struct file *file, unsigned int Request,
 	else ErrorCode = get_user(ControllerNumber,
 			     &UserSpaceControllerInfo->ControllerNumber);
 	if (ErrorCode != 0)
-		break;;
+		break;
 	ErrorCode = -ENXIO;
 	if (ControllerNumber < 0 ||
 	    ControllerNumber > DAC960_ControllerCount - 1) {
@@ -6660,7 +6660,7 @@ static long DAC960_gam_ioctl(struct file *file, unsigned int Request,
 	}
 	Controller = DAC960_Controllers[ControllerNumber];
 	if (Controller == NULL)
-		break;;
+		break;
 	memset(&ControllerInfo, 0, sizeof(DAC960_ControllerInfo_T));
 	ControllerInfo.ControllerNumber = ControllerNumber;
 	ControllerInfo.FirmwareType = Controller->FirmwareType;
diff --git a/drivers/block/swim3.c b/drivers/block/swim3.c
index 80df93e..572ec61 100644
--- a/drivers/block/swim3.c
+++ b/drivers/block/swim3.c
@@ -1062,7 +1062,7 @@ static int swim3_add_device(struct macio_dev *mdev, int index)
 		goto out_release;
 	}
 	fs->swim3_intr = macio_irq(mdev, 0);
-	fs->dma_intr = macio_irq(mdev, 1);;
+	fs->dma_intr = macio_irq(mdev, 1);
 	fs->cur_cyl = -1;
 	fs->cur_sector = -1;
 	fs->secpercyl = 36;
diff --git a/drivers/char/epca.c b/drivers/char/epca.c
index abef1f7..3e68ce9 100644
--- a/drivers/char/epca.c
+++ b/drivers/char/epca.c
@@ -2238,7 +2238,7 @@ static void do_softint(struct work_struct *work)
 	struct channel *ch = container_of(work, struct channel, tqueue);
 	/* Called in response to a modem change event */
 	if (ch && ch->magic == EPCA_MAGIC) {
-		struct tty_struct *tty = tty_port_tty_get(&ch->port);;
+		struct tty_struct *tty = tty_port_tty_get(&ch->port);
 
 		if (tty && tty->driver_data) {
 			if (test_and_clear_bit(EPCA_EVENT_HANGUP, &ch->event)) {
diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index fb7da51..cec1ec0 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -114,7 +114,7 @@ static void dmatest_init_srcs(u8 **bufs, unsigned int start, unsigned int len)
 			buf[i] = PATTERN_SRC | (~i & PATTERN_COUNT_MASK);
 		for ( ; i < start + len; i++)
 			buf[i] = PATTERN_SRC | PATTERN_COPY
-				| (~i & PATTERN_COUNT_MASK);;
+				| (~i & PATTERN_COUNT_MASK);
 		for ( ; i < test_buf_size; i++)
 			buf[i] = PATTERN_SRC | (~i & PATTERN_COUNT_MASK);
 		buf++;
diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index f18d1bd..71ce8ed 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -136,7 +136,7 @@ static int dma_is_idle(struct fsl_dma_chan *fsl_chan)
 
 static void dma_start(struct fsl_dma_chan *fsl_chan)
 {
-	u32 mr_set = 0;;
+	u32 mr_set = 0;
 
 	if (fsl_chan->feature & FSL_DMA_CHAN_PAUSE_EXT) {
 		DMA_OUT(fsl_chan, &fsl_chan->reg_base->bcr, 0, 32);
diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index ddab94f..3f23eab 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -1176,7 +1176,7 @@ static int __devinit mv_xor_probe(struct platform_device *pdev)
 	if (dma_has_cap(DMA_MEMSET, dma_dev->cap_mask))
 		dma_dev->device_prep_dma_memset = mv_xor_prep_dma_memset;
 	if (dma_has_cap(DMA_XOR, dma_dev->cap_mask)) {
-		dma_dev->max_xor = 8;                  ;
+		dma_dev->max_xor = 8;
 		dma_dev->device_prep_dma_xor = mv_xor_prep_dma_xor;
 	}
 
diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 8f8d37d..5359f59 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -211,7 +211,7 @@ intel_dp_aux_ch(struct intel_output *intel_output,
 	for (try = 0; try < 5; try++) {
 		/* Load the send data into the aux channel data registers */
 		for (i = 0; i < send_bytes; i += 4) {
-			uint32_t    d = pack_aux(send + i, send_bytes - i);;
+			uint32_t    d = pack_aux(send + i, send_bytes - i);
 	
 			I915_WRITE(ch_data + i, d);
 		}
diff --git a/drivers/gpu/drm/radeon/r300.c b/drivers/gpu/drm/radeon/r300.c
index e2ed5bc..e471a9c 100644
--- a/drivers/gpu/drm/radeon/r300.c
+++ b/drivers/gpu/drm/radeon/r300.c
@@ -1276,11 +1276,11 @@ static int r300_packet0_check(struct radeon_cs_parser *p,
 	case 0x443C:
 		/* TX_FILTER0_[0-15] */
 		i = (reg - 0x4400) >> 2;
-		tmp = ib_chunk->kdata[idx] & 0x7;;
+		tmp = ib_chunk->kdata[idx] & 0x7;
 		if (tmp == 2 || tmp == 4 || tmp == 6) {
 			track->textures[i].roundup_w = false;
 		}
-		tmp = (ib_chunk->kdata[idx] >> 3) & 0x7;;
+		tmp = (ib_chunk->kdata[idx] >> 3) & 0x7;
 		if (tmp == 2 || tmp == 4 || tmp == 6) {
 			track->textures[i].roundup_h = false;
 		}
diff --git a/drivers/hwmon/sht15.c b/drivers/hwmon/sht15.c
index 56cd600..6290a25 100644
--- a/drivers/hwmon/sht15.c
+++ b/drivers/hwmon/sht15.c
@@ -257,7 +257,7 @@ static inline int sht15_update_single_val(struct sht15_data *data,
 				 (data->flag == SHT15_READING_NOTHING),
 				 msecs_to_jiffies(timeout_msecs));
 	if (ret == 0) {/* timeout occurred */
-		disable_irq_nosync(gpio_to_irq(data->pdata->gpio_data));;
+		disable_irq_nosync(gpio_to_irq(data->pdata->gpio_data));
 		sht15_connection_reset(data);
 		return -ETIME;
 	}
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 1bb106f..20120fd 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1201,7 +1201,7 @@ static int ide_find_port_slot(const struct ide_port_info *d)
 {
 	int idx = -ENOENT;
 	u8 bootable = (d && (d->host_flags & IDE_HFLAG_NON_BOOTABLE)) ? 0 : 1;
-	u8 i = (d && (d->host_flags & IDE_HFLAG_QD_2ND_PORT)) ? 1 : 0;;
+	u8 i = (d && (d->host_flags & IDE_HFLAG_QD_2ND_PORT)) ? 1 : 0;
 
 	/*
 	 * Claim an unassigned slot.
diff --git a/drivers/ide/umc8672.c b/drivers/ide/umc8672.c
index 0608d41..60f936e 100644
--- a/drivers/ide/umc8672.c
+++ b/drivers/ide/umc8672.c
@@ -170,9 +170,9 @@ static int __init umc8672_init(void)
 		goto out;
 
 	if (umc8672_probe() == 0)
-		return 0;;
+		return 0;
 out:
-	return -ENODEV;;
+	return -ENODEV;
 }
 
 module_init(umc8672_init);
diff --git a/drivers/isdn/capi/capiutil.c b/drivers/isdn/capi/capiutil.c
index 16f2e46..26626ee 100644
--- a/drivers/isdn/capi/capiutil.c
+++ b/drivers/isdn/capi/capiutil.c
@@ -1019,7 +1019,7 @@ int __init cdebug_init(void)
 	if (!g_debbuf->buf) {
 		kfree(g_cmsg);
 		kfree(g_debbuf);
-		return -ENOMEM;;
+		return -ENOMEM;
 	}
 	g_debbuf->size = CDEBUG_GSIZE;
 	g_debbuf->buf[0] = 0;
diff --git a/drivers/macintosh/rack-meter.c b/drivers/macintosh/rack-meter.c
index a98ab72..93fb320 100644
--- a/drivers/macintosh/rack-meter.c
+++ b/drivers/macintosh/rack-meter.c
@@ -274,7 +274,7 @@ static void __devinit rackmeter_init_cpu_sniffer(struct rackmeter *rm)
 
 		if (cpu > 1)
 			continue;
-		rcpu = &rm->cpu[cpu];;
+		rcpu = &rm->cpu[cpu];
 		rcpu->prev_idle = get_cpu_idle_time(cpu);
 		rcpu->prev_wall = jiffies64_to_cputime64(get_jiffies_64());
 		schedule_delayed_work_on(cpu, &rm->cpu[cpu].sniffer,
diff --git a/drivers/media/dvb/b2c2/flexcop-fe-tuner.c b/drivers/media/dvb/b2c2/flexcop-fe-tuner.c
index efb4a6c..bc37018 100644
--- a/drivers/media/dvb/b2c2/flexcop-fe-tuner.c
+++ b/drivers/media/dvb/b2c2/flexcop-fe-tuner.c
@@ -410,7 +410,7 @@ static int skystar2_rev28_attach(struct flexcop_device *fc,
 	if (!fc->fe)
 		return 0;
 
-	i2c_tuner = cx24123_get_tuner_i2c_adapter(fc->fe);;
+	i2c_tuner = cx24123_get_tuner_i2c_adapter(fc->fe);
 	if (!i2c_tuner)
 		return 0;
 
diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index 818b2ab..49fd781 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -310,7 +310,7 @@ static int stk7700d_tuner_attach(struct dvb_usb_adapter *adap)
 	struct i2c_adapter *tun_i2c;
 	tun_i2c = dib7000p_get_i2c_master(adap->fe, DIBX000_I2C_INTERFACE_TUNER, 1);
 	return dvb_attach(mt2266_attach, adap->fe, tun_i2c,
-		&stk7700d_mt2266_config[adap->id]) == NULL ? -ENODEV : 0;;
+		&stk7700d_mt2266_config[adap->id]) == NULL ? -ENODEV : 0;
 }
 
 /* STK7700-PH: Digital/Analog Hybrid Tuner, e.h. Cinergy HT USB HE */
diff --git a/drivers/media/dvb/frontends/cx24123.c b/drivers/media/dvb/frontends/cx24123.c
index 0592f04..d8f921b 100644
--- a/drivers/media/dvb/frontends/cx24123.c
+++ b/drivers/media/dvb/frontends/cx24123.c
@@ -458,7 +458,7 @@ static int cx24123_set_symbolrate(struct cx24123_state *state, u32 srate)
 	/*  check if symbol rate is within limits */
 	if ((srate > state->frontend.ops.info.symbol_rate_max) ||
 	    (srate < state->frontend.ops.info.symbol_rate_min))
-		return -EOPNOTSUPP;;
+		return -EOPNOTSUPP;
 
 	/* choose the sampling rate high enough for the required operation,
 	   while optimizing the power consumed by the demodulator */
diff --git a/drivers/media/dvb/frontends/dib0070.c b/drivers/media/dvb/frontends/dib0070.c
index fe895bf..da92cbe 100644
--- a/drivers/media/dvb/frontends/dib0070.c
+++ b/drivers/media/dvb/frontends/dib0070.c
@@ -167,7 +167,7 @@ static int dib0070_tune_digital(struct dvb_frontend *fe, struct dvb_frontend_par
 					break;
 				case BAND_SBAND:
 					LO4_SET_VCO_HFDIV(lo4, 0, 0);
-					LO4_SET_CTRIM(lo4, 1);;
+					LO4_SET_CTRIM(lo4, 1);
 					c = 1;
 					break;
 				case BAND_UHF:
diff --git a/drivers/media/dvb/frontends/stv0900_sw.c b/drivers/media/dvb/frontends/stv0900_sw.c
index a5a3153..962fde1 100644
--- a/drivers/media/dvb/frontends/stv0900_sw.c
+++ b/drivers/media/dvb/frontends/stv0900_sw.c
@@ -1721,7 +1721,7 @@ static enum fe_stv0900_signal_type stv0900_dvbs1_acq_workaround(struct dvb_front
 
 	s32 srate, demod_timeout,
 		fec_timeout, freq1, freq0;
-	enum fe_stv0900_signal_type signal_type = STV0900_NODATA;;
+	enum fe_stv0900_signal_type signal_type = STV0900_NODATA;
 
 	switch (demod) {
 	case STV0900_DEMOD_1:
diff --git a/drivers/media/video/cx18/cx18-fileops.c b/drivers/media/video/cx18/cx18-fileops.c
index 29969c1..04d9c25 100644
--- a/drivers/media/video/cx18/cx18-fileops.c
+++ b/drivers/media/video/cx18/cx18-fileops.c
@@ -690,7 +690,7 @@ int cx18_v4l2_open(struct file *filp)
 	int res;
 	struct video_device *video_dev = video_devdata(filp);
 	struct cx18_stream *s = video_get_drvdata(video_dev);
-	struct cx18 *cx = s->cx;;
+	struct cx18 *cx = s->cx;
 
 	mutex_lock(&cx->serialize_lock);
 	if (cx18_init_on_first_open(cx)) {
diff --git a/drivers/media/video/cx231xx/cx231xx-video.c b/drivers/media/video/cx231xx/cx231xx-video.c
index 609bae6..3650372 100644
--- a/drivers/media/video/cx231xx/cx231xx-video.c
+++ b/drivers/media/video/cx231xx/cx231xx-video.c
@@ -923,8 +923,8 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 
 	f->fmt.pix.width = dev->width;
 	f->fmt.pix.height = dev->height;
-	f->fmt.pix.pixelformat = dev->format->fourcc;;
-	f->fmt.pix.bytesperline = (dev->width * dev->format->depth + 7) >> 3;;
+	f->fmt.pix.pixelformat = dev->format->fourcc;
+	f->fmt.pix.bytesperline = (dev->width * dev->format->depth + 7) >> 3;
 	f->fmt.pix.sizeimage = f->fmt.pix.bytesperline * dev->height;
 	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
 
diff --git a/drivers/media/video/cx23885/cx23885.h b/drivers/media/video/cx23885/cx23885.h
index 1a2ac51..2915103 100644
--- a/drivers/media/video/cx23885/cx23885.h
+++ b/drivers/media/video/cx23885/cx23885.h
@@ -391,7 +391,7 @@ struct sram_channel {
 	u32  cmds_start;
 	u32  ctrl_start;
 	u32  cdt;
-	u32  fifo_start;;
+	u32  fifo_start;
 	u32  fifo_size;
 	u32  ptr1_reg;
 	u32  ptr2_reg;
diff --git a/drivers/media/video/ivtv/ivtv-driver.c b/drivers/media/video/ivtv/ivtv-driver.c
index 558f8a8..fa360d3 100644
--- a/drivers/media/video/ivtv/ivtv-driver.c
+++ b/drivers/media/video/ivtv/ivtv-driver.c
@@ -218,7 +218,7 @@ MODULE_PARM_DESC(ivtv_yuv_mode,
 		 "\t\t\tDefault: 0 (interlaced)");
 MODULE_PARM_DESC(ivtv_yuv_threshold,
 		 "If ivtv_yuv_mode is 2 (auto) then playback content as\n\t\tprogressive if src height <= ivtv_yuvthreshold\n"
-		 "\t\t\tDefault: 480");;
+		 "\t\t\tDefault: 480");
 MODULE_PARM_DESC(enc_mpg_buffers,
 		 "Encoder MPG Buffers (in MB)\n"
 		 "\t\t\tDefault: " __stringify(IVTV_DEFAULT_ENC_MPG_BUFFERS));
diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index bae61b2..e57f778 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -441,7 +441,7 @@ static void twl4030_sih_do_edge(struct work_struct *work)
 	/* see what work we have */
 	spin_lock_irq(&sih_agent_lock);
 	edge_change = agent->edge_change;
-	agent->edge_change = 0;;
+	agent->edge_change = 0;
 	sih = edge_change ? agent->sih : NULL;
 	spin_unlock_irq(&sih_agent_lock);
 	if (!sih)
diff --git a/drivers/mmc/host/imxmmc.c b/drivers/mmc/host/imxmmc.c
index e0be21a..bf98d7c 100644
--- a/drivers/mmc/host/imxmmc.c
+++ b/drivers/mmc/host/imxmmc.c
@@ -652,7 +652,7 @@ static irqreturn_t imxmci_irq(int irq, void *devid)
 	set_bit(IMXMCI_PEND_STARTED_b, &host->pending_events);
 	tasklet_schedule(&host->tasklet);
 
-	return IRQ_RETVAL(handled);;
+	return IRQ_RETVAL(handled);
 }
 
 static void imxmci_tasklet_fnc(unsigned long data)
diff --git a/drivers/net/arcnet/arc-rawmode.c b/drivers/net/arcnet/arc-rawmode.c
index 646dfc5..8ea9c75 100644
--- a/drivers/net/arcnet/arc-rawmode.c
+++ b/drivers/net/arcnet/arc-rawmode.c
@@ -123,7 +123,6 @@ static void rx(struct net_device *dev, int bufnum,
 	BUGLVL(D_SKB) arcnet_dump_skb(dev, skb, "rx");
 
 	skb->protocol = cpu_to_be16(ETH_P_ARCNET);
-;
 	netif_rx(skb);
 }
 
diff --git a/drivers/net/arcnet/capmode.c b/drivers/net/arcnet/capmode.c
index 083e210..66bcbbb 100644
--- a/drivers/net/arcnet/capmode.c
+++ b/drivers/net/arcnet/capmode.c
@@ -149,7 +149,6 @@ static void rx(struct net_device *dev, int bufnum,
 	BUGLVL(D_SKB) arcnet_dump_skb(dev, skb, "rx");
 
 	skb->protocol = cpu_to_be16(ETH_P_ARCNET);
-;
 	netif_rx(skb);
 }
 
diff --git a/drivers/net/bnx2x_link.c b/drivers/net/bnx2x_link.c
index ed648ac..f5f45c6 100644
--- a/drivers/net/bnx2x_link.c
+++ b/drivers/net/bnx2x_link.c
@@ -2390,7 +2390,7 @@ static u8 bnx2x_read_sfp_module_eeprom(struct link_params *params, u16 addr,
 			      MDIO_PMA_REG_8726_TWO_WIRE_CTRL, &val);
 		if ((val & MDIO_PMA_REG_8726_TWO_WIRE_CTRL_STATUS_MASK) ==
 		    MDIO_PMA_REG_8726_TWO_WIRE_STATUS_IDLE)
-			return 0;;
+			return 0;
 		msleep(1);
 	}
 	return -EINVAL;
diff --git a/drivers/net/gianfar_ethtool.c b/drivers/net/gianfar_ethtool.c
index dbf06e9..1c1790d 100644
--- a/drivers/net/gianfar_ethtool.c
+++ b/drivers/net/gianfar_ethtool.c
@@ -293,7 +293,7 @@ static int gfar_gcoalesce(struct net_device *dev, struct ethtool_coalesce *cvals
 	rxtime  = get_ictt_value(priv->rxic);
 	rxcount = get_icft_value(priv->rxic);
 	txtime  = get_ictt_value(priv->txic);
-	txcount = get_icft_value(priv->txic);;
+	txcount = get_icft_value(priv->txic);
 	cvals->rx_coalesce_usecs = gfar_ticks2usecs(priv, rxtime);
 	cvals->rx_max_coalesced_frames = rxcount;
 
diff --git a/drivers/net/ibm_newemac/core.c b/drivers/net/ibm_newemac/core.c
index beb8421..d4531ef 100644
--- a/drivers/net/ibm_newemac/core.c
+++ b/drivers/net/ibm_newemac/core.c
@@ -2557,13 +2557,13 @@ static int __devinit emac_init_config(struct emac_instance *dev)
 	if (emac_read_uint_prop(np, "mdio-device", &dev->mdio_ph, 0))
 		dev->mdio_ph = 0;
 	if (emac_read_uint_prop(np, "zmii-device", &dev->zmii_ph, 0))
-		dev->zmii_ph = 0;;
+		dev->zmii_ph = 0;
 	if (emac_read_uint_prop(np, "zmii-channel", &dev->zmii_port, 0))
-		dev->zmii_port = 0xffffffff;;
+		dev->zmii_port = 0xffffffff;
 	if (emac_read_uint_prop(np, "rgmii-device", &dev->rgmii_ph, 0))
-		dev->rgmii_ph = 0;;
+		dev->rgmii_ph = 0;
 	if (emac_read_uint_prop(np, "rgmii-channel", &dev->rgmii_port, 0))
-		dev->rgmii_port = 0xffffffff;;
+		dev->rgmii_port = 0xffffffff;
 	if (emac_read_uint_prop(np, "fifo-entry-size", &dev->fifo_entry_size, 0))
 		dev->fifo_entry_size = 16;
 	if (emac_read_uint_prop(np, "mal-burst-size", &dev->mal_burst_size, 0))
diff --git a/drivers/net/igb/igb_main.c b/drivers/net/igb/igb_main.c
index ea17319..43d5fda 100644
--- a/drivers/net/igb/igb_main.c
+++ b/drivers/net/igb/igb_main.c
@@ -3901,7 +3901,7 @@ static int igb_set_vf_multicasts(struct igb_adapter *adapter,
 	/* VFs are limited to using the MTA hash table for their multicast
 	 * addresses */
 	for (i = 0; i < n; i++)
-		vf_data->vf_mc_hashes[i] = hash_list[i];;
+		vf_data->vf_mc_hashes[i] = hash_list[i];
 
 	/* Flush and reset the mta with the new values */
 	igb_set_multi(adapter->netdev);
@@ -5447,7 +5447,7 @@ static inline void igb_set_rah_pool(struct e1000_hw *hw, int pool, int entry)
 
 	reg_data = rd32(E1000_RAH(entry));
 	reg_data &= ~E1000_RAH_POOL_MASK;
-	reg_data |= E1000_RAH_POOL_1 << pool;;
+	reg_data |= E1000_RAH_POOL_1 << pool;
 	wr32(E1000_RAH(entry), reg_data);
 }
 
diff --git a/drivers/net/ll_temac_main.c b/drivers/net/ll_temac_main.c
index 96e7248..d23e817 100644
--- a/drivers/net/ll_temac_main.c
+++ b/drivers/net/ll_temac_main.c
@@ -865,7 +865,7 @@ temac_of_probe(struct of_device *op, const struct of_device_id *match)
 	dcrs = dcr_resource_start(np, 0);
 	if (dcrs == 0) {
 		dev_err(&op->dev, "could not get DMA register address\n");
-		goto nodev;;
+		goto nodev;
 	}
 	lp->sdma_dcrs = dcr_map(np, dcrs, dcr_resource_len(np, 0));
 	dev_dbg(&op->dev, "DCR base: %x\n", dcrs);
diff --git a/drivers/net/ni52.c b/drivers/net/ni52.c
index 77d44a0..3679e2b 100644
--- a/drivers/net/ni52.c
+++ b/drivers/net/ni52.c
@@ -615,10 +615,10 @@ static int init586(struct net_device *dev)
 	/* addr_len |!src_insert |pre-len |loopback */
 	writeb(0x2e, &cfg_cmd->adr_len);
 	writeb(0x00, &cfg_cmd->priority);
-	writeb(0x60, &cfg_cmd->ifs);;
+	writeb(0x60, &cfg_cmd->ifs);
 	writeb(0x00, &cfg_cmd->time_low);
 	writeb(0xf2, &cfg_cmd->time_high);
-	writeb(0x00, &cfg_cmd->promisc);;
+	writeb(0x00, &cfg_cmd->promisc);
 	if (dev->flags & IFF_ALLMULTI) {
 		int len = ((char __iomem *)p->iscp - (char __iomem *)ptr - 8) / 6;
 		if (num_addrs > len) {
diff --git a/drivers/net/qlge/qlge_main.c b/drivers/net/qlge/qlge_main.c
index 90d1f76..bc41287 100644
--- a/drivers/net/qlge/qlge_main.c
+++ b/drivers/net/qlge/qlge_main.c
@@ -2607,7 +2607,7 @@ static int ql_start_rx_ring(struct ql_adapter *qdev, struct rx_ring *rx_ring)
 	    FLAGS_LI;		/* Load irq delay values */
 	if (rx_ring->lbq_len) {
 		cqicb->flags |= FLAGS_LL;	/* Load lbq values */
-		tmp = (u64)rx_ring->lbq_base_dma;;
+		tmp = (u64)rx_ring->lbq_base_dma;
 		base_indirect_ptr = (__le64 *) rx_ring->lbq_base_indirect;
 		page_entries = 0;
 		do {
@@ -2631,7 +2631,7 @@ static int ql_start_rx_ring(struct ql_adapter *qdev, struct rx_ring *rx_ring)
 	}
 	if (rx_ring->sbq_len) {
 		cqicb->flags |= FLAGS_LS;	/* Load sbq values */
-		tmp = (u64)rx_ring->sbq_base_dma;;
+		tmp = (u64)rx_ring->sbq_base_dma;
 		base_indirect_ptr = (__le64 *) rx_ring->sbq_base_indirect;
 		page_entries = 0;
 		do {
diff --git a/drivers/net/skfp/pcmplc.c b/drivers/net/skfp/pcmplc.c
index f1df2ec..e6b33ee 100644
--- a/drivers/net/skfp/pcmplc.c
+++ b/drivers/net/skfp/pcmplc.c
@@ -960,7 +960,7 @@ static void pcm_fsm(struct s_smc *smc, struct s_phy *phy, int cmd)
 			/*PC88b*/
 			if (!phy->cf_join) {
 				phy->cf_join = TRUE ;
-				queue_event(smc,EVENT_CFM,CF_JOIN+np) ; ;
+				queue_event(smc,EVENT_CFM,CF_JOIN+np) ;
 			}
 			if (cmd == PC_JOIN)
 				GO_STATE(PC8_ACTIVE) ;
diff --git a/drivers/net/skfp/pmf.c b/drivers/net/skfp/pmf.c
index 79e665e..a320fdb 100644
--- a/drivers/net/skfp/pmf.c
+++ b/drivers/net/skfp/pmf.c
@@ -807,9 +807,9 @@ void smt_add_para(struct s_smc *smc, struct s_pcon *pcon, u_short para,
 				mib_p->fddiPORTLerFlag ;
 			sp->p4050_pad = 0 ;
 			sp->p4050_cutoff =
-				mib_p->fddiPORTLer_Cutoff ; ;
+				mib_p->fddiPORTLer_Cutoff ;
 			sp->p4050_alarm =
-				mib_p->fddiPORTLer_Alarm ; ;
+				mib_p->fddiPORTLer_Alarm ;
 			sp->p4050_estimate =
 				mib_p->fddiPORTLer_Estimate ;
 			sp->p4050_reject_ct =
@@ -829,7 +829,7 @@ void smt_add_para(struct s_smc *smc, struct s_pcon *pcon, u_short para,
 			sp->p4051_porttype =
 				mib_p->fddiPORTMy_Type ;
 			sp->p4051_connectstate =
-				mib_p->fddiPORTConnectState ; ;
+				mib_p->fddiPORTConnectState ;
 			sp->p4051_pc_neighbor =
 				mib_p->fddiPORTNeighborType ;
 			sp->p4051_pc_withhold =
@@ -853,7 +853,7 @@ void smt_add_para(struct s_smc *smc, struct s_pcon *pcon, u_short para,
 			struct smt_p_4053	*sp ;
 			sp = (struct smt_p_4053 *) to ;
 			sp->p4053_multiple =
-				mib_p->fddiPORTMultiple_P ; ;
+				mib_p->fddiPORTMultiple_P ;
 			sp->p4053_availablepaths =
 				mib_p->fddiPORTAvailablePaths ;
 			sp->p4053_currentpath =
diff --git a/drivers/net/skge.c b/drivers/net/skge.c
index 60d502e..0202471 100644
--- a/drivers/net/skge.c
+++ b/drivers/net/skge.c
@@ -215,7 +215,7 @@ static void skge_wol_init(struct skge_port *skge)
 	if (skge->wol & WAKE_MAGIC)
 		ctrl |= WOL_CTL_ENA_PME_ON_MAGIC_PKT|WOL_CTL_ENA_MAGIC_PKT_UNIT;
 	else
-		ctrl |= WOL_CTL_DIS_PME_ON_MAGIC_PKT|WOL_CTL_DIS_MAGIC_PKT_UNIT;;
+		ctrl |= WOL_CTL_DIS_PME_ON_MAGIC_PKT|WOL_CTL_DIS_MAGIC_PKT_UNIT;
 
 	ctrl |= WOL_CTL_DIS_PME_ON_PATTERN|WOL_CTL_DIS_PATTERN_UNIT;
 	skge_write16(hw, WOL_REGS(port, WOL_CTRL_STAT), ctrl);
diff --git a/drivers/net/sky2.c b/drivers/net/sky2.c
index 7681d28..c4281b5 100644
--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -749,7 +749,7 @@ static void sky2_wol_init(struct sky2_port *sky2)
 	if (sky2->wol & WAKE_MAGIC)
 		ctrl |= WOL_CTL_ENA_PME_ON_MAGIC_PKT|WOL_CTL_ENA_MAGIC_PKT_UNIT;
 	else
-		ctrl |= WOL_CTL_DIS_PME_ON_MAGIC_PKT|WOL_CTL_DIS_MAGIC_PKT_UNIT;;
+		ctrl |= WOL_CTL_DIS_PME_ON_MAGIC_PKT|WOL_CTL_DIS_MAGIC_PKT_UNIT;
 
 	ctrl |= WOL_CTL_DIS_PME_ON_PATTERN|WOL_CTL_DIS_PATTERN_UNIT;
 	sky2_write16(hw, WOL_REGS(port, WOL_CTRL_STAT), ctrl);
diff --git a/drivers/net/vxge/vxge-config.h b/drivers/net/vxge/vxge-config.h
index afbdf6f..e65a381 100644
--- a/drivers/net/vxge/vxge-config.h
+++ b/drivers/net/vxge/vxge-config.h
@@ -1547,7 +1547,7 @@ void vxge_hw_ring_rxd_1b_info_get(
 	rxd_info->l4_cksum_valid =
 		(u32)VXGE_HW_RING_RXD_L4_CKSUM_CORRECT_GET(rxdp->control_0);
 	rxd_info->l4_cksum =
-		(u32)VXGE_HW_RING_RXD_L4_CKSUM_GET(rxdp->control_0);;
+		(u32)VXGE_HW_RING_RXD_L4_CKSUM_GET(rxdp->control_0);
 	rxd_info->frame =
 		(u32)VXGE_HW_RING_RXD_ETHER_ENCAP_GET(rxdp->control_0);
 	rxd_info->proto =
diff --git a/drivers/net/vxge/vxge-main.c b/drivers/net/vxge/vxge-main.c
index 6034497..fb7e6b1 100644
--- a/drivers/net/vxge/vxge-main.c
+++ b/drivers/net/vxge/vxge-main.c
@@ -2341,7 +2341,7 @@ static int vxge_enable_msix(struct vxgedev *vdev)
 	enum vxge_hw_status status;
 	/* 0 - Tx, 1 - Rx  */
 	int tim_msix_id[4];
-	int alarm_msix_id = 0, msix_intr_vect = 0;;
+	int alarm_msix_id = 0, msix_intr_vect = 0;
 	vdev->intr_cnt = 0;
 
 	/* allocate msix vectors */
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index a2fda70..d82a0f9 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -2516,10 +2516,8 @@ static void ath9k_hw_set_def_power_per_rate_table(struct ath_hw *ah,
 			targetPowerCck.tPow2x[1];
 		ratesArray[rate5_5s] = ratesArray[rate5_5l] =
 			targetPowerCck.tPow2x[2];
-		;
 		ratesArray[rate11s] = ratesArray[rate11l] =
 			targetPowerCck.tPow2x[3];
-		;
 	}
 	if (IS_CHAN_HT40(chan)) {
 		for (i = 0; i < ARRAY_SIZE(targetPowerHt40.tPow2x); i++) {
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 34935a8..cffb078 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2345,7 +2345,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	ath9k_hw_init_bb(ah, chan);
 
 	if (!ath9k_hw_init_cal(ah, chan))
-		return -EIO;;
+		return -EIO;
 
 	rx_chainmask = ah->rxchainmask;
 	if ((rx_chainmask == 0x5) || (rx_chainmask == 0x3)) {
diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index d73cf96..4cec54e 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -779,16 +779,16 @@ static int iwm_mlme_mgt_frame(struct iwm_priv *iwm, u8 *buf,
 		    le16_to_cpu(mgt_frame->len));
 
 	if (ieee80211_is_assoc_req(mgt->frame_control)) {
-		ie = mgt->u.assoc_req.variable;;
+		ie = mgt->u.assoc_req.variable;
 		event = IWEVASSOCREQIE;
 	} else if (ieee80211_is_reassoc_req(mgt->frame_control)) {
-		ie = mgt->u.reassoc_req.variable;;
+		ie = mgt->u.reassoc_req.variable;
 		event = IWEVASSOCREQIE;
 	} else if (ieee80211_is_assoc_resp(mgt->frame_control)) {
-		ie = mgt->u.assoc_resp.variable;;
+		ie = mgt->u.assoc_resp.variable;
 		event = IWEVASSOCRESPIE;
 	} else if (ieee80211_is_reassoc_resp(mgt->frame_control)) {
-		ie = mgt->u.reassoc_resp.variable;;
+		ie = mgt->u.reassoc_resp.variable;
 		event = IWEVASSOCRESPIE;
 	} else {
 		IWM_ERR(iwm, "Unsupported management frame");
diff --git a/drivers/pci/pcie/aer/ecrc.c b/drivers/pci/pcie/aer/ecrc.c
index ece97df..a928d8a 100644
--- a/drivers/pci/pcie/aer/ecrc.c
+++ b/drivers/pci/pcie/aer/ecrc.c
@@ -106,7 +106,7 @@ void pcie_set_ecrc_checking(struct pci_dev *dev)
 		disable_ecrc_checking(dev);
 		break;
 	case ECRC_POLICY_ON:
-		enable_ecrc_checking(dev);;
+		enable_ecrc_checking(dev);
 		break;
 	default:
 		return;
diff --git a/drivers/pcmcia/pcmcia_resource.c b/drivers/pcmcia/pcmcia_resource.c
index f5d0ba8..8c2db2a 100644
--- a/drivers/pcmcia/pcmcia_resource.c
+++ b/drivers/pcmcia/pcmcia_resource.c
@@ -489,7 +489,7 @@ int pcmcia_request_configuration(struct pcmcia_device *p_dev,
 	pccard_io_map iomap;
 
 	if (!(s->state & SOCKET_PRESENT))
-		return -ENODEV;;
+		return -ENODEV;
 
 	if (req->IntType & INT_CARDBUS) {
 		ds_dbg(p_dev->socket, 0, "IntType may not be INT_CARDBUS\n");
diff --git a/drivers/regulator/pcf50633-regulator.c b/drivers/regulator/pcf50633-regulator.c
index 8e14900..70ba775 100644
--- a/drivers/regulator/pcf50633-regulator.c
+++ b/drivers/regulator/pcf50633-regulator.c
@@ -155,7 +155,7 @@ static int pcf50633_regulator_get_voltage(struct regulator_dev *rdev)
 	int regulator_id, millivolts, volt_bits;
 	u8 regnr;
 
-	pcf = rdev_get_drvdata(rdev);;
+	pcf = rdev_get_drvdata(rdev);
 
 	regulator_id = rdev_get_id(rdev);
 	if (regulator_id >= PCF50633_NUM_REGULATORS)
diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index bd1ce8e..0587d53 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -430,7 +430,7 @@ fail:
 
 static int __exit omap_rtc_remove(struct platform_device *pdev)
 {
-	struct rtc_device	*rtc = platform_get_drvdata(pdev);;
+	struct rtc_device	*rtc = platform_get_drvdata(pdev);
 
 	device_init_wakeup(&pdev->dev, 0);
 
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index f8b1f04..dd45277 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -706,7 +706,7 @@ static int dasd_eckd_generate_uid(struct dasd_device *device,
 	       sizeof(uid->serial) - 1);
 	EBCASC(uid->serial, sizeof(uid->serial) - 1);
 	uid->ssid = private->gneq->subsystemID;
-	uid->real_unit_addr = private->ned->unit_addr;;
+	uid->real_unit_addr = private->ned->unit_addr;
 	if (private->sneq) {
 		uid->type = private->sneq->sua_flags;
 		if (uid->type == UA_BASE_PAV_ALIAS)
diff --git a/drivers/s390/net/netiucv.c b/drivers/s390/net/netiucv.c
index 8c36eaf..6b6371b 100644
--- a/drivers/s390/net/netiucv.c
+++ b/drivers/s390/net/netiucv.c
@@ -2113,7 +2113,7 @@ static ssize_t remove_write (struct device_driver *drv,
 	IUCV_DBF_TEXT(trace, 3, __func__);
 
         if (count >= IFNAMSIZ)
-                count = IFNAMSIZ - 1;;
+                count = IFNAMSIZ - 1;
 
 	for (i = 0, p = buf; i < count && *p; i++, p++) {
 		if (*p == '\n' || *p == ' ')
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 967ede7..7db90da 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -101,7 +101,7 @@ static int zfcp_scsi_queuecommand(struct scsi_cmnd *scpnt,
 	if (unlikely((status & ZFCP_STATUS_COMMON_ERP_FAILED) ||
 		     !(status & ZFCP_STATUS_COMMON_RUNNING))) {
 		zfcp_scsi_command_fail(scpnt, DID_ERROR);
-		return 0;;
+		return 0;
 	}
 
 	ret = zfcp_fsf_send_fcp_command_task(unit, scpnt);
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 906cef5..41e1b0e 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1340,7 +1340,7 @@ static int bnx2i_process_login_resp(struct iscsi_session *session,
 	resp_hdr->opcode = login->op_code;
 	resp_hdr->flags = login->response_flags;
 	resp_hdr->max_version = login->version_max;
-	resp_hdr->active_version = login->version_active;;
+	resp_hdr->active_version = login->version_active;
 	resp_hdr->hlength = 0;
 
 	hton24(resp_hdr->dlength, login->data_length);
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 0e532f0..4d935ba 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1205,7 +1205,7 @@ lpfc_ns_cmd(struct lpfc_vport *vport, int cmdcode,
 		vport->ct_flags &= ~FC_CT_RFF_ID;
 		CtReq->CommandResponse.bits.CmdRsp =
 		    be16_to_cpu(SLI_CTNS_RFF_ID);
-		CtReq->un.rff.PortId = cpu_to_be32(vport->fc_myDID);;
+		CtReq->un.rff.PortId = cpu_to_be32(vport->fc_myDID);
 		CtReq->un.rff.fbits = FC4_FEATURE_INIT;
 		CtReq->un.rff.type_code = FC_FCP_DATA;
 		cmpl = lpfc_cmpl_ct_cmd_rff_id;
diff --git a/drivers/spi/omap_uwire.c b/drivers/spi/omap_uwire.c
index aa90ddb..fbfd321 100644
--- a/drivers/spi/omap_uwire.c
+++ b/drivers/spi/omap_uwire.c
@@ -213,7 +213,7 @@ static int uwire_txrx(struct spi_device *spi, struct spi_transfer *t)
 	unsigned	bits = ust->bits_per_word;
 	unsigned	bytes;
 	u16		val, w;
-	int		status = 0;;
+	int		status = 0;
 
 	if (!t->tx_buf && !t->rx_buf)
 		return 0;
diff --git a/drivers/spi/spi_s3c24xx.c b/drivers/spi/spi_s3c24xx.c
index e0d44af..9253cab 100644
--- a/drivers/spi/spi_s3c24xx.c
+++ b/drivers/spi/spi_s3c24xx.c
@@ -385,7 +385,7 @@ static int __init s3c24xx_spi_probe(struct platform_device *pdev)
 
  err_no_iores:
  err_no_pdata:
-	spi_master_put(hw->master);;
+	spi_master_put(hw->master);
 
  err_nomem:
 	return err;
diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.c b/drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.c
index 43198aa..7f28fe2 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.c
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.c
@@ -1008,7 +1008,7 @@ int i_APCI1710_InsnWriteEnableDisableTorCounter(struct comedi_device *dev,
 	b_ExternGate = (unsigned char) data[3];
 	b_CycleMode = (unsigned char) data[4];
 	b_InterruptEnable = (unsigned char) data[5];
-	i_ReturnValue = insn->n;;
+	i_ReturnValue = insn->n;
 	devpriv->tsk_Current = current;	/*  Save the current process task structure */
 	/**************************/
 	/* Test the module number */
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
index 236b8a3..fb4db93 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
@@ -2834,7 +2834,7 @@ int i_APCI1500_Reset(struct comedi_device *dev)
 	i_Logic = 0;
 	i_CounterLogic = 0;
 	i_InterruptMask = 0;
-	i_InputChannel = 0;;
+	i_InputChannel = 0;
 	i_TimerCounter1Enabled = 0;
 	i_TimerCounter2Enabled = 0;
 	i_WatchdogCounter3Enabled = 0;
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.c
index 3841635..fcd71ae 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.c
@@ -335,7 +335,7 @@ int i_APCI1516_WriteDigitalOutput(struct comedi_device *dev, struct comedi_subde
 			return -EINVAL;
 		}		/* if else data[3]==1) */
 	}			/* if else data[3]==0) */
-	return (insn->n);;
+	return (insn->n);
 }
 
 /*
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
index ef21f03..edd1fff 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
@@ -339,7 +339,7 @@ int i_APCI3501_ConfigAnalogOutput(struct comedi_device *dev, struct comedi_subde
 int i_APCI3501_WriteAnalogOutput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
-	unsigned int ul_Command1 = 0, ul_Channel_no, ul_Polarity, ul_DAC_Ready = 0;;
+	unsigned int ul_Command1 = 0, ul_Channel_no, ul_Polarity, ul_DAC_Ready = 0;
 
 	ul_Channel_no = CR_CHAN(insn->chanspec);
 
diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 21133f0..48e0765 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -918,7 +918,7 @@ static int pci230_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (thisboard->ao_chans > 0) {
 		s->type = COMEDI_SUBD_AO;
 		s->subdev_flags = SDF_WRITABLE | SDF_GROUND;
-		s->n_chan = thisboard->ao_chans;;
+		s->n_chan = thisboard->ao_chans;
 		s->maxdata = (1 << thisboard->ao_bits) - 1;
 		s->range_table = &pci230_ao_range;
 		s->insn_write = &pci230_ao_winsn;
diff --git a/drivers/staging/comedi/drivers/comedi_bond.c b/drivers/staging/comedi/drivers/comedi_bond.c
index 45cd41f..8bd50d7 100644
--- a/drivers/staging/comedi/drivers/comedi_bond.c
+++ b/drivers/staging/comedi/drivers/comedi_bond.c
@@ -400,7 +400,7 @@ static int doDevConfig(struct comedi_device *dev, struct comedi_devconfig *it)
 	void *devs_opened[COMEDI_NUM_BOARD_MINORS];
 
 	memset(devs_opened, 0, sizeof(devs_opened));
-	devpriv->name[0] = 0;;
+	devpriv->name[0] = 0;
 	/* Loop through all comedi devices specified on the command-line,
 	   building our device list */
 	for (i = 0; i < COMEDI_NDEVCONFOPTS && (!i || it->options[i]); ++i) {
diff --git a/drivers/staging/go7007/go7007-driver.c b/drivers/staging/go7007/go7007-driver.c
index 77b1e76..98a4a00 100644
--- a/drivers/staging/go7007/go7007-driver.c
+++ b/drivers/staging/go7007/go7007-driver.c
@@ -647,7 +647,7 @@ struct go7007 *go7007_alloc(struct go7007_board_info *board, struct device *dev)
 	go->dvd_mode = 0;
 	go->interlace_coding = 0;
 	for (i = 0; i < 4; ++i)
-		go->modet[i].enable = 0;;
+		go->modet[i].enable = 0;
 	for (i = 0; i < 1624; ++i)
 		go->modet_map[i] = 0;
 	go->audio_deliver = NULL;
diff --git a/drivers/staging/otus/80211core/cmmsta.c b/drivers/staging/otus/80211core/cmmsta.c
index b28a4e2..d6aa0a4 100644
--- a/drivers/staging/otus/80211core/cmmsta.c
+++ b/drivers/staging/otus/80211core/cmmsta.c
@@ -1426,7 +1426,7 @@ struct zsBssInfo* zfStaFindBssInfo(zdev_t* dev, zbuf_t* buf, struct zsWlanProbeR
                     if (zfHpIsAllowedChannel(dev, zfChNumToFreq(dev, channel, 0)) == 0) {
                         frequency = 0;
                     } else {
-                        frequency = zfChNumToFreq(dev, channel, 0);;
+                        frequency = zfChNumToFreq(dev, channel, 0);
                     }
                 } else {
                     frequency = 0;
diff --git a/drivers/staging/otus/hal/hpmain.c b/drivers/staging/otus/hal/hpmain.c
index 322585b..32f0b49 100644
--- a/drivers/staging/otus/hal/hpmain.c
+++ b/drivers/staging/otus/hal/hpmain.c
@@ -1455,7 +1455,7 @@ void zfHpSetFrequencyEx(zdev_t* dev, u32_t frequency, u8_t bw40,
        /* calibration that updates the pddac with the wrong polarity.  Fortunately    */
        /* the second loop can be disabled with a bit called en_pd_dc_offset_thr.      */
 #if 0
-        cmdB[0] = 8 | (ZM_CMD_BITAND << 8);;
+        cmdB[0] = 8 | (ZM_CMD_BITAND << 8);
         cmdB[1] = (0xa27c + 0x1bc000);
         cmdB[2] = 0xffefffff;
         ret = zfIssueCmd(dev, cmdB, 12, ZM_OID_INTERNAL_WRITE, 0);
diff --git a/drivers/staging/rt2860/common/cmm_data_2860.c b/drivers/staging/rt2860/common/cmm_data_2860.c
index fb17355..5a6349a 100644
--- a/drivers/staging/rt2860/common/cmm_data_2860.c
+++ b/drivers/staging/rt2860/common/cmm_data_2860.c
@@ -80,7 +80,7 @@ USHORT RtmpPCI_WriteTxResource(
 
 	pTxD->SDPtr0 = BufBasePaLow;
 	pTxD->SDLen0 = TXINFO_SIZE + TXWI_SIZE + hwHeaderLen; // include padding
-	pTxD->SDPtr1 = PCI_MAP_SINGLE(pAd, pTxBlk, 0, 1, PCI_DMA_TODEVICE);;
+	pTxD->SDPtr1 = PCI_MAP_SINGLE(pAd, pTxBlk, 0, 1, PCI_DMA_TODEVICE);
 	pTxD->SDLen1 = pTxBlk->SrcBufLen;
 	pTxD->LastSec0 = 0;
 	pTxD->LastSec1 = (bIsLast) ? 1 : 0;
@@ -139,7 +139,7 @@ USHORT RtmpPCI_WriteSingleTxResource(
 
 	pTxD->SDPtr0 = BufBasePaLow;
 	pTxD->SDLen0 = TXINFO_SIZE + TXWI_SIZE + hwHeaderLen; // include padding
-	pTxD->SDPtr1 = PCI_MAP_SINGLE(pAd, pTxBlk, 0, 1, PCI_DMA_TODEVICE);;
+	pTxD->SDPtr1 = PCI_MAP_SINGLE(pAd, pTxBlk, 0, 1, PCI_DMA_TODEVICE);
 	pTxD->SDLen1 = pTxBlk->SrcBufLen;
 	pTxD->LastSec0 = 0;
 	pTxD->LastSec1 = (bIsLast) ? 1 : 0;
@@ -218,7 +218,7 @@ USHORT RtmpPCI_WriteMultiTxResource(
 
 	pTxD->SDPtr0 = BufBasePaLow;
 	pTxD->SDLen0 = firstDMALen; // include padding
-	pTxD->SDPtr1 = PCI_MAP_SINGLE(pAd, pTxBlk, 0, 1, PCI_DMA_TODEVICE);;
+	pTxD->SDPtr1 = PCI_MAP_SINGLE(pAd, pTxBlk, 0, 1, PCI_DMA_TODEVICE);
 	pTxD->SDLen1 = pTxBlk->SrcBufLen;
 	pTxD->LastSec0 = 0;
 	pTxD->LastSec1 = (bIsLast) ? 1 : 0;
@@ -372,7 +372,7 @@ int RtmpPCIMgmtKickOut(
 	pTxD->LastSec1 = 1;
 	pTxD->DMADONE = 0;
 	pTxD->SDLen1 = 0;
-	pTxD->SDPtr0 = PCI_MAP_SINGLE(pAd, pSrcBufVA, SrcBufLen, 0, PCI_DMA_TODEVICE);;
+	pTxD->SDPtr0 = PCI_MAP_SINGLE(pAd, pSrcBufVA, SrcBufLen, 0, PCI_DMA_TODEVICE);
 	pTxD->SDLen0 = SrcBufLen;
 
 	pAd->RalinkCounters.KickTxCount++;
diff --git a/drivers/staging/rt2860/rt_linux.c b/drivers/staging/rt2860/rt_linux.c
index 80176b2..b5a2050 100644
--- a/drivers/staging/rt2860/rt_linux.c
+++ b/drivers/staging/rt2860/rt_linux.c
@@ -934,7 +934,7 @@ void send_monitor_packets(
     ph->rssi.did = DIDmsg_lnxind_wlansniffrm_rssi;
 	ph->rssi.status = 0;
 	ph->rssi.len = 4;
-    ph->rssi.data = (u_int32_t)RTMPMaxRssi(pAd, ConvertToRssi(pAd, pRxBlk->pRxWI->RSSI0, RSSI_0), ConvertToRssi(pAd, pRxBlk->pRxWI->RSSI1, RSSI_1), ConvertToRssi(pAd, pRxBlk->pRxWI->RSSI2, RSSI_2));;
+    ph->rssi.data = (u_int32_t)RTMPMaxRssi(pAd, ConvertToRssi(pAd, pRxBlk->pRxWI->RSSI0, RSSI_0), ConvertToRssi(pAd, pRxBlk->pRxWI->RSSI1, RSSI_1), ConvertToRssi(pAd, pRxBlk->pRxWI->RSSI2, RSSI_2));
 
 	ph->signal.did = DIDmsg_lnxind_wlansniffrm_signal;
 	ph->signal.status = 0;
diff --git a/drivers/staging/rt2860/rtmp.h b/drivers/staging/rt2860/rtmp.h
index 25c3199..c8138d0 100644
--- a/drivers/staging/rt2860/rtmp.h
+++ b/drivers/staging/rt2860/rtmp.h
@@ -4507,8 +4507,7 @@ VOID IterateOnBssTab(
 	IN  PRTMP_ADAPTER   pAd);
 
 VOID IterateOnBssTab2(
-	IN  PRTMP_ADAPTER   pAd);;
-
+	IN  PRTMP_ADAPTER   pAd);
 VOID JoinParmFill(
 	IN  PRTMP_ADAPTER   pAd,
 	IN  OUT MLME_JOIN_REQ_STRUCT *JoinReq,
diff --git a/drivers/staging/rt2860/sta/aironet.c b/drivers/staging/rt2860/sta/aironet.c
index 4af4a19..07b0d51 100644
--- a/drivers/staging/rt2860/sta/aironet.c
+++ b/drivers/staging/rt2860/sta/aironet.c
@@ -367,7 +367,7 @@ VOID	ChannelLoadRequestAction(
 		if (NStatus	!= NDIS_STATUS_SUCCESS)
 			return;
 
-		pNullFrame = (PHEADER_802_11) pOutBuffer;;
+		pNullFrame = (PHEADER_802_11) pOutBuffer;
 		// Make the power save Null frame with PSM bit on
 		MgtMacHeaderInit(pAd, pNullFrame, SUBTYPE_NULL_FUNC, 1, pAd->CommonCfg.Bssid, pAd->CommonCfg.Bssid);
 		pNullFrame->Duration 	= 0;
diff --git a/drivers/staging/rtl8187se/r8185b_init.c b/drivers/staging/rtl8187se/r8185b_init.c
index 4b885a2..0add9f5 100644
--- a/drivers/staging/rtl8187se/r8185b_init.c
+++ b/drivers/staging/rtl8187se/r8185b_init.c
@@ -2642,7 +2642,7 @@ SetRFPowerState(
 
 		default:
 			printk("SetRFPowerState8185(): unknown RFChipID: 0x%X!!!\n", priv->rf_chip);
-			break;;
+			break;
 }
 //	printk("<--------- SetRFPowerState(): bResult(%d)\n", bResult);
 
diff --git a/drivers/staging/rtl8192su/ieee80211/ieee80211_tx.c b/drivers/staging/rtl8192su/ieee80211/ieee80211_tx.c
index 7294572..46b4bad 100644
--- a/drivers/staging/rtl8192su/ieee80211/ieee80211_tx.c
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_tx.c
@@ -788,7 +788,7 @@ int ieee80211_xmit(struct sk_buff *skb, struct net_device *dev)
 		{
 			txb->queue_index = UP2AC(skb->priority);
 		} else {
-			txb->queue_index = WME_AC_BK;;
+			txb->queue_index = WME_AC_BK;
 		}
 
 
diff --git a/drivers/staging/rtl8192su/r8192U_core.c b/drivers/staging/rtl8192su/r8192U_core.c
index f1423d7..0f4d82d 100644
--- a/drivers/staging/rtl8192su/r8192U_core.c
+++ b/drivers/staging/rtl8192su/r8192U_core.c
@@ -7454,7 +7454,7 @@ static void rtl8192SU_MacConfigBeforeFwDownloadASIC(struct net_device *dev)
 void rtl8192SU_HalUsbRxAggr8192SUsb(struct net_device *dev, bool Value)
 {
 	struct r8192_priv *priv = ieee80211_priv((struct net_device *)dev);
-	PRT_HIGH_THROUGHPUT	pHTInfo = priv->ieee80211->pHTInfo;;
+	PRT_HIGH_THROUGHPUT	pHTInfo = priv->ieee80211->pHTInfo;
 
 
 	//
@@ -7527,7 +7527,7 @@ void rtl8192SU_HalUsbRxAggr8192SUsb(struct net_device *dev, bool Value)
 void rtl8192SU_HalUsbRxAggr8192SUsb(struct net_device *dev, bool Value)
 {
 	struct r8192_priv *priv = ieee80211_priv((struct net_device *)dev);
-	PRT_HIGH_THROUGHPUT	pHTInfo = priv->ieee80211->pHTInfo;;
+	PRT_HIGH_THROUGHPUT	pHTInfo = priv->ieee80211->pHTInfo;
 
 
 	//
@@ -10688,7 +10688,7 @@ static void rtl8192_query_rxphystatus(
 			//Get Rx snr value in DB
 			tmp_rxsnr =	pofdm_buf->rxsnr_X[i];
 			rx_snrX = (char)(tmp_rxsnr);
-			//rx_snrX >>= 1;;
+			//rx_snrX >>= 1;
 			rx_snrX /= 2;
 			priv->stats.rxSNRdB[i] = (long)rx_snrX;
 
diff --git a/drivers/staging/rtl8192su/r819xU_phy.c b/drivers/staging/rtl8192su/r819xU_phy.c
index 00497d3..0b0eeb0 100644
--- a/drivers/staging/rtl8192su/r819xU_phy.c
+++ b/drivers/staging/rtl8192su/r819xU_phy.c
@@ -1011,7 +1011,7 @@ u8 rtl8192_phy_ConfigRFWithHeaderFile(struct net_device* dev, RF90_RADIO_PATH_E
 			break;
 	}
 
-	return ret;;
+	return ret;
 
 }
 /******************************************************************************
diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index 723f44e..8076cb9 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -2960,7 +2960,7 @@ BOOL CARDbSoftwareReset (PVOID pDeviceHandler)
 QWORD CARDqGetTSFOffset (BYTE byRxRate, QWORD qwTSF1, QWORD qwTSF2)
 {
     QWORD   qwTSFOffset;
-    WORD    wRxBcnTSFOffst= 0;;
+    WORD    wRxBcnTSFOffst= 0;
 
     HIDWORD(qwTSFOffset) = 0;
     LODWORD(qwTSFOffset) = 0;
diff --git a/drivers/staging/vt6655/iwctl.c b/drivers/staging/vt6655/iwctl.c
index 4d5a1da..fff6265 100644
--- a/drivers/staging/vt6655/iwctl.c
+++ b/drivers/staging/vt6655/iwctl.c
@@ -2168,7 +2168,7 @@ int iwctl_giwencodeext(struct net_device *dev,
              struct iw_point *wrq,
              char *extra)
 {
-		return -EOPNOTSUPP;;
+		return -EOPNOTSUPP;
 }
 
 int iwctl_siwmlme(struct net_device *dev,
diff --git a/drivers/staging/vt6655/wpa2.c b/drivers/staging/vt6655/wpa2.c
index e2fdb33..8828873 100644
--- a/drivers/staging/vt6655/wpa2.c
+++ b/drivers/staging/vt6655/wpa2.c
@@ -225,7 +225,7 @@ WPA2vParseRSN (
         m = *((PWORD) &(pRSN->abyRSN[4]));
 
         if (pRSN->len >= 10+m*4) { // ver(2) + GK(4) + PK count(2) + PKS(4*m) + AKMSS count(2)
-            pBSSNode->wAKMSSAuthCount = *((PWORD) &(pRSN->abyRSN[6+4*m]));;
+            pBSSNode->wAKMSSAuthCount = *((PWORD) &(pRSN->abyRSN[6+4*m]));
             j = 0;
             pbyOUI = &(pRSN->abyRSN[8+4*m]);
             for (i = 0; (i < pBSSNode->wAKMSSAuthCount) && (j < sizeof(pBSSNode->abyAKMSSAuthType)/sizeof(BYTE)); i++) {
@@ -244,7 +244,7 @@ WPA2vParseRSN (
             pBSSNode->wAKMSSAuthCount = (WORD)j;
             DEVICE_PRT(MSG_LEVEL_DEBUG, KERN_INFO"wAKMSSAuthCount: %d\n", pBSSNode->wAKMSSAuthCount);
 
-            n = *((PWORD) &(pRSN->abyRSN[6+4*m]));;
+            n = *((PWORD) &(pRSN->abyRSN[6+4*m]));
             if (pRSN->len >= 12+4*m+4*n) { // ver(2)+GK(4)+PKCnt(2)+PKS(4*m)+AKMSSCnt(2)+AKMSS(4*n)+Cap(2)
                 pBSSNode->sRSNCapObj.bRSNCapExist = TRUE;
                 pBSSNode->sRSNCapObj.wRSNCap = *((PWORD) &(pRSN->abyRSN[8+4*m+4*n]));
diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index 0fe4345..76929ea 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -507,8 +507,6 @@ static int wdm_open(struct inode *inode, struct file *file)
 	desc = usb_get_intfdata(intf);
 	if (test_bit(WDM_DISCONNECTING, &desc->flags))
 		goto out;
-
-	;
 	file->private_data = desc;
 
 	rv = usb_autopm_get_interface(desc->intf);
diff --git a/drivers/usb/serial/spcp8x5.c b/drivers/usb/serial/spcp8x5.c
index 3c249d8..26d2914 100644
--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -546,7 +546,7 @@ static void spcp8x5_set_termios(struct tty_struct *tty,
 	}
 
 	/* Set Baud Rate */
-	baud = tty_get_baud_rate(tty);;
+	baud = tty_get_baud_rate(tty);
 	switch (baud) {
 	case 300:	buf[0] = 0x00;	break;
 	case 600:	buf[0] = 0x01;	break;
diff --git a/drivers/uwb/i1480/i1480u-wlp/netdev.c b/drivers/uwb/i1480/i1480u-wlp/netdev.c
index 7305553..b236e69 100644
--- a/drivers/uwb/i1480/i1480u-wlp/netdev.c
+++ b/drivers/uwb/i1480/i1480u-wlp/netdev.c
@@ -214,7 +214,7 @@ int i1480u_open(struct net_device *net_dev)
 
 	netif_wake_queue(net_dev);
 #ifdef i1480u_FLOW_CONTROL
-	result = usb_submit_urb(i1480u->notif_urb, GFP_KERNEL);;
+	result = usb_submit_urb(i1480u->notif_urb, GFP_KERNEL);
 	if (result < 0) {
 		dev_err(dev, "Can't submit notification URB: %d\n", result);
 		goto error_notif_urb_submit;
diff --git a/drivers/video/cfbcopyarea.c b/drivers/video/cfbcopyarea.c
index df03f37..79e5f40 100644
--- a/drivers/video/cfbcopyarea.c
+++ b/drivers/video/cfbcopyarea.c
@@ -114,7 +114,7 @@ bitcpy(struct fb_info *p, unsigned long __iomem *dst, int dst_idx,
 				d0 >>= right;
 			} else if (src_idx+n <= bits) {
 				// Single source word
-				d0 <<= left;;
+				d0 <<= left;
 			} else {
 				// 2 source words
 				d1 = FB_READL(src + 1);
diff --git a/drivers/video/imxfb.c b/drivers/video/imxfb.c
index 15a0ee6..89e6f1e 100644
--- a/drivers/video/imxfb.c
+++ b/drivers/video/imxfb.c
@@ -677,7 +677,7 @@ static int __init imxfb_probe(struct platform_device *pdev)
 
 	fbi->clk = clk_get(&pdev->dev, NULL);
 	if (IS_ERR(fbi->clk)) {
-		ret = PTR_ERR(fbi->clk);;
+		ret = PTR_ERR(fbi->clk);
 		dev_err(&pdev->dev, "unable to get clock: %d\n", ret);
 		goto failed_getclock;
 	}
diff --git a/drivers/video/s3c2410fb.c b/drivers/video/s3c2410fb.c
index 7da0027..5ffca2a 100644
--- a/drivers/video/s3c2410fb.c
+++ b/drivers/video/s3c2410fb.c
@@ -1119,7 +1119,7 @@ int __init s3c2410fb_init(void)
 	int ret = platform_driver_register(&s3c2410fb_driver);
 
 	if (ret == 0)
-		ret = platform_driver_register(&s3c2412fb_driver);;
+		ret = platform_driver_register(&s3c2412fb_driver);
 
 	return ret;
 }
diff --git a/drivers/watchdog/bcm47xx_wdt.c b/drivers/watchdog/bcm47xx_wdt.c
index 5c7011c..751c003 100644
--- a/drivers/watchdog/bcm47xx_wdt.c
+++ b/drivers/watchdog/bcm47xx_wdt.c
@@ -161,7 +161,7 @@ static long bcm47xx_wdt_ioctl(struct file *file,
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	int new_value, retval = -EINVAL;;
+	int new_value, retval = -EINVAL;
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index f5bbd9e..4d1b322 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -214,7 +214,7 @@ static int increase_reservation(unsigned long nr_pages)
 	page = balloon_first_page();
 	for (i = 0; i < nr_pages; i++) {
 		BUG_ON(page == NULL);
-		frame_list[i] = page_to_pfn(page);;
+		frame_list[i] = page_to_pfn(page);
 		page = balloon_next_page(page);
 	}
 
diff --git a/fs/autofs/dirhash.c b/fs/autofs/dirhash.c
index 2316e94..e947915 100644
--- a/fs/autofs/dirhash.c
+++ b/fs/autofs/dirhash.c
@@ -90,7 +90,7 @@ struct autofs_dir_ent *autofs_expire(struct super_block *sb,
 			DPRINTK(("autofs: not expirable (not a mounted directory): %s\n", ent->name));
 			continue;
 		}
-		while (d_mountpoint(path.dentry) && follow_down(&path));
+		while (d_mountpoint(path.dentry) && follow_down(&path))
 			;
 		umount_ok = may_umount(path.mnt);
 		path_put(&path);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c139222..ab326dd 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2605,7 +2605,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 								extent);
 				cs = btrfs_file_extent_offset(src, extent);
 				cl = btrfs_file_extent_num_bytes(src,
-								extent);;
+								extent);
 				if (btrfs_file_extent_compression(src,
 								  extent)) {
 					cs = 0;
diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index 3bb11be..3f2c2a3 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -136,7 +136,7 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
 	rc = dns_resolve_server_name_to_ip(*devname, &srvIP);
 	if (rc != 0) {
 		cERROR(1, ("%s: Failed to resolve server part of %s to IP: %d",
-			  __func__, *devname, rc));;
+			  __func__, *devname, rc));
 		goto compose_mount_options_err;
 	}
 	/* md_len = strlen(...) + 12 for 'sep+prefixpath='
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 519a0a6..6b4e5ae 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2525,7 +2525,7 @@ int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
 
 	INIT_LIST_HEAD(&meta_group_info[i]->bb_prealloc_list);
 	init_rwsem(&meta_group_info[i]->alloc_sem);
-	meta_group_info[i]->bb_free_root.rb_node = NULL;;
+	meta_group_info[i]->bb_free_root.rb_node = NULL;
 
 #ifdef DOUBLE_CHECK
 	{
diff --git a/fs/nfs/callback_xdr.c b/fs/nfs/callback_xdr.c
index e5a2dac..76b0aa0 100644
--- a/fs/nfs/callback_xdr.c
+++ b/fs/nfs/callback_xdr.c
@@ -222,7 +222,7 @@ static unsigned decode_sessionid(struct xdr_stream *xdr,
 
 	p = read_buf(xdr, len);
 	if (unlikely(p == NULL))
-		return htonl(NFS4ERR_RESOURCE);;
+		return htonl(NFS4ERR_RESOURCE);
 
 	memcpy(sid->data, p, len);
 	return 0;
diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index edfa60c..05ed815 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -143,7 +143,7 @@ static int ocfs2_get_quota_block(struct inode *inode, int block,
 		err = -EIO;
 		mlog_errno(err);
 	}
-	return err;;
+	return err;
 }
 
 /* Read data from global quotafile - avoid pagecache and such because we cannot
diff --git a/include/scsi/fc/fc_fc2.h b/include/scsi/fc/fc_fc2.h
index cff8a8c..f87777d 100644
--- a/include/scsi/fc/fc_fc2.h
+++ b/include/scsi/fc/fc_fc2.h
@@ -92,8 +92,7 @@ struct fc_esb {
 	__u8	_esb_resvd[4];
 	__u8	esb_service_params[112]; /* TBD */
 	__u8	esb_seq_status[8];	/* sequence statuses, 8 bytes each */
-} __attribute__((packed));;
-
+} __attribute__((packed));
 
 /*
  * Define expected size for ASSERTs.
diff --git a/kernel/trace/trace_hw_branches.c b/kernel/trace/trace_hw_branches.c
index ca7d7c4..23b6385 100644
--- a/kernel/trace/trace_hw_branches.c
+++ b/kernel/trace/trace_hw_branches.c
@@ -155,7 +155,7 @@ static enum print_line_t bts_trace_print_line(struct trace_iterator *iter)
 		    seq_print_ip_sym(seq, it->from, symflags) &&
 		    trace_seq_printf(seq, "\n"))
 			return TRACE_TYPE_HANDLED;
-		return TRACE_TYPE_PARTIAL_LINE;;
+		return TRACE_TYPE_PARTIAL_LINE;
 	}
 	return TRACE_TYPE_UNHANDLED;
 }
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index d030c53..2e33fe5 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -794,7 +794,7 @@ int cfg80211_wext_siwtxpower(struct net_device *dev,
 		return 0;
 	}
 
-	return rdev->ops->set_tx_power(wdev->wiphy, type, dbm);;
+	return rdev->ops->set_tx_power(wdev->wiphy, type, dbm);
 }
 EXPORT_SYMBOL_GPL(cfg80211_wext_siwtxpower);
 
diff --git a/sound/oss/sys_timer.c b/sound/oss/sys_timer.c
index 1075344..8db6aef 100644
--- a/sound/oss/sys_timer.c
+++ b/sound/oss/sys_timer.c
@@ -100,9 +100,6 @@ def_tmr_open(int dev, int mode)
 	curr_tempo = 60;
 	curr_timebase = 100;
 	opened = 1;
-
-	;
-
 	{
 		def_tmr.expires = (1) + jiffies;
 		add_timer(&def_tmr);
diff --git a/sound/soc/codecs/wm9081.c b/sound/soc/codecs/wm9081.c
index 86fc57e..220eebc 100644
--- a/sound/soc/codecs/wm9081.c
+++ b/sound/soc/codecs/wm9081.c
@@ -1079,7 +1079,7 @@ static int wm9081_hw_params(struct snd_pcm_substream *substream,
 		       - wm9081->fs);
 	for (i = 1; i < ARRAY_SIZE(clk_sys_rates); i++) {
 		cur_val = abs((wm9081->sysclk_rate /
-			       clk_sys_rates[i].ratio) - wm9081->fs);;
+			       clk_sys_rates[i].ratio) - wm9081->fs);
 		if (cur_val < best_val) {
 			best = i;
 			best_val = cur_val;
diff --git a/sound/soc/pxa/pxa-ssp.c b/sound/soc/pxa/pxa-ssp.c
index 19c4540..af87986 100644
--- a/sound/soc/pxa/pxa-ssp.c
+++ b/sound/soc/pxa/pxa-ssp.c
@@ -351,7 +351,7 @@ static int pxa_ssp_set_dai_pll(struct snd_soc_dai *cpu_dai,
 			do_div(tmp, freq_out);
 			val = tmp;
 
-			val = (val << 16) | 64;;
+			val = (val << 16) | 64;
 			ssp_write_reg(ssp, SSACDD, val);
 
 			ssacd |= (0x6 << 4);
diff --git a/sound/soc/s3c24xx/s3c24xx_uda134x.c b/sound/soc/s3c24xx/s3c24xx_uda134x.c
index 8e79a41..c215d32 100644
--- a/sound/soc/s3c24xx/s3c24xx_uda134x.c
+++ b/sound/soc/s3c24xx/s3c24xx_uda134x.c
@@ -67,7 +67,7 @@ static int s3c24xx_uda134x_startup(struct snd_pcm_substream *substream)
 {
 	int ret = 0;
 #ifdef ENFORCE_RATES
-	struct snd_pcm_runtime *runtime = substream->runtime;;
+	struct snd_pcm_runtime *runtime = substream->runtime;
 #endif
 
 	mutex_lock(&clk_lock);


