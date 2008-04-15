Return-Path: <linux-kernel-owner+w=401wt.eu-S1754312AbYDOGUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbYDOGUz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 02:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbYDOGUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 02:20:44 -0400
Received: from mk-outboundfilter-4.mail.uk.tiscali.com ([212.74.114.32]:8559
	"EHLO mk-outboundfilter-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750982AbYDOGUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 02:20:40 -0400
X-Trace: 59568189/mk-outboundfilter-2.mail.uk.tiscali.com/F2S/$ACCEPTED/freedom2Surf-customers/83.67.11.44
X-SBRS: None
X-RemoteIP: 83.67.11.44
X-IP-MAIL-FROM: tvrtko@ursulin.net
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al0FALLlA0hTQwss/2dsb2JhbACBXqow
X-IP-Direction: IN
From: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: libata errors with smartctl on 2.6.24, WD3200AAKS and nVidia AHCI
Date: Tue, 15 Apr 2008 07:21:17 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200804092130.07149.tvrtko@ursulin.net> <200804130834.14257.tvrtko@ursulin.net> <48041CC1.1030909@gmail.com>
In-Reply-To: <48041CC1.1030909@gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_dlEBIoG5qvb6A2M"
Message-Id: <200804150721.17337.tvrtko@ursulin.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_dlEBIoG5qvb6A2M
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday 15 April 2008 04:10:57 Tejun Heo wrote:
> Tvrtko A. Ursulin wrote:
> > On Sunday 13 April 2008 04:11:15 Tejun Heo wrote:
> >> Is auto spindown configured for the drive?
> >
> > I don't think so - it's a 3.5" drive with no special PM features - but
> > how to tell?
>
> Hmm... Can you please post the result of "smartctl --version" and
> "smartctl -a > out 2>&1" and dmesg after the smartctl command?

Yep, pasted and attached below. dmesg is 67k, hope list is happy with that.

Tvrtko

root@sol:~# smartctl --version
smartctl version 5.37 [x86_64-unknown-linux-gnu] Copyright (C) 2002-6 Bruce 
Allen
Home page is http://smartmontools.sourceforge.net/

smartctl comes with ABSOLUTELY NO WARRANTY. This
is free software, and you are welcome to redistribute it
under the terms of the GNU General Public License Version 2.
See http://www.gnu.org for further details.

CVS version IDs of files used to build this code are:
Module: atacmdnames.cpp  revision: 1.15  date: 2006/10/22
  uses: atacmdnames.h    revision: 1.5   date: 2006/04/12
Module: atacmds.cpp      revision: 1.177 date: 2006/10/27
  uses: atacmds.h        revision: 1.83  date: 2006/08/25
  uses: configure.in     revision: 1.122 date: 2006/12/20
  uses: extern.h         revision: 1.47  date: 2006/09/15
  uses: int64.h          revision: 1.16  date: 2006/10/29
  uses: scsiata.h        revision: 1.2   date: 2006/07/01
  uses: utility.h        revision: 1.47  date: 2006/10/09
Module: ataprint.cpp     revision: 1.171 date: 2006/10/28
  uses: atacmdnames.h    revision: 1.5   date: 2006/04/12
  uses: atacmds.h        revision: 1.83  date: 2006/08/25
  uses: ataprint.h       revision: 1.29  date: 2006/09/17
  uses: configure.in     revision: 1.122 date: 2006/12/20
  uses: extern.h         revision: 1.47  date: 2006/09/15
  uses: int64.h          revision: 1.16  date: 2006/10/29
  uses: knowndrives.h    revision: 1.17  date: 2006/08/09
  uses: smartctl.h       revision: 1.24  date: 2006/07/20
  uses: utility.h        revision: 1.47  date: 2006/10/09
Module: knowndrives.cpp  revision: 1.156 date: 2006/10/30
  uses: atacmds.h        revision: 1.83  date: 2006/08/25
  uses: ataprint.h       revision: 1.29  date: 2006/09/17
  uses: configure.in     revision: 1.122 date: 2006/12/20
  uses: extern.h         revision: 1.47  date: 2006/09/15
  uses: int64.h          revision: 1.16  date: 2006/10/29
  uses: knowndrives.h    revision: 1.17  date: 2006/08/09
  uses: utility.h        revision: 1.47  date: 2006/10/09
Module: os_linux.cpp     revision: 1.88  date: 2006/10/25
  uses: atacmds.h        revision: 1.83  date: 2006/08/25
  uses: configure.in     revision: 1.122 date: 2006/12/20
  uses: int64.h          revision: 1.16  date: 2006/10/29
  uses: os_linux.h       revision: 1.25  date: 2006/08/25
  uses: scsicmds.h       revision: 1.63  date: 2006/11/12
  uses: utility.h        revision: 1.47  date: 2006/10/09
Module: scsicmds.cpp     revision: 1.92  date: 2006/11/12
  uses: configure.in     revision: 1.122 date: 2006/12/20
  uses: extern.h         revision: 1.47  date: 2006/09/15
  uses: int64.h          revision: 1.16  date: 2006/10/29
  uses: scsicmds.h       revision: 1.63  date: 2006/11/12
  uses: utility.h        revision: 1.47  date: 2006/10/09
Module: scsiprint.cpp    revision: 1.119 date: 2006/11/12
  uses: configure.in     revision: 1.122 date: 2006/12/20
  uses: extern.h         revision: 1.47  date: 2006/09/15
  uses: int64.h          revision: 1.16  date: 2006/10/29
  uses: scsicmds.h       revision: 1.63  date: 2006/11/12
  uses: scsiprint.h      revision: 1.20  date: 2006/04/12
  uses: smartctl.h       revision: 1.24  date: 2006/07/20
  uses: utility.h        revision: 1.47  date: 2006/10/09
Module: smartctl.cpp     revision: 1.156 date: 2006/10/09
  uses: atacmds.h        revision: 1.83  date: 2006/08/25
  uses: ataprint.h       revision: 1.29  date: 2006/09/17
  uses: configure.in     revision: 1.122 date: 2006/12/20
  uses: extern.h         revision: 1.47  date: 2006/09/15
  uses: int64.h          revision: 1.16  date: 2006/10/29
  uses: knowndrives.h    revision: 1.17  date: 2006/08/09
  uses: scsicmds.h       revision: 1.63  date: 2006/11/12
  uses: scsiprint.h      revision: 1.20  date: 2006/04/12
  uses: smartctl.h       revision: 1.24  date: 2006/07/20
  uses: utility.h        revision: 1.47  date: 2006/10/09
Module: utility.cpp      revision: 1.62  date: 2006/08/09
  uses: configure.in     revision: 1.122 date: 2006/12/20
  uses: int64.h          revision: 1.16  date: 2006/10/29
  uses: utility.h        revision: 1.47  date: 2006/10/09

smartmontools release 5.37 dated 2006/12/20 at 20:37:59 UTC
smartmontools build host: x86_64-unknown-linux-gnu
smartmontools build configured: 2007/09/12 22:04:20 UTC
smartctl compile dated Sep 12 2007 at 22:04:32
smartmontools configure 
arguments:  '--prefix=/usr' '--sysconfdir=/etc' '--mandir=/usr/share/man' '--with-initscriptdir=/etc/init.d' '--with-docdir=/usr/share/doc/smartmontools' 'CFLAGS=-fsigned-char -Wall -O2'



--Boundary-00=_dlEBIoG5qvb6A2M
Content-Type: text/plain;
  charset="utf-8";
  name="out"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="out"

smartctl version 5.37 [x86_64-unknown-linux-gnu] Copyright (C) 2002-6 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Device Model:     WDC WD3200AAKS-00VYA0
Serial Number:    WD-WCARW0059893
Firmware Version: 12.01B02
User Capacity:    320,072,933,376 bytes
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Tue Apr 15 07:18:40 2008 BST
SMART support is: Available - device has SMART capability.
SMART support is: Disabled

Warning! SMART Attribute Data Structure error: invalid SMART checksum.
Warning! SMART Attribute Thresholds Structure error: invalid SMART checksum.
=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED
See vendor-specific Attribute list for marginal Attributes.

General SMART Values:
Offline data collection status:  (0x00)	Offline data collection activity
					was never started.
					Auto Offline Data Collection: Disabled.
Total time to complete Offline 
data collection: 		 (   0) seconds.
Offline data collection
capabilities: 			 (0x00) 	Offline data collection not supported.
SMART capabilities:            (0x55c0)	Does not save SMART data before
					entering power-saving mode.
Error logging capability:        (0x90)	Error logging supported.
					General Purpose Logging supported.

SMART Attributes Data Structure revision number: 0
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
255 Unknown_Attribute       0x40ff   018   149   255    Pre-fail  Always   FAILING_NOW 1099503304802
255 Unknown_Attribute       0x10ff   253   034   255    Pre-fail  Always   FAILING_NOW 1099511627648
 16 Unknown_Attribute       0x0000   000   000   000    Old_age   Offline  FAILING_NOW 537001984
180 Unknown_Attribute       0x0076   129   255   118    Old_age   Always       -       255
 34 Unknown_Attribute       0xff80   255   255   128    Old_age   Offline      -       268501247
 87 Unknown_Attribute       0x0056   129   255   086    Old_age   Always       -       424013611263
255 Unknown_Attribute       0x00ff   000   000   255    Pre-fail  Always   FAILING_NOW 211106232532992
144 Unknown_Attribute       0x0076   129   255   118    Old_age   Always       -       280925807907071
255 Unknown_Attribute       0x00ff   001   016   255    Pre-fail  Always   FAILING_NOW 0
 32 Unknown_Attribute       0x0000   000   000   000    Old_age   Offline  FAILING_NOW 422166540288
255 Unknown_Attribute       0xc0ff   028   083   255    Pre-fail  Always   FAILING_NOW 1099503304787
255 Unknown_Attribute       0x10ff   253   034   255    Pre-fail  Always   FAILING_NOW 1099511627648
 16 Unknown_Attribute       0x0000   000   000   000    Old_age   Offline  FAILING_NOW 537001984
 65 Unknown_Attribute       0x0060   129   255   096    Old_age   Offline      -       255
 34 Unknown_Attribute       0xff80   255   255   128    Old_age   Offline      -       268501247
102 Unknown_Attribute       0x0062   129   255   098    Old_age   Always       -       414351491327
255 Unknown_Attribute       0x00ff   000   000   255    Pre-fail  Always   FAILING_NOW 211106232532992
144 Unknown_Attribute       0x0076   129   255   118    Old_age   Always       -       280925807907071
255 Unknown_Attribute       0x00ff   001   016   255    Pre-fail  Always   FAILING_NOW 0
 32 Unknown_Attribute       0x0000   000   000   000    Old_age   Offline  FAILING_NOW 422619164672
255 Unknown_Attribute       0xc0ff   147   084   255    Pre-fail  Always   FAILING_NOW 1099503304789

Warning! SMART ATA Error Log Structure error: invalid SMART checksum.
SMART Error Log Version: 0
No Errors Logged

Warning! SMART Self-Test Log Structure error: invalid SMART checksum.
SMART Self-test log structure revision number 0
Warning: ATA Specification requires self-test log structure revision number = 1
No self-tests have been logged.  [To run self-tests, use: smartctl -t]


Device does not support Selective Self Tests/Logging

--Boundary-00=_dlEBIoG5qvb6A2M
Content-Type: text/plain;
  charset="utf-8";
  name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg"

[    0.000000] Linux version 2.6.24.3 (tvrtko@sol) (gcc version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #4 SMP PREEMPT Sat Mar 8 12:57:56 GMT 2008
[    0.000000] Command line: root=UUID=5781d9c0-be35-41cc-9eca-64e5d8fffbe4 ro quiet splash
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009e800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000077000000 (usable)
[    0.000000]  BIOS-e820: 0000000077000000 - 000000007f000000 (reserved)
[    0.000000]  BIOS-e820: 000000007f000000 - 000000007fdf0000 (usable)
[    0.000000]  BIOS-e820: 000000007fef0000 - 000000007fef3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007fef3000 - 000000007ff00000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000e2000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] Entering add_active_range(0, 0, 158) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 487424) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 520192, 523760) 2 entries of 256 used
[    0.000000] end_pfn_map = 1048576
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000F6600, 0014 (r0 GBT   )
[    0.000000] ACPI: RSDT 7FEF3040, 0038 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
[    0.000000] ACPI: FACP 7FEF30C0, 0074 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
[    0.000000] ACPI: DSDT 7FEF3180, 52C6 (r1 GBT    GBTUACPI     1000 MSFT  100000C)
[    0.000000] ACPI: FACS 7FEF1800, 0040
[    0.000000] ACPI: HPET 7FEF85C0, 0038 (r1 GBT    GBTUACPI 42302E31 GBTU       98)
[    0.000000] ACPI: MCFG 7FEF8640, 003C (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
[    0.000000] ACPI: APIC 7FEF84C0, 0098 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
[    0.000000] ACPI: SSDT 7FEF8CE0, 02FC (r1  PmRef    CpuPm     3000 INTL 20040311)
[    0.000000] Entering add_active_range(0, 0, 158) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 487424) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 520192, 523760) 2 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0:        0 ->      158
[    0.000000]     0:      256 ->   487424
[    0.000000]     0:   520192 ->   523760
[    0.000000] On node 0 totalpages: 490894
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1031 pages reserved
[    0.000000]   DMA zone: 2911 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7104 pages used for memmap
[    0.000000]   DMA32 zone: 479792 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfeff0000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] swsusp: Registered nosave memory region: 000000000009e000 - 00000000000a0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000f0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000f0000 - 0000000000100000
[    0.000000] swsusp: Registered nosave memory region: 0000000077000000 - 000000007f000000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 7ff00000:60100000)
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 32496 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 482703
[    0.000000] Kernel command line: root=UUID=5781d9c0-be35-41cc-9eca-64e5d8fffbe4 ro quiet splash
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] hpet clockevent registered
[    0.000000] TSC calibrated against HPET
[   16.820956] time.c: Detected 2333.332 MHz processor.
[   16.823422] Console: colour VGA+ 80x25
[   16.823425] console [tty0] enabled
[   16.824597] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[   16.825441] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[   16.825570] Checking aperture...
[   16.840754] Memory: 1922140k/2095040k available (2186k kernel code, 40844k reserved, 1139k data, 220k init)
[   16.840788] SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
[   16.899786] Calibrating delay using timer specific routine.. 4670.28 BogoMIPS (lpj=2335142)
[   16.899807] Security Framework initialized
[   16.899816] Capability LSM initialized
[   16.899825] Mount-cache hash table entries: 256
[   16.899934] CPU: L1 I cache: 32K, L1 D cache: 32K
[   16.899936] CPU: L2 cache: 4096K
[   16.899937] using mwait in idle threads.
[   16.899939] CPU: Physical Processor ID: 0
[   16.899940] CPU: Processor Core ID: 0
[   16.899945] CPU0: Thermal monitoring enabled (TM2)
[   16.899954] SMP alternatives: switching to UP code
[   16.900359] ACPI: Core revision 20070126
[   16.914056] Using local APIC timer interrupts.
[   16.956833] APIC timer calibration result 20833325
[   16.956835] Detected 20.833 MHz APIC timer.
[   16.956909] SMP alternatives: switching to SMP code
[   16.957202] Booting processor 1/2 APIC 0x1
[   16.968700] Initializing CPU#1
[   17.027699] Calibrating delay using timer specific routine.. 4666.63 BogoMIPS (lpj=2333319)
[   17.027704] CPU: L1 I cache: 32K, L1 D cache: 32K
[   17.027706] CPU: L2 cache: 4096K
[   17.027707] CPU: Physical Processor ID: 0
[   17.027708] CPU: Processor Core ID: 1
[   17.027713] CPU1: Thermal monitoring enabled (TM2)
[   17.028112] Intel(R) Core(TM)2 Duo CPU     E6550  @ 2.33GHz stepping 0b
[   17.028165] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[   17.048145] Brought up 2 CPUs
[   17.048324] net_namespace: 120 bytes
[   17.048570] NET: Registered protocol family 16
[   17.048685] ACPI: bus type pci registered
[   17.049815] PCI: Using MMCONFIG at e0000000 - e1ffffff
[   17.050287] mtrr: your CPUs had inconsistent fixed MTRR settings
[   17.050288] mtrr: probably your BIOS does not setup all CPUs.
[   17.050289] mtrr: corrected configuration.
[   17.051277] ACPI: EC: Look up EC in DSDT
[   17.055694] ACPI: Interpreter enabled
[   17.055696] ACPI: (supports S0 S1 S4 S5)
[   17.055707] ACPI: Using IOAPIC for interrupt routing
[   17.062136] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   17.063245] PCI: Transparent bridge - 0000:00:0a.0
[   17.063381] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   17.063556] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[   17.102749] ACPI: PCI Interrupt Link [LNK1] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[   17.102871] ACPI: PCI Interrupt Link [LNK2] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[   17.102992] ACPI: PCI Interrupt Link [LNK3] (IRQs 5 7 9 *10 11 14 15)
[   17.103111] ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[   17.103230] ACPI: PCI Interrupt Link [LNK5] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[   17.103348] ACPI: PCI Interrupt Link [LNK6] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[   17.103467] ACPI: PCI Interrupt Link [LNK7] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[   17.103587] ACPI: PCI Interrupt Link [LNK8] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[   17.103707] ACPI: PCI Interrupt Link [LP2P] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[   17.103826] ACPI: PCI Interrupt Link [LIGP] (IRQs *5 7 9 10 11 14 15)
[   17.103945] ACPI: PCI Interrupt Link [LUBA] (IRQs 5 7 9 10 *11 14 15)
[   17.104064] ACPI: PCI Interrupt Link [LUB2] (IRQs *5 7 9 10 11 14 15)
[   17.104187] ACPI: PCI Interrupt Link [LU1B] (IRQs 5 7 9 10 11 14 15) *0
[   17.104306] ACPI: PCI Interrupt Link [LU2B] (IRQs 5 7 9 10 11 14 15) *0
[   17.104426] ACPI: PCI Interrupt Link [LMAC] (IRQs 5 7 9 10 11 14 *15)
[   17.104545] ACPI: PCI Interrupt Link [LAZA] (IRQs 5 7 9 10 *11 14 15)
[   17.104668] ACPI: PCI Interrupt Link [LPMU] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[   17.104788] ACPI: PCI Interrupt Link [LSMB] (IRQs 5 7 9 *10 11 14 15)
[   17.104910] ACPI: PCI Interrupt Link [LIDE] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[   17.105032] ACPI: PCI Interrupt Link [LSID] (IRQs 5 7 9 10 *11 14 15)
[   17.105182] ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
[   17.105325] ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0, disabled.
[   17.105467] ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0
[   17.105612] ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
[   17.105754] ACPI: PCI Interrupt Link [APC5] (IRQs 16) *0, disabled.
[   17.105895] ACPI: PCI Interrupt Link [APC6] (IRQs 16) *0, disabled.
[   17.106037] ACPI: PCI Interrupt Link [APC7] (IRQs 16) *0, disabled.
[   17.106178] ACPI: PCI Interrupt Link [APC8] (IRQs 16) *0, disabled.
[   17.106320] ACPI: PCI Interrupt Link [AIGP] (IRQs 20 21 22 23) *0
[   17.106462] ACPI: PCI Interrupt Link [AUBA] (IRQs 20 21 22 23) *0
[   17.106607] ACPI: PCI Interrupt Link [AUB2] (IRQs 20 21 22 23) *0
[   17.106750] ACPI: PCI Interrupt Link [AU1B] (IRQs 20 21 22 23) *0
[   17.106892] ACPI: PCI Interrupt Link [AU2B] (IRQs 20 21 22 23) *0
[   17.107035] ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
[   17.107178] ACPI: PCI Interrupt Link [APMU] (IRQs 20 21 22 23) *0, disabled.
[   17.107321] ACPI: PCI Interrupt Link [AAZA] (IRQs 20 21 22 23) *0
[   17.107463] ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0
[   17.107607] ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22 23) *0, disabled.
[   17.107751] ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
[   17.107895] ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0
[   17.107988] Linux Plug and Play Support v0.97 (c) Adam Belay
[   17.108007] pnp: PnP ACPI init
[   17.108014] ACPI: bus type pnp registered
[   17.111200] pnp: PnP ACPI: found 12 devices
[   17.111202] ACPI: ACPI bus type pnp unregistered
[   17.111332] PCI: Using ACPI for IRQ routing
[   17.111334] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   17.114602] PCI-GART: No AMD northbridge found.
[   17.114609] hpet0: at MMIO 0xfeff0000, IRQs 2, 8, 31
[   17.114612] hpet0: 3 32-bit timers, 25000000 Hz
[   17.116602] Time: tsc clocksource has been installed.
[   17.118665] system 00:01: ioport range 0x1000-0x107f has been reserved
[   17.118668] system 00:01: ioport range 0x1080-0x10ff has been reserved
[   17.118670] system 00:01: ioport range 0x1400-0x147f has been reserved
[   17.118672] system 00:01: ioport range 0x1480-0x14ff has been reserved
[   17.118674] system 00:01: ioport range 0x1800-0x187f has been reserved
[   17.118676] system 00:01: ioport range 0x1880-0x18ff has been reserved
[   17.118678] system 00:01: iomem range 0x0-0x0 could not be reserved
[   17.118681] system 00:01: iomem range 0xfefe0000-0xfefe01ff has been reserved
[   17.118683] system 00:01: iomem range 0xfefe1000-0xfefe10ff has been reserved
[   17.118685] system 00:01: iomem range 0x77000000-0x7effffff could not be reserved
[   17.118690] system 00:02: ioport range 0x4d0-0x4d1 has been reserved
[   17.118692] system 00:02: ioport range 0x800-0x87f has been reserved
[   17.118694] system 00:02: ioport range 0x295-0x314 has been reserved
[   17.118696] system 00:02: ioport range 0x290-0x294 has been reserved
[   17.118698] system 00:02: ioport range 0x880-0x88f has been reserved
[   17.118705] system 00:0a: iomem range 0xe0000000-0xe1ffffff could not be reserved
[   17.118710] system 00:0b: iomem range 0xd0000-0xd3fff has been reserved
[   17.118712] system 00:0b: iomem range 0xd6800-0xd7fff has been reserved
[   17.118714] system 00:0b: iomem range 0xf0000-0xfbfff could not be reserved
[   17.118716] system 00:0b: iomem range 0xfc000-0xfffff could not be reserved
[   17.118718] system 00:0b: iomem range 0x7fef0000-0x7fefffff could not be reserved
[   17.118721] system 00:0b: iomem range 0xffff0000-0xffffffff has been reserved
[   17.118723] system 00:0b: iomem range 0x0-0x9ffff could not be reserved
[   17.118725] system 00:0b: iomem range 0x100000-0x7feeffff could not be reserved
[   17.118727] system 00:0b: iomem range 0xfec00000-0xfec00fff has been reserved
[   17.118729] system 00:0b: iomem range 0xfee00000-0xfee00fff could not be reserved
[   17.119012] PCI: Bridge: 0000:00:0a.0
[   17.119013]   IO window: disabled.
[   17.119016]   MEM window: e5000000-e50fffff
[   17.119017]   PREFETCH window: disabled.
[   17.119019] PCI: Bridge: 0000:00:0b.0
[   17.119020]   IO window: 9000-9fff
[   17.119022]   MEM window: disabled.
[   17.119023]   PREFETCH window: disabled.
[   17.119024] PCI: Bridge: 0000:00:0c.0
[   17.119025]   IO window: b000-bfff
[   17.119027]   MEM window: disabled.
[   17.119028]   PREFETCH window: disabled.
[   17.119029] PCI: Bridge: 0000:00:0d.0
[   17.119031]   IO window: a000-afff
[   17.119032]   MEM window: disabled.
[   17.119033]   PREFETCH window: disabled.
[   17.119038] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   17.119043] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   17.119047] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   17.119051] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   17.119057] NET: Registered protocol family 2
[   17.127833] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[   17.128068] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[   17.129443] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[   17.130010] TCP: Hash tables configured (established 262144 bind 65536)
[   17.130012] TCP reno registered
[   17.132985] checking if image is initramfs... it is
[   17.380845] Switched to high resolution mode on CPU 1
[   17.381362] Switched to high resolution mode on CPU 0
[   17.498896] Freeing initrd memory: 4812k freed
[   17.503068] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[   17.503072] io scheduler noop registered
[   17.503073] io scheduler anticipatory registered
[   17.503075] io scheduler deadline registered
[   17.503140] io scheduler cfq registered (default)
[   17.520284] Boot video device is 0000:00:10.0
[   17.520397] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   17.520409] assign_interrupt_mode Found MSI capability
[   17.520420] Allocate Port Service[0000:00:0b.0:pcie00]
[   17.520445] Allocate Port Service[0000:00:0b.0:pcie03]
[   17.520480] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   17.520491] assign_interrupt_mode Found MSI capability
[   17.520499] Allocate Port Service[0000:00:0c.0:pcie00]
[   17.520522] Allocate Port Service[0000:00:0c.0:pcie03]
[   17.520557] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   17.520567] assign_interrupt_mode Found MSI capability
[   17.520576] Allocate Port Service[0000:00:0d.0:pcie00]
[   17.520599] Allocate Port Service[0000:00:0d.0:pcie03]
[   17.522164] Real Time Clock Driver v1.12ac
[   17.522286] hpet_resources: 0xfeff0000 is busy
[   17.522307] Linux agpgart interface v0.102
[   17.522309] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[   17.522403] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   17.522717] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   17.523188] RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
[   17.523272] PNP: No PS/2 controller found. Probing ports directly.
[   17.523591] serio: i8042 KBD port at 0x60,0x64 irq 1
[   17.523594] serio: i8042 AUX port at 0x60,0x64 irq 12
[   17.523661] mice: PS/2 mouse device common for all mice
[   17.523691] cpuidle: using governor ladder
[   17.523693] cpuidle: using governor menu
[   17.523745] TCP cubic registered
[   17.523782] NET: Registered protocol family 1
[   17.523871] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[   17.523877] Freeing unused kernel memory: 220k freed
[   18.634348] fuse init (API version 7.9)
[   18.639655] ACPI: SSDT 7FEF86C0, 022A (r1  PmRef  Cpu0Ist     3000 INTL 20040311)
[   18.639897] ACPI: SSDT 7FEF8B80, 0152 (r1  PmRef  Cpu1Ist     3000 INTL 20040311)
[   18.640037] ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor Device is not present [20070126]
[   18.640045] ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor Device is not present [20070126]
[   18.790788] usbcore: registered new interface driver usbfs
[   18.790808] usbcore: registered new interface driver hub
[   18.791177] usbcore: registered new device driver usb
[   18.792065] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[   18.792355] ACPI: PCI Interrupt Link [AUBA] enabled at IRQ 23
[   18.792362] ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [AUBA] -> GSI 23 (level, low) -> IRQ 23
[   18.793664] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   18.793669] ohci_hcd 0000:00:04.0: OHCI Host Controller
[   18.793766] ohci_hcd 0000:00:04.0: new USB bus registered, assigned bus number 1
[   18.793780] ohci_hcd 0000:00:04.0: irq 23, io mem 0xe5108000
[   18.821728] SCSI subsystem initialized
[   18.837738] libata version 3.00 loaded.
[   18.846547] usb usb1: configuration #1 chosen from 1 choice
[   18.846565] hub 1-0:1.0: USB hub found
[   18.846570] hub 1-0:1.0: 10 ports detected
[   18.947629] ACPI: PCI Interrupt Link [AUB2] enabled at IRQ 22
[   18.947635] ACPI: PCI Interrupt 0000:00:04.1[B] -> Link [AUB2] -> GSI 22 (level, low) -> IRQ 22
[   18.948717] PCI: Setting latency timer of device 0000:00:04.1 to 64
[   18.948721] ehci_hcd 0000:00:04.1: EHCI Host Controller
[   18.948764] ehci_hcd 0000:00:04.1: new USB bus registered, assigned bus number 2
[   18.948788] ehci_hcd 0000:00:04.1: debug port 1
[   18.948790] PCI: cache line size of 32 is not supported by device 0000:00:04.1
[   18.948800] ehci_hcd 0000:00:04.1: irq 22, io mem 0xe5107000
[   18.954250] ehci_hcd 0000:00:04.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   18.954338] usb usb2: configuration #1 chosen from 1 choice
[   18.954357] hub 2-0:1.0: USB hub found
[   18.954362] hub 2-0:1.0: 10 ports detected
[   19.055568] ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
[   19.055573] ACPI: PCI Interrupt 0000:01:07.0[A] -> Link [APC3] -> GSI 18 (level, low) -> IRQ 18
[   19.111977] firewire_ohci: Added fw-ohci device 0000:01:07.0, OHCI version 1.10
[   19.112013] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
[   19.112301] ACPI: PCI Interrupt Link [APCH] enabled at IRQ 21
[   19.112306] ACPI: PCI Interrupt 0000:00:0f.0[A] -> Link [APCH] -> GSI 21 (level, low) -> IRQ 21
[   19.112310] PCI: Setting latency timer of device 0000:00:0f.0 to 64
[   19.493288] usb 1-2: new low speed USB device using ohci_hcd and address 2
[   19.611111] firewire_core: created new fw device fw0 (0 config rom retries, S400)
[   19.624655] forcedeth 0000:00:0f.0: ifname eth0, PHY OUI 0x732 @ 1, addr 00:1a:4d:59:db:59
[   19.624658] forcedeth 0000:00:0f.0: highdma pwrctl mgmt timirq gbit lnktim msi desc-v3
[   19.626547] ahci 0000:00:0e.0: version 3.0
[   19.626791] ACPI: PCI Interrupt Link [APSI] enabled at IRQ 20
[   19.626795] ACPI: PCI Interrupt 0000:00:0e.0[A] -> Link [APSI] -> GSI 20 (level, low) -> IRQ 20
[   19.628233] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   19.628238] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[   19.684889] usb 1-2: configuration #1 chosen from 1 choice
[   19.695856] usbcore: registered new interface driver hiddev
[   19.702000] input: BTC USB Multimedia Cordless Kit   as /class/input/input0
[   19.706904] input: USB HID v1.00 Keyboard [BTC USB Multimedia Cordless Kit  ] on usb-0000:00:04.0-2
[   19.720252] input: BTC USB Multimedia Cordless Kit   as /class/input/input1
[   19.725902] input,hiddev96: USB HID v1.00 Mouse [BTC USB Multimedia Cordless Kit  ] on usb-0000:00:04.0-2
[   19.725911] usbcore: registered new interface driver usbhid
[   19.725913] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   20.626248] ahci 0000:00:0e.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[   20.626252] ahci 0000:00:0e.0: flags: 64bit sntf led clo pmp pio 
[   20.626254] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   20.626509] scsi0 : ahci
[   20.626630] scsi1 : ahci
[   20.626723] scsi2 : ahci
[   20.626814] scsi3 : ahci
[   20.626877] ata1: SATA max UDMA/133 abar m8192@0xe5104000 port 0xe5104100 irq 316
[   20.626879] ata2: SATA max UDMA/133 abar m8192@0xe5104000 port 0xe5104180 irq 316
[   20.626880] ata3: SATA max UDMA/133 abar m8192@0xe5104000 port 0xe5104200 irq 316
[   20.626882] ata4: SATA max UDMA/133 abar m8192@0xe5104000 port 0xe5104280 irq 316
[   20.930694] ata1: SATA link down (SStatus 0 SControl 300)
[   21.538595] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   21.555434] ata2.00: ATA-8: WDC WD3200AAKS-00VYA0, 12.01B02, max UDMA/133
[   21.555437] ata2.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 0/32)
[   21.556174] ata2.00: configured for UDMA/133
[   22.163469] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   22.164555] ata3.00: ATAPI: TSSTcorp CDDVDW SH-S203N, SB01, max UDMA/100, ATAPI AN
[   22.316045] ata3.00: configured for UDMA/100
[   22.619646] ata4: SATA link down (SStatus 0 SControl 300)
[   22.619728] scsi 1:0:0:0: Direct-Access     ATA      WDC WD3200AAKS-0 12.0 PQ: 0 ANSI: 5
[   22.620347] scsi 2:0:0:0: CD-ROM            TSSTcorp CDDVDW SH-S203N  SB01 PQ: 0 ANSI: 5
[   22.620424] NFORCE-MCP73: IDE controller (0x10de:0x056c rev 0xa1) at  PCI slot 0000:00:08.0
[   22.620444] NFORCE-MCP73: not 100% native mode: will probe irqs later
[   22.620449] NFORCE-MCP73: 0000:00:08.0 (rev a1) UDMA133 controller
[   22.620453]     ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:DMA, hdb:DMA
[   22.620458] NFORCE-MCP73: IDE port disabled
[   22.620461] Probing IDE interface ide0...
[   22.625484] Driver 'sd' needs updating - please use bus_type methods
[   22.625529] sd 1:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
[   22.625537] sd 1:0:0:0: [sda] Write Protect is off
[   22.625539] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   22.625550] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   22.625580] sd 1:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
[   22.625586] sd 1:0:0:0: [sda] Write Protect is off
[   22.625588] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   22.625599] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   22.625601]  sda: sda1 sda2 sda3 sda4 <<4>Driver 'sr' needs updating - please use bus_type methods
[   22.633148]  sda5 sda6 sda7 sda8 sda9 >
[   22.659350] sd 1:0:0:0: [sda] Attached SCSI disk
[   22.661687] sd 1:0:0:0: Attached scsi generic sg0 type 0
[   22.661701] sr 2:0:0:0: Attached scsi generic sg1 type 5
[   22.665172] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[   22.665174] Uniform CD-ROM driver Revision: 3.20
[   22.665204] sr 2:0:0:0: Attached scsi CD-ROM sr0
[   22.992032] Attempting manual resume
[   22.992034] swsusp: Resume From Partition 8:2
[   22.992035] PM: Checking swsusp image.
[   22.992146] PM: Resume from disk failed.
[   22.995770] JFS: nTxBlock = 8192, nTxLock = 65536
[   27.244643] input: Power Button (FF) as /class/input/input2
[   27.257283] ACPI: Power Button (FF) [PWRF]
[   27.257319] input: Power Button (CM) as /class/input/input3
[   27.273257] ACPI: Power Button (CM) [PWRB]
[   27.812316] nvidia: module license 'NVIDIA' taints kernel.
[   27.842200] input: PC Speaker as /class/input/input4
[   27.980345] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 23
[   27.980349] ACPI: PCI Interrupt 0000:00:09.0[A] -> Link [AAZA] -> GSI 23 (level, low) -> IRQ 23
[   27.981263] PCI: Setting latency timer of device 0000:00:09.0 to 64
[   28.112692] ACPI: PCI Interrupt Link [AIGP] enabled at IRQ 22
[   28.112695] ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [AIGP] -> GSI 22 (level, low) -> IRQ 22
[   28.112701] PCI: Setting latency timer of device 0000:00:10.0 to 64
[   28.112841] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  169.12  Thu Feb 14 17:51:09 PST 2008
[   29.130156] it87: Found IT8718F chip at 0x290, revision 4
[   29.130167] it87: in3 is VCC (+5V)
[   29.134510] coretemp coretemp.0: Using undocumented features, absolute temperature might be wrong!
[   29.134541] coretemp coretemp.1: Using undocumented features, absolute temperature might be wrong!
[   29.181796] Adding 2000084k swap on /dev/sda2.  Priority:-1 extents:1 across:2000084k
[   29.643543] device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised: dm-devel@redhat.com
[   30.271222] kjournald starting.  Commit interval 5 seconds
[   30.279044] EXT3 FS on sda1, internal journal
[   30.279048] EXT3-fs: mounted filesystem with ordered data mode.
[   31.709918] No dock devices found.
[   34.487709] NET: Registered protocol family 10
[   34.487889] lo: Disabled Privacy Extensions
[   42.687068] Bluetooth: Core ver 2.11
[   42.687265] NET: Registered protocol family 31
[   42.687268] Bluetooth: HCI device and connection manager initialized
[   42.687270] Bluetooth: HCI socket layer initialized
[   42.694447] Bluetooth: L2CAP ver 2.9
[   42.694452] Bluetooth: L2CAP socket layer initialized
[   42.697192] Bluetooth: RFCOMM socket layer initialized
[   42.697205] Bluetooth: RFCOMM TTY layer initialized
[   42.697206] Bluetooth: RFCOMM ver 1.8
[   43.081739] [4864]: VMCI: Driver initialized.
[   43.081763] [4864]: Module vmmon: registered with major=10 minor=165
[   43.081772] [4864]: Module vmmon: initialized
[   43.165373] /dev/vmnet: open called by PID 4887 (vmnet-bridge)
[   43.165379] /dev/vmnet: hub 0 does not exist, allocating memory.
[   43.165387] /dev/vmnet: port on hub 0 successfully opened
[   43.165398] bridge-eth0: enabling the bridge
[   43.165401] bridge-eth0: up
[   43.165402] bridge-eth0: already up
[   43.165403] bridge-eth0: attached
[   43.190584] /dev/vmnet: open called by PID 4893 (vmnet-netifup)
[   43.190591] /dev/vmnet: hub 1 does not exist, allocating memory.
[   43.190599] /dev/vmnet: port on hub 1 successfully opened
[   43.202172] /dev/vmnet: open called by PID 4909 (vmnet-netifup)
[   43.202256] /dev/vmnet: hub 8 does not exist, allocating memory.
[   43.202331] /dev/vmnet: port on hub 8 successfully opened
[   43.243718] /dev/vmnet: open called by PID 4917 (vmnet-natd)
[   43.243728] /dev/vmnet: port on hub 8 successfully opened
[   43.343152] /dev/vmnet: open called by PID 4924 (vmnet-dhcpd)
[   43.343160] /dev/vmnet: port on hub 8 successfully opened
[   43.362568] /dev/vmnet: open called by PID 4925 (vmnet-dhcpd)
[   43.362574] /dev/vmnet: port on hub 1 successfully opened
[   46.943492] NET: Registered protocol family 17
[   53.601567] vmnet1: no IPv6 routers present
[   53.763505] vmnet8: no IPv6 routers present
[   61.686093] eth0: no IPv6 routers present
[17030.737907]  CIFS VFS: cifs_mount failed w/return code = -13
[17065.594524]  CIFS VFS: cifs_mount failed w/return code = -13
[17118.163561]  CIFS VFS: cifs_mount failed w/return code = -13
[17131.624947]  CIFS VFS: cifs_mount failed w/return code = -13
[17153.254275]  CIFS VFS: cifs_mount failed w/return code = -13
[17179.473085]  CIFS VFS: cifs_mount failed w/return code = -13
[17216.154587]  CIFS VFS: cifs_mount failed w/return code = -13
[26924.992029] bridge-eth0: disabling the bridge
[26924.997939] bridge-eth0: down
[26925.183366] ACPI: PCI interrupt for device 0000:00:0f.0 disabled
[26926.732844] PM: suspend-to-disk mode set to 'shutdown'
[26926.732990] swsusp: Marking nosave pages: 000000000009e000 - 0000000000100000
[26926.732995] swsusp: Marking nosave pages: 0000000077000000 - 000000007f000000
[26926.733716] swsusp: Basic memory bitmaps created
[26926.733717] Syncing filesystems ... done.
[26926.762925] Freezing user space processes ... (elapsed 0.00 seconds) done.
[26926.763241] Freezing remaining freezable tasks ... (elapsed 1.59 seconds) done.
[26928.358493] Shrinking memory...  -\|/-\|/-\|/-\|/-\|done (253770 pages freed)
[26930.721021] Freed 1015080 kbytes in 2.36 seconds (430.11 MB/s)
[26930.721023] Suspending console(s)
[26930.921337] sd 1:0:0:0: [sda] Synchronizing SCSI cache
[26930.923012] ACPI handle has no context!
[26930.923241] serial 00:08: disabled
[26930.923277] ACPI handle has no context!
[26930.933325] NVRM: RmPowerManagement: 3
[26931.125955] ACPI: PCI interrupt for device 0000:00:09.0 disabled
[26931.137023] ACPI: PCI interrupt for device 0000:00:04.1 disabled
[26931.147924] ACPI: PCI interrupt for device 0000:00:04.0 disabled
[26931.159324] Disabling non-boot CPUs ...
[26931.264679] CPU 1 is now offline
[26931.264682] SMP alternatives: switching to UP code
[26931.265774] CPU1 is down
[26931.265914] swsusp: critical section: 
[26931.303274] swsusp: Need to copy 120439 pages
[26931.303276] swsusp: Normal pages needed: 120439 + 1024 + 38, available pages: 370448
[   29.894092] Enabling non-boot CPUs ...
[   29.896483] SMP alternatives: switching to SMP code
[   29.897234] Booting processor 1/2 APIC 0x1
[   29.907581] Initializing CPU#1
[   29.967281] Calibrating delay using timer specific routine.. 4666.93 BogoMIPS (lpj=2333466)
[   29.967286] CPU: L1 I cache: 32K, L1 D cache: 32K
[   29.967288] CPU: L2 cache: 4096K
[   29.967290] CPU: Physical Processor ID: 0
[   29.967290] CPU: Processor Core ID: 1
[   29.967687] Intel(R) Core(TM)2 Duo CPU     E6550  @ 2.33GHz stepping 0b
[   29.967729] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[   29.987961] CPU1 is up
[   29.988711] Switched to high resolution mode on CPU 1
[   29.999272] PCI: Enabling device 0000:00:04.0 (0000 -> 0002)
[   29.999276] ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [AUBA] -> GSI 23 (level, low) -> IRQ 23
[   29.999280] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   29.999285] PM: Writing back config space on device 0000:00:04.0 at offset f (was 1030100, writing 103010b)
[   29.999291] PM: Writing back config space on device 0000:00:04.0 at offset 4 (was 0, writing e5108000)
[   29.999295] PM: Writing back config space on device 0000:00:04.0 at offset 1 (was b00006, writing b00007)
[   30.010216] ACPI: PCI Interrupt 0000:00:04.1[B] -> Link [AUB2] -> GSI 22 (level, low) -> IRQ 22
[   30.010219] PCI: Setting latency timer of device 0000:00:04.1 to 64
[   30.010234] usb usb2: root hub lost power or was reset
[   30.010241] ehci_hcd 0000:00:04.1: debug port 1
[   30.010243] PCI: cache line size of 32 is not supported by device 0000:00:04.1
[   30.021244] PM: Writing back config space on device 0000:00:09.0 at offset 1 (was b00006, writing b00002)
[   30.021251] ACPI: PCI Interrupt 0000:00:09.0[A] -> Link [AAZA] -> GSI 23 (level, low) -> IRQ 23
[   30.021255] PCI: Setting latency timer of device 0000:00:09.0 to 64
[   30.021274] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   30.021286] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   30.021299] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   30.021310] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   30.021319] PM: Writing back config space on device 0000:00:0e.0 at offset 1 (was b00403, writing b00407)
[   30.021329] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   30.021348] PM: Writing back config space on device 0000:00:0f.0 at offset 1 (was b00007, writing b00003)
[   30.021366] NVRM: RmPowerManagement: 5
[   30.166955] PM: Writing back config space on device 0000:01:07.0 at offset f (was 4020100, writing 402010a)
[   30.166966] PM: Writing back config space on device 0000:01:07.0 at offset 5 (was 0, writing e5000000)
[   30.166970] PM: Writing back config space on device 0000:01:07.0 at offset 4 (was 0, writing e5004000)
[   30.166973] PM: Writing back config space on device 0000:01:07.0 at offset 3 (was 0, writing 2008)
[   30.166977] PM: Writing back config space on device 0000:01:07.0 at offset 1 (was 2100000, writing 2100006)
[   30.224505] serial 00:08: activated
[   30.276707] usb usb1: root hub lost power or was reset
[   30.325606] ata1: SATA link down (SStatus 0 SControl 300)
[   30.325616] ata4: SATA link down (SStatus 0 SControl 300)
[   30.527227] sd 1:0:0:0: [sda] Starting disk
[   30.629024] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   30.629052] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   30.637718] ata2.00: configured for UDMA/133
[   30.641379] sd 1:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
[   30.641389] sd 1:0:0:0: [sda] Write Protect is off
[   30.641391] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   30.641405] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   30.641453] PM: Image restored successfully.
[   30.673355] Restarting tasks ... <6>usb 1-2: USB disconnect, address 2
[   30.674179] done.
[   30.675193] swsusp: Basic memory bitmaps freed
[   30.932285] ata3.00: configured for UDMA/100
[   31.206916] usb 1-2: new low speed USB device using ohci_hcd and address 3
[   31.398590] usb 1-2: configuration #1 chosen from 1 choice
[   31.412711] input: BTC USB Multimedia Cordless Kit   as /class/input/input5
[   31.419523] input: USB HID v1.00 Keyboard [BTC USB Multimedia Cordless Kit  ] on usb-0000:00:04.0-2
[   31.432992] input: BTC USB Multimedia Cordless Kit   as /class/input/input6
[   31.442602] input,hiddev96: USB HID v1.00 Mouse [BTC USB Multimedia Cordless Kit  ] on usb-0000:00:04.0-2
[   34.856002] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
[   34.856026] ACPI: PCI Interrupt 0000:00:0f.0[A] -> Link [APCH] -> GSI 21 (level, low) -> IRQ 21
[   34.856031] PCI: Setting latency timer of device 0000:00:0f.0 to 64
[   35.367877] forcedeth 0000:00:0f.0: ifname eth0, PHY OUI 0x732 @ 1, addr 00:1a:4d:59:db:59
[   35.367883] forcedeth 0000:00:0f.0: highdma pwrctl mgmt timirq gbit lnktim msi desc-v3
[   35.579445] eth0: no link during initialization.
[   35.583296] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   35.583299] bridge-eth0: enabling the bridge
[   35.583302] bridge-eth0: up
[   36.542758] eth0: link up.
[   36.545859] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   38.064439] input: Power Button (FF) as /class/input/input7
[   38.071816] ACPI: Power Button (FF) [PWRF]
[   38.071859] input: Power Button (CM) as /class/input/input8
[   38.083678] ACPI: Power Button (CM) [PWRB]
[   55.662103] eth0: no IPv6 routers present
[  376.174004]  CIFS VFS: No response for cmd 50 mid 31713
[ 7786.218334] npviewer.bin[24121]: segfault at 1 rip f7a7baf7 rsp ffe3bf44 error 4
[24893.254516] npviewer.bin[29513]: segfault at f77c85de rip f7aaa0ed rsp ffb90540 error 7
[24893.254519] npviewer.bin[29530]: segfault at f77c85de rip f7aaa0ed rsp f5b70d80 error 7
[25078.778898] npviewer.bin[29705]: segfault at f77c8599 rip f7aaa0ed rsp f5b70d80 error 7
[25078.778902] npviewer.bin[29688]: segfault at f77c8599 rip f7aaa0ed rsp ffa003b0 error 7
[25478.360380] npviewer.bin[30026]: segfault at f77505c9 rip f7a51745 rsp f52f7cc0 error 7
[25478.360383] npviewer.bin[29991]: segfault at f77505c9 rip f7a51745 rsp ff89c180 error 7
[27243.199530] sr0: CDROM not ready yet.
[27245.238219] sr0: CDROM not ready yet.
[27247.255134] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27248.256161] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27249.256204] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27250.256268] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27251.256385] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27252.256483] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27253.256531] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27254.256633] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27255.256725] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27256.256822] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27257.256873] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27258.256958] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27259.257047] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27260.257133] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27261.257244] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27262.257314] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27263.257382] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27264.257498] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27265.257582] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27266.257640] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27267.257755] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27268.257843] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27269.257895] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27270.258008] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27271.258101] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27272.258152] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27273.258251] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27274.258347] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27275.258413] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27276.258520] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27277.258618] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27278.258668] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27279.258971] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27280.157397] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27280.258904] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27281.258931] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27282.259034] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27283.259094] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27284.259180] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27285.259307] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27286.259386] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27287.259480] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27288.259525] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27289.259612] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27290.259940] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27291.259821] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27292.259898] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27293.296230] sr0: CDROM not ready yet.
[27295.334928] sr0: CDROM not ready yet.
[27297.373590] sr0: CDROM not ready yet.
[27299.412293] sr0: CDROM not ready yet.
[27301.450981] sr0: CDROM not ready yet.
[27304.623771] end_request: I/O error, dev sr0, sector 0
[27304.623776] Buffer I/O error on device sr0, logical block 0
[27304.623780] Buffer I/O error on device sr0, logical block 1
[27304.623783] Buffer I/O error on device sr0, logical block 2
[27304.623785] Buffer I/O error on device sr0, logical block 3
[27304.623787] Buffer I/O error on device sr0, logical block 4
[27304.623790] Buffer I/O error on device sr0, logical block 5
[27304.623792] Buffer I/O error on device sr0, logical block 6
[27304.623795] Buffer I/O error on device sr0, logical block 7
[27304.625137] end_request: I/O error, dev sr0, sector 0
[27304.625140] Buffer I/O error on device sr0, logical block 0
[27304.626513] end_request: I/O error, dev sr0, sector 4
[27304.626516] Buffer I/O error on device sr0, logical block 1
[27304.627883] end_request: I/O error, dev sr0, sector 0
[27304.629261] end_request: I/O error, dev sr0, sector 4
[27304.630634] end_request: I/O error, dev sr0, sector 0
[27304.632012] end_request: I/O error, dev sr0, sector 4
[27304.633384] end_request: I/O error, dev sr0, sector 0
[27304.634763] end_request: I/O error, dev sr0, sector 4
[27304.636136] end_request: I/O error, dev sr0, sector 0
[27304.638103] end_request: I/O error, dev sr0, sector 4
[27304.639478] end_request: I/O error, dev sr0, sector 0
[27304.640856] end_request: I/O error, dev sr0, sector 4
[27304.642230] end_request: I/O error, dev sr0, sector 0
[27304.643610] end_request: I/O error, dev sr0, sector 4
[27304.644983] end_request: I/O error, dev sr0, sector 0
[27304.646362] end_request: I/O error, dev sr0, sector 4
[27304.647736] end_request: I/O error, dev sr0, sector 0
[27304.649115] end_request: I/O error, dev sr0, sector 4
[27304.650489] end_request: I/O error, dev sr0, sector 0
[27304.651866] end_request: I/O error, dev sr0, sector 4
[27304.653242] end_request: I/O error, dev sr0, sector 0
[27304.654621] end_request: I/O error, dev sr0, sector 4
[27304.655994] end_request: I/O error, dev sr0, sector 0
[27304.657373] end_request: I/O error, dev sr0, sector 4
[27304.659338] end_request: I/O error, dev sr0, sector 0
[27304.660715] end_request: I/O error, dev sr0, sector 4
[27304.662091] end_request: I/O error, dev sr0, sector 0
[27304.663468] end_request: I/O error, dev sr0, sector 4
[27304.664844] end_request: I/O error, dev sr0, sector 0
[27304.666220] end_request: I/O error, dev sr0, sector 4
[27304.667597] end_request: I/O error, dev sr0, sector 0
[27304.668973] end_request: I/O error, dev sr0, sector 4
[27304.670350] end_request: I/O error, dev sr0, sector 0
[27304.671727] end_request: I/O error, dev sr0, sector 4
[27304.673103] end_request: I/O error, dev sr0, sector 0
[27304.674479] end_request: I/O error, dev sr0, sector 4
[27304.675855] end_request: I/O error, dev sr0, sector 0
[27304.677232] end_request: I/O error, dev sr0, sector 4
[27304.678608] end_request: I/O error, dev sr0, sector 0
[27304.680574] end_request: I/O error, dev sr0, sector 4
[27304.681948] end_request: I/O error, dev sr0, sector 0
[27304.683327] end_request: I/O error, dev sr0, sector 4
[27304.684701] end_request: I/O error, dev sr0, sector 0
[27304.686080] end_request: I/O error, dev sr0, sector 4
[27304.687455] end_request: I/O error, dev sr0, sector 0
[27304.688832] end_request: I/O error, dev sr0, sector 4
[27304.690206] end_request: I/O error, dev sr0, sector 0
[27304.691586] end_request: I/O error, dev sr0, sector 4
[27304.692959] end_request: I/O error, dev sr0, sector 0
[27304.694338] end_request: I/O error, dev sr0, sector 4
[27304.695712] end_request: I/O error, dev sr0, sector 0
[27304.697091] end_request: I/O error, dev sr0, sector 4
[27304.698465] end_request: I/O error, dev sr0, sector 0
[27304.699844] end_request: I/O error, dev sr0, sector 4
[27304.827167] end_request: I/O error, dev sr0, sector 0
[27304.829133] end_request: I/O error, dev sr0, sector 4
[27304.830507] end_request: I/O error, dev sr0, sector 0
[27304.831886] end_request: I/O error, dev sr0, sector 4
[27633.478052] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
[27633.478061] ata3.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[27633.478062]          cdb 1b 00 00 00 02 00 00 00  00 00 00 00 00 00 00 00
[27633.478063]          res 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
[27633.478066] ata3.00: status: { DRDY }
[27633.478073] ata3: hard resetting link
[27634.088877] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[27634.480533] ata3.00: configured for UDMA/100
[27634.480543] ata3: EH complete
[27662.800986] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[27672.782175] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[55128.897815] bridge-eth0: disabling the bridge
[55128.900941] bridge-eth0: down
[55128.996792] ACPI: PCI interrupt for device 0000:00:0f.0 disabled
[55130.517763] PM: suspend-to-disk mode set to 'shutdown'
[55130.517916] swsusp: Marking nosave pages: 000000000009e000 - 0000000000100000
[55130.517921] swsusp: Marking nosave pages: 0000000077000000 - 000000007f000000
[55130.518639] swsusp: Basic memory bitmaps created
[55130.518641] Syncing filesystems ... done.
[55130.540753] Freezing user space processes ... (elapsed 0.00 seconds) done.
[55130.541101] Freezing remaining freezable tasks ... (elapsed 6.93 seconds) done.
[55137.459562] Shrinking memory...  -\|/-\|/-\|/-\done (191473 pages freed)
[55139.814898] Freed 765892 kbytes in 2.35 seconds (325.91 MB/s)
[55139.814900] Suspending console(s)
[55140.016416] sd 1:0:0:0: [sda] Synchronizing SCSI cache
[55140.016604] ACPI handle has no context!
[55140.016827] serial 00:08: disabled
[55140.016864] ACPI handle has no context!
[55140.027404] NVRM: RmPowerManagement: 3
[55140.220036] ACPI: PCI interrupt for device 0000:00:09.0 disabled
[55140.231095] ACPI: PCI interrupt for device 0000:00:04.1 disabled
[55140.242005] ACPI: PCI interrupt for device 0000:00:04.0 disabled
[55140.253405] Disabling non-boot CPUs ...
[55140.358760] CPU 1 is now offline
[55140.358763] SMP alternatives: switching to UP code
[55140.359889] CPU1 is down
[55140.360028] swsusp: critical section: 
[55140.399385] swsusp: Need to copy 124487 pages
[55140.399388] swsusp: Normal pages needed: 124487 + 1024 + 38, available pages: 366397
[   29.948252] Enabling non-boot CPUs ...
[   29.950611] SMP alternatives: switching to SMP code
[   29.951364] Booting processor 1/2 APIC 0x1
[   29.961711] Initializing CPU#1
[   30.021410] Calibrating delay using timer specific routine.. 4666.90 BogoMIPS (lpj=2333450)
[   30.021415] CPU: L1 I cache: 32K, L1 D cache: 32K
[   30.021417] CPU: L2 cache: 4096K
[   30.021418] CPU: Physical Processor ID: 0
[   30.021419] CPU: Processor Core ID: 1
[   30.021816] Intel(R) Core(TM)2 Duo CPU     E6550  @ 2.33GHz stepping 0b
[   30.021856] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[   30.042093] CPU1 is up
[   30.042837] Switched to high resolution mode on CPU 1
[   30.053386] PCI: Enabling device 0000:00:04.0 (0000 -> 0002)
[   30.053390] ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [AUBA] -> GSI 23 (level, low) -> IRQ 23
[   30.053394] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   30.053398] PM: Writing back config space on device 0000:00:04.0 at offset f (was 1030100, writing 103010b)
[   30.053405] PM: Writing back config space on device 0000:00:04.0 at offset 4 (was 0, writing e5108000)
[   30.053408] PM: Writing back config space on device 0000:00:04.0 at offset 1 (was b00006, writing b00007)
[   30.064379] ACPI: PCI Interrupt 0000:00:04.1[B] -> Link [AUB2] -> GSI 22 (level, low) -> IRQ 22
[   30.064383] PCI: Setting latency timer of device 0000:00:04.1 to 64
[   30.064398] usb usb2: root hub lost power or was reset
[   30.064405] ehci_hcd 0000:00:04.1: debug port 1
[   30.064407] PCI: cache line size of 32 is not supported by device 0000:00:04.1
[   30.075381] PM: Writing back config space on device 0000:00:09.0 at offset 1 (was b00006, writing b00002)
[   30.075389] ACPI: PCI Interrupt 0000:00:09.0[A] -> Link [AAZA] -> GSI 23 (level, low) -> IRQ 23
[   30.075393] PCI: Setting latency timer of device 0000:00:09.0 to 64
[   30.075412] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   30.075424] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   30.075436] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   30.075448] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   30.075457] PM: Writing back config space on device 0000:00:0e.0 at offset 1 (was b00403, writing b00407)
[   30.075466] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   30.075486] PM: Writing back config space on device 0000:00:0f.0 at offset 1 (was b00007, writing b00003)
[   30.075504] NVRM: RmPowerManagement: 5
[   30.221078] PM: Writing back config space on device 0000:01:07.0 at offset f (was 4020100, writing 402010a)
[   30.221090] PM: Writing back config space on device 0000:01:07.0 at offset 5 (was 0, writing e5000000)
[   30.221093] PM: Writing back config space on device 0000:01:07.0 at offset 4 (was 0, writing e5004000)
[   30.221096] PM: Writing back config space on device 0000:01:07.0 at offset 3 (was 0, writing 2008)
[   30.221101] PM: Writing back config space on device 0000:01:07.0 at offset 1 (was 2100000, writing 2100006)
[   30.278639] serial 00:08: activated
[   30.330833] usb usb1: root hub lost power or was reset
[   30.379734] ata4: SATA link down (SStatus 0 SControl 300)
[   30.379745] ata1: SATA link down (SStatus 0 SControl 300)
[   30.582345] sd 1:0:0:0: [sda] Starting disk
[   30.683149] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   30.683165] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   30.689050] ata2.00: configured for UDMA/133
[   30.692716] sd 1:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
[   30.692726] sd 1:0:0:0: [sda] Write Protect is off
[   30.692728] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   30.692742] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   30.692796] PM: Image restored successfully.
[   30.726394] Restarting tasks ... <6>usb 1-2: USB disconnect, address 3
[   30.734505] done.
[   30.736236] swsusp: Basic memory bitmaps freed
[   30.986425] ata3.00: configured for UDMA/100
[   31.267285] usb 1-2: new low speed USB device using ohci_hcd and address 4
[   31.458759] usb 1-2: configuration #1 chosen from 1 choice
[   31.472803] input: BTC USB Multimedia Cordless Kit   as /class/input/input9
[   31.489635] input: USB HID v1.00 Keyboard [BTC USB Multimedia Cordless Kit  ] on usb-0000:00:04.0-2
[   31.503044] input: BTC USB Multimedia Cordless Kit   as /class/input/input10
[   31.526826] input,hiddev96: USB HID v1.00 Mouse [BTC USB Multimedia Cordless Kit  ] on usb-0000:00:04.0-2
[   32.472201] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
[   32.472225] ACPI: PCI Interrupt 0000:00:0f.0[A] -> Link [APCH] -> GSI 21 (level, low) -> IRQ 21
[   32.472229] PCI: Setting latency timer of device 0000:00:0f.0 to 64
[   32.984647] forcedeth 0000:00:0f.0: ifname eth0, PHY OUI 0x732 @ 1, addr 00:1a:4d:59:db:59
[   32.984652] forcedeth 0000:00:0f.0: highdma pwrctl mgmt timirq gbit lnktim msi desc-v3
[   33.016838] eth0: no link during initialization.
[   33.020688] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   33.020691] bridge-eth0: enabling the bridge
[   33.020695] bridge-eth0: up
[   34.347099] eth0: link up.
[   34.350984] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   34.524674] input: Power Button (FF) as /class/input/input11
[   34.536793] ACPI: Power Button (FF) [PWRF]
[   34.536835] input: Power Button (CM) as /class/input/input12
[   34.548780] ACPI: Power Button (CM) [PWRB]
[   53.026629] eth0: no IPv6 routers present
[  220.887434]  CIFS VFS: No response for cmd 50 mid 50128
[ 1646.490993] bridge-eth0: disabling the bridge
[ 1646.496328] bridge-eth0: down
[ 1646.590560] ACPI: PCI interrupt for device 0000:00:0f.0 disabled
[ 1648.079695] PM: suspend-to-disk mode set to 'shutdown'
[ 1648.079831] swsusp: Marking nosave pages: 000000000009e000 - 0000000000100000
[ 1648.079835] swsusp: Marking nosave pages: 0000000077000000 - 000000007f000000
[ 1648.080556] swsusp: Basic memory bitmaps created
[ 1648.080557] Syncing filesystems ... done.
[ 1648.102787] Freezing user space processes ... (elapsed 0.00 seconds) done.
[ 1648.103104] Freezing remaining freezable tasks ... (elapsed 7.72 seconds) done.
[ 1655.809473] Shrinking memory...  -\|/-\|/done (112983 pages freed)
[ 1657.182523] Freed 451932 kbytes in 1.37 seconds (329.87 MB/s)
[ 1657.182525] Suspending console(s)
[ 1657.384459] sd 1:0:0:0: [sda] Synchronizing SCSI cache
[ 1657.384646] ACPI handle has no context!
[ 1657.384869] serial 00:08: disabled
[ 1657.384905] ACPI handle has no context!
[ 1657.395447] NVRM: RmPowerManagement: 3
[ 1657.588079] ACPI: PCI interrupt for device 0000:00:09.0 disabled
[ 1657.599137] ACPI: PCI interrupt for device 0000:00:04.1 disabled
[ 1657.610048] ACPI: PCI interrupt for device 0000:00:04.0 disabled
[ 1657.621449] Disabling non-boot CPUs ...
[ 1657.726803] CPU 1 is now offline
[ 1657.726806] SMP alternatives: switching to UP code
[ 1657.727888] CPU1 is down
[ 1657.728027] swsusp: critical section: 
[ 1657.766803] swsusp: Need to copy 108235 pages
[ 1657.766805] swsusp: Normal pages needed: 108235 + 1024 + 38, available pages: 382652
[   29.914763] Enabling non-boot CPUs ...
[   29.917152] SMP alternatives: switching to SMP code
[   29.917906] Booting processor 1/2 APIC 0x1
[   29.928253] Initializing CPU#1
[   29.987958] Calibrating delay using timer specific routine.. 4666.90 BogoMIPS (lpj=2333454)
[   29.987963] CPU: L1 I cache: 32K, L1 D cache: 32K
[   29.987964] CPU: L2 cache: 4096K
[   29.987966] CPU: Physical Processor ID: 0
[   29.987967] CPU: Processor Core ID: 1
[   29.988364] Intel(R) Core(TM)2 Duo CPU     E6550  @ 2.33GHz stepping 0b
[   29.988401] checking TSC synchronization [CPU#0 -> CPU#1]:
[   30.008365] Measured 124887420 cycles TSC warp between CPUs, turning off TSC clock.
[   30.008367] Marking TSC unstable due to check_tsc_sync_source failed
[   30.008373] Time: hpet clocksource has been installed.
[   30.008640] CPU1 is up
[   30.009386] Switched to high resolution mode on CPU 1
[   30.019937] PCI: Enabling device 0000:00:04.0 (0000 -> 0002)
[   30.019940] ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [AUBA] -> GSI 23 (level, low) -> IRQ 23
[   30.019945] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   30.019949] PM: Writing back config space on device 0000:00:04.0 at offset f (was 1030100, writing 103010b)
[   30.019956] PM: Writing back config space on device 0000:00:04.0 at offset 4 (was 0, writing e5108000)
[   30.019959] PM: Writing back config space on device 0000:00:04.0 at offset 1 (was b00006, writing b00007)
[   30.030930] ACPI: PCI Interrupt 0000:00:04.1[B] -> Link [AUB2] -> GSI 22 (level, low) -> IRQ 22
[   30.030934] PCI: Setting latency timer of device 0000:00:04.1 to 64
[   30.030949] usb usb2: root hub lost power or was reset
[   30.030955] ehci_hcd 0000:00:04.1: debug port 1
[   30.030958] PCI: cache line size of 32 is not supported by device 0000:00:04.1
[   30.041931] PM: Writing back config space on device 0000:00:09.0 at offset 1 (was b00006, writing b00002)
[   30.041939] ACPI: PCI Interrupt 0000:00:09.0[A] -> Link [AAZA] -> GSI 23 (level, low) -> IRQ 23
[   30.041943] PCI: Setting latency timer of device 0000:00:09.0 to 64
[   30.041962] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   30.041974] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   30.041987] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   30.041999] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   30.042008] PM: Writing back config space on device 0000:00:0e.0 at offset 1 (was b00403, writing b00407)
[   30.042017] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   30.042036] PM: Writing back config space on device 0000:00:0f.0 at offset 1 (was b00007, writing b00003)
[   30.042053] NVRM: RmPowerManagement: 5
[   30.188630] PM: Writing back config space on device 0000:01:07.0 at offset f (was 4020100, writing 402010a)
[   30.188641] PM: Writing back config space on device 0000:01:07.0 at offset 5 (was 0, writing e5000000)
[   30.188645] PM: Writing back config space on device 0000:01:07.0 at offset 4 (was 0, writing e5004000)
[   30.188648] PM: Writing back config space on device 0000:01:07.0 at offset 3 (was 0, writing 2008)
[   30.188652] PM: Writing back config space on device 0000:01:07.0 at offset 1 (was 2100000, writing 2100006)
[   30.246177] serial 00:08: activated
[   30.298368] usb usb1: root hub lost power or was reset
[   30.346268] ata1: SATA link down (SStatus 0 SControl 300)
[   30.346278] ata4: SATA link down (SStatus 0 SControl 300)
[   30.548877] sd 1:0:0:0: [sda] Starting disk
[   30.649680] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   30.649696] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   30.655668] ata2.00: configured for UDMA/133
[   30.659333] sd 1:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
[   30.659343] sd 1:0:0:0: [sda] Write Protect is off
[   30.659345] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   30.659359] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   30.659412] PM: Image restored successfully.
[   30.690677] Restarting tasks ... <6>usb 1-2: USB disconnect, address 4
[   30.704037] done.
[   30.705800] swsusp: Basic memory bitmaps freed
[   30.952962] ata3.00: configured for UDMA/100
[   31.235561] usb 1-2: new low speed USB device using ohci_hcd and address 5
[   31.427288] usb 1-2: configuration #1 chosen from 1 choice
[   31.441373] input: BTC USB Multimedia Cordless Kit   as /class/input/input13
[   31.454178] input: USB HID v1.00 Keyboard [BTC USB Multimedia Cordless Kit  ] on usb-0000:00:04.0-2
[   31.467652] input: BTC USB Multimedia Cordless Kit   as /class/input/input14
[   31.479133] input,hiddev96: USB HID v1.00 Mouse [BTC USB Multimedia Cordless Kit  ] on usb-0000:00:04.0-2
[   33.523894] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
[   33.523915] ACPI: PCI Interrupt 0000:00:0f.0[A] -> Link [APCH] -> GSI 21 (level, low) -> IRQ 21
[   33.523920] PCI: Setting latency timer of device 0000:00:0f.0 to 64
[   34.036115] forcedeth 0000:00:0f.0: ifname eth0, PHY OUI 0x732 @ 1, addr 00:1a:4d:59:db:59
[   34.036119] forcedeth 0000:00:0f.0: highdma pwrctl mgmt timirq gbit lnktim msi desc-v3
[   34.069201] eth0: no link during initialization.
[   34.073098] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   34.073101] bridge-eth0: enabling the bridge
[   34.073105] bridge-eth0: up
[   35.094431] input: Power Button (FF) as /class/input/input15
[   35.107176] ACPI: Power Button (FF) [PWRF]
[   35.107220] input: Power Button (CM) as /class/input/input16
[   35.121716] ACPI: Power Button (CM) [PWRB]
[   35.419744] eth0: link up.
[   35.423325] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   50.564818] eth0: no IPv6 routers present
[  427.856088] printk: 56 messages suppressed.
[  427.856093] npviewer.bin[13266]: segfault at 34 rip f7b59950 rsp f5b67cb0 error 4
[ 5443.257675]  CIFS VFS: No response for cmd 50 mid 50170
[ 6515.010138] npviewer.bin[15888]: segfault at 44 rip 44 rsp fffd2bec error 14
[ 6696.476933] npviewer.bin[15998]: segfault at 18 rip f7aa511c rsp ffc2fdc0 error 4
[ 6722.940424] npviewer.bin[16077]: segfault at 30 rip f7a9b6fe rsp f5b437d0 error 4
[16391.542469] bridge-eth0: disabling the bridge
[16391.547739] bridge-eth0: down
[16391.630627] ACPI: PCI interrupt for device 0000:00:0f.0 disabled
[16393.062824] PM: suspend-to-disk mode set to 'shutdown'
[16393.062970] swsusp: Marking nosave pages: 000000000009e000 - 0000000000100000
[16393.062974] swsusp: Marking nosave pages: 0000000077000000 - 000000007f000000
[16393.063691] swsusp: Basic memory bitmaps created
[16393.063692] Syncing filesystems ... done.
[16393.100603] Freezing user space processes ... (elapsed 0.00 seconds) done.
[16393.100958] Freezing remaining freezable tasks ... (elapsed 2.88 seconds) done.
[16395.976265] Shrinking memory...  -\|/-\|/done (106375 pages freed)
[16397.160402] Freed 425500 kbytes in 1.18 seconds (360.59 MB/s)
[16397.160404] Suspending console(s)
[16397.162312] sd 1:0:0:0: [sda] Synchronizing SCSI cache
[16397.162515] ACPI handle has no context!
[16397.162712] serial 00:08: disabled
[16397.162758] ACPI handle has no context!
[16397.173754] NVRM: RmPowerManagement: 3
[16397.367366] ACPI: PCI interrupt for device 0000:00:09.0 disabled
[16397.378423] ACPI: PCI interrupt for device 0000:00:04.1 disabled
[16397.389333] ACPI: PCI interrupt for device 0000:00:04.0 disabled
[16397.400733] Disabling non-boot CPUs ...
[16397.506099] CPU 1 is now offline
[16397.506102] SMP alternatives: switching to UP code
[16397.507182] CPU1 is down
[16397.507323] swsusp: critical section: 
[16397.545704] swsusp: Need to copy 124847 pages
[16397.545707] swsusp: Normal pages needed: 124847 + 1024 + 38, available pages: 366040
[   30.132788] Enabling non-boot CPUs ...
[   30.135168] SMP alternatives: switching to SMP code
[   30.135921] Booting processor 1/2 APIC 0x1
[   30.146266] Initializing CPU#1
[   30.205966] Calibrating delay using timer specific routine.. 4666.91 BogoMIPS (lpj=2333456)
[   30.205971] CPU: L1 I cache: 32K, L1 D cache: 32K
[   30.205972] CPU: L2 cache: 4096K
[   30.205974] CPU: Physical Processor ID: 0
[   30.205975] CPU: Processor Core ID: 1
[   30.206372] Intel(R) Core(TM)2 Duo CPU     E6550  @ 2.33GHz stepping 0b
[   30.206651] CPU1 is up
[   30.207393] Switched to high resolution mode on CPU 1
[   30.217967] PCI: Enabling device 0000:00:04.0 (0000 -> 0002)
[   30.217971] ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [AUBA] -> GSI 23 (level, low) -> IRQ 23
[   30.217976] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   30.217980] PM: Writing back config space on device 0000:00:04.0 at offset f (was 1030100, writing 103010b)
[   30.217987] PM: Writing back config space on device 0000:00:04.0 at offset 4 (was 0, writing e5108000)
[   30.217990] PM: Writing back config space on device 0000:00:04.0 at offset 1 (was b00006, writing b00007)
[   30.228940] ACPI: PCI Interrupt 0000:00:04.1[B] -> Link [AUB2] -> GSI 22 (level, low) -> IRQ 22
[   30.228944] PCI: Setting latency timer of device 0000:00:04.1 to 64
[   30.228959] usb usb2: root hub lost power or was reset
[   30.228966] ehci_hcd 0000:00:04.1: debug port 1
[   30.228968] PCI: cache line size of 32 is not supported by device 0000:00:04.1
[   30.239979] PM: Writing back config space on device 0000:00:09.0 at offset 1 (was b00006, writing b00002)
[   30.239987] ACPI: PCI Interrupt 0000:00:09.0[A] -> Link [AAZA] -> GSI 23 (level, low) -> IRQ 23
[   30.239991] PCI: Setting latency timer of device 0000:00:09.0 to 64
[   30.240010] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   30.240022] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   30.240035] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   30.240047] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   30.240056] PM: Writing back config space on device 0000:00:0e.0 at offset 1 (was b00403, writing b00407)
[   30.240066] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   30.240085] PM: Writing back config space on device 0000:00:0f.0 at offset 1 (was b00007, writing b00003)
[   30.240107] NVRM: RmPowerManagement: 5
[   30.383657] PM: Writing back config space on device 0000:01:07.0 at offset f (was 4020100, writing 402010a)
[   30.383668] PM: Writing back config space on device 0000:01:07.0 at offset 5 (was 0, writing e5000000)
[   30.383672] PM: Writing back config space on device 0000:01:07.0 at offset 4 (was 0, writing e5004000)
[   30.383675] PM: Writing back config space on device 0000:01:07.0 at offset 3 (was 0, writing 2008)
[   30.383679] PM: Writing back config space on device 0000:01:07.0 at offset 1 (was 2100000, writing 2100006)
[   30.441236] serial 00:08: activated
[   30.493430] usb usb1: root hub lost power or was reset
[   30.544332] ata1: SATA link down (SStatus 0 SControl 300)
[   30.544342] ata4: SATA link down (SStatus 0 SControl 300)
[   30.743949] sd 1:0:0:0: [sda] Starting disk
[   30.847753] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   30.847781] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   30.861239] ata2.00: configured for UDMA/133
[   30.864865] sd 1:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
[   30.864875] sd 1:0:0:0: [sda] Write Protect is off
[   30.864877] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   30.864890] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   30.864928] PM: Image restored successfully.
[   30.895764] Restarting tasks ... <6>usb 1-2: USB disconnect, address 5
[   30.910113] done.
[   30.911828] swsusp: Basic memory bitmaps freed
[   31.151023] ata3.00: configured for UDMA/100
[   31.442611] usb 1-2: new low speed USB device using ohci_hcd and address 6
[   31.634295] usb 1-2: configuration #1 chosen from 1 choice
[   31.648402] input: BTC USB Multimedia Cordless Kit   as /class/input/input17
[   31.657215] input: USB HID v1.00 Keyboard [BTC USB Multimedia Cordless Kit  ] on usb-0000:00:04.0-2
[   31.670699] input: BTC USB Multimedia Cordless Kit   as /class/input/input18
[   31.682189] input,hiddev96: USB HID v1.00 Mouse [BTC USB Multimedia Cordless Kit  ] on usb-0000:00:04.0-2
[   32.380567] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
[   32.380594] ACPI: PCI Interrupt 0000:00:0f.0[A] -> Link [APCH] -> GSI 21 (level, low) -> IRQ 21
[   32.380599] PCI: Setting latency timer of device 0000:00:0f.0 to 64
[   32.892756] forcedeth 0000:00:0f.0: ifname eth0, PHY OUI 0x732 @ 1, addr 00:1a:4d:59:db:59
[   32.892760] forcedeth 0000:00:0f.0: highdma pwrctl mgmt timirq gbit lnktim msi desc-v3
[   32.924801] eth0: no link during initialization.
[   32.928727] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   32.928730] bridge-eth0: enabling the bridge
[   32.928734] bridge-eth0: up
[   34.266185] eth0: link up.
[   34.270076] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   34.271522] input: Power Button (FF) as /class/input/input19
[   34.284207] ACPI: Power Button (FF) [PWRF]
[   34.284251] input: Power Button (CM) as /class/input/input20
[   34.294420] ACPI: Power Button (CM) [PWRB]
[   49.247535] eth0: no IPv6 routers present
[  373.235997]  CIFS VFS: No response for cmd 50 mid 54293
[  500.725653] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
[  500.725660] ata2.00: cmd b0/da:00:00:4f:c2/00:00:00:00:00/00 tag 0
[  500.725661]          res 40/00:01:b4:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
[  500.725664] ata2.00: status: { DRDY }
[  500.725670] ata2: hard resetting link
[  501.333485] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  501.342713] ata2.00: configured for UDMA/133
[  501.342721] ata2: EH complete
[  501.342866] sd 1:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
[  501.342982] sd 1:0:0:0: [sda] Write Protect is off
[  501.342985] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[  501.343181] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  507.331011] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
[  507.331019] ata2.00: cmd b0/d1:01:01:4f:c2/00:00:00:00:00/00 tag 0 pio 512 in
[  507.331021]          res 40/00:01:b4:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
[  507.331023] ata2.00: status: { DRDY }
[  507.331029] ata2: hard resetting link
[  507.938846] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  507.952183] ata2.00: configured for UDMA/133
[  507.952191] ata2: EH complete
[  507.952423] sd 1:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
[  507.952511] sd 1:0:0:0: [sda] Write Protect is off
[  507.952514] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[  507.952750] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

--Boundary-00=_dlEBIoG5qvb6A2M--
