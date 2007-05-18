Return-Path: <linux-kernel-owner+w=401wt.eu-S1759466AbXERRJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759466AbXERRJY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 13:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757329AbXERRJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 13:09:06 -0400
Received: from sccrmhc13.comcast.net ([63.240.77.83]:42251 "EHLO
	sccrmhc13.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757270AbXERRJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 13:09:03 -0400
Date: Fri, 18 May 2007 13:04:41 -0400
From: Matt LaPlante <kernel1@cyberdogtech.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org
Subject: Re: [PATCH] 2.6.21-git15 - Kconfig Cleanup
Message-Id: <20070518130441.060a9190.kernel1@cyberdogtech.com>
In-Reply-To: <20070511220501.02181278.kernel1@cyberdogtech.com>
References: <20070511220501.02181278.kernel1@cyberdogtech.com>
X-Mailer: Sylpheed 2.4.0 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Processed: mail.cyberdogtech.com, Fri, 18 May 2007 13:04:44 -0400
	(not processed: message from valid local sender)
X-Return-Path: kernel1@cyberdogtech.com
X-Envelope-From: kernel1@cyberdogtech.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
X-MDAV-Processed: mail.cyberdogtech.com, Fri, 18 May 2007 13:04:45 -0400
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ping?

On Fri, 11 May 2007 22:05:01 -0400
Matt LaPlante <kernel1@cyberdogtech.com> wrote:

> Fix misc small issues/typos/grammar in Kconfigs for 2.6.21-git15.
> 
> Signed-off-by: Matt LaPlante <kernel1@cyberdogtech.com>
> --
> 
> diff -ru a/arch/arm/plat-s3c24xx/Kconfig b/arch/arm/plat-s3c24xx/Kconfig
> --- a/arch/arm/plat-s3c24xx/Kconfig	2007-04-25 23:08:32.000000000 -0400
> +++ b/arch/arm/plat-s3c24xx/Kconfig	2007-05-11 21:44:06.000000000 -0400
> @@ -70,7 +70,7 @@
>  	help
>  	  Set the chunksize in Kilobytes of the CRC for checking memory
>  	  corruption over suspend and resume. A smaller value will mean that
> -	  the CRC data block will take more memory, but wil identify any
> +	  the CRC data block will take more memory, but will identify any
>  	  faults with better precision.
>  
>  	  See <file:Documentation/arm/Samsung-S3C24XX/Suspend.txt>
> diff -ru a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
> --- a/arch/blackfin/Kconfig	2007-05-11 20:32:24.000000000 -0400
> +++ b/arch/blackfin/Kconfig	2007-05-11 21:33:28.000000000 -0400
> @@ -435,100 +435,100 @@
>  	default y
>  	help
>  	  If enabled interrupt entry code (STORE/RESTORE CONTEXT) is linked
> -	  into L1 instruction memory.(less latency)
> +	  into L1 instruction memory. (less latency)
>  
>  config EXCPT_IRQ_SYSC_L1
> -	bool "Locate entire ASM lowlevel excepetion / interrupt - Syscall and CPLB handler code in L1 Memory"
> +	bool "Locate entire ASM lowlevel exception / interrupt - Syscall and CPLB handler code in L1 Memory"
>  	default y
>  	help
> -	  If enabled entire ASM lowlevel exception and interrupt entry code (STORE/RESTORE CONTEXT) is linked
> -	  into L1 instruction memory.(less latency)
> +	  If enabled, the entire ASM lowlevel exception and interrupt entry code 
> +	  (STORE/RESTORE CONTEXT) is linked into L1 instruction memory. (less latency)
>  
>  config DO_IRQ_L1
>  	bool "Locate frequently called do_irq dispatcher function in L1 Memory"
>  	default y
>  	help
> -	  If enabled frequently called do_irq dispatcher function is linked
> -	  into L1 instruction memory.(less latency)
> +	  If enabled, the frequently called do_irq dispatcher function is linked
> +	  into L1 instruction memory. (less latency)
>  
>  config CORE_TIMER_IRQ_L1
>  	bool "Locate frequently called timer_interrupt() function in L1 Memory"
>  	default y
>  	help
> -	  If enabled frequently called timer_interrupt() function is linked
> -	  into L1 instruction memory.(less latency)
> +	  If enabled, the frequently called timer_interrupt() function is linked
> +	  into L1 instruction memory. (less latency)
>  
>  config IDLE_L1
>  	bool "Locate frequently idle function in L1 Memory"
>  	default y
>  	help
> -	  If enabled frequently called idle function is linked
> -	  into L1 instruction memory.(less latency)
> +	  If enabled, the frequently called idle function is linked
> +	  into L1 instruction memory. (less latency)
>  
>  config SCHEDULE_L1
>  	bool "Locate kernel schedule function in L1 Memory"
>  	default y
>  	help
> -	  If enabled frequently called kernel schedule is linked
> -	  into L1 instruction memory.(less latency)
> +	  If enabled, the frequently called kernel schedule is linked
> +	  into L1 instruction memory. (less latency)
>  
>  config ARITHMETIC_OPS_L1
>  	bool "Locate kernel owned arithmetic functions in L1 Memory"
>  	default y
>  	help
>  	  If enabled arithmetic functions are linked
> -	  into L1 instruction memory.(less latency)
> +	  into L1 instruction memory. (less latency)
>  
>  config ACCESS_OK_L1
>  	bool "Locate access_ok function in L1 Memory"
>  	default y
>  	help
> -	  If enabled access_ok function is linked
> -	  into L1 instruction memory.(less latency)
> +	  If enabled, the access_ok function is linked
> +	  into L1 instruction memory. (less latency)
>  
>  config MEMSET_L1
>  	bool "Locate memset function in L1 Memory"
>  	default y
>  	help
> -	  If enabled memset function is linked
> -	  into L1 instruction memory.(less latency)
> +	  If enabled, the memset function is linked
> +	  into L1 instruction memory. (less latency)
>  
>  config MEMCPY_L1
>  	bool "Locate memcpy function in L1 Memory"
>  	default y
>  	help
> -	  If enabled memcpy function is linked
> -	  into L1 instruction memory.(less latency)
> +	  If enabled, the memcpy function is linked
> +	  into L1 instruction memory. (less latency)
>  
>  config SYS_BFIN_SPINLOCK_L1
>  	bool "Locate sys_bfin_spinlock function in L1 Memory"
>  	default y
>  	help
> -	  If enabled sys_bfin_spinlock function is linked
> -	  into L1 instruction memory.(less latency)
> +	  If enabled, the sys_bfin_spinlock function is linked
> +	  into L1 instruction memory. (less latency)
>  
>  config IP_CHECKSUM_L1
>  	bool "Locate IP Checksum function in L1 Memory"
>  	default n
>  	help
> -	  If enabled IP Checksum function is linked
> -	  into L1 instruction memory.(less latency)
> +	  If enabled, the IP Checksum function is linked
> +	  into L1 instruction memory. (less latency)
>  
>  config CACHELINE_ALIGNED_L1
>  	bool "Locate cacheline_aligned data to L1 Data Memory"
>  	default y
>  	depends on !BF531
>  	help
> -	  If enabled cacheline_anligned data is linked
> -	  into L1 data memory.(less latency)
> +	  If enabled, the cacheline_aligned data is linked
> +	  into L1 data memory. (less latency)
>  
>  config SYSCALL_TAB_L1
>  	bool "Locate Syscall Table L1 Data Memory"
>  	default n
>  	depends on !BF531
>  	help
> -	  If enabled the Syscall LUT is linked
> -	  into L1 data memory.(less latency)
> +	  If enabled, the the Syscall LUT is linked
> +	  into L1 data memory. (less latency)
>  
>  config CPLB_SWITCH_TAB_L1
>  	bool "Locate CPLB Switch Tables L1 Data Memory"
> @@ -536,7 +536,7 @@
>  	depends on !BF531
>  	help
>  	  If enabled the CPLB Switch Tables are linked
> -	  into L1 data memory.(less latency)
> +	  into L1 data memory. (less latency)
>  
>  endmenu
>  
> @@ -905,13 +905,13 @@
>  	  from.
>  
>  config DEBUG_ICACHE_CHECK
> -	bool "Check Instruction cache coherancy"
> +	bool "Check Instruction cache coherency"
>  	depends on DEBUG_KERNEL
>  	depends on DEBUG_HWERR
>  	help
> -	  Say Y here if you are getting wierd unexplained errors. This will
> -	  ensure that icache is what SDRAM says it should be, by doing a
> -	  byte wise comparision between SDRAM and instruction cache. This
> +	  Say Y here if you are getting weird unexplained errors. This will
> +	  ensure that icache is what SDRAM says it should be by doing a
> +	  byte wise comparison between SDRAM and instruction cache. This
>  	  also relocates the irq_panic() function to L1 memory, (which is
>  	  un-cached).
>  
> @@ -921,7 +921,7 @@
>  	help
>  	  Say Y here to put in an mini-execption handler before the kernel
>  	  replaces the bootloader exception handler. This will stop kernels
> -	  from dieing at startup with no visible error messages.
> +	  from dying at startup with no visible error messages.
>  
>  config DEBUG_SERIAL_EARLY_INIT
>  	bool "Initialize serial driver early"
> @@ -930,8 +930,8 @@
>  	help
>  	  Say Y here if you want to get kernel output early when kernel
>  	  crashes before the normal console initialization. If this option
> -	  is enable, console output will always go to the ttyBF0, no matter
> -	  what kernel boot paramters you set.
> +	  is enabled, console output will always go to the ttyBF0, no matter
> +	  what kernel boot parameters you set.
>  
>  config DEBUG_HUNT_FOR_ZERO
>  	bool "Catch NULL pointer reads/writes"
> diff -ru a/arch/cris/arch-v10/Kconfig b/arch/cris/arch-v10/Kconfig
> --- a/arch/cris/arch-v10/Kconfig	2007-04-25 23:08:32.000000000 -0400
> +++ b/arch/cris/arch-v10/Kconfig	2007-05-11 20:59:17.000000000 -0400
> @@ -182,7 +182,7 @@
>  	  set this to same as CONFIG_ETRAX_LED1G (normally 2).
>  
>  config ETRAX_LED8Y
> -	int "Eigth yellow LED bit"
> +	int "Eighth yellow LED bit"
>  	depends on ETRAX_CSP0_LEDS
>  	default "2"
>  	help
> diff -ru a/arch/ia64/Kconfig b/arch/ia64/Kconfig
> --- a/arch/ia64/Kconfig	2007-05-11 20:32:25.000000000 -0400
> +++ b/arch/ia64/Kconfig	2007-05-11 21:40:23.000000000 -0400
> @@ -442,9 +442,9 @@
>  config IA64_MC_ERR_INJECT
>  	tristate "MC error injection support"
>  	help
> -	  Selets whether support for MC error injection. By enabling the
> -	  support, kernel provide sysfs interface for user application to
> -	  call MC error injection PAL procedure to inject various errors.
> +	  Adds support for MC error injection. If enabled, the kernel 
> +          will provide a sysfs interface for user applications to
> +	  call MC error injection PAL procedures to inject various errors.
>  	  This is a useful tool for MCA testing.
>  
>  	  If you're unsure, do not select this option.
> @@ -471,7 +471,7 @@
>  	  but it is independent of the system firmware.   And like a reboot
>  	  you can start any kernel with it, not just Linux.
>  
> -	  The name comes from the similiarity to the exec system call.
> +	  The name comes from the similarity to the exec system call.
>  
>  	  It is an ongoing process to be certain the hardware in a machine
>  	  is properly shutdown, so do not be surprised if this code does not
> diff -ru a/arch/mips/Kconfig b/arch/mips/Kconfig
> --- a/arch/mips/Kconfig	2007-05-11 20:32:29.000000000 -0400
> +++ b/arch/mips/Kconfig	2007-05-11 21:20:49.000000000 -0400
> @@ -748,8 +748,8 @@
>  
>  	  This is useful for kernel debugging when your machine crashes very
>  	  early before the console code is initialized. For normal operation
> -	  it is not recommended because it looks on some machines ugly and
> -	  oesn't cooperate with an X server. You should normally N here,
> +	  it is not recommended because it looks ugly on some machines and
> +	  doesn't cooperate with an X server. You should normally say N here,
>  	  unless you want to debug such a crash.
>  
>  config SYS_HAS_EARLY_PRINTK
> @@ -1749,7 +1749,7 @@
>  	  but it is independent of the system firmware.   And like a reboot
>  	  you can start any kernel with it, not just Linux.
>  
> -	  The name comes from the similiarity to the exec system call.
> +	  The name comes from the similarity to the exec system call.
>  
>  	  It is an ongoing process to be certain the hardware in a machine
>  	  is properly shutdown, so do not be surprised if this code does not
> diff -ru a/arch/powerpc/platforms/Kconfig b/arch/powerpc/platforms/Kconfig
> --- a/arch/powerpc/platforms/Kconfig	2007-05-11 20:32:30.000000000 -0400
> +++ b/arch/powerpc/platforms/Kconfig	2007-05-11 21:30:35.000000000 -0400
> @@ -108,7 +108,7 @@
>  	depends PPC_IBM_CELL_BLADE
>  	help
>  	  PMI (Platform Management Interrupt) is a way to
> -	  communicate with the BMC (Baseboard Mangement Controller).
> +	  communicate with the BMC (Baseboard Management Controller).
>  	  It is used in some IBM Cell blades.
>  	default m
>  
> diff -ru a/arch/um/Kconfig b/arch/um/Kconfig
> --- a/arch/um/Kconfig	2007-05-11 20:32:32.000000000 -0400
> +++ b/arch/um/Kconfig	2007-05-11 21:41:30.000000000 -0400
> @@ -3,7 +3,7 @@
>  	option defconfig_list
>  	default "arch/$ARCH/defconfig"
>  
> -# UML uses the generic IRQ sugsystem
> +# UML uses the generic IRQ subsystem
>  config GENERIC_HARDIRQS
>  	bool
>  	default y
> diff -ru a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> --- a/drivers/i2c/busses/Kconfig	2007-05-11 20:32:43.000000000 -0400
> +++ b/drivers/i2c/busses/Kconfig	2007-05-11 21:36:01.000000000 -0400
> @@ -258,7 +258,7 @@
>  	depends on ARCH_IXP2000
>  	select I2C_ALGOBIT
>  	help
> -	  Say Y here if you have an Intel IXP2000(2400, 2800, 2850) based 
> +	  Say Y here if you have an Intel IXP2000 (2400, 2800, 2850) based 
>  	  system and are using GPIO lines for an I2C bus.
>  
>  	  This support is also available as a module. If so, the module
> @@ -273,8 +273,8 @@
>  	default y
>  	help
>  	  This exposes the various PowerMac i2c interfaces to the linux i2c
> -	  layer and to userland. It is used by various drivers on the powemac
> -	  platform, thus should generally be enabled.
> +	  layer and to userland. It is used by various drivers on the PowerMac
> +	  platform, and should generally be enabled.
>  
>  	  This support is also available as a module.  If so, the module
>  	  will be called i2c-powermac.
> @@ -423,12 +423,12 @@
>  	tristate "Simtec Generic I2C interface"
>  	select I2C_ALGOBIT
>  	help
> -	  If you say yes to this option, support will be inclyded for
> +	  If you say yes to this option, support will be included for
>  	  the Simtec Generic I2C interface. This driver is for the
>  	  simple I2C bus used on newer Simtec products for general
>  	  I2C, such as DDC on the Simtec BBD2016A.
>  
> -	  This driver can also be build as a module. If so, the module
> +	  This driver can also be built as a module. If so, the module
>  	  will be called i2c-simtec.
>  
>  config SCx200_I2C
> diff -ru a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> --- a/drivers/mfd/Kconfig	2007-05-11 20:32:56.000000000 -0400
> +++ b/drivers/mfd/Kconfig	2007-05-11 20:50:59.000000000 -0400
> @@ -10,8 +10,8 @@
>  	 ---help---
>  	  This is the core driver for the Silicon Motion SM501 multimedia
>  	  companion chip. This device is a multifunction device which may
> -	  provide numerous interfaces including USB host controller USB gadget,
> -	  Asyncronous Serial ports, Audio functions and a dual display video
> +	  provide numerous interfaces including USB host controller, USB gadget,
> +	  asynchronous serial ports, audio functions, and a dual display video
>  	  interface. The device may be connected by PCI or local bus with
>  	  varying functions enabled.
>  
> diff -ru a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> --- a/drivers/misc/Kconfig	2007-05-11 20:32:56.000000000 -0400
> +++ b/drivers/misc/Kconfig	2007-05-11 21:03:35.000000000 -0400
> @@ -148,7 +148,7 @@
>  	  For more information about this driver see 
>  	  <file:Documentation/thinkpad-acpi.txt> and <http://ibm-acpi.sf.net/> .
>  
> -	  This driver was formely known as ibm-acpi.
> +	  This driver was formerly known as ibm-acpi.
>  
>  	  If you have an IBM or Lenovo ThinkPad laptop, say Y or M here.
>  
> @@ -182,7 +182,7 @@
>  	default y
>  	---help---
>  	  Allows the thinkpad_acpi driver to handle removable bays.  It will
> -	  eletrically disable the device in the bay, and also generate
> +	  electrically disable the device in the bay, and also generate
>  	  notifications when the bay lever is ejected or inserted.
>  
>  	  If you are not sure, say Y here.
> diff -ru a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
> --- a/drivers/mtd/maps/Kconfig	2007-05-11 20:32:59.000000000 -0400
> +++ b/drivers/mtd/maps/Kconfig	2007-05-11 21:32:22.000000000 -0400
> @@ -54,7 +54,7 @@
>  	help
>  	  This is the total width of the data bus of the flash devices
>  	  in octets. For example, if you have a data bus width of 32
> -	  bits, you would set the bus width octect value to 4. This is
> +	  bits, you would set the bus width octet value to 4. This is
>  	  used internally by the CFI drivers.
>  	  Ignore this option if you use run-time physmap configuration
>  	  (i.e., run-time calling physmap_configure()).
> @@ -73,12 +73,12 @@
>  	depends on PMC_MSP && MTD_CFI
>  	select MTD_PARTITIONS
>  	help
> -	  This provides a 'mapping' driver which support the way
> +	  This provides a 'mapping' driver which supports the way
>            in which user-programmable flash chips are connected on the
> -          PMC-Sierra MSP eval/demo boards
> +          PMC-Sierra MSP eval/demo boards.
>  
>  choice
> -	prompt "Maximum mappable memory avialable for flash IO"
> +	prompt "Maximum mappable memory available for flash IO"
>  	depends on MTD_PMC_MSP_EVM
>  	default MSP_FLASH_MAP_LIMIT_32M
>  
> diff -ru a/drivers/video/Kconfig b/drivers/video/Kconfig
> --- a/drivers/video/Kconfig	2007-05-11 20:33:11.000000000 -0400
> +++ b/drivers/video/Kconfig	2007-05-11 21:18:17.000000000 -0400
> @@ -618,7 +618,7 @@
>         help
>           This enables support for the Hecuba board. This driver was tested
>           with an E-Ink 800x600 display and x86 SBCs through a 16 bit GPIO
> -         interface (8 bit data, 4 bit control). If you anticpate using
> +         interface (8 bit data, 4 bit control). If you anticipate using
>           this driver, say Y or M; otherwise say N. You must specify the
>           GPIO IO address to be used for setting control and data.
>  
> @@ -1542,7 +1542,7 @@
>  	help
>  	  This is the framebuffer device for the Sun XVR-500 and similar
>  	  graphics cards based upon the 3DLABS Wildcat chipset.  The driver
> -	  only works on sparc64 systems where the system firwmare has
> +	  only works on sparc64 systems where the system firmware has
>  	  mostly initialized the card already.  It is treated as a
>  	  completely dumb framebuffer device.
>  
> @@ -1555,7 +1555,7 @@
>  	help
>  	  This is the framebuffer device for the Sun XVR-2500 and similar
>  	  graphics cards based upon the 3DLABS Wildcat chipset.  The driver
> -	  only works on sparc64 systems where the system firwmare has
> +	  only works on sparc64 systems where the system firmware has
>  	  mostly initialized the card already.  It is treated as a
>  	  completely dumb framebuffer device.
>  
> diff -ru a/net/ipv4/Kconfig b/net/ipv4/Kconfig
> --- a/net/ipv4/Kconfig	2007-05-11 20:33:58.000000000 -0400
> +++ b/net/ipv4/Kconfig	2007-05-11 21:10:15.000000000 -0400
> @@ -593,7 +593,7 @@
>  	depends on EXPERIMENTAL
>  	default n
>  	---help---
> -	TCP-Illinois is a sender-side modificatio of TCP Reno for
> +	TCP-Illinois is a sender-side modification of TCP Reno for
>  	high speed long delay links. It uses round-trip-time to
>  	adjust the alpha and beta parameters to achieve a higher average
>  	throughput and maintain fairness.


-- 
Matt LaPlante
CCNP, CCDP, A+, Linux+, CQS
kernel1@cyberdogtech.com

