Return-Path: <linux-kernel-owner+w=401wt.eu-S1761979AbXHXNyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761979AbXHXNyc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 09:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbXHXNyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 09:54:24 -0400
Received: from tisolutions.biz ([62.253.227.66]:1923 "EHLO
	sideshow-bob.tisolutions.biz" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751163AbXHXNyX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 09:54:23 -0400
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Aug 2007 09:54:21 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.0.6487.1
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: "exception Emask: 0x42" errors with 2.6.22.x and SATA drives
Date: Fri, 24 Aug 2007 14:39:10 +0100
Message-ID: <94439DDF32D7464A916B5068EFF76B3B0225E6AD@bart.tisolutions.biz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: "exception Emask: 0x42" errors with 2.6.22.x and SATA drives
Thread-Index: AcfmVCShfB2QfMvjQpybYdbqloSgxQ==
From: "Dermot Bradley" <dermot.bradley@sla-mobile.com>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've just built a new machine using a ASUS M2A-VM boardboard (ATI SB600
chipset), AMD X2 3800+ processor, and 2 Western Digital 2.5" 80Gb drives
running in RAID-1 using MD. I've had these problems with both 2.6.22.1
and now 2.6.22.5 kernels.

I'm getting the following errors on occasion:

Aug 24 13:19:22 playpbx kernel: APIC error on CPU0: 00(40)
Aug 24 13:19:33 playpbx kernel: APIC error on CPU0: 40(40)
Aug 24 13:20:01 playpbx last message repeated 5 times
Aug 24 13:20:54 playpbx last message repeated 2 times
Aug 24 13:21:40 playpbx kernel: APIC error on CPU0: 40(40)
Aug 24 13:23:23 playpbx kernel: APIC error on CPU0: 40(40)
Aug 24 13:24:35 playpbx kernel: APIC error on CPU0: 40(40)
Aug 24 13:25:51 playpbx kernel: APIC error on CPU0: 40(40)
Aug 24 13:26:37 playpbx kernel: APIC error on CPU0: 40(40)
Aug 24 13:29:11 playpbx kernel: APIC error on CPU0: 40(40)
Aug 24 13:30:01 playpbx last message repeated 4 times
Aug 24 13:30:46 playpbx kernel: APIC error on CPU0: 40(40)
Aug 24 13:32:21 playpbx last message repeated 2 times
Aug 24 13:33:33 playpbx last message repeated 2 times
Aug 24 13:35:14 playpbx kernel: APIC error on CPU0: 40(40)
Aug 24 13:36:10 playpbx last message repeated 3 times
Aug 24 13:37:04 playpbx last message repeated 2 times
Aug 24 13:38:25 playpbx last message repeated 2 times
Aug 24 13:38:43 playpbx kernel: APIC error on CPU0: 40(40)
Aug 24 13:40:08 playpbx last message repeated 3 times
Aug 24 13:40:57 playpbx kernel: APIC error on CPU0: 40(40)
Aug 24 13:42:28 playpbx kernel: APIC error on CPU0: 40(40)
Aug 24 13:43:37 playpbx kernel: APIC error on CPU0: 40(40)
Aug 24 13:45:04 playpbx kernel: APIC error on CPU0: 40(40)
Aug 24 13:45:11 playpbx kernel: APIC error on CPU0: 40(40)
Aug 24 13:46:47 playpbx last message repeated 2 times
Aug 24 13:47:33 playpbx kernel: APIC error on CPU0: 40(40)
Aug 24 13:48:15 playpbx kernel: APIC error on CPU0: 40(40)
Aug 24 13:49:56 playpbx kernel: APIC error on CPU0: 40(40)
Aug 24 13:51:34 playpbx kernel: APIC error on CPU0: 40(40)
Aug 24 13:51:44 playpbx kernel: APIC error on CPU0: 40(40)
Aug 24 13:53:28 playpbx last message repeated 2 times
Aug 24 13:54:02 playpbx kernel: APIC error on CPU0: 40(40)
Aug 24 13:55:31 playpbx kernel: ata3.00: exception Emask 0x42 SAct
0x7fc77 SErr0x800 action 0x6 frozen
Aug 24 13:55:31 playpbx kernel: ata3.00: (spurious completions during
NCQ issue=0x0 SAct=0x7fc77 FIS=004040a1:00000008)
Aug 24 13:55:31 playpbx kernel: ata3.00: cmd
61/08:00:9a:b7:fc/00:00:04:00:00/40 tag 0 cdb 0x0 data 4096 out
Aug 24 13:55:31 playpbx kernel:          res
40/00:34:4a:c0:fc/00:00:04:00:00/40 Emask 0x42 (HSM violation)
Aug 24 13:55:31 playpbx kernel: ata3.00: cmd
61/08:08:72:ba:fc/00:00:04:00:00/40 tag 1 cdb 0x0 data 4096 out
Aug 24 13:55:31 playpbx kernel:          res
40/00:34:4a:c0:fc/00:00:04:00:00/40 Emask 0x42 (HSM violation)
Aug 24 13:55:31 playpbx kernel: ata3.00: cmd
61/10:10:f2:bd:fc/00:00:04:00:00/40 tag 2 cdb 0x0 data 8192 out
Aug 24 13:55:31 playpbx kernel:          res
40/00:34:4a:c0:fc/00:00:04:00:00/40 Emask 0x42 (HSM violation)
Aug 24 13:55:31 playpbx kernel: ata3.00: cmd
61/08:20:8a:be:fc/00:00:04:00:00/40 tag 4 cdb 0x0 data 4096 out
Aug 24 13:55:31 playpbx kernel:          res
40/00:34:4a:c0:fc/00:00:04:00:00/40 Emask 0x42 (HSM violation)
Aug 24 13:55:31 playpbx kernel: ata3.00: cmd
61/08:28:12:bf:fc/00:00:04:00:00/40 tag 5 cdb 0x0 data 4096 out
Aug 24 13:55:31 playpbx kernel:          res
40/00:34:4a:c0:fc/00:00:04:00:00/40 Emask 0x42 (HSM violation)
Aug 24 13:55:31 playpbx kernel: ata3.00: cmd
61/10:30:4a:c0:fc/00:00:04:00:00/40 tag 6 cdb 0x0 data 8192 out
Aug 24 13:55:31 playpbx kernel:          res
40/00:34:4a:c0:fc/00:00:04:00:00/40 Emask 0x42 (HSM violation)
Aug 24 13:55:31 playpbx kernel: ata3.00: cmd
61/08:50:4a:b5:fc/00:00:04:00:00/40 tag 10 cdb 0x0 data 4096 out
Aug 24 13:55:31 playpbx kernel:          res
40/00:34:4a:c0:fc/00:00:04:00:00/40 Emask 0x42 (HSM violation)
Aug 24 13:55:31 playpbx kernel: ata3.00: cmd
61/08:58:d2:b5:fc/00:00:04:00:00/40 tag 11 cdb 0x0 data 4096 out
Aug 24 13:55:31 playpbx kernel:          res
40/00:34:4a:c0:fc/00:00:04:00:00/40 Emask 0x42 (HSM violation)
Aug 24 13:55:31 playpbx kernel: ata3.00: cmd
61/10:60:02:b7:fc/00:00:04:00:00/40 tag 12 cdb 0x0 data 8192 out
Aug 24 13:55:31 playpbx kernel:          res
40/00:34:4a:c0:fc/00:00:04:00:00/40 Emask 0x42 (HSM violation)
Aug 24 13:55:31 playpbx kernel: ata3.00: cmd
61/08:68:22:b8:fc/00:00:04:00:00/40 tag 13 cdb 0x0 data 4096 out
Aug 24 13:55:31 playpbx kernel:          res
40/00:34:4a:c0:fc/00:00:04:00:00/40 Emask 0x42 (HSM violation)
Aug 24 13:55:31 playpbx kernel: ata3.00: cmd
61/10:70:52:b9:fc/00:00:04:00:00/40 tag 14 cdb 0x0 data 8192 out
Aug 24 13:55:31 playpbx kernel:          res
40/00:34:4a:c0:fc/00:00:04:00:00/40 Emask 0x42 (HSM violation)
Aug 24 13:55:31 playpbx kernel: ata3.00: cmd
61/08:78:ea:b9:fc/00:00:04:00:00/40 tag 15 cdb 0x0 data 4096 out
Aug 24 13:55:31 playpbx kernel:          res
40/00:34:4a:c0:fc/00:00:04:00:00/40 Emask 0x42 (HSM violation)
Aug 24 13:55:31 playpbx kernel: ata3.00: cmd
61/10:80:a2:bb:fc/00:00:04:00:00/40 tag 16 cdb 0x0 data 8192 out
Aug 24 13:55:31 playpbx kernel:          res
40/00:34:4a:c0:fc/00:00:04:00:00/40 Emask 0x42 (HSM violation)
Aug 24 13:55:31 playpbx kernel: ata3.00: cmd
61/08:88:3a:bc:fc/00:00:04:00:00/40 tag 17 cdb 0x0 data 4096 out
Aug 24 13:55:31 playpbx kernel:          res
40/00:34:4a:c0:fc/00:00:04:00:00/40 Emask 0x42 (HSM violation)
Aug 24 13:55:31 playpbx kernel: ata3.00: cmd
61/08:90:c2:bc:fc/00:00:04:00:00/40 tag 18 cdb 0x0 data 4096 out
Aug 24 13:55:31 playpbx kernel:          res
40/00:34:4a:c0:fc/00:00:04:00:00/40 Emask 0x42 (HSM violation)
Aug 24 13:55:31 playpbx kernel: ata3: hard resetting port
Aug 24 13:55:32 playpbx kernel: ata3: SATA link up 1.5 Gbps (SStatus 113
SControl 300)
Aug 24 13:55:32 playpbx kernel: ata3.00: configured for UDMA/133
Aug 24 13:55:32 playpbx kernel: ata3: EH complete
Aug 24 13:55:32 playpbx kernel: sd 2:0:0:0: [sdb] 156301488 512-byte
hardware sectors (80026 MB)
Aug 24 13:55:32 playpbx kernel: sd 2:0:0:0: [sdb] Write Protect is off
Aug 24 13:55:32 playpbx kernel: sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00
00
Aug 24 13:55:32 playpbx kernel: sd 2:0:0:0: [sdb] Write cache: enabled,
read cache: enabled, doesn't support DPO or FUA
Aug 24 13:56:39 playpbx kernel: APIC error on CPU0: 40(40)
Aug 24 13:57:23 playpbx kernel: APIC error on CPU0: 40(40)
Aug 24 13:58:08 playpbx last message repeated 2 times
Aug 24 13:59:52 playpbx kernel: APIC error on CPU0: 40(40)
Aug 24 14:00:52 playpbx last message repeated 3 times
Aug 24 14:01:59 playpbx kernel: APIC error on CPU0: 40(40)
Aug 24 14:02:24 playpbx last message repeated 2 times
Aug 24 14:03:52 playpbx last message repeated 3 times
Aug 24 14:05:08 playpbx kernel: APIC error on CPU0: 40(40)
Aug 24 14:05:17 playpbx kernel: APIC error on CPU0: 40(40)
Aug 24 14:05:19 playpbx kernel: ata1.00: exception Emask 0x2 SAct
0x41ffe SErr 0x0 action 0x2 frozen
Aug 24 14:05:19 playpbx kernel: ata1.00: (spurious completions during
NCQ issue=0x0 SAct=0x41ffe FIS=004040a1:00020000)
Aug 24 14:05:19 playpbx kernel: ata1.00: cmd
61/08:08:52:9e:fc/00:00:04:00:00/40 tag 1 cdb 0x0 data 4096 out
Aug 24 14:05:19 playpbx kernel:          res
40/00:64:2a:87:fc/00:00:04:00:00/40 Emask 0x2 (HSM violation)
Aug 24 14:05:19 playpbx kernel: ata1.00: cmd
61/08:10:e2:a2:fc/00:00:04:00:00/40 tag 2 cdb 0x0 data 4096 out
Aug 24 14:05:19 playpbx kernel:          res
40/00:64:2a:87:fc/00:00:04:00:00/40 Emask 0x2 (HSM violation)
Aug 24 14:05:19 playpbx kernel: ata1.00: cmd
61/08:18:72:a7:fc/00:00:04:00:00/40 tag 3 cdb 0x0 data 4096 out
Aug 24 14:05:19 playpbx kernel:          res
40/00:64:2a:87:fc/00:00:04:00:00/40 Emask 0x2 (HSM violation)
Aug 24 14:05:19 playpbx kernel: ata1.00: cmd
61/08:20:6a:97:fc/00:00:04:00:00/40 tag 4 cdb 0x0 data 4096 out
Aug 24 14:05:19 playpbx kernel:          res
40/00:64:2a:87:fc/00:00:04:00:00/40 Emask 0x2 (HSM violation)
Aug 24 14:05:19 playpbx kernel: ata1.00: cmd
61/08:28:0a:ac:fc/00:00:04:00:00/40 tag 5 cdb 0x0 data 4096 out
Aug 24 14:05:19 playpbx kernel:          res
40/00:64:2a:87:fc/00:00:04:00:00/40 Emask 0x2 (HSM violation)
Aug 24 14:05:19 playpbx kernel: ata1.00: cmd
61/08:30:62:b2:fc/00:00:04:00:00/40 tag 6 cdb 0x0 data 4096 out
Aug 24 14:05:19 playpbx kernel:          res
40/00:64:2a:87:fc/00:00:04:00:00/40 Emask 0x2 (HSM violation)
Aug 24 14:05:19 playpbx kernel: ata1.00: cmd
61/08:38:b2:b4:fc/00:00:04:00:00/40 tag 7 cdb 0x0 data 4096 out
Aug 24 14:05:19 playpbx kernel:          res
40/00:64:2a:87:fc/00:00:04:00:00/40 Emask 0x2 (HSM violation)
Aug 24 14:05:19 playpbx kernel: ata1.00: cmd
61/08:40:02:b7:fc/00:00:04:00:00/40 tag 8 cdb 0x0 data 4096 out
Aug 24 14:05:19 playpbx kernel:          res
40/00:64:2a:87:fc/00:00:04:00:00/40 Emask 0x2 (HSM violation)
Aug 24 14:05:19 playpbx kernel: ata1.00: cmd
61/08:48:52:b9:fc/00:00:04:00:00/40 tag 9 cdb 0x0 data 4096 out
Aug 24 14:05:19 playpbx kernel:          res
40/00:64:2a:87:fc/00:00:04:00:00/40 Emask 0x2 (HSM violation)
Aug 24 14:05:19 playpbx kernel: ata1.00: cmd
61/08:50:a2:bb:fc/00:00:04:00:00/40 tag 10 cdb 0x0 data 4096 out
Aug 24 14:05:19 playpbx kernel:          res
40/00:64:2a:87:fc/00:00:04:00:00/40 Emask 0x2 (HSM violation)
Aug 24 14:05:19 playpbx kernel: ata1.00: cmd
61/08:58:f2:bd:fc/00:00:04:00:00/40 tag 11 cdb 0x0 data 4096 out
Aug 24 14:05:19 playpbx kernel:          res
40/00:64:2a:87:fc/00:00:04:00:00/40 Emask 0x2 (HSM violation)
Aug 24 14:05:19 playpbx kernel: ata1.00: cmd
61/08:60:2a:87:fc/00:00:04:00:00/40 tag 12 cdb 0x0 data 4096 out
Aug 24 14:05:19 playpbx kernel:          res
40/00:64:2a:87:fc/00:00:04:00:00/40 Emask 0x2 (HSM violation)
Aug 24 14:05:19 playpbx kernel: ata1.00: cmd
61/08:90:c2:99:fc/00:00:04:00:00/40 tag 18 cdb 0x0 data 4096 out
Aug 24 14:05:19 playpbx kernel:          res
40/00:64:2a:87:fc/00:00:04:00:00/40 Emask 0x2 (HSM violation)
Aug 24 14:05:19 playpbx kernel: ata1: soft resetting port
Aug 24 14:05:20 playpbx kernel: ata1: SATA link up 1.5 Gbps (SStatus 113
SControl 300)
Aug 24 14:05:20 playpbx kernel: ata1.00: configured for UDMA/133
Aug 24 14:05:20 playpbx kernel: ata1: EH complete
Aug 24 14:05:20 playpbx kernel: sd 0:0:0:0: [sda] 156301488 512-byte
hardware sectors (80026 MB)
Aug 24 14:05:20 playpbx kernel: sd 0:0:0:0: [sda] Write Protect is off
Aug 24 14:05:20 playpbx kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00
00
Aug 24 14:05:20 playpbx kernel: sd 0:0:0:0: [sda] Write cache: enabled,
read cache: enabled, doesn't support DPO or FUA
Aug 24 14:06:39 playpbx kernel: APIC error on CPU0: 40(40)
Aug 24 14:07:13 playpbx kernel: APIC error on CPU0: 40(40)
Aug 24 14:07:57 playpbx last message repeated 2 times
Aug 24 14:09:13 playpbx kernel: md: md1: resync done.
Aug 24 14:09:13 playpbx kernel: RAID1 conf printout:
Aug 24 14:09:13 playpbx kernel:  --- wd:2 rd:2
Aug 24 14:09:13 playpbx kernel:  disk 0, wo:0, o:1, dev:sda2
Aug 24 14:09:13 playpbx kernel:  disk 1, wo:0, o:1, dev:sdb2
Aug 24 14:10:36 playpbx kernel: APIC error on CPU0: 40(40)
Aug 24 14:11:58 playpbx kernel: APIC error on CPU0: 40(40)
Aug 24 14:17:16 playpbx kernel: APIC error on CPU0: 40(40)

So far I've noticed this whilst a RAID-1 partition was being resynced
between these drives. Is this just a problem with WDs NCQ
implementation? What about the APIC error, is it related or another
problem?


Here's an excerpt of relevant entries from kern.log:

Aug 24 13:19:06 playpbx kernel: klogd 1.4.1#18, log source = /proc/kmsg
started.
Aug 24 13:19:06 playpbx kernel: ng add_active_range(0, 0, 122592) 0
entries of 256 used
Aug 24 13:19:06 playpbx kernel: Zone PFN ranges:
Aug 24 13:19:06 playpbx kernel:   DMA             0 ->     4096
Aug 24 13:19:06 playpbx kernel:   Normal       4096 ->   122592
Aug 24 13:19:06 playpbx kernel: early_node_map[1] active PFN ranges
Aug 24 13:19:06 playpbx kernel:     0:        0 ->   122592
Aug 24 13:19:06 playpbx kernel: On node 0 totalpages: 122592
Aug 24 13:19:06 playpbx kernel:   DMA zone: 32 pages used for memmap
Aug 24 13:19:06 playpbx kernel:   DMA zone: 0 pages reserved
Aug 24 13:19:06 playpbx kernel:   DMA zone: 4064 pages, LIFO batch:0
Aug 24 13:19:06 playpbx kernel:   Normal zone: 925 pages used for memmap
Aug 24 13:19:06 playpbx kernel:   Normal zone: 117571 pages, LIFO
batch:31
Aug 24 13:19:06 playpbx kernel: DMI 2.4 present.
Aug 24 13:19:06 playpbx kernel: ACPI: RSDP 000F8100, 0024 (r2 ATI   )
Aug 24 13:19:06 playpbx kernel: ACPI: XSDT 1DEE3100, 0044 (r1 ATI
ASUSACPI 42302E31 AWRD        0)
Aug 24 13:19:06 playpbx kernel: ACPI: FACP 1DEE8400, 00F4 (r3 ATI
ASUSACPI 42302E31 AWRD        0)
Aug 24 13:19:06 playpbx kernel: ACPI: DSDT 1DEE3280, 5136 (r1 ATI
ASUSACPI  1000 MSFT  3000000)
Aug 24 13:19:06 playpbx kernel: ACPI: FACS 1DEE0000, 0040
Aug 24 13:19:06 playpbx kernel: ACPI: SSDT 1DEE8600, 01C4 (r1 PTLTD
POWERNOW     1  LTP        1)
Aug 24 13:19:06 playpbx kernel: ACPI: MCFG 1DEE88C0, 003C (r1 ATI
ASUSACPI 42302E31 AWRD        0)
Aug 24 13:19:06 playpbx kernel: ACPI: APIC 1DEE8540, 0068 (r1 ATI
ASUSACPI 42302E31 AWRD        0)
Aug 24 13:19:06 playpbx kernel: ATI board detected. Disabling timer
routing over 8254.
Aug 24 13:19:06 playpbx kernel: ACPI: PM-Timer IO Port: 0x4008
Aug 24 13:19:06 playpbx kernel: ACPI: Local APIC address 0xfee00000
Aug 24 13:19:06 playpbx kernel: ACPI: LAPIC (acpi_id[0x00]
lapic_id[0x00] enabled)
Aug 24 13:19:06 playpbx kernel: Processor #0 15:3 APIC version 16
Aug 24 13:19:06 playpbx kernel: ACPI: LAPIC (acpi_id[0x01]
lapic_id[0x01] enabled)
Aug 24 13:19:06 playpbx kernel: Processor #1 15:3 APIC version 16
Aug 24 13:19:06 playpbx kernel: ACPI: LAPIC_NMI (acpi_id[0x00] high edge
lint[0x1])
Aug 24 13:19:06 playpbx kernel: ACPI: LAPIC_NMI (acpi_id[0x01] high edge
lint[0x1])
Aug 24 13:19:06 playpbx kernel: ACPI: IOAPIC (id[0x02]
address[0xfec00000] gsi_base[0])
Aug 24 13:19:06 playpbx kernel: IOAPIC[0]: apic_id 2, version 33,
address 0xfec00000, GSI 0-23
Aug 24 13:19:06 playpbx kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 0
global_irq 2 dfl dfl)
Aug 24 13:19:06 playpbx kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 9
global_irq 9 low level)
Aug 24 13:19:06 playpbx kernel: ACPI: IRQ0 used by override.
Aug 24 13:19:06 playpbx kernel: ACPI: IRQ2 used by override.
Aug 24 13:19:06 playpbx kernel: ACPI: IRQ9 used by override.
Aug 24 13:19:06 playpbx kernel: Enabling APIC mode:  Flat.  Using 1 I/O
APICs
Aug 24 13:19:06 playpbx kernel: Using ACPI (MADT) for SMP configuration
information
Aug 24 13:19:06 playpbx kernel: Allocating PCI resources starting at
20000000 (gap: 1df00000:c2100000)
Aug 24 13:19:06 playpbx kernel: Built 1 zonelists.  Total pages: 121635
Aug 24 13:19:06 playpbx kernel: Kernel command line: root=/dev/md1 ro
nmi_watchdog=1 panic=60
Aug 24 13:19:06 playpbx kernel: mapped APIC to ffffd000 (fee00000)
Aug 24 13:19:06 playpbx kernel: mapped IOAPIC to ffffc000 (fec00000)
Aug 24 13:19:06 playpbx kernel: Enabling fast FPU save and restore...
done.
Aug 24 13:19:06 playpbx kernel: Enabling unmasked SIMD FPU exception
support...done.
Aug 24 13:19:06 playpbx kernel: Initializing CPU#0
Aug 24 13:19:06 playpbx kernel: PID hash table entries: 2048 (order: 11,
8192 bytes)
Aug 24 13:19:06 playpbx kernel: Detected 1999.988 MHz processor.
Aug 24 13:19:06 playpbx kernel: Console: colour VGA+ 80x25
Aug 24 13:19:06 playpbx kernel: Dentry cache hash table entries: 65536
(order: 6, 262144 bytes)
Aug 24 13:19:06 playpbx kernel: Inode-cache hash table entries: 32768
(order: 5, 131072 bytes)
Aug 24 13:19:06 playpbx kernel: Memory: 482420k/490368k available (2114k
kernel code, 7540k reserved, 695k data, 224k init, 0k highmem)
Aug 24 13:19:06 playpbx kernel: virtual kernel memory layout:
Aug 24 13:19:06 playpbx kernel:     fixmap  : 0xfffb7000 - 0xfffff000
( 288 kB)
Aug 24 13:19:06 playpbx kernel:     vmalloc : 0xde800000 - 0xfffb5000
( 535 MB)
Aug 24 13:19:06 playpbx kernel:     lowmem  : 0xc0000000 - 0xddee0000
( 478 MB)
Aug 24 13:19:06 playpbx kernel:       .init : 0xc03c5000 - 0xc03fd000
( 224 kB)
Aug 24 13:19:06 playpbx kernel:       .data : 0xc03109bd - 0xc03be724
( 695 kB)
Aug 24 13:19:06 playpbx kernel:       .text : 0xc0100000 - 0xc03109bd
(2114 kB)
Aug 24 13:19:06 playpbx kernel: Checking if this processor honours the
WP bit even in supervisor mode... Ok.
Aug 24 13:19:06 playpbx kernel: Calibrating delay using timer specific
routine.. 4001.56 BogoMIPS (lpj=2000780)
Aug 24 13:19:06 playpbx kernel: Mount-cache hash table entries: 512
Aug 24 13:19:06 playpbx kernel: CPU: After generic identify, caps:
178bfbff ebd3fbff 00000000 00000000 00002001 00000000 0000001f
Aug 24 13:19:06 playpbx kernel: CPU: L1 I Cache: 64K (64 bytes/line), D
cache 64K (64 bytes/line)
Aug 24 13:19:06 playpbx kernel: CPU: L2 Cache: 512K (64 bytes/line)
Aug 24 13:19:06 playpbx kernel: CPU 0(2) -> Core 0
Aug 24 13:19:06 playpbx kernel: CPU: After all inits, caps: 178bfbff
ebd3fbff 00000000 00000410 00002001 00000000 0000001f
Aug 24 13:19:06 playpbx kernel: Intel machine check architecture
supported.
Aug 24 13:19:06 playpbx kernel: Intel machine check reporting enabled on
CPU#0.
Aug 24 13:19:06 playpbx kernel: Compat vDSO mapped to ffffe000.
Aug 24 13:19:06 playpbx kernel: Checking 'hlt' instruction... OK.
Aug 24 13:19:06 playpbx kernel: Freeing SMP alternatives: 11k freed
Aug 24 13:19:06 playpbx kernel: ACPI: Core revision 20070126
Aug 24 13:19:06 playpbx kernel: CPU0: AMD Athlon(tm) 64 X2 Dual Core
Processor 3800+ stepping 02
Aug 24 13:19:06 playpbx kernel: Booting processor 1/1 eip 2000
Aug 24 13:19:06 playpbx kernel: Initializing CPU#1
Aug 24 13:19:06 playpbx kernel: Calibrating delay using timer specific
routine.. 3999.27 BogoMIPS (lpj=1999639)
Aug 24 13:19:06 playpbx kernel: CPU: After generic identify, caps:
178bfbff ebd3fbff 00000000 00000000 00002001 00000000 0000001f
Aug 24 13:19:06 playpbx kernel: CPU: L1 I Cache: 64K (64 bytes/line), D
cache 64K (64 bytes/line)
Aug 24 13:19:06 playpbx kernel: CPU: L2 Cache: 512K (64 bytes/line)
Aug 24 13:19:06 playpbx kernel: CPU 1(2) -> Core 1
Aug 24 13:19:06 playpbx kernel: CPU: After all inits, caps: 178bfbff
ebd3fbff 00000000 00000410 00002001 00000000 0000001f
Aug 24 13:19:06 playpbx kernel: Intel machine check architecture
supported.
Aug 24 13:19:06 playpbx kernel: Intel machine check reporting enabled on
CPU#1.
Aug 24 13:19:06 playpbx kernel: CPU1: AMD Athlon(tm) 64 X2 Dual Core
Processor 3800+ stepping 02
Aug 24 13:19:06 playpbx kernel: Total of 2 processors activated (8000.83
BogoMIPS).
Aug 24 13:19:06 playpbx kernel: ENABLING IO-APIC IRQs
Aug 24 13:19:06 playpbx kernel: ..TIMER: vector=0x31 apic1=0 pin1=2
apic2=-1 pin2=-1
Aug 24 13:19:06 playpbx kernel: Brought up 2 CPUs
Aug 24 13:19:06 playpbx kernel: migration_cost=1000
Aug 24 13:19:06 playpbx kernel: ACPI: bus type pci registered
Aug 24 13:19:06 playpbx kernel: PCI: Using MMCONFIG
Aug 24 13:19:06 playpbx kernel: PCI: No mmconfig possible on device
00:18
Aug 24 13:19:06 playpbx kernel: Setting up standard PCI resources
Aug 24 13:19:06 playpbx kernel: ACPI: Interpreter enabled
Aug 24 13:19:06 playpbx kernel: ACPI: Using IOAPIC for interrupt routing
Aug 24 13:19:06 playpbx kernel: ACPI: PCI Root Bridge [PCI0] (0000:00)
Aug 24 13:19:06 playpbx kernel: PCI: Probing PCI hardware (bus 00)
Aug 24 13:19:06 playpbx kernel: PCI: Transparent bridge - 0000:00:14.4
Aug 24 13:19:06 playpbx kernel: ACPI: PCI Interrupt Routing Table
[\_SB_.PCI0._PRT]
Aug 24 13:19:06 playpbx kernel: ACPI: PCI Interrupt Routing Table
[\_SB_.PCI0.P2P_._PRT]
Aug 24 13:19:06 playpbx kernel: ACPI: PCI Interrupt Routing Table
[\_SB_.PCI0.PCE7._PRT]
Aug 24 13:19:06 playpbx kernel: ACPI: PCI Interrupt Routing Table
[\_SB_.PCI0.AGP_._PRT]
Aug 24 13:19:06 playpbx kernel: ACPI: PCI Interrupt Link [LNKA] (IRQs 3
4 5 6 7 10 11) *0, disabled.
Aug 24 13:19:06 playpbx kernel: ACPI: PCI Interrupt Link [LNKB] (IRQs 3
4 5 6 7 10 11) *0, disabled.
Aug 24 13:19:06 playpbx kernel: ACPI: PCI Interrupt Link [LNKC] (IRQs 3
4 5 6 7 10 11) *0, disabled.
Aug 24 13:19:06 playpbx kernel: ACPI: PCI Interrupt Link [LNKD] (IRQs 3
4 5 6 7 10 11) *0, disabled.
Aug 24 13:19:06 playpbx kernel: ACPI: PCI Interrupt Link [LNKE] (IRQs 3
4 5 6 7 10 11) *0, disabled.
Aug 24 13:19:06 playpbx kernel: ACPI: PCI Interrupt Link [LNKF] (IRQs 3
4 *5 6 7 10 11)
Aug 24 13:19:06 playpbx kernel: ACPI: PCI Interrupt Link [LNK0] (IRQs 3
4 5 6 7 10 *11)
Aug 24 13:19:06 playpbx kernel: ACPI: PCI Interrupt Link [LNK1] (IRQs 3
4 5 6 7 10 11) *0, disabled.
Aug 24 13:19:06 playpbx kernel: Linux Plug and Play Support v0.97 (c)
Adam Belay
Aug 24 13:19:06 playpbx kernel: pnp: PnP ACPI init
Aug 24 13:19:06 playpbx kernel: ACPI: bus type pnp registered
Aug 24 13:19:06 playpbx kernel: pnp: PnP ACPI: found 11 devices
Aug 24 13:19:06 playpbx kernel: ACPI: ACPI bus type pnp unregistered
Aug 24 13:19:06 playpbx kernel: SCSI subsystem initialized
Aug 24 13:19:06 playpbx kernel: libata version 2.21 loaded.
Aug 24 13:19:06 playpbx kernel: PCI: Using ACPI for IRQ routing
...
...
Aug 24 12:28:26 dev-pbx kernel: ahci 0000:00:12.0: version 2.2
Aug 24 13:19:06 playpbx kernel: ACPI: PCI Interrupt 0000:00:12.0[A] ->
GSI 22 (level, low) -> IRQ 17
Aug 24 12:28:26 dev-pbx kernel: ahci 0000:00:12.0: controller can't do
64bit DMA, forcing 32bit
Aug 24 12:28:26 dev-pbx kernel: ahci 0000:00:12.0: AHCI 0001.0100 32
slots 4 ports 3 Gbps 0xf impl SATA mode
Aug 24 12:28:26 dev-pbx kernel: ahci 0000:00:12.0: flags: ncq ilck pm
led clo pmp pio slum part
Aug 24 12:28:26 dev-pbx kernel: scsi0 : ahci
Aug 24 12:28:26 dev-pbx kernel: scsi1 : ahci
Aug 24 12:28:26 dev-pbx kernel: scsi2 : ahci
Aug 24 12:28:26 dev-pbx kernel: scsi3 : ahci
Aug 24 12:28:26 dev-pbx kernel: ata1: SATA max UDMA/133 cmd 0xde812100
ctl 0x00000000 bmdma 0x00000000 irq 17
Aug 24 12:28:26 dev-pbx kernel: ata2: SATA max UDMA/133 cmd 0xde812180
ctl 0x00000000 bmdma 0x00000000 irq 17
Aug 24 12:28:26 dev-pbx kernel: ata3: SATA max UDMA/133 cmd 0xde812200
ctl 0x00000000 bmdma 0x00000000 irq 17
Aug 24 12:28:26 dev-pbx kernel: ata4: SATA max UDMA/133 cmd 0xde812280
ctl 0x00000000 bmdma 0x00000000 irq 17
Aug 24 12:28:26 dev-pbx kernel: ata1: SATA link up 1.5 Gbps (SStatus 113
SControl 300)
Aug 24 12:28:26 dev-pbx kernel: ata1.00: ATA-7: WDC WD800BEVS-07RST0,
04.01G04, max UDMA/133
Aug 24 12:28:26 dev-pbx kernel: ata1.00: 156301488 sectors, multi 1:
LBA48 NCQ (depth 31/32)
Aug 24 12:28:26 dev-pbx kernel: ata1.00: configured for UDMA/133
Aug 24 12:28:26 dev-pbx kernel: ata2: SATA link down (SStatus 0 SControl
300)
Aug 24 12:28:26 dev-pbx kernel: ata3: SATA link up 1.5 Gbps (SStatus 113
SControl 300)
Aug 24 12:28:26 dev-pbx kernel: ata3.00: ATA-7: WDC WD800BEVS-07RST0,
04.01G04, max UDMA/133
Aug 24 12:28:26 dev-pbx kernel: ata3.00: 156301488 sectors, multi 1:
LBA48 NCQ (depth 31/32)
Aug 24 12:28:26 dev-pbx kernel: ata3.00: configured for UDMA/133
Aug 24 12:28:26 dev-pbx kernel: ata4: SATA link down (SStatus 0 SControl
300)
Aug 24 12:28:26 dev-pbx kernel: scsi 0:0:0:0: Direct-Access     ATA
WDC WD800BEVS-07 04.0 PQ: 0 ANSI: 5
Aug 24 12:28:26 dev-pbx kernel: sd 0:0:0:0: [sda] 156301488 512-byte
hardware sectors (80026 MB)
Aug 24 12:28:26 dev-pbx kernel: sd 0:0:0:0: [sda] Write Protect is off
Aug 24 12:28:26 dev-pbx kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00
00
Aug 24 12:28:26 dev-pbx kernel: sd 0:0:0:0: [sda] Write cache: enabled,
read cache: enabled, doesn't support DPO or FUA
Aug 24 12:28:26 dev-pbx kernel: sd 0:0:0:0: [sda] 156301488 512-byte
hardware sectors (80026 MB)
Aug 24 12:28:26 dev-pbx kernel: sd 0:0:0:0: [sda] Write Protect is off
Aug 24 12:28:26 dev-pbx kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00
00
Aug 24 12:28:26 dev-pbx kernel: sd 0:0:0:0: [sda] Write cache: enabled,
read cache: enabled, doesn't support DPO or FUA
Aug 24 12:28:26 dev-pbx kernel:  sda: sda1 sda2
Aug 24 12:28:26 dev-pbx kernel: sd 0:0:0:0: [sda] Attached SCSI disk
Aug 24 12:28:26 dev-pbx kernel: scsi 2:0:0:0: Direct-Access     ATA
WDC WD800BEVS-07 04.0 PQ: 0 ANSI: 5
Aug 24 12:28:26 dev-pbx kernel: sd 2:0:0:0: [sdb] 156301488 512-byte
hardware sectors (80026 MB)
Aug 24 12:28:26 dev-pbx kernel: sd 2:0:0:0: [sdb] Write Protect is off
Aug 24 12:28:26 dev-pbx kernel: sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00
00
Aug 24 12:28:26 dev-pbx kernel: sd 2:0:0:0: [sdb] Write cache: enabled,
read cache: enabled, doesn't support DPO or FUA
Aug 24 12:28:26 dev-pbx kernel: sd 2:0:0:0: [sdb] 156301488 512-byte
hardware sectors (80026 MB)
Aug 24 12:28:26 dev-pbx kernel: sd 2:0:0:0: [sdb] Write Protect is off
Aug 24 12:28:26 dev-pbx kernel: sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00
00
Aug 24 12:28:26 dev-pbx kernel: sd 2:0:0:0: [sdb] Write cache: enabled,
read cache: enabled, doesn't support DPO or FUA
Aug 24 12:28:26 dev-pbx kernel:  sdb: sdb1 sdb2
Aug 24 12:28:26 dev-pbx kernel: sd 2:0:0:0: [sdb] Attached SCSI disk




Stirk, Lamont & Associates Ltd.
Registered Address: Thomas Andrews House, Queens Road, Belfast,  BT3 9DU
Registered in Northern Ireland, Number: NI 47983. VAT Number: 832 2778 22

