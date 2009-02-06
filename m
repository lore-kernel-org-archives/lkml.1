Return-Path: <linux-kernel-owner+w=401wt.eu-S1757207AbZBFNxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207AbZBFNxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 08:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754081AbZBFNxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 08:53:11 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:58391 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbZBFNxI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 08:53:08 -0500
X-BigFish: VPS-37(zz1432R1453M98dR936eQ1805M936fM8b9bkzzzzz32i6bh6di43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KEND7W-01-PKZ-01
Date: Fri, 6 Feb 2009 14:52:48 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Mark Hounschell <dmarkh@cfl.rr.com>
CC: markh@compro.net, Andreas Herrmann <andreas.herrmann3@amd.com>,
       john stultz <johnstul@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PROBLEM: Can't boot a (HZ = 1000) kernel using an AMD Phenom-II
	processor
Message-ID: <20090206135248.GB23459@aftab>
References: <49798F33.8070906@cfl.rr.com> <20090123130416.GA27616@alberich.amd.com> <497A48D5.9040904@cfl.rr.com> <497E0072.7000500@compro.net> <20090127163843.GA1628@aftab> <497FA725.7020503@cfl.rr.com> <497FA7F2.3060709@cfl.rr.com> <20090203151137.GB12017@aftab> <498897C1.2090802@compro.net> <498B1FA9.2050203@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <498B1FA9.2050203@cfl.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 06 Feb 2009 13:52:48.0136 (UTC) FILETIME=[31DAB880:01C98862]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Feb 05, 2009 at 12:19:37PM -0500, Mark Hounschell wrote:
> A tickless kernel didn't change anything. I did get a serial console connected
> and below is what I got. I don't see much usefull. Attached is the config.

Nope, not really. It happens really early in the process for initcalls.
By the way, is the system then completely locked up or you can enter
characters from the keyboard?

> Press any key to continue.
> root (hd0,0)
>  Filesystem type is ext2fs, partition type 0x83
> kernel /vmlinuz-2.6.26.8-1000Hz  root=/dev/sda5 hwprobe=-modules.pata apm=off s
> elinux=0 noresume splash=silent debug initcall_debug log_buf_len=10M console=tt
> yS0,19200n8 vga=normal
>    [Linux-bzImage, setup=0x2e00, size=0x1827c0]
> initrd /initrd-2.6.26.8-1000Hz
>    [Linux-initrd @ 0x37622000, 0x9cdf42 bytes]
> 
> Initializing cgroup subsys cpuset
> Linux version 2.6.26.8-1000Hz (root@harley) (gcc version 4.3.1 20080507
> (prerelease) [gcc-4_3-branch revision 135036] (SUSE Linux) ) #5 SMP PREEMPT Wed Feb9

Is this actually a Suse distribution kernel (with a lot of patches on it) or a stock one?

> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
>  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 00000000bffe0000 (usable)
>  BIOS-e820: 00000000bffe0000 - 00000000bffe3000 (ACPI NVS)
>  BIOS-e820: 00000000bffe3000 - 00000000bfff0000 (ACPI data)
>  BIOS-e820: 00000000bfff0000 - 00000000c0000000 (reserved)
>  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
>  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
>  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
> x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> Warning only 4GB will be used.
> Use a HIGHMEM64G enabled kernel.
> 3200MB HIGHMEM available.
> 896MB LOWMEM available.
> found SMP MP-table at [c00f3f00] 000f3f00
> Entering add_active_range(0, 0, 1048576) 0 entries of 256 used
> Zone PFN ranges:
>   DMA             0 ->     4096
>   Normal       4096 ->   229376
>   HighMem    229376 ->  1048576
> Movable zone start PFN for each node
> early_node_map[1] active PFN ranges
>     0:        0 ->  1048576
> On node 0 totalpages: 1048576
>   DMA zone: 32 pages used for memmap
>   DMA zone: 0 pages reserved
>   DMA zone: 4064 pages, LIFO batch:0
>   Normal zone: 1760 pages used for memmap
>   Normal zone: 223520 pages, LIFO batch:31
>   HighMem zone: 6400 pages used for memmap
>   HighMem zone: 812800 pages, LIFO batch:31
>   Movable zone: 0 pages used for memmap
> DMI 2.5 present.
> ACPI: RSDP 000F7FB0, 0024 (r2 RX780 )
> ACPI: XSDT BFFE3080, 0044 (r1 RX780  AWRDACPI 42302E31 AWRD        0)
> ACPI: FACP BFFE8C80, 00F4 (r3 RX780  AWRDACPI 42302E31 AWRD        0)
> ACPI: DSDT BFFE3200, 5A71 (r1 RX780  AWRDACPI     1000 MSFT  100000E)
> ACPI: FACS BFFE0000, 0040
> ACPI: HPET BFFE8E40, 0038 (r1 RX780  AWRDACPI 42302E31 AWRD       98)
> ACPI: MCFG BFFE8E80, 003C (r1 RX780  AWRDACPI 42302E31 AWRD        0)
> ACPI: APIC BFFE8D80, 0084 (r1 RX780  AWRDACPI 42302E31 AWRD        0)
> ATI board detected. Disabling timer routing over 8254.
> ACPI: PM-Timer IO Port: 0x4008
> ACPI: Local APIC address 0xfee00000
> ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
> ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
> ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
> ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
> IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
> ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
> ACPI: IRQ0 used by override.
> ACPI: IRQ2 used by override.
> ACPI: IRQ9 used by override.
> Enabling APIC mode:  Flat.  Using 1 I/O APICs
> ACPI: HPET id: 0x10b9a201 base: 0xfed00000
> Using ACPI (MADT) for SMP configuration information
> Allocating PCI resources starting at c2000000 (gap: c0000000:20000000)
> SMP: Allowing 4 CPUs, 0 hotplug CPUs
> PERCPU: Allocating 38788 bytes of per cpu data
> NR_CPUS: 32, nr_cpu_ids: 4
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1040384
> Kernel command line: root=/dev/sda5 hwprobe=-modules.pata apm=off selinux=0
> noresume splash=silent debug initcall_debug log_buf_len=10M console=ttyS0,19200l
> log_buf_len: 16777216
> mapped APIC to ffffb000 (fee00000)
> mapped IOAPIC to ffffa000 (fec00000)
> Enabling fast FPU save and restore... done.
> Enabling unmasked SIMD FPU exception support... done.
> Initializing CPU#0
> Preemptible RCU implementation.
> PID hash table entries: 4096 (order: 12, 16384 bytes)
> Detected 3360.327 MHz processor.

Is your CPU overclocked?

> Console: colour VGA+ 80x25
> console [ttyS0] enabled
> Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
> Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> Memory: 3080904k/4194304k available (1751k kernel code, 63472k reserved, 730k
> data, 216k init, 2228096k highmem)
> virtual kernel memory layout:
>     fixmap  : 0xffe15000 - 0xfffff000   (1960 kB)
>     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
>     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
>     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
>       .init : 0xc0373000 - 0xc03a9000   ( 216 kB)
>       .data : 0xc02b5ca2 - 0xc036c6d0   ( 730 kB)
>       .text : 0xc0100000 - 0xc02b5ca2   (1751 kB)
> Checking if this processor honours the WP bit even in supervisor mode...Ok.
> CPA: page pool initialized 1 of 1 pages preallocated
> SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1

Ok, here are two things you could try:

Disable CONFIG_HIGH_RES_TIMERS (high resolution timers support in
"Processor type and features"), boot with "apic=debug" and send me the
output. I'd like to see how the lapic timer gets programmed. It would
be better for that exercise to get the latest stable kernel, 2.6.28.3,
imho.

The other thing you could do is get x86info tools from here:
http://www.codemonkey.org.uk/projects/x86info/. However, get either a
daily snapshot or a checkout from the git repository and build it on
your system. Then do

x86info -a > x86info.txt

lsmsr -V3 -a > lsmsr.txt

and send me those text files - we might be able to get a clue what's going on
from them.

Thanks.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

