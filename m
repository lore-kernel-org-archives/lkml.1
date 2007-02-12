Return-Path: <linux-kernel-owner+w=401wt.eu-S965027AbXBLRmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965027AbXBLRmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 12:42:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965029AbXBLRmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 12:42:44 -0500
Received: from mpemail.mpe.mpg.de ([130.183.137.110]:33009 "EHLO
	mpemail.mpe.mpg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965027AbXBLRmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 12:42:44 -0500
From: "Martin A. Fink" <fink@mpe.mpg.de>
Organization: MPE
To: linux-kernel@vger.kernel.org
Subject: Re: SATA-performance: Linux vs. FreeBSD
Date: Mon, 12 Feb 2007 18:42:40 +0100
User-Agent: KMail/1.8
References: <200702121502.17130.fink@mpe.mpg.de> <p73abzji9xi.fsf@bingen.suse.de>
In-Reply-To: <p73abzji9xi.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702121842.40380.fink@mpe.mpg.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

System Details:

dmesg: (parts)

Bootdata ok (command line is root=/dev/sda7 vga=0x31a    resume=/dev/sda5 
splash=silent)
Linux version 2.6.18.2-34-default (geeko@buildhost) (gcc version 4.1.2 
20061115 (prerelease) (SUSE Linux)) #1 SMP Mon Nov 27 11:46:27 UTC 2006
...
Using ACPI (MADT) for SMP configuration information
...
Intel(R) Core(TM)2 CPU          6300  @ 1.86GHz stepping 06
Brought up 2 CPUs
...
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: Processor [CPU2] (supports 8 throttling states)
...
ICH7: IDE controller at PCI slot 0000:00:1f.1
GSI 18 sharing vector 0xD9 and IRQ 18
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 22 (level, low) -> IRQ 217
ICH7: chipset revision 1
ICH7: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0xffa8-0xffaf, BIOS settings: hdc:pio, hdd:pio
Probing IDE interface ide0...
hda: HL-DT-STDVD-RAM GSA-H22N, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
libata version 2.00 loaded.
ahci 0000:00:1f.2: version 2.0
GSI 19 sharing vector 0xE1 and IRQ 19
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 23 (level, low) -> IRQ 225
PCI: Setting latency timer of device 0000:00:1f.2 to 64
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum part 
ata1: SATA max UDMA/133 cmd 0xFFFFC20000026D00 ctl 0x0 bmdma 0x0 irq 233
ata2: SATA max UDMA/133 cmd 0xFFFFC20000026D80 ctl 0x0 bmdma 0x0 irq 233
ata3: SATA max UDMA/133 cmd 0xFFFFC20000026E00 ctl 0x0 bmdma 0x0 irq 233
ata4: SATA max UDMA/133 cmd 0xFFFFC20000026E80 ctl 0x0 bmdma 0x0 irq 233
scsi0 : ahci
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7, max UDMA/133, 156301488 sectors: LBA48 NCQ (depth 31/32)
ata1.00: ata1: dev 0 multi count 16
ata1.00: configured for UDMA/133
scsi1 : ahci
ata2: SATA link down (SStatus 0 SControl 300)
scsi2 : ahci
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ATA-6, max UDMA/100, 57337056 sectors: LBA 
ata3.00: ata3: dev 0 multi count 1
ata3.00: applying bridge limits
ata3.00: configured for UDMA/100
scsi3 : ahci
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4.00: ATA-7, max UDMA/133, 488397168 sectors: LBA48 NCQ (depth 31/32)
ata4.00: ata4: dev 0 multi count 16
ata4.00: configured for UDMA/133
  Vendor: ATA       Model: ST380811AS        Rev: 3.AA
Losing some ticks... checking if CPU frequency changed.
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: drive cache: write back
SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: drive cache: write back
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 >
 sda2: <bsd: sda9 sda10 sda11 sda12 sda13 >
sd 0:0:0:0: Attached scsi disk sda
  Vendor: ATA       Model: Adtron A25FB-28G  Rev: BF22
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdb: 57337056 512-byte hdwr sectors (29357 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: drive cache: write through
SCSI device sdb: 57337056 512-byte hdwr sectors (29357 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: drive cache: write through
 sdb: sdb1
sd 2:0:0:0: Attached scsi disk sdb
  Vendor: ATA       Model: ST3250820AS       Rev: 3.AA
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdc: 488397168 512-byte hdwr sectors (250059 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: drive cache: write back
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 2:0:0:0: Attached scsi generic sg1 type 0
SCSI device sdc: 488397168 512-byte hdwr sectors (250059 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: drive cache: write back
 sdc:
sd 3:0:0:0: Attached scsi disk sdc
sd 3:0:0:0: Attached scsi generic sg2 type 0
...


strace output:

% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
 73.73   49.904049        1947     25627           write
 25.66   17.365062      694602        25           fsync
  0.62    0.416500       59500         7           close
  0.00    0.000000           0         4           read
  0.00    0.000000           0         7           open
  0.00    0.000000           0         5           fstat
  0.00    0.000000           0        16           mmap
  0.00    0.000000           0         7           mprotect
  0.00    0.000000           0         1           munmap
  0.00    0.000000           0         3           brk
  0.00    0.000000           0         1         1 access
  0.00    0.000000           0         1           execve
  0.00    0.000000           0         1           uname
  0.00    0.000000           0         1           arch_prctl
  0.00    0.000000           0         4           fadvise64
------ ----------- ----------- --------- --------- ----------------
100.00   67.685611                 25710         1 total

as result of $> strace -c -T -o trace.out PTestY

PTestY run for 12.5 min = 752 seconds
Thus it stuck somewhere in the system for around 690 seconds !!
