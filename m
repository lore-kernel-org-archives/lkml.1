Return-Path: <linux-kernel-owner+w=401wt.eu-S1756566AbYAAUIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbYAAUIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 15:08:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754659AbYAAUH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 15:07:59 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37391 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754582AbYAAUH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 15:07:58 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mikko Vinni <mmvinni@yahoo.com>
Subject: Re: IDE/ACPI related hibernation regression: Second attempt fails
Date: Tue, 1 Jan 2008 21:09:54 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andreas Mohr <andi@lisas.de>, htejun@gmail.com,
       linux-kernel@vger.kernel.org, shaohua.li@intel.com, len.brown@intel.com,
       bzolnier@gmail.com, linux-pm@lists.linux-foundation.org
References: <165217.15601.qm@web58401.mail.re3.yahoo.com>
In-Reply-To: <165217.15601.qm@web58401.mail.re3.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801012109.55607.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 1 of January 2008, Mikko Vinni wrote:
> Hi again,

Hi,

Please attach the information below to the Bugzilla entry at:
http://bugzilla.kernel.org/show_bug.cgi?id=9673

Thanks,
Rafael


> I compiled the kernel (unmodified e697789d64..., I promise) again with DEBUGGING set to 1 in drivers/ide/ide-acpi.c.
> Here are the relevant (I hope) parts of dmesg output after 1 suspend/resume:
> 
> [    0.000000] Linux version 2.6.24-rc6-debugide (mikko@ubuntu) (gcc version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #1 Tue Jan 1 19:02:07 EET 2008
> ...
> [   27.472882] alim15x3: ATI Radeon IGP Northbridge is not yet fully tested.
> [   27.472946] ALI15X3: IDE controller (0x10b9:0x5229 rev 0xc4) at  PCI slot 0000:00:10.0
> [   27.473039] ACPI: Unable to derive IRQ for device 0000:00:10.0
> [   27.473088] ACPI: PCI Interrupt 0000:00:10.0[A]: no GSI
> [   27.473176] ALI15X3: not 100% native mode: will probe irqs later
> [   27.473244]     ide0: BM-DMA at 0x8080-0x8087, BIOS settings: hda:DMA, hdb:pio
> [   27.473381]     ide1: BM-DMA at 0x8088-0x808f, BIOS settings: hdc:DMA, hdd:pio
> [   27.473512] Probing IDE interface ide0...
> [   27.547404] Floppy drive(s): fd0 is 1.44M
> [   27.565886] FDC 0 is a post-1991 82077
> [   27.629089] Marking TSC unstable due to: TSC halts in idle.
> [   27.629160] Time: acpi_pm clocksource has been installed.
> [   27.752403] usb 1-1: new low speed USB device using ohci_hcd and address 2
> [   27.976556] usb 1-1: configuration #1 chosen from 1 choice
> [   27.993561] usbcore: registered new interface driver hiddev
> [   28.011803] input: Logitech USB Receiver as /class/input/input1
> [   28.018999] input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:02.0-1
> [   28.019145] usbcore: registered new interface driver usbhid
> [   28.019197] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
> [   28.389030] hda: ST94813A, ATA DISK drive
> [   28.389177] hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
> [   28.389399] hda: UDMA/100 mode selected
> [   28.389745] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> [   28.389845] ide_acpi_hwif_get_handle: ENTER: device ide0
> [   28.389849] ide_get_dev_handle: ENTER: pci 00:10.0
> [   28.389884] ide_get_dev_handle: for dev=0x10.0, addr=0x100000, *handle=0xdd416ab8
> [   28.389905] ide_acpi_hwif_get_handle: chan adr=0: handle=0xdd416fb8
> [   28.391658] ide_acpi_init: ACPI methods disabled on boot
> [   28.391714] Probing IDE interface ide1...
> [   29.412106] hdc: QSI CD-RW/DVD-ROM SBW-241, ATAPI CD/DVD-ROM drive
> [   29.412321] hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
> [   29.412393] hdc: UDMA/33 mode selected
> [   29.412542] ide1 at 0x170-0x177,0x376 on irq 15
> [   29.412642] ide_acpi_hwif_get_handle: ENTER: device ide1
> [   29.412646] ide_get_dev_handle: ENTER: pci 00:10.0
> [   29.412678] ide_get_dev_handle: for dev=0x10.0, addr=0x100000, *handle=0xdd416ab8
> [   29.412698] ide_acpi_hwif_get_handle: chan adr=1: handle=0xdd416e78
> [   29.412977] ide_acpi_init: ACPI methods disabled on boot
> [   29.424840] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
> [   29.424905] ACPI: PCI Interrupt 0000:00:0c.0[A] -> Link [LNKC] -> GSI 10 (level, low) -> IRQ 10
> [   29.476316] SCSI subsystem initialized
> [   29.486989] libata version 3.00 loaded.
> [   29.493800] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[10]  MMIO=[e0007000-e00077ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
> [   29.495401] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
> [   29.495468] ACPI: PCI Interrupt 0000:00:12.0[A] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
> [   29.497587] natsemi eth0: NatSemi DP8381[56] at 0xe0008000 (0000:00:12.0), 00:0d:9d:5b:58:5f, IRQ 11, port TP.
> [   29.516915] hda: max request size: 128KiB
> [   29.517623] hda: 78140160 sectors (40007 MB) w/8192KiB Cache, CHS=16383/255/63
> [   29.517947] hda: cache flushes supported
> [   29.518054]  hda: hda1 hda2 hda3 < hda5 hda6 > hda4
> [   29.568579] hdc: ATAPI 24X DVD-ROM CD-R/RW drive, 2048kB Cache
> [   29.568803] Uniform CD-ROM driver Revision: 3.20
> [   29.973733] Attempting manual resume
> [   29.973784] swsusp: Resume From Partition 3:5
> [   29.973787] PM: Checking swsusp image.
> [   29.974146] PM: Resume from disk failed.
> ...
> [   55.200524] NET: Registered protocol family 10
> [   55.200865] lo: Disabled Privacy Extensions
> [   65.920563] eth0: no IPv6 routers present
> [  266.282104] swsusp: Marking nosave pages: 000000000009f000 - 0000000000100000
> [  266.282116] swsusp: Basic memory bitmaps created
> [  266.282118] Syncing filesystems ... done.
> [  266.289229] Freezing user space processes ... (elapsed 0.00 seconds) done.
> [  266.289308] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
> [  266.289360] Shrinking memory...  -done (0 pages freed)
> [  266.310942] Freed 0 kbytes in 0.02 seconds (0.00 MB/s)
> [  266.310946] Suspending console(s)
> [  266.310991] ide_acpi_get_timing: ENTER:
> [  266.311160] ide_acpi_get_timing: _GTM status: 0, outptr: 0xdcf9bae0, outlen: 0x24
> [  266.311164] ide_acpi_get_timing: _GTM info: ptr: 0xdcf9baf0, len: 0x14, exp.len: 0x14
> [  266.311168] ide_acpi_get_timing: _GTM fields: 0x78, 0x8, 0x78, 0x8, 0x1f
> [  266.311188] ide_acpi_set_state: ENTER:
> [  266.311191] ide_acpi_drive_get_handle: ENTER: hdc at channel#: 1 port#: 0
> [  266.311211] ide_acpi_drive_get_handle: drive hdc handle 0xdd416dec
> [  266.311219] ACPI: Cannot set device to a higher-powered state than parent
> [  266.311222] ide_acpi_drive_get_handle: ENTER: hdd at channel#: 1 port#: 1
> [  266.311230] ide_acpi_drive_get_handle: drive hdd handle 0x00000000
> [  266.311277] ide_acpi_get_timing: ENTER:
> [  266.311315] ide_acpi_get_timing: _GTM status: 0, outptr: 0xdcf9bae0, outlen: 0x24
> [  266.311318] ide_acpi_get_timing: _GTM info: ptr: 0xdcf9baf0, len: 0x14, exp.len: 0x14
> [  266.311321] ide_acpi_get_timing: _GTM fields: 0x78, 0x8, 0x78, 0x8, 0x1f
> [  266.377953] ide_acpi_set_state: ENTER:
> [  266.377956] ide_acpi_drive_get_handle: ENTER: hda at channel#: 0 port#: 0
> [  266.377967] ide_acpi_drive_get_handle: drive hda handle 0xdd416ef0
> [  266.377973] ACPI: Cannot set device to a higher-powered state than parent
> [  266.377976] ide_acpi_drive_get_handle: ENTER: hdb at channel#: 0 port#: 1
> [  266.377984] ide_acpi_drive_get_handle: drive hdb handle 0x00000000
> [  266.378674] serial 00:0a: disabled
> [  266.379028] parport_pc 00:09: disabled
> [  266.379308] eth0: remaining active for wake-on-lan
> [  266.416992] ACPI: PCI interrupt for device 0000:00:06.0 disabled
> [  266.430221] ACPI: PCI interrupt for device 0000:00:02.0 disabled
> [  266.447648] swsusp: critical section: 
> [  266.469400] swsusp: Need to copy 24489 pages
> [  266.469406] swsusp: Normal pages needed: 24489 + 1024 + 14, available pages: 98020
> [   22.222242] Intel machine check architecture supported.
> [   22.222254] Intel machine check reporting enabled on CPU#0.
> [   22.232030] PM: Writing back config space on device 0000:00:00.0 at offset 1 (was 22300006, writing 2300006)
> [   22.245149] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKU] -> GSI 10 (level, low) -> IRQ 10
> [   22.258479] PM: Writing back config space on device 0000:00:06.0 at offset 1 (was c2900007, writing c2900003)
> [   22.258491] ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [LNKH] -> GSI 5 (level, low) -> IRQ 5
> [   22.555101] PM: Writing back config space on device 0000:00:0a.0 at offset f (was 180010a, writing 580010a)
> [   22.555115] PM: Writing back config space on device 0000:00:0a.0 at offset 3 (was 824000, writing 82a800)
> [   22.555120] PM: Writing back config space on device 0000:00:0a.0 at offset 1 (was 4100007, writing 4100087)
> [   22.555134] Yenta O2: res at 0x94/0xD4: ea/00
> [   22.555136] Yenta O2: enabling read prefetch/write burst
> [   22.691693] PM: Writing back config space on device 0000:00:0a.1 at offset f (was 180020a, writing 580020a)
> [   22.691707] PM: Writing back config space on device 0000:00:0a.1 at offset 3 (was 824000, writing 82a800)
> [   22.691713] PM: Writing back config space on device 0000:00:0a.1 at offset 1 (was 4100007, writing 4100087)
> [   22.841649] PM: Writing back config space on device 0000:00:0c.0 at offset f (was 4020100, writing 4020109)
> [   22.841661] PM: Writing back config space on device 0000:00:0c.0 at offset 5 (was 0, writing e0000000)
> [   22.841666] PM: Writing back config space on device 0000:00:0c.0 at offset 4 (was 0, writing e0007000)
> [   22.841670] PM: Writing back config space on device 0000:00:0c.0 at offset 3 (was 0, writing 4010)
> [   22.841675] PM: Writing back config space on device 0000:00:0c.0 at offset 1 (was 2100000, writing 2100016)
> [   22.891699] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[10]  MMIO=[e0007000-e00077ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
> [   22.891834] ACPI: Unable to derive IRQ for device 0000:00:10.0
> [   22.891836] ACPI: PCI Interrupt 0000:00:10.0[A]: no GSI
> [   22.891920] eth0: DSPCFG accepted after 0 usec.
> [   22.893613] parport_pc 00:09: activated
> [   22.894637] serial 00:0a: activated
> [   23.573474] usb usb1: root hub lost power or was reset
> [   23.688118] ide_acpi_set_state: ENTER:
> [   23.688199] ide_acpi_drive_get_handle: ENTER: hdb at channel#: 0 port#: 1
> [   23.688215] ide_acpi_drive_get_handle: drive hdb handle 0x00000000
> [   23.688217] ide_acpi_push_timing: ENTER:
> [   23.688693] ide_acpi_push_timing: _STM status: 0
> [   23.688697] ide_acpi_exec_tfs: call get_GTF, drive=hda port=0
> [   23.688701] do_drive_get_GTF: ENTER: ide0 at 0000:00:10.0, port#: 0, hard_port#: 0
> [   23.688850] do_drive_get_GTF: returning gtf_length=21, gtf_address=0xdcf9baf0, obj_loc=0xdcf9bae0
> [   23.688854] ide_acpi_exec_tfs: call set_taskfiles, drive=hda
> [   23.688856] do_drive_set_taskfiles: ENTER: hda, hard_port#: 0
> [   23.688859] do_drive_set_taskfiles: total GTF bytes=21 (0x15), gtf_count=3, addr=0xdcf9baf0
> [   23.688863] taskfile_load_raw: (0x1f1-1f7): hex: 03 45 00 00 00 a0 ef
> [   23.688865] taskfile_load_raw: _GTF execution disabled
> [   23.688868] taskfile_load_raw: (0x1f1-1f7): hex: 03 45 00 00 00 a0 ef
> [   23.688870] taskfile_load_raw: _GTF execution disabled
> [   23.688872] taskfile_load_raw: (0x1f1-1f7): hex: 03 0c 00 00 00 a0 ef
> [   23.688874] taskfile_load_raw: _GTF execution disabled
> [   23.688877] ide_acpi_exec_tfs: ret=0
> [   23.690904] hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
> [   23.691250] hda: UDMA/100 mode selected
> [   23.691641] ide_acpi_set_state: ENTER:
> [   23.691686] ide_acpi_drive_get_handle: ENTER: hdd at channel#: 1 port#: 1
> [   23.691695] ide_acpi_drive_get_handle: drive hdd handle 0x00000000
> [   23.691697] ide_acpi_push_timing: ENTER:
> [   23.692120] ide_acpi_push_timing: _STM status: 0
> [   23.692123] ide_acpi_exec_tfs: call get_GTF, drive=hdc port=2
> [   23.692126] do_drive_get_GTF: ENTER: ide1 at 0000:00:10.0, port#: 0, hard_port#: 1
> [   23.692273] do_drive_get_GTF: returning gtf_length=21, gtf_address=0xdcf9baf0, obj_loc=0xdcf9bae0
> [   23.692276] ide_acpi_exec_tfs: call set_taskfiles, drive=hdc
> [   23.692279] do_drive_set_taskfiles: ENTER: hdc, hard_port#: 2
> [   23.692282] do_drive_set_taskfiles: total GTF bytes=21 (0x15), gtf_count=3, addr=0xdcf9baf0
> [   23.692285] taskfile_load_raw: (0x1f1-1f7): hex: 03 42 00 00 00 a0 ef
> [   23.692287] taskfile_load_raw: _GTF execution disabled
> [   23.692290] taskfile_load_raw: (0x1f1-1f7): hex: 03 42 00 00 00 a0 ef
> [   23.692292] taskfile_load_raw: _GTF execution disabled
> [   23.692294] taskfile_load_raw: (0x1f1-1f7): hex: 03 0c 00 00 00 a0 ef
> [   23.692296] taskfile_load_raw: _GTF execution disabled
> [   23.692298] ide_acpi_exec_tfs: ret=0
> [   23.694313] hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
> [   23.705376] hdc: UDMA/33 mode selected
> [   23.705529] PM: Image restored successfully.
> [   23.715598] Restarting tasks ... <6>usb 1-1: USB disconnect, address 2
> [   23.718912] done.
> [   23.718940] swsusp: Basic memory bitmaps freed
> [   24.018008] usb 1-1: new low speed USB device using ohci_hcd and address 3
> [   24.242290] usb 1-1: configuration #1 chosen from 1 choice
> [   24.265617] input: Logitech USB Receiver as /class/input/input8
> [   24.291398] input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:02.0-1
> 
> 
> I hope this makes sense to somebody.
> 
> 
> > > Disassembled ACPI BIOS AML code (DSDT) of your machine would be
> > > very useful in this case, I'm afraid (done via acpidump and
> > iasl,
> > 
>  search
> > > the internet for pointers).
> > > lspci -x or better -xxx of the IDE device would be very useful, too.
> > 
> > 
> > This one?
> > 00:10.0 IDE interface: ALi Corporation M5229 IDE (rev c4)
> > 00: b9 10 29 52 05 00 90 02 c4 b0 01 01 00 20 00 00
> > 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > 20: 81 80 00 00 00 00 00 00 00 00 00 00 3c 10 24 00
> > 30: 00 00 00 00 60 00 00 00 00 00 00 00 00 01 02 04
> > 40: 00 00 00 0f 00 00 00 00 30 00 20 c9 00 00 ba 3a
> > 50: 02 00 00 89 55 50 0f 0a 01 31 31 00 01 31 31 00
> > 60: 01 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00
> > 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > 
> 
> 
> After booting into this new kernel, I ran lspci -xxx both before and after hibernation, and diffed the outputs. This is the result:
> --- lspcixxx_debug    2008-01-01 20:01:21.000000000 +0200
> +++ lspcixxx_debug_after1suspend    2008-01-01 20:03:03.000000000 +0200
> @@ -1,27 +1,27 @@
>  00:00.0 Host bridge: ATI Technologies Inc AGP Bridge [IGP 320M] (rev 13)
>  00: 02 10 b0 ca 06 00 30 02 13 00 00 06 00 20 00 00
>  10: 08 00 00 e4 08 00 40 e0 91 80 00 00 00 00 00 00
>  20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  30: 00 00 00 00 a0 00 00 00 00 00 00 00 00 00 00 00
>  40: 00 00 00 00 0b 03 00 00 00 00 00 00 04 0d 00 00
>  50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  60: bd 0c a2 85 24 36 e2 56 00 00 00 00 30 01 06 c1
>  70: e0 0d 20 30 84 84 84 84 00 00 00 00 00 00 00 00
>  80: 00 00 00 00 96 10 83 00 33 00 30 00 03 00 00 00
> -90: 00 00 00 00 1f 1e 05 00 00 00 e4 7f 80 00 00 00
> +90: 00 00 00 00 1f 1d 05 00 00 00 e4 7f 80 00 00 00
>  a0: 02 00 20 00 17 02 00 0f 00 00 00 00 03 00 00 00
>  b0: 00 00 02 00 08 00 00 00 04 04 04 04 00 00 00 00
>  c0: 00 00 00 ff 5a 15 05 0f 00 1e ff 1f 00 00 84 00
>  d0: eb 7b 0f 00 eb 7b 4f 00 6a 00 60 10 00 00 00 ff
>  e0: 00 00 00 00 00 00 00 00 00 00 00 ff 00 00 00 ff
> -f0: 1f 00 09 00 00 00 00 ff 00 08 10 18 00 00 00 00
> +f0: 03 00 09 00 00 00 00 ff 00 08 10 18 00 00 00 00
>  
>  00:01.0 PCI bridge: ATI Technologies Inc PCI Bridge [IGP 320M] (rev 01)
>  00: 02 10 0f 70 07 00 20 02 01 00 04 06 00 63 01 00
>  10: 00 00 00 00 00 00 00 00 00 01 01 44 91 91 20 02
>  20: 10 e0 10 e0 00 e8 f0 ef 00 00 00 00 00 00 00 00
>  30: 00 00 00 00 00 00 00 00 00 00 00 00 ff 00 0c 00
>  40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> @@ -50,40 +50,40 @@
>  c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  
>  00:06.0 Multimedia audio controller: ALi Corporation M5451 PCI AC-Link Controller Audio Device (rev 02)
>  00: b9 10 51 54 07 00 90 c2 02 00 01 04 00 40 00 00
>  10: 01 84 00 00 00 50 00 e0 00 00 00 00 00 00 00 00
>  20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 24 00
>  30: 00 00 00 00 dc 00 00 00 00 00 00 00 05 01 02 18
> -40: 00 00 00 00 aa 40 08 e2 00 00 00 00 00 00 00 00
> +40: 00 00 00 00 00 40 08 e2 00 00 00 00 00 00 00 00
>  50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  d0: 00 00 00 00 00 00 00 00 00 00 00 00 01 00 22 e6
>  e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  
>  00:07.0 ISA bridge: ALi Corporation M1533/M1535 PCI to ISA Bridge [Aladdin IV/V/V+]
>  00: b9 10 33 15 0f 00 10 02 00 00 01 06 00 00 00 00
>  10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  20: 00 00 00 00 00 00 00 00 00 00 00 00 b9 10 33 15
>  30: 00 00 00 00 a0 00 00 00 00 00 00 00 00 00 00 00
>  40: 01 d3 0b ea 5d 42 00 03 90 03 90 52 00 00 cd 33
> -50: 00 00 00 00 02 00 02 00 4c 80 80 00 00 00 e0 f0
> +50: 00 00 00 00 02 00 02 00 4c 00 80 00 00 00 e0 f0
>  60: 62 21 00 00 00 00 00 00 00 00 00 00 00 64 00 00
>  70: d2 00 23 00 03 1f 81 01 40 00 00 00 61 00 00 91
>  80: a5 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  a0: 01 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
>  b0: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> @@ -159,47 +159,47 @@
>  d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  e0: 00 00 00 00 00 00 00 00 00 00 00 00 88 00 00 00
>  f0: 10 00 00 00 82 10 00 00 3c 10 24 00 00 00 00 00
>  
>  00:10.0 IDE interface: ALi Corporation M5229 IDE (rev c4)
>  00: b9 10 29 52 05 00 90 02 c4 b0 01 01 00 20 00 00
>  10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  20: 81 80 00 00 00 00 00 00 00 00 00 00 3c 10 24 00
>  30: 00 00 00 00 60 00 00 00 00 00 00 00 00 01 02 04
>  40: 00 00 00 0f 00 00 00 00 30 00 20 c9 00 00 ba 3a
> -50: 02 00 00 89 05 00 0f 0a 01 31 31 00 01 31 31 00
> +50: 02 00 00 89 55 50 0f 0a 01 31 31 00 01 31 31 00
>  60: 01 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00
>  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  
>  00:11.0 Bridge: ALi Corporation M7101 Power Management Controller [PMU]
>  00: b9 10 01 71 00 00 00 02 00 00 80 06 00 00 00 00
>  10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 24 00
>  30: 00 00 00 00 e4 00 00 00 00 00 00 00 00 00 00 00
> -40: 00 40 08 00 00 80 21 00 aa 20 00 30 00 00 00 00
> +40: 00 40 00 00 00 80 21 00 aa 20 00 30 00 00 00 00
>  50: 00 01 00 00 00 00 00 00 00 05 05 00 00 00 00 00
>  60: 00 00 00 00 a5 00 00 00 00 00 00 22 00 00 00 0e
>  70: 00 00 00 00 00 00 00 28 f7 77 00 a2 38 1e 13 00
>  80: 76 89 15 13 00 33 00 00 0e 00 00 9a 99 00 00 99
>  90: 30 03 00 00 00 00 00 3b db 00 00 21 00 01 00 00
>  a0: 00 00 00 c0 00 00 00 28 10 fe 00 fe 00 00 00 00
>  b0: 00 84 00 08 00 0f 01 00 60 04 00 01 00 01 00 a5
>  c0: 13 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> -d0: 00 46 04 00 00 00 00 00 00 00 40 00 0c 80 00 00
> +d0: 00 46 04 00 00 00 00 00 00 00 40 00 8b 80 00 00
>  e0: 00 80 40 80 01 00 01 00 00 00 00 00 00 00 00 00
>  f0: 01 00 20 1e 00 00 00 00 00 00 00 00 00 00 00 00
>  
>  00:12.0 Ethernet controller: National Semiconductor Corporation DP83815 (MacPhyter) Ethernet Controller
>  00: 0b 10 20 00 07 00 90 02 00 00 00 02 00 5a 00 00
>  10: 01 8c 00 00 00 80 00 e0 00 00 00 00 00 00 00 00
>  20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 24 00
>  30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 01 0b 34
>  40: 01 00 82 ff 00 80 00 00 00 00 00 00 00 00 00 00
>  50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 
> 
> What seems to happen when I try to hibernate the machine for the second time, is that the hard disk powers down quite early in the process (I hear it spin down, if I'm not totally mistaken) and it doesn't turn back on. 
> 
> 
> Mikko
> 
> 
> 
> 
>       ____________________________________________________________________________________
> Be a better friend, newshound, and 
> know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ 
> 
> 
> 



-- 
"Premature optimization is the root of all evil." - Donald Knuth
