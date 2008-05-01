Return-Path: <linux-kernel-owner+w=401wt.eu-S1763826AbYEAXiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763826AbYEAXiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 19:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169AbYEAXh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 19:37:59 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:30143 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752614AbYEAXh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 19:37:57 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 May 2008 19:37:57 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type;
  b=4V9ZlmPWjRzeOLLtB2gf0MXDK1uj2vpRGaCS5/9VH22IP+PbtXiAeeioAAhHu+rMQW2iUXNpGmkUQ/klVv2ph0dPIKupNoJjjiurRaboncm7IhA6iN06c6T3dgk3fnL1lMKKx2Ic/cKNrvKIk5bYnFwmm7PvjdnLmsGOt6zpugI=  ;
X-YMail-OSG: A8VzhrAVM1mbLzvqjeZbwT4D.19lim8D0BieMXlSlzdLveCBXsH0XV0XnzwnVTqm.HiH8KDfk7bKuvrtVDMoEZavnpRNMwRd5AvdKSgDn.JveTmu8q.DOFA5lClJXhdbisbmiHxfE8.ZlHvZR98D3fQi
X-Yahoo-Newman-Property: ymail-3
Message-ID: <481A5276.4040607@sbcglobal.net>
Date: Thu, 01 May 2008 16:29:58 -0700
From: Ryan Roth <ryanroth@sbcglobal.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ryan.Roth@CH2M.com
CC: akpm@linux-foundation.org, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 10586] New: High Number of Segfaults onMacBookStarting
 With 2.6.24.5 Kernel
References: <bug-10586-10286@http.bugzilla.kernel.org/><20080501130444.cc5c63e8.akpm@linux-foundation.org><86A21F45FFA48B408A65E67054362EB6069DD742@CULEBRA.amr.ch2m.com> <20080501133003.be723364.akpm@linux-foundation.org> <86A21F45FFA48B408A65E67054362EB621C948@CULEBRA.amr.ch2m.com>
In-Reply-To: <86A21F45FFA48B408A65E67054362EB621C948@CULEBRA.amr.ch2m.com>
Content-Type: multipart/mixed;
 boundary="------------010401070104000905030004"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010401070104000905030004
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


> -----Original Message-----
> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> Sent: Thu 5/1/2008 1:30 PM
> To: Roth, Ryan/RDD
> Cc: bugme-daemon@bugzilla.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [Bugme-new] [Bug 10586] New: High Number of Segfaults 
> onMacBookStarting With 2.6.24.5 Kernel
>
> On Thu, 1 May 2008 14:09:00 -0600
> <Ryan.Roth@CH2M.com> wrote:
> >
> > -----Original Message-----
> > > From: Andrew Morton [mailto:akpm@linux-foundation.org]
> > > Sent: Thursday, May 01, 2008 1:05 PM
> > > To: Roth, Ryan/RDD
> > > Cc: bugme-daemon@bugzilla.kernel.org; linux-kernel@vger.kernel.org
> > > Subject: Re: [Bugme-new] [Bug 10586] New: High Number of Segfaults
> > > onMacBook Starting With 2.6.24.5 Kernel
> > >
> > > (switched to email.  Please respond via emailed reply-to-all, not via
> > > the bugzilla web interface).
> > >
> > > On Thu,  1 May 2008 12:30:18 -0700 (PDT)
> > > bugme-daemon@bugzilla.kernel.org wrote:
> > >
> > > > http://bugzilla.kernel.org/show_bug.cgi?id=10586
> > > >
> > > >            Summary: High Number of Segfaults on MacBook Starting 
> With
> > > >                     2.6.24.5 Kernel
> > > >            Product: Memory Management
> > > >            Version: 2.5
> > > >      KernelVersion: 2.6.24.5
> > > >           Platform: All
> > > >         OS/Version: Linux
> > > >               Tree: Mainline
> > > >             Status: NEW
> > > >           Severity: normal
> > > >           Priority: P1
> > > >          Component: Other
> > > >         AssignedTo: akpm@osdl.org
> > > >         ReportedBy: ryan.roth@ch2m.com
> > > >
> > > >
> > > > Latest working kernel version:  2.6.23?
> > > > Earliest failing kernel version:  2.6.24.5
> > > > Distribution: Fedora 8 x86_64
> > > > Hardware Environment:  MacBook
> > > > Problem Description:  Extremely high number of segfaults.  Suspect
> > > > that this may have to do with some sort of change in memory 
> remapping
> > > > changes in the kernel.
> > >
> > > This report is a bit mysterious.  I assume you're referring to x86's
> > >
> > >     "%s%s[%d]: segfault at %lx ip %08lx sp %08lx error %lx"
> > >
> > > printk in the kernel logs?
> > >
> > > Can you please send some examples of the log output?
> > >
> > > Is there actually any observeable problem apart from the logs?  Are
> > > applications dying where they previously did not?
> > >
> >
> > Yes there is a issue with a lot of apps dying, especially the
> > gnome-power-* apps which means my power management fails to work
> > frequently.  I'm on Git-10 currently and I'm going to patch it up to
> > date right now because it looks like there have been some memory remap
> > patches lately.  I will update the list after I do so.
> >
>
> OK, worried.  This is a huge bug.  But afaik you're the only person 
> who has
> hit it, so there must be something special in your setup which is
> triggering it.  This could be hard.
>

OK here is what I get with the git16 kernel.  On boot I get this error:

PCI: Not using MMCONFIG
PCI: BIOS Bug: MCFG area at f0000000 is not reserved in ACPI motherboard 
resources
PCI: Not using MMCONFIG

Attached is a complete log after this boot
>
>
>

--------------010401070104000905030004
Content-Type: text/x-log;
 name="boot.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="boot.log"

May  1 16:15:01 rsyslogd: [origin software="rsyslogd" swVersion="2.0.2" x-pid="2118" x-info="http://www.rsyslog.com"][x-configInfo udpReception="No" udpPort="514" tcpReception="No" tcpPort="0"] restart
May  1 16:15:01 kernel: rklogd 2.0.2, log source = /proc/kmsg started.
May  1 16:15:01 kernel: Initializing cgroup subsys cpuset
May  1 16:15:01 kernel: Linux version 2.6.25-git16 (root@) (gcc version 4.1.2 20070925 (Red Hat 4.1.2-33)) #3 SMP Thu May 1 16:10:07 PDT 2008
May  1 16:15:01 kernel: Command line: ro root=LABEL=/ rhgb quiet
May  1 16:15:01 kernel: BIOS-provided physical RAM map:
May  1 16:15:01 kernel:  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
May  1 16:15:01 kernel:  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
May  1 16:15:01 kernel:  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
May  1 16:15:01 kernel:  BIOS-e820: 0000000000100000 - 00000000bdd31000 (usable)
May  1 16:15:01 kernel:  BIOS-e820: 00000000bdd31000 - 00000000bdf32000 (ACPI NVS)
May  1 16:15:01 kernel:  BIOS-e820: 00000000bdf32000 - 00000000bdfe5000 (ACPI data)
May  1 16:15:01 kernel:  BIOS-e820: 00000000bdfe5000 - 00000000bdfe7000 (ACPI NVS)
May  1 16:15:01 kernel:  BIOS-e820: 00000000bdfe7000 - 00000000beec3000 (ACPI data)
May  1 16:15:01 kernel:  BIOS-e820: 00000000beec3000 - 00000000beec5000 (ACPI NVS)
May  1 16:15:01 kernel:  BIOS-e820: 00000000beec5000 - 00000000beec8000 (ACPI data)
May  1 16:15:01 kernel:  BIOS-e820: 00000000beec8000 - 00000000beecb000 (ACPI NVS)
May  1 16:15:01 kernel:  BIOS-e820: 00000000beecb000 - 00000000beecc000 (ACPI data)
May  1 16:15:01 kernel:  BIOS-e820: 00000000beecc000 - 00000000beedf000 (ACPI NVS)
May  1 16:15:01 kernel:  BIOS-e820: 00000000beedf000 - 00000000beef9000 (ACPI data)
May  1 16:15:01 kernel:  BIOS-e820: 00000000beef9000 - 00000000beeff000 (reserved)
May  1 16:15:01 kernel:  BIOS-e820: 00000000beeff000 - 00000000bef00000 (ACPI data)
May  1 16:15:01 kernel:  BIOS-e820: 00000000bef00000 - 00000000c0000000 (reserved)
May  1 16:15:01 kernel:  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
May  1 16:15:01 kernel:  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
May  1 16:15:01 kernel:  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
May  1 16:15:01 kernel:  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
May  1 16:15:01 kernel:  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
May  1 16:15:01 kernel:  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
May  1 16:15:01 kernel:  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
May  1 16:15:01 kernel: max_pfn_mapped = 1310720
May  1 16:15:01 kernel: x86: PAT support disabled.
May  1 16:15:01 kernel: init_memory_mapping
May  1 16:15:01 kernel: DMI 2.4 present.
May  1 16:15:01 kernel: ACPI: RSDP 000FE020, 0024 (r2 APPLE )
May  1 16:15:01 kernel: ACPI: XSDT BEEEE1C0, 0084 (r1 APPLE   Apple00       C1       1000013)
May  1 16:15:01 kernel: ACPI: FACP BEEEC000, 00F4 (r3 APPLE   Apple00       C1 Loki       5F)
May  1 16:15:01 kernel: ACPI: DSDT BEEE1000, 45C6 (r1 APPLE   MacBook    40001 INTL 20061109)
May  1 16:15:01 kernel: ACPI: FACS BEECC000, 0040
May  1 16:15:01 kernel: ACPI: HPET BEEEB000, 0038 (r1 APPLE   Apple00        1 Loki       5F)
May  1 16:15:01 kernel: ACPI: APIC BEEEA000, 0068 (r1 APPLE   Apple00        1 Loki       5F)
May  1 16:15:01 kernel: ACPI: MCFG BEEE9000, 003C (r1 APPLE   Apple00        1 Loki       5F)
May  1 16:15:01 kernel: ACPI: ASF! BEEE8000, 00A5 (r32 APPLE   Apple00        1 Loki       5F)
May  1 16:15:01 kernel: ACPI: SBST BEEE7000, 0030 (r1 APPLE   Apple00        1 Loki       5F)
May  1 16:15:01 kernel: ACPI: ECDT BEEE6000, 0053 (r1 APPLE   Apple00        1 Loki       5F)
May  1 16:15:01 kernel: ACPI: SSDT BEEC7000, 04DC (r1  APPLE    CpuPm     3000 INTL 20061109)
May  1 16:15:01 kernel: ACPI: SSDT BEEC6000, 025F (r1  APPLE  Cpu0Tst     3000 INTL 20061109)
May  1 16:15:01 kernel: ACPI: SSDT BEEC5000, 00A6 (r1  APPLE  Cpu1Tst     3000 INTL 20061109)
May  1 16:15:01 kernel: ACPI: SSDT BEEE0000, 0544 (r1 SataRe  SataPri     1000 INTL 20061109)
May  1 16:15:01 kernel: ACPI: SSDT BEEDF000, 0477 (r1 SataRe  SataSec     1000 INTL 20061109)
May  1 16:15:01 kernel: ACPI: DMI detected: Apple
May  1 16:15:01 kernel: No NUMA configuration found
May  1 16:15:01 kernel: Faking a node at 0000000000000000-0000000140000000
May  1 16:15:01 kernel: Bootmem setup node 0 0000000000000000-0000000140000000
May  1 16:15:01 kernel:   NODE_DATA [000000000000e000 - 0000000000012fff]
May  1 16:15:01 kernel:   bootmap [0000000000013000 -  000000000003afff] pages 28
May  1 16:15:01 kernel:   early res: 0 [0-fff] BIOS data page
May  1 16:15:01 kernel:   early res: 1 [6000-7fff] TRAMPOLINE
May  1 16:15:01 kernel:   early res: 2 [200000-74dc6b] TEXT DATA BSS
May  1 16:15:01 kernel:   early res: 3 [37cc4000-37fef8ef] RAMDISK
May  1 16:15:01 kernel:   early res: 4 [9fc00-fffff] BIOS reserved
May  1 16:15:01 kernel:   early res: 5 [8000-dfff] PGTABLE
May  1 16:15:01 kernel: Zone PFN ranges:
May  1 16:15:01 kernel:   DMA             0 ->     4096
May  1 16:15:01 kernel:   DMA32        4096 ->  1048576
May  1 16:15:01 kernel:   Normal    1048576 ->  1310720
May  1 16:15:01 kernel: Movable zone start PFN for each node
May  1 16:15:01 kernel: early_node_map[3] active PFN ranges
May  1 16:15:01 kernel:     0:        0 ->      159
May  1 16:15:01 kernel:     0:      256 ->   777521
May  1 16:15:01 kernel:     0:  1048576 ->  1310720
May  1 16:15:01 kernel: ACPI: PM-Timer IO Port: 0x408
May  1 16:15:01 kernel: ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
May  1 16:15:01 kernel: ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
May  1 16:15:01 kernel: ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
May  1 16:15:01 kernel: ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
May  1 16:15:01 kernel: ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
May  1 16:15:01 kernel: IOAPIC[0]: apic_id 1, version 0, address 0xfec00000, GSI 0-23
May  1 16:15:01 kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
May  1 16:15:01 kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
May  1 16:15:01 kernel: Setting APIC routing to flat
May  1 16:15:01 kernel: ACPI: HPET id: 0x8086a201 base: 0xfed00000
May  1 16:15:01 kernel: Using ACPI (MADT) for SMP configuration information
May  1 16:15:01 kernel: PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
May  1 16:15:01 kernel: PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
May  1 16:15:01 kernel: PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
May  1 16:15:01 kernel: PM: Registered nosave memory: 00000000bdd31000 - 00000000bdf32000
May  1 16:15:01 kernel: PM: Registered nosave memory: 00000000bdf32000 - 00000000bdfe5000
May  1 16:15:01 kernel: PM: Registered nosave memory: 00000000bdfe5000 - 00000000bdfe7000
May  1 16:15:01 kernel: PM: Registered nosave memory: 00000000bdfe7000 - 00000000beec3000
May  1 16:15:01 kernel: PM: Registered nosave memory: 00000000beec3000 - 00000000beec5000
May  1 16:15:01 kernel: PM: Registered nosave memory: 00000000beec5000 - 00000000beec8000
May  1 16:15:01 kernel: PM: Registered nosave memory: 00000000beec8000 - 00000000beecb000
May  1 16:15:01 kernel: PM: Registered nosave memory: 00000000beecb000 - 00000000beecc000
May  1 16:15:01 kernel: PM: Registered nosave memory: 00000000beecc000 - 00000000beedf000
May  1 16:15:01 kernel: PM: Registered nosave memory: 00000000beedf000 - 00000000beef9000
May  1 16:15:01 kernel: PM: Registered nosave memory: 00000000beef9000 - 00000000beeff000
May  1 16:15:01 kernel: PM: Registered nosave memory: 00000000beeff000 - 00000000bef00000
May  1 16:15:01 kernel: PM: Registered nosave memory: 00000000bef00000 - 00000000c0000000
May  1 16:15:01 kernel: PM: Registered nosave memory: 00000000c0000000 - 00000000f0000000
May  1 16:15:01 kernel: PM: Registered nosave memory: 00000000f0000000 - 00000000f4000000
May  1 16:15:01 kernel: PM: Registered nosave memory: 00000000f4000000 - 00000000fec00000
May  1 16:15:01 kernel: PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
May  1 16:15:01 kernel: PM: Registered nosave memory: 00000000fec01000 - 00000000fed14000
May  1 16:15:01 kernel: PM: Registered nosave memory: 00000000fed14000 - 00000000fed1a000
May  1 16:15:01 kernel: PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
May  1 16:15:01 kernel: PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
May  1 16:15:01 kernel: PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
May  1 16:15:01 kernel: PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
May  1 16:15:01 kernel: PM: Registered nosave memory: 00000000fee01000 - 00000000ffe00000
May  1 16:15:01 kernel: PM: Registered nosave memory: 00000000ffe00000 - 0000000100000000
May  1 16:15:01 kernel: Allocating PCI resources starting at c4000000 (gap: c0000000:30000000)
May  1 16:15:01 kernel: SMP: Allowing 2 CPUs, 0 hotplug CPUs
May  1 16:15:01 kernel: PERCPU: Allocating 44128 bytes of per cpu data
May  1 16:15:01 kernel: Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1020186
May  1 16:15:01 kernel: Policy zone: Normal
May  1 16:15:01 kernel: Kernel command line: ro root=LABEL=/ rhgb quiet
May  1 16:15:01 kernel: Initializing CPU#0
May  1 16:15:01 kernel: PID hash table entries: 4096 (order: 12, 32768 bytes)
May  1 16:15:01 kernel: Extended CMOS year: 2000
May  1 16:15:01 kernel: TSC calibrated against PM_TIMER
May  1 16:15:01 kernel: time.c: Detected 2393.991 MHz processor.
May  1 16:15:01 kernel: Console: colour VGA+ 80x25
May  1 16:15:01 kernel: console [tty0] enabled
May  1 16:15:01 kernel: Checking aperture...
May  1 16:15:01 kernel: PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
May  1 16:15:01 kernel: Placing software IO TLB between 0x4000000 - 0x8000000
May  1 16:15:01 kernel: Memory: 4025868k/5242880k available (2467k kernel code, 132404k reserved, 1536k data, 348k init)
May  1 16:15:01 kernel: SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
May  1 16:15:01 kernel: Calibrating delay using timer specific routine.. 4791.85 BogoMIPS (lpj=2395928)
May  1 16:15:01 kernel: Security Framework initialized
May  1 16:15:01 kernel: SELinux:  Initializing.
May  1 16:15:01 kernel: selinux_register_security:  Registering secondary module capability
May  1 16:15:01 kernel: Capability LSM initialized as secondary
May  1 16:15:01 kernel: Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
May  1 16:15:01 kernel: Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
May  1 16:15:01 kernel: Mount-cache hash table entries: 256
May  1 16:15:01 kernel: Initializing cgroup subsys ns
May  1 16:15:01 kernel: Initializing cgroup subsys cpuacct
May  1 16:15:01 kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
May  1 16:15:01 kernel: CPU: L2 cache: 3072K
May  1 16:15:01 kernel: CPU 0/0 -> Node 0
May  1 16:15:01 kernel: CPU: Physical Processor ID: 0
May  1 16:15:01 kernel: CPU: Processor Core ID: 0
May  1 16:15:01 kernel: using mwait in idle threads.
May  1 16:15:01 kernel: ACPI: Core revision 20080321
May  1 16:15:01 kernel: CPU0: Intel(R) Core(TM)2 Duo CPU     T8300  @ 2.40GHz stepping 06
May  1 16:15:01 kernel: Using local APIC timer interrupts.
May  1 16:15:01 kernel: Detected 12.468 MHz APIC timer.
May  1 16:15:01 kernel: Booting processor 1/1 ip 6000
May  1 16:15:01 kernel: Initializing CPU#1
May  1 16:15:01 kernel: Calibrating delay using timer specific routine.. 4787.74 BogoMIPS (lpj=2393874)
May  1 16:15:01 kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
May  1 16:15:01 kernel: CPU: L2 cache: 3072K
May  1 16:15:01 kernel: CPU 1/1 -> Node 0
May  1 16:15:01 kernel: CPU: Physical Processor ID: 0
May  1 16:15:01 kernel: CPU: Processor Core ID: 1
May  1 16:15:01 kernel: x86: PAT support disabled.
May  1 16:15:01 kernel: CPU1: Intel(R) Core(TM)2 Duo CPU     T8300  @ 2.40GHz stepping 06
May  1 16:15:01 kernel: checking TSC synchronization [CPU#0 -> CPU#1]: passed.
May  1 16:15:01 kernel: Brought up 2 CPUs
May  1 16:15:01 kernel: Total of 2 processors activated (9579.60 BogoMIPS).
May  1 16:15:01 kernel: net_namespace: 1224 bytes
May  1 16:15:01 kernel: NET: Registered protocol family 16
May  1 16:15:01 kernel: No dock devices found.
May  1 16:15:01 kernel: ACPI: bus type pci registered
May  1 16:15:01 kernel: PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 255
May  1 16:15:01 kernel: PCI: Not using MMCONFIG.
May  1 16:15:01 kernel: PCI: Using configuration type 1 for base access
May  1 16:15:01 kernel: ACPI: EC: EC description table is found, configuring boot EC
May  1 16:15:01 kernel: ACPI: EC: non-query interrupt received, switching to interrupt mode
May  1 16:15:01 kernel: ACPI: BIOS _OSI(Linux) query ignored via DMI
May  1 16:15:01 kernel: ACPI: Interpreter enabled
May  1 16:15:01 kernel: ACPI: (supports S0 S3 S4 S5)
May  1 16:15:01 kernel: ACPI: Using IOAPIC for interrupt routing
May  1 16:15:01 kernel: PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 255
May  1 16:15:01 kernel: PCI: BIOS Bug: MCFG area at f0000000 is not reserved in ACPI motherboard resources
May  1 16:15:01 kernel: PCI: Not using MMCONFIG.
May  1 16:15:01 kernel: ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
May  1 16:15:01 kernel: ACPI: EC: driver started in interrupt mode
May  1 16:15:01 kernel: ACPI: PCI Root Bridge [PCI0] (0000:00)
May  1 16:15:01 kernel: pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
May  1 16:15:01 kernel: pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
May  1 16:15:01 kernel: PCI: Transparent bridge - 0000:00:1e.0
May  1 16:15:01 kernel: ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
May  1 16:15:01 kernel: ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 *7 11 12 14 15)
May  1 16:15:01 kernel: ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 *5 6 7 10 12 14 15)
May  1 16:15:01 kernel: ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
May  1 16:15:01 kernel: ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 *10 12 14 15)
May  1 16:15:01 kernel: ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *9
May  1 16:15:01 kernel: ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
May  1 16:15:01 kernel: ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
May  1 16:15:01 kernel: Linux Plug and Play Support v0.97 (c) Adam Belay
May  1 16:15:01 kernel: pnp: PnP ACPI init
May  1 16:15:01 kernel: ACPI: bus type pnp registered
May  1 16:15:01 kernel: pnp: PnP ACPI: found 9 devices
May  1 16:15:01 kernel: ACPI: ACPI bus type pnp unregistered
May  1 16:15:01 kernel: usbcore: registered new interface driver usbfs
May  1 16:15:01 kernel: usbcore: registered new interface driver hub
May  1 16:15:01 kernel: usbcore: registered new device driver usb
May  1 16:15:01 kernel: PCI: Using ACPI for IRQ routing
May  1 16:15:01 kernel: NetLabel: Initializing
May  1 16:15:01 kernel: NetLabel:  domain hash size = 128
May  1 16:15:01 kernel: NetLabel:  protocols = UNLABELED CIPSOv4
May  1 16:15:01 kernel: NetLabel:  unlabeled traffic allowed by default
May  1 16:15:01 kernel: PCI-GART: No AMD northbridge found.
May  1 16:15:01 kernel: hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
May  1 16:15:01 kernel: hpet0: 3 64-bit timers, 14318180 Hz
May  1 16:15:01 kernel: system 00:01: iomem range 0xfed1c000-0xfed1ffff could not be reserved
May  1 16:15:01 kernel: system 00:01: iomem range 0xfed14000-0xfed17fff could not be reserved
May  1 16:15:01 kernel: system 00:01: iomem range 0xfed18000-0xfed18fff could not be reserved
May  1 16:15:01 kernel: system 00:01: iomem range 0xfed19000-0xfed19fff could not be reserved
May  1 16:15:01 kernel: system 00:01: iomem range 0xf0000000-0xf3ffffff could not be reserved
May  1 16:15:01 kernel: system 00:01: iomem range 0xfed20000-0xfed3ffff has been reserved
May  1 16:15:01 kernel: system 00:01: iomem range 0xfed45000-0xfed8ffff has been reserved
May  1 16:15:01 kernel: system 00:05: iomem range 0xfed00000-0xfed003ff has been reserved
May  1 16:15:01 kernel: system 00:07: ioport range 0x680-0x69f has been reserved
May  1 16:15:01 kernel: system 00:07: ioport range 0x800-0x80f has been reserved
May  1 16:15:01 kernel: system 00:07: ioport range 0x810-0x817 has been reserved
May  1 16:15:01 kernel: system 00:07: ioport range 0x400-0x47f has been reserved
May  1 16:15:01 kernel: system 00:07: ioport range 0x500-0x53f has been reserved
May  1 16:15:01 kernel: system 00:07: ioport range 0x1640-0x164f has been reserved
May  1 16:15:01 kernel: PCI: Bridge: 0000:00:1c.0
May  1 16:15:01 kernel:   IO window: disabled.
May  1 16:15:01 kernel:   MEM window: 0xd0600000-0xd06fffff
May  1 16:15:01 kernel:   PREFETCH window: disabled.
May  1 16:15:01 kernel: PCI: Bridge: 0000:00:1c.4
May  1 16:15:01 kernel:   IO window: disabled.
May  1 16:15:01 kernel:   MEM window: 0xd0500000-0xd05fffff
May  1 16:15:01 kernel:   PREFETCH window: 0x00000000d0000000-0x00000000d00fffff
May  1 16:15:01 kernel: PCI: Bridge: 0000:00:1c.5
May  1 16:15:01 kernel:   IO window: 5000-5fff
May  1 16:15:01 kernel:   MEM window: 0xd0400000-0xd04fffff
May  1 16:15:01 kernel:   PREFETCH window: 0x00000000d0800000-0x00000000d08fffff
May  1 16:15:01 kernel: PCI: Bridge: 0000:00:1e.0
May  1 16:15:01 kernel:   IO window: disabled.
May  1 16:15:01 kernel:   MEM window: 0xd0300000-0xd03fffff
May  1 16:15:01 kernel:   PREFETCH window: disabled.
May  1 16:15:01 kernel: pci 0000:00:1c.0: enabling device (0000 -> 0002)
May  1 16:15:01 kernel: ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
May  1 16:15:01 kernel: ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 16 (level, low) -> IRQ 16
May  1 16:15:01 kernel: ACPI: PCI Interrupt 0000:00:1c.5[B] -> GSI 17 (level, low) -> IRQ 17
May  1 16:15:01 kernel: NET: Registered protocol family 2
May  1 16:15:01 kernel: IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
May  1 16:15:01 kernel: TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
May  1 16:15:01 kernel: TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
May  1 16:15:01 kernel: TCP: Hash tables configured (established 524288 bind 65536)
May  1 16:15:01 kernel: TCP reno registered
May  1 16:15:01 kernel: NET: Registered protocol family 1
May  1 16:15:01 kernel: checking if image is initramfs... it is
May  1 16:15:01 kernel: Freeing initrd memory: 3246k freed
May  1 16:15:01 kernel: audit: initializing netlink socket (disabled)
May  1 16:15:01 kernel: type=2000 audit(1209683666.442:1): initialized
May  1 16:15:01 kernel: Total HugeTLB memory allocated, 0
May  1 16:15:01 kernel: VFS: Disk quotas dquot_6.5.1
May  1 16:15:01 kernel: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
May  1 16:15:01 kernel: msgmni has been set to 7869 for ipc namespace ffffffff813b3be0
May  1 16:15:01 kernel: Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
May  1 16:15:01 kernel: io scheduler noop registered
May  1 16:15:01 kernel: io scheduler anticipatory registered
May  1 16:15:01 kernel: io scheduler deadline registered
May  1 16:15:01 kernel: io scheduler cfq registered (default)
May  1 16:15:01 kernel: assign_interrupt_mode Found MSI capability
May  1 16:15:04 kernel:last message repeated 2 times
May  1 16:15:01 kernel: pci_hotplug: PCI Hot Plug PCI Core version: 0.5
May  1 16:15:01 kernel: ACPI: SSDT BEECAA98, 0340 (r1  APPLE  Cpu0Ist     3000 INTL 20061109)
May  1 16:15:01 kernel: ACPI: SSDT BEEC8C18, 02AD (r1  APPLE  Cpu0Cst     3001 INTL 20061109)
May  1 16:15:01 kernel: ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
May  1 16:15:01 kernel: ACPI: ACPI0007:00 is registered as cooling_device0
May  1 16:15:01 kernel: ACPI: Processor [CPU0] (supports 8 throttling states)
May  1 16:15:01 kernel: ACPI: SSDT BEEC9F18, 00C8 (r1  APPLE  Cpu1Ist     3000 INTL 20061109)
May  1 16:15:01 kernel: ACPI: SSDT BEEC8F18, 0085 (r1  APPLE  Cpu1Cst     3000 INTL 20061109)
May  1 16:15:01 kernel: ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
May  1 16:15:01 kernel: ACPI: ACPI0007:01 is registered as cooling_device1
May  1 16:15:01 kernel: ACPI: Processor [CPU1] (supports 8 throttling states)
May  1 16:15:01 kernel: Real Time Clock Driver v1.12ac
May  1 16:15:01 kernel: Non-volatile memory driver v1.2
May  1 16:15:01 kernel: Linux agpgart interface v0.103
May  1 16:15:01 kernel: agpgart: Detected an Intel 965GM Chipset.
May  1 16:15:01 kernel: agpgart: Detected 15868K stolen memory.
May  1 16:15:01 kernel: agpgart: AGP aperture is 256M @ 0xc0000000
May  1 16:15:01 kernel: Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
May  1 16:15:01 kernel: brd: module loaded
May  1 16:15:01 kernel: input: Macintosh mouse button emulation as /class/input/input0
May  1 16:15:01 kernel: PNP: No PS/2 controller found. Probing ports directly.
May  1 16:15:01 kernel: i8042.c: No controller found.
May  1 16:15:01 kernel: mice: PS/2 mouse device common for all mice
May  1 16:15:01 kernel: cpuidle: using governor ladder
May  1 16:15:01 kernel: cpuidle: using governor menu
May  1 16:15:01 kernel: usbcore: registered new interface driver hiddev
May  1 16:15:01 kernel: usbcore: registered new interface driver usbhid
May  1 16:15:01 kernel: usbhid: v2.6:USB HID core driver
May  1 16:15:01 kernel: TCP cubic registered
May  1 16:15:01 kernel: Initializing XFRM netlink socket
May  1 16:15:01 kernel: NET: Registered protocol family 17
May  1 16:15:01 kernel: registered taskstats version 1
May  1 16:15:01 kernel: Freeing unused kernel memory: 348k freed
May  1 16:15:01 kernel: Write protecting the kernel read-only data: 3676k
May  1 16:15:01 kernel: Marking TSC unstable due to TSC halts in idle
May  1 16:15:01 kernel: ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 21 (level, low) -> IRQ 21
May  1 16:15:01 kernel: ehci_hcd 0000:00:1a.7: EHCI Host Controller
May  1 16:15:01 kernel: ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
May  1 16:15:01 kernel: ehci_hcd 0000:00:1a.7: debug port 1
May  1 16:15:01 kernel: ehci_hcd 0000:00:1a.7: irq 21, io mem 0xd0704c00
May  1 16:15:01 kernel: ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
May  1 16:15:01 kernel: usb usb1: configuration #1 chosen from 1 choice
May  1 16:15:01 kernel: hub 1-0:1.0: USB hub found
May  1 16:15:01 kernel: hub 1-0:1.0: 4 ports detected
May  1 16:15:01 kernel: ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 20 (level, low) -> IRQ 20
May  1 16:15:01 kernel: ehci_hcd 0000:00:1d.7: EHCI Host Controller
May  1 16:15:01 kernel: ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
May  1 16:15:01 kernel: ehci_hcd 0000:00:1d.7: debug port 1
May  1 16:15:01 kernel: ehci_hcd 0000:00:1d.7: irq 20, io mem 0xd0704800
May  1 16:15:01 kernel: ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
May  1 16:15:01 kernel: usb usb2: configuration #1 chosen from 1 choice
May  1 16:15:01 kernel: hub 2-0:1.0: USB hub found
May  1 16:15:01 kernel: hub 2-0:1.0: 6 ports detected
May  1 16:15:01 kernel: USB Universal Host Controller Interface driver v3.0
May  1 16:15:01 kernel: ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 20 (level, low) -> IRQ 20
May  1 16:15:01 kernel: uhci_hcd 0000:00:1a.0: UHCI Host Controller
May  1 16:15:01 kernel: uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
May  1 16:15:01 kernel: uhci_hcd 0000:00:1a.0: irq 20, io base 0x000060c0
May  1 16:15:01 kernel: usb usb3: configuration #1 chosen from 1 choice
May  1 16:15:01 kernel: hub 3-0:1.0: USB hub found
May  1 16:15:01 kernel: hub 3-0:1.0: 2 ports detected
May  1 16:15:01 kernel: Clocksource tsc unstable (delta = -472139333 ns)
May  1 16:15:01 kernel: hub 1-0:1.0: unable to enumerate USB device on port 1
May  1 16:15:01 kernel: ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 16 (level, low) -> IRQ 16
May  1 16:15:01 kernel: uhci_hcd 0000:00:1a.1: UHCI Host Controller
May  1 16:15:01 kernel: uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
May  1 16:15:01 kernel: uhci_hcd 0000:00:1a.1: irq 16, io base 0x000060a0
May  1 16:15:01 kernel: usb usb4: configuration #1 chosen from 1 choice
May  1 16:15:01 kernel: hub 4-0:1.0: USB hub found
May  1 16:15:01 kernel: hub 4-0:1.0: 2 ports detected
May  1 16:15:01 kernel: ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16
May  1 16:15:01 kernel: uhci_hcd 0000:00:1d.0: UHCI Host Controller
May  1 16:15:01 kernel: uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
May  1 16:15:01 kernel: uhci_hcd 0000:00:1d.0: irq 16, io base 0x00006080
May  1 16:15:01 kernel: usb usb5: configuration #1 chosen from 1 choice
May  1 16:15:01 kernel: hub 5-0:1.0: USB hub found
May  1 16:15:01 kernel: hub 5-0:1.0: 2 ports detected
May  1 16:15:01 kernel: usb 1-2: new high speed USB device using ehci_hcd and address 3
May  1 16:15:01 kernel: ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 18 (level, low) -> IRQ 18
May  1 16:15:01 kernel: uhci_hcd 0000:00:1d.1: UHCI Host Controller
May  1 16:15:01 kernel: uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
May  1 16:15:01 kernel: uhci_hcd 0000:00:1d.1: irq 18, io base 0x00006060
May  1 16:15:01 kernel: usb usb6: configuration #1 chosen from 1 choice
May  1 16:15:01 kernel: hub 6-0:1.0: USB hub found
May  1 16:15:01 kernel: hub 6-0:1.0: 2 ports detected
May  1 16:15:01 kernel: ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 21 (level, low) -> IRQ 21
May  1 16:15:01 kernel: uhci_hcd 0000:00:1d.2: UHCI Host Controller
May  1 16:15:01 kernel: uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
May  1 16:15:01 kernel: uhci_hcd 0000:00:1d.2: irq 21, io base 0x00006040
May  1 16:15:01 kernel: usb usb7: configuration #1 chosen from 1 choice
May  1 16:15:01 kernel: hub 7-0:1.0: USB hub found
May  1 16:15:01 kernel: hub 7-0:1.0: 2 ports detected
May  1 16:15:01 kernel: usb 1-2: configuration #1 chosen from 1 choice
May  1 16:15:01 kernel: hub 1-2:1.0: USB hub found
May  1 16:15:01 kernel: hub 1-2:1.0: 4 ports detected
May  1 16:15:01 kernel: SCSI subsystem initialized
May  1 16:15:01 kernel: Driver 'sd' needs updating - please use bus_type methods
May  1 16:15:01 kernel: ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 21 (level, low) -> IRQ 21
May  1 16:15:01 kernel: scsi0 : ata_piix
May  1 16:15:01 kernel: scsi1 : ata_piix
May  1 16:15:01 kernel: ata1: PATA max UDMA/100 cmd 0x6108 ctl 0x6124 bmdma 0x60e0 irq 21
May  1 16:15:01 kernel: ata2: PATA max UDMA/100 cmd 0x6100 ctl 0x6120 bmdma 0x60e8 irq 21
May  1 16:15:01 kernel: ata1.00: ATAPI: HL-DT-ST DVDRW  GSA-S10N, BP10, max UDMA/33
May  1 16:15:01 kernel: ata1.00: configured for UDMA/33
May  1 16:15:01 kernel: usb 2-4: new high speed USB device using ehci_hcd and address 2
May  1 16:15:01 kernel: usb 2-4: configuration #1 chosen from 1 choice
May  1 16:15:01 kernel: scsi 0:0:0:0: CD-ROM            HL-DT-ST DVDRW  GSA-S10N  BP10 PQ: 0 ANSI: 5
May  1 16:15:01 kernel: ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 18 (level, low) -> IRQ 18
May  1 16:15:01 kernel: ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
May  1 16:15:01 kernel: hub 2-0:1.0: unable to enumerate USB device on port 5
May  1 16:15:01 kernel: ata4294967295: XXX: SCR_READ reg=0 0:0 -> 0
May  1 16:15:01 kernel: ata4294967295: XXX: SCR_READ reg=0 0:0 -> 0
May  1 16:15:01 kernel: ata4294967295: XXX: SCR_READ reg=2 0:0 -> 0
May  1 16:15:01 kernel: ata4294967295: XXX: SCR_READ reg=2 0:0 -> 0
May  1 16:15:01 kernel: ata4294967295: XXX: SCR_READ reg=1 0:0 -> 0
May  1 16:15:01 kernel: ata4294967295: XXX: SCR_READ reg=1 0:0 -> 0
May  1 16:15:01 kernel: ata_piix 0000:00:1f.2: SCR access via SIDPR is available but doesn't work
May  1 16:15:01 kernel: scsi2 : ata_piix
May  1 16:15:01 kernel: scsi3 : ata_piix
May  1 16:15:01 kernel: ata3: SATA max UDMA/133 cmd 0x60f8 ctl 0x611c bmdma 0x6020 irq 18
May  1 16:15:01 kernel: ata4: SATA max UDMA/133 cmd 0x60f0 ctl 0x6118 bmdma 0x6028 irq 18
May  1 16:15:01 kernel: ata3.00: ATA-8: Hitachi HTS542516K9SA00, BBCAC3GP, max UDMA/133
May  1 16:15:01 kernel: ata3.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 0/32)
May  1 16:15:01 kernel: ata3.00: configured for UDMA/133
May  1 16:15:01 kernel: hub 2-0:1.0: unable to enumerate USB device on port 6
May  1 16:15:01 kernel: scsi 2:0:0:0: Direct-Access     ATA      Hitachi HTS54251 BBCA PQ: 0 ANSI: 5
May  1 16:15:01 kernel: sd 2:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
May  1 16:15:01 kernel: sd 2:0:0:0: [sda] Write Protect is off
May  1 16:15:01 kernel: sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
May  1 16:15:01 kernel: sd 2:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
May  1 16:15:01 kernel: sd 2:0:0:0: [sda] Write Protect is off
May  1 16:15:01 kernel: sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
May  1 16:15:01 kernel:  sda:<6>usb 3-1: new full speed USB device using uhci_hcd and address 2
May  1 16:15:01 kernel:  sda1 sda2 sda3 sda4 sda5
May  1 16:15:01 kernel: sd 2:0:0:0: [sda] Attached SCSI disk
May  1 16:15:01 kernel: usb 3-1: configuration #1 chosen from 1 choice
May  1 16:15:01 kernel: drivers/hid/usbhid/hid-core.c: couldn't find an input interrupt endpoint
May  1 16:15:01 kernel: usb 7-1: new low speed USB device using uhci_hcd and address 2
May  1 16:15:01 kernel: usb 7-1: configuration #1 chosen from 1 choice
May  1 16:15:01 kernel: hiddev96hidraw0: USB HID v1.11 Device [Apple Computer, Inc. IR Receiver] on usb-0000:00:1d.2-1
May  1 16:15:01 kernel: usb 7-2: new full speed USB device using uhci_hcd and address 3
May  1 16:15:01 kernel: usb 7-2: configuration #1 chosen from 1 choice
May  1 16:15:01 kernel: input: Apple Computer Apple Internal Keyboard / Trackpad as /class/input/input1
May  1 16:15:01 kernel: input,hidraw1: USB HID v1.11 Keyboard [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.2-2
May  1 16:15:01 kernel: input: Apple Computer Apple Internal Keyboard / Trackpad as /class/input/input2
May  1 16:15:01 kernel: input,hidraw2: USB HID v1.11 Device [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.2-2
May  1 16:15:01 kernel: usb 1-2.1: new low speed USB device using ehci_hcd and address 4
May  1 16:15:01 kernel: usb 1-2.1: configuration #1 chosen from 1 choice
May  1 16:15:01 kernel: input: Microsoft Microsoft 3-Button Mouse with IntelliEye(TM) as /class/input/input3
May  1 16:15:01 kernel: input,hidraw3: USB HID v1.10 Mouse [Microsoft Microsoft 3-Button Mouse with IntelliEye(TM)] on usb-0000:00:1a.7-2.1
May  1 16:15:01 kernel: usb 1-2.2: new low speed USB device using ehci_hcd and address 5
May  1 16:15:01 kernel: usb 1-2.2: configuration #1 chosen from 1 choice
May  1 16:15:01 kernel: input: Logitech Logitech Cordless RumblePad 2 as /class/input/input4
May  1 16:15:01 kernel: Force feedback for Logitech force feedback devices by Johann Deneux <johann.deneux@it.uu.se>
May  1 16:15:01 kernel: input,hidraw4: USB HID v1.10 Gamepad [Logitech Logitech Cordless RumblePad 2] on usb-0000:00:1a.7-2.2
May  1 16:15:01 kernel: kjournald starting.  Commit interval 5 seconds
May  1 16:15:01 kernel: EXT3-fs: mounted filesystem with ordered data mode.
May  1 16:15:01 kernel: SELinux:  Disabled at runtime.
May  1 16:15:01 kernel: type=1404 audit(1209683673.978:2): selinux=0 auid=4294967295 ses=4294967295
May  1 16:15:01 kernel: input: PC Speaker as /class/input/input5
May  1 16:15:01 kernel: ACPI: PCI Interrupt 0000:04:03.0[A] -> GSI 19 (level, low) -> IRQ 19
May  1 16:15:01 kernel: ACPI: AC Adapter [ADP1] (on-line)
May  1 16:15:01 kernel: firewire_ohci: Added fw-ohci device 0000:04:03.0, OHCI version 1.0
May  1 16:15:01 kernel: ACPI: PCI Interrupt 0000:00:1f.3[C] -> GSI 20 (level, low) -> IRQ 20
May  1 16:15:01 kernel: ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
May  1 16:15:01 kernel: sky2 0000:03:00.0: v1.21 addr 0xd0400000 irq 17 Yukon-EC Ultra (0xb4) rev 3
May  1 16:15:01 kernel: sky2 eth0: addr 00:1e:c2:18:d6:c4
May  1 16:15:01 kernel: scsi 0:0:0:0: Attached scsi generic sg0 type 5
May  1 16:15:01 kernel: sd 2:0:0:0: Attached scsi generic sg1 type 0
May  1 16:15:01 kernel: iTCO_vendor_support: vendor-support=0
May  1 16:15:01 kernel: ACPI: Battery Slot [BAT0] (battery present)
May  1 16:15:01 kernel: iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
May  1 16:15:01 kernel: iTCO_wdt: Found a ICH8M TCO device (Version=2, TCOBASE=0x0460)
May  1 16:15:01 kernel: iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
May  1 16:15:01 kernel: proc_dir_entry 'info' already registered
May  1 16:15:01 kernel: Pid: 1099, comm: modprobe Not tainted 2.6.25-git16 #3
May  1 16:15:01 kernel: 
May  1 16:15:01 kernel: Call Trace:
May  1 16:15:01 kernel:  [<ffffffff81118269>] idr_get_new+0xb/0x28
May  1 16:15:01 kernel:  [<ffffffff810d5e92>] proc_register+0xcb/0x14b
May  1 16:15:01 kernel:  [<ffffffff810d5ec5>] proc_register+0xfe/0x14b
May  1 16:15:01 kernel:  [<ffffffff810d5f96>] proc_create_data+0x84/0x9e
May  1 16:15:01 kernel:  [<ffffffffa013dd37>] :video:acpi_video_bus_add+0x98f/0xc6d
May  1 16:15:01 kernel:  [<ffffffff8115d4d9>] acpi_device_probe+0x43/0x91
May  1 16:15:01 kernel:  [<ffffffff81192564>] driver_probe_device+0xd0/0x14d
May  1 16:15:01 kernel:  [<ffffffff81192627>] __driver_attach+0x46/0x6d
May  1 16:15:01 kernel:  [<ffffffff811925e1>] __driver_attach+0x0/0x6d
May  1 16:15:01 kernel:  [<ffffffff81191f09>] bus_for_each_dev+0x44/0x6f
May  1 16:15:01 kernel:  [<ffffffff8119186e>] bus_add_driver+0xb2/0x1ff
May  1 16:15:01 kernel:  [<ffffffff81192846>] driver_register+0x59/0xcd
May  1 16:15:01 kernel:  [<ffffffffa00d803c>] :video:acpi_video_init+0x3c/0x5e
May  1 16:15:01 kernel:  [<ffffffff81052db2>] sys_init_module+0x171a/0x1896
May  1 16:15:01 kernel:  [<ffffffff8115d812>] acpi_bus_register_driver+0x0/0x3e
May  1 16:15:01 kernel:  [<ffffffff81098831>] vfs_read+0xa6/0xfe
May  1 16:15:01 kernel:  [<ffffffff8100bf3b>] system_call_after_swapgs+0x7b/0x80
May  1 16:15:01 kernel: 
May  1 16:15:01 kernel: proc_dir_entry 'info' already registered
May  1 16:15:01 kernel: Pid: 1099, comm: modprobe Not tainted 2.6.25-git16 #3
May  1 16:15:01 kernel: 
May  1 16:15:01 kernel: Call Trace:
May  1 16:15:01 kernel:  [<ffffffff81118269>] idr_get_new+0xb/0x28
May  1 16:15:01 kernel:  [<ffffffff810d5e92>] proc_register+0xcb/0x14b
May  1 16:15:01 kernel:  [<ffffffff810d5edb>] proc_register+0x114/0x14b
May  1 16:15:01 kernel:  [<ffffffff810d5f96>] proc_create_data+0x84/0x9e
May  1 16:15:01 kernel:  [<ffffffffa013dd37>] :video:acpi_video_bus_add+0x98f/0xc6d
May  1 16:15:01 kernel:  [<ffffffff8115d4d9>] acpi_device_probe+0x43/0x91
May  1 16:15:01 kernel:  [<ffffffff81192564>] driver_probe_device+0xd0/0x14d
May  1 16:15:01 kernel:  [<ffffffff81192627>] __driver_attach+0x46/0x6d
May  1 16:15:01 kernel:  [<ffffffff811925e1>] __driver_attach+0x0/0x6d
May  1 16:15:01 kernel:  [<ffffffff81191f09>] bus_for_each_dev+0x44/0x6f
May  1 16:15:01 kernel:  [<ffffffff8119186e>] bus_add_driver+0xb2/0x1ff
May  1 16:15:01 kernel:  [<ffffffff81192846>] driver_register+0x59/0xcd
May  1 16:15:01 kernel:  [<ffffffffa00d803c>] :video:acpi_video_init+0x3c/0x5e
May  1 16:15:01 kernel:  [<ffffffff81052db2>] sys_init_module+0x171a/0x1896
May  1 16:15:01 kernel:  [<ffffffff8115d812>] acpi_bus_register_driver+0x0/0x3e
May  1 16:15:01 kernel:  [<ffffffff81098831>] vfs_read+0xa6/0xfe
May  1 16:15:01 kernel:  [<ffffffff8100bf3b>] system_call_after_swapgs+0x7b/0x80
May  1 16:15:01 kernel: 
May  1 16:15:01 kernel: proc_dir_entry 'state' already registered
May  1 16:15:01 kernel: Pid: 1099, comm: modprobe Not tainted 2.6.25-git16 #3
May  1 16:15:01 kernel: 
May  1 16:15:01 kernel: Call Trace:
May  1 16:15:01 kernel:  [<ffffffff81118269>] idr_get_new+0xb/0x28
May  1 16:15:01 kernel:  [<ffffffff810d5e92>] proc_register+0xcb/0x14b
May  1 16:15:01 kernel:  [<ffffffff810d5edb>] proc_register+0x114/0x14b
May  1 16:15:01 kernel:  [<ffffffff810d5f96>] proc_create_data+0x84/0x9e
May  1 16:15:01 kernel:  [<ffffffffa013dd71>] :video:acpi_video_bus_add+0x9c9/0xc6d
May  1 16:15:01 kernel:  [<ffffffff8115d4d9>] acpi_device_probe+0x43/0x91
May  1 16:15:01 kernel:  [<ffffffff81192564>] driver_probe_device+0xd0/0x14d
May  1 16:15:01 kernel:  [<ffffffff81192627>] __driver_attach+0x46/0x6d
May  1 16:15:01 kernel:  [<ffffffff811925e1>] __driver_attach+0x0/0x6d
May  1 16:15:01 kernel:  [<ffffffff81191f09>] bus_for_each_dev+0x44/0x6f
May  1 16:15:01 kernel:  [<ffffffff8119186e>] bus_add_driver+0xb2/0x1ff
May  1 16:15:01 kernel:  [<ffffffff81192846>] driver_register+0x59/0xcd
May  1 16:15:01 kernel:  [<ffffffffa00d803c>] :video:acpi_video_init+0x3c/0x5e
May  1 16:15:01 kernel:  [<ffffffff81052db2>] sys_init_module+0x171a/0x1896
May  1 16:15:01 kernel:  [<ffffffff8115d812>] acpi_bus_register_driver+0x0/0x3e
May  1 16:15:01 kernel:  [<ffffffff81098831>] vfs_read+0xa6/0xfe
May  1 16:15:01 kernel:  [<ffffffff8100bf3b>] system_call_after_swapgs+0x7b/0x80
May  1 16:15:01 kernel: 
May  1 16:15:01 kernel: proc_dir_entry 'brightness' already registered
May  1 16:15:01 kernel: Pid: 1099, comm: modprobe Not tainted 2.6.25-git16 #3
May  1 16:15:01 kernel: 
May  1 16:15:01 kernel: Call Trace:
May  1 16:15:01 kernel:  [<ffffffff81118269>] idr_get_new+0xb/0x28
May  1 16:15:01 kernel:  [<ffffffff810d5e92>] proc_register+0xcb/0x14b
May  1 16:15:01 kernel:  [<ffffffff810d5edb>] proc_register+0x114/0x14b
May  1 16:15:01 kernel:  [<ffffffff810d5f96>] proc_create_data+0x84/0x9e
May  1 16:15:01 kernel:  [<ffffffffa013dda7>] :video:acpi_video_bus_add+0x9ff/0xc6d
May  1 16:15:01 kernel:  [<ffffffff8115d4d9>] acpi_device_probe+0x43/0x91
May  1 16:15:01 kernel:  [<ffffffff81192564>] driver_probe_device+0xd0/0x14d
May  1 16:15:01 kernel:  [<ffffffff81192627>] __driver_attach+0x46/0x6d
May  1 16:15:01 kernel:  [<ffffffff811925e1>] __driver_attach+0x0/0x6d
May  1 16:15:01 kernel:  [<ffffffff81191f09>] bus_for_each_dev+0x44/0x6f
May  1 16:15:01 kernel:  [<ffffffff8119186e>] bus_add_driver+0xb2/0x1ff
May  1 16:15:01 kernel:  [<ffffffff81192846>] driver_register+0x59/0xcd
May  1 16:15:01 kernel:  [<ffffffffa00d803c>] :video:acpi_video_init+0x3c/0x5e
May  1 16:15:01 kernel:  [<ffffffff81052db2>] sys_init_module+0x171a/0x1896
May  1 16:15:01 kernel:  [<ffffffff8115d812>] acpi_bus_register_driver+0x0/0x3e
May  1 16:15:01 kernel:  [<ffffffff81098831>] vfs_read+0xa6/0xfe
May  1 16:15:01 kernel:  [<ffffffff8100bf3b>] system_call_after_swapgs+0x7b/0x80
May  1 16:15:01 kernel: 
May  1 16:15:01 kernel: proc_dir_entry 'EDID' already registered
May  1 16:15:01 kernel: Pid: 1099, comm: modprobe Not tainted 2.6.25-git16 #3
May  1 16:15:01 kernel: 
May  1 16:15:01 kernel: Call Trace:
May  1 16:15:01 kernel:  [<ffffffff81118269>] idr_get_new+0xb/0x28
May  1 16:15:01 kernel:  [<ffffffff810d5e92>] proc_register+0xcb/0x14b
May  1 16:15:01 kernel:  [<ffffffff810d5edb>] proc_register+0x114/0x14b
May  1 16:15:01 kernel:  [<ffffffff810d5f96>] proc_create_data+0x84/0x9e
May  1 16:15:01 kernel:  [<ffffffffa013ddd2>] :video:acpi_video_bus_add+0xa2a/0xc6d
May  1 16:15:01 kernel:  [<ffffffff8115d4d9>] acpi_device_probe+0x43/0x91
May  1 16:15:01 kernel:  [<ffffffff81192564>] driver_probe_device+0xd0/0x14d
May  1 16:15:01 kernel:  [<ffffffff81192627>] __driver_attach+0x46/0x6d
May  1 16:15:01 kernel:  [<ffffffff811925e1>] __driver_attach+0x0/0x6d
May  1 16:15:01 kernel:  [<ffffffff81191f09>] bus_for_each_dev+0x44/0x6f
May  1 16:15:01 kernel:  [<ffffffff8119186e>] bus_add_driver+0xb2/0x1ff
May  1 16:15:01 kernel:  [<ffffffff81192846>] driver_register+0x59/0xcd
May  1 16:15:01 kernel:  [<ffffffffa00d803c>] :video:acpi_video_init+0x3c/0x5e
May  1 16:15:01 kernel:  [<ffffffff81052db2>] sys_init_module+0x171a/0x1896
May  1 16:15:01 kernel:  [<ffffffff8115d812>] acpi_bus_register_driver+0x0/0x3e
May  1 16:15:01 kernel:  [<ffffffff81098831>] vfs_read+0xa6/0xfe
May  1 16:15:01 kernel:  [<ffffffff8100bf3b>] system_call_after_swapgs+0x7b/0x80
May  1 16:15:01 kernel: 
May  1 16:15:01 kernel: proc_dir_entry 'info' already registered
May  1 16:15:01 kernel: Pid: 1099, comm: modprobe Not tainted 2.6.25-git16 #3
May  1 16:15:01 kernel: 
May  1 16:15:01 kernel: Call Trace:
May  1 16:15:01 kernel:  [<ffffffff81118269>] idr_get_new+0xb/0x28
May  1 16:15:01 kernel:  [<ffffffff810d5e92>] proc_register+0xcb/0x14b
May  1 16:15:01 kernel:  [<ffffffff810d5edb>] proc_register+0x114/0x14b
May  1 16:15:01 kernel:  [<ffffffff810d5f96>] proc_create_data+0x84/0x9e
May  1 16:15:01 kernel:  [<ffffffffa013dd37>] :video:acpi_video_bus_add+0x98f/0xc6d
May  1 16:15:01 kernel:  [<ffffffff8115d4d9>] acpi_device_probe+0x43/0x91
May  1 16:15:01 kernel:  [<ffffffff81192564>] driver_probe_device+0xd0/0x14d
May  1 16:15:01 kernel:  [<ffffffff81192627>] __driver_attach+0x46/0x6d
May  1 16:15:01 kernel:  [<ffffffff811925e1>] __driver_attach+0x0/0x6d
May  1 16:15:01 kernel:  [<ffffffff81191f09>] bus_for_each_dev+0x44/0x6f
May  1 16:15:01 kernel:  [<ffffffff8119186e>] bus_add_driver+0xb2/0x1ff
May  1 16:15:01 kernel:  [<ffffffff81192846>] driver_register+0x59/0xcd
May  1 16:15:01 kernel:  [<ffffffffa00d803c>] :video:acpi_video_init+0x3c/0x5e
May  1 16:15:01 kernel:  [<ffffffff81052db2>] sys_init_module+0x171a/0x1896
May  1 16:15:01 kernel:  [<ffffffff8115d812>] acpi_bus_register_driver+0x0/0x3e
May  1 16:15:01 kernel:  [<ffffffff81098831>] vfs_read+0xa6/0xfe
May  1 16:15:01 kernel:  [<ffffffff8100bf3b>] system_call_after_swapgs+0x7b/0x80
May  1 16:15:01 kernel: 
May  1 16:15:01 kernel: proc_dir_entry 'state' already registered
May  1 16:15:01 kernel: Pid: 1099, comm: modprobe Not tainted 2.6.25-git16 #3
May  1 16:15:01 kernel: 
May  1 16:15:01 kernel: Call Trace:
May  1 16:15:01 kernel:  [<ffffffff81118269>] idr_get_new+0xb/0x28
May  1 16:15:01 kernel:  [<ffffffff810d5e92>] proc_register+0xcb/0x14b
May  1 16:15:01 kernel:  [<ffffffff810d5edb>] proc_register+0x114/0x14b
May  1 16:15:01 kernel:  [<ffffffff810d5f96>] proc_create_data+0x84/0x9e
May  1 16:15:01 kernel:  [<ffffffffa013dd71>] :video:acpi_video_bus_add+0x9c9/0xc6d
May  1 16:15:01 kernel:  [<ffffffff8115d4d9>] acpi_device_probe+0x43/0x91
May  1 16:15:01 kernel:  [<ffffffff81192564>] driver_probe_device+0xd0/0x14d
May  1 16:15:01 kernel:  [<ffffffff81192627>] __driver_attach+0x46/0x6d
May  1 16:15:01 kernel:  [<ffffffff811925e1>] __driver_attach+0x0/0x6d
May  1 16:15:01 kernel:  [<ffffffff81191f09>] bus_for_each_dev+0x44/0x6f
May  1 16:15:01 kernel:  [<ffffffff8119186e>] bus_add_driver+0xb2/0x1ff
May  1 16:15:01 kernel:  [<ffffffff81192846>] driver_register+0x59/0xcd
May  1 16:15:01 kernel:  [<ffffffffa00d803c>] :video:acpi_video_init+0x3c/0x5e
May  1 16:15:01 kernel:  [<ffffffff81052db2>] sys_init_module+0x171a/0x1896
May  1 16:15:01 kernel:  [<ffffffff8115d812>] acpi_bus_register_driver+0x0/0x3e
May  1 16:15:01 kernel:  [<ffffffff81098831>] vfs_read+0xa6/0xfe
May  1 16:15:01 kernel:  [<ffffffff8100bf3b>] system_call_after_swapgs+0x7b/0x80
May  1 16:15:01 kernel: 
May  1 16:15:01 kernel: proc_dir_entry 'brightness' already registered
May  1 16:15:01 kernel: Pid: 1099, comm: modprobe Not tainted 2.6.25-git16 #3
May  1 16:15:01 kernel: 
May  1 16:15:01 kernel: Call Trace:
May  1 16:15:01 kernel:  [<ffffffff81118269>] idr_get_new+0xb/0x28
May  1 16:15:01 kernel:  [<ffffffff810d5e92>] proc_register+0xcb/0x14b
May  1 16:15:01 kernel:  [<ffffffff810d5edb>] proc_register+0x114/0x14b
May  1 16:15:01 kernel:  [<ffffffff810d5f96>] proc_create_data+0x84/0x9e
May  1 16:15:01 kernel:  [<ffffffffa013dda7>] :video:acpi_video_bus_add+0x9ff/0xc6d
May  1 16:15:01 kernel:  [<ffffffff8115d4d9>] acpi_device_probe+0x43/0x91
May  1 16:15:01 kernel:  [<ffffffff81192564>] driver_probe_device+0xd0/0x14d
May  1 16:15:01 kernel:  [<ffffffff81192627>] __driver_attach+0x46/0x6d
May  1 16:15:01 kernel:  [<ffffffff811925e1>] __driver_attach+0x0/0x6d
May  1 16:15:01 kernel:  [<ffffffff81191f09>] bus_for_each_dev+0x44/0x6f
May  1 16:15:01 kernel:  [<ffffffff8119186e>] bus_add_driver+0xb2/0x1ff
May  1 16:15:01 kernel:  [<ffffffff81192846>] driver_register+0x59/0xcd
May  1 16:15:01 kernel:  [<ffffffffa00d803c>] :video:acpi_video_init+0x3c/0x5e
May  1 16:15:01 kernel:  [<ffffffff81052db2>] sys_init_module+0x171a/0x1896
May  1 16:15:01 kernel:  [<ffffffff8115d812>] acpi_bus_register_driver+0x0/0x3e
May  1 16:15:01 kernel:  [<ffffffff81098831>] vfs_read+0xa6/0xfe
May  1 16:15:01 kernel:  [<ffffffff8100bf3b>] system_call_after_swapgs+0x7b/0x80
May  1 16:15:01 kernel: 
May  1 16:15:01 kernel: proc_dir_entry 'EDID' already registered
May  1 16:15:01 kernel: Pid: 1099, comm: modprobe Not tainted 2.6.25-git16 #3
May  1 16:15:01 kernel: 
May  1 16:15:01 kernel: Call Trace:
May  1 16:15:01 kernel:  [<ffffffff81118269>] idr_get_new+0xb/0x28
May  1 16:15:01 kernel:  [<ffffffff810d5e92>] proc_register+0xcb/0x14b
May  1 16:15:01 kernel:  [<ffffffff810d5edb>] proc_register+0x114/0x14b
May  1 16:15:01 kernel:  [<ffffffff810d5f96>] proc_create_data+0x84/0x9e
May  1 16:15:01 kernel:  [<ffffffffa013ddd2>] :video:acpi_video_bus_add+0xa2a/0xc6d
May  1 16:15:01 kernel:  [<ffffffff8115d4d9>] acpi_device_probe+0x43/0x91
May  1 16:15:01 kernel:  [<ffffffff81192564>] driver_probe_device+0xd0/0x14d
May  1 16:15:01 kernel:  [<ffffffff81192627>] __driver_attach+0x46/0x6d
May  1 16:15:01 kernel:  [<ffffffff811925e1>] __driver_attach+0x0/0x6d
May  1 16:15:01 kernel:  [<ffffffff81191f09>] bus_for_each_dev+0x44/0x6f
May  1 16:15:01 kernel:  [<ffffffff8119186e>] bus_add_driver+0xb2/0x1ff
May  1 16:15:01 kernel:  [<ffffffff81192846>] driver_register+0x59/0xcd
May  1 16:15:01 kernel:  [<ffffffffa00d803c>] :video:acpi_video_init+0x3c/0x5e
May  1 16:15:01 kernel:  [<ffffffff81052db2>] sys_init_module+0x171a/0x1896
May  1 16:15:01 kernel:  [<ffffffff8115d812>] acpi_bus_register_driver+0x0/0x3e
May  1 16:15:01 kernel:  [<ffffffff81098831>] vfs_read+0xa6/0xfe
May  1 16:15:01 kernel:  [<ffffffff8100bf3b>] system_call_after_swapgs+0x7b/0x80
May  1 16:15:01 kernel: 
May  1 16:15:01 kernel: input: Video Bus as /class/input/input6
May  1 16:15:01 kernel: ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
May  1 16:15:01 kernel: appletouch: Geyser mode initialized.
May  1 16:15:01 kernel: input: appletouch as /class/input/input7
May  1 16:15:01 kernel: usbcore: registered new interface driver appletouch
May  1 16:15:01 kernel: input: Power Button (FF) as /class/input/input8
May  1 16:15:01 kernel: ACPI: Power Button (FF) [PWRF]
May  1 16:15:01 kernel: input: Lid Switch as /class/input/input9
May  1 16:15:01 kernel: ACPI: Lid Switch [LID0]
May  1 16:15:01 kernel: input: Power Button (CM) as /class/input/input10
May  1 16:15:01 kernel: ACPI: Power Button (CM) [PWRB]
May  1 16:15:01 kernel: input: Sleep Button (CM) as /class/input/input11
May  1 16:15:01 kernel: ACPI: Sleep Button (CM) [SLPB]
May  1 16:15:01 kernel: firewire_core: created device fw0: GUID 001f5bfffe22002e, S400
May  1 16:15:01 kernel: Driver 'sr' needs updating - please use bus_type methods
May  1 16:15:01 kernel: sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda caddy
May  1 16:15:01 kernel: Uniform CD-ROM driver Revision: 3.20
May  1 16:15:01 kernel: ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 20 (level, low) -> IRQ 20
May  1 16:15:01 kernel: applesmc: Apple MacBook detected:
May  1 16:15:01 kernel: applesmc:  - Model with accelerometer
May  1 16:15:01 kernel: applesmc:  - Model without light sensors and backlight
May  1 16:15:01 kernel: applesmc:  - Model with 10 temperature sensors
May  1 16:15:01 kernel: applesmc: wait status failed: c != 8
May  1 16:15:11 kernel:last message repeated 99 times
May  1 16:15:01 kernel: applesmc: failed to init the device
May  1 16:15:01 kernel: applesmc: 1 fans found.
May  1 16:15:01 kernel: applesmc: wait status failed: c != 8
May  1 16:15:01 kernel: input: applesmc as /class/input/input12
May  1 16:15:01 kernel: applesmc: driver successfully loaded.
May  1 16:15:01 kernel: NET: Registered protocol family 10
May  1 16:15:01 kernel: lo: Disabled Privacy Extensions
May  1 16:15:01 kernel: ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
May  1 16:15:01 kernel: device-mapper: uevent: version 1.0.3
May  1 16:15:01 kernel: device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
May  1 16:15:01 kernel: device-mapper: multipath: version 1.0.5 loaded
May  1 16:15:01 kernel: EXT3 FS on sda3, internal journal
May  1 16:15:01 kernel: kjournald starting.  Commit interval 5 seconds
May  1 16:15:01 kernel: EXT3 FS on sda5, internal journal
May  1 16:15:01 kernel: EXT3-fs: mounted filesystem with ordered data mode.
May  1 16:15:01 kernel: Adding 2096472k swap on /dev/sda4.  Priority:-1 extents:1 across:2096472k
May  1 16:15:01 kernel: firmware: requesting intel-ucode/06-17-06
May  1 16:15:01 kernel: firmware: requesting intel-ucode/06-17-06
May  1 16:15:01 kernel: IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
May  1 16:15:01 kernel: warning: process `kudzu' used the deprecated sysctl system call with 1.23.
May  1 16:15:01 kernel: ip6_tables: (C) 2000-2006 Netfilter Core Team
May  1 16:15:01 kernel: nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
May  1 16:15:01 kernel: ip_tables: (C) 2000-2006 Netfilter Core Team
May  1 16:15:01 kernel: RPC: Registered udp transport module.
May  1 16:15:01 kernel: RPC: Registered tcp transport module.
May  1 16:15:01 kernel: Bluetooth: Core ver 2.11
May  1 16:15:01 kernel: NET: Registered protocol family 31
May  1 16:15:01 kernel: Bluetooth: HCI device and connection manager initialized
May  1 16:15:01 kernel: Bluetooth: HCI socket layer initialized
May  1 16:15:01 kernel: Bluetooth: L2CAP ver 2.9
May  1 16:15:01 kernel: Bluetooth: L2CAP socket layer initialized
May  1 16:15:01 kernel: Bluetooth: RFCOMM socket layer initialized
May  1 16:15:01 kernel: Bluetooth: RFCOMM TTY layer initialized
May  1 16:15:01 kernel: Bluetooth: RFCOMM ver 1.8
May  1 16:15:01 kernel: hub 1-0:1.0: unable to enumerate USB device on port 1
May  1 16:15:01 kernel: usb 3-1: USB disconnect, address 2
May  1 16:15:01 kernel: usb 3-1: new full speed USB device using uhci_hcd and address 3
May  1 16:15:01 kernel: usb 3-1: configuration #1 chosen from 1 choice
May  1 16:15:01 kernel: Bluetooth: HCI USB driver ver 2.9
May  1 16:15:01 kernel: usbcore: registered new interface driver hci_usb
May  1 16:15:01 kernel: fuse init (API version 7.9)
May  1 16:15:01 pommed[2023]: DBus system bus connection failed: Failed to connect to socket /var/run/dbus/system_bus_socket: No such file or directory
May  1 16:15:01 kernel: warning: `dbus-daemon' uses 32-bit capabilities (legacy support in use)
May  1 16:15:02 automount[2158]: lookup_read_master: lookup(nisplus): couldn't locate nis+ table auto.master
May  1 16:15:02 acpid: starting up
May  1 16:15:04 avahi-daemon[2327]: Found user 'avahi' (UID 498) and group 'avahi' (GID 494).
May  1 16:15:04 avahi-daemon[2327]: Successfully dropped root privileges.
May  1 16:15:04 avahi-daemon[2327]: avahi-daemon 0.6.21 starting up.
May  1 16:15:04 avahi-daemon[2327]: WARNING: No NSS support for mDNS detected, consider installing nss-mdns!
May  1 16:15:04 avahi-daemon[2327]: Successfully called chroot().
May  1 16:15:04 avahi-daemon[2327]: Successfully dropped remaining capabilities.
May  1 16:15:04 avahi-daemon[2327]: Loading service file /services/ssh.service.
May  1 16:15:04 avahi-daemon[2327]: Network interface enumeration completed.
May  1 16:15:04 avahi-daemon[2327]: Registering HINFO record with values 'X86_64'/'LINUX'.
May  1 16:15:04 avahi-daemon[2327]: Server startup complete. Host name is .local. Local service cookie is 721604805.
May  1 16:15:04 avahi-daemon[2327]: Service "" (/services/ssh.service) successfully established.
May  1 16:15:07 acpid: client connected from 2378[68:68]
May  1 16:15:09 NetworkManager: <info>  starting...
May  1 16:15:09 NetworkManager: <info>  eth0: Device is fully-supported using driver 'sky2'.
May  1 16:15:09 NetworkManager: <info>  Now managing wired Ethernet (802.3) device 'eth0'.
May  1 16:15:09 NetworkManager: <info>  Bringing up device eth0
May  1 16:15:09 kernel: sky2 eth0: enabling interface
May  1 16:15:09 kernel: ADDRCONF(NETDEV_UP): eth0: link is not ready
May  1 16:15:09 NetworkManager: <info>  Deactivating device eth0.
May  1 16:15:09 NetworkManager: <info>  (eth0): exported as /org/freedesktop/Hal/devices/net_00_1e_c2_18_d6_c4
May  1 16:15:09 NetworkManager: <info>  Trying to start the supplicant...
May  1 16:15:09 NetworkManager: <info>  Trying to start the system settings daemon...
May  1 16:15:09 NetworkManager: <info>  (eth0) supplicant interface is now in state 1 (from 0).
May  1 16:15:09 NetworkManager: <info>  (eth0) supplicant interface is now in state 2 (from 1).
May  1 16:15:09 init: open(/dev/pts/0): No such file or directory
May  1 16:15:11 init:last message repeated 5 times
May  1 16:15:11 pcscd: winscard.c:219:SCardConnect() Reader E-Gate 0 0 Not Found
May  1 16:15:11 pcscd:last message repeated 3 times
May  1 16:15:11 acpid: client connected from 2615[0:0]
May  1 16:15:13 kernel: [drm] Initialized drm 1.1.0 20060810
May  1 16:15:13 kernel: [drm] Initialized i915 1.6.0 20060119 on minor 0
May  1 16:15:24 gconfd (ryanroth-2739): starting (version 2.20.1), pid 2739 user 'ryanroth'
May  1 16:15:24 gconfd (ryanroth-2739): Resolved address "xml:readonly:/etc/gconf/gconf.xml.mandatory" to a read-only configuration source at position 0
May  1 16:15:24 gconfd (ryanroth-2739): Resolved address "xml:readwrite:/home/ryanroth/.gconf" to a writable configuration source at position 1
May  1 16:15:24 gconfd (ryanroth-2739): Resolved address "xml:readonly:/etc/gconf/gconf.xml.defaults" to a read-only configuration source at position 2
May  1 16:15:26 pulseaudio[2747]: polkit.c: Failed to show grant dialog: Unable to lookup exe for caller
May  1 16:15:26 pulseaudio[2747]: polkit.c: PolicyKit responded with 'auth_admin_keep_always'
May  1 16:15:26 pulseaudio[2747]: main.c: Called SUID root and real-time/high-priority scheduling was requested in the configuration. However, we lack the necessary priviliges:
May  1 16:15:26 pulseaudio[2747]: main.c: We are not in group 'pulse-rt' and PolicyKit refuse to grant us priviliges. Dropping SUID again.
May  1 16:15:26 pulseaudio[2747]: main.c: For enabling real-time scheduling please acquire the appropriate PolicyKit priviliges, or become a member of 'pulse-rt', or increase the RLIMIT_NICE/RLIMIT_RTPRIO resource limits for this user.
May  1 16:15:26 pulseaudio[2747]: pid.c: Stale PID file, overwriting.
May  1 16:15:26 pulseaudio[2747]: main.c: setrlimit(RLIMIT_NICE, (31, 31)) failed: Operation not permitted
May  1 16:15:26 pulseaudio[2747]: main.c: setrlimit(RLIMIT_RTPRIO, (9, 9)) failed: Operation not permitted
May  1 16:15:29 gconfd (ryanroth-2739): Resolved address "xml:readwrite:/home/ryanroth/.gconf" to a writable configuration source at position 0

--------------010401070104000905030004--
