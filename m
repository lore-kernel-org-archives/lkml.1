Return-Path: <linux-kernel-owner+w=401wt.eu-S1757501AbZDNQAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501AbZDNQAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757179AbZDNQAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:00:16 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:27929 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757375AbZDNQAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:00:13 -0400
Message-ID: <49E4B2CC.3060005@oracle.com>
Date: Tue, 14 Apr 2009 08:59:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: kernel-parameters replace X86-32,X86-64 with
 X86
References: <1239698023.3033.37.camel@ht.satnam>
In-Reply-To: <1239698023.3033.37.camel@ht.satnam>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010203.49E4B2B1.0195:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> X86 is same as X86-32+X86-64 so replacing X86-32,X86-64 with X86

That's all good, thanks.

There is still one instance of "i386" that should be changed.
This should become just [X86]:

	enable_timer_pin_1 [i386,x86-64]


> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  Documentation/kernel-parameters.txt |   40 +++++++++++++++++-----------------
>  1 files changed, 20 insertions(+), 20 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 5e966a9..8b6acdc 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -134,7 +134,7 @@ and is between 256 and 4096 characters. It is defined in the file
>  ./include/asm/setup.h as COMMAND_LINE_SIZE.
>  
>  
> -	acpi=		[HW,ACPI,X86-64,i386]
> +	acpi=		[HW,ACPI,X86]
>  			Advanced Configuration and Power Interface
>  			Format: { force | off | ht | strict | noirq | rsdt }
>  			force -- enable ACPI if default was off
> @@ -218,7 +218,7 @@ and is between 256 and 4096 characters. It is defined in the file
>  			acpi_osi="!string2"	# remove built-in string2
>  			acpi_osi=		# disable all strings
>  
> -	acpi_pm_good	[X86-32,X86-64]
> +	acpi_pm_good	[X86]
>  			Override the pmtimer bug detection: force the kernel
>  			to assume that this machine's pmtimer latches its value
>  			and always returns good values.
> @@ -459,7 +459,7 @@ and is between 256 and 4096 characters. It is defined in the file
>  			Also note the kernel might malfunction if you disable
>  			some critical bits.
>  
> -	code_bytes	[IA32/X86_64] How many bytes of object code to print
> +	code_bytes	[X86] How many bytes of object code to print
>  			in an oops report.
>  			Range: 0 - 8192
>  			Default: 64
> @@ -592,7 +592,7 @@ and is between 256 and 4096 characters. It is defined in the file
>  			MTRR settings.  This parameter disables that behavior,
>  			possibly causing your machine to run very slowly.
>  
> -	disable_timer_pin_1 [i386,x86-64]
> +	disable_timer_pin_1 [X86]
>  			Disable PIN 1 of APIC timer
>  			Can be useful to work around chipset bugs.
>  
> @@ -624,7 +624,7 @@ and is between 256 and 4096 characters. It is defined in the file
>  			UART at the specified I/O port or MMIO address.
>  			The options are the same as for ttyS, above.
>  
> -	earlyprintk=	[X86-32,X86-64,SH,BLACKFIN]
> +	earlyprintk=	[X86,SH,BLACKFIN]
>  			earlyprintk=vga
>  			earlyprintk=serial[,ttySn[,baudrate]]
>  			earlyprintk=dbgp
> @@ -659,7 +659,7 @@ and is between 256 and 4096 characters. It is defined in the file
>  			See Documentation/block/as-iosched.txt and
>  			Documentation/block/deadline-iosched.txt for details.
>  
> -	elfcorehdr=	[IA64,PPC,SH,X86-32,X86_64]
> +	elfcorehdr=	[IA64,PPC,SH,X86]
>  			Specifies physical address of start of kernel core
>  			image elf header. Generally kexec loader will
>  			pass this option to capture kernel.
> @@ -938,7 +938,7 @@ and is between 256 and 4096 characters. It is defined in the file
>  			See comment before marvel_specify_io7 in
>  			arch/alpha/kernel/core_marvel.c.
>  
> -	io_delay=	[X86-32,X86-64] I/O delay method
> +	io_delay=	[X86] I/O delay method
>  		0x80
>  			Standard port 0x80 based delay
>  		0xed
> @@ -1000,7 +1000,7 @@ and is between 256 and 4096 characters. It is defined in the file
>  
>  	keepinitrd	[HW,ARM]
>  
> -	kernelcore=nn[KMG]	[KNL,X86-32,IA-64,PPC,X86-64] This parameter
> +	kernelcore=nn[KMG]	[KNL,X86,IA-64,PPC] This parameter
>  			specifies the amount of memory usable by the kernel
>  			for non-movable allocations.  The requested amount is
>  			spread evenly throughout all nodes in the system. The
> @@ -1034,7 +1034,7 @@ and is between 256 and 4096 characters. It is defined in the file
>  			Configure the RouterBoard 532 series on-chip
>  			Ethernet adapter MAC address.
>  
> -	kstack=N	[X86-32,X86-64] Print N words from the kernel stack
> +	kstack=N	[X86] Print N words from the kernel stack
>  			in oops dumps.
>  
>  	l2cr=		[PPC]
> @@ -1044,7 +1044,7 @@ and is between 256 and 4096 characters. It is defined in the file
>  	lapic		[X86-32,APIC] Enable the local APIC even if BIOS
>  			disabled it.
>  
> -	lapic_timer_c2_ok	[X86-32,x86-64,APIC] trust the local apic timer
> +	lapic_timer_c2_ok	[X86,APIC] trust the local apic timer
>  			in C2 power state.
>  
>  	libata.dma=	[LIBATA] DMA control
> @@ -1234,7 +1234,7 @@ and is between 256 and 4096 characters. It is defined in the file
>  			[KNL,SH] Allow user to override the default size for
>  			per-device physically contiguous DMA buffers.
>  
> -	memmap=exactmap	[KNL,X86-32,X86_64] Enable setting of an exact
> +	memmap=exactmap	[KNL,X86] Enable setting of an exact
>  			E820 memory map, as specified by the user.
>  			Such memmap=exactmap lines can be constructed based on
>  			BIOS output or other requirements. See the memmap=nn@ss
> @@ -1325,7 +1325,7 @@ and is between 256 and 4096 characters. It is defined in the file
>  	mousedev.yres=	[MOUSE] Vertical screen resolution, used for devices
>  			reporting absolute coordinates, such as tablets
>  
> -	movablecore=nn[KMG]	[KNL,X86-32,IA-64,PPC,X86-64] This parameter
> +	movablecore=nn[KMG]	[KNL,X86,IA-64,PPC] This parameter
>  			is similar to kernelcore except it specifies the
>  			amount of memory used for migratable allocations.
>  			If both kernelcore and movablecore is specified,
> @@ -1427,7 +1427,7 @@ and is between 256 and 4096 characters. It is defined in the file
>  			when a NMI is triggered.
>  			Format: [state][,regs][,debounce][,die]
>  
> -	nmi_watchdog=	[KNL,BUGS=X86-32,X86-64] Debugging features for SMP kernels
> +	nmi_watchdog=	[KNL,BUGS=X86] Debugging features for SMP kernels
>  			Format: [panic,][num]
>  			Valid num: 0,1,2
>  			0 - turn nmi_watchdog off
> @@ -1480,11 +1480,11 @@ and is between 256 and 4096 characters. It is defined in the file
>  
>  	nodsp		[SH] Disable hardware DSP at boot time.
>  
> -	noefi		[X86-32,X86-64] Disable EFI runtime services support.
> +	noefi		[X86] Disable EFI runtime services support.
>  
>  	noexec		[IA-64]
>  
> -	noexec		[X86-32,X86-64]
> +	noexec		[X86]
>  			On X86-32 available only on PAE configured kernels.
>  			noexec=on: enable non-executable mappings (default)
>  			noexec=off: disable non-executable mappings
> @@ -1530,7 +1530,7 @@ and is between 256 and 4096 characters. It is defined in the file
>  	noirqdebug	[X86-32] Disables the code which attempts to detect and
>  			disable unhandled interrupt sources.
>  
> -	no_timer_check	[X86-32,X86_64,APIC] Disables the code which tests for
> +	no_timer_check	[X86,APIC] Disables the code which tests for
>  			broken timer IRQ sources.
>  
>  	noisapnp	[ISAPNP] Disables ISA PnP code.
> @@ -1694,7 +1694,7 @@ and is between 256 and 4096 characters. It is defined in the file
>  				disable the use of PCIE advanced error reporting.
>  		nodomains	[PCI] Disable support for multiple PCI
>  				root domains (aka PCI segments, in ACPI-speak).
> -		nommconf	[X86-32,X86_64] Disable use of MMCONFIG for PCI
> +		nommconf	[X86] Disable use of MMCONFIG for PCI
>  				Configuration
>  		nomsi		[MSI] If the PCI_MSI kernel config parameter is
>  				enabled, this kernel boot option can be used to
> @@ -2385,7 +2385,7 @@ and is between 256 and 4096 characters. It is defined in the file
>  			reported either.
>  
>  	unknown_nmi_panic
> -			[X86-32,X86-64]
> +			[X86]
>  			Set unknown_nmi_panic=1 early on boot.
>  
>  	usbcore.autosuspend=
> @@ -2452,12 +2452,12 @@ and is between 256 and 4096 characters. It is defined in the file
>  					medium is write-protected).
>  			Example: quirks=0419:aaf5:rl,0421:0433:rc
>  
> -	vdso=		[X86-32,SH,x86-64]
> +	vdso=		[X86,SH]
>  			vdso=2: enable compat VDSO (default with COMPAT_VDSO)
>  			vdso=1: enable VDSO (default)
>  			vdso=0: disable VDSO mapping
>  
> -	vdso32=		[X86-32,X86-64]
> +	vdso32=		[X86]
>  			vdso32=2: enable compat VDSO (default with COMPAT_VDSO)
>  			vdso32=1: enable 32-bit VDSO (default)
>  			vdso32=0: disable 32-bit VDSO mapping


-- 
~Randy
