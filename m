Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbZK1Lyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbZK1Lyx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 06:54:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbZK1Lyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 06:54:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589AbZK1Lym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 06:54:42 -0500
Message-ID: <4B110F79.8080405@redhat.com>
Date: Sat, 28 Nov 2009 12:54:33 +0100
From: Stefan Assmann <sassmann@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: linux-pci@vger.kernel.org
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Krzysztof Halasa <khc@pm.waw.pl>, Don Dutile <ddutile@redhat.com>,
       kaneshige.kenji@jp.fujitsu.com
Subject: [PATCH] change PCI nomenclature according to PCI-SIG
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Assmann <sassmann@redhat.com>

Changing occurrences of variants of PCI-X and PCIe to the PCI-SIG
terms listed in the "Trademark and Logo Usage Guidelines".
http://www.pcisig.com/developers/procedures/logos/Trademark_and_Logo_Usage_Guidelines_updated_112206.pdf
Additionally some renames of Gb/s to GT/s where appropriate, concerns PCIe.

This is a followup to the discussion at:
http://lkml.org/lkml/2009/10/14/107
Patch is based on 2.6.32-rc8.

Signed-off-by: Stefan Assmann <sassmann@redhat.com>
---
 Documentation/PCI/pci-error-recovery.txt         |    2 +-
 Documentation/PCI/pcieaer-howto.txt              |   12 ++--
 Documentation/kernel-parameters.txt              |    2 +-
 Documentation/networking/cxgb.txt                |    2 +-
 Documentation/networking/s2io.txt                |    2 +-
 Documentation/powerpc/eeh-pci-error-recovery.txt |    2 +-
 arch/arm/mach-iop13xx/include/mach/iop13xx.h     |   12 ++--
 arch/arm/mach-iop13xx/pci.c                      |   14 +++---
 arch/arm/mach-iop13xx/setup.c                    |    4 +-
 arch/arm/mach-realview/Kconfig                   |    4 +-
 arch/arm/plat-orion/pcie.c                       |    2 +-
 arch/ia64/include/asm/sn/pic.h                   |    2 +-
 arch/ia64/include/asm/sn/tiocp.h                 |    2 +-
 arch/ia64/sn/pci/pcibr/pcibr_reg.c               |    2 +-
 arch/powerpc/boot/dts/mpc8548cds.dts             |    8 ++--
 arch/powerpc/include/asm/pci-bridge.h            |    6 +-
 arch/powerpc/platforms/cell/setup.c              |    4 +-
 arch/powerpc/platforms/pseries/eeh.c             |   12 ++--
 arch/powerpc/sysdev/fsl_pci.c                    |    8 ++--
 arch/powerpc/sysdev/fsl_pci.h                    |   34 ++++++------
 arch/powerpc/sysdev/ppc4xx_pci.c                 |   60 +++++++++++-----------
 arch/sh/drivers/pci/pcie-sh7786.h                |    2 +-
 arch/sparc/kernel/pci_fire.c                     |    4 +-
 arch/sparc/kernel/pci_impl.h                     |    2 +-
 drivers/char/agp/intel-agp.c                     |    2 +-
 drivers/edac/amd8131_edac.c                      |    2 +-
 drivers/edac/amd8131_edac.h                      |    6 +-
 drivers/edac/mv64x60_edac.h                      |    2 +-
 drivers/edac/ppc4xx_edac.c                       |    4 +-
 drivers/firewire/ohci.c                          |    2 +-
 drivers/firmware/edd.c                           |    2 +-
 drivers/gpu/drm/i810/i810_dma.c                  |    2 +-
 drivers/gpu/drm/i830/i830_dma.c                  |    2 +-
 drivers/gpu/drm/i915/i915_dma.c                  |    2 +-
 drivers/gpu/drm/radeon/atombios.h                |   18 +++---
 drivers/gpu/drm/radeon/r100.c                    |    2 +-
 drivers/gpu/drm/radeon/r300.c                    |   10 ++--
 drivers/gpu/drm/radeon/r600.c                    |    6 +-
 drivers/gpu/drm/radeon/r600_cp.c                 |    4 +-
 drivers/gpu/drm/radeon/radeon_cp.c               |    2 +-
 drivers/gpu/drm/radeon/radeon_device.c           |    8 ++--
 drivers/gpu/drm/radeon/radeon_drv.h              |    4 +-
 drivers/gpu/drm/radeon/radeon_reg.h              |    2 +-
 drivers/gpu/drm/radeon/radeon_state.c            |    2 +-
 drivers/gpu/drm/radeon/rs600.c                   |    2 +-
 drivers/gpu/drm/radeon/rv770.c                   |    2 +-
 drivers/hwmon/abituguru3.c                       |   18 +++---
 drivers/infiniband/hw/ipath/ipath_driver.c       |    2 +-
 drivers/infiniband/hw/ipath/ipath_iba6110.c      |    2 +-
 drivers/infiniband/hw/ipath/ipath_iba6120.c      |    4 +-
 drivers/infiniband/hw/ipath/ipath_iba7220.c      |    2 +-
 drivers/message/fusion/mptbase.h                 |    2 +-
 drivers/net/Kconfig                              |    2 +-
 drivers/net/atl1c/atl1c_main.c                   |    4 +-
 drivers/net/atl1e/atl1e_hw.c                     |    2 +-
 drivers/net/atl1e/atl1e_main.c                   |    6 +-
 drivers/net/atlx/atl1.c                          |    8 ++--
 drivers/net/atlx/atl2.c                          |    4 +-
 drivers/net/bnx2.c                               |    6 +-
 drivers/net/bnx2x.h                              |    2 +-
 drivers/net/bnx2x_main.c                         |    6 +-
 drivers/net/chelsio/cxgb2.c                      |    2 +-
 drivers/net/chelsio/subr.c                       |    4 +-
 drivers/net/cxgb3/t3_hw.c                        |    2 +-
 drivers/net/e1000/e1000_hw.h                     |   18 +++---
 drivers/net/e1000/e1000_main.c                   |    2 +-
 drivers/net/e1000e/82571.c                       |    6 +-
 drivers/net/e1000e/defines.h                     |    2 +-
 drivers/net/e1000e/es2lan.c                      |    4 +-
 drivers/net/e1000e/ethtool.c                     |    2 +-
 drivers/net/e1000e/hw.h                          |    4 +-
 drivers/net/e1000e/ich8lan.c                     |    4 +-
 drivers/net/e1000e/lib.c                         |    2 +-
 drivers/net/igb/e1000_82575.c                    |    6 +-
 drivers/net/igb/e1000_defines.h                  |    2 +-
 drivers/net/igb/e1000_mac.c                      |    2 +-
 drivers/net/igb/e1000_regs.h                     |    2 +-
 drivers/net/igb/igb_main.c                       |    2 +-
 drivers/net/ixgbe/ixgbe_82598.c                  |    4 +-
 drivers/net/ixgbe/ixgbe_82599.c                  |    4 +-
 drivers/net/ixgbe/ixgbe_common.c                 |    6 +-
 drivers/net/ixgbe/ixgbe_main.c                   |    4 +-
 drivers/net/ixgbe/ixgbe_type.h                   |    2 +-
 drivers/net/myri10ge/myri10ge.c                  |   14 +++---
 drivers/net/myri10ge/myri10ge_mcp.h              |    4 +-
 drivers/net/netxen/netxen_nic_hw.c               |    4 +-
 drivers/net/qlge/qlge.h                          |    2 +-
 drivers/net/r8169.c                              |   42 ++++++++--------
 drivers/net/s2io.c                               |   16 +++---
 drivers/net/sfc/falcon_hwdefs.h                  |    2 +-
 drivers/net/sky2.h                               |   12 ++--
 drivers/net/tehuti.c                             |    8 ++--
 drivers/net/tehuti.h                             |    4 +-
 drivers/net/tg3.c                                |   12 ++--
 drivers/net/wireless/ath/ath5k/ath5k.h           |    6 +-
 drivers/net/wireless/ath/ath5k/attach.c          |    4 +-
 drivers/net/wireless/ath/ath5k/base.c            |    2 +-
 drivers/net/wireless/ath/ath5k/eeprom.h          |    2 +-
 drivers/net/wireless/ath/ath5k/reg.h             |    6 +-
 drivers/net/wireless/ath/ath5k/reset.c           |   10 ++--
 drivers/net/wireless/ath/ath9k/pci.c             |    8 ++--
 drivers/pci/hotplug/pci_hotplug_core.c           |   22 ++++----
 drivers/pci/hotplug/pciehp_hpc.c                 |    8 ++--
 drivers/pci/hotplug/shpchp.h                     |    2 +-
 drivers/pci/intr_remapping.c                     |    2 +-
 drivers/pci/pci.c                                |    6 +-
 drivers/pci/pcie/aer/Kconfig.debug               |    4 +-
 drivers/pci/pcie/aer/aer_inject.c                |    6 +-
 drivers/pci/pcie/aer/aerdrv.c                    |    2 +-
 drivers/pci/pcie/aer/aerdrv_acpi.c               |    2 +-
 drivers/pci/pcie/aer/aerdrv_core.c               |    6 +-
 drivers/pci/pcie/aer/aerdrv_errprint.c           |    4 +-
 drivers/pci/pcie/aspm.c                          |    4 +-
 drivers/pci/pcie/portdrv_pci.c                   |    2 +-
 drivers/pci/search.c                             |    4 +-
 drivers/scsi/aic7xxx/aic79xx.h                   |    6 +-
 drivers/scsi/aic7xxx/aic79xx_core.c              |    2 +-
 drivers/scsi/aic7xxx/aic79xx_pci.c               |    4 +-
 drivers/scsi/aic94xx/aic94xx_hwi.c               |    2 +-
 drivers/scsi/mvsas/Kconfig                       |    4 +-
 drivers/scsi/mvsas/mv_chips.h                    |    2 +-
 drivers/scsi/mvsas/mv_defs.h                     |    2 +-
 drivers/ssb/driver_pcicore.c                     |    2 +-
 drivers/ssb/scan.c                               |    6 +-
 drivers/staging/phison/Kconfig                   |    2 +-
 drivers/staging/phison/phison.c                  |    2 +-
 drivers/staging/rt2860/rt_main_dev.c             |    2 +-
 drivers/staging/rt3090/common/cmm_mac_pci.c      |    2 +-
 drivers/staging/rt3090/common/mlme.c             |    4 +-
 drivers/staging/rt3090/common/rtmp_init.c        |    2 +-
 drivers/staging/rt3090/pci_main_dev.c            |    4 +-
 drivers/staging/rtl8192e/r8192E_core.c           |    2 +-
 drivers/staging/rtl8192su/r8192S_hw.h            |   16 +++---
 drivers/staging/slicoss/Kconfig                  |    2 +-
 drivers/staging/slicoss/README                   |    2 +-
 drivers/staging/slicoss/slicoss.c                |    2 +-
 include/linux/pci.h                              |    6 +-
 include/linux/pci_hotplug.h                      |    4 +-
 include/linux/ssb/ssb_driver_pci.h               |    2 +-
 139 files changed, 382 insertions(+), 382 deletions(-)

diff --git a/Documentation/PCI/pci-error-recovery.txt b/Documentation/PCI/pci-error-recovery.txt
index e83f2ea..96b0be1 100644
--- a/Documentation/PCI/pci-error-recovery.txt
+++ b/Documentation/PCI/pci-error-recovery.txt
@@ -12,7 +12,7 @@
 Many PCI bus controllers are able to detect a variety of hardware
 PCI errors on the bus, such as parity errors on the data and address
 busses, as well as SERR and PERR errors.  Some of the more advanced
-chipsets are able to deal with these errors; these include PCI-E chipsets,
+chipsets are able to deal with these errors; these include PCIe chipsets,
 and the PCI-host bridges found on IBM Power4, Power5 and Power6-based
 pSeries boxes. A typical action taken is to disconnect the affected device,
 halting all I/O to it.  The goal of a disconnection is to avoid system
diff --git a/Documentation/PCI/pcieaer-howto.txt b/Documentation/PCI/pcieaer-howto.txt
index be21001..d09d17a 100644
--- a/Documentation/PCI/pcieaer-howto.txt
+++ b/Documentation/PCI/pcieaer-howto.txt
@@ -66,7 +66,7 @@ hardware (mostly chipsets) has root ports that cannot obtain the reporting
 source ID. nosourceid=n by default.

 2.3 AER error output
-When a PCI-E AER error is captured, an error message will be outputed to
+When a PCIe AER error is captured, an error message will be outputed to
 console. If it's a correctable error, it is outputed as a warning.
 Otherwise, it is printed as an error. So users could choose different
 log level to filter out correctable error messages.
@@ -74,7 +74,7 @@ log level to filter out correctable error messages.
 Below shows an example.
 +------ PCI-Express Device Error -----+
 Error Severity          : Uncorrected (Fatal)
-PCIE Bus Error type     : Transaction Layer
+PCIe Bus Error type     : Transaction Layer
 Unsupported Request     : First
 Requester ID            : 0500
 VendorID=8086h, DeviceID=0329h, Bus=05h, Device=00h, Function=00h
@@ -112,7 +112,7 @@ but the PCI Express link itself is fully functional. Fatal errors, on
 the other hand, cause the link to be unreliable.

 When AER is enabled, a PCI Express device will automatically send an
-error message to the PCIE root port above it when the device captures
+error message to the PCIe root port above it when the device captures
 an error. The Root Port, upon receiving an error reporting message,
 internally processes and logs the error message in its PCI Express
 capability structure. Error information being logged includes storing
@@ -253,11 +253,11 @@ cleanup uncorrectable status register. Pls. refer to section 3.3.

 4. Software error injection

-Debugging PCIE AER error recovery code is quite difficult because it
+Debugging PCIe AER error recovery code is quite difficult because it
 is hard to trigger real hardware errors. Software based error
-injection can be used to fake various kinds of PCIE errors.
+injection can be used to fake various kinds of PCIe errors.

-First you should enable PCIE AER software error injection in kernel
+First you should enable PCIe AER software error injection in kernel
 configuration, that is, following item should be in your .config.

 CONFIG_PCIEAER_INJECT=y or CONFIG_PCIEAER_INJECT=m
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 9107b38..ccd4b55 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1856,7 +1856,7 @@ and is between 256 and 4096 characters. It is defined in the file
 				Mechanism 2.
 		noaer		[PCIE] If the PCIEAER kernel config parameter is
 				enabled, this kernel boot option can be used to
-				disable the use of PCIE advanced error reporting.
+				disable the use of PCIe advanced error reporting.
 		nodomains	[PCI] Disable support for multiple PCI
 				root domains (aka PCI segments, in ACPI-speak).
 		nommconf	[X86] Disable use of MMCONFIG for PCI
diff --git a/Documentation/networking/cxgb.txt b/Documentation/networking/cxgb.txt
index 20a8876..1cfa30d 100644
--- a/Documentation/networking/cxgb.txt
+++ b/Documentation/networking/cxgb.txt
@@ -188,7 +188,7 @@ DRIVER MESSAGES
      Chelsio Network Driver - version 2.1.1

   NIC detected:
-     eth#: Chelsio N210 1x10GBaseX NIC (rev #), PCIX 133MHz/64-bit
+     eth#: Chelsio N210 1x10GBaseX NIC (rev #), PCI-X 133MHz/64-bit

   Link up:
      eth#: link is up at 10 Gbps, full duplex
diff --git a/Documentation/networking/s2io.txt b/Documentation/networking/s2io.txt
index c3d6b4d..c4e3458 100644
--- a/Documentation/networking/s2io.txt
+++ b/Documentation/networking/s2io.txt
@@ -26,7 +26,7 @@ c. View log messages
 You will see messages similar to:
 eth3: Neterion Xframe I 10GbE adapter (rev 3), Version 2.0.9.1, Intr type INTA
 eth4: Neterion Xframe II 10GbE adapter (rev 2), Version 2.0.9.1, Intr type INTA
-eth4: Device is on 64 bit 133MHz PCIX(M1) bus
+eth4: Device is on 64 bit 133MHz PCI-X(M1) bus

 The above messages identify the adapter type(Xframe I/II), adapter revision,
 driver version, interface name(eth3, eth4), Interrupt type(INTA, MSI, MSI-X).
diff --git a/Documentation/powerpc/eeh-pci-error-recovery.txt b/Documentation/powerpc/eeh-pci-error-recovery.txt
index 9d4e33d..2a248e4 100644
--- a/Documentation/powerpc/eeh-pci-error-recovery.txt
+++ b/Documentation/powerpc/eeh-pci-error-recovery.txt
@@ -27,7 +27,7 @@ the idea behind EEH is that the operating system can become more
 reliable and robust by protecting it from PCI errors, and giving
 the OS the ability to "reboot"/recover individual PCI devices.

-Future systems from other vendors, based on the PCI-E specification,
+Future systems from other vendors, based on the PCIe specification,
 may contain similar features.


diff --git a/arch/arm/mach-iop13xx/include/mach/iop13xx.h b/arch/arm/mach-iop13xx/include/mach/iop13xx.h
index 52b7fab..73f7530 100644
--- a/arch/arm/mach-iop13xx/include/mach/iop13xx.h
+++ b/arch/arm/mach-iop13xx/include/mach/iop13xx.h
@@ -63,12 +63,12 @@ extern unsigned long get_iop_tick_rate(void);
 /* PCI MAP
  * bus range		cpu phys	cpu virt	note
  * 0x0000.0000 + 2GB	(n/a)		(n/a)		inbound, 1:1 mapping with Physical RAM
- * 0x8000.0000 + 928M	0x1.8000.0000   (ioremap)	PCIX outbound memory window
- * 0x8000.0000 + 928M	0x2.8000.0000   (ioremap)	PCIE outbound memory window
+ * 0x8000.0000 + 928M	0x1.8000.0000   (ioremap)	PCI-X outbound memory window
+ * 0x8000.0000 + 928M	0x2.8000.0000   (ioremap)	PCIe outbound memory window
  *
  * IO MAP
- * 0x1000 + 64K	0x0.fffb.1000	0xfec6.1000	PCIX outbound i/o window
- * 0x1000 + 64K	0x0.fffd.1000	0xfed7.1000	PCIE outbound i/o window
+ * 0x1000 + 64K	0x0.fffb.1000	0xfec6.1000	PCI-X outbound i/o window
+ * 0x1000 + 64K	0x0.fffd.1000	0xfed7.1000	PCIe outbound i/o window
  */
 #define IOP13XX_PCIX_IO_WINDOW_SIZE   0x10000UL
 #define IOP13XX_PCIX_LOWER_IO_PA      0xfffb0000UL
@@ -100,7 +100,7 @@ extern unsigned long get_iop_tick_rate(void);
 #define IOP13XX_PCIX_MEM_OFFSET        (IOP13XX_PCIX_MEM_COOKIE -\
 					IOP13XX_PCIX_LOWER_MEM_BA)

-/* PCI-E ranges */
+/* PCIe ranges */
 #define IOP13XX_PCIE_IO_WINDOW_SIZE   	 0x10000UL
 #define IOP13XX_PCIE_LOWER_IO_PA      	 0xfffd0000UL
 #define IOP13XX_PCIE_LOWER_IO_VA      	 0xfed70000UL
@@ -228,7 +228,7 @@ extern unsigned long get_iop_tick_rate(void);
 #define IOP13XX_ESSR0_PMMR_OFFSET  	0x00002188
 #define IOP13XX_ESSR0			IOP13XX_REG_ADDR32(0x00002188)

-#define IOP13XX_ESSR0_IFACE_MASK   	0x00004000  /* Interface PCI-X / PCI-E */
+#define IOP13XX_ESSR0_IFACE_MASK   	0x00004000  /* Interface PCI-X / PCIe */
 #define IOP13XX_CONTROLLER_ONLY    	(1 << 14)
 #define IOP13XX_INTERFACE_SEL_PCIX 	(1 << 15)

diff --git a/arch/arm/mach-iop13xx/pci.c b/arch/arm/mach-iop13xx/pci.c
index 4873f26..b8a21c2 100644
--- a/arch/arm/mach-iop13xx/pci.c
+++ b/arch/arm/mach-iop13xx/pci.c
@@ -362,20 +362,20 @@ static int iop13xx_atue_pci_status(int clear)
 				IOP13XX_ATUE_ATUISR);
 		err++;

-		/* check the PCI-E status if the ATUISR reports an interface error */
+		/* check the PCIe status if the ATUISR reports an interface error */
 		if (status & IOP13XX_ATUE_STAT_PCI_IFACE_ERR) {
 			/* get the unmasked errors */
 			status = __raw_readl(IOP13XX_ATUE_PIE_STS) &
 					~(__raw_readl(IOP13XX_ATUE_PIE_MSK));

 			if (status) {
-				PRINTK("\t\t\tPCI-E error: ATUE_PIE_STS %#08x",
+				PRINTK("\t\t\tPCIe error: ATUE_PIE_STS %#08x",
 					__raw_readl(IOP13XX_ATUE_PIE_STS));
 				err++;
 			} else {
-				PRINTK("\t\t\tPCI-E error: ATUE_PIE_STS %#08x",
+				PRINTK("\t\t\tPCIe error: ATUE_PIE_STS %#08x",
 					__raw_readl(IOP13XX_ATUE_PIE_STS));
-				PRINTK("\t\t\tPCI-E error: ATUE_PIE_MSK %#08x",
+				PRINTK("\t\t\tPCIe error: ATUE_PIE_MSK %#08x",
 					__raw_readl(IOP13XX_ATUE_PIE_MSK));
 				BUG();
 			}
@@ -424,7 +424,7 @@ iop13xx_atue_read_config(struct pci_bus *bus, unsigned int devfn, int where,
 	u32 val;
 	unsigned long addr = iop13xx_atue_cfg_address(bus, devfn, where);

-	/* Hide device numbers > 0 on the local PCI-E bus (Type 0 access) */
+	/* Hide device numbers > 0 on the local PCIe bus (Type 0 access) */
 	if (!PCI_SLOT(devfn) || (addr & 1)) {
 		val = iop13xx_atue_read(addr) >> ((where & 3) * 8);
 		if( iop13xx_atue_pci_status(1) || is_atue_occdr_error() ) {
@@ -584,7 +584,7 @@ void __init iop13xx_atue_setup(void)
 	 __raw_writel(0x0, IOP13XX_ATUE_IAUTVR1);
 	 __raw_writel(PHYS_OFFSET, IOP13XX_ATUE_IATVR1);

-	/* Outbound window 1 (PCIX/PCIE memory window) */
+	/* Outbound window 1 (PCI-X/PCIe memory window) */
 	/* 32 bit Address Space */
 	__raw_writel(0x0, IOP13XX_ATUE_OUMWTVR1);
 	/* PA[35:32] */
@@ -753,7 +753,7 @@ void __init iop13xx_atux_setup(void)
 	__raw_writel(0x0, IOP13XX_ATUX_IAUTVR1);
 	__raw_writel(PHYS_OFFSET, IOP13XX_ATUX_IATVR1);

-	/* Outbound window 1 (PCIX/PCIE memory window) */
+	/* Outbound window 1 (PCI-X/PCIe memory window) */
 	/* 32 bit Address Space */
 	__raw_writel(0x0, IOP13XX_ATUX_OUMWTVR1);
 	/* PA[35:32] */
diff --git a/arch/arm/mach-iop13xx/setup.c b/arch/arm/mach-iop13xx/setup.c
index 5c147fb..4587caa 100644
--- a/arch/arm/mach-iop13xx/setup.c
+++ b/arch/arm/mach-iop13xx/setup.c
@@ -39,12 +39,12 @@ static struct map_desc iop13xx_std_desc[] __initdata = {
 		.pfn 	 = __phys_to_pfn(IOP13XX_PMMR_PHYS_MEM_BASE),
 		.length  = IOP13XX_PMMR_SIZE,
 		.type	 = MT_DEVICE,
-	}, { /* PCIE IO space */
+	}, { /* PCIe IO space */
 		.virtual = IOP13XX_PCIE_LOWER_IO_VA,
 		.pfn 	 = __phys_to_pfn(IOP13XX_PCIE_LOWER_IO_PA),
 		.length  = IOP13XX_PCIX_IO_WINDOW_SIZE,
 		.type	 = MT_DEVICE,
-	}, { /* PCIX IO space */
+	}, { /* PCI-X IO space */
 		.virtual = IOP13XX_PCIX_LOWER_IO_VA,
 		.pfn 	 = __phys_to_pfn(IOP13XX_PCIX_LOWER_IO_PA),
 		.length  = IOP13XX_PCIX_IO_WINDOW_SIZE,
diff --git a/arch/arm/mach-realview/Kconfig b/arch/arm/mach-realview/Kconfig
index c48e1f2..277eae4 100644
--- a/arch/arm/mach-realview/Kconfig
+++ b/arch/arm/mach-realview/Kconfig
@@ -38,7 +38,7 @@ config MACH_REALVIEW_PB11MP
 	help
 	  Include support for the ARM(R) RealView MPCore Platform Baseboard.
 	  PB11MPCore is a platform with an on-board ARM11MPCore and has
-	  support for PCI-E and Compact Flash.
+	  support for PCIe and Compact Flash.

 config MACH_REALVIEW_PB1176
 	bool "Support RealView/PB1176 platform"
@@ -64,7 +64,7 @@ config MACH_REALVIEW_PBA8
 	help
 	  Include support for the ARM(R) RealView Cortex-A8 Platform Baseboard.
 	  PB-A8 is a platform with an on-board Cortex-A8 and has support for
-	  PCI-E and Compact Flash.
+	  PCIe and Compact Flash.

 config MACH_REALVIEW_PBX
 	bool "Support RealView/PBX platform"
diff --git a/arch/arm/plat-orion/pcie.c b/arch/arm/plat-orion/pcie.c
index d41d41d..e1a5531 100644
--- a/arch/arm/plat-orion/pcie.c
+++ b/arch/arm/plat-orion/pcie.c
@@ -86,7 +86,7 @@ void __init orion_pcie_set_local_bus_nr(void __iomem *base, int nr)
 }

 /*
- * Setup PCIE BARs and Address Decode Wins:
+ * Setup PCIe BARs and Address Decode Wins:
  * BAR[0,2] -> disabled, BAR[1] -> covers all DRAM banks
  * WIN[0-3] -> DRAM bank[0-3]
  */
diff --git a/arch/ia64/include/asm/sn/pic.h b/arch/ia64/include/asm/sn/pic.h
index 5f9da5f..6213207 100644
--- a/arch/ia64/include/asm/sn/pic.h
+++ b/arch/ia64/include/asm/sn/pic.h
@@ -249,7 +249,7 @@ struct pic {

     char		_pad_030007[0x040000-0x030008];

-    /* 0x040000-0x030007 -- PCIX Special Cycle */
+    /* 0x040000-0x030007 -- PCI-X Special Cycle */
     union {
 	u8		c[8 / 1];
 	u16	s[8 / 2];
diff --git a/arch/ia64/include/asm/sn/tiocp.h b/arch/ia64/include/asm/sn/tiocp.h
index e8ad0bb..db1757f 100644
--- a/arch/ia64/include/asm/sn/tiocp.h
+++ b/arch/ia64/include/asm/sn/tiocp.h
@@ -220,7 +220,7 @@ struct tiocp{

     char		_pad_030007[0x040000-0x030008];

-    /* 0x040000-0x040007 -- PCIX Special Cycle */
+    /* 0x040000-0x040007 -- PCI-X Special Cycle */
     union {
 	u8	c[8 / 1];
 	u16	s[8 / 2];
diff --git a/arch/ia64/sn/pci/pcibr/pcibr_reg.c b/arch/ia64/sn/pci/pcibr/pcibr_reg.c
index 8b8bbd5..76fc813 100644
--- a/arch/ia64/sn/pci/pcibr/pcibr_reg.c
+++ b/arch/ia64/sn/pci/pcibr/pcibr_reg.c
@@ -64,7 +64,7 @@ void pcireg_control_bit_set(struct pcibus_info *pcibus_info, u64 bits)
 }

 /*
- * PCI/PCIX Target Flush Register Access -- Read Only		    0000_0050
+ * PCI/PCI-X Target Flush Register Access -- Read Only		    0000_0050
  */
 u64 pcireg_tflush_get(struct pcibus_info *pcibus_info)
 {
diff --git a/arch/powerpc/boot/dts/mpc8548cds.dts b/arch/powerpc/boot/dts/mpc8548cds.dts
index 4173af3..4b52d89 100644
--- a/arch/powerpc/boot/dts/mpc8548cds.dts
+++ b/arch/powerpc/boot/dts/mpc8548cds.dts
@@ -362,25 +362,25 @@
 	pci0: pci@e0008000 {
 		interrupt-map-mask = <0xf800 0x0 0x0 0x7>;
 		interrupt-map = <
-			/* IDSEL 0x4 (PCIX Slot 2) */
+			/* IDSEL 0x4 (PCI-X Slot 2) */
 			0x2000 0x0 0x0 0x1 &mpic 0x0 0x1
 			0x2000 0x0 0x0 0x2 &mpic 0x1 0x1
 			0x2000 0x0 0x0 0x3 &mpic 0x2 0x1
 			0x2000 0x0 0x0 0x4 &mpic 0x3 0x1

-			/* IDSEL 0x5 (PCIX Slot 3) */
+			/* IDSEL 0x5 (PCI-X Slot 3) */
 			0x2800 0x0 0x0 0x1 &mpic 0x1 0x1
 			0x2800 0x0 0x0 0x2 &mpic 0x2 0x1
 			0x2800 0x0 0x0 0x3 &mpic 0x3 0x1
 			0x2800 0x0 0x0 0x4 &mpic 0x0 0x1

-			/* IDSEL 0x6 (PCIX Slot 4) */
+			/* IDSEL 0x6 (PCI-X Slot 4) */
 			0x3000 0x0 0x0 0x1 &mpic 0x2 0x1
 			0x3000 0x0 0x0 0x2 &mpic 0x3 0x1
 			0x3000 0x0 0x0 0x3 &mpic 0x0 0x1
 			0x3000 0x0 0x0 0x4 &mpic 0x1 0x1

-			/* IDSEL 0x8 (PCIX Slot 5) */
+			/* IDSEL 0x8 (PCI-X Slot 5) */
 			0x4000 0x0 0x0 0x1 &mpic 0x0 0x1
 			0x4000 0x0 0x0 0x2 &mpic 0x1 0x1
 			0x4000 0x0 0x0 0x3 &mpic 0x2 0x1
diff --git a/arch/powerpc/include/asm/pci-bridge.h b/arch/powerpc/include/asm/pci-bridge.h
index 76e1f31..25824c4 100644
--- a/arch/powerpc/include/asm/pci-bridge.h
+++ b/arch/powerpc/include/asm/pci-bridge.h
@@ -105,12 +105,12 @@ struct pci_controller {
 	/*
 	 * Used for variants of PCI indirect handling and possible quirks:
 	 *  SET_CFG_TYPE - used on 4xx or any PHB that does explicit type0/1
-	 *  EXT_REG - provides access to PCI-e extended registers
+	 *  EXT_REG - provides access to PCIe extended registers
 	 *  SURPRESS_PRIMARY_BUS - we surpress the setting of PCI_PRIMARY_BUS
-	 *   on Freescale PCI-e controllers since they used the PCI_PRIMARY_BUS
+	 *   on Freescale PCIe controllers since they used the PCI_PRIMARY_BUS
 	 *   to determine which bus number to match on when generating type0
 	 *   config cycles
-	 *  NO_PCIE_LINK - the Freescale PCI-e controllers have issues with
+	 *  NO_PCIE_LINK - the Freescale PCIe controllers have issues with
 	 *   hanging if we don't have link and try to do config cycles to
 	 *   anything but the PHB.  Only allow talking to the PHB if this is
 	 *   set.
diff --git a/arch/powerpc/platforms/cell/setup.c b/arch/powerpc/platforms/cell/setup.c
index 5930536..0270dc4 100644
--- a/arch/powerpc/platforms/cell/setup.c
+++ b/arch/powerpc/platforms/cell/setup.c
@@ -98,7 +98,7 @@ static void cell_fixup_pcie_rootcomplex(struct pci_dev *dev)
 	if (hose == NULL)
 		return;

-	/* Only on PCIE */
+	/* Only on PCIe */
 	if (!of_device_is_compatible(hose->dn, "pciex"))
 		return;

@@ -112,7 +112,7 @@ static void cell_fixup_pcie_rootcomplex(struct pci_dev *dev)
 		dev->resource[i].flags = 0;
 	}

-	printk(KERN_DEBUG "PCI: Hiding resources on Axon PCIE RC %s\n",
+	printk(KERN_DEBUG "PCI: Hiding resources on Axon PCIe RC %s\n",
 	       pci_name(dev));
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_ANY_ID, PCI_ANY_ID, cell_fixup_pcie_rootcomplex);
diff --git a/arch/powerpc/platforms/pseries/eeh.c b/arch/powerpc/platforms/pseries/eeh.c
index ccd8dd0..3d7e99e 100644
--- a/arch/powerpc/platforms/pseries/eeh.c
+++ b/arch/powerpc/platforms/pseries/eeh.c
@@ -216,29 +216,29 @@ static size_t gather_pci_data(struct pci_dn *pdn, char * buf, size_t len)
 		printk(KERN_WARNING "EEH: PCI-X status: %08x\n", cfg);
 	}

-	/* If PCI-E capable, dump PCI-E cap 10, and the AER */
+	/* If PCIe capable, dump PCIe cap 10, and the AER */
 	cap = pci_find_capability(dev, PCI_CAP_ID_EXP);
 	if (cap) {
 		n += scnprintf(buf+n, len-n, "pci-e cap10:\n");
 		printk(KERN_WARNING
-		       "EEH: PCI-E capabilities and status follow:\n");
+		       "EEH: PCIe capabilities and status follow:\n");

 		for (i=0; i<=8; i++) {
 			rtas_read_config(pdn, cap+4*i, 4, &cfg);
 			n += scnprintf(buf+n, len-n, "%02x:%x\n", 4*i, cfg);
-			printk(KERN_WARNING "EEH: PCI-E %02x: %08x\n", i, cfg);
+			printk(KERN_WARNING "EEH: PCIe %02x: %08x\n", i, cfg);
 		}

 		cap = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ERR);
 		if (cap) {
 			n += scnprintf(buf+n, len-n, "pci-e AER:\n");
 			printk(KERN_WARNING
-			       "EEH: PCI-E AER capability register set follows:\n");
+			       "EEH: PCIe AER capability register set follows:\n");

 			for (i=0; i<14; i++) {
 				rtas_read_config(pdn, cap+4*i, 4, &cfg);
 				n += scnprintf(buf+n, len-n, "%02x:%x\n", 4*i, cfg);
-				printk(KERN_WARNING "EEH: PCI-E AER %02x: %08x\n", i, cfg);
+				printk(KERN_WARNING "EEH: PCIe AER %02x: %08x\n", i, cfg);
 			}
 		}
 	}
@@ -706,7 +706,7 @@ rtas_pci_slot_reset(struct pci_dn *pdn, int state)
 }

 /**
- * pcibios_set_pcie_slot_reset - Set PCI-E reset state
+ * pcibios_set_pcie_slot_reset - Set PCIe reset state
  * @dev:	pci device struct
  * @state:	reset state to enter
  *
diff --git a/arch/powerpc/sysdev/fsl_pci.c b/arch/powerpc/sysdev/fsl_pci.c
index ae88b14..ab4d6c0 100644
--- a/arch/powerpc/sysdev/fsl_pci.c
+++ b/arch/powerpc/sysdev/fsl_pci.c
@@ -1,5 +1,5 @@
 /*
- * MPC83xx/85xx/86xx PCI/PCIE support routing.
+ * MPC83xx/85xx/86xx PCI/PCIe support routing.
  *
  * Copyright 2007-2009 Freescale Semiconductor, Inc.
  * Copyright 2008-2009 MontaVista Software, Inc.
@@ -413,7 +413,7 @@ struct mpc83xx_pcie_priv {
 };

 /*
- * With the convention of u-boot, the PCIE outbound window 0 serves
+ * With the convention of u-boot, the PCIe outbound window 0 serves
  * as configuration transactions outbound.
  */
 #define PEX_OUTWIN0_BAR		0xCA4
@@ -428,7 +428,7 @@ static int mpc83xx_pcie_exclude_device(struct pci_bus *bus, unsigned int devfn)
 		return PCIBIOS_DEVICE_NOT_FOUND;
 	/*
 	 * Workaround for the HW bug: for Type 0 configure transactions the
-	 * PCI-E controller does not check the device number bits and just
+	 * PCIe controller does not check the device number bits and just
 	 * assumes that the device number bits are 0.
 	 */
 	if (bus->number == hose->first_busno ||
@@ -544,7 +544,7 @@ static int __init mpc83xx_pcie_setup(struct pci_controller *hose,

 	cfg_bar = in_le32(pcie->cfg_type0 + PEX_OUTWIN0_BAR);
 	if (!cfg_bar) {
-		/* PCI-E isn't configured. */
+		/* PCIe isn't configured. */
 		ret = -ENODEV;
 		goto err1;
 	}
diff --git a/arch/powerpc/sysdev/fsl_pci.h b/arch/powerpc/sysdev/fsl_pci.h
index a9d8bbe..a45956a 100644
--- a/arch/powerpc/sysdev/fsl_pci.h
+++ b/arch/powerpc/sysdev/fsl_pci.h
@@ -14,7 +14,7 @@
 #ifndef __POWERPC_FSL_PCI_H
 #define __POWERPC_FSL_PCI_H

-#define PCIE_LTSSM	0x0404		/* PCIE Link Training and Status */
+#define PCIE_LTSSM	0x0404		/* PCIe Link Training and Status */
 #define PCIE_LTSSM_L0	0x16		/* L0 state */
 #define PIWAR_EN		0x80000000	/* Enable */
 #define PIWAR_PF		0x20000000	/* prefetch */
@@ -44,16 +44,16 @@ struct pci_inbound_window_regs {

 /* PCI/PCI Express IO block registers for 85xx/86xx */
 struct ccsr_pci {
-	__be32	config_addr;		/* 0x.000 - PCI/PCIE Configuration Address Register */
-	__be32	config_data;		/* 0x.004 - PCI/PCIE Configuration Data Register */
+	__be32	config_addr;		/* 0x.000 - PCI/PCIe Configuration Address Register */
+	__be32	config_data;		/* 0x.004 - PCI/PCIe Configuration Data Register */
 	__be32	int_ack;		/* 0x.008 - PCI Interrupt Acknowledge Register */
-	__be32	pex_otb_cpl_tor;	/* 0x.00c - PCIE Outbound completion timeout register */
-	__be32	pex_conf_tor;		/* 0x.010 - PCIE configuration timeout register */
+	__be32	pex_otb_cpl_tor;	/* 0x.00c - PCIe Outbound completion timeout register */
+	__be32	pex_conf_tor;		/* 0x.010 - PCIe configuration timeout register */
 	u8	res2[12];
-	__be32	pex_pme_mes_dr;		/* 0x.020 - PCIE PME and message detect register */
-	__be32	pex_pme_mes_disr;	/* 0x.024 - PCIE PME and message disable register */
-	__be32	pex_pme_mes_ier;	/* 0x.028 - PCIE PME and message interrupt enable register */
-	__be32	pex_pmcr;		/* 0x.02c - PCIE power management command register */
+	__be32	pex_pme_mes_dr;		/* 0x.020 - PCIe PME and message detect register */
+	__be32	pex_pme_mes_disr;	/* 0x.024 - PCIe PME and message disable register */
+	__be32	pex_pme_mes_ier;	/* 0x.028 - PCIe PME and message interrupt enable register */
+	__be32	pex_pmcr;		/* 0x.02c - PCIe power management command register */
 	u8	res3[3024];

 /* PCI/PCI Express outbound window 0-4
@@ -71,18 +71,18 @@ struct ccsr_pci {
  */
 	struct pci_inbound_window_regs piw[3];

-	__be32	pex_err_dr;		/* 0x.e00 - PCI/PCIE error detect register */
+	__be32	pex_err_dr;		/* 0x.e00 - PCI/PCIe error detect register */
 	u8	res21[4];
-	__be32	pex_err_en;		/* 0x.e08 - PCI/PCIE error interrupt enable register */
+	__be32	pex_err_en;		/* 0x.e08 - PCI/PCIe error interrupt enable register */
 	u8	res22[4];
-	__be32	pex_err_disr;		/* 0x.e10 - PCI/PCIE error disable register */
+	__be32	pex_err_disr;		/* 0x.e10 - PCI/PCIe error disable register */
 	u8	res23[12];
-	__be32	pex_err_cap_stat;	/* 0x.e20 - PCI/PCIE error capture status register */
+	__be32	pex_err_cap_stat;	/* 0x.e20 - PCI/PCIe error capture status register */
 	u8	res24[4];
-	__be32	pex_err_cap_r0;		/* 0x.e28 - PCIE error capture register 0 */
-	__be32	pex_err_cap_r1;		/* 0x.e2c - PCIE error capture register 0 */
-	__be32	pex_err_cap_r2;		/* 0x.e30 - PCIE error capture register 0 */
-	__be32	pex_err_cap_r3;		/* 0x.e34 - PCIE error capture register 0 */
+	__be32	pex_err_cap_r0;		/* 0x.e28 - PCIe error capture register 0 */
+	__be32	pex_err_cap_r1;		/* 0x.e2c - PCIe error capture register 0 */
+	__be32	pex_err_cap_r2;		/* 0x.e30 - PCIe error capture register 0 */
+	__be32	pex_err_cap_r3;		/* 0x.e34 - PCIe error capture register 0 */
 };

 extern int fsl_add_bridge(struct device_node *dev, int is_primary);
diff --git a/arch/powerpc/sysdev/ppc4xx_pci.c b/arch/powerpc/sysdev/ppc4xx_pci.c
index 6ff9d71..55db466 100644
--- a/arch/powerpc/sysdev/ppc4xx_pci.c
+++ b/arch/powerpc/sysdev/ppc4xx_pci.c
@@ -668,7 +668,7 @@ static int __init ppc440spe_pciex_check_reset(struct device_node *np)
 		 *
 		 * -- Shouldn't we also re-reset the whole thing ? -- BenH
 		 */
-		pr_debug("PCIE: SDR0_PLLLCT1 already reset.\n");
+		pr_debug("PCIe: SDR0_PLLLCT1 already reset.\n");
 		mtdcri(SDR0, PESDR0_440SPE_RCSSET, 0x01010000);
 		mtdcri(SDR0, PESDR1_440SPE_RCSSET, 0x01010000);
 		mtdcri(SDR0, PESDR2_440SPE_RCSSET, 0x01010000);
@@ -682,7 +682,7 @@ static int __init ppc440spe_pciex_check_reset(struct device_node *np)
 	if (!(valPE0 & 0x01000000) ||
 	    !(valPE1 & 0x01000000) ||
 	    !(valPE2 & 0x01000000)) {
-		printk(KERN_INFO "PCIE: SDR0_PExRCSSET rstgu error\n");
+		printk(KERN_INFO "PCIe: SDR0_PExRCSSET rstgu error\n");
 		err = -1;
 	}

@@ -690,7 +690,7 @@ static int __init ppc440spe_pciex_check_reset(struct device_node *np)
 	if (!(valPE0 & 0x00010000) ||
 	    !(valPE1 & 0x00010000) ||
 	    !(valPE2 & 0x00010000)) {
-		printk(KERN_INFO "PCIE: SDR0_PExRCSSET rstdl error\n");
+		printk(KERN_INFO "PCIe: SDR0_PExRCSSET rstdl error\n");
 		err = -1;
 	}

@@ -698,7 +698,7 @@ static int __init ppc440spe_pciex_check_reset(struct device_node *np)
 	if ((valPE0 & 0x00001000) ||
 	    (valPE1 & 0x00001000) ||
 	    (valPE2 & 0x00001000)) {
-		printk(KERN_INFO "PCIE: SDR0_PExRCSSET rstpyn error\n");
+		printk(KERN_INFO "PCIe: SDR0_PExRCSSET rstpyn error\n");
 		err = -1;
 	}

@@ -706,7 +706,7 @@ static int __init ppc440spe_pciex_check_reset(struct device_node *np)
 	if ((valPE0 & 0x10000000) ||
 	    (valPE1 & 0x10000000) ||
 	    (valPE2 & 0x10000000)) {
-		printk(KERN_INFO "PCIE: SDR0_PExRCSSET hldplb error\n");
+		printk(KERN_INFO "PCIe: SDR0_PExRCSSET hldplb error\n");
 		err = -1;
 	}

@@ -714,7 +714,7 @@ static int __init ppc440spe_pciex_check_reset(struct device_node *np)
 	if ((valPE0 & 0x00100000) ||
 	    (valPE1 & 0x00100000) ||
 	    (valPE2 & 0x00100000)) {
-		printk(KERN_INFO "PCIE: SDR0_PExRCSSET rdy error\n");
+		printk(KERN_INFO "PCIe: SDR0_PExRCSSET rdy error\n");
 		err = -1;
 	}

@@ -722,7 +722,7 @@ static int __init ppc440spe_pciex_check_reset(struct device_node *np)
 	if ((valPE0 & 0x00000100) ||
 	    (valPE1 & 0x00000100) ||
 	    (valPE2 & 0x00000100)) {
-		printk(KERN_INFO "PCIE: SDR0_PExRCSSET shutdown error\n");
+		printk(KERN_INFO "PCIe: SDR0_PExRCSSET shutdown error\n");
 		err = -1;
 	}

@@ -742,7 +742,7 @@ static int __init ppc440spe_pciex_core_init(struct device_node *np)
 		return -ENXIO;

 	if (!(mfdcri(SDR0, PESDR0_PLLLCT2) & 0x10000)) {
-		printk(KERN_INFO "PCIE: PESDR_PLLCT2 resistance calibration "
+		printk(KERN_INFO "PCIe: PESDR_PLLCT2 resistance calibration "
 		       "failed (0x%08x)\n",
 		       mfdcri(SDR0, PESDR0_PLLLCT2));
 		return -1;
@@ -760,11 +760,11 @@ static int __init ppc440spe_pciex_core_init(struct device_node *np)
 			break;
 	}
 	if (!time_out) {
-		printk(KERN_INFO "PCIE: VCO output not locked\n");
+		printk(KERN_INFO "PCIe: VCO output not locked\n");
 		return -1;
 	}

-	pr_debug("PCIE initialization OK\n");
+	pr_debug("PCIe initialization OK\n");

 	return 3;
 }
@@ -1093,7 +1093,7 @@ static int __init ppc4xx_pciex_check_core_init(struct device_node *np)
 		ppc4xx_pciex_hwops = &ppc405ex_pcie_hwops;
 #endif
 	if (ppc4xx_pciex_hwops == NULL) {
-		printk(KERN_WARNING "PCIE: unknown host type %s\n",
+		printk(KERN_WARNING "PCIe: unknown host type %s\n",
 		       np->full_name);
 		return -ENODEV;
 	}
@@ -1107,7 +1107,7 @@ static int __init ppc4xx_pciex_check_core_init(struct device_node *np)
 			ppc4xx_pciex_port_count = count;
 			return 0;
 		}
-		printk(KERN_WARNING "PCIE: failed to allocate ports array\n");
+		printk(KERN_WARNING "PCIe: failed to allocate ports array\n");
 		return -ENOMEM;
 	}
 	return -ENODEV;
@@ -1151,7 +1151,7 @@ static int __init ppc4xx_pciex_wait_on_sdr(struct ppc4xx_pciex_port *port,
 	while(timeout_ms--) {
 		val = mfdcri(SDR0, port->sdr_base + sdr_offset);
 		if ((val & mask) == value) {
-			pr_debug("PCIE%d: Wait on SDR %x success with tm %d (%08x)\n",
+			pr_debug("PCIe%d: Wait on SDR %x success with tm %d (%08x)\n",
 				 port->index, sdr_offset, timeout_ms, val);
 			return 0;
 		}
@@ -1170,12 +1170,12 @@ static int __init ppc4xx_pciex_port_init(struct ppc4xx_pciex_port *port)
 	if (rc != 0)
 		return rc;

-	printk(KERN_INFO "PCIE%d: Checking link...\n",
+	printk(KERN_INFO "PCIe%d: Checking link...\n",
 	       port->index);

 	/* Wait for reset to complete */
 	if (ppc4xx_pciex_wait_on_sdr(port, PESDRn_RCSSTS, 1 << 20, 0, 10)) {
-		printk(KERN_WARNING "PCIE%d: PGRST failed\n",
+		printk(KERN_WARNING "PCIe%d: PGRST failed\n",
 		       port->index);
 		return -1;
 	}
@@ -1191,19 +1191,19 @@ static int __init ppc4xx_pciex_port_init(struct ppc4xx_pciex_port *port)
 	    !ppc4xx_pciex_wait_on_sdr(port, PESDRn_LOOP,
 				      1 << 28, 1 << 28, 100)) {
 		printk(KERN_INFO
-		       "PCIE%d: Device detected, waiting for link...\n",
+		       "PCIe%d: Device detected, waiting for link...\n",
 		       port->index);
 		if (ppc4xx_pciex_wait_on_sdr(port, PESDRn_LOOP,
 					     0x1000, 0x1000, 2000))
 			printk(KERN_WARNING
-			       "PCIE%d: Link up failed\n", port->index);
+			       "PCIe%d: Link up failed\n", port->index);
 		else {
 			printk(KERN_INFO
-			       "PCIE%d: link is up !\n", port->index);
+			       "PCIe%d: link is up !\n", port->index);
 			port->link = 1;
 		}
 	} else
-		printk(KERN_INFO "PCIE%d: No device detected.\n", port->index);
+		printk(KERN_INFO "PCIe%d: No device detected.\n", port->index);

 	/*
 	 * Initialize mapping: disable all regions and configure
@@ -1229,7 +1229,7 @@ static int __init ppc4xx_pciex_port_init(struct ppc4xx_pciex_port *port)
 	if (port->link &&
 	    ppc4xx_pciex_wait_on_sdr(port, PESDRn_RCSSTS,
 				     1 << 16, 1 << 16, 5000)) {
-		printk(KERN_INFO "PCIE%d: VC0 not active\n", port->index);
+		printk(KERN_INFO "PCIe%d: VC0 not active\n", port->index);
 		port->link = 0;
 	}

@@ -1648,7 +1648,7 @@ static void __init ppc4xx_pciex_port_setup_hose(struct ppc4xx_pciex_port *port)
 	}
 	hose->cfg_addr = mbase;

-	pr_debug("PCIE %s, bus %d..%d\n", port->node->full_name,
+	pr_debug("PCIe %s, bus %d..%d\n", port->node->full_name,
 		 hose->first_busno, hose->last_busno);
 	pr_debug("     config space mapped at: root @0x%p, other @0x%p\n",
 		 hose->cfg_addr, hose->cfg_data);
@@ -1719,13 +1719,13 @@ static void __init ppc4xx_pciex_port_setup_hose(struct ppc4xx_pciex_port *port)
 		/* Set Class Code to PCI-PCI bridge and Revision Id to 1 */
 		out_le32(mbase + 0x208, 0x06040001);

-		printk(KERN_INFO "PCIE%d: successfully set as root-complex\n",
+		printk(KERN_INFO "PCIe%d: successfully set as root-complex\n",
 		       port->index);
 	} else {
 		/* Set Class Code to Processor/PPC */
 		out_le32(mbase + 0x208, 0x0b200001);

-		printk(KERN_INFO "PCIE%d: successfully set as endpoint\n",
+		printk(KERN_INFO "PCIe%d: successfully set as endpoint\n",
 		       port->index);
 	}

@@ -1756,13 +1756,13 @@ static void __init ppc4xx_probe_pciex_bridge(struct device_node *np)
 	/* Get the port number from the device-tree */
 	pval = of_get_property(np, "port", NULL);
 	if (pval == NULL) {
-		printk(KERN_ERR "PCIE: Can't find port number for %s\n",
+		printk(KERN_ERR "PCIe: Can't find port number for %s\n",
 		       np->full_name);
 		return;
 	}
 	portno = *pval;
 	if (portno >= ppc4xx_pciex_port_count) {
-		printk(KERN_ERR "PCIE: port number out of range for %s\n",
+		printk(KERN_ERR "PCIe: port number out of range for %s\n",
 		       np->full_name);
 		return;
 	}
@@ -1773,14 +1773,14 @@ static void __init ppc4xx_probe_pciex_bridge(struct device_node *np)
 	 * Check if device is enabled
 	 */
 	if (!of_device_is_available(np)) {
-		printk(KERN_INFO "PCIE%d: Port disabled via device-tree\n", port->index);
+		printk(KERN_INFO "PCIe%d: Port disabled via device-tree\n", port->index);
 		return;
 	}

 	port->node = of_node_get(np);
 	pval = of_get_property(np, "sdr-base", NULL);
 	if (pval == NULL) {
-		printk(KERN_ERR "PCIE: missing sdr-base for %s\n",
+		printk(KERN_ERR "PCIe: missing sdr-base for %s\n",
 		       np->full_name);
 		return;
 	}
@@ -1796,14 +1796,14 @@ static void __init ppc4xx_probe_pciex_bridge(struct device_node *np)
 	} else if (!strcmp(val, "pci")) {
 		port->endpoint = 0;
 	} else {
-		printk(KERN_ERR "PCIE: missing or incorrect device_type for %s\n",
+		printk(KERN_ERR "PCIe: missing or incorrect device_type for %s\n",
 		       np->full_name);
 		return;
 	}

 	/* Fetch config space registers address */
 	if (of_address_to_resource(np, 0, &port->cfg_space)) {
-		printk(KERN_ERR "%s: Can't get PCI-E config space !",
+		printk(KERN_ERR "%s: Can't get PCIe config space !",
 		       np->full_name);
 		return;
 	}
@@ -1825,7 +1825,7 @@ static void __init ppc4xx_probe_pciex_bridge(struct device_node *np)

 	/* Initialize the port specific registers */
 	if (ppc4xx_pciex_port_init(port)) {
-		printk(KERN_WARNING "PCIE%d: Port init failed\n", port->index);
+		printk(KERN_WARNING "PCIe%d: Port init failed\n", port->index);
 		return;
 	}

diff --git a/arch/sh/drivers/pci/pcie-sh7786.h b/arch/sh/drivers/pci/pcie-sh7786.h
index c655290..43273f6 100644
--- a/arch/sh/drivers/pci/pcie-sh7786.h
+++ b/arch/sh/drivers/pci/pcie-sh7786.h
@@ -63,7 +63,7 @@
 #define PCI_MBAR1	0x018

 /* PCI power management/MSI/capablity 040-0ff */
-/* PCIE extended 100-fff */
+/* PCIe extended 100-fff */

 /* SH7786 device identification */	// Rev1.171
 #define SH4A_PVR		(0xFF000030)
diff --git a/arch/sparc/kernel/pci_fire.c b/arch/sparc/kernel/pci_fire.c
index d53f45b..0c072e2 100644
--- a/arch/sparc/kernel/pci_fire.c
+++ b/arch/sparc/kernel/pci_fire.c
@@ -1,4 +1,4 @@
-/* pci_fire.c: Sun4u platform PCI-E controller support.
+/* pci_fire.c: Sun4u platform PCIe controller support.
  *
  * Copyright (C) 2007 David S. Miller (davem@davemloft.net)
  */
@@ -431,7 +431,7 @@ static int __devinit pci_fire_pbm_init(struct pci_pbm_info *pbm,
 	pbm->pbm_regs = regs[0].phys_addr;
 	pbm->controller_regs = regs[1].phys_addr - 0x410000UL;

-	printk("%s: SUN4U PCIE Bus Module\n", pbm->name);
+	printk("%s: SUN4U PCIe Bus Module\n", pbm->name);

 	pci_determine_mem_io_space(pbm);

diff --git a/arch/sparc/kernel/pci_impl.h b/arch/sparc/kernel/pci_impl.h
index 0318682..f467884 100644
--- a/arch/sparc/kernel/pci_impl.h
+++ b/arch/sparc/kernel/pci_impl.h
@@ -101,7 +101,7 @@ struct pci_pbm_info {
 	/* Base of PCI Config space, can be per-PBM or shared. */
 	unsigned long			config_space;

-	/* This will be 12 on PCI-E controllers, 8 elsewhere.  */
+	/* This will be 12 on PCIe controllers, 8 elsewhere.  */
 	unsigned long			config_space_reg_bits;

 	unsigned long			pci_afsr;
diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index 10e1f03..071b41b 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -2264,7 +2264,7 @@ static int find_gmch(u16 device)
 	return 1;
 }

-/* Table to describe Intel GMCH and AGP/PCIE GART drivers.  At least one of
+/* Table to describe Intel GMCH and AGP/PCIe GART drivers.  At least one of
  * driver and gmch_driver must be non-null, and find_gmch will determine
  * which one should be used if a gmch_chip_id is present.
  */
diff --git a/drivers/edac/amd8131_edac.c b/drivers/edac/amd8131_edac.c
index b432d60..c8652c9 100644
--- a/drivers/edac/amd8131_edac.c
+++ b/drivers/edac/amd8131_edac.c
@@ -242,7 +242,7 @@ static struct amd8131_info amd8131_chipset = {
 };

 /*
- * There are 4 PCIX Bridges on ATCA-6101 that share the same PCI Device ID,
+ * There are 4 PCI-X Bridges on ATCA-6101 that share the same PCI Device ID,
  * so amd8131_probe() would be called by kernel 4 times, with different
  * address of pci_dev for each of them each time.
  */
diff --git a/drivers/edac/amd8131_edac.h b/drivers/edac/amd8131_edac.h
index 60e0d1c..bc8d0c2 100644
--- a/drivers/edac/amd8131_edac.h
+++ b/drivers/edac/amd8131_edac.h
@@ -98,11 +98,11 @@ struct amd8131_dev_info {
 };

 /*
- * AMD8131 chipset has two pairs of PCIX Bridge and related IOAPIC
+ * AMD8131 chipset has two pairs of PCI-X Bridge and related IOAPIC
  * Controler, and ATCA-6101 has two AMD8131 chipsets, so there are
- * four PCIX Bridges on ATCA-6101 altogether.
+ * four PCI-X Bridges on ATCA-6101 altogether.
  *
- * These PCIX Bridges share the same PCI Device ID and are all of
+ * These PCI-X Bridges share the same PCI Device ID and are all of
  * Function Zero, they could be discrimated by their pci_dev->devfn.
  * They share the same set of init/check/exit methods, and their
  * private structures are collected in the devices[] array.
diff --git a/drivers/edac/mv64x60_edac.h b/drivers/edac/mv64x60_edac.h
index e042e2d..7ac22dc 100644
--- a/drivers/edac/mv64x60_edac.h
+++ b/drivers/edac/mv64x60_edac.h
@@ -61,7 +61,7 @@
  */
 #define MV64X60_PCIx_ERR_MASK_VAL	0x00a50c24

-/* Register offsets from PCIx error address low register */
+/* Register offsets from PCI-X error address low register */
 #define MV64X60_PCI_ERROR_ADDR_LO	0x00
 #define MV64X60_PCI_ERROR_ADDR_HI	0x04
 #define MV64X60_PCI_ERROR_ATTR		0x08
diff --git a/drivers/edac/ppc4xx_edac.c b/drivers/edac/ppc4xx_edac.c
index 11f2172..eda4fdf 100644
--- a/drivers/edac/ppc4xx_edac.c
+++ b/drivers/edac/ppc4xx_edac.c
@@ -224,8 +224,8 @@ static const unsigned ppc4xx_edac_nr_chans = 1;
  */
 static const char * const ppc4xx_plb_masters[9] = {
 	[SDRAM_PLB_M0ID_ICU]	= "ICU",
-	[SDRAM_PLB_M0ID_PCIE0]	= "PCI-E 0",
-	[SDRAM_PLB_M0ID_PCIE1]	= "PCI-E 1",
+	[SDRAM_PLB_M0ID_PCIE0]	= "PCIe 0",
+	[SDRAM_PLB_M0ID_PCIE1]	= "PCIe 1",
 	[SDRAM_PLB_M0ID_DMA]	= "DMA",
 	[SDRAM_PLB_M0ID_DCU]	= "DCU",
 	[SDRAM_PLB_M0ID_OPB]	= "OPB",
diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 5d52425..941c21d 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -1016,7 +1016,7 @@ static int at_context_queue_packet(struct context *ctx,
 	 * is halted, so appending to the context and trying to run it is
 	 * futile.  Most controllers do the right thing and just flush the AT
 	 * queue (per section 7.2.3.2 of the OHCI 1.1 specification), but
-	 * some controllers (like a JMicron JMB381 PCI-e) misbehave and wind
+	 * some controllers (like a JMicron JMB381 PCIe. misbehave and wind
 	 * up stalling out.  So we just bail out in software and try again
 	 * later, and everyone is happy.
 	 * FIXME: Document how the locking works.
diff --git a/drivers/firmware/edd.c b/drivers/firmware/edd.c
index 9e4f59d..ed6b7e3 100644
--- a/drivers/firmware/edd.c
+++ b/drivers/firmware/edd.c
@@ -150,7 +150,7 @@ edd_show_host_bus(struct edd_device *edev, char *buf)
 	if (!strncmp(info->params.host_bus_type, "ISA", 3)) {
 		p += scnprintf(p, left, "\tbase_address: %x\n",
 			     info->params.interface_path.isa.base_address);
-	} else if (!strncmp(info->params.host_bus_type, "PCIX", 4) ||
+	} else if (!strncmp(info->params.host_bus_type, "PCI-X", 4) ||
 		   !strncmp(info->params.host_bus_type, "PCI", 3)) {
 		p += scnprintf(p, left,
 			     "\t%02x:%02x.%d  channel: %u\n",
diff --git a/drivers/gpu/drm/i810/i810_dma.c b/drivers/gpu/drm/i810/i810_dma.c
index 7d1d88c..3e06f3f 100644
--- a/drivers/gpu/drm/i810/i810_dma.c
+++ b/drivers/gpu/drm/i810/i810_dma.c
@@ -1268,7 +1268,7 @@ int i810_max_ioctl = DRM_ARRAY_SIZE(i810_ioctls);
  * Determine if the device really is AGP or not.
  *
  * All Intel graphics chipsets are treated as AGP, even if they are really
- * PCI-e.
+ * PCIe.
  *
  * \param dev   The device to be tested.
  *
diff --git a/drivers/gpu/drm/i830/i830_dma.c b/drivers/gpu/drm/i830/i830_dma.c
index 877bf6c..46c3d8f 100644
--- a/drivers/gpu/drm/i830/i830_dma.c
+++ b/drivers/gpu/drm/i830/i830_dma.c
@@ -1538,7 +1538,7 @@ int i830_max_ioctl = DRM_ARRAY_SIZE(i830_ioctls);
  * Determine if the device really is AGP or not.
  *
  * All Intel graphics chipsets are treated as AGP, even if they are really
- * PCI-e.
+ * PCIe.
  *
  * \param dev   The device to be tested.
  *
diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index e5b138b..e82fae8 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1664,7 +1664,7 @@ int i915_max_ioctl = DRM_ARRAY_SIZE(i915_ioctls);
  * Determine if the device really is AGP or not.
  *
  * All Intel graphics chipsets are treated as AGP, even if they are really
- * PCI-e.
+ * PCIe.
  *
  * \param dev   The device to be tested.
  *
diff --git a/drivers/gpu/drm/radeon/atombios.h b/drivers/gpu/drm/radeon/atombios.h
index c11dddd..ed880ec 100644
--- a/drivers/gpu/drm/radeon/atombios.h
+++ b/drivers/gpu/drm/radeon/atombios.h
@@ -621,7 +621,7 @@ typedef struct _DIG_TRANSMITTER_CONTROL_PARAMETERS {
 	/*  =0: PHY linkA   if bfLane<3 */
 	/*  =1: PHY linkB   if bfLanes<3 */
 	/*  =0: PHY linkA+B if bfLanes=3 */
-	/*  [5:4]PCIE lane Sel */
+	/*  [5:4]PCIe lane Sel */
 	/*  =0: lane 0~3 or 0~7 */
 	/*  =1: lane 4~7 */
 	/*  =2: lane 8~11 or 8~15 */
@@ -1652,7 +1652,7 @@ typedef struct _ATOM_INTEGRATED_SYSTEM_INFO {

 	USHORT usFSBClock;	/* In MHz unit */
 	USHORT usCapabilityFlag;	/* Bit0=1 indicates the fake HDMI support,Bit1=0/1 for Dynamic clocking dis/enable */
-	/* Bit[3:2]== 0:No PCIE card, 1:AC card, 2:SDVO card */
+	/* Bit[3:2]== 0:No PCIe card, 1:AC card, 2:SDVO card */
 	/* Bit[4]==1: P/2 mode, ==0: P/1 mode */
 	USHORT usPCIENBCfgReg7;	/* bit[7:0]=MUX_Sel, bit[9:8]=MUX_SEL_LEVEL2, bit[10]=Lane_Reversal */
 	USHORT usK8MemoryClock;	/* in MHz unit */
@@ -1770,9 +1770,9 @@ ulBootUpReqDisplayVector: This dword is a bit vector indicates what display devi
 ulOtherDisplayMisc: [15:8]- Bootup LCD Expansion selection; 0-center, 1-full panel size expansion;
 			              [7:0] - BootupTV standard selection; This is a bit vector to indicate what TV standards are supported by the system. Refer to ucTVSuppportedStd definition;

-ulDDISlot1Config: Describes the PCIE lane configuration on this DDI PCIE slot (ADD2 card) or connector (Mobile design).
-      [3:0]  - Bit vector to indicate PCIE lane config of the DDI slot/connector on chassis (bit 0=1 lane 3:0; bit 1=1 lane 7:4; bit 2=1 lane 11:8; bit 3=1 lane 15:12)
-			[7:4]  - Bit vector to indicate PCIE lane config of the same DDI slot/connector on docking station (bit 0=1 lane 3:0; bit 1=1 lane 7:4; bit 2=1 lane 11:8; bit 3=1 lane 15:12)
+ulDDISlot1Config: Describes the PCIe lane configuration on this DDI PCIe slot (ADD2 card) or connector (Mobile design).
+      [3:0]  - Bit vector to indicate PCIe lane config of the DDI slot/connector on chassis (bit 0=1 lane 3:0; bit 1=1 lane 7:4; bit 2=1 lane 11:8; bit 3=1 lane 15:12)
+			[7:4]  - Bit vector to indicate PCIe lane config of the same DDI slot/connector on docking station (bit 0=1 lane 3:0; bit 1=1 lane 7:4; bit 2=1 lane 11:8; bit 3=1 lane 15:12)
 			[15:8] - Lane configuration attribute;
       [23:16]- Connector type, possible value:
                CONNECTOR_OBJECT_ID_SINGLE_LINK_DVI_D
@@ -3033,7 +3033,7 @@ typedef struct _ATOM_ASIC_INTERNAL_SS_INFO {
 #define ATOM_S0_DFP_MASK \
 	(ATOM_S0_DFP1 | ATOM_S0_DFP2 | ATOM_S0_DFP3 | ATOM_S0_DFP4 | ATOM_S0_DFP5)

-#define ATOM_S0_FAD_REGISTER_BUG        0x02000000L	/*  If set, indicates we are running a PCIE asic with */
+#define ATOM_S0_FAD_REGISTER_BUG        0x02000000L	/*  If set, indicates we are running a PCIe asic with */
 						    /*  the FAD/HDP reg access bug.  Bit is read by DAL */

 #define ATOM_S0_THERMAL_STATE_MASK      0x1C000000L
@@ -4612,7 +4612,7 @@ typedef struct _ATOM_POWERMODE_INFO {
 	UCHAR ucSelectedPanel_RefreshRate;	/*  panel refresh rate */
 	UCHAR ucMinTemperature;
 	UCHAR ucMaxTemperature;
-	UCHAR ucNumPciELanes;	/*  number of PCIE lanes */
+	UCHAR ucNumPciELanes;	/*  number of PCIe lanes */
 } ATOM_POWERMODE_INFO;

 /* ucTableFormatRevision=2 */
@@ -4626,7 +4626,7 @@ typedef struct _ATOM_POWERMODE_INFO_V2 {
 	UCHAR ucSelectedPanel_RefreshRate;	/*  panel refresh rate */
 	UCHAR ucMinTemperature;
 	UCHAR ucMaxTemperature;
-	UCHAR ucNumPciELanes;	/*  number of PCIE lanes */
+	UCHAR ucNumPciELanes;	/*  number of PCIe lanes */
 } ATOM_POWERMODE_INFO_V2;

 /* ucTableFormatRevision=2 */
@@ -4640,7 +4640,7 @@ typedef struct _ATOM_POWERMODE_INFO_V3 {
 	UCHAR ucSelectedPanel_RefreshRate;	/*  panel refresh rate */
 	UCHAR ucMinTemperature;
 	UCHAR ucMaxTemperature;
-	UCHAR ucNumPciELanes;	/*  number of PCIE lanes */
+	UCHAR ucNumPciELanes;	/*  number of PCIe lanes */
 	UCHAR ucVDDCI_VoltageDropIndex;	/*  index to VDDCI votage table */
 } ATOM_POWERMODE_INFO_V3;

diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index c9e93ea..15d5976 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -2319,7 +2319,7 @@ void r100_bandwidth_update(struct radeon_device *rdev)
 		temp_ff.full = rfixed_const_666(16);
 		sclk_eff_ff.full -= rfixed_mul(agpmode_ff, temp_ff);
 	}
-	/* TODO PCIE lanes may affect this - agpmode == 16?? */
+	/* TODO PCIe lanes may affect this - agpmode == 16?? */

 	if (ASIC_IS_R300(rdev)) {
 		sclk_delay_ff.full = rfixed_const(250);
diff --git a/drivers/gpu/drm/radeon/r300.c b/drivers/gpu/drm/radeon/r300.c
index 2f43ee8..fc8e206 100644
--- a/drivers/gpu/drm/radeon/r300.c
+++ b/drivers/gpu/drm/radeon/r300.c
@@ -39,7 +39,7 @@
 /* This files gather functions specifics to: r300,r350,rv350,rv370,rv380 */

 /*
- * rv370,rv380 PCIE GART
+ * rv370,rv380 PCIe GART
  */
 static int rv370_debugfs_pcie_gart_info_init(struct radeon_device *rdev);

@@ -80,7 +80,7 @@ int rv370_pcie_gart_init(struct radeon_device *rdev)
 	int r;

 	if (rdev->gart.table.vram.robj) {
-		WARN(1, "RV370 PCIE GART already initialized.\n");
+		WARN(1, "RV370 PCIe GART already initialized.\n");
 		return 0;
 	}
 	/* Initialize common gart structure */
@@ -89,7 +89,7 @@ int rv370_pcie_gart_init(struct radeon_device *rdev)
 		return r;
 	r = rv370_debugfs_pcie_gart_info_init(rdev);
 	if (r)
-		DRM_ERROR("Failed to register debugfs file for PCIE gart !\n");
+		DRM_ERROR("Failed to register debugfs file for PCIe gart !\n");
 	rdev->gart.table_size = rdev->gart.num_gpu_pages * 4;
 	rdev->asic->gart_tlb_flush = &rv370_pcie_gart_tlb_flush;
 	rdev->asic->gart_set_page = &rv370_pcie_gart_set_page;
@@ -103,7 +103,7 @@ int rv370_pcie_gart_enable(struct radeon_device *rdev)
 	int r;

 	if (rdev->gart.table.vram.robj == NULL) {
-		dev_err(rdev->dev, "No VRAM object for PCIE GART.\n");
+		dev_err(rdev->dev, "No VRAM object for PCIe GART.\n");
 		return -EINVAL;
 	}
 	r = radeon_gart_table_vram_pin(rdev);
@@ -129,7 +129,7 @@ int rv370_pcie_gart_enable(struct radeon_device *rdev)
 	tmp |= RADEON_PCIE_TX_GART_UNMAPPED_ACCESS_DISCARD;
 	WREG32_PCIE(RADEON_PCIE_TX_GART_CNTL, tmp);
 	rv370_pcie_gart_tlb_flush(rdev);
-	DRM_INFO("PCIE GART of %uM enabled (table at 0x%08X).\n",
+	DRM_INFO("PCIe GART of %uM enabled (table at 0x%08X).\n",
 		 (unsigned)(rdev->mc.gtt_size >> 20), table_addr);
 	rdev->gart.ready = true;
 	return 0;
diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index 278f646..bb8f523 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -71,7 +71,7 @@ void r600_gpu_init(struct radeon_device *rdev);
 void r600_fini(struct radeon_device *rdev);

 /*
- * R600 PCIE GART
+ * R600 PCIe GART
  */
 int r600_gart_clear_page(struct radeon_device *rdev, int i)
 {
@@ -113,7 +113,7 @@ int r600_pcie_gart_init(struct radeon_device *rdev)
 	int r;

 	if (rdev->gart.table.vram.robj) {
-		WARN(1, "R600 PCIE GART already initialized.\n");
+		WARN(1, "R600 PCIe GART already initialized.\n");
 		return 0;
 	}
 	/* Initialize common gart structure */
@@ -130,7 +130,7 @@ int r600_pcie_gart_enable(struct radeon_device *rdev)
 	int r, i;

 	if (rdev->gart.table.vram.robj == NULL) {
-		dev_err(rdev->dev, "No VRAM object for PCIE GART.\n");
+		dev_err(rdev->dev, "No VRAM object for PCIe GART.\n");
 		return -EINVAL;
 	}
 	r = radeon_gart_table_vram_pin(rdev);
diff --git a/drivers/gpu/drm/radeon/r600_cp.c b/drivers/gpu/drm/radeon/r600_cp.c
index 6d5a711..9e639b1 100644
--- a/drivers/gpu/drm/radeon/r600_cp.c
+++ b/drivers/gpu/drm/radeon/r600_cp.c
@@ -248,7 +248,7 @@ static void r600_vm_init(struct drm_device *dev)
 	u32 vm_c0, i;
 	u32 mc_rd_a;
 	u32 vm_l2_cntl, vm_l2_cntl3;
-	/* okay set up the PCIE aperture type thingo */
+	/* okay set up the PCIe aperture type thingo */
 	RADEON_WRITE(R600_MC_VM_SYSTEM_APERTURE_LOW_ADDR, dev_priv->gart_vm_start >> 12);
 	RADEON_WRITE(R600_MC_VM_SYSTEM_APERTURE_HIGH_ADDR, (dev_priv->gart_vm_start + dev_priv->gart_size - 1) >> 12);
 	RADEON_WRITE(R600_MC_VM_SYSTEM_APERTURE_DEFAULT_ADDR, 0);
@@ -430,7 +430,7 @@ static void r700_vm_init(struct drm_device *dev)
 	u32 vm_c0, i;
 	u32 mc_vm_md_l1;
 	u32 vm_l2_cntl, vm_l2_cntl3;
-	/* okay set up the PCIE aperture type thingo */
+	/* okay set up the PCIe aperture type thingo */
 	RADEON_WRITE(R700_MC_VM_SYSTEM_APERTURE_LOW_ADDR, dev_priv->gart_vm_start >> 12);
 	RADEON_WRITE(R700_MC_VM_SYSTEM_APERTURE_HIGH_ADDR, (dev_priv->gart_vm_start + dev_priv->gart_size - 1) >> 12);
 	RADEON_WRITE(R700_MC_VM_SYSTEM_APERTURE_DEFAULT_ADDR, 0);
diff --git a/drivers/gpu/drm/radeon/radeon_cp.c b/drivers/gpu/drm/radeon/radeon_cp.c
index 4f7afc7..321707a 100644
--- a/drivers/gpu/drm/radeon/radeon_cp.c
+++ b/drivers/gpu/drm/radeon/radeon_cp.c
@@ -289,7 +289,7 @@ void radeon_enable_bm(struct drm_radeon_private *dev_priv)
 		/* r1xx, r2xx, r300, r(v)350, r420/r481, rs400/rs480 */
 		tmp = RADEON_READ(RADEON_BUS_CNTL) & ~RADEON_BUS_MASTER_DIS;
 		RADEON_WRITE(RADEON_BUS_CNTL, tmp);
-	} /* PCIE cards appears to not need this */
+	} /* PCIe cards appears to not need this */
 }

 static int RADEON_READ_PLL(struct drm_device * dev, int addr)
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index e3f9edf..2f8990f 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -498,13 +498,13 @@ void radeon_agp_disable(struct radeon_device *rdev)
 {
 	rdev->flags &= ~RADEON_IS_AGP;
 	if (rdev->family >= CHIP_R600) {
-		DRM_INFO("Forcing AGP to PCIE mode\n");
+		DRM_INFO("Forcing AGP to PCIe mode\n");
 		rdev->flags |= RADEON_IS_PCIE;
 	} else if (rdev->family >= CHIP_RV515 ||
 			rdev->family == CHIP_RV380 ||
 			rdev->family == CHIP_RV410 ||
 			rdev->family == CHIP_R423) {
-		DRM_INFO("Forcing AGP to PCIE mode\n");
+		DRM_INFO("Forcing AGP to PCIe mode\n");
 		rdev->flags |= RADEON_IS_PCIE;
 		rdev->asic->gart_tlb_flush = &rv370_pcie_gart_tlb_flush;
 		rdev->asic->gart_set_page = &rv370_pcie_gart_set_page;
@@ -558,7 +558,7 @@ int radeon_device_init(struct radeon_device *rdev,
 	}

 	/* set DMA mask + need_dma32 flags.
-	 * PCIE - can handle 40-bits.
+	 * PCIe - can handle 40-bits.
 	 * IGP - can handle 40-bits (in theory)
 	 * AGP - generally dma32 is safest
 	 * PCI - only dma32
@@ -597,7 +597,7 @@ int radeon_device_init(struct radeon_device *rdev,

 	if (rdev->flags & RADEON_IS_AGP && !rdev->accel_working) {
 		/* Acceleration not working on AGP card try again
-		 * with fallback to PCI or PCIE GART
+		 * with fallback to PCI or PCIe GART
 		 */
 		radeon_gpu_reset(rdev);
 		radeon_fini(rdev);
diff --git a/drivers/gpu/drm/radeon/radeon_drv.h b/drivers/gpu/drm/radeon/radeon_drv.h
index 350962e..152a3ef 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.h
+++ b/drivers/gpu/drm/radeon/radeon_drv.h
@@ -92,7 +92,7 @@
  *       R200_EMIT_PP_AFS_0/1, R200_EMIT_PP_TXCTLALL_0-5 (replaces
  *       R200_EMIT_PP_TXFILTER_0-5, 2 more regs) and R200_EMIT_ATF_TFACTOR
  *       (replaces R200_EMIT_TFACTOR_0 (8 consts instead of 6)
- * 1.19- Add support for gart table in FB memory and PCIE r300
+ * 1.19- Add support for gart table in FB memory and PCIe r300
  * 1.20- Add support for r300 texrect
  * 1.21- Add support for card type getparam
  * 1.22- Add support for texture cache flushes (R300_TX_CNTL)
@@ -480,7 +480,7 @@ extern void r600_blit_swap(struct drm_device *dev,
 #	define RADEON_SCISSOR_2_ENABLE		(1 << 30)

 /*
- * PCIE radeons (rv370/rv380, rv410, r423/r430/r480, r5xx)
+ * PCIe radeons (rv370/rv380, rv410, r423/r430/r480, r5xx)
  * don't have an explicit bus mastering disable bit.  It's handled
  * by the PCI D-states.  PMI_BM_DIS disables D-state bus master
  * handling, not bus mastering itself.
diff --git a/drivers/gpu/drm/radeon/radeon_reg.h b/drivers/gpu/drm/radeon/radeon_reg.h
index 29ab759..868af1c 100644
--- a/drivers/gpu/drm/radeon/radeon_reg.h
+++ b/drivers/gpu/drm/radeon/radeon_reg.h
@@ -305,7 +305,7 @@

 /* #define RADEON_PCIE_INDEX                   0x0030 */
 /* #define RADEON_PCIE_DATA                    0x0034 */
-#define RADEON_PCIE_LC_LINK_WIDTH_CNTL             0xa2 /* PCIE */
+#define RADEON_PCIE_LC_LINK_WIDTH_CNTL             0xa2 /* PCIe */
 #       define RADEON_PCIE_LC_LINK_WIDTH_SHIFT     0
 #       define RADEON_PCIE_LC_LINK_WIDTH_MASK      0x7
 #       define RADEON_PCIE_LC_LINK_WIDTH_X0        0
diff --git a/drivers/gpu/drm/radeon/radeon_state.c b/drivers/gpu/drm/radeon/radeon_state.c
index 38537d9..b868e90 100644
--- a/drivers/gpu/drm/radeon/radeon_state.c
+++ b/drivers/gpu/drm/radeon/radeon_state.c
@@ -57,7 +57,7 @@ static __inline__ int radeon_check_and_fixup_offset(drm_radeon_private_t *
 	 * try to detect those cases and fix them up.
 	 *
 	 * Note: It might be a good idea here to make sure the offset lands
-	 * in some "allowed" area to protect things like the PCIE GART...
+	 * in some "allowed" area to protect things like the PCIe GART...
 	 */

 	/* First, the best case, the offset already lands in either the
diff --git a/drivers/gpu/drm/radeon/rs600.c b/drivers/gpu/drm/radeon/rs600.c
index 5f117cd..3332436 100644
--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -89,7 +89,7 @@ int rs600_gart_enable(struct radeon_device *rdev)
 	int r, i;

 	if (rdev->gart.table.vram.robj == NULL) {
-		dev_err(rdev->dev, "No VRAM object for PCIE GART.\n");
+		dev_err(rdev->dev, "No VRAM object for PCIe GART.\n");
 		return -EINVAL;
 	}
 	r = radeon_gart_table_vram_pin(rdev);
diff --git a/drivers/gpu/drm/radeon/rv770.c b/drivers/gpu/drm/radeon/rv770.c
index b0efd0d..2362c70 100644
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -50,7 +50,7 @@ int rv770_pcie_gart_enable(struct radeon_device *rdev)
 	int r, i;

 	if (rdev->gart.table.vram.robj == NULL) {
-		dev_err(rdev->dev, "No VRAM object for PCIE GART.\n");
+		dev_err(rdev->dev, "No VRAM object for PCIe GART.\n");
 		return -EINVAL;
 	}
 	r = radeon_gart_table_vram_pin(rdev);
diff --git a/drivers/hwmon/abituguru3.c b/drivers/hwmon/abituguru3.c
index 3cf28af..9bbfb02 100644
--- a/drivers/hwmon/abituguru3.c
+++ b/drivers/hwmon/abituguru3.c
@@ -172,7 +172,7 @@ static const struct abituguru3_motherboard_info abituguru3_motherboards[] = {
 		{ "DDR",		 1, 0, 10, 1, 0 },
 		{ "DDR VTT",		 2, 0, 10, 1, 0 },
 		{ "CPU VTT 1.2V",	 3, 0, 10, 1, 0 },
-		{ "MCH & PCIE 1.5V",	 4, 0, 10, 1, 0 },
+		{ "MCH & PCIe 1.5V",	 4, 0, 10, 1, 0 },
 		{ "MCH 2.5V",		 5, 0, 20, 1, 0 },
 		{ "ICH 1.05V",		 6, 0, 10, 1, 0 },
 		{ "ATX +12V (24-Pin)",	 7, 0, 60, 1, 0 },
@@ -194,7 +194,7 @@ static const struct abituguru3_motherboard_info abituguru3_motherboards[] = {
 		{ "DDR",		 1, 0, 10, 1, 0 },
 		{ "DDR VTT",		 2, 0, 10, 1, 0 },
 		{ "CPU VTT 1.2V",	 3, 0, 10, 1, 0 },
-		{ "MCH & PCIE 1.5V",	 4, 0, 10, 1, 0 },
+		{ "MCH & PCIe 1.5V",	 4, 0, 10, 1, 0 },
 		{ "MCH 2.5V",		 5, 0, 20, 1, 0 },
 		{ "ICH 1.05V",		 6, 0, 10, 1, 0 },
 		{ "ATX +12V (24-Pin)",	 7, 0, 60, 1, 0 },
@@ -223,7 +223,7 @@ static const struct abituguru3_motherboard_info abituguru3_motherboards[] = {
 		{ "DDR",		 1, 0, 10, 1, 0 },
 		{ "DDR VTT",		 2, 0, 10, 1, 0 },
 		{ "CPU VTT 1.2V",	 3, 0, 10, 1, 0 },
-		{ "MCH & PCIE 1.5V",	 4, 0, 10, 1, 0 },
+		{ "MCH & PCIe 1.5V",	 4, 0, 10, 1, 0 },
 		{ "MCH 2.5V",		 5, 0, 20, 1, 0 },
 		{ "ICH 1.05V",		 6, 0, 10, 1, 0 },
 		{ "ATX +12V (24-Pin)",	 7, 0, 60, 1, 0 },
@@ -245,7 +245,7 @@ static const struct abituguru3_motherboard_info abituguru3_motherboards[] = {
 		{ "DDR",		 1, 0, 10, 1, 0 },
 		{ "DDR VTT",		 2, 0, 10, 1, 0 },
 		{ "CPU VTT 1.2V",	 3, 0, 10, 1, 0 },
-		{ "MCH & PCIE 1.5V",	 4, 0, 10, 1, 0 },
+		{ "MCH & PCIe 1.5V",	 4, 0, 10, 1, 0 },
 		{ "MCH 2.5V",		 5, 0, 20, 1, 0 },
 		{ "ICH 1.05V",		 6, 0, 10, 1, 0 },
 		{ "ATX +12V (24-Pin)",	 7, 0, 60, 1, 0 },
@@ -291,7 +291,7 @@ static const struct abituguru3_motherboard_info abituguru3_motherboards[] = {
 		{ "NB 1.8V",		 4, 0, 10, 1, 0 },
 		{ "NB 1.8V Dual",	 5, 0, 10, 1, 0 },
 		{ "HTV 1.2",		 3, 0, 10, 1, 0 },
-		{ "PCIE 1.2V",		12, 0, 10, 1, 0 },
+		{ "PCIe 1.2V",		12, 0, 10, 1, 0 },
 		{ "NB 1.2V",		13, 0, 10, 1, 0 },
 		{ "ATX +12V (24-Pin)",	 7, 0, 60, 1, 0 },
 		{ "ATX +12V (4-pin)",	 8, 0, 60, 1, 0 },
@@ -337,7 +337,7 @@ static const struct abituguru3_motherboard_info abituguru3_motherboards[] = {
 		{ "DDR",		 1, 0, 10, 1, 0 },
 		{ "DDR VTT",		 2, 0, 10, 1, 0 },
 		{ "CPU VTT 1.2V",	 3, 0, 10, 1, 0 },
-		{ "MCH & PCIE 1.5V",	 4, 0, 10, 1, 0 },
+		{ "MCH & PCIe 1.5V",	 4, 0, 10, 1, 0 },
 		{ "MCH 2.5V",		 5, 0, 20, 1, 0 },
 		{ "ICH 1.05V",		 6, 0, 10, 1, 0 },
 		{ "ATX +12V (24-Pin)",	 7, 0, 60, 1, 0 },
@@ -366,7 +366,7 @@ static const struct abituguru3_motherboard_info abituguru3_motherboards[] = {
 		{ "DDR",		 1, 0, 10, 1, 0 },
 		{ "DDR VTT",		 2, 0, 10, 1, 0 },
 		{ "CPU VTT 1.2V",	 3, 0, 10, 1, 0 },
-		{ "MCH & PCIE 1.5V",	 4, 0, 10, 1, 0 },
+		{ "MCH & PCIe 1.5V",	 4, 0, 10, 1, 0 },
 		{ "MCH 2.5V",		 5, 0, 20, 1, 0 },
 		{ "ICH 1.05V",		 6, 0, 10, 1, 0 },
 		{ "ATX +12V (24-Pin)",	 7, 0, 60, 1, 0 },
@@ -411,7 +411,7 @@ static const struct abituguru3_motherboard_info abituguru3_motherboards[] = {
 		{ "DDR2",		 1, 0, 20, 1, 0 },
 		{ "DDR2 VTT",		 2, 0, 10, 1, 0 },
 		{ "CPU VTT 1.2V",	 3, 0, 10, 1, 0 },
-		{ "MCH & PCIE 1.5V",	 4, 0, 10, 1, 0 },
+		{ "MCH & PCIe 1.5V",	 4, 0, 10, 1, 0 },
 		{ "MCH 2.5V",		 5, 0, 20, 1, 0 },
 		{ "ICH 1.05V",		 6, 0, 10, 1, 0 },
 		{ "ATX +12V (24-Pin)",	 7, 0, 60, 1, 0 },
@@ -443,7 +443,7 @@ static const struct abituguru3_motherboard_info abituguru3_motherboards[] = {
 		{ "NB 1.8V",		 4, 0, 10, 1, 0 },
 		{ "NB 1.2V ",		13, 0, 10, 1, 0 },
 		{ "SB 1.2V",		 5, 0, 10, 1, 0 },
-		{ "PCIE 1.2V",		12, 0, 10, 1, 0 },
+		{ "PCIe 1.2V",		12, 0, 10, 1, 0 },
 		{ "ATX +12V (24-Pin)",	 7, 0, 60, 1, 0 },
 		{ "ATX +12V (4-pin)",	 8, 0, 60, 1, 0 },
 		{ "ATX +5V",		 9, 0, 30, 1, 0 },
diff --git a/drivers/infiniband/hw/ipath/ipath_driver.c b/drivers/infiniband/hw/ipath/ipath_driver.c
index 013d138..5a3a5a3 100644
--- a/drivers/infiniband/hw/ipath/ipath_driver.c
+++ b/drivers/infiniband/hw/ipath/ipath_driver.c
@@ -532,7 +532,7 @@ static int __devinit ipath_init_one(struct pci_dev *pdev,
 		ipath_init_iba6120_funcs(dd);
 		break;
 #else
-		ipath_dev_err(dd, "QLogic PCIE device 0x%x cannot work if "
+		ipath_dev_err(dd, "QLogic PCIe device 0x%x cannot work if "
 			      "CONFIG_PCI_MSI is not enabled\n", ent->device);
 		return -ENODEV;
 #endif
diff --git a/drivers/infiniband/hw/ipath/ipath_iba6110.c b/drivers/infiniband/hw/ipath/ipath_iba6110.c
index 4bd39c8..23150e3 100644
--- a/drivers/infiniband/hw/ipath/ipath_iba6110.c
+++ b/drivers/infiniband/hw/ipath/ipath_iba6110.c
@@ -1671,7 +1671,7 @@ static int ipath_ht_early_init(struct ipath_devdata *dd)
  * @dd: the infinipath device
  * @kbase: ipath_base_info pointer
  *
- * We set the PCIE flag because the lower bandwidth on PCIe vs
+ * We set the PCIe flag because the lower bandwidth on PCIe vs
  * HyperTransport can affect some user packet algorithms.
  */
 static int ipath_ht_get_base_info(struct ipath_portdata *pd, void *kbase)
diff --git a/drivers/infiniband/hw/ipath/ipath_iba6120.c b/drivers/infiniband/hw/ipath/ipath_iba6120.c
index fbf8c53..e20cdb8 100644
--- a/drivers/infiniband/hw/ipath/ipath_iba6120.c
+++ b/drivers/infiniband/hw/ipath/ipath_iba6120.c
@@ -639,7 +639,7 @@ static int ipath_pe_boardname(struct ipath_devdata *dd, char *name,
 		ipath_dev_err(dd,
 			      "Don't yet know about board with ID %u\n",
 			      boardrev);
-		snprintf(name, namelen, "Unknown_InfiniPath_PCIe_%u",
+		snprintf(name, namelen, "Unknown_InfiniPath_PCIE_%u",
 			 boardrev);
 		break;
 	}
@@ -1561,7 +1561,7 @@ int __attribute__((weak)) ipath_unordered_wc(void)
  * @pd: the infinipath port
  * @kbase: ipath_base_info pointer
  *
- * We set the PCIE flag because the lower bandwidth on PCIe vs
+ * We set the PCIe flag because the lower bandwidth on PCIe vs
  * HyperTransport can affect some user packet algorithms.
  */
 static int ipath_pe_get_base_info(struct ipath_portdata *pd, void *kbase)
diff --git a/drivers/infiniband/hw/ipath/ipath_iba7220.c b/drivers/infiniband/hw/ipath/ipath_iba7220.c
index a805402..a29d330 100644
--- a/drivers/infiniband/hw/ipath/ipath_iba7220.c
+++ b/drivers/infiniband/hw/ipath/ipath_iba7220.c
@@ -1936,7 +1936,7 @@ static int ipath_7220_early_init(struct ipath_devdata *dd)
  * @pd: the infinipath port
  * @kbase: ipath_base_info pointer
  *
- * We set the PCIE flag because the lower bandwidth on PCIe vs
+ * We set the PCIe flag because the lower bandwidth on PCIe vs
  * HyperTransport can affect some user packet algorithims.
  */
 static int ipath_7220_get_base_info(struct ipath_portdata *pd, void *kbase)
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 8dd4d21..2c5d697 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -692,7 +692,7 @@ typedef struct _MPT_ADAPTER
 	u8			 ir_firmware; /* =1 if IR firmware detected */
 	/*
 	 * Description: errata_flag_1064
-	 * If a PCIX read occurs within 1 or 2 cycles after the chip receives
+	 * If a PCI-X read occurs within 1 or 2 cycles after the chip receives
 	 * a split completion for a read data, an internal address pointer incorrectly
 	 * increments by 32 bytes
 	 */
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index e19ca4b..066a60f 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -2619,7 +2619,7 @@ config IXGB
 	depends on PCI
 	---help---
 	  This driver supports Intel(R) PRO/10GbE family of adapters for
-	  PCI-X type cards. For PCI-E type cards, use the "ixgbe" driver
+	  PCI-X type cards. For PCIe type cards, use the "ixgbe" driver
 	  instead. For more information on how to identify your adapter, go
 	  to the Adapter & Driver ID Guide at:

diff --git a/drivers/net/atl1c/atl1c_main.c b/drivers/net/atl1c/atl1c_main.c
index 1372e9a..9e85892 100644
--- a/drivers/net/atl1c/atl1c_main.c
+++ b/drivers/net/atl1c/atl1c_main.c
@@ -89,7 +89,7 @@ static const u32 atl1c_default_msg = NETIF_MSG_DRV | NETIF_MSG_PROBE |
 	NETIF_MSG_LINK | NETIF_MSG_TIMER | NETIF_MSG_IFDOWN | NETIF_MSG_IFUP;

 /*
- * atl1c_init_pcie - init PCIE module
+ * atl1c_init_pcie - init PCIe module
  */
 static void atl1c_reset_pcie(struct atl1c_hw *hw, u32 flag)
 {
@@ -1527,7 +1527,7 @@ static irqreturn_t atl1c_intr(int irq, void *data)
 			atl1c_clean_tx_irq(adapter, atl1c_trans_normal);

 		handled = IRQ_HANDLED;
-		/* check if PCIE PHY Link down */
+		/* check if PCIe PHY Link down */
 		if (status & ISR_ERROR) {
 			if (netif_msg_hw(adapter))
 				dev_err(&pdev->dev,
diff --git a/drivers/net/atl1e/atl1e_hw.c b/drivers/net/atl1e/atl1e_hw.c
index 4a77006..5e261dd 100644
--- a/drivers/net/atl1e/atl1e_hw.c
+++ b/drivers/net/atl1e/atl1e_hw.c
@@ -273,7 +273,7 @@ int atl1e_write_phy_reg(struct atl1e_hw *hw, u32 reg_addr, u16 phy_data)
 }

 /*
- * atl1e_init_pcie - init PCIE module
+ * atl1e_init_pcie - init PCIe module
  */
 static void atl1e_init_pcie(struct atl1e_hw *hw)
 {
diff --git a/drivers/net/atl1e/atl1e_main.c b/drivers/net/atl1e/atl1e_main.c
index 955da73..805a67b 100644
--- a/drivers/net/atl1e/atl1e_main.c
+++ b/drivers/net/atl1e/atl1e_main.c
@@ -1131,7 +1131,7 @@ static int atl1e_configure(struct atl1e_adapter *adapter)
 	intr_status_data = AT_READ_REG(hw, REG_ISR);
 	if (unlikely((intr_status_data & ISR_PHY_LINKDOWN) != 0)) {
 		dev_err(&pdev->dev, "atl1e_configure failed,"
-				"PCIE phy link down\n");
+				"PCIe phy link down\n");
 		return -1;
 	}

@@ -1283,7 +1283,7 @@ static irqreturn_t atl1e_intr(int irq, void *data)
 		AT_WRITE_REG(hw, REG_ISR, status | ISR_DIS_INT);

 		handled = IRQ_HANDLED;
-		/* check if PCIE PHY Link down */
+		/* check if PCIe PHY Link down */
 		if (status & ISR_PHY_LINKDOWN) {
 			dev_err(&pdev->dev,
 				"pcie phy linkdown %x\n", status);
@@ -1298,7 +1298,7 @@ static irqreturn_t atl1e_intr(int irq, void *data)
 		/* check if DMA read/write error */
 		if (status & (ISR_DMAR_TO_RST | ISR_DMAW_TO_RST)) {
 			dev_err(&pdev->dev,
-				"PCIE DMA RW error (status = 0x%x)\n",
+				"PCIe DMA RW error (status = 0x%x)\n",
 				status);
 			atl1e_irq_reset(adapter);
 			schedule_work(&adapter->reset_task);
diff --git a/drivers/net/atlx/atl1.c b/drivers/net/atlx/atl1.c
index 00569dc..4c1ec27 100644
--- a/drivers/net/atlx/atl1.c
+++ b/drivers/net/atlx/atl1.c
@@ -1636,7 +1636,7 @@ static u32 atl1_configure(struct atl1_adapter *adapter)
 }

 /*
- * atl1_pcie_patch - Patch for PCIE module
+ * atl1_pcie_patch - Patch for PCIe module
  */
 static void atl1_pcie_patch(struct atl1_adapter *adapter)
 {
@@ -2471,7 +2471,7 @@ static irqreturn_t atl1_intr(int irq, void *data)
 		if (status & ISR_SMB)
 			atl1_inc_smb(adapter);

-		/* check if PCIE PHY Link down */
+		/* check if PCIe PHY Link down */
 		if (status & ISR_PHY_LINKDOWN) {
 			if (netif_msg_intr(adapter))
 				dev_printk(KERN_DEBUG, &adapter->pdev->dev,
@@ -2551,9 +2551,9 @@ static void atl1_phy_config(unsigned long data)
 /*
  * Orphaned vendor comment left intact here:
  * <vendor comment>
- * If TPD Buffer size equal to 0, PCIE DMAR_TO_INT
+ * If TPD Buffer size equal to 0, PCIe DMAR_TO_INT
  * will assert. We do soft reset <0x1400=1> according
- * with the SPEC. BUT, it seemes that PCIE or DMA
+ * with the SPEC. BUT, it seemes that PCIe or DMA
  * state-machine will not be reset. DMAR_TO_INT will
  * assert again and again.
  * </vendor comment>
diff --git a/drivers/net/atlx/atl2.c b/drivers/net/atlx/atl2.c
index ab68886..d9f9752 100644
--- a/drivers/net/atlx/atl2.c
+++ b/drivers/net/atlx/atl2.c
@@ -599,7 +599,7 @@ static irqreturn_t atl2_intr(int irq, void *data)
 	/* clear ISR status, and Enable CMB DMA/Disable Interrupt */
 	ATL2_WRITE_REG(hw, REG_ISR, status | ISR_DIS_INT);

-	/* check if PCIE PHY Link down */
+	/* check if PCIe PHY Link down */
 	if (status & ISR_PHY_LINKDOWN) {
 		if (netif_running(adapter->netdev)) { /* reset MAC */
 			ATL2_WRITE_REG(hw, REG_ISR, 0);
@@ -2417,7 +2417,7 @@ static void atl2_hash_set(struct atl2_hw *hw, u32 hash_value)
 }

 /*
- * atl2_init_pcie - init PCIE module
+ * atl2_init_pcie - init PCIe module
  */
 static void atl2_init_pcie(struct atl2_hw *hw)
 {
diff --git a/drivers/net/bnx2.c b/drivers/net/bnx2.c
index 08cddb6..7d44a0c 100644
--- a/drivers/net/bnx2.c
+++ b/drivers/net/bnx2.c
@@ -7719,7 +7719,7 @@ bnx2_init_board(struct pci_dev *pdev, struct net_device *dev)
 	if (CHIP_NUM(bp) == CHIP_NUM_5709) {
 		if (pci_find_capability(pdev, PCI_CAP_ID_EXP) == 0) {
 			dev_err(&pdev->dev,
-				"Cannot find PCIE capability, aborting.\n");
+				"Cannot find PCIe capability, aborting.\n");
 			rc = -EIO;
 			goto err_out_unmap;
 		}
@@ -7730,7 +7730,7 @@ bnx2_init_board(struct pci_dev *pdev, struct net_device *dev)
 		bp->pcix_cap = pci_find_capability(pdev, PCI_CAP_ID_PCIX);
 		if (bp->pcix_cap == 0) {
 			dev_err(&pdev->dev,
-				"Cannot find PCIX capability, aborting.\n");
+				"Cannot find PCI-X capability, aborting.\n");
 			rc = -EIO;
 			goto err_out_unmap;
 		}
@@ -7780,7 +7780,7 @@ bnx2_init_board(struct pci_dev *pdev, struct net_device *dev)
 		!(bp->flags & BNX2_FLAG_PCIX)) {

 		dev_err(&pdev->dev,
-			"5706 A1 can only be used in a PCIX bus, aborting.\n");
+			"5706 A1 can only be used in a PCI-X bus, aborting.\n");
 		goto err_out_unmap;
 	}

diff --git a/drivers/net/bnx2x.h b/drivers/net/bnx2x.h
index bbf8422..dec5e59 100644
--- a/drivers/net/bnx2x.h
+++ b/drivers/net/bnx2x.h
@@ -1119,7 +1119,7 @@ static inline u32 reg_poll(struct bnx2x *bp, u32 reg, u32 expected, int ms,
 					 E1HVN_MAX)


-/* PCIE link and speed */
+/* PCIe link and speed */
 #define PCICFG_LINK_WIDTH		0x1f00000
 #define PCICFG_LINK_WIDTH_SHIFT		20
 #define PCICFG_LINK_SPEED		0xf0000
diff --git a/drivers/net/bnx2x_main.c b/drivers/net/bnx2x_main.c
index 20f0ed9..e88d230 100644
--- a/drivers/net/bnx2x_main.c
+++ b/drivers/net/bnx2x_main.c
@@ -6168,7 +6168,7 @@ static int bnx2x_init_common(struct bnx2x *bp)
 	bnx2x_init_block(bp, MISC_AEU_BLOCK, COMMON_STAGE);

 	bnx2x_init_block(bp, PXPCS_BLOCK, COMMON_STAGE);
-	/* Reset PCIE errors for debug */
+	/* Reset PCIe errors for debug */
 	REG_WR(bp, 0x2814, 0xffffffff);
 	REG_WR(bp, 0x3820, 0xffffffff);

@@ -6534,7 +6534,7 @@ static int bnx2x_init_func(struct bnx2x *bp)
 	}
 	bnx2x_init_block(bp, HC_BLOCK, FUNC0_STAGE + func);

-	/* Reset PCIE errors for debug */
+	/* Reset PCIe errors for debug */
 	REG_WR(bp, 0x2114, 0xffffffff);
 	REG_WR(bp, 0x2120, 0xffffffff);

@@ -11949,7 +11949,7 @@ static int __devinit bnx2x_init_one(struct pci_dev *pdev,
 	}

 	bnx2x_get_pcie_width_speed(bp, &pcie_width, &pcie_speed);
-	printk(KERN_INFO "%s: %s (%c%d) PCI-E x%d %s found at mem %lx,"
+	printk(KERN_INFO "%s: %s (%c%d) PCIe x%d %s found at mem %lx,"
 	       " IRQ %d, ", dev->name, board_info[ent->driver_data].name,
 	       (CHIP_REV(bp) >> 12) + 'A', (CHIP_METAL(bp) >> 4),
 	       pcie_width, (pcie_speed == 2) ? "5GHz (Gen2)" : "2.5GHz",
diff --git a/drivers/net/chelsio/cxgb2.c b/drivers/net/chelsio/cxgb2.c
index 082cdb2..54dbd17 100644
--- a/drivers/net/chelsio/cxgb2.c
+++ b/drivers/net/chelsio/cxgb2.c
@@ -1171,7 +1171,7 @@ static int __devinit init_one(struct pci_dev *pdev,

 	printk(KERN_INFO "%s: %s (rev %d), %s %dMHz/%d-bit\n", adapter->name,
 	       bi->desc, adapter->params.chip_revision,
-	       adapter->params.pci.is_pcix ? "PCIX" : "PCI",
+	       adapter->params.pci.is_pcix ? "PCI-X" : "PCI",
 	       adapter->params.pci.speed, adapter->params.pci.width);

 	/*
diff --git a/drivers/net/chelsio/subr.c b/drivers/net/chelsio/subr.c
index 17720c6..a0520a2 100644
--- a/drivers/net/chelsio/subr.c
+++ b/drivers/net/chelsio/subr.c
@@ -800,7 +800,7 @@ void t1_interrupts_enable(adapter_t *adapter)
 		adapter->port[i].phy->ops->interrupt_enable(adapter->port[i].phy);
 	}

-	/* Enable PCIX & external chip interrupts on ASIC boards. */
+	/* Enable PCI-X & external chip interrupts on ASIC boards. */
 	if (t1_is_asic(adapter)) {
 		u32 pl_intr = readl(adapter->regs + A_PL_ENABLE);

@@ -830,7 +830,7 @@ void t1_interrupts_disable(adapter_t* adapter)
 		adapter->port[i].phy->ops->interrupt_disable(adapter->port[i].phy);
 	}

-	/* Disable PCIX & external chip interrupts. */
+	/* Disable PCI-X & external chip interrupts. */
 	if (t1_is_asic(adapter))
 		writel(0, adapter->regs + A_PL_ENABLE);

diff --git a/drivers/net/cxgb3/t3_hw.c b/drivers/net/cxgb3/t3_hw.c
index 032cfe0..0022346 100644
--- a/drivers/net/cxgb3/t3_hw.c
+++ b/drivers/net/cxgb3/t3_hw.c
@@ -1518,7 +1518,7 @@ static void pci_intr_handler(struct adapter *adapter)
 }

 /*
- * Interrupt handler for the PCIE module.
+ * Interrupt handler for the PCIe module.
  */
 static void pcie_intr_handler(struct adapter *adapter)
 {
diff --git a/drivers/net/e1000/e1000_hw.h b/drivers/net/e1000/e1000_hw.h
index 9acfddb..46a40b8 100644
--- a/drivers/net/e1000/e1000_hw.h
+++ b/drivers/net/e1000/e1000_hw.h
@@ -986,11 +986,11 @@ struct e1000_ffvt_entry {
 #define E1000_MANC2H     0x05860	/* Managment Control To Host - RW */
 #define E1000_SW_FW_SYNC 0x05B5C	/* Software-Firmware Synchronization - RW */

-#define E1000_GCR       0x05B00	/* PCI-Ex Control */
-#define E1000_GSCL_1    0x05B10	/* PCI-Ex Statistic Control #1 */
-#define E1000_GSCL_2    0x05B14	/* PCI-Ex Statistic Control #2 */
-#define E1000_GSCL_3    0x05B18	/* PCI-Ex Statistic Control #3 */
-#define E1000_GSCL_4    0x05B1C	/* PCI-Ex Statistic Control #4 */
+#define E1000_GCR       0x05B00	/* PCIe Control */
+#define E1000_GSCL_1    0x05B10	/* PCIe Statistic Control #1 */
+#define E1000_GSCL_2    0x05B14	/* PCIe Statistic Control #2 */
+#define E1000_GSCL_3    0x05B18	/* PCIe Statistic Control #3 */
+#define E1000_GSCL_4    0x05B1C	/* PCIe Statistic Control #4 */
 #define E1000_FACTPS    0x05B30	/* Function Active and Power State to MNG */
 #define E1000_SWSM      0x05B50	/* SW Semaphore */
 #define E1000_FWSM      0x05B54	/* FW Semaphore */
@@ -2103,9 +2103,9 @@ struct e1000_host_command_info {

 #define E1000_MDALIGN          4096

-/* PCI-Ex registers*/
+/* PCIe registers*/

-/* PCI-Ex Control Register */
+/* PCIe Control Register */
 #define E1000_GCR_RXD_NO_SNOOP          0x00000001
 #define E1000_GCR_RXDSCW_NO_SNOOP       0x00000002
 #define E1000_GCR_RXDSCR_NO_SNOOP       0x00000004
@@ -2147,7 +2147,7 @@ struct e1000_host_command_info {
 #define E1000_FACTPS_LAN_FUNC_SEL                   0x40000000
 #define E1000_FACTPS_PM_STATE_CHANGED               0x80000000

-/* PCI-Ex Config Space */
+/* PCIe Config Space */
 #define PCI_EX_LINK_STATUS           0x12
 #define PCI_EX_LINK_WIDTH_MASK       0x3F0
 #define PCI_EX_LINK_WIDTH_SHIFT      4
@@ -2347,7 +2347,7 @@ struct e1000_host_command_info {
 #define FC_DEFAULT_LO_THRESH        (0x4000)	/* 16KB */
 #define FC_DEFAULT_TX_TIMER         (0x100)	/* ~130 us */

-/* PCIX Config space */
+/* PCI-X Config space */
 #define PCIX_COMMAND_REGISTER    0xE6
 #define PCIX_STATUS_REGISTER_LO  0xE8
 #define PCIX_STATUS_REGISTER_HI  0xEA
diff --git a/drivers/net/e1000/e1000_main.c b/drivers/net/e1000/e1000_main.c
index bcd192c..124d7ea 100644
--- a/drivers/net/e1000/e1000_main.c
+++ b/drivers/net/e1000/e1000_main.c
@@ -608,7 +608,7 @@ void e1000_reset(struct e1000_adapter *adapter)
 		    ((min_tx_space - tx_space) < pba)) {
 			pba = pba - (min_tx_space - tx_space);

-			/* PCI/PCIx hardware has PBA alignment constraints */
+			/* PCI/PCI-X hardware has PBA alignment constraints */
 			switch (hw->mac_type) {
 			case e1000_82545 ... e1000_82546_rev_3:
 				pba &= ~(E1000_PBA_8K - 1);
diff --git a/drivers/net/e1000e/82571.c b/drivers/net/e1000e/82571.c
index d1e0563..03c1630 100644
--- a/drivers/net/e1000e/82571.c
+++ b/drivers/net/e1000e/82571.c
@@ -847,12 +847,12 @@ static s32 e1000_reset_hw_82571(struct e1000_hw *hw)
 	u16 i = 0;

 	/*
-	 * Prevent the PCI-E bus from sticking if there is no TLP connection
+	 * Prevent the PCIe bus from sticking if there is no TLP connection
 	 * on the last TLP read/write transaction when MAC is reset.
 	 */
 	ret_val = e1000e_disable_pcie_master(hw);
 	if (ret_val)
-		hw_dbg(hw, "PCI-E Master disable polling has failed.\n");
+		hw_dbg(hw, "PCIe Master disable polling has failed.\n");

 	hw_dbg(hw, "Masking off all interrupts\n");
 	ew32(IMC, 0xffffffff);
@@ -1117,7 +1117,7 @@ static void e1000_initialize_hw_bits_82571(struct e1000_hw *hw)
         }


-	/* PCI-Ex Control Registers */
+	/* PCIe Control Registers */
 	switch (hw->mac.type) {
 	case e1000_82574:
 	case e1000_82583:
diff --git a/drivers/net/e1000e/defines.h b/drivers/net/e1000e/defines.h
index 1190167..9db1ff4 100644
--- a/drivers/net/e1000e/defines.h
+++ b/drivers/net/e1000e/defines.h
@@ -670,7 +670,7 @@
 #define IGP_ACTIVITY_LED_ENABLE 0x0300
 #define IGP_LED3_MODE           0x07000000

-/* PCI/PCI-X/PCI-EX Config space */
+/* PCI/PCI-X/PCIe Config space */
 #define PCI_HEADER_TYPE_REGISTER     0x0E
 #define PCIE_LINK_STATUS             0x12

diff --git a/drivers/net/e1000e/es2lan.c b/drivers/net/e1000e/es2lan.c
index ae5d736..0b7a769 100644
--- a/drivers/net/e1000e/es2lan.c
+++ b/drivers/net/e1000e/es2lan.c
@@ -771,12 +771,12 @@ static s32 e1000_reset_hw_80003es2lan(struct e1000_hw *hw)
 	s32 ret_val;

 	/*
-	 * Prevent the PCI-E bus from sticking if there is no TLP connection
+	 * Prevent the PCIe bus from sticking if there is no TLP connection
 	 * on the last TLP read/write transaction when MAC is reset.
 	 */
 	ret_val = e1000e_disable_pcie_master(hw);
 	if (ret_val)
-		hw_dbg(hw, "PCI-E Master disable polling has failed.\n");
+		hw_dbg(hw, "PCIe Master disable polling has failed.\n");

 	hw_dbg(hw, "Masking off all interrupts\n");
 	ew32(IMC, 0xffffffff);
diff --git a/drivers/net/e1000e/ethtool.c b/drivers/net/e1000e/ethtool.c
index 1bf4d2a..4911697 100644
--- a/drivers/net/e1000e/ethtool.c
+++ b/drivers/net/e1000e/ethtool.c
@@ -607,7 +607,7 @@ static void e1000_get_drvinfo(struct net_device *netdev,

 	/*
 	 * EEPROM image version # is reported as firmware version # for
-	 * PCI-E controllers
+	 * PCIe controllers
 	 */
 	sprintf(firmware_version, "%d.%d-%d",
 		(adapter->eeprom_vers & 0xF000) >> 12,
diff --git a/drivers/net/e1000e/hw.h b/drivers/net/e1000e/hw.h
index aaea41e..62e25c4 100644
--- a/drivers/net/e1000e/hw.h
+++ b/drivers/net/e1000e/hw.h
@@ -209,8 +209,8 @@ enum e1e_registers {
 	E1000_KMRNCTRLSTA = 0x00034, /* MAC-PHY interface - RW */
 	E1000_MANC2H    = 0x05860, /* Management Control To Host - RW */
 	E1000_SW_FW_SYNC = 0x05B5C, /* Software-Firmware Synchronization - RW */
-	E1000_GCR	= 0x05B00, /* PCI-Ex Control */
-	E1000_GCR2      = 0x05B64, /* PCI-Ex Control #2 */
+	E1000_GCR	= 0x05B00, /* PCIe Control */
+	E1000_GCR2      = 0x05B64, /* PCIe Control #2 */
 	E1000_FACTPS    = 0x05B30, /* Function Active and Power State to MNG */
 	E1000_SWSM      = 0x05B50, /* SW Semaphore */
 	E1000_FWSM      = 0x05B54, /* FW Semaphore */
diff --git a/drivers/net/e1000e/ich8lan.c b/drivers/net/e1000e/ich8lan.c
index 51ddb04..e259d51 100644
--- a/drivers/net/e1000e/ich8lan.c
+++ b/drivers/net/e1000e/ich8lan.c
@@ -2589,12 +2589,12 @@ static s32 e1000_reset_hw_ich8lan(struct e1000_hw *hw)
 	s32 ret_val;

 	/*
-	 * Prevent the PCI-E bus from sticking if there is no TLP connection
+	 * Prevent the PCIe bus from sticking if there is no TLP connection
 	 * on the last TLP read/write transaction when MAC is reset.
 	 */
 	ret_val = e1000e_disable_pcie_master(hw);
 	if (ret_val) {
-		hw_dbg(hw, "PCI-E Master disable polling has failed.\n");
+		hw_dbg(hw, "PCIe Master disable polling has failed.\n");
 	}

 	hw_dbg(hw, "Masking off all interrupts\n");
diff --git a/drivers/net/e1000e/lib.c b/drivers/net/e1000e/lib.c
index 99ba2b8..2ba4a63 100644
--- a/drivers/net/e1000e/lib.c
+++ b/drivers/net/e1000e/lib.c
@@ -1462,7 +1462,7 @@ s32 e1000e_blink_led(struct e1000_hw *hw)
 	u32 i;

 	if (hw->phy.media_type == e1000_media_type_fiber) {
-		/* always blink LED0 for PCI-E fiber */
+		/* always blink LED0 for PCIe fiber */
 		ledctl_blink = E1000_LEDCTL_LED0_BLINK |
 		     (E1000_LEDCTL_MODE_LED_ON << E1000_LEDCTL_LED0_MODE_SHIFT);
 	} else {
diff --git a/drivers/net/igb/e1000_82575.c b/drivers/net/igb/e1000_82575.c
index f8f5772..12a1163 100644
--- a/drivers/net/igb/e1000_82575.c
+++ b/drivers/net/igb/e1000_82575.c
@@ -826,17 +826,17 @@ static s32 igb_reset_hw_82575(struct e1000_hw *hw)
 	s32 ret_val;

 	/*
-	 * Prevent the PCI-E bus from sticking if there is no TLP connection
+	 * Prevent the PCIe bus from sticking if there is no TLP connection
 	 * on the last TLP read/write transaction when MAC is reset.
 	 */
 	ret_val = igb_disable_pcie_master(hw);
 	if (ret_val)
-		hw_dbg("PCI-E Master disable polling has failed.\n");
+		hw_dbg("PCIe Master disable polling has failed.\n");

 	/* set the completion timeout for interface */
 	ret_val = igb_set_pcie_completion_timeout(hw);
 	if (ret_val) {
-		hw_dbg("PCI-E Set completion timeout has failed.\n");
+		hw_dbg("PCIe Set completion timeout has failed.\n");
 	}

 	hw_dbg("Masking off all interrupts\n");
diff --git a/drivers/net/igb/e1000_defines.h b/drivers/net/igb/e1000_defines.h
index cb91683..76a7205 100644
--- a/drivers/net/igb/e1000_defines.h
+++ b/drivers/net/igb/e1000_defines.h
@@ -573,7 +573,7 @@
 #define IGP_ACTIVITY_LED_ENABLE 0x0300
 #define IGP_LED3_MODE           0x07000000

-/* PCI/PCI-X/PCI-EX Config space */
+/* PCI/PCI-X/PCIe Config space */
 #define PCIE_LINK_STATUS             0x12
 #define PCIE_DEVICE_CONTROL2         0x28

diff --git a/drivers/net/igb/e1000_mac.c b/drivers/net/igb/e1000_mac.c
index 7d76bb0..ef4ee0b 100644
--- a/drivers/net/igb/e1000_mac.c
+++ b/drivers/net/igb/e1000_mac.c
@@ -1256,7 +1256,7 @@ s32 igb_led_off(struct e1000_hw *hw)
 }

 /**
- *  igb_disable_pcie_master - Disables PCI-express master access
+ *  igb_disable_pcie_master - Disables PCIe.press master access
  *  @hw: pointer to the HW structure
  *
  *  Returns 0 (0) if successful, else returns -10
diff --git a/drivers/net/igb/e1000_regs.h b/drivers/net/igb/e1000_regs.h
index 345d144..4f07044 100644
--- a/drivers/net/igb/e1000_regs.h
+++ b/drivers/net/igb/e1000_regs.h
@@ -305,7 +305,7 @@ enum {
 #define E1000_CCMCTL      0x05B48 /* CCM Control Register */
 #define E1000_GIOCTL      0x05B44 /* GIO Analog Control Register */
 #define E1000_SCCTL       0x05B4C /* PCIc PLL Configuration Register */
-#define E1000_GCR         0x05B00 /* PCI-Ex Control */
+#define E1000_GCR         0x05B00 /* PCIe Control */
 #define E1000_FACTPS    0x05B30 /* Function Active and Power State to MNG */
 #define E1000_SWSM      0x05B50 /* SW Semaphore */
 #define E1000_FWSM      0x05B54 /* FW Semaphore */
diff --git a/drivers/net/igb/igb_main.c b/drivers/net/igb/igb_main.c
index 714c3a4..a759efd 100644
--- a/drivers/net/igb/igb_main.c
+++ b/drivers/net/igb/igb_main.c
@@ -1567,7 +1567,7 @@ static int __devinit igb_probe(struct pci_dev *pdev,
 	dev_info(&pdev->dev, "%s: (PCIe:%s:%s) %pM\n",
 		 netdev->name,
 		 ((hw->bus.speed == e1000_bus_speed_2500)
-		  ? "2.5Gb/s" : "unknown"),
+		  ? "2.5GT/s" : "unknown"),
 		 ((hw->bus.width == e1000_bus_width_pcie_x4) ? "Width x4" :
 		  (hw->bus.width == e1000_bus_width_pcie_x2) ? "Width x2" :
 		  (hw->bus.width == e1000_bus_width_pcie_x1) ? "Width x1" :
diff --git a/drivers/net/ixgbe/ixgbe_82598.c b/drivers/net/ixgbe/ixgbe_82598.c
index e2d5343..fd5b3b4 100644
--- a/drivers/net/ixgbe/ixgbe_82598.c
+++ b/drivers/net/ixgbe/ixgbe_82598.c
@@ -747,13 +747,13 @@ static s32 ixgbe_reset_hw_82598(struct ixgbe_hw *hw)

 no_phy_reset:
 	/*
-	 * Prevent the PCI-E bus from from hanging by disabling PCI-E master
+	 * Prevent the PCIe bus from from hanging by disabling PCIe master
 	 * access and verify no pending requests before reset
 	 */
 	status = ixgbe_disable_pcie_master(hw);
 	if (status != 0) {
 		status = IXGBE_ERR_MASTER_REQUESTS_PENDING;
-		hw_dbg(hw, "PCI-E Master disable polling has failed.\n");
+		hw_dbg(hw, "PCIe Master disable polling has failed.\n");
 	}

 	/*
diff --git a/drivers/net/ixgbe/ixgbe_82599.c b/drivers/net/ixgbe/ixgbe_82599.c
index 34b0492..e4c5a73 100644
--- a/drivers/net/ixgbe/ixgbe_82599.c
+++ b/drivers/net/ixgbe/ixgbe_82599.c
@@ -793,13 +793,13 @@ static s32 ixgbe_reset_hw_82599(struct ixgbe_hw *hw)
 		hw->phy.ops.reset(hw);

 	/*
-	 * Prevent the PCI-E bus from from hanging by disabling PCI-E master
+	 * Prevent the PCIe bus from from hanging by disabling PCIe master
 	 * access and verify no pending requests before reset
 	 */
 	status = ixgbe_disable_pcie_master(hw);
 	if (status != 0) {
 		status = IXGBE_ERR_MASTER_REQUESTS_PENDING;
-		hw_dbg(hw, "PCI-E Master disable polling has failed.\n");
+		hw_dbg(hw, "PCIe Master disable polling has failed.\n");
 	}

 	/*
diff --git a/drivers/net/ixgbe/ixgbe_common.c b/drivers/net/ixgbe/ixgbe_common.c
index 40ff120..b077084 100644
--- a/drivers/net/ixgbe/ixgbe_common.c
+++ b/drivers/net/ixgbe/ixgbe_common.c
@@ -374,11 +374,11 @@ s32 ixgbe_stop_adapter_generic(struct ixgbe_hw *hw)
 	}

 	/*
-	 * Prevent the PCI-E bus from from hanging by disabling PCI-E master
+	 * Prevent the PCIe bus from from hanging by disabling PCIe master
 	 * access and verify no pending requests
 	 */
 	if (ixgbe_disable_pcie_master(hw) != 0)
-		hw_dbg(hw, "PCI-E Master disable polling has failed.\n");
+		hw_dbg(hw, "PCIe Master disable polling has failed.\n");

 	return 0;
 }
@@ -2066,7 +2066,7 @@ out:
 }

 /**
- *  ixgbe_disable_pcie_master - Disable PCI-express master access
+ *  ixgbe_disable_pcie_master - Disable PCIe.press master access
  *  @hw: pointer to hardware structure
  *
  *  Disables PCI-Express master access and verifies there are no pending
diff --git a/drivers/net/ixgbe/ixgbe_main.c b/drivers/net/ixgbe/ixgbe_main.c
index a5036f7..e303e22 100644
--- a/drivers/net/ixgbe/ixgbe_main.c
+++ b/drivers/net/ixgbe/ixgbe_main.c
@@ -5792,8 +5792,8 @@ static int __devinit ixgbe_probe(struct pci_dev *pdev,

 	/* print bus type/speed/width info */
 	dev_info(&pdev->dev, "(PCI Express:%s:%s) %pM\n",
-	        ((hw->bus.speed == ixgbe_bus_speed_5000) ? "5.0Gb/s":
-	         (hw->bus.speed == ixgbe_bus_speed_2500) ? "2.5Gb/s":"Unknown"),
+	        ((hw->bus.speed == ixgbe_bus_speed_5000) ? "5.0GT/s":
+	         (hw->bus.speed == ixgbe_bus_speed_2500) ? "2.5GT/s":"Unknown"),
 	        ((hw->bus.width == ixgbe_bus_width_pcie_x8) ? "Width x8" :
 	         (hw->bus.width == ixgbe_bus_width_pcie_x4) ? "Width x4" :
 	         (hw->bus.width == ixgbe_bus_width_pcie_x1) ? "Width x1" :
diff --git a/drivers/net/ixgbe/ixgbe_type.h b/drivers/net/ixgbe/ixgbe_type.h
index ef4bdd5..f150255 100644
--- a/drivers/net/ixgbe/ixgbe_type.h
+++ b/drivers/net/ixgbe/ixgbe_type.h
@@ -671,7 +671,7 @@
 #define IXGBE_HFDR      0x15FE8
 #define IXGBE_FLEX_MNG  0x15800 /* 0x15800 - 0x15EFC */

-/* PCI-E registers */
+/* PCIe registers */
 #define IXGBE_GCR       0x11000
 #define IXGBE_GTV       0x11004
 #define IXGBE_FUNCTAG   0x11008
diff --git a/drivers/net/myri10ge/myri10ge.c b/drivers/net/myri10ge/myri10ge.c
index f362451..1de2991 100644
--- a/drivers/net/myri10ge/myri10ge.c
+++ b/drivers/net/myri10ge/myri10ge.c
@@ -278,7 +278,7 @@ MODULE_PARM_DESC(myri10ge_fw_name, "Firmware image names per board");

 static int myri10ge_ecrc_enable = 1;
 module_param(myri10ge_ecrc_enable, int, S_IRUGO);
-MODULE_PARM_DESC(myri10ge_ecrc_enable, "Enable Extended CRC on PCI-E");
+MODULE_PARM_DESC(myri10ge_ecrc_enable, "Enable Extended CRC on PCIe");

 static int myri10ge_small_bytes = -1;	/* -1 == auto */
 module_param(myri10ge_small_bytes, int, S_IRUGO | S_IWUSR);
@@ -3138,7 +3138,7 @@ static int myri10ge_change_mtu(struct net_device *dev, int new_mtu)
 }

 /*
- * Enable ECRC to align PCI-E Completion packets on an 8-byte boundary.
+ * Enable ECRC to align PCIe Completion packets on an 8-byte boundary.
  * Only do it if the bridge is a root port since we don't want to disturb
  * any other device, except if forced with myri10ge_ecrc_enable > 1.
  */
@@ -3215,13 +3215,13 @@ static void myri10ge_enable_ecrc(struct myri10ge_priv *mgp)
 }

 /*
- * The Lanai Z8E PCI-E interface achieves higher Read-DMA throughput
- * when the PCI-E Completion packets are aligned on an 8-byte
- * boundary.  Some PCI-E chip sets always align Completion packets; on
+ * The Lanai Z8E PCIe interface achieves higher Read-DMA throughput
+ * when the PCIe Completion packets are aligned on an 8-byte
+ * boundary.  Some PCIe chip sets always align Completion packets; on
  * the ones that do not, the alignment can be enforced by enabling
  * ECRC generation (if supported).
  *
- * When PCI-E Completion packets are not aligned, it is actually more
+ * When PCIe Completion packets are not aligned, it is actually more
  * efficient to limit Read-DMA transactions to 2KB, rather than 4KB.
  *
  * If the driver can neither enable ECRC nor verify that it has
@@ -3305,7 +3305,7 @@ static void myri10ge_select_firmware(struct myri10ge_priv *mgp)
 		 * upstream bridge is known to provide aligned
 		 * completions */
 		if (link_width < 8) {
-			dev_info(&mgp->pdev->dev, "PCIE x%d Link\n",
+			dev_info(&mgp->pdev->dev, "PCIe x%d Link\n",
 				 link_width);
 			mgp->tx_boundary = 4096;
 			mgp->fw_name = myri10ge_fw_aligned;
diff --git a/drivers/net/myri10ge/myri10ge_mcp.h b/drivers/net/myri10ge/myri10ge_mcp.h
index 11be150..9e37e9c 100644
--- a/drivers/net/myri10ge/myri10ge_mcp.h
+++ b/drivers/net/myri10ge/myri10ge_mcp.h
@@ -338,8 +338,8 @@ enum myri10ge_mcp_cmd_type {
 	 * throttle_factor = 256 * pcie-raw-speed / tx_speed
 	 * tx_speed = 256 * pcie-raw-speed / throttle_factor
 	 *
-	 * For PCI-E x8: pcie-raw-speed == 16Gb/s
-	 * For PCI-E x4: pcie-raw-speed == 8Gb/s
+	 * For PCIe x8: pcie-raw-speed == 16Gb/s
+	 * For PCIe x4: pcie-raw-speed == 8Gb/s
 	 *
 	 * ex1: throttle_factor == 0x1a0 (416), tx_speed == 1.23GB/s == 9.846 Gb/s
 	 * ex2: throttle_factor == 0x200 (512), tx_speed == 1.0GB/s == 8 Gb/s
diff --git a/drivers/net/netxen/netxen_nic_hw.c b/drivers/net/netxen/netxen_nic_hw.c
index 3185a98..82ad9e7 100644
--- a/drivers/net/netxen/netxen_nic_hw.c
+++ b/drivers/net/netxen/netxen_nic_hw.c
@@ -84,7 +84,7 @@ static void __iomem *pci_base_offset(struct netxen_adapter *adapter,
 static crb_128M_2M_block_map_t
 crb_128M_2M_map[64] __cacheline_aligned_in_smp = {
     {{{0, 0,         0,         0} } },		/* 0: PCI */
-    {{{1, 0x0100000, 0x0102000, 0x120000},	/* 1: PCIE */
+    {{{1, 0x0100000, 0x0102000, 0x120000},	/* 1: PCIe */
 	  {1, 0x0110000, 0x0120000, 0x130000},
 	  {1, 0x0120000, 0x0122000, 0x124000},
 	  {1, 0x0130000, 0x0132000, 0x126000},
@@ -191,7 +191,7 @@ crb_128M_2M_map[64] __cacheline_aligned_in_smp = {
     {{{1, 0x1e00000, 0x1e01000, 0x16a000} } },/* 30: P2NR2 */
     {{{1, 0x1f00000, 0x1f10000, 0x150000} } },/* 31: EPG */
 	{{{0} } },				/* 32: PCI */
-	{{{1, 0x2100000, 0x2102000, 0x120000},	/* 33: PCIE */
+	{{{1, 0x2100000, 0x2102000, 0x120000},	/* 33: PCIe */
 	  {1, 0x2110000, 0x2120000, 0x130000},
 	  {1, 0x2120000, 0x2122000, 0x124000},
 	  {1, 0x2130000, 0x2132000, 0x126000},
diff --git a/drivers/net/qlge/qlge.h b/drivers/net/qlge/qlge.h
index c2383ad..2a736c4 100644
--- a/drivers/net/qlge/qlge.h
+++ b/drivers/net/qlge/qlge.h
@@ -15,7 +15,7 @@
  * General definitions...
  */
 #define DRV_NAME  	"qlge"
-#define DRV_STRING 	"QLogic 10 Gigabit PCI-E Ethernet Driver "
+#define DRV_STRING 	"QLogic 10 Gigabit PCIe Ethernet Driver "
 #define DRV_VERSION	"v1.00.00-b3"

 #define PFX "qlge: "
diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index b9221bd..7df679f 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -134,27 +134,27 @@ static const struct {
 	_R("RTL8169sb/8110sb",	RTL_GIGA_MAC_VER_04, 0xff7e1880), // 8169SB
 	_R("RTL8169sc/8110sc",	RTL_GIGA_MAC_VER_05, 0xff7e1880), // 8110SCd
 	_R("RTL8169sc/8110sc",	RTL_GIGA_MAC_VER_06, 0xff7e1880), // 8110SCe
-	_R("RTL8102e",		RTL_GIGA_MAC_VER_07, 0xff7e1880), // PCI-E
-	_R("RTL8102e",		RTL_GIGA_MAC_VER_08, 0xff7e1880), // PCI-E
-	_R("RTL8102e",		RTL_GIGA_MAC_VER_09, 0xff7e1880), // PCI-E
-	_R("RTL8101e",		RTL_GIGA_MAC_VER_10, 0xff7e1880), // PCI-E
-	_R("RTL8168b/8111b",	RTL_GIGA_MAC_VER_11, 0xff7e1880), // PCI-E
-	_R("RTL8168b/8111b",	RTL_GIGA_MAC_VER_12, 0xff7e1880), // PCI-E
-	_R("RTL8101e",		RTL_GIGA_MAC_VER_13, 0xff7e1880), // PCI-E 8139
-	_R("RTL8100e",		RTL_GIGA_MAC_VER_14, 0xff7e1880), // PCI-E 8139
-	_R("RTL8100e",		RTL_GIGA_MAC_VER_15, 0xff7e1880), // PCI-E 8139
-	_R("RTL8168b/8111b",	RTL_GIGA_MAC_VER_17, 0xff7e1880), // PCI-E
-	_R("RTL8101e",		RTL_GIGA_MAC_VER_16, 0xff7e1880), // PCI-E
-	_R("RTL8168cp/8111cp",	RTL_GIGA_MAC_VER_18, 0xff7e1880), // PCI-E
-	_R("RTL8168c/8111c",	RTL_GIGA_MAC_VER_19, 0xff7e1880), // PCI-E
-	_R("RTL8168c/8111c",	RTL_GIGA_MAC_VER_20, 0xff7e1880), // PCI-E
-	_R("RTL8168c/8111c",	RTL_GIGA_MAC_VER_21, 0xff7e1880), // PCI-E
-	_R("RTL8168c/8111c",	RTL_GIGA_MAC_VER_22, 0xff7e1880), // PCI-E
-	_R("RTL8168cp/8111cp",	RTL_GIGA_MAC_VER_23, 0xff7e1880), // PCI-E
-	_R("RTL8168cp/8111cp",	RTL_GIGA_MAC_VER_24, 0xff7e1880), // PCI-E
-	_R("RTL8168d/8111d",	RTL_GIGA_MAC_VER_25, 0xff7e1880), // PCI-E
-	_R("RTL8168d/8111d",	RTL_GIGA_MAC_VER_26, 0xff7e1880), // PCI-E
-	_R("RTL8168dp/8111dp",	RTL_GIGA_MAC_VER_27, 0xff7e1880)  // PCI-E
+	_R("RTL8102e",		RTL_GIGA_MAC_VER_07, 0xff7e1880), // PCIe
+	_R("RTL8102e",		RTL_GIGA_MAC_VER_08, 0xff7e1880), // PCIe
+	_R("RTL8102e",		RTL_GIGA_MAC_VER_09, 0xff7e1880), // PCIe
+	_R("RTL8101e",		RTL_GIGA_MAC_VER_10, 0xff7e1880), // PCIe
+	_R("RTL8168b/8111b",	RTL_GIGA_MAC_VER_11, 0xff7e1880), // PCIe
+	_R("RTL8168b/8111b",	RTL_GIGA_MAC_VER_12, 0xff7e1880), // PCIe
+	_R("RTL8101e",		RTL_GIGA_MAC_VER_13, 0xff7e1880), // PCIe 8139
+	_R("RTL8100e",		RTL_GIGA_MAC_VER_14, 0xff7e1880), // PCIe 8139
+	_R("RTL8100e",		RTL_GIGA_MAC_VER_15, 0xff7e1880), // PCIe 8139
+	_R("RTL8168b/8111b",	RTL_GIGA_MAC_VER_17, 0xff7e1880), // PCIe
+	_R("RTL8101e",		RTL_GIGA_MAC_VER_16, 0xff7e1880), // PCIe
+	_R("RTL8168cp/8111cp",	RTL_GIGA_MAC_VER_18, 0xff7e1880), // PCIe
+	_R("RTL8168c/8111c",	RTL_GIGA_MAC_VER_19, 0xff7e1880), // PCIe
+	_R("RTL8168c/8111c",	RTL_GIGA_MAC_VER_20, 0xff7e1880), // PCIe
+	_R("RTL8168c/8111c",	RTL_GIGA_MAC_VER_21, 0xff7e1880), // PCIe
+	_R("RTL8168c/8111c",	RTL_GIGA_MAC_VER_22, 0xff7e1880), // PCIe
+	_R("RTL8168cp/8111cp",	RTL_GIGA_MAC_VER_23, 0xff7e1880), // PCIe
+	_R("RTL8168cp/8111cp",	RTL_GIGA_MAC_VER_24, 0xff7e1880), // PCIe
+	_R("RTL8168d/8111d",	RTL_GIGA_MAC_VER_25, 0xff7e1880), // PCIe
+	_R("RTL8168d/8111d",	RTL_GIGA_MAC_VER_26, 0xff7e1880), // PCIe
+	_R("RTL8168dp/8111dp",	RTL_GIGA_MAC_VER_27, 0xff7e1880)  // PCIe
 };
 #undef _R

diff --git a/drivers/net/s2io.c b/drivers/net/s2io.c
index 0dd7839..c29fde4 100644
--- a/drivers/net/s2io.c
+++ b/drivers/net/s2io.c
@@ -1126,7 +1126,7 @@ static int s2io_print_pci_mode(struct s2io_nic *nic)
 	config->bus_speed = bus_speed[mode];

 	if (s2io_on_nec_bridge(nic->pdev)) {
-		DBG_PRINT(ERR_DBG, "%s: Device is on PCI-E bus\n",
+		DBG_PRINT(ERR_DBG, "%s: Device is on PCIe bus\n",
 			  nic->dev->name);
 		return mode;
 	}
@@ -1139,22 +1139,22 @@ static int s2io_print_pci_mode(struct s2io_nic *nic)
 		pcimode = "66MHz PCI bus";
 		break;
 	case PCI_MODE_PCIX_M1_66:
-		pcimode = "66MHz PCIX(M1) bus";
+		pcimode = "66MHz PCI-X(M1) bus";
 		break;
 	case PCI_MODE_PCIX_M1_100:
-		pcimode = "100MHz PCIX(M1) bus";
+		pcimode = "100MHz PCI-X(M1) bus";
 		break;
 	case PCI_MODE_PCIX_M1_133:
-		pcimode = "133MHz PCIX(M1) bus";
+		pcimode = "133MHz PCI-X(M1) bus";
 		break;
 	case PCI_MODE_PCIX_M2_66:
-		pcimode = "133MHz PCIX(M2) bus";
+		pcimode = "133MHz PCI-X(M2) bus";
 		break;
 	case PCI_MODE_PCIX_M2_100:
-		pcimode = "200MHz PCIX(M2) bus";
+		pcimode = "200MHz PCI-X(M2) bus";
 		break;
 	case PCI_MODE_PCIX_M2_133:
-		pcimode = "266MHz PCIX(M2) bus";
+		pcimode = "266MHz PCI-X(M2) bus";
 		break;
 	default:
 		pcimode = "unsupported bus!";
@@ -3522,7 +3522,7 @@ static void s2io_reset(struct s2io_nic *sp)
 		/* Clear "detected parity error" bit */
 		pci_write_config_word(sp->pdev, PCI_STATUS, 0x8000);

-		/* Clearing PCIX Ecc status register */
+		/* Clearing PCI-X Ecc status register */
 		pci_write_config_dword(sp->pdev, 0x68, 0x7C);

 		/* Clearing PCI_STATUS error reflected here */
diff --git a/drivers/net/sfc/falcon_hwdefs.h b/drivers/net/sfc/falcon_hwdefs.h
index 2d22611..f946a17 100644
--- a/drivers/net/sfc/falcon_hwdefs.h
+++ b/drivers/net/sfc/falcon_hwdefs.h
@@ -103,7 +103,7 @@
 #define EE_SF_CLOCK_DIV_LBN 120
 #define EE_SF_CLOCK_DIV_WIDTH 7

-/* PCIE CORE ACCESS REG */
+/* PCIe CORE ACCESS REG */
 #define PCIE_CORE_ADDR_PCIE_DEVICE_CTRL_STAT 0x68
 #define PCIE_CORE_ADDR_PCIE_LINK_CTRL_STAT 0x70
 #define PCIE_CORE_ADDR_ACK_RPL_TIMER 0x700
diff --git a/drivers/net/sky2.h b/drivers/net/sky2.h
index ed54129..1910a61 100644
--- a/drivers/net/sky2.h
+++ b/drivers/net/sky2.h
@@ -116,17 +116,17 @@ enum pci_dev_reg_5 {

 #/*	PCI_CFG_REG_1			32 bit	Config Register 1 (Yukon-Ext only) */
 enum pci_cfg_reg1 {
-	P_CF1_DIS_REL_EVT_RST	= 1<<24, /* Dis. Rel. Event during PCIE reset */
+	P_CF1_DIS_REL_EVT_RST	= 1<<24, /* Dis. Rel. Event during PCIe reset */
 										/* Bit 23..21: Release Clock on Event */
 	P_CF1_REL_LDR_NOT_FIN	= 1<<23, /* EEPROM Loader Not Finished */
 	P_CF1_REL_VMAIN_AVLBL	= 1<<22, /* Vmain available */
-	P_CF1_REL_PCIE_RESET	= 1<<21, /* PCI-E reset */
+	P_CF1_REL_PCIE_RESET	= 1<<21, /* PCIe reset */
 										/* Bit 20..18: Gate Clock on Event */
 	P_CF1_GAT_LDR_NOT_FIN	= 1<<20, /* EEPROM Loader Finished */
-	P_CF1_GAT_PCIE_RX_IDLE	= 1<<19, /* PCI-E Rx Electrical idle */
-	P_CF1_GAT_PCIE_RESET	= 1<<18, /* PCI-E Reset */
-	P_CF1_PRST_PHY_CLKREQ	= 1<<17, /* Enable PCI-E rst & PM2PHY gen. CLKREQ */
-	P_CF1_PCIE_RST_CLKREQ	= 1<<16, /* Enable PCI-E rst generate CLKREQ */
+	P_CF1_GAT_PCIE_RX_IDLE	= 1<<19, /* PCIe Rx Electrical idle */
+	P_CF1_GAT_PCIE_RESET	= 1<<18, /* PCIe Reset */
+	P_CF1_PRST_PHY_CLKREQ	= 1<<17, /* Enable PCIe rst & PM2PHY gen. CLKREQ */
+	P_CF1_PCIE_RST_CLKREQ	= 1<<16, /* Enable PCIe rst generate CLKREQ */

 	P_CF1_ENA_CFG_LDR_DONE	= 1<<8, /* Enable core level Config loader done */

diff --git a/drivers/net/tehuti.c b/drivers/net/tehuti.c
index ec9dfb2..6b7b5df 100644
--- a/drivers/net/tehuti.c
+++ b/drivers/net/tehuti.c
@@ -226,10 +226,10 @@ static void bdx_isr_extra(struct bdx_priv *priv, u32 isr)
 		bdx_link_changed(priv);

 	if (isr & IR_PCIE_LINK)
-		ERR("%s: PCI-E Link Fault\n", priv->ndev->name);
+		ERR("%s: PCIe Link Fault\n", priv->ndev->name);

 	if (isr & IR_PCIE_TOUT)
-		ERR("%s: PCI-E Time Out\n", priv->ndev->name);
+		ERR("%s: PCIe Time Out\n", priv->ndev->name);

 }

@@ -458,7 +458,7 @@ static int bdx_hw_reset_direct(void __iomem *regs)
 	/* check that the PLLs are locked and reset ended */
 	for (i = 0; i < 70; i++, mdelay(10))
 		if ((readl(regs + regCLKPLL) & CLKPLL_LKD) == CLKPLL_LKD) {
-			/* do any PCI-E read transaction */
+			/* do any PCIe read transaction */
 			readl(regs + regRXD_CFG0_0);
 			return 0;
 		}
@@ -482,7 +482,7 @@ static int bdx_hw_reset(struct bdx_priv *priv)
 	/* check that the PLLs are locked and reset ended */
 	for (i = 0; i < 70; i++, mdelay(10))
 		if ((READ_REG(priv, regCLKPLL) & CLKPLL_LKD) == CLKPLL_LKD) {
-			/* do any PCI-E read transaction */
+			/* do any PCIe read transaction */
 			READ_REG(priv, regRXD_CFG0_0);
 			return 0;
 		}
diff --git a/drivers/net/tehuti.h b/drivers/net/tehuti.h
index 4fc875e..aaec66b 100644
--- a/drivers/net/tehuti.h
+++ b/drivers/net/tehuti.h
@@ -515,7 +515,7 @@ struct txd_desc {
 #define  CLKPLL_LKD             (CLKPLL_PLLLKD|CLKPLL_RSTEND)

 /*
- * PCI-E Device Control Register (Offset 0x88)
+ * PCIe Device Control Register (Offset 0x88)
  * Source: Luxor Data Sheet, 7.1.3.3.3
  */
 #define PCI_DEV_CTRL_REG 0x88
@@ -523,7 +523,7 @@ struct txd_desc {
 #define GET_DEV_CTRL_MRRS(x)            GET_BITS_SHIFT(x, 3, 12)

 /*
- * PCI-E Link Status Register (Offset 0x92)
+ * PCIe Link Status Register (Offset 0x92)
  * Source: Luxor Data Sheet, 7.1.3.3.7
  */
 #define PCI_LINK_STATUS_REG 0x92
diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
index ba5d3fe..c0072ad 100644
--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -12959,7 +12959,7 @@ static int __devinit tg3_get_invariants(struct tg3 *tp)

 			/* Write some dummy words into the SRAM status block
 			 * area, see if it reads back correctly.  If the return
-			 * value is bad, force enable the PCIX workaround.
+			 * value is bad, force enable the PCI-X workaround.
 			 */
 			sram_base = tp->regs + NIC_SRAM_WIN_BASE + NIC_SRAM_STATS_BLK;

@@ -13227,7 +13227,7 @@ static u32 __devinit tg3_calc_dma_bndry(struct tg3 *tp, u32 val)
 	 * when a device tries to burst across a cache-line boundary.
 	 * Therefore, letting tg3 do so just wastes PCI bandwidth.
 	 *
-	 * Unfortunately, for PCI-E there are only limited
+	 * Unfortunately, for PCIe there are only limited
 	 * write-side controls for this, and thus for reads
 	 * we will still get the disconnects.  We'll also waste
 	 * these PCI cycles for both read and write for chips
@@ -13428,7 +13428,7 @@ static int __devinit tg3_test_dma(struct tg3 *tp)
 	tp->dma_rwctrl = tg3_calc_dma_bndry(tp, tp->dma_rwctrl);

 	if (tp->tg3_flags2 & TG3_FLG2_PCI_EXPRESS) {
-		/* DMA read watermark not used on PCIE */
+		/* DMA read watermark not used on PCIe */
 		tp->dma_rwctrl |= 0x00180000;
 	} else if (!(tp->tg3_flags & TG3_FLAG_PCIX_MODE)) {
 		if (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5705 ||
@@ -13454,16 +13454,16 @@ static int __devinit tg3_test_dma(struct tg3 *tp)

 			if (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5703)
 				read_water = 4;
-			/* Set bit 23 to enable PCIX hw bug fix */
+			/* Set bit 23 to enable PCI-X hw bug fix */
 			tp->dma_rwctrl |=
 				(read_water << DMA_RWCTRL_READ_WATER_SHIFT) |
 				(0x3 << DMA_RWCTRL_WRITE_WATER_SHIFT) |
 				(1 << 23);
 		} else if (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5780) {
-			/* 5780 always in PCIX mode */
+			/* 5780 always in PCI-X mode */
 			tp->dma_rwctrl |= 0x00144000;
 		} else if (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5714) {
-			/* 5714 always in PCIX mode */
+			/* 5714 always in PCI-X mode */
 			tp->dma_rwctrl |= 0x00148000;
 		} else {
 			tp->dma_rwctrl |= 0x001b000f;
diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 6cd5efc..16d7396 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -62,7 +62,7 @@
 #define PCI_DEVICE_ID_ATHEROS_AR5212_0019 	0x0019 /* AR5212 compatible */
 #define PCI_DEVICE_ID_ATHEROS_AR2413 		0x001a /* AR2413 (Griffin-lite) */
 #define PCI_DEVICE_ID_ATHEROS_AR5413 		0x001b /* AR5413 (Eagle) */
-#define PCI_DEVICE_ID_ATHEROS_AR5424 		0x001c /* AR5424 (Condor PCI-E) */
+#define PCI_DEVICE_ID_ATHEROS_AR5424 		0x001c /* AR5424 (Condor PCIe) */
 #define PCI_DEVICE_ID_ATHEROS_AR5416 		0x0023 /* AR5416 */
 #define PCI_DEVICE_ID_ATHEROS_AR5418 		0x0024 /* AR5418 */

@@ -315,8 +315,8 @@ struct ath5k_srev_name {
 #define AR5K_SREV_AR5413	0xa4 /* Eagle lite */
 #define AR5K_SREV_AR5414	0xa0 /* Eagle */
 #define AR5K_SREV_AR2415	0xb0 /* Talon */
-#define AR5K_SREV_AR5416	0xc0 /* PCI-E */
-#define AR5K_SREV_AR5418	0xca /* PCI-E */
+#define AR5K_SREV_AR5416	0xc0 /* PCIe */
+#define AR5K_SREV_AR5418	0xca /* PCIe */
 #define AR5K_SREV_AR2425	0xe0 /* Swan */
 #define AR5K_SREV_AR2417	0xf0 /* Nala */

diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index 71a1bd2..703f33f 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -279,7 +279,7 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc)
 	}

 	/*
-	 * Write PCI-E power save settings
+	 * Write PCIe power save settings
 	 */
 	if ((ah->ah_version == AR5K_AR5212) && (pdev->is_pcie)) {
 		struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
@@ -291,7 +291,7 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc)
 		ath5k_hw_reg_write(ah, 0x28000039, AR5K_PCIE_SERDES);
 		ath5k_hw_reg_write(ah, 0x53160824, AR5K_PCIE_SERDES);

-		/* If serdes programing is enabled, increase PCI-E
+		/* If serdes programing is enabled, increase PCIe
 		 * tx power for systems with long trace from host
 		 * to minicard connector. */
 		if (ee->ee_serdes)
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 95a8e23..88c1ccf 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -100,7 +100,7 @@ static const struct pci_device_id ath5k_pci_id_table[] = {
 	{ PCI_VDEVICE(ATHEROS, 0x0019) }, /* 5212 combatible */
 	{ PCI_VDEVICE(ATHEROS, 0x001a) }, /* 2413 Griffin-lite */
 	{ PCI_VDEVICE(ATHEROS, 0x001b) }, /* 5413 Eagle */
-	{ PCI_VDEVICE(ATHEROS, 0x001c) }, /* PCI-E cards */
+	{ PCI_VDEVICE(ATHEROS, 0x001c) }, /* PCIe cards */
 	{ PCI_VDEVICE(ATHEROS, 0x001d) }, /* 2417 Nala */
 	{ 0 }
 };
diff --git a/drivers/net/wireless/ath/ath5k/eeprom.h b/drivers/net/wireless/ath/ath5k/eeprom.h
index 0123f35..23b1e92 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.h
+++ b/drivers/net/wireless/ath/ath5k/eeprom.h
@@ -19,7 +19,7 @@
 /*
  * Common ar5xxx EEPROM data offsets (set these on AR5K_EEPROM_BASE)
  */
-#define	AR5K_EEPROM_PCIE_OFFSET		0x02	/* Contains offset to PCI-E infos */
+#define	AR5K_EEPROM_PCIE_OFFSET		0x02	/* Contains offset to PCIe infos */
 #define	AR5K_EEPROM_PCIE_SERDES_SECTION	0x40	/* PCIE_OFFSET points here when
 						 * SERDES infos are present */
 #define AR5K_EEPROM_MAGIC		0x003d	/* EEPROM Magic number */
diff --git a/drivers/net/wireless/ath/ath5k/reg.h b/drivers/net/wireless/ath/ath5k/reg.h
index c63ea6a..f3d27e5 100644
--- a/drivers/net/wireless/ath/ath5k/reg.h
+++ b/drivers/net/wireless/ath/ath5k/reg.h
@@ -982,7 +982,7 @@
 #define AR5K_5414_CBCFG_BUF_DIS	0x10	/* Disable buffer */

 /*
- * PCI-E Power management configuration
+ * PCIe Power management configuration
  * and status register [5424+]
  */
 #define	AR5K_PCIE_PM_CTL		0x4068			/* Register address */
@@ -1003,12 +1003,12 @@
 #define	AR5K_PCIE_PM_CTL_PSM_D3		0x00000400

 /*
- * PCI-E Workaround enable register
+ * PCIe Workaround enable register
  */
 #define	AR5K_PCIE_WAEN	0x407c

 /*
- * PCI-E Serializer/Desirializer
+ * PCIe Serializer/Desirializer
  * registers
  */
 #define	AR5K_PCIE_SERDES	0x4080
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 34e13c7..46b7fc2 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -327,9 +327,9 @@ int ath5k_hw_on_hold(struct ath5k_hw *ah)
 	/*
 	 * Put chipset on warm reset...
 	 *
-	 * Note: puting PCI core on warm reset on PCI-E cards
+	 * Note: puting PCI core on warm reset on PCIe cards
 	 * results card to hang and always return 0xffff... so
-	 * we ingore that flag for PCI-E cards. On PCI cards
+	 * we ingore that flag for PCIe cards. On PCI cards
 	 * this flag gets cleared after 64 PCI clocks.
 	 */
 	bus_flags = (pdev->is_pcie) ? 0 : AR5K_RESET_CTL_PCI;
@@ -385,9 +385,9 @@ int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 	/*
 	 * Put chipset on warm reset...
 	 *
-	 * Note: puting PCI core on warm reset on PCI-E cards
+	 * Note: puting PCI core on warm reset on PCIe cards
 	 * results card to hang and always return 0xffff... so
-	 * we ingore that flag for PCI-E cards. On PCI cards
+	 * we ingore that flag for PCIe cards. On PCI cards
 	 * this flag gets cleared after 64 PCI clocks.
 	 */
 	bus_flags = (pdev->is_pcie) ? 0 : AR5K_RESET_CTL_PCI;
@@ -1361,7 +1361,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	 * a DMA size of 512 causes rx overruns and tx errors
 	 * on pci-e cards (tested on 5424 but since rx overruns
 	 * also occur on 5416/5418 with madwifi we set 128
-	 * for all PCI-E cards to be safe).
+	 * for all PCIe cards to be safe).
 	 *
 	 * XXX: need to check 5210 for this
 	 * TODO: Check out tx triger level, it's always 64 on dumps but I
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 903dd8a..6b0d50a 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -20,13 +20,13 @@

 static struct pci_device_id ath_pci_id_table[] __devinitdata = {
 	{ PCI_VDEVICE(ATHEROS, 0x0023) }, /* PCI   */
-	{ PCI_VDEVICE(ATHEROS, 0x0024) }, /* PCI-E */
+	{ PCI_VDEVICE(ATHEROS, 0x0024) }, /* PCIe */
 	{ PCI_VDEVICE(ATHEROS, 0x0027) }, /* PCI   */
 	{ PCI_VDEVICE(ATHEROS, 0x0029) }, /* PCI   */
-	{ PCI_VDEVICE(ATHEROS, 0x002A) }, /* PCI-E */
-	{ PCI_VDEVICE(ATHEROS, 0x002B) }, /* PCI-E */
+	{ PCI_VDEVICE(ATHEROS, 0x002A) }, /* PCIe */
+	{ PCI_VDEVICE(ATHEROS, 0x002B) }, /* PCIe */
 	{ PCI_VDEVICE(ATHEROS, 0x002D) }, /* PCI   */
-	{ PCI_VDEVICE(ATHEROS, 0x002E) }, /* PCI-E */
+	{ PCI_VDEVICE(ATHEROS, 0x002E) }, /* PCIe */
 	{ 0 }
 };

diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
index 0325d98..38183a5 100644
--- a/drivers/pci/hotplug/pci_hotplug_core.c
+++ b/drivers/pci/hotplug/pci_hotplug_core.c
@@ -68,26 +68,26 @@ static DEFINE_MUTEX(pci_hp_mutex);
 static char *pci_bus_speed_strings[] = {
 	"33 MHz PCI",		/* 0x00 */
 	"66 MHz PCI",		/* 0x01 */
-	"66 MHz PCIX", 		/* 0x02 */
-	"100 MHz PCIX",		/* 0x03 */
-	"133 MHz PCIX",		/* 0x04 */
+	"66 MHz PCI-X",		/* 0x02 */
+	"100 MHz PCI-X",	/* 0x03 */
+	"133 MHz PCI-X",	/* 0x04 */
 	NULL,			/* 0x05 */
 	NULL,			/* 0x06 */
 	NULL,			/* 0x07 */
 	NULL,			/* 0x08 */
-	"66 MHz PCIX 266",	/* 0x09 */
-	"100 MHz PCIX 266",	/* 0x0a */
-	"133 MHz PCIX 266",	/* 0x0b */
+	"66 MHz PCI-X 266",	/* 0x09 */
+	"100 MHz PCI-X 266",	/* 0x0a */
+	"133 MHz PCI-X 266",	/* 0x0b */
 	NULL,			/* 0x0c */
 	NULL,			/* 0x0d */
 	NULL,			/* 0x0e */
 	NULL,			/* 0x0f */
 	NULL,			/* 0x10 */
-	"66 MHz PCIX 533",	/* 0x11 */
-	"100 MHz PCIX 533",	/* 0x12 */
-	"133 MHz PCIX 533",	/* 0x13 */
-	"2.5 GT/s PCI-E",	/* 0x14 */
-	"5.0 GT/s PCI-E",	/* 0x15 */
+	"66 MHz PCI-X 533",	/* 0x11 */
+	"100 MHz PCI-X 533",	/* 0x12 */
+	"133 MHz PCI-X 533",	/* 0x13 */
+	"2.5 GT/s PCIe",	/* 0x14 */
+	"5.0 GT/s PCIe",	/* 0x15 */
 };

 #ifdef CONFIG_HOTPLUG_PCI_CPCI
diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index 9ef4605..0bebf6c 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -687,10 +687,10 @@ int pciehp_get_max_link_speed(struct slot *slot, enum pci_bus_speed *value)

 	switch (lnk_cap & 0x000F) {
 	case 1:
-		lnk_speed = PCIE_2_5GB;
+		lnk_speed = PCIE_2_5GT;
 		break;
 	case 2:
-		lnk_speed = PCIE_5_0GB;
+		lnk_speed = PCIE_5_0GT;
 		break;
 	default:
 		lnk_speed = PCIE_LNK_SPEED_UNKNOWN;
@@ -769,10 +769,10 @@ int pciehp_get_cur_link_speed(struct slot *slot, enum pci_bus_speed *value)

 	switch (lnk_status & PCI_EXP_LNKSTA_CLS) {
 	case 1:
-		lnk_speed = PCIE_2_5GB;
+		lnk_speed = PCIE_2_5GT;
 		break;
 	case 2:
-		lnk_speed = PCIE_5_0GB;
+		lnk_speed = PCIE_5_0GT;
 		break;
 	default:
 		lnk_speed = PCIE_LNK_SPEED_UNKNOWN;
diff --git a/drivers/pci/hotplug/shpchp.h b/drivers/pci/hotplug/shpchp.h
index bd588eb..8e210cd 100644
--- a/drivers/pci/hotplug/shpchp.h
+++ b/drivers/pci/hotplug/shpchp.h
@@ -121,7 +121,7 @@ struct controller {
 #define PCI_DEVICE_ID_AMD_GOLAM_7450	0x7450
 #define PCI_DEVICE_ID_AMD_POGO_7458	0x7458

-/* AMD PCIX bridge registers */
+/* AMD PCI-X bridge registers */
 #define PCIX_MEM_BASE_LIMIT_OFFSET	0x1C
 #define PCIX_MISCII_OFFSET		0x48
 #define PCIX_MISC_BRIDGE_ERRORS_OFFSET	0x80
diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index 0ed78a7..cd9712d 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -486,7 +486,7 @@ int set_msi_sid(struct irte *irte, struct pci_dev *dev)

 	bridge = pci_find_upstream_pcie_bridge(dev);
 	if (bridge) {
-		if (bridge->is_pcie) /* this is a PCIE-to-PCI/PCIX bridge */
+		if (bridge->is_pcie) /* this is a PCIe-to-PCI/PCI-X bridge */
 			set_irte_sid(irte, SVT_VERIFY_BUS, SQ_ALL_16,
 				(bridge->bus->number << 8) | dev->bus->number);
 		else /* this is a legacy PCI bridge */
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 4e4c295..4d2c096 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1140,11 +1140,11 @@ pci_disable_device(struct pci_dev *dev)

 /**
  * pcibios_set_pcie_reset_state - set reset state for device dev
- * @dev: the PCI-E device reset
+ * @dev: the PCIe device reset
  * @state: Reset state to enter into
  *
  *
- * Sets the PCI-E reset state for the device. This is the default
+ * Sets the PCIe reset state for the device. This is the default
  * implementation. Architecture implementations can override this.
  */
 int __attribute__ ((weak)) pcibios_set_pcie_reset_state(struct pci_dev *dev,
@@ -1155,7 +1155,7 @@ int __attribute__ ((weak)) pcibios_set_pcie_reset_state(struct pci_dev *dev,

 /**
  * pci_set_pcie_reset_state - set reset state for device dev
- * @dev: the PCI-E device reset
+ * @dev: the PCIe device reset
  * @state: Reset state to enter into
  *
  *
diff --git a/drivers/pci/pcie/aer/Kconfig.debug b/drivers/pci/pcie/aer/Kconfig.debug
index b8c925c..edfe756 100644
--- a/drivers/pci/pcie/aer/Kconfig.debug
+++ b/drivers/pci/pcie/aer/Kconfig.debug
@@ -3,14 +3,14 @@
 #

 config PCIEAER_INJECT
-	tristate "PCIE AER error injector support"
+	tristate "PCIe AER error injector support"
 	depends on PCIEAER
 	default n
 	help
 	  This enables PCI Express Root Port Advanced Error Reporting
 	  (AER) software error injector.

-	  Debuging PCIE AER code is quite difficult because it is hard
+	  Debuging PCIe AER code is quite difficult because it is hard
 	  to trigger various real hardware errors. Software based
 	  error injection can fake almost all kinds of errors with the
 	  help of a user space helper tool aer-inject, which can be
diff --git a/drivers/pci/pcie/aer/aer_inject.c b/drivers/pci/pcie/aer/aer_inject.c
index 62d15f6..8e056f2 100644
--- a/drivers/pci/pcie/aer/aer_inject.c
+++ b/drivers/pci/pcie/aer/aer_inject.c
@@ -1,7 +1,7 @@
 /*
- * PCIE AER software error injection support.
+ * PCIe AER software error injection support.
  *
- * Debuging PCIE AER code is quite difficult because it is hard to
+ * Debuging PCIe AER code is quite difficult because it is hard to
  * trigger various real hardware errors. Software based error
  * injection can fake almost all kinds of errors with the help of a
  * user space helper tool aer-inject, which can be gotten from:
@@ -462,5 +462,5 @@ static void __exit aer_inject_exit(void)
 module_init(aer_inject_init);
 module_exit(aer_inject_exit);

-MODULE_DESCRIPTION("PCIE AER software error injector");
+MODULE_DESCRIPTION("PCIe AER software error injector");
 MODULE_LICENSE("GPL");
diff --git a/drivers/pci/pcie/aer/aerdrv.c b/drivers/pci/pcie/aer/aerdrv.c
index 40c3cc5..499aacd 100644
--- a/drivers/pci/pcie/aer/aerdrv.c
+++ b/drivers/pci/pcie/aer/aerdrv.c
@@ -155,7 +155,7 @@ static struct aer_rpc *aer_alloc_rpc(struct pcie_device *dev)
 	mutex_init(&rpc->rpc_mutex);
 	init_waitqueue_head(&rpc->wait_release);

-	/* Use PCIE bus function to store rpc into PCIE device */
+	/* Use PCIe bus function to store rpc into PCIe device */
 	set_service_data(dev, rpc);

 	return rpc;
diff --git a/drivers/pci/pcie/aer/aerdrv_acpi.c b/drivers/pci/pcie/aer/aerdrv_acpi.c
index 8edb2f3..0481408 100644
--- a/drivers/pci/pcie/aer/aerdrv_acpi.c
+++ b/drivers/pci/pcie/aer/aerdrv_acpi.c
@@ -24,7 +24,7 @@
  *
  * @return: Zero on success. Nonzero otherwise.
  *
- * Invoked when PCIE bus loads AER service driver. To avoid conflict with
+ * Invoked when PCIe bus loads AER service driver. To avoid conflict with
  * BIOS AER support requires BIOS to yield AER control to OS native driver.
  **/
 int aer_osc_setup(struct pcie_device *pciedev)
diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
index 9f5ccbe..9ab97a8 100644
--- a/drivers/pci/pcie/aer/aerdrv_core.c
+++ b/drivers/pci/pcie/aer/aerdrv_core.c
@@ -603,7 +603,7 @@ static void handle_error_source(struct pcie_device *aerdev,
  * aer_enable_rootport - enable Root Port's interrupts when receiving messages
  * @rpc: pointer to a Root Port data structure
  *
- * Invoked when PCIE bus loads AER service driver.
+ * Invoked when PCIe bus loads AER service driver.
  */
 void aer_enable_rootport(struct aer_rpc *rpc)
 {
@@ -613,7 +613,7 @@ void aer_enable_rootport(struct aer_rpc *rpc)
 	u32 reg32;

 	pos = pci_find_capability(pdev, PCI_CAP_ID_EXP);
-	/* Clear PCIE Capability's Device Status */
+	/* Clear PCIe Capability's Device Status */
 	pci_read_config_word(pdev, pos+PCI_EXP_DEVSTA, &reg16);
 	pci_write_config_word(pdev, pos+PCI_EXP_DEVSTA, reg16);

@@ -647,7 +647,7 @@ void aer_enable_rootport(struct aer_rpc *rpc)
  * disable_root_aer - disable Root Port's interrupts when receiving messages
  * @rpc: pointer to a Root Port data structure
  *
- * Invoked when PCIE bus unloads AER service driver.
+ * Invoked when PCIe bus unloads AER service driver.
  */
 static void disable_root_aer(struct aer_rpc *rpc)
 {
diff --git a/drivers/pci/pcie/aer/aerdrv_errprint.c b/drivers/pci/pcie/aer/aerdrv_errprint.c
index 44acde7..9d3e4c8 100644
--- a/drivers/pci/pcie/aer/aerdrv_errprint.c
+++ b/drivers/pci/pcie/aer/aerdrv_errprint.c
@@ -184,7 +184,7 @@ void aer_print_error(struct pci_dev *dev, struct aer_err_info *info)

 	if (info->status == 0) {
 		AER_PR(info, dev,
-			"PCIE Bus Error: severity=%s, type=Unaccessible, "
+			"PCIe Bus Error: severity=%s, type=Unaccessible, "
 			"id=%04x(Unregistered Agent ID)\n",
 			aer_error_severity_string[info->severity], id);
 	} else {
@@ -194,7 +194,7 @@ void aer_print_error(struct pci_dev *dev, struct aer_err_info *info)
 		agent = AER_GET_AGENT(info->severity, info->status);

 		AER_PR(info, dev,
-			"PCIE Bus Error: severity=%s, type=%s, id=%04x(%s)\n",
+			"PCIe Bus Error: severity=%s, type=%s, id=%04x(%s)\n",
 			aer_error_severity_string[info->severity],
 			aer_error_layer[layer], id, aer_agent_string[agent]);

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 5b7056c..1dd123e 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -1,6 +1,6 @@
 /*
  * File:	drivers/pci/pcie/aspm.c
- * Enabling PCIE link L0s/L1 state and Clock Power Management
+ * Enabling PCIe link L0s/L1 state and Clock Power Management
  *
  * Copyright (C) 2007 Intel
  * Copyright (C) Zhang Yanmin (yanmin.zhang@intel.com)
@@ -499,7 +499,7 @@ static int pcie_aspm_sanity_check(struct pci_dev *pdev)
 	int pos;
 	u32 reg32;
 	/*
-	 * Some functions in a slot might not all be PCIE functions,
+	 * Some functions in a slot might not all be PCIe functions,
 	 * very strange. Disable ASPM for the whole slot
 	 */
 	list_for_each_entry(child, &pdev->subordinate->devices, bus_list) {
diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
index f635e47..6788d0f 100644
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -24,7 +24,7 @@
  */
 #define DRIVER_VERSION "v1.0"
 #define DRIVER_AUTHOR "tom.l.nguyen@intel.com"
-#define DRIVER_DESC "PCIE Port Bus Driver"
+#define DRIVER_DESC "PCIe Port Bus Driver"
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index ec41535..d182027 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -17,7 +17,7 @@ DECLARE_RWSEM(pci_bus_sem);
 /*
  * find the upstream PCIE-to-PCI bridge of a PCI device
  * if the device is PCIE, return NULL
- * if the device isn't connected to a PCIE bridge (that is its parent is a
+ * if the device isn't connected to a PCIe bridge (that is its parent is a
  * legacy PCI bridge and the bridge is directly connected to bus 0), return its
  * parent
  */
@@ -37,7 +37,7 @@ pci_find_upstream_pcie_bridge(struct pci_dev *pdev)
 			tmp = pdev;
 			continue;
 		}
-		/* PCI device should connect to a PCIE bridge */
+		/* PCI device should connect to a PCIe bridge */
 		if (pdev->pcie_type != PCI_EXP_TYPE_PCI_BRIDGE) {
 			/* Busted hardware? */
 			WARN_ON_ONCE(1);
diff --git a/drivers/scsi/aic7xxx/aic79xx.h b/drivers/scsi/aic7xxx/aic79xx.h
index be5558a..4a4f49f 100644
--- a/drivers/scsi/aic7xxx/aic79xx.h
+++ b/drivers/scsi/aic7xxx/aic79xx.h
@@ -202,7 +202,7 @@ typedef enum {
 	AHD_AIC7902	= 0x0002,
 	AHD_AIC7901A	= 0x0003,
 	AHD_PCI		= 0x0100,	/* Bus type PCI */
-	AHD_PCIX	= 0x0200,	/* Bus type PCIX */
+	AHD_PCIX	= 0x0200,	/* Bus type PCI-X */
 	AHD_BUS_MASK	= 0x0F00
 } ahd_chip;

@@ -246,13 +246,13 @@ typedef enum {
 	AHD_NLQICRC_DELAYED_BUG	= 0x0010,
 	/* The chip must be reset for all outgoing bus resets.  */
 	AHD_SCSIRST_BUG		= 0x0020,
-	/* Some PCIX fields must be saved and restored across chip reset. */
+	/* Some PCI-X fields must be saved and restored across chip reset. */
 	AHD_PCIX_CHIPRST_BUG	= 0x0040,
 	/* MMAPIO is not functional in PCI-X mode.  */
 	AHD_PCIX_MMAPIO_BUG	= 0x0080,
 	/* Reads to SCBRAM fail to reset the discard timer. */
 	AHD_PCIX_SCBRAM_RD_BUG  = 0x0100,
-	/* Bug workarounds that can be disabled on non-PCIX busses. */
+	/* Bug workarounds that can be disabled on non-PCI-X busses. */
 	AHD_PCIX_BUG_MASK	= AHD_PCIX_CHIPRST_BUG
 				| AHD_PCIX_MMAPIO_BUG
 				| AHD_PCIX_SCBRAM_RD_BUG,
diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 63b521d..e707514 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -7366,7 +7366,7 @@ ahd_chip_init(struct ahd_softc *ahd)
 	if ((ahd->chip & AHD_BUS_MASK) == AHD_PCIX)
 		/*
 		 * Do not issue a target abort when a split completion
-		 * error occurs.  Let our PCIX interrupt handler deal
+		 * error occurs.  Let our PCI-X interrupt handler deal
 		 * with it instead. H2A4 Razor #625
 		 */
 		ahd_outb(ahd, PCIXCTL, ahd_inb(ahd, PCIXCTL) | SPLTSTADIS);
diff --git a/drivers/scsi/aic7xxx/aic79xx_pci.c b/drivers/scsi/aic7xxx/aic79xx_pci.c
index 90a04a3..be65b39 100644
--- a/drivers/scsi/aic7xxx/aic79xx_pci.c
+++ b/drivers/scsi/aic7xxx/aic79xx_pci.c
@@ -109,7 +109,7 @@ static const struct ahd_pci_identity ahd_pci_ident_table[] =
 	{
 		ID_AHA_29320ALP,
 		ID_ALL_MASK,
-		"Adaptec 29320ALP PCIx Ultra320 SCSI adapter",
+		"Adaptec 29320ALP PCI-X Ultra320 SCSI adapter",
 		ahd_aic7901_setup
 	},
 	{
@@ -317,7 +317,7 @@ ahd_pci_config(struct ahd_softc *ahd, const struct ahd_pci_identity *entry)
 	devconfig = ahd_pci_read_config(ahd->dev_softc, DEVCONFIG, /*bytes*/4);
 	if ((devconfig & PCIXINITPAT) == PCIXINIT_PCI33_66) {
 		ahd->chip |= AHD_PCI;
-		/* Disable PCIX workarounds when running in PCI mode. */
+		/* Disable PCI-X workarounds when running in PCI mode. */
 		ahd->bugs &= ~AHD_PCIX_BUG_MASK;
 	} else {
 		ahd->chip |= AHD_PCIX;
diff --git a/drivers/scsi/aic94xx/aic94xx_hwi.c b/drivers/scsi/aic94xx/aic94xx_hwi.c
index eb9dc31..d0cc457 100644
--- a/drivers/scsi/aic94xx/aic94xx_hwi.c
+++ b/drivers/scsi/aic94xx/aic94xx_hwi.c
@@ -967,7 +967,7 @@ static void asd_rbi_exsi_isr(struct asd_ha_struct *asd_ha)
  * asd_hst_pcix_isr -- process host interface interrupts
  * @asd_ha: pointer to host adapter structure
  *
- * Asserted on PCIX errors: target abort, etc.
+ * Asserted on PCI-X errors: target abort, etc.
  */
 static void asd_hst_pcix_isr(struct asd_ha_struct *asd_ha)
 {
diff --git a/drivers/scsi/mvsas/Kconfig b/drivers/scsi/mvsas/Kconfig
index 6de7af2..994fba5 100644
--- a/drivers/scsi/mvsas/Kconfig
+++ b/drivers/scsi/mvsas/Kconfig
@@ -30,8 +30,8 @@ config SCSI_MVSAS
 	select SCSI_SAS_LIBSAS
 	select FW_LOADER
 	help
-		This driver supports Marvell's SAS/SATA 3Gb/s PCI-E 88SE64XX and 6Gb/s
-		PCI-E 88SE94XX chip based host adapters.
+		This driver supports Marvell's SAS/SATA 3Gb/s PCIe 88SE64XX and 6Gb/s
+		PCIe 88SE94XX chip based host adapters.

 config SCSI_MVSAS_DEBUG
 	bool "Compile in debug mode"
diff --git a/drivers/scsi/mvsas/mv_chips.h b/drivers/scsi/mvsas/mv_chips.h
index a67e1c4..5ab0047 100644
--- a/drivers/scsi/mvsas/mv_chips.h
+++ b/drivers/scsi/mvsas/mv_chips.h
@@ -266,7 +266,7 @@ static inline void mvs_show_pcie_usage(struct mvs_info *mvi)
 	if (link_spd >= 3)
 		link_spd = 0;
 	dev_printk(KERN_INFO, mvi->dev,
-		"mvsas: PCI-E x%u, Bandwidth Usage: %s Gbps\n",
+		"mvsas: PCIe x%u, Bandwidth Usage: %s Gbps\n",
 	       (link_stat & PLS_NEG_LINK_WD) >> PLS_NEG_LINK_WD_OFFS,
 	       spd[link_spd]);
 }
diff --git a/drivers/scsi/mvsas/mv_defs.h b/drivers/scsi/mvsas/mv_defs.h
index 1849da1..0a01f38 100644
--- a/drivers/scsi/mvsas/mv_defs.h
+++ b/drivers/scsi/mvsas/mv_defs.h
@@ -138,7 +138,7 @@ enum hw_register_bits {
 	CINT_SW0		= (1U << 30),	/* software event 0 */
 	CINT_SW1		= (1U << 29),	/* software event 1 */
 	CINT_PRD_BC		= (1U << 28),	/* PRD BC err for read cmd */
-	CINT_DMA_PCIE		= (1U << 27),	/* DMA to PCIE timeout */
+	CINT_DMA_PCIE		= (1U << 27),	/* DMA to PCIe timeout */
 	CINT_MEM		= (1U << 26),	/* int mem parity err */
 	CINT_I2C_SLAVE		= (1U << 25),	/* slave I2C event */
 	CINT_SRS		= (1U << 3),	/* SRS event */
diff --git a/drivers/ssb/driver_pcicore.c b/drivers/ssb/driver_pcicore.c
index 538c570..669d57b 100644
--- a/drivers/ssb/driver_pcicore.c
+++ b/drivers/ssb/driver_pcicore.c
@@ -599,7 +599,7 @@ int ssb_pcicore_dev_irqvecs_enable(struct ssb_pcicore *pc,
 		}
 	} else {
 		WARN_ON(pdev->id.coreid != SSB_DEV_PCIE);
-		//TODO: Better make defines for all these magic PCIE values.
+		//TODO: Better make defines for all these magic PCIe values.
 		if ((pdev->id.revision == 0) || (pdev->id.revision == 1)) {
 			/* TLP Workaround register. */
 			tmp = ssb_pcie_read(pc, 0x4);
diff --git a/drivers/ssb/scan.c b/drivers/ssb/scan.c
index e8b89e8..4a244a7 100644
--- a/drivers/ssb/scan.c
+++ b/drivers/ssb/scan.c
@@ -81,7 +81,7 @@ const char *ssb_core_name(u16 coreid)
 	case SSB_DEV_ETHERNET_GBIT:
 		return "GBit Ethernet";
 	case SSB_DEV_PCIE:
-		return "PCI-E";
+		return "PCIe";
 	case SSB_DEV_MIMO_PHY:
 		return "MIMO PHY";
 	case SSB_DEV_SRAM_CTRLR:
@@ -404,8 +404,8 @@ int ssb_bus_scan(struct ssb_bus *bus,
 		case SSB_DEV_PCIE:
 #ifdef CONFIG_SSB_DRIVER_PCICORE
 			if (bus->bustype == SSB_BUSTYPE_PCI) {
-				/* Ignore PCI cores on PCI-E cards.
-				 * Ignore PCI-E cores on PCI cards. */
+				/* Ignore PCI cores on PCIe cards.
+				 * Ignore PCIe cores on PCI cards. */
 				if (dev->id.coreid == SSB_DEV_PCI) {
 					if (bus->host_pci->is_pcie)
 						continue;
diff --git a/drivers/staging/phison/Kconfig b/drivers/staging/phison/Kconfig
index d3c65d3..ad188f6 100644
--- a/drivers/staging/phison/Kconfig
+++ b/drivers/staging/phison/Kconfig
@@ -1,5 +1,5 @@
 config IDE_PHISON
-	tristate "PCIE ATA PS5000 IDE support"
+	tristate "PCIe ATA PS5000 IDE support"
 	depends on PCI && ATA && ATA_SFF
 	---help---
 	  This is an experimental driver for PS5000 IDE driver.
diff --git a/drivers/staging/phison/phison.c b/drivers/staging/phison/phison.c
index 270ebcb..0f0e3b4 100644
--- a/drivers/staging/phison/phison.c
+++ b/drivers/staging/phison/phison.c
@@ -101,6 +101,6 @@ module_init(phison_ide_init);
 module_exit(phison_ide_exit);

 MODULE_AUTHOR("Evan Ko");
-MODULE_DESCRIPTION("PCIE driver module for PHISON PS5000 E-BOX");
+MODULE_DESCRIPTION("PCIe driver module for PHISON PS5000 E-BOX");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
diff --git a/drivers/staging/rt2860/rt_main_dev.c b/drivers/staging/rt2860/rt_main_dev.c
index 22f37cf..929b82e 100644
--- a/drivers/staging/rt2860/rt_main_dev.c
+++ b/drivers/staging/rt2860/rt_main_dev.c
@@ -380,7 +380,7 @@ static int rt28xx_init(IN struct net_device *net_dev)
 	} while (index++ < 100);

 	DBGPRINT(RT_DEBUG_TRACE, ("MAC_CSR0  [ Ver:Rev=0x%08x]\n", pAd->MACVersion));
-/*Iverson patch PCIE L1 issue */
+/*Iverson patch PCIe L1 issue */

 	// Disable DMA
 	RT28XXDMADisable(pAd);
diff --git a/drivers/staging/rt3090/common/cmm_mac_pci.c b/drivers/staging/rt3090/common/cmm_mac_pci.c
index 8e16363..38b09c4 100644
--- a/drivers/staging/rt3090/common/cmm_mac_pci.c
+++ b/drivers/staging/rt3090/common/cmm_mac_pci.c
@@ -1481,7 +1481,7 @@ BOOLEAN RT28xxPciAsicRadioOff(
 	*/
 #endif // CONFIG_STA_SUPPORT //
 //KH Debug:My original codes have the follwoing codes, but currecnt codes do not have it.
-// Disable for stability. If PCIE Link Control is modified for advance power save, re-covery this code segment.
+// Disable for stability. If PCIe Link Control is modified for advance power save, re-covery this code segment.
 RTMP_IO_WRITE32(pAd, PBF_SYS_CTRL, 0x1280);
 //OPSTATUS_SET_FLAG(pAd, fOP_STATUS_CLKSELECT_40MHZ);

diff --git a/drivers/staging/rt3090/common/mlme.c b/drivers/staging/rt3090/common/mlme.c
index 1613c04..8b85e78 100644
--- a/drivers/staging/rt3090/common/mlme.c
+++ b/drivers/staging/rt3090/common/mlme.c
@@ -724,7 +724,7 @@ VOID MlmePeriodicExec(
 #ifndef RT3090
 			RTMP_IO_READ32(pAd, GPIO_CTRL_CFG, &data);
 #endif // RT3090 //
-//KH(PCIE PS):Added based on Jane<--
+//KH(PCIe PS):Added based on Jane<--
 #ifdef RT3090
 // Read GPIO pin2 as Hardware controlled radio state
 // We need to Read GPIO if HW said so no mater what advance power saving
@@ -740,7 +740,7 @@ if ((pAd->OpMode == OPMODE_STA) && (IDLE_ON(pAd))
 else
 	RTMP_IO_FORCE_READ32(pAd, GPIO_CTRL_CFG, &data);
 #endif // RT3090 //
-//KH(PCIE PS):Added based on Jane-->
+//KH(PCIe PS):Added based on Jane-->

 			if (data & 0x04)
 			{
diff --git a/drivers/staging/rt3090/common/rtmp_init.c b/drivers/staging/rt3090/common/rtmp_init.c
index 48b95b7..9d2b454 100644
--- a/drivers/staging/rt3090/common/rtmp_init.c
+++ b/drivers/staging/rt3090/common/rtmp_init.c
@@ -3512,7 +3512,7 @@ int rt28xx_init(

 #ifdef RTMP_MAC_PCI
 #ifdef PCIE_PS_SUPPORT
-	/*Iverson patch PCIE L1 issue to make sure that driver can be read,write ,BBP and RF register  at pcie L.1 level */
+	/*Iverson patch PCIe L1 issue to make sure that driver can be read,write ,BBP and RF register  at pcie L.1 level */
 	if ((IS_RT3090(pAd) || IS_RT3572(pAd) || IS_RT3390(pAd))&&OPSTATUS_TEST_FLAG(pAd, fOP_STATUS_PCIE_DEVICE))
 	{
 		RTMP_IO_READ32(pAd, AUX_CTRL, &MacCsr0);
diff --git a/drivers/staging/rt3090/pci_main_dev.c b/drivers/staging/rt3090/pci_main_dev.c
index 1410156..8d764c2 100644
--- a/drivers/staging/rt3090/pci_main_dev.c
+++ b/drivers/staging/rt3090/pci_main_dev.c
@@ -637,8 +637,8 @@ VOID RTMPInitPCIeLinkCtrlValue(
 		}

 		RTMP_IO_READ32(pAd, AUX_CTRL, &MacValue);
-		//enable WAKE_PCIE function, which forces to enable PCIE clock when mpu interrupt asserting.
-		//Force PCIE 125MHz CLK to toggle
+		//enable WAKE_PCIE function, which forces to enable PCIe clock when mpu interrupt asserting.
+		//Force PCIe 125MHz CLK to toggle
 		MacValue |= 0x402;
 		RTMP_IO_WRITE32(pAd, AUX_CTRL, MacValue);
 		DBGPRINT_RAW(RT_DEBUG_ERROR,(" AUX_CTRL = 0x%32x\n", MacValue));
diff --git a/drivers/staging/rtl8192e/r8192E_core.c b/drivers/staging/rtl8192e/r8192E_core.c
index b0802a7..fc8bb07 100644
--- a/drivers/staging/rtl8192e/r8192E_core.c
+++ b/drivers/staging/rtl8192e/r8192E_core.c
@@ -2562,7 +2562,7 @@ static void rtl8192_read_eeprom_info(struct net_device* dev)
 		priv->bTXPowerDataReadFromEEPORM = false;
 	}

-	// 2007/11/15 MH 8190PCI Default=2T4R, 8192PCIE dafault=1T2R
+	// 2007/11/15 MH 8190PCI Default=2T4R, 8192PCIe dafault=1T2R
 	priv->rf_type = RTL819X_DEFAULT_RF_TYPE;

 	if(priv->card_8192_version > VERSION_8190_BD)
diff --git a/drivers/staging/rtl8192su/r8192S_hw.h b/drivers/staging/rtl8192su/r8192S_hw.h
index 82ea96b..34cf54b 100644
--- a/drivers/staging/rtl8192su/r8192S_hw.h
+++ b/drivers/staging/rtl8192su/r8192S_hw.h
@@ -173,7 +173,7 @@ typedef enum _BaseBand_Config_Type{
 // 11. General Purpose Registers
 // 12. Host Interrupt Status Registers
 // 13. Test Mode and Debug Control Registers
-// 14. PCIE config register
+// 14. PCIe config register
 //


@@ -472,10 +472,10 @@ typedef enum _BaseBand_Config_Type{
 // Boundary is 0x37F

 //
-// 14. PCIE config register	(Offset 0x500-)
+// 14. PCIe config register	(Offset 0x500-)
 //
 #define		TPPoll				0x0500	// Transmit Polling
-#define		PM_CTRL				0x0502	// PCIE power management control Register
+#define		PM_CTRL				0x0502	// PCIe power management control Register
 #define		PCIF				0x0503	// PCI Function Register 0x0009h~0x000bh

 #define		THPDA				0x0514	// Transmit High Priority Desc Addr
@@ -491,10 +491,10 @@ typedef enum _BaseBand_Config_Type{
 #define		RDSA				0x053C	// Receive Desc Starting Addr
 #define		DBI_WDATA			0x0540	// DBI write data Register
 #define		DBI_RDATA			0x0544	// DBI read data Register
-#define		DBI_CTRL			0x0548	// PCIE DBI control Register
-#define		MDIO_DATA			0x0550	// PCIE MDIO data Register
-#define		MDIO_CTRL			0x0554	// PCIE MDIO control Register
-#define		PCI_RPWM			0x0561	// PCIE RPWM register
+#define		DBI_CTRL			0x0548	// PCIe DBI control Register
+#define		MDIO_DATA			0x0550	// PCIe MDIO data Register
+#define		MDIO_CTRL			0x0554	// PCIe MDIO control Register
+#define		PCI_RPWM			0x0561	// PCIe RPWM register
 #define		PCI_CPWM				0x0563	// Current Power Mode.

 //
@@ -1125,7 +1125,7 @@ Default: 00b.
 //

 //
-// 14. PCIE config register	(Offset 0x500-)
+// 14. PCIe config register	(Offset 0x500-)
 //
 //----------------------------------------------------------------------------
 //       8190 TPPool bits 					(offset 0xd9, 2 byte)
diff --git a/drivers/staging/slicoss/Kconfig b/drivers/staging/slicoss/Kconfig
index d2993d3..b736672 100644
--- a/drivers/staging/slicoss/Kconfig
+++ b/drivers/staging/slicoss/Kconfig
@@ -8,7 +8,7 @@ config SLICOSS
 	  This includes the following devices:
 	    Mojave cards (single port PCI Gigabit) both copper and fiber
 	    Oasis cards (single and dual port PCI-x Gigabit) copper and fiber
-	    Kalahari cards (dual and quad port PCI-e Gigabit) copper and fiber
+	    Kalahari cards (dual and quad port PCIe Gigabit) copper and fiber

 	  To compile this driver as a module, choose M here: the module
 	  will be called slicoss.
diff --git a/drivers/staging/slicoss/README b/drivers/staging/slicoss/README
index 70f4909..802945b 100644
--- a/drivers/staging/slicoss/README
+++ b/drivers/staging/slicoss/README
@@ -2,7 +2,7 @@ This driver is supposed to support:

 	Mojave cards (single port PCI Gigabit) both copper and fiber
 	Oasis cards (single and dual port PCI-x Gigabit) copper and fiber
-	Kalahari cards (dual and quad port PCI-e Gigabit) copper and fiber
+	Kalahari cards (dual and quad port PCIe Gigabit) copper and fiber

 The driver was actually tested on Oasis and Kalahari cards.

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index e67a130..4d80cfb 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -45,7 +45,7 @@
  *
  *      Mojave cards (single port PCI Gigabit) both copper and fiber
  *      Oasis cards (single and dual port PCI-x Gigabit) copper and fiber
- *      Kalahari cards (dual and quad port PCI-e Gigabit) copper and fiber
+ *      Kalahari cards (dual and quad port PCIe Gigabit) copper and fiber
  *
  * The driver was acutally tested on Oasis and Kalahari cards.
  *
diff --git a/include/linux/pci.h b/include/linux/pci.h
index f5c7cd3..7fccb3d 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -159,10 +159,10 @@ enum pcie_reset_state {
 	/* Reset is NOT asserted (Use to deassert reset) */
 	pcie_deassert_reset = (__force pcie_reset_state_t) 1,

-	/* Use #PERST to reset PCI-E device */
+	/* Use #PERST to reset PCIe device */
 	pcie_warm_reset = (__force pcie_reset_state_t) 2,

-	/* Use PCI-E Hot Reset to reset device */
+	/* Use PCIe Hot Reset to reset device */
 	pcie_hot_reset = (__force pcie_reset_state_t) 3
 };

@@ -218,7 +218,7 @@ struct pci_dev {
 	unsigned int	class;		/* 3 bytes: (base,sub,prog-if) */
 	u8		revision;	/* PCI revision, low byte of class word */
 	u8		hdr_type;	/* PCI header type (`multi' flag masked out) */
-	u8		pcie_type;	/* PCI-E device/port type */
+	u8		pcie_type;	/* PCIe device/port type */
 	u8		rom_base_reg;	/* which config register controls the ROM */
 	u8		pin;  		/* which interrupt pin this device uses */

diff --git a/include/linux/pci_hotplug.h b/include/linux/pci_hotplug.h
index 652ba79..4c006aa 100644
--- a/include/linux/pci_hotplug.h
+++ b/include/linux/pci_hotplug.h
@@ -62,8 +62,8 @@ enum pcie_link_width {
 };

 enum pcie_link_speed {
-	PCIE_2_5GB		= 0x14,
-	PCIE_5_0GB		= 0x15,
+	PCIE_2_5GT		= 0x14,
+	PCIE_5_0GT		= 0x15,
 	PCIE_LNK_SPEED_UNKNOWN	= 0xFF,
 };

diff --git a/include/linux/ssb/ssb_driver_pci.h b/include/linux/ssb/ssb_driver_pci.h
index 41e330e..940d494 100644
--- a/include/linux/ssb/ssb_driver_pci.h
+++ b/include/linux/ssb/ssb_driver_pci.h
@@ -62,7 +62,7 @@ struct pci_dev;
 #define SSB_PCICORE_PCICFG3		0x0700	/* PCI config space 3 (rev >= 8) */
 #define SSB_PCICORE_SPROM(wordoffset)	(0x0800 + ((wordoffset) * 2)) /* SPROM shadow area (72 bytes) */

-/* SBtoPCIx */
+/* SBtoPCI-X */
 #define SSB_PCICORE_SBTOPCI_MEM		0x00000000
 #define SSB_PCICORE_SBTOPCI_IO		0x00000001
 #define SSB_PCICORE_SBTOPCI_CFG0	0x00000002
-- 
1.6.5.2

