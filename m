Return-Path: <linux-kernel-owner+w=401wt.eu-S1752548AbZH1Isd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbZH1Isd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 04:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbZH1Isc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 04:48:32 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:36296 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbZH1Isa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 04:48:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=PiDswI1LAOEQ4ouWCC2B3NbZB4G1QcJ5ta82FVzd1yN6ThCU8pGxmakBP1ia4PNq2q
         4zzMvuhJZzYjKoMxH7VmonfiiwRKOOpTQqTllPzcnpRvw0FOvqymFckpVB7JL/gN4cyo
         dIbzg50J3TI5ZbhEKw8dOV1Blsqe1IPPSWe2E=
MIME-Version: 1.0
Date: Fri, 28 Aug 2009 10:48:31 +0200
Message-ID: <c4e36d110908280148p4ee31c71l4f0c0c906fe06ebe@mail.gmail.com>
Subject: irq 18: nobody cared after resume
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

When I've resumed my T61 with SD inserted in the internal card reader
- I've got irq nobody cared warning;

SD card has been inserted during suspend state (i.e. not present before suspend)

Suspend without docking station
Resume was connected to docking station.

My machine is T61, 4GB, C2D,
Kernel commit 7c0a57d5c47bcfc492b3139e77400f888a935c44
(some past 2.6.31-rc7)

/proc/interrrupts:
18:        384        395   IO-APIC-fasteoi   uhci_hcd:usb7, mmc0

Zdenek


Freezing user space processes ... (elapsed 0.00 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
pci 0000:00:02.0: power state changed by ACPI to D3
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Stopping disk
sdhci-pci 0000:15:00.2: PME# disabled
sdhci-pci 0000:15:00.2: PCI INT C disabled
ata_piix 0000:00:1f.1: PCI INT C disabled
ehci_hcd 0000:00:1d.7: PCI INT D disabled
uhci_hcd 0000:00:1d.2: PCI INT C disabled
uhci_hcd 0000:00:1d.1: PCI INT B disabled
uhci_hcd 0000:00:1d.0: PCI INT A disabled
HDA Intel 0000:00:1b.0: PCI INT B disabled
ehci_hcd 0000:00:1a.7: PCI INT C disabled
uhci_hcd 0000:00:1a.1: PCI INT B disabled
uhci_hcd 0000:00:1a.0: PCI INT A disabled
e1000e 0000:00:19.0: PCI INT A disabled
e1000e 0000:00:19.0: PME# enabled
e1000e 0000:00:19.0: wake-up capability enabled by ACPI
ehci_hcd 0000:00:1d.7: PME# disabled
ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
uhci_hcd 0000:00:1d.2: power state changed by ACPI to D3
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D3
ehci_hcd 0000:00:1a.7: PME# disabled
ehci_hcd 0000:00:1a.7: power state changed by ACPI to D3
uhci_hcd 0000:00:1a.1: power state changed by ACPI to D3
ACPI: Preparing to enter system sleep state S3
Disabling non-boot CPUs ...
kvm: disabling virtualization on CPU1
CPU 1 is now offline
lockdep: fixing up alternatives.
SMP alternatives: switching to UP code
CPU1 is down
Extended CMOS year: 2000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Extended CMOS year: 2000
Enabling non-boot CPUs ...
lockdep: fixing up alternatives.
SMP alternatives: switching to SMP code
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4390.66 BogoMIPS (lpj=7314666)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
mce: CPU supports 6 MCE banks
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0a
kvm: enabling virtualization on CPU1
CPU1 is up
ACPI: Waking up from system sleep state S3
ACPI: \_SB_.GDCK - docking
acpi device:2b: parent device:11 should not be sleeping
acpi device:2c: parent device:22 should not be sleeping
acpi device:2d: parent device:28 should not be sleeping
acpi IBM0079:01: parent device:00 should not be sleeping
uhci_hcd 0000:00:1a.1: power state changed by ACPI to D0
ehci_hcd 0000:00:1a.7: PME# disabled
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
ehci_hcd 0000:00:1d.7: PME# disabled
pci 0000:00:02.0: PME# disabled
pci 0000:00:02.1: PME# disabled
e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
e1000e 0000:00:19.0: wake-up capability disabled by ACPI
e1000e 0000:00:19.0: PME# disabled
e1000e 0000:00:19.0: wake-up capability disabled by ACPI
e1000e 0000:00:19.0: PME# disabled
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
usb usb3: root hub lost power or was reset
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
usb usb4: root hub lost power or was reset
ehci_hcd 0000:00:1a.7: PME# disabled
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
irq 18: nobody cared (try booting with the "irqpoll" option)
Pid: 0, comm: swapper Not tainted 2.6.31-rc7-00059-ge716334 #19
Call Trace:
 <IRQ>  [<ffffffff810a500b>] __report_bad_irq+0x2b/0xa0
 [<ffffffff810a520a>] note_interrupt+0x18a/0x1d0
 [<ffffffff810a588d>] handle_fasteoi_irq+0xcd/0xf0
 [<ffffffff8100ee99>] handle_irq+0x49/0xa0
 [<ffffffff813e1343>] do_IRQ+0x73/0xf0
 [<ffffffff8100cb93>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8129057d>] ? acpi_idle_enter_c1+0xa1/0xc0
 [<ffffffff8107d83d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff81290580>] ? acpi_idle_enter_c1+0xa4/0xc0
 [<ffffffff8129057d>] ? acpi_idle_enter_c1+0xa1/0xc0
 [<ffffffff81334a9b>] ? cpuidle_idle_call+0x9b/0xf0
 [<ffffffff8100aa7b>] ? cpu_idle+0x6b/0xd0
 [<ffffffff813c72ca>] ? rest_init+0x7a/0x80
 [<ffffffff81601b02>] ? start_kernel+0x38f/0x39b
 [<ffffffff81601128>] ? x86_64_start_reservations+0x125/0x129
 [<ffffffff8160120d>] ? x86_64_start_kernel+0xe1/0xe8
handlers:
[<ffffffffa0006720>] (usb_hcd_irq+0x0/0xa0 [usbcore])
Disabling IRQ #18
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
usb usb5: root hub lost power or was reset
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
usb usb6: root hub lost power or was reset
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
usb usb7: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: PME# disabled
ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.1: PCI INT C -> GSI 16 (level, low) -> IRQ 16
pci 0000:15:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
sdhci-pci 0000:15:00.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully
claim to support it.
pci 0000:15:00.3: PME# disabled
pci 0000:15:00.4: PME# disabled
pci 0000:15:00.5: PME# disabled
sd 0:0:0:0: [sda] Starting disk
ata4.00: ACPI cmd ef/03:42:00:00:00:a0 filtered out
ata4.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
ata4.00: configured for UDMA/33
ata3: SATA link down (SStatus 0 SControl 300)
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: configured for UDMA/100
ata1.00: configured for UDMA/100
ata1: EH complete
mmc0: new high speed SDHC card at address b368
mmc mmc0:b368: parent mmc0 should not be sleeping
usb 3-2: reset full speed USB device using uhci_hcd and address 3
thinkpad_acpi: ACPI backlight control delay disabled
Restarting tasks ... done.
usb 1-4: new high speed USB device using ehci_hcd and address 8
usb 1-4: New USB device found, idVendor=04b3, idProduct=4485
usb 1-4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
usb 1-4: configuration #1 chosen from 1 choice
hub 1-4:1.0: USB hub found
hub 1-4:1.0: 4 ports detected
mmcblk0: mmc0:b368 NCard 7.46 GiB
 mmcblk0: p1
usb 1-4.4: new low speed USB device using ehci_hcd and address 9
usb 1-4.4: New USB device found, idVendor=046d, idProduct=c016
usb 1-4.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-4.4: Product: Optical USB Mouse
usb 1-4.4: Manufacturer: Logitech
usb 1-4.4: configuration #1 chosen from 1 choice
input: Logitech Optical USB Mouse as
/devices/pci0000:00/0000:00:1a.7/usb1/1-4/1-4.4/1-4.4:1.0/input/input10
generic-usb 0003:046D:C016.0002: input: USB HID v1.10 Mouse [Logitech
Optical USB Mouse] on usb-0000:00:1a.7-4.4/input0
