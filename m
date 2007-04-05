Return-Path: <linux-kernel-owner+w=401wt.eu-S1767116AbXDEQDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767116AbXDEQDr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 12:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767126AbXDEQDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 12:03:47 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49697 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767116AbXDEQDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 12:03:45 -0400
Date: Thu, 5 Apr 2007 17:06:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, hpa@zytor.com
Subject: [PATCH] doc/kernel-parameters: use IA-32 tag instead of i386 take 2
Message-ID: <20070405170642.28ff4813@the-village.bc.nu>
In-Reply-To: <46151D41.50801@oracle.com>
References: <20070404220534.36cd24e9.randy.dunlap@oracle.com>
	<20070404224152.29062e47.akpm@linux-foundation.org>
	<20070405084155.e00687a4.randy.dunlap@oracle.com>
	<20070405164935.607adfc6@the-village.bc.nu>
	<46151D41.50801@oracle.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok try this one then

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>

--- Documentation/kernel-parameters.txt~	2007-04-05 16:30:30.817515360 +0100
+++ Documentation/kernel-parameters.txt	2007-04-05 16:48:15.557650256 +0100
@@ -41,7 +41,6 @@
 	EIDE	EIDE/ATAPI support is enabled.
 	FB	The frame buffer device is enabled.
 	HW	Appropriate hardware is enabled.
-	IA-32	IA-32 aka i386 architecture is enabled.
 	IA-64	IA-64 architecture is enabled.
 	IOSCHED	More than one I/O scheduler is enabled.
 	IP_PNP	IP DHCP, BOOTP, or RARP is enabled.
@@ -91,6 +90,7 @@
 	VT	Virtual terminal support is enabled.
 	WDT	Watchdog support is enabled.
 	XT	IBM PC/XT MFM hard disk support is enabled.
+	X86-32	X86-32, aka i386 architecture is enabled.
 	X86-64	X86-64 architecture is enabled.
 			More X86-64 boot options can be found in
 			Documentation/x86_64/boot-options.txt .
@@ -202,7 +202,7 @@
 			override platform specific driver.
 			See also Documentation/acpi-hotkey.txt.
 
-	acpi_pm_good	[IA-32,X86-64]
+	acpi_pm_good	[X86-32,X86-64]
 			Override the pmtimer bug detection: force the kernel
 			to assume that this machine's pmtimer latches its value
 			and always returns good values.
@@ -336,7 +336,7 @@
 
 	c101=		[NET] Moxa C101 synchronous serial card
 
-	cachesize=	[BUGS=IA-32] Override level 2 CPU cache size detection.
+	cachesize=	[BUGS=X86-32] Override level 2 CPU cache size detection.
 			Sometimes CPU hardware bugs make them report the cache
 			size incorrectly. The kernel will attempt work arounds
 			to fix known problems, but for some CPUs it is not
@@ -359,25 +359,25 @@
 			Value can be changed at runtime via
 				/selinux/checkreqprot.
 
-	clock=		[BUGS=IA-32, HW] gettimeofday clocksource override.
+	clock=		[BUGS=X86-32, HW] gettimeofday clocksource override.
 			[Deprecated]
 			Forces specified clocksource (if available) to be used
 			when calculating gettimeofday(). If specified
 			clocksource is not available, it defaults to PIT.
 			Format: { pit | tsc | cyclone | pmtmr }
 
-	code_bytes	[IA32] How many bytes of object code to print in an
+	code_bytes	[X86-32] How many bytes of object code to print in an
 			oops report.
 			Range: 0 - 8192
 			Default: 64
 
 	disable_8254_timer
 	enable_8254_timer
-			[IA32/X86_64] Disable/Enable interrupt 0 timer routing
+			[X86-32/X86_64] Disable/Enable interrupt 0 timer routing
 			over the 8254 in addition to over the IO-APIC. The
 			kernel tries to set a sensible default.
 
-	hpet=		[IA-32,HPET] option to disable HPET and use PIT.
+	hpet=		[X86-32,HPET] option to disable HPET and use PIT.
 			Format: disable
 
 	cm206=		[HW,CD]
@@ -486,7 +486,7 @@
 
 	dtc3181e=	[HW,SCSI]
 
-	earlyprintk=	[IA-32,X86-64,SH]
+	earlyprintk=	[X86-32,X86-64,SH]
 			earlyprintk=vga
 			earlyprintk=serial[,ttySn[,baudrate]]
 
@@ -524,7 +524,7 @@
 	eisa_irq_edge=	[PARISC,HW]
 			See header of drivers/parisc/eisa.c.
 
-	elanfreq=	[IA-32]
+	elanfreq=	[X86-32]
 			See comment before function elanfreq_setup() in
 			arch/i386/kernel/cpu/cpufreq/elanfreq.c.
 
@@ -533,7 +533,7 @@
 			See Documentation/block/as-iosched.txt and
 			Documentation/block/deadline-iosched.txt for details.
 
-	elfcorehdr=	[IA-32, X86_64]
+	elfcorehdr=	[X86-32, X86_64]
 			Specifies physical address of start of kernel core
 			image elf header. Generally kexec loader will
 			pass this option to capture kernel.
@@ -618,7 +618,7 @@
 	hisax=		[HW,ISDN]
 			See Documentation/isdn/README.HiSax.
 
-	hugepages=	[HW,IA-32,IA-64] Maximal number of HugeTLB pages.
+	hugepages=	[HW,X86-32,IA-64] Maximal number of HugeTLB pages.
 
 	i8042.direct	[HW] Put keyboard port into non-translated mode
 	i8042.dumbkbd	[HW] Pretend that controller can only read data from
@@ -763,7 +763,7 @@
 	js=		[HW,JOY] Analog joystick
 			See Documentation/input/joystick.txt.
 
-	kernelcore=nn[KMG]	[KNL,IA-32,IA-64,PPC,X86-64] This parameter
+	kernelcore=nn[KMG]	[KNL,X86-32,IA-64,PPC,X86-64] This parameter
 			specifies the amount of memory usable by the kernel
 			for non-movable allocations.  The requested amount is
 			spread evenly throughout all nodes in the system. The
@@ -781,15 +781,15 @@
 
 	keepinitrd	[HW,ARM]
 
-	kstack=N	[IA-32,X86-64] Print N words from the kernel stack
+	kstack=N	[X86-32,X86-64] Print N words from the kernel stack
 			in oops dumps.
 
 	l2cr=		[PPC]
 
-	lapic		[IA-32,APIC] Enable the local APIC even if BIOS
+	lapic		[X86-32,APIC] Enable the local APIC even if BIOS
 			disabled it.
 
-	lapic_timer_c2_ok	[IA-32,x86-64,APIC] trust the local apic timer in
+	lapic_timer_c2_ok	[X86-32,x86-64,APIC] trust the local apic timer in
 			C2 power state.
 
 	lasi=		[HW,SCSI] PARISC LASI driver for the 53c700 chip
@@ -903,7 +903,7 @@
 			[SCSI] Maximum number of LUNs received.
 			Should be between 1 and 16384.
 
-	mca-pentium	[BUGS=IA-32]
+	mca-pentium	[BUGS=X86-32]
 
 	mcatest=	[IA-64]
 
@@ -912,7 +912,7 @@
 
 	mcdx=		[HW,CD]
 
-	mce		[IA-32] Machine Check Exception
+	mce		[X86-32] Machine Check Exception
 
 	md=		[HW] RAID subsystems devices and level
 			See Documentation/md.txt.
@@ -924,14 +924,14 @@
 	mem=nn[KMG]	[KNL,BOOT] Force usage of a specific amount of memory
 			Amount of memory to be used when the kernel is not able
 			to see the whole system memory or for test.
-			[IA-32] Use together with memmap= to avoid physical
+			[X86-32] Use together with memmap= to avoid physical
 			address space collisions. Without memmap= PCI devices
 			could be placed at addresses belonging to unused RAM.
 
-	mem=nopentium	[BUGS=IA-32] Disable usage of 4MB pages for kernel
+	mem=nopentium	[BUGS=X86-32] Disable usage of 4MB pages for kernel
 			memory.
 
-	memmap=exactmap	[KNL,IA-32,X86_64] Enable setting of an exact
+	memmap=exactmap	[KNL,X86-32,X86_64] Enable setting of an exact
 			E820 memory map, as specified by the user.
 			Such memmap=exactmap lines can be constructed based on
 			BIOS output or other requirements. See the memmap=nn@ss
@@ -1060,9 +1060,9 @@
 			[NFS] set the maximum lifetime for idmapper cache
 			entries.
 
-	nmi_watchdog=	[KNL,BUGS=IA-32] Debugging features for SMP kernels
+	nmi_watchdog=	[KNL,BUGS=X86-32] Debugging features for SMP kernels
 
-	no387		[BUGS=IA-32] Tells the kernel to use the 387 maths
+	no387		[BUGS=X86-32] Tells the kernel to use the 387 maths
 			emulation library even if a 387 maths coprocessor
 			is present.
 
@@ -1093,17 +1093,17 @@
 
 	noexec		[IA-64]
 
-	noexec		[IA-32,X86-64]
+	noexec		[X86-32,X86-64]
 			noexec=on: enable non-executable mappings (default)
 			noexec=off: disable nn-executable mappings
 
-	nofxsr		[BUGS=IA-32] Disables x86 floating point extended
+	nofxsr		[BUGS=X86-32] Disables x86 floating point extended
 			register save and restore. The kernel will only save
 			legacy floating-point registers on task switch.
 
 	nohlt		[BUGS=ARM]
 
-	no-hlt		[BUGS=IA-32] Tells the kernel that the hlt
+	no-hlt		[BUGS=X86-32] Tells the kernel that the hlt
 			instruction doesn't work correctly and not to
 			use it.
 
@@ -1118,12 +1118,12 @@
 			Valid arguments: on, off
 			Default: on
 
-	noirqbalance	[IA-32,SMP,KNL] Disable kernel irq balancing
+	noirqbalance	[X86-32,SMP,KNL] Disable kernel irq balancing
 
-	noirqdebug	[IA-32] Disables the code which attempts to detect and
+	noirqdebug	[X86-32] Disables the code which attempts to detect and
 			disable unhandled interrupt sources.
 
-	no_timer_check	[IA-32,X86_64,APIC] Disables the code which tests for
+	no_timer_check	[X86-32,X86_64,APIC] Disables the code which tests for
 			broken timer IRQ sources.
 
 	noisapnp	[ISAPNP] Disables ISA PnP code.
@@ -1133,16 +1133,16 @@
 
 	nointroute	[IA-64]
 
-	nolapic		[IA-32,APIC] Do not enable or use the local APIC.
+	nolapic		[X86-32,APIC] Do not enable or use the local APIC.
 
-	nolapic_timer	[IA-32,APIC] Do not use the local APIC timer.
+	nolapic_timer	[X86-32,APIC] Do not use the local APIC timer.
 
 	noltlbs		[PPC] Do not use large page/tlb entries for kernel
 			lowmem mapping on PPC40x.
 
 	nomca		[IA-64] Disable machine check abort handling
 
-	nomce		[IA-32] Machine Check Exception
+	nomce		[X86-32] Machine Check Exception
 
 	noresidual	[PPC] Don't use residual data on PReP machines.
 
@@ -1155,13 +1155,13 @@
 
 	nosbagart	[IA-64]
 
-	nosep		[BUGS=IA-32] Disables x86 SYSENTER/SYSEXIT support.
+	nosep		[BUGS=X86-32] Disables x86 SYSENTER/SYSEXIT support.
 
 	nosmp		[SMP] Tells an SMP kernel to act as a UP kernel.
 
 	nosync		[HW,M68K] Disables sync negotiation for all devices.
 
-	notsc		[BUGS=IA-32] Disable Time Stamp Counter
+	notsc		[BUGS=X86-32] Disable Time Stamp Counter
 
 	nousb		[USB] Disable the USB subsystem
 
@@ -1232,28 +1232,28 @@
 			See also Documentation/paride.txt.
 
 	pci=option[,option...]	[PCI] various PCI subsystem options:
-		off		[IA-32] don't probe for the PCI bus
-		bios		[IA-32] force use of PCI BIOS, don't access
+		off		[X86-32] don't probe for the PCI bus
+		bios		[X86-32] force use of PCI BIOS, don't access
 				the hardware directly. Use this if your machine
 				has a non-standard PCI host bridge.
-		nobios		[IA-32] disallow use of PCI BIOS, only direct
+		nobios		[X86-32] disallow use of PCI BIOS, only direct
 				hardware access methods are allowed. Use this
 				if you experience crashes upon bootup and you
 				suspect they are caused by the BIOS.
-		conf1		[IA-32] Force use of PCI Configuration
+		conf1		[X86-32] Force use of PCI Configuration
 				Mechanism 1.
-		conf2		[IA-32] Force use of PCI Configuration
+		conf2		[X86-32] Force use of PCI Configuration
 				Mechanism 2.
-		nommconf	[IA-32,X86_64] Disable use of MMCONFIG for PCI
+		nommconf	[X86-32,X86_64] Disable use of MMCONFIG for PCI
 				Configuration
 		nomsi		[MSI] If the PCI_MSI kernel config parameter is
 				enabled, this kernel boot option can be used to
 				disable the use of MSI interrupts system-wide.
-		nosort		[IA-32] Don't sort PCI devices according to
+		nosort		[X86-32] Don't sort PCI devices according to
 				order given by the PCI BIOS. This sorting is
 				done to get a device order compatible with
 				older kernels.
-		biosirq		[IA-32] Use PCI BIOS calls to get the interrupt
+		biosirq		[X86-32] Use PCI BIOS calls to get the interrupt
 				routing table. These calls are known to be buggy
 				on several machines and they hang the machine
 				when used, but on other computers it's the only
@@ -1261,32 +1261,32 @@
 				this option if the kernel is unable to allocate
 				IRQs or discover secondary PCI buses on your
 				motherboard.
-		rom		[IA-32] Assign address space to expansion ROMs.
+		rom		[X86-32] Assign address space to expansion ROMs.
 				Use with caution as certain devices share
 				address decoders between ROMs and other
 				resources.
-		irqmask=0xMMMM	[IA-32] Set a bit mask of IRQs allowed to be
+		irqmask=0xMMMM	[X86-32] Set a bit mask of IRQs allowed to be
 				assigned automatically to PCI devices. You can
 				make the kernel exclude IRQs of your ISA cards
 				this way.
-		pirqaddr=0xAAAAA	[IA-32] Specify the physical address
+		pirqaddr=0xAAAAA	[X86-32] Specify the physical address
 				of the PIRQ table (normally generated
 				by the BIOS) if it is outside the
 				F0000h-100000h range.
-		lastbus=N	[IA-32] Scan all buses thru bus #N. Can be
+		lastbus=N	[X86-32] Scan all buses thru bus #N. Can be
 				useful if the kernel is unable to find your
 				secondary buses and you want to tell it
 				explicitly which ones they are.
-		assign-busses	[IA-32] Always assign all PCI bus
+		assign-busses	[X86-32] Always assign all PCI bus
 				numbers ourselves, overriding
 				whatever the firmware may have done.
-		usepirqmask	[IA-32] Honor the possible IRQ mask stored
+		usepirqmask	[X86-32] Honor the possible IRQ mask stored
 				in the BIOS $PIR table. This is needed on
 				some systems with broken BIOSes, notably
 				some HP Pavilion N5400 and Omnibook XE3
 				notebooks. This will have no effect if ACPI
 				IRQ routing is enabled.
-		noacpi		[IA-32] Do not use ACPI for IRQ routing
+		noacpi		[X86-32] Do not use ACPI for IRQ routing
 				or for PCI scanning.
 		routeirq	Do IRQ routing for all PCI devices.
 				This is normally done in pci_enable_device(),
@@ -1432,13 +1432,13 @@
 			Run specified binary instead of /init from the ramdisk,
 			used for early userspace startup. See initrd.
 
-	reboot=		[BUGS=IA-32,BUGS=ARM,BUGS=IA-64] Rebooting mode
+	reboot=		[BUGS=X86-32,BUGS=ARM,BUGS=IA-64] Rebooting mode
 			Format: <reboot_mode>[,<reboot_mode2>[,...]]
 			See arch/*/kernel/reboot.c or arch/*/kernel/process.c			
 
 	reserve=	[KNL,BUGS] Force the kernel to ignore some iomem area
 
-	reservetop=	[IA-32]
+	reservetop=	[X86-32]
 			Format: nn[KMG]
 			Reserves a hole at the top of the kernel virtual
 			address space.
@@ -1530,7 +1530,7 @@
                         Value can be changed at runtime via
                         /selinux/compat_net.
 
-	serialnumber	[BUGS=IA-32]
+	serialnumber	[BUGS=X86-32]
 
 	sg_def_reserved_size=	[SCSI]
 
@@ -1809,14 +1809,14 @@
 	usbhid.mousepoll=
 			[USBHID] The interval which mice are to be polled at.
 
-	vdso=		[IA-32,SH]
+	vdso=		[X86-32,SH]
 			vdso=1: enable VDSO (default)
 			vdso=0: disable VDSO mapping
 
 	video=		[FB] Frame buffer configuration
 			See Documentation/fb/modedb.txt.
 
-	vga=		[BOOT,IA-32] Select a particular video mode
+	vga=		[BOOT,X86-32] Select a particular video mode
 			See Documentation/i386/boot.txt and
 			Documentation/svga.txt.
 			Use vga=ask for menu.

