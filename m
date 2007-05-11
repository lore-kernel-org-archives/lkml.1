Return-Path: <linux-kernel-owner+w=401wt.eu-S965927AbXEKTk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965927AbXEKTk4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762336AbXEKTkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:40:39 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:45909 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761839AbXEKTkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:40:35 -0400
Message-ID: <4644C6AE.30501@simon.arlott.org.uk>
Date: Fri, 11 May 2007 20:40:30 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.arm.linux.org.uk, trivial@kernel.org
Subject: [PATCH] spelling fixes: arch/arm/
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Spelling fixes in arch/arm/.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 arch/arm/common/dmabounce.c           |    2 +-
 arch/arm/common/gic.c                 |    2 +-
 arch/arm/common/sharpsl_param.c       |    2 +-
 arch/arm/common/sharpsl_pm.c          |   10 +++++-----
 arch/arm/kernel/sys_arm.c             |    2 +-
 arch/arm/lib/bitops.h                 |    2 +-
 arch/arm/mach-at91/board-carmeva.c    |    8 ++++----
 arch/arm/mach-h720x/cpu-h7202.c       |    4 ++--
 arch/arm/mach-imx/cpufreq.c           |    2 +-
 arch/arm/mach-imx/dma.c               |    8 ++++----
 arch/arm/mach-iop13xx/pci.c           |    2 +-
 arch/arm/mach-ixp2000/enp2611.c       |    2 +-
 arch/arm/mach-ixp2000/ixdp2x00.c      |    4 ++--
 arch/arm/mach-ixp2000/ixdp2x01.c      |    6 +++---
 arch/arm/mach-ixp2000/pci.c           |    2 +-
 arch/arm/mach-ixp23xx/core.c          |    2 +-
 arch/arm/mach-ixp4xx/gtwx5715-setup.c |    2 +-
 arch/arm/mach-lh7a40x/lcd-panel.h     |    6 +++---
 arch/arm/mach-ns9xxx/time.c           |    2 +-
 arch/arm/mach-omap1/board-osk.c       |    2 +-
 arch/arm/mach-omap1/board-palmte.c    |    2 +-
 arch/arm/mach-omap1/pm.c              |    2 +-
 arch/arm/mach-omap2/clock.c           |    2 +-
 arch/arm/mach-omap2/clock.h           |    4 ++--
 arch/arm/mach-pxa/corgi_lcd.c         |   10 +++++-----
 arch/arm/mach-pxa/corgi_ssp.c         |    2 +-
 arch/arm/mach-realview/localtimer.c   |    2 +-
 arch/arm/mach-s3c2440/mach-osiris.c   |    2 +-
 arch/arm/mach-sa1100/time.c           |    2 +-
 arch/arm/mm/alignment.c               |    2 +-
 arch/arm/mm/ioremap.c                 |    2 +-
 arch/arm/mm/mmu.c                     |    2 +-
 arch/arm/plat-iop/pci.c               |    2 +-
 arch/arm/plat-omap/common.c           |    2 +-
 arch/arm/plat-omap/dma.c              |    2 +-
 arch/arm/plat-omap/sram.c             |    6 +++---
 arch/arm/plat-omap/usb.c              |    2 +-
 arch/arm/plat-s3c24xx/dma.c           |    2 +-
 arch/arm/plat-s3c24xx/pm.c            |    2 +-
 39 files changed, 62 insertions(+), 62 deletions(-)

diff --git a/arch/arm/common/dmabounce.c b/arch/arm/common/dmabounce.c
index 6fbe772..b36b1e8 100644
--- a/arch/arm/common/dmabounce.c
+++ b/arch/arm/common/dmabounce.c
@@ -6,7 +6,7 @@
  *  copy data to/from buffers located outside the DMA region. This
  *  only works for systems in which DMA memory is at the bottom of
  *  RAM, the remainder of memory is at the top and the DMA memory
- *  can be marked as ZONE_DMA. Anything beyond that such as discontigous
+ *  can be marked as ZONE_DMA. Anything beyond that such as discontiguous
  *  DMA windows will require custom implementations that reserve memory
  *  areas at early bootup.
  *
diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index 4deece5..5da2ce7 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -72,7 +72,7 @@ static inline unsigned int gic_irq(unsigned int irq)
  * unmask it, in the same way we need to unmask an interrupt when
  * we first enable it.
  *
- * The GIC has a seperate notion of "end of interrupt" to re-enable
+ * The GIC has a separate notion of "end of interrupt" to re-enable
  * an interrupt after handling, in order to support hardware
  * prioritisation.
  *
diff --git a/arch/arm/common/sharpsl_param.c b/arch/arm/common/sharpsl_param.c
index c94864c..aad4d94 100644
--- a/arch/arm/common/sharpsl_param.c
+++ b/arch/arm/common/sharpsl_param.c
@@ -20,7 +20,7 @@
  * typically including LCD parameters are loaded by the bootloader at the
  * address PARAM_BASE. As the kernel will overwrite them, we need to store
  * them early in the boot process, then pass them to the appropriate drivers.
- * Not all devices use all paramaters but the format is common to all.
+ * Not all devices use all parameters but the format is common to all.
  */
 #ifdef CONFIG_ARCH_SA1100
 #define PARAM_BASE	0xe8ffc000
diff --git a/arch/arm/common/sharpsl_pm.c b/arch/arm/common/sharpsl_pm.c
index 5972df2..51f5417 100644
--- a/arch/arm/common/sharpsl_pm.c
+++ b/arch/arm/common/sharpsl_pm.c
@@ -291,7 +291,7 @@ static void sharpsl_chrg_full_timer(unsigned long data)
 }
 
 /* Charging Finished Interrupt (Not present on Corgi) */
-/* Can trigger at the same time as an AC staus change so
+/* Can trigger at the same time as an AC status change so
    delay until after that has been processed */
 irqreturn_t sharpsl_chrg_full_isr(int irq, void *dev_id)
 {
@@ -635,7 +635,7 @@ static int sharpsl_fatal_check(void)
 
 static int sharpsl_off_charge_error(void)
 {
-	dev_err(sharpsl_pm.dev, "Offline Charger: Error occured.\n");
+	dev_err(sharpsl_pm.dev, "Offline Charger: Error occurred.\n");
 	sharpsl_pm.machinfo->charge(0);
 	sharpsl_pm_led(SHARPSL_LED_ERROR);
 	sharpsl_pm.charge_mode = CHRG_ERROR;
@@ -691,14 +691,14 @@ static int sharpsl_off_charge_battery(void)
 
 		time = RCNR;
 		while(1) {
-			/* Check if any wakeup event had occured */
+			/* Check if any wakeup event had occurred */
 			if (sharpsl_pm.machinfo->charger_wakeup() != 0)
 				return 0;
 			/* Check for timeout */
 			if ((RCNR - time) > SHARPSL_WAIT_CO_TIME)
 				return 1;
 			if (sharpsl_pm.machinfo->read_devdata(SHARPSL_STATUS_CHRGFULL)) {
-				dev_dbg(sharpsl_pm.dev, "Offline Charger: Charge full occured. Retrying to check\n");
+				dev_dbg(sharpsl_pm.dev, "Offline Charger: Charge full occurred. Retrying to check\n");
 	   			sharpsl_pm.full_count++;
 				sharpsl_pm.machinfo->charge(0);
 				mdelay(SHARPSL_CHARGE_WAIT_TIME);
@@ -714,7 +714,7 @@ static int sharpsl_off_charge_battery(void)
 
 	time = RCNR;
 	while(1) {
-		/* Check if any wakeup event had occured */
+		/* Check if any wakeup event had occurred */
 		if (sharpsl_pm.machinfo->charger_wakeup() != 0)
 			return 0;
 		/* Check for timeout */
diff --git a/arch/arm/kernel/sys_arm.c b/arch/arm/kernel/sys_arm.c
index 3d4fcbc..1ca2d51 100644
--- a/arch/arm/kernel/sys_arm.c
+++ b/arch/arm/kernel/sys_arm.c
@@ -320,7 +320,7 @@ int kernel_execve(const char *filename, char *const argv[], char *const envp[])
 EXPORT_SYMBOL(kernel_execve);
 
 /*
- * Since loff_t is a 64 bit type we avoid a lot of ABI hastle
+ * Since loff_t is a 64 bit type we avoid a lot of ABI hassle
  * with a different argument ordering.
  */
 asmlinkage long sys_arm_fadvise64_64(int fd, int advice,
diff --git a/arch/arm/lib/bitops.h b/arch/arm/lib/bitops.h
index 5422510..2e787d4 100644
--- a/arch/arm/lib/bitops.h
+++ b/arch/arm/lib/bitops.h
@@ -47,7 +47,7 @@
  * @store: store instruction
  *
  * Note: we can trivially conditionalise the store instruction
- * to avoid dirting the data cache.
+ * to avoid dirtying the data cache.
  */
 	.macro	testop, instr, store
 	add	r1, r1, r0, lsr #3
diff --git a/arch/arm/mach-at91/board-carmeva.c b/arch/arm/mach-at91/board-carmeva.c
index b451861..76ec856 100644
--- a/arch/arm/mach-at91/board-carmeva.c
+++ b/arch/arm/mach-at91/board-carmeva.c
@@ -79,7 +79,7 @@ static struct at91_udc_data __initdata carmeva_udc_data = {
 	.pullup_pin	= AT91_PIN_PD9,
 };
 
-/* FIXME: user dependend */
+/* FIXME: user dependant */
 // static struct at91_cf_data __initdata carmeva_cf_data = {
 //	.det_pin	= AT91_PIN_PB0,
 //	.rst_pin	= AT91_PIN_PC5,
@@ -100,17 +100,17 @@ static struct spi_board_info carmeva_spi_devices[] = {
 		.chip_select  = 0,
 		.max_speed_hz = 10 * 1000 * 1000,
 	},
-	{ /* User accessable spi - cs1 (250KHz) */
+	{ /* User accessible spi - cs1 (250KHz) */
 		.modalias = "spi-cs1",
 		.chip_select  = 1,
 		.max_speed_hz = 250 *  1000,
 	},
-	{ /* User accessable spi - cs2 (1MHz) */
+	{ /* User accessible spi - cs2 (1MHz) */
 		.modalias = "spi-cs2",
 		.chip_select  = 2,
 		.max_speed_hz = 1 * 1000 *  1000,
 	},
-	{ /* User accessable spi - cs3 (10MHz) */
+	{ /* User accessible spi - cs3 (10MHz) */
 		.modalias = "spi-cs3",
 		.chip_select  = 3,
 		.max_speed_hz = 10 * 1000 *  1000,
diff --git a/arch/arm/mach-h720x/cpu-h7202.c b/arch/arm/mach-h720x/cpu-h7202.c
index 82e420d..0a1a25f 100644
--- a/arch/arm/mach-h720x/cpu-h7202.c
+++ b/arch/arm/mach-h720x/cpu-h7202.c
@@ -143,7 +143,7 @@ h7202_timer_interrupt(int irq, void *dev_id)
 }
 
 /*
- * mask multiplexed timer irq's
+ * mask multiplexed timer IRQs
  */
 static void inline mask_timerx_irq (u32 irq)
 {
@@ -153,7 +153,7 @@ static void inline mask_timerx_irq (u32 irq)
 }
 
 /*
- * unmask multiplexed timer irq's
+ * unmask multiplexed timer IRQs
  */
 static void inline unmask_timerx_irq (u32 irq)
 {
diff --git a/arch/arm/mach-imx/cpufreq.c b/arch/arm/mach-imx/cpufreq.c
index 7e70e0b..467d899 100644
--- a/arch/arm/mach-imx/cpufreq.c
+++ b/arch/arm/mach-imx/cpufreq.c
@@ -245,7 +245,7 @@ static int imx_set_target(struct cpufreq_policy *policy,
 	if(mpctl0) {
 		CSCR |= CSCR_MPLL_RESTART;
 
-		/* Wait until MPLL is stablized */
+		/* Wait until MPLL is stabilized */
 		while( CSCR & CSCR_MPLL_RESTART );
 
 		imx_set_async_mode();
diff --git a/arch/arm/mach-imx/dma.c b/arch/arm/mach-imx/dma.c
index 6d50d85..bc6fb02 100644
--- a/arch/arm/mach-imx/dma.c
+++ b/arch/arm/mach-imx/dma.c
@@ -131,7 +131,7 @@ imx_dma_setup_sg_base(imx_dmach_t dma_ch,
  * The function setups DMA channel source and destination addresses for transfer
  * specified by provided parameters. The scatter-gather emulation is disabled,
  * because linear data block
- * form the physical address range is transfered.
+ * form the physical address range is transferred.
  * Return value: if incorrect parameters are provided -%EINVAL.
  *		Zero indicates success.
  */
@@ -192,7 +192,7 @@ imx_dma_setup_single(imx_dmach_t dma_ch, dma_addr_t dma_address,
  * @dmamode: DMA transfer mode, %DMA_MODE_READ from the device to the memory
  *           or %DMA_MODE_WRITE from memory to the device
  *
- * The function setups DMA channel state and registers to be ready for transfer
+ * The function sets up DMA channel state and registers to be ready for transfer
  * specified by provided parameters. The scatter-gather emulation is set up
  * according to the parameters.
  *
@@ -212,7 +212,7 @@ imx_dma_setup_single(imx_dmach_t dma_ch, dma_addr_t dma_address,
  *
  * %CCR_SMOD_LINEAR | %CCR_SSIZ_32 | %CCR_DMOD_FIFO | %CCR_DSIZ_x
  *
- * Be carefull there and do not mistakenly mix source and target device
+ * Be careful here and do not mistakenly mix source and target device
  * port sizes constants, they are really different:
  * %CCR_SSIZ_8, %CCR_SSIZ_16, %CCR_SSIZ_32,
  * %CCR_DSIZ_8, %CCR_DSIZ_16, %CCR_DSIZ_32
@@ -495,7 +495,7 @@ static irqreturn_t dma_err_handler(int irq, void *dev_id)
 		/*
 		 * The cleaning of @sg field would be questionable
 		 * there, because its value can help to compute
-		 * remaining/transfered bytes count in the handler
+		 * remaining/transferred bytes count in the handler
 		 */
 		/*imx_dma_channels[i].sg = NULL;*/
 
diff --git a/arch/arm/mach-iop13xx/pci.c b/arch/arm/mach-iop13xx/pci.c
index d1d0d32..2f2ce9b 100644
--- a/arch/arm/mach-iop13xx/pci.c
+++ b/arch/arm/mach-iop13xx/pci.c
@@ -973,7 +973,7 @@ void __init iop13xx_pci_init(void)
 			"imprecise external abort");
 }
 
-/* intialize the pci memory space.  handle any combination of
+/* initialize the pci memory space.  handle any combination of
  * atue and atux enabled/disabled
  */
 int iop13xx_pci_setup(int nr, struct pci_sys_data *sys)
diff --git a/arch/arm/mach-ixp2000/enp2611.c b/arch/arm/mach-ixp2000/enp2611.c
index 500e997..9c49435 100644
--- a/arch/arm/mach-ixp2000/enp2611.c
+++ b/arch/arm/mach-ixp2000/enp2611.c
@@ -198,7 +198,7 @@ subsys_initcall(enp2611_pci_init);
 
 
 /*************************************************************************
- * ENP-2611 Machine Intialization
+ * ENP-2611 Machine Initialization
  *************************************************************************/
 static struct flash_platform_data enp2611_flash_platform_data = {
 	.map_name	= "cfi_probe",
diff --git a/arch/arm/mach-ixp2000/ixdp2x00.c b/arch/arm/mach-ixp2000/ixdp2x00.c
index 52b368b..5dbc97e 100644
--- a/arch/arm/mach-ixp2000/ixdp2x00.c
+++ b/arch/arm/mach-ixp2000/ixdp2x00.c
@@ -195,7 +195,7 @@ void __init ixdp2x00_map_io(void)
  * instances  of the kernel. So far so good. Peers on the PCI bus running 
  * Linux is a common design in telecom systems. The problem is that instead 
  * of all the devices being controlled by a single host, different
- * devices are controlles by different NPUs on the same bus, leading to
+ * devices are controlled by different NPUs on the same bus, leading to
  * multiple hosts on the bus. The exact bus layout looks like:
  *
  *                   Bus 0
@@ -211,7 +211,7 @@ void __init ixdp2x00_map_io(void)
  *                  |      |         |         |      |
  *             ... Dev    PMC       Media     Eth0   Eth1 ...
  *
- * The master controlls all but Eth1, which is controlled by the
+ * The master controls all but Eth1, which is controlled by the
  * slave. What this means is that the both the master and the slave
  * have to scan the bus, but only one of them can enumerate the bus.
  * In addition, after the bus is scanned, each kernel must remove
diff --git a/arch/arm/mach-ixp2000/ixdp2x01.c b/arch/arm/mach-ixp2000/ixdp2x01.c
index 3084a5f..d3d730d 100644
--- a/arch/arm/mach-ixp2000/ixdp2x01.c
+++ b/arch/arm/mach-ixp2000/ixdp2x01.c
@@ -276,7 +276,7 @@ static int __init ixdp2x01_pci_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
 	/* Device is located after first MB bridge */
 	case 0x0008:
 		if (tmp_bus == dev->bus) {
-			/* Device is located directy after first MB bridge */
+			/* Device is located directly after first MB bridge */
 			switch (devpin) {
 			case DEVPIN(1, 1):	/* Onboard 82546 ch 0 */
 				if (machine_is_ixdp2401())
@@ -299,7 +299,7 @@ static int __init ixdp2x01_pci_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
 		break;
 	case 0x0010:
 		if (tmp_bus == dev->bus) {
-			/* Device is located directy after second MB bridge */
+			/* Device is located directly after second MB bridge */
 			/* Secondary bus of second bridge */
 			switch (devpin) {
 			case DEVPIN(0, 1):	/* DB#0 */
@@ -348,7 +348,7 @@ int __init ixdp2x01_pci_init(void)
 subsys_initcall(ixdp2x01_pci_init);
 
 /*************************************************************************
- * IXDP2x01 Machine Intialization
+ * IXDP2x01 Machine Initialization
  *************************************************************************/
 static struct flash_platform_data ixdp2x01_flash_platform_data = {
 	.map_name	= "cfi_probe",
diff --git a/arch/arm/mach-ixp2000/pci.c b/arch/arm/mach-ixp2000/pci.c
index 5a09a90..03f4cf7 100644
--- a/arch/arm/mach-ixp2000/pci.c
+++ b/arch/arm/mach-ixp2000/pci.c
@@ -102,7 +102,7 @@ int ixp2000_pci_read_config(struct pci_bus *bus, unsigned int devfn, int where,
 }
 
 /*
- * We don't do error checks by callling clear_master_aborts() b/c the
+ * We don't do error checks by calling clear_master_aborts() b/c the
  * assumption is that the caller did a read first to make sure a device
  * exists.
  */
diff --git a/arch/arm/mach-ixp23xx/core.c b/arch/arm/mach-ixp23xx/core.c
index b644bba..16356ff 100644
--- a/arch/arm/mach-ixp23xx/core.c
+++ b/arch/arm/mach-ixp23xx/core.c
@@ -389,7 +389,7 @@ struct sys_timer ixp23xx_timer = {
 
 
 /*************************************************************************
- * IXP23xx Platform Initializaion
+ * IXP23xx Platform Initialization
  *************************************************************************/
 static struct resource ixp23xx_uart_resources[] = {
 	{
diff --git a/arch/arm/mach-ixp4xx/gtwx5715-setup.c b/arch/arm/mach-ixp4xx/gtwx5715-setup.c
index 30f1300..dc6725b 100644
--- a/arch/arm/mach-ixp4xx/gtwx5715-setup.c
+++ b/arch/arm/mach-ixp4xx/gtwx5715-setup.c
@@ -1,7 +1,7 @@
 /*
  * arch/arm/mach-ixp4xx/gtwx5715-setup.c
  *
- * Gemtek GTWX5715 (Linksys WRV54G) board settup
+ * Gemtek GTWX5715 (Linksys WRV54G) board setup
  *
  * Copyright (C) 2004 George T. Joseph
  * Derived from Coyote
diff --git a/arch/arm/mach-lh7a40x/lcd-panel.h b/arch/arm/mach-lh7a40x/lcd-panel.h
index 4fb2efc..df6e38e 100644
--- a/arch/arm/mach-lh7a40x/lcd-panel.h
+++ b/arch/arm/mach-lh7a40x/lcd-panel.h
@@ -126,7 +126,7 @@ static struct clcd_panel_extra lcd_panel_extra = {
 
  */
 
-/* The full horozontal cycle (Th) is clock/360/400/450. */
+/* The full horizontal cycle (Th) is clock/360/400/450. */
 /* The full vertical   cycle (Tv) is line/251/262/280. */
 
 #define PIX_CLOCK_TARGET	(6300000) /* -/6.3/7 MHz */
@@ -162,7 +162,7 @@ static struct clcd_panel lcd_panel = {
 	/* Logic Product Development LCD 6.4" VGA -10 */
 	/* Sharp PN LQ64D343 */
 
-/* The full horozontal cycle (Th) is clock/750/800/900. */
+/* The full horizontal cycle (Th) is clock/750/800/900. */
 /* The full vertical   cycle (Tv) is line/515/525/560. */
 
 #define PIX_CLOCK_TARGET	(28330000)
@@ -243,7 +243,7 @@ static struct clcd_panel lcd_panel = {
  * (fdisk, e2fsck).  And, at that speed the display may have a visible
  * flicker. */
 
-/* The full horozontal cycle (Th) is clock/832/1056/1395. */
+/* The full horizontal cycle (Th) is clock/832/1056/1395. */
 
 #define PIX_CLOCK_TARGET	(20000000)
 #define PIX_CLOCK_DIVIDER	CLOCK_TO_DIV (PIX_CLOCK_TARGET, HCLK)
diff --git a/arch/arm/mach-ns9xxx/time.c b/arch/arm/mach-ns9xxx/time.c
index dd25708..b97d0c5 100644
--- a/arch/arm/mach-ns9xxx/time.c
+++ b/arch/arm/mach-ns9xxx/time.c
@@ -35,7 +35,7 @@ static unsigned long ns9xxx_timer_gettimeoffset(void)
 {
 	/* return the microseconds which have passed since the last interrupt
 	 * was _serviced_.  That is, if an interrupt is pending or the counter
-	 * reloads, return one periode more. */
+	 * reloads, return one period more. */
 
 	u32 counter1 = SYS_TR(0);
 	int pending = SYS_ISR & (1 << IRQ_TIMER0);
diff --git a/arch/arm/mach-omap1/board-osk.c b/arch/arm/mach-omap1/board-osk.c
index 7d0cf7a..e713029 100644
--- a/arch/arm/mach-omap1/board-osk.c
+++ b/arch/arm/mach-omap1/board-osk.c
@@ -385,7 +385,7 @@ static void __init osk_init(void)
 	/* Workaround for wrong CS3 (NOR flash) timing
 	 * There are some U-Boot versions out there which configure
 	 * wrong CS3 memory timings. This mainly leads to CRC
-	 * or similiar errors if you use NOR flash (e.g. with JFFS2)
+	 * or similar errors if you use NOR flash (e.g. with JFFS2)
 	 */
 	if (EMIFS_CCS(3) != EMIFS_CS3_VAL)
 		EMIFS_CCS(3) = EMIFS_CS3_VAL;
diff --git a/arch/arm/mach-omap1/board-palmte.c b/arch/arm/mach-omap1/board-palmte.c
index 4bc8a62..0158241 100644
--- a/arch/arm/mach-omap1/board-palmte.c
+++ b/arch/arm/mach-omap1/board-palmte.c
@@ -7,7 +7,7 @@
  *
  * Original version : Laurent Gonzalez
  *
- * Maintainters : http://palmtelinux.sf.net
+ * Maintainers : http://palmtelinux.sf.net
  *                palmtelinux-developpers@lists.sf.net
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/arch/arm/mach-omap1/pm.c b/arch/arm/mach-omap1/pm.c
index 6f4ea4b..e2b238a 100644
--- a/arch/arm/mach-omap1/pm.c
+++ b/arch/arm/mach-omap1/pm.c
@@ -439,7 +439,7 @@ void omap_pm_suspend(void)
 		omap_writew(0, ULPD_SOFT_DISABLE_REQ_REG);
 
 	/*
-	 * Reenable interrupts
+	 * Re-enable interrupts
 	 */
 
 	local_irq_enable();
diff --git a/arch/arm/mach-omap2/clock.c b/arch/arm/mach-omap2/clock.c
index 5170481..588adb5 100644
--- a/arch/arm/mach-omap2/clock.c
+++ b/arch/arm/mach-omap2/clock.c
@@ -443,7 +443,7 @@ static long omap2_clk_round_rate(struct clk *clk, unsigned long rate)
 
 /*
  * Check the DLL lock state, and return tue if running in unlock mode.
- * This is needed to compenste for the shifted DLL value in unlock mode.
+ * This is needed to compensate for the shifted DLL value in unlock mode.
  */
 static u32 omap2_dll_force_needed(void)
 {
diff --git a/arch/arm/mach-omap2/clock.h b/arch/arm/mach-omap2/clock.h
index 162978f..4f79186 100644
--- a/arch/arm/mach-omap2/clock.h
+++ b/arch/arm/mach-omap2/clock.h
@@ -338,7 +338,7 @@ struct prcm_config {
 /*
  * These represent optimal values for common parts, it won't work for all.
  * As long as you scale down, most parameters are still work, they just
- * become sub-optimal. The RFR value goes in the oppisite direction. If you
+ * become sub-optimal. The RFR value goes in the opposite direction. If you
  * don't adjust it down as your clock period increases the refresh interval
  * will not be met. Setting all parameters for complete worst case may work,
  * but may cut memory performance by 2x. Due to errata the DLLs need to be
@@ -384,7 +384,7 @@ struct prcm_config {
  * Filling in table based on H4 boards and 2430-SDPs variants available.
  * There are quite a few more rates combinations which could be defined.
  *
- * When multiple values are defiend the start up will try and choose the
+ * When multiple values are defined the start up will try and choose the
  * fastest one. If a 'fast' value is defined, then automatically, the /2
  * one should be included as it can be used.	Generally having more that
  * one fast set does not make sense, as static timings need to be changed
diff --git a/arch/arm/mach-pxa/corgi_lcd.c b/arch/arm/mach-pxa/corgi_lcd.c
index a72476c..365b943 100644
--- a/arch/arm/mach-pxa/corgi_lcd.c
+++ b/arch/arm/mach-pxa/corgi_lcd.c
@@ -40,7 +40,7 @@
 #define PICTRL_ADRS     0x06
 #define POLCTRL_ADRS    0x07
 
-/* Resgister Bit Definitions */
+/* Register Bit Definitions */
 #define RESCTL_QVGA     0x01
 #define RESCTL_VGA      0x00
 
@@ -55,11 +55,11 @@
 #define POWER0_COM_DCLK 0x01  /* COM Voltage DC Bias DAC Serial Data Clock */
 #define POWER0_COM_DOUT 0x02  /* COM Voltage DC Bias DAC Serial Data Out */
 #define POWER0_DAC_ON   0x04  /* DAC Power Supply ON */
-#define POWER0_COM_ON   0x08  /* COM Powewr Supply ON */
+#define POWER0_COM_ON   0x08  /* COM Power Supply ON */
 #define POWER0_VCC5_ON  0x10  /* VCC5 Power Supply ON */
 
 #define POWER0_DAC_OFF  0x00  /* DAC Power Supply OFF */
-#define POWER0_COM_OFF  0x00  /* COM Powewr Supply OFF */
+#define POWER0_COM_OFF  0x00  /* COM Power Supply OFF */
 #define POWER0_VCC5_OFF 0x00  /* VCC5 Power Supply OFF */
 
 #define PICTRL_INIT_STATE      0x01
@@ -145,7 +145,7 @@ static void lcdtg_set_common_voltage(u8 base_data, u8 data)
 	lcdtg_i2c_send_stop(base_data);
 }
 
-/* Set Phase Adjuct */
+/* Set Phase Adjust */
 static void lcdtg_set_phadadj(int mode)
 {
 	int adj;
@@ -226,7 +226,7 @@ static void lcdtg_hw_init(int mode)
 		/* Signals output enable */
 		corgi_ssp_lcdtg_send(PICTRL_ADRS, 0);
 
-		/* Set Phase Adjuct */
+		/* Set Phase Adjust */
 		lcdtg_set_phadadj(mode);
 
 		/* Initialize for Input Signals from ATI */
diff --git a/arch/arm/mach-pxa/corgi_ssp.c b/arch/arm/mach-pxa/corgi_ssp.c
index ff6b4ee..40dea3d 100644
--- a/arch/arm/mach-pxa/corgi_ssp.c
+++ b/arch/arm/mach-pxa/corgi_ssp.c
@@ -32,7 +32,7 @@ static struct corgissp_machinfo *ssp_machinfo;
  * There are three devices connected to the SSP interface:
  *   1. A touchscreen controller (TI ADS7846 compatible)
  *   2. An LCD contoller (with some Backlight functionality)
- *   3. A battery moinitoring IC (Maxim MAX1111)
+ *   3. A battery monitoring IC (Maxim MAX1111)
  *
  * Each device uses a different speed/mode of communication.
  *
diff --git a/arch/arm/mach-realview/localtimer.c b/arch/arm/mach-realview/localtimer.c
index caf6b8b..c7bdf04 100644
--- a/arch/arm/mach-realview/localtimer.c
+++ b/arch/arm/mach-realview/localtimer.c
@@ -30,7 +30,7 @@ static unsigned long mpcore_timer_rate;
 /*
  * local_timer_ack: checks for a local timer interrupt.
  *
- * If a local timer interrupt has occured, acknowledge and return 1.
+ * If a local timer interrupt has occurred, acknowledge and return 1.
  * Otherwise, return 0.
  */
 int local_timer_ack(void)
diff --git a/arch/arm/mach-s3c2440/mach-osiris.c b/arch/arm/mach-s3c2440/mach-osiris.c
index 324f5a2..4d6c7a5 100644
--- a/arch/arm/mach-s3c2440/mach-osiris.c
+++ b/arch/arm/mach-s3c2440/mach-osiris.c
@@ -45,7 +45,7 @@
 #include <asm/plat-s3c24xx/devs.h>
 #include <asm/plat-s3c24xx/cpu.h>
 
-/* onboard perihpheral map */
+/* onboard perihperal map */
 
 static struct map_desc osiris_iodesc[] __initdata = {
   /* ISA IO areas (may be over-written later) */
diff --git a/arch/arm/mach-sa1100/time.c b/arch/arm/mach-sa1100/time.c
index 416e277..29cb0c1 100644
--- a/arch/arm/mach-sa1100/time.c
+++ b/arch/arm/mach-sa1100/time.c
@@ -25,7 +25,7 @@ static unsigned long __init sa1100_get_rtc_time(void)
 {
 	/*
 	 * According to the manual we should be able to let RTTR be zero
-	 * and then a default diviser for a 32.768KHz clock is used.
+	 * and then a default divisor for a 32.768KHz clock is used.
 	 * Apparently this doesn't work, at least for my SA1110 rev 5.
 	 * If the clock divider is uninitialized then reset it to the
 	 * default value to get the 1Hz clock.
diff --git a/arch/arm/mm/alignment.c b/arch/arm/mm/alignment.c
index 19ca333..36440c8 100644
--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -3,7 +3,7 @@
  *
  *  Copyright (C) 1995  Linus Torvalds
  *  Modifications for ARM processor (c) 1995-2001 Russell King
- *  Thumb aligment fault fixups (c) 2004 MontaVista Software, Inc.
+ *  Thumb alignment fault fixups (c) 2004 MontaVista Software, Inc.
  *  - Adapted from gdb/sim/arm/thumbemu.c -- Thumb instruction emulation.
  *    Copyright (C) 1996, Cygnus Software Technologies Ltd.
  *
diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
index d6167ad..f3ade18 100644
--- a/arch/arm/mm/ioremap.c
+++ b/arch/arm/mm/ioremap.c
@@ -346,7 +346,7 @@ void __iounmap(volatile void __iomem *addr)
 #ifndef CONFIG_SMP
 	/*
 	 * If this is a section based mapping we need to handle it
-	 * specially as the VM subysystem does not know how to handle
+	 * specially as the VM subsystem does not know how to handle
 	 * such a beast. We need the lock here b/c we need to clear
 	 * all the mappings before the area can be reclaimed
 	 * by someone else.
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 2ba1530..02e050a 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -92,7 +92,7 @@ static struct cachepolicy cache_policies[] __initdata = {
 };
 
 /*
- * These are useful for identifing cache coherency
+ * These are useful for identifying cache coherency
  * problems by allowing the cache or the cache and
  * writebuffer to be turned off.  (Note: the write
  * buffer should not be on and the cache off).
diff --git a/arch/arm/plat-iop/pci.c b/arch/arm/plat-iop/pci.c
index e2744b7..ded1d17 100644
--- a/arch/arm/plat-iop/pci.c
+++ b/arch/arm/plat-iop/pci.c
@@ -85,7 +85,7 @@ static int iop3xx_pci_status(void)
 
 /*
  * Simply write the address register and read the configuration
- * data.  Note that the 4 nop's ensure that we are able to handle
+ * data.  Note that the 4 nops ensure that we are able to handle
  * a delayed abort (in theory.)
  */
 static inline u32 iop3xx_read(unsigned long addr)
diff --git a/arch/arm/plat-omap/common.c b/arch/arm/plat-omap/common.c
index dd8708a..7987aa6 100644
--- a/arch/arm/plat-omap/common.c
+++ b/arch/arm/plat-omap/common.c
@@ -73,7 +73,7 @@ static const void *get_config(u16 tag, size_t len, int skip, size_t *len_out)
 	}
 	if (info != NULL) {
 		/* Check the length as a lame attempt to check for
-		 * binary inconsistancy. */
+		 * binary inconsistency. */
 		if (len != NO_LENGTH_CHECK) {
 			/* Word-align len */
 			if (len & 0x03)
diff --git a/arch/arm/plat-omap/dma.c b/arch/arm/plat-omap/dma.c
index 2d86b10..ab558d4 100644
--- a/arch/arm/plat-omap/dma.c
+++ b/arch/arm/plat-omap/dma.c
@@ -1172,7 +1172,7 @@ static void set_b1_regs(void)
 		break;
 	default:
 		BUG();
-		return;	/* Supress warning about uninitialized vars */
+		return;	/* Suppress warning about uninitialized vars */
 	}
 
 	if (omap_dma_in_1510_mode()) {
diff --git a/arch/arm/plat-omap/sram.c b/arch/arm/plat-omap/sram.c
index bc46f33..1f23f04 100644
--- a/arch/arm/plat-omap/sram.c
+++ b/arch/arm/plat-omap/sram.c
@@ -59,8 +59,8 @@ extern unsigned long omapfb_reserve_sram(unsigned long sram_pstart,
 
 /*
  * Depending on the target RAMFS firewall setup, the public usable amount of
- * SRAM varies.  The default accessable size for all device types is 2k. A GP
- * device allows ARM11 but not other initators for full size. This
+ * SRAM varies.  The default accessible size for all device types is 2k. A GP
+ * device allows ARM11 but not other initiators for full size. This
  * functionality seems ok until some nice security API happens.
  */
 static int is_sram_locked(void)
@@ -71,7 +71,7 @@ static int is_sram_locked(void)
 		type = __raw_readl(VA_CONTROL_STAT) & TYPE_MASK;
 
 	if (type == GP_DEVICE) {
-		/* RAMFW: R/W access to all initators for all qualifier sets */
+		/* RAMFW: R/W access to all initiators for all qualifier sets */
 		if (cpu_is_omap242x()) {
 			__raw_writel(0xFF, VA_REQINFOPERM0); /* all q-vects */
 			__raw_writel(0xCFDE, VA_READPERM0);  /* all i-read */
diff --git a/arch/arm/plat-omap/usb.c b/arch/arm/plat-omap/usb.c
index 25489aa..a5aedf9 100644
--- a/arch/arm/plat-omap/usb.c
+++ b/arch/arm/plat-omap/usb.c
@@ -177,7 +177,7 @@ static u32 __init omap_usb0_init(unsigned nwires, unsigned is_device)
 
 	/* NOTE:  SPEED and SUSP aren't configured here.  OTG hosts
 	 * may be able to use I2C requests to set those bits along
-	 * with VBUS switching and overcurrent detction.
+	 * with VBUS switching and overcurrent detection.
 	 */
 
 	if (cpu_class_is_omap1() && nwires != 6)
diff --git a/arch/arm/plat-s3c24xx/dma.c b/arch/arm/plat-s3c24xx/dma.c
index 6f03c93..08d80f2 100644
--- a/arch/arm/plat-s3c24xx/dma.c
+++ b/arch/arm/plat-s3c24xx/dma.c
@@ -1153,7 +1153,7 @@ EXPORT_SYMBOL(s3c2410_dma_set_buffdone_fn);
  *
  * hwcfg:     the value for xxxSTCn register,
  *            bit 0: 0=increment pointer, 1=leave pointer
- *            bit 1: 0=soucre is AHB, 1=soucre is APB
+ *            bit 1: 0=source is AHB, 1=source is APB
  *
  * devaddr:   physical address of the source
 */
diff --git a/arch/arm/plat-s3c24xx/pm.c b/arch/arm/plat-s3c24xx/pm.c
index c6b03f8..5692ecc 100644
--- a/arch/arm/plat-s3c24xx/pm.c
+++ b/arch/arm/plat-s3c24xx/pm.c
@@ -555,7 +555,7 @@ static int s3c2410_pm_enter(suspend_state_t state)
 	__raw_writel(__raw_readl(S3C2410_INTPND), S3C2410_INTPND);
 	__raw_writel(__raw_readl(S3C2410_SRCPND), S3C2410_SRCPND);
 
-	/* call cpu specific preperation */
+	/* call cpu specific preparation */
 
 	pm_cpu_prep();
 
-- 
1.5.0.1

-- 
Simon Arlott
