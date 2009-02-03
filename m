Return-Path: <linux-kernel-owner+w=401wt.eu-S1756138AbZBCRdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbZBCRdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 12:33:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbZBCRdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 12:33:36 -0500
Received: from rv-out-0506.google.com ([209.85.198.236]:40684 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbZBCRde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 12:33:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=e86T66xK+Lj8uUWZiEsa0xs9+lmd5Y4JOmiDLMizja0PneZQDCMdSagIGkUJnLl99f
         nPnSuDH9VcpYiIYoB5senZvLcsMrXXtsm/4A9aNvXf2NILrFBDGDbRiQwQl/Vi8wQgvw
         R48hK1J53ssfonS7YUzsF5ytBs+hj64Sf3BrA=
MIME-Version: 1.0
In-Reply-To: <200902030941.57261.rjw@sisk.pl>
References: <a44ae5cd0902022058x629dc2a3o641193630b60393f@mail.gmail.com>
	 <200902030941.57261.rjw@sisk.pl>
Date: Tue, 3 Feb 2009 12:33:32 -0500
Message-ID: <a44ae5cd0902030933s5c936f9ex165b278338520673@mail.gmail.com>
Subject: Re: 2.6.29-rc3-git3 -- Failure to resume two Sandisk USB flash drives 
	attached to a Belkin USB Busport Mobile (F5U022).
From: Miles Lane <miles.lane@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       David Brownell <dbrownell@users.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This does seem to be a regression.

I just checked with Ubuntu Jaunty running 2.6.28-6-generic.  The USB
host and USB
flash drives resume perfectly with this setup.  I tested having
Nautilus windows open
for both drives, suspending and resuming.  After resuming, I was able
to work with
the folders and files in those Nautilus windows.

[ 1774.552146] yenta_cardbus 0000:04:09.0: restoring config space at
offset 0xf (was 0x34001ff, writing 0x50001ff)
[ 1774.552156] yenta_cardbus 0000:04:09.0: restoring config space at
offset 0xe (was 0x0, writing 0x44fc)
[ 1774.552165] yenta_cardbus 0000:04:09.0: restoring config space at
offset 0xd (was 0x0, writing 0x4400)
[ 1774.552174] yenta_cardbus 0000:04:09.0: restoring config space at
offset 0xc (was 0x0, writing 0x40fc)
[ 1774.552183] yenta_cardbus 0000:04:09.0: restoring config space at
offset 0xb (was 0x0, writing 0x4000)
[ 1774.552192] yenta_cardbus 0000:04:09.0: restoring config space at
offset 0xa (was 0x0, writing 0xf3fff000)
[ 1774.552201] yenta_cardbus 0000:04:09.0: restoring config space at
offset 0x9 (was 0x0, writing 0xf0000000)
[ 1774.552211] yenta_cardbus 0000:04:09.0: restoring config space at
offset 0x8 (was 0x0, writing 0xdffff000)
[ 1774.552220] yenta_cardbus 0000:04:09.0: restoring config space at
offset 0x7 (was 0x0, writing 0xdc000000)
[ 1774.552229] yenta_cardbus 0000:04:09.0: restoring config space at
offset 0x6 (was 0x0, writing 0xb0080504)
[ 1774.552241] yenta_cardbus 0000:04:09.0: restoring config space at
offset 0x4 (was 0x0, writing 0xd8006000)
[ 1774.552251] yenta_cardbus 0000:04:09.0: restoring config space at
offset 0x3 (was 0x820000, writing 0x82a820)
[ 1774.552263] yenta_cardbus 0000:04:09.0: restoring config space at
offset 0x1 (was 0x2100000, writing 0x2100007)
...
[ 1777.300230] ohci_hcd 0000:05:00.0: enabling device (0000 -> 0002)
[ 1777.300240] ohci_hcd 0000:05:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[ 1777.300253] ohci_hcd 0000:05:00.0: setting latency timer to 64
[ 1777.300265] ohci_hcd 0000:05:00.0: restoring config space at offset
0xf (was 0x100, writing 0x111)
[ 1777.300303] ohci_hcd 0000:05:00.0: restoring config space at offset
0x4 (was 0x0, writing 0xf0000000)
[ 1777.358145] usb usb6: root hub lost power or was reset
[ 1777.832124] usb 6-1: reset full speed USB device using ohci_hcd and address 2
[ 1778.220125] usb 6-2: reset full speed USB device using ohci_hcd and address 3


On Tue, Feb 3, 2009 at 3:41 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Hi,
>
> Did that work before?
>
> On Tuesday 03 February 2009, Miles Lane wrote:
>> Before suspend:
>>
>> pcmcia_socket pcmcia_socket0: pccard: CardBus card inserted into slot 0
>> pci 0000:05:00.0: reg 10 32bit mmio: [0x000000-0x000fff]
>> ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
>> ohci_hcd: block sizes: ed 80 td 96
>> ohci_hcd 0000:05:00.0: enabling device (0000 -> 0002)
>> ohci_hcd 0000:05:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
>> ohci_hcd 0000:05:00.0: setting latency timer to 64
>> ohci_hcd 0000:05:00.0: OHCI Host Controller
>> drivers/usb/core/inode.c: creating file '006'
>> ohci_hcd 0000:05:00.0: new USB bus registered, assigned bus number 6
>> ohci_hcd 0000:05:00.0: WARNING: OPTi workarounds unavailable
>> ohci_hcd 0000:05:00.0: created debug files
>> ohci_hcd 0000:05:00.0: irq 17, io mem 0xf0000000
>> ohci_hcd 0000:05:00.0: OHCI controller state
>> ohci_hcd 0000:05:00.0: OHCI 1.0, NO legacy support registers
>> ohci_hcd 0000:05:00.0: control 0x083 HCFS=operational CBSR=3
>> ohci_hcd 0000:05:00.0: cmdstatus 0x00000 SOC=0
>> ohci_hcd 0000:05:00.0: intrstatus 0x00000044 RHSC SF
>> ohci_hcd 0000:05:00.0: intrenable 0x8000000a MIE RD WDH
>> ohci_hcd 0000:05:00.0: hcca frame #0003
>> ohci_hcd 0000:05:00.0: roothub.a 01000202 POTPGT=1 NPS NDP=2(2)
>> ohci_hcd 0000:05:00.0: roothub.b 00000000 PPCM=0000 DR=0000
>> ohci_hcd 0000:05:00.0: roothub.status 00008000 DRWE
>> ohci_hcd 0000:05:00.0: roothub.portstatus [0] 0x00010101 CSC PPS CCS
>> ohci_hcd 0000:05:00.0: roothub.portstatus [1] 0x00010101 CSC PPS CCS
>> usb usb6: default language 0x0409
>> usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
>> usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> usb usb6: Product: OHCI Host Controller
>> usb usb6: Manufacturer: Linux 2.6.29-rc3-git3 ohci_hcd
>> usb usb6: SerialNumber: 0000:05:00.0
>> usb usb6: uevent
>> usb usb6: usb_probe_device
>> usb usb6: configuration #1 chosen from 1 choice
>> usb usb6: adding 6-0:1.0 (config #1, interface 0)
>> usb 6-0:1.0: uevent
>> hub 6-0:1.0: usb_probe_interface
>> hub 6-0:1.0: usb_probe_interface - got id
>> hub 6-0:1.0: USB hub found
>> hub 6-0:1.0: 2 ports detected
>> hub 6-0:1.0: standalone hub
>> hub 6-0:1.0: no power switching (usb 1.0)
>> hub 6-0:1.0: global over-current protection
>> hub 6-0:1.0: power on to power good time: 2ms
>> hub 6-0:1.0: local power source is good
>> hub 6-0:1.0: no over-current condition exists
>> hub 6-0:1.0: trying to enable port power on non-switchable hub
>> drivers/usb/core/inode.c: creating file '001'
>> ohci_hcd 0000:05:00.0: GetStatus roothub.portstatus [0] = 0x00010101 CSC PPS CCS
>> hub 6-0:1.0: port 1: status 0101 change 0001
>> ohci_hcd 0000:05:00.0: GetStatus roothub.portstatus [1] = 0x00010101 CSC PPS CCS
>> hub 6-0:1.0: port 2: status 0101 change 0001
>> hub 6-0:1.0: state 7 ports 2 chg 0006 evt 0000
>> hub 6-0:1.0: port 1, status 0101, change 0000, 12 Mb/s
>> ohci_hcd 0000:05:00.0: GetStatus roothub.portstatus [0] = 0x00100103
>> PRSC PPS PES CCS
>> usb 6-1: new full speed USB device using ohci_hcd and address 2
>> ohci_hcd 0000:05:00.0: GetStatus roothub.portstatus [0] = 0x00100103
>> PRSC PPS PES CCS
>> usb 6-1: not running at top speed; connect to a high speed hub
>> usb 6-1: default language 0x0409
>> usb 6-1: New USB device found, idVendor=0781, idProduct=5406
>> usb 6-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
>> usb 6-1: Product: U3 Cruzer Micro
>> usb 6-1: Manufacturer: SanDisk
>> usb 6-1: SerialNumber: 1100500C9FC366E7
>> usb 6-1: uevent
>> usb 6-1: usb_probe_device
>> usb 6-1: configuration #1 chosen from 1 choice
>> usb 6-1: adding 6-1:1.0 (config #1, interface 0)
>> usb 6-1:1.0: uevent
>> drivers/usb/core/inode.c: creating file '002'
>> hub 6-0:1.0: port 2, status 0101, change 0000, 12 Mb/s
>> libusual 6-1:1.0: usb_probe_interface
>> libusual 6-1:1.0: usb_probe_interface - got id
>> usbcore: registered new interface driver libusual
>> ohci_hcd 0000:05:00.0: GetStatus roothub.portstatus [1] = 0x00100103
>> PRSC PPS PES CCS
>> Initializing USB Mass Storage driver...
>> usb-storage 6-1:1.0: usb_probe_interface
>> usb-storage 6-1:1.0: usb_probe_interface - got id
>> scsi6 : SCSI emulation for USB Mass Storage devices
>> usb-storage: device found at 2
>> usb-storage: waiting for device to settle before scanning
>> usbcore: registered new interface driver usb-storage
>> USB Mass Storage support registered.
>> usb 6-2: new full speed USB device using ohci_hcd and address 3
>> ohci_hcd 0000:05:00.0: GetStatus roothub.portstatus [1] = 0x00100103
>> PRSC PPS PES CCS
>> usb 6-2: not running at top speed; connect to a high speed hub
>> usb 6-2: default language 0x0409
>> usb 6-2: New USB device found, idVendor=0781, idProduct=5406
>> usb 6-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
>> usb 6-2: Product: U3 Cruzer Micro
>> usb 6-2: Manufacturer: SanDisk Corporation
>> usb 6-2: SerialNumber: 0000162B5371EB2B
>> usb 6-2: uevent
>> usb 6-2: usb_probe_device
>> usb 6-2: configuration #1 chosen from 1 choice
>> usb 6-2: adding 6-2:1.0 (config #1, interface 0)
>> usb 6-2:1.0: uevent
>> libusual 6-2:1.0: usb_probe_interface
>> libusual 6-2:1.0: usb_probe_interface - got id
>> usb-storage 6-2:1.0: usb_probe_interface
>> usb-storage 6-2:1.0: usb_probe_interface - got id
>> scsi7 : SCSI emulation for USB Mass Storage devices
>> drivers/usb/core/inode.c: creating file '003'
>> hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0004
>> usb-storage: device found at 3
>> usb-storage: waiting for device to settle before scanning
>> scsi 6:0:0:0: Direct-Access     SanDisk  Cruzer           7.01 PQ: 0 ANSI: 0 CCS
>> sd 6:0:0:0: [sdb] 15695871 512-byte hardware sectors: (8.03 GB/7.48 GiB)
>> ohci_hcd 0000:05:00.0: urb ffff880043c29948 path 1 ep1in 92120000 cc 9
>> --> status -121
>> sd 6:0:0:0: [sdb] Write Protect is off
>> sd 6:0:0:0: [sdb] Mode Sense: 45 00 00 08
>> sd 6:0:0:0: [sdb] Assuming drive cache: write through
>> sd 6:0:0:0: [sdb] 15695871 512-byte hardware sectors: (8.03 GB/7.48 GiB)
>> ohci_hcd 0000:05:00.0: urb ffff880043c29318 path 1 ep1in 93120000 cc 9
>> --> status -121
>> sd 6:0:0:0: [sdb] Write Protect is off
>> sd 6:0:0:0: [sdb] Mode Sense: 45 00 00 08
>> sd 6:0:0:0: [sdb] Assuming drive cache: write through
>>  sdb: sdb1
>> sd 6:0:0:0: [sdb] Attached SCSI removable disk
>> sd 6:0:0:0: Attached scsi generic sg2 type 0
>> scsi 6:0:0:1: CD-ROM            SanDisk  Cruzer           7.01 PQ: 0 ANSI: 0
>> usb 6-1:1.0: uevent
>> usb 6-1: uevent
>> ohci_hcd 0000:05:00.0: urb ffff880043c29738 path 1 ep1in 92120000 cc 9
>> --> status -121
>> sr1: scsi3-mmc drive: 48x/48x tray
>> sr 6:0:0:1: Attached scsi CD-ROM sr1
>> sr 6:0:0:1: Attached scsi generic sg3 type 5
>> usb-storage: device scan complete
>> scsi 7:0:0:0: Direct-Access     SanDisk  U3 Cruzer Micro  3.27 PQ: 0 ANSI: 2
>> sd 7:0:0:0: [sdc] 8009728 512-byte hardware sectors: (4.10 GB/3.81 GiB)
>> ohci_hcd 0000:05:00.0: urb ffff880043c29a50 path 2 ep1in 92120000 cc 9
>> --> status -121
>> sd 7:0:0:0: [sdc] Write Protect is off
>> sd 7:0:0:0: [sdc] Mode Sense: 03 00 00 00
>> sd 7:0:0:0: [sdc] Assuming drive cache: write through
>> sd 7:0:0:0: [sdc] 8009728 512-byte hardware sectors: (4.10 GB/3.81 GiB)
>> ohci_hcd 0000:05:00.0: urb ffff880043c29738 path 2 ep1in 93120000 cc 9
>> --> status -121
>> sd 7:0:0:0: [sdc] Write Protect is off
>> sd 7:0:0:0: [sdc] Mode Sense: 03 00 00 00
>> sd 7:0:0:0: [sdc] Assuming drive cache: write through
>>  sdc: sdc1
>> sd 7:0:0:0: [sdc] Attached SCSI removable disk
>> sd 7:0:0:0: Attached scsi generic sg4 type 0
>> scsi 7:0:0:1: CD-ROM            SanDisk  U3 Cruzer Micro  3.27 PQ: 0 ANSI: 2
>> ohci_hcd 0000:05:00.0: urb ffff880043c29108 path 2 ep1in 93120000 cc 9
>> --> status -121
>> ohci_hcd 0000:05:00.0: urb ffff8800509cab58 path 2 ep1in 43160000 cc 4
>> --> status -32
>> usb 6-2:1.0: uevent
>> usb 6-2: uevent
>> ohci_hcd 0000:05:00.0: urb ffff880043c29630 path 2 ep1in 93120000 cc 9
>> --> status -121
>> ohci_hcd 0000:05:00.0: urb ffff8800509cab58 path 2 ep1in 43160000 cc 4
>> --> status -32
>> ohci_hcd 0000:05:00.0: urb ffff880043c29630 path 2 ep1in 93120000 cc 9
>> --> status -121
>> ohci_hcd 0000:05:00.0: urb ffff8800509cab58 path 2 ep1in 43160000 cc 4
>> --> status -32
>> ------------[ cut here ]------------
>> WARNING: at drivers/usb/storage/transport.c:584
>> last_sector_hacks+0x103/0x165 [usb_storage]()
>> Hardware name: MT6821
>> sdb: Successful last sector success at 15695870, device 0781:5406:0200
>> Modules linked in: usb_storage libusual ohci_hcd iwl3945 rfkill
>> mac80211 led_class lib80211 cfg80211 orinoco_cs orinoco hermes_dld
>> hermes binfmt_misc sco bridge stp rfcomm llc bnep l2cap bluetooth ipv6
>> acpi_cpufreq cpufreq_ondemand cpufreq_stats cpufreq_performance
>> freq_table cpufreq_powersave pci_slot sbs sbshc sbp2 ppdev parport_pc
>> lp parport snd_hda_codec_si3054 snd_hda_codec_idt snd_hda_intel
>> snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm arc4 ecb
>> snd_seq_oss joydev pcmcia snd_seq_midi snd_rawmidi snd_seq_midi_event
>> snd_seq snd_timer snd_seq_device tifm_7xx1 yenta_socket rsrc_nonstatic
>> pcmcia_core rng_core ac tifm_core snd rtc_cmos rtc_core rtc_lib
>> battery button iTCO_wdt iTCO_vendor_support psmouse soundcore
>> snd_page_alloc evdev ohci1394 sr_mod cdrom ehci_hcd ieee1394 uhci_hcd
>> usbcore sky2 thermal processor fan thermal_sys hwmon fuse [last
>> unloaded: cfg80211]
>> Pid: 12603, comm: usb-storage Tainted: G        W  2.6.29-rc3-git3 #4
>> Call Trace:
>>  [<ffffffff8023ac8f>] warn_slowpath+0xd3/0x10f
>>  [<ffffffff805125a9>] ? wait_for_common+0xbd/0xfb
>>  [<ffffffff805125d7>] ? wait_for_common+0xeb/0xfb
>>  [<ffffffff802351fb>] ? default_wake_function+0x0/0xf
>>  [<ffffffffa0188da5>] ? usb_stor_msg_common+0x134/0x166 [usb_storage]
>>  [<ffffffffa018920c>] ? usb_stor_bulk_transfer_buf+0x7c/0x85 [usb_storage]
>>  [<ffffffffa01898b3>] ? usb_stor_Bulk_transport+0x156/0x297 [usb_storage]
>>  [<ffffffffa0188c0f>] last_sector_hacks+0x103/0x165 [usb_storage]
>>  [<ffffffffa01895f7>] usb_stor_invoke_transport+0x2ce/0x2db [usb_storage]
>>  [<ffffffffa0188a36>] usb_stor_transparent_scsi_command+0x9/0xb [usb_storage]
>>  [<ffffffffa018ac2b>] usb_stor_control_thread+0x14e/0x1ff [usb_storage]
>>  [<ffffffff80514ca4>] ? _spin_unlock_irqrestore+0x4e/0x5c
>>  [<ffffffffa018aadd>] ? usb_stor_control_thread+0x0/0x1ff [usb_storage]
>>  [<ffffffff8024e88d>] kthread+0x49/0x76
>>  [<ffffffff8020c87a>] child_rip+0xa/0x20
>>  [<ffffffff8024e844>] ? kthread+0x0/0x76
>>  [<ffffffff8020c870>] ? child_rip+0x0/0x20
>> ---[ end trace d209a224db943e8f ]---
>> ohci_hcd 0000:05:00.0: urb ffff880043c29b58 path 2 ep1in 92120000 cc 9
>> --> status -121
>> sr2: scsi3-mmc drive: 8x/40x writer xa/form2 cdda tray
>> sr 7:0:0:1: Attached scsi CD-ROM sr2
>> sr 7:0:0:1: Attached scsi generic sg5 type 5
>> usb-storage: device scan complete
>> ohci_hcd 0000:05:00.0: urb ffff88004c50e948 path 2 ep1in 43120000 cc 4
>> --> status -32
>> ohci_hcd 0000:05:00.0: urb ffff88004c50eb58 path 2 ep1in 92120000 cc 9
>> --> status -121
>> ohci_hcd 0000:05:00.0: urb ffff8800509cab58 path 2 ep1in 42160000 cc 4
>> --> status -32
>> usb 6-2:1.0: uevent
>> usb 6-2: uevent
>> usb 6-1:1.0: uevent
>> usb 6-1: uevent
>> sky2 eth0: disabling interface
>> wlan0: disassociating by local choice (reason=3)
>> PM: Syncing filesystems ... done.
>> PM: Preparing system for mem sleep
>> Freezing user space processes ... (elapsed 0.01 seconds) done.
>> Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
>> PM: Entering mem sleep
>> Suspending console(s) (use no_console_suspend to debug)
>> usb 6-2: usb suspend
>> usb 6-1: usb suspend
>> hub 6-0:1.0: hub_suspend
>> usb usb6: bus suspend
>> ohci_hcd 0000:05:00.0: suspend root hub
>> ohci_hcd 0000:05:00.0: PCI INT A disabled
>> ohci_hcd 0000:05:00.0: wakeup: 0
>> ohci_hcd 0000:05:00.0: --> PCI D0 legacy
>> sd 0:0:0:0: [sda] Synchronizing SCSI cache
>> sd 0:0:0:0: [sda] Stopping disk
>> pci 0000:00:02.0: PCI INT A disabled
>> ACPI handle has no context!
>> ACPI handle has no context!
>> tifm_7xx1 0000:04:09.2: PME# disabled
>> tifm_7xx1 0000:04:09.2: PCI INT A disabled
>> ACPI handle has no context!
>> ACPI handle has no context!
>> sky2 0000:02:00.0: PME# disabled
>> ahci 0000:00:1f.2: power state changed by ACPI to D3
>> ata6: port disabled. ignoring.
>> ata_piix 0000:00:1f.1: PCI INT B disabled
>> ehci_hcd 0000:00:1d.7: PCI INT A disabled
>> ehci_hcd 0000:00:1d.7: PME# disabled
>> ehci_hcd 0000:00:1d.7: wakeup: 0
>> ehci_hcd 0000:00:1d.7: --> PCI D3
>> uhci_hcd 0000:00:1d.3: uhci_pci_suspend
>> uhci_hcd 0000:00:1d.3: PCI INT D disabled
>> uhci_hcd 0000:00:1d.3: wakeup: 0
>> uhci_hcd 0000:00:1d.3: --> PCI D0 legacy
>> uhci_hcd 0000:00:1d.2: uhci_pci_suspend
>> uhci_hcd 0000:00:1d.2: PCI INT C disabled
>> uhci_hcd 0000:00:1d.2: wakeup: 0
>> uhci_hcd 0000:00:1d.2: --> PCI D0 legacy
>> uhci_hcd 0000:00:1d.1: uhci_pci_suspend
>> uhci_hcd 0000:00:1d.1: PCI INT B disabled
>> uhci_hcd 0000:00:1d.1: wakeup: 0
>> uhci_hcd 0000:00:1d.1: --> PCI D0 legacy
>> uhci_hcd 0000:00:1d.0: uhci_pci_suspend
>> uhci_hcd 0000:00:1d.0: PCI INT A disabled
>> uhci_hcd 0000:00:1d.0: wakeup: 0
>> uhci_hcd 0000:00:1d.0: --> PCI D0 legacy
>> HDA Intel 0000:00:1b.0: PCI INT A disabled
>> ACPI: Preparing to enter system sleep state S3
>> Disabling non-boot CPUs ...
>> CPU 1 is now offline
>> lockdep: fixing up alternatives.
>> SMP alternatives: switching to UP code
>> CPU1 is down
>>
>> After resume:
>>
>> yenta_cardbus 0000:04:09.0: restoring config space at offset 0xf (was
>> 0x54001ff, writing 0x50001ff)
>> ...
>> ehci_hcd 0000:00:1d.7: resume root hub
>> hub 5-0:1.0: hub_resume
>> ohci_hcd 0000:05:00.0: enabling device (0000 -> 0002)
>> ohci_hcd 0000:05:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
>> ohci_hcd 0000:05:00.0: setting latency timer to 64
>> ohci_hcd 0000:05:00.0: BIOS/SMM active, control ffffffff
>> ohci_hcd 0000:05:00.0: USB HC TakeOver from BIOS/SMM
>> ohci_hcd 0000:05:00.0: USB HC takeover failed!  (BIOS/SMM bug)
>> ohci_hcd 0000:05:00.0: USB HC reset timed out!
>> ohci_hcd 0000:05:00.0: can't restart, -1
>> usb usb6: root hub lost power or was reset
>> ohci_hcd 0000:05:00.0: already suspended
>> usb usb6: usb resume
>> ohci_hcd 0000:05:00.0: BIOS/SMM active, control ffffffff
>> ohci_hcd 0000:05:00.0: USB HC TakeOver from BIOS/SMM
>> ohci_hcd 0000:05:00.0: USB HC takeover failed!  (BIOS/SMM bug)
>> ohci_hcd 0000:05:00.0: USB HC reset timed out!
>> ohci_hcd 0000:05:00.0: can't restart, -1
>> usb usb6: root hub lost power or was reset
>> usb usb6: bus resume fail, err -1
>> ohci_hcd 0000:05:00.0: HC died; cleaning up
>> pm_op(): usb_dev_resume+0x0/0x10 [usbcore] returns -1
>> PM: Device usb6 failed to resume: error -1
>> pm_op(): usb_dev_resume+0x0/0x10 [usbcore] returns -19
>> PM: Device 6-1 failed to resume: error -19
>> pm_op(): usb_dev_resume+0x0/0x10 [usbcore] returns -19
>> PM: Device 6-2 failed to resume: error -19
>> PM: Finishing wakeup.
>> Restarting tasks ... <7>hub 5-0:1.0: state 7 ports 8 chg 0000 evt 0000
>> hub 6-0:1.0: state 0 ports 2 chg 0000 evt 0000
>> usb 6-1: USB disconnect, address 2
>> usb 6-1: unregistering device
>> usb 6-1: usb_disable_device nuking all URBs
>> usb 6-1: unregistering interface 6-1:1.0
>> done.
>> sd 6:0:0:0: [sdb] READ CAPACITY failed
>> sd 6:0:0:0: [sdb] Result: hostbyte=DID_NO_CONNECT
>> driverbyte=DRIVER_OK,SUGGEST_OK
>> sd 6:0:0:0: [sdb] Sense not available.
>> sd 6:0:0:0: [sdb] Write Protect is off
>> sd 6:0:0:0: [sdb] Mode Sense: 00 00 00 00
>> sd 6:0:0:0: [sdb] Assuming drive cache: write through
>> usb 6-1:1.0: uevent
>> usb 6-1: uevent
>> usb 6-2: USB disconnect, address 3
>> usb 6-2: unregistering device
>> usb 6-2: usb_disable_device nuking all URBs
>> usb 6-2: unregistering interface 6-2:1.0
>> scsi 7:0:0:0: rejecting I/O to dead device
>> scsi 7:0:0:0: rejecting I/O to dead device
>> scsi 7:0:0:0: rejecting I/O to dead device
>> scsi 7:0:0:0: rejecting I/O to dead device
>> scsi 7:0:0:0: [sdc] READ CAPACITY failed
>> scsi 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT
>> driverbyte=DRIVER_OK,SUGGEST_OK
>> scsi 7:0:0:0: [sdc] Sense not available.
>> scsi 7:0:0:0: rejecting I/O to dead device
>> scsi 7:0:0:0: [sdc] Write Protect is off
>> scsi 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
>> scsi 7:0:0:0: [sdc] Assuming drive cache: write through
>> usb 6-2:1.0: uevent
>> usb 6-2: uevent
>> scsi 6:0:0:0: rejecting I/O to dead device
>
> Rafael
>
