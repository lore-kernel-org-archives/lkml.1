Return-Path: <linux-kernel-owner+w=401wt.eu-S967289AbXEGXhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967289AbXEGXhZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 19:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967239AbXEGXhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 19:37:21 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:52096 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967237AbXEGXhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 19:37:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=k7iXnvelLSTiHyji9ba0gdlXh6lkFEGWFCed9fjUixPH0p3mDv1KMUnH1seApf06Tev10rAMPBlG6TwxAYwqrHv3X2gzj7U3GTzZgFyiCWjRYnDD+12+c5H83AyUUMnDnOrVOW10pctP3hu0k7Q89Osh2ECu5eky/M564FSpB7k=
Message-ID: <a44ae5cd0705071637x59d4579bm369b44c7975bea37@mail.gmail.com>
Date: Mon, 7 May 2007 16:37:17 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.21-mm1 -- Hibernation locked up and didn't power down (had to hold power button down for five seconds)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is probably more log info than you need, but I am including it in
case it helps.
This log shows another manifestation of the time confusion on wakeup.
This is the portion beginning with the hibernation initiation:

[ 5482.518162] PM: Removing info for No Bus:eth0
[ 5482.581594] ACPI: PCI interrupt for device 0000:01:00.0 disabled
[ 5482.664582] PM: Removing info for No Bus:eth1
[ 5482.740270] ACPI: PCI interrupt for device 0000:01:06.0 disabled
[ 5483.947270] [ACPI Debug]  String: [0x1C] "Temperature increasing: _Q80"
[ 5485.142037] PM: suspend-to-disk mode set to 'shutdown'
[ 5485.142618] swsusp: Basic memory bitmaps created
[ 5485.153011] Stopping tasks ... done.
[ 5485.783751] Shrinking memory... -[ACPI Debug]  String: [0x1C]
"Temperature increasing: _Q80"
[ 5485.974969]done (101216 pages freed)
[ 5487.254038] Freed 404864 kbytes in 1.47 seconds (275.41 MB/s)
[ 5487.254042] Suspending console(s)
[ 5487.254050] Suspending device event4
[ 5487.254056] Suspending device input13
[ 5487.254059] Suspending device event3
[ 5487.254062] Suspending device input12
[ 5487.254065] Suspending device event2
[ 5487.254068] Suspending device input11
[ 5487.254071] Suspending device bluetooth
[ 5487.254074] platform bluetooth: freeze
[ 5487.254078] Suspending device apm_bios
[ 5487.254081] Suspending device vcsa7
[ 5487.254084] Suspending device vcs7
[ 5487.254087] Suspending device vcsa2
[ 5487.254090] Suspending device vcs2
[ 5487.254093] Suspending device vcsa6
[ 5487.254096] Suspending device vcs6
[ 5487.254099] Suspending device vcsa1
[ 5487.254101] Suspending device vcs1
[ 5487.254104] Suspending device vcsa3
[ 5487.254107] Suspending device vcs3
[ 5487.254110] Suspending device vcsa5
[ 5487.254113] Suspending device vcs5
[ 5487.254116] Suspending device vcsa4
[ 5487.254119] Suspending device vcs4
[ 5487.254122] Suspending device fuse
[ 5487.254125] Suspending device mixer
[ 5487.254128] Suspending device controlC0
[ 5487.254131] Suspending device 0-0:unknown codec
[ 5487.254134] ac97 0-0:unknown codec: freeze
[ 5487.254137] Suspending device audio
[ 5487.254140] Suspending device dsp
[ 5487.254143] Suspending device pcmC0D0c
[ 5487.254145] Suspending device pcmC0D0p
[ 5487.254148] Suspending device adsp
[ 5487.254151] Suspending device pcmC0D1c
[ 5487.254154] Suspending device pcmC0D2c
[ 5487.254157] Suspending device pcmC0D3c
[ 5487.254160] Suspending device pcmC0D4p
[ 5487.254163] Suspending device card0
[ 5487.254166] Suspending device sequencer2
[ 5487.254169] Suspending device sequencer
[ 5487.254172] Suspending device mmc2
[ 5487.254175] Suspending device mmc1
[ 5487.254178] Suspending device mmc0
[ 5487.254181] Suspending device pcmcia_socket0
[ 5487.254184] Suspending device seq
[ 5487.254187] Suspending device timer
[ 5487.254190] Suspending device event1
[ 5487.254193] Suspending device mouse0
[ 5487.254196] Suspending device input1
[ 5487.254199] Suspending device rtc
[ 5487.254202] Suspending device watchdog
[ 5487.254205] Suspending device iTCO_wdt
[ 5487.254207] iTCO_wdt iTCO_wdt: freeze
[ 5487.254210] Suspending device agpgart
[ 5487.254213] Suspending device 00c09f00004fec18
[ 5487.254217] Suspending device fw-host0
[ 5487.254220] Suspending device 1:0:0:0
[ 5487.254223] sr 1:0:0:0: freeze
[ 5487.254277] Suspending device target1:0:0
[ 5487.254280] Suspending device 0:0:0:0
[ 5487.254282] sd 0:0:0:0: freeze
[ 5487.254289] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 5487.254773] Suspending device target0:0:0
[ 5487.254776] Suspending device host1
[ 5487.254779] Suspending device host0
[ 5487.254782] Suspending device usbdev4.1_ep81
[ 5487.254786] usb_endpoint usbdev4.1_ep81: PM: suspend 0->1, parent
4-0:1.0 already 2
[ 5487.254789] Suspending device 4-0:1.0
[ 5487.254792] hub 4-0:1.0: PM: suspend 2-->1
[ 5487.254794] hub 4-0:1.0: PM: suspend 2->1, parent usb4 already 2
[ 5487.254797] Suspending device usbdev4.1_ep00
[ 5487.254800] usb_endpoint usbdev4.1_ep00: PM: suspend 0->1, parent
usb4 already 2
[ 5487.254803] Suspending device usb4
[ 5487.254806] usb usb4: PM: suspend 2-->1
[ 5487.254809] Suspending device usbdev3.1_ep81
[ 5487.254812] usb_endpoint usbdev3.1_ep81: PM: suspend 0->1, parent
3-0:1.0 already 2
[ 5487.254815] Suspending device 3-0:1.0
[ 5487.254817] hub 3-0:1.0: PM: suspend 2-->1
[ 5487.254819] hub 3-0:1.0: PM: suspend 2->1, parent usb3 already 2
[ 5487.254822] Suspending device usbdev3.1_ep00
[ 5487.254825] usb_endpoint usbdev3.1_ep00: PM: suspend 0->1, parent
usb3 already 2
[ 5487.254828] Suspending device usb3
[ 5487.254830] usb usb3: PM: suspend 2-->1
[ 5487.254833] Suspending device usbdev2.1_ep81
[ 5487.254836] usb_endpoint usbdev2.1_ep81: PM: suspend 0->1, parent
2-0:1.0 already 2
[ 5487.254839] Suspending device 2-0:1.0
[ 5487.254841] hub 2-0:1.0: PM: suspend 2-->1
[ 5487.254843] hub 2-0:1.0: PM: suspend 2->1, parent usb2 already 2
[ 5487.254847] Suspending device usbdev2.1_ep00
[ 5487.254849] usb_endpoint usbdev2.1_ep00: PM: suspend 0->1, parent
usb2 already 2
[ 5487.254853] Suspending device usb2
[ 5487.254854] usb usb2: PM: suspend 2-->1
[ 5487.254857] Suspending device usbdev1.1_ep81
[ 5487.254860] usb_endpoint usbdev1.1_ep81: PM: suspend 0->1, parent
1-0:1.0 already 2
[ 5487.254863] Suspending device 1-0:1.0
[ 5487.254865] hub 1-0:1.0: PM: suspend 2-->1
[ 5487.254868] hub 1-0:1.0: PM: suspend 2->1, parent usb1 already 2
[ 5487.254871] Suspending device usbdev1.1_ep00
[ 5487.254873] usb_endpoint usbdev1.1_ep00: PM: suspend 0->1, parent
usb1 already 2
[ 5487.254877] Suspending device usb1
[ 5487.254878] usb usb1: PM: suspend 2-->1
[ 5487.254881] Suspending device vcsa8
[ 5487.254884] Suspending device vcs8
[ 5487.254887] Suspending device event0
[ 5487.254890] Suspending device input0
[ 5487.254893] Suspending device serio1
[ 5487.254895] psmouse serio1: freeze
[ 5487.254899] Suspending device mice
[ 5487.254902] Suspending device serio0
[ 5487.254904] atkbd serio0: freeze
[ 5487.254907] Suspending device i8042
[ 5487.254909] i8042 i8042: freeze
[ 5487.254912] Suspending device lo
[ 5487.254915] Suspending device bond0
[ 5487.254918] Suspending device pktcdvd
[ 5487.254921] Suspending device isa
[ 5487.254924] Suspending device ttyS1
[ 5487.254927] Suspending device ttyS0
[ 5487.254930] Suspending device serial8250
[ 5487.254932] serial8250 serial8250: freeze
[ 5487.254937] Suspending device hpet
[ 5487.254940] Suspending device tty63
[ 5487.254943] Suspending device tty62
[ 5487.254946] Suspending device tty61
[ 5487.254949] Suspending device tty60
[ 5487.254952] Suspending device tty59
[ 5487.254955] Suspending device tty58
[ 5487.254957] Suspending device tty57
[ 5487.254960] Suspending device tty56
[ 5487.254963] Suspending device tty55
[ 5487.254966] Suspending device tty54
[ 5487.254969] Suspending device tty53
[ 5487.254972] Suspending device tty52
[ 5487.254974] Suspending device tty51
[ 5487.254977] Suspending device tty50
[ 5487.254980] Suspending device tty49
[ 5487.254983] Suspending device tty48
[ 5487.254986] Suspending device tty47
[ 5487.254989] Suspending device tty46
[ 5487.254991] Suspending device tty45
[ 5487.254994] Suspending device tty44
[ 5487.254997] Suspending device tty43
[ 5487.255000] Suspending device tty42
[ 5487.255003] Suspending device tty41
[ 5487.255006] Suspending device tty40
[ 5487.255008] Suspending device tty39
[ 5487.255011] Suspending device tty38
[ 5487.255014] Suspending device tty37
[ 5487.255017] Suspending device tty36
[ 5487.255020] Suspending device tty35
[ 5487.255023] Suspending device tty34
[ 5487.255026] Suspending device tty33
[ 5487.255028] Suspending device tty32
[ 5487.255031] Suspending device tty31
[ 5487.255034] Suspending device tty30
[ 5487.255037] Suspending device tty29
[ 5487.255040] Suspending device tty28
[ 5487.255043] Suspending device tty27
[ 5487.255045] Suspending device tty26
[ 5487.255048] Suspending device tty25
[ 5487.255051] Suspending device tty24
[ 5487.255054] Suspending device tty23
[ 5487.255057] Suspending device tty22
[ 5487.255059] Suspending device tty21
[ 5487.255062] Suspending device tty20
[ 5487.255065] Suspending device tty19
[ 5487.255068] Suspending device tty18
[ 5487.255071] Suspending device tty17
[ 5487.255074] Suspending device tty16
[ 5487.255076] Suspending device tty15
[ 5487.255079] Suspending device tty14
[ 5487.255082] Suspending device tty13
[ 5487.255085] Suspending device tty12
[ 5487.255088] Suspending device tty11
[ 5487.255091] Suspending device tty10
[ 5487.255093] Suspending device tty9
[ 5487.255096] Suspending device tty8
[ 5487.255099] Suspending device tty7
[ 5487.255102] Suspending device tty6
[ 5487.255105] Suspending device tty5
[ 5487.255108] Suspending device tty4
[ 5487.255110] Suspending device tty3
[ 5487.255113] Suspending device tty2
[ 5487.255116] Suspending device tty1
[ 5487.255119] Suspending device vcsa
[ 5487.255122] Suspending device vcs
[ 5487.255125] Suspending device tty0
[ 5487.255127] Suspending device ptmx
[ 5487.255130] Suspending device console
[ 5487.255133] Suspending device tty
[ 5487.255136] Suspending device vtcon1
[ 5487.255139] Suspending device fb0
[ 5487.255142] Suspending device vesafb.0
[ 5487.255144] vesafb vesafb.0: freeze
[ 5487.255147] Suspending device snapshot
[ 5487.255150] Suspending device pcspkr
[ 5487.255152] platform pcspkr: freeze
[ 5487.255155] Suspending device oldmem
[ 5487.255158] Suspending device kmsg
[ 5487.255161] Suspending device urandom
[ 5487.255164] Suspending device random
[ 5487.255167] Suspending device full
[ 5487.255169] Suspending device zero
[ 5487.255172] Suspending device port
[ 5487.255175] Suspending device null
[ 5487.255178] Suspending device kmem
[ 5487.255181] Suspending device mem
[ 5487.255184] Suspending device 00:06
[ 5487.255186] i8042 aux 00:06: freeze
[ 5487.255189] Suspending device 00:05
[ 5487.255191] i8042 kbd 00:05: freeze
[ 5487.255194] Suspending device 00:04
[ 5487.255196] system 00:04: freeze
[ 5487.255199] Suspending device 00:03
[ 5487.255201] pnp 00:03: freeze
[ 5487.255204] Suspending device 00:02
[ 5487.255206] pnp 00:02: freeze
[ 5487.255209] Suspending device 00:01
[ 5487.255211] pnp 00:01: freeze
[ 5487.255213] Suspending device 00:00
[ 5487.255215] pnp 00:00: freeze
[ 5487.255218] Suspending device pnp0
[ 5487.255221] Suspending device 0000:01:09.4
[ 5487.255224] sdhci 0000:01:09.4: freeze
[ 5487.255226] sdhci [sdhci_suspend()]: Suspending...
[ 5487.255233] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
[ 5487.255242] mmc1: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
[ 5487.255250] mmc2: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
[ 5487.255867] ACPI: PCI interrupt for device 0000:01:09.4 disabled
[ 5487.272001] Suspending device 0000:01:09.3
[ 5487.272003] tifm_7xx1 0000:01:09.3: freeze
[ 5487.272072] ACPI: PCI interrupt for device 0000:01:09.3 disabled
[ 5487.289510] Suspending device 0000:01:09.2
[ 5487.289512] ohci1394 0000:01:09.2: freeze
[ 5487.305982] Suspending device 0000:01:09.0
[ 5487.305984] yenta_cardbus 0000:01:09.0: freeze
[ 5487.306069] Suspending device 0000:01:06.0
[ 5487.306071] pci 0000:01:06.0: freeze
[ 5487.306119] Suspending device 0000:01:00.0
[ 5487.306121] pci 0000:01:00.0: freeze
[ 5487.306168] Suspending device 0000:00:1f.6
[ 5487.306170] pci 0000:00:1f.6: freeze
[ 5487.306215] Suspending device 0000:00:1f.5
[ 5487.306217] Intel ICH 0000:00:1f.5: freeze
[ 5487.306394] codec_write 0: semaphore is not ready for register 0x26
[ 5487.306454] ACPI: PCI interrupt for device 0000:00:1f.5 disabled
[ 5487.306499] Suspending device 0000:00:1f.3
[ 5487.306501] pci 0000:00:1f.3: freeze
[ 5487.306538] Suspending device 0000:00:1f.1
[ 5487.306540] ata_piix 0000:00:1f.1: freeze
[ 5487.306633] ACPI: PCI interrupt for device 0000:00:1f.1 disabled
[ 5487.306636] Suspending device 0000:00:1f.0
[ 5487.306638] pci 0000:00:1f.0: freeze
[ 5487.306675] Suspending device 0000:00:1e.0
[ 5487.306677] pci 0000:00:1e.0: freeze
[ 5487.306714] Suspending device 0000:00:1d.7
[ 5487.306716] ehci_hcd 0000:00:1d.7: freeze
[ 5487.306789] ACPI: PCI interrupt for device 0000:00:1d.7 disabled
[ 5487.321896] ehci_hcd 0000:00:1d.7: --> PCI D3/wakeup
[ 5487.321925] Suspending device 0000:00:1d.2
[ 5487.321927] uhci_hcd 0000:00:1d.2: freeze
[ 5487.321930] uhci_hcd 0000:00:1d.2: uhci_suspend
[ 5487.321976] ACPI: PCI interrupt for device 0000:00:1d.2 disabled
[ 5487.321978] uhci_hcd 0000:00:1d.2: --> PCI D0/legacy
[ 5487.321981] Suspending device 0000:00:1d.1
[ 5487.321983] uhci_hcd 0000:00:1d.1: freeze
[ 5487.321985] uhci_hcd 0000:00:1d.1: uhci_suspend
[ 5487.322030] ACPI: PCI interrupt for device 0000:00:1d.1 disabled
[ 5487.322032] uhci_hcd 0000:00:1d.1: --> PCI D0/legacy
[ 5487.322035] Suspending device 0000:00:1d.0
[ 5487.322037] uhci_hcd 0000:00:1d.0: freeze
[ 5487.322039] uhci_hcd 0000:00:1d.0: uhci_suspend
[ 5487.322084] ACPI: PCI interrupt for device 0000:00:1d.0 disabled
[ 5487.322086] uhci_hcd 0000:00:1d.0: --> PCI D0/legacy
[ 5487.322089] Suspending device 0000:00:02.1
[ 5487.322091] pci 0000:00:02.1: freeze
[ 5487.322128] Suspending device 0000:00:02.0
[ 5487.322130] pci 0000:00:02.0: freeze
[ 5487.322167] Suspending device 0000:00:00.3
[ 5487.322169] pci 0000:00:00.3: freeze
[ 5487.322197] Suspending device 0000:00:00.1
[ 5487.322199] pci 0000:00:00.1: freeze
[ 5487.322227] Suspending device 0000:00:00.0
[ 5487.322230] agpgart-intel 0000:00:00.0: freeze
[ 5487.322278] Suspending device pci0000:00
[ 5487.322282] Suspending device thermal:01
[ 5487.322284] acpi thermal:01: freeze
[ 5487.322287] Suspending device thermal:00
[ 5487.322289] acpi thermal:00: freeze
[ 5487.322292] Suspending device pnp0c14:00
[ 5487.322294] acpi pnp0c14:00: freeze
[ 5487.322297] Suspending device device:18
[ 5487.322299] acpi device:18: freeze
[ 5487.322301] Suspending device device:17
[ 5487.322303] acpi device:17: freeze
[ 5487.322306] Suspending device device:16
[ 5487.322308] acpi device:16: freeze
[ 5487.322311] Suspending device device:15
[ 5487.322313] acpi device:15: freeze
[ 5487.322316] Suspending device device:14
[ 5487.322318] acpi device:14: freeze
[ 5487.322321] Suspending device device:13
[ 5487.322323] acpi device:13: freeze
[ 5487.322326] Suspending device device:12
[ 5487.322328] acpi device:12: freeze
[ 5487.322330] Suspending device device:11
[ 5487.322333] acpi device:11: freeze
[ 5487.322335] Suspending device device:10
[ 5487.322337] acpi device:10: freeze
[ 5487.322340] Suspending device device:0f
[ 5487.322342] acpi device:0f: freeze
[ 5487.322345] Suspending device device:0e
[ 5487.322347] acpi device:0e: freeze
[ 5487.322349] Suspending device device:0d
[ 5487.322352] acpi device:0d: freeze
[ 5487.322354] Suspending device device:0c
[ 5487.322356] acpi device:0c: freeze
[ 5487.322359] Suspending device device:0b
[ 5487.322361] acpi device:0b: freeze
[ 5487.322364] Suspending device SYN0110:00
[ 5487.322366] acpi SYN0110:00: freeze
[ 5487.322369] Suspending device PNP0303:00
[ 5487.322371] acpi PNP0303:00: freeze
[ 5487.322374] Suspending device PNP0C09:00
[ 5487.322376] ec PNP0C09:00: freeze
[ 5487.322379] Suspending device PNP0C02:00
[ 5487.322381] acpi PNP0C02:00: freeze
[ 5487.322384] Suspending device PNP0200:00
[ 5487.322386] acpi PNP0200:00: freeze
[ 5487.322388] Suspending device PNP0C04:00
[ 5487.322390] acpi PNP0C04:00: freeze
[ 5487.322393] Suspending device PNP0B00:00
[ 5487.322395] acpi PNP0B00:00: freeze
[ 5487.322398] Suspending device PNP0000:00
[ 5487.322400] acpi PNP0000:00: freeze
[ 5487.322403] Suspending device PNP0100:00
[ 5487.322405] acpi PNP0100:00: freeze
[ 5487.322408] Suspending device PNP0C0F:07
[ 5487.322410] pci_link PNP0C0F:07: freeze
[ 5487.322413] Suspending device PNP0C0F:06
[ 5487.322415] pci_link PNP0C0F:06: freeze
[ 5487.322418] Suspending device PNP0C0F:05
[ 5487.322420] pci_link PNP0C0F:05: freeze
[ 5487.322423] Suspending device PNP0C0F:04
[ 5487.322425] pci_link PNP0C0F:04: freeze
[ 5487.322428] Suspending device PNP0C0F:03
[ 5487.322430] pci_link PNP0C0F:03: freeze
[ 5487.322433] Suspending device PNP0C0F:02
[ 5487.322435] pci_link PNP0C0F:02: freeze
[ 5487.322438] Suspending device PNP0C0F:01
[ 5487.322440] pci_link PNP0C0F:01: freeze
[ 5487.322443] Suspending device PNP0C0F:00
[ 5487.322445] pci_link PNP0C0F:00: freeze
[ 5487.322447] Suspending device device:0a
[ 5487.322449] acpi device:0a: freeze
[ 5487.322452] Suspending device device:09
[ 5487.322454] acpi device:09: freeze
[ 5487.322457] Suspending device device:08
[ 5487.322459] acpi device:08: freeze
[ 5487.322462] Suspending device device:07
[ 5487.322464] acpi device:07: freeze
[ 5487.322467] Suspending device device:06
[ 5487.322469] acpi device:06: freeze
[ 5487.322471] Suspending device device:05
[ 5487.322473] acpi device:05: freeze
[ 5487.322476] Suspending device device:04
[ 5487.322478] acpi device:04: freeze
[ 5487.322481] Suspending device device:03
[ 5487.322483] acpi device:03: freeze
[ 5487.322486] Suspending device device:02
[ 5487.322488] acpi device:02: freeze
[ 5487.322491] Suspending device video:00
[ 5487.322493] video video:00: freeze
[ 5487.322496] Suspending device device:01
[ 5487.322498] acpi device:01: freeze
[ 5487.322500] Suspending device PNP0A03:00
[ 5487.322503] pci_root PNP0A03:00: freeze
[ 5487.322505] Suspending device PNP0C0E:00
[ 5487.322508] button PNP0C0E:00: freeze
[ 5487.322511] Suspending device PNP0C0D:00
[ 5487.322513] button PNP0C0D:00: freeze
[ 5487.322516] Suspending device PNP0C0A:00
[ 5487.322518] battery PNP0C0A:00: freeze
[ 5487.322520] Suspending device ACPI0003:00
[ 5487.322523] ac ACPI0003:00: freeze
[ 5487.322525] Suspending device device:00
[ 5487.322527] acpi device:00: freeze
[ 5487.322530] Suspending device ACPI0007:00
[ 5487.322533] processor ACPI0007:00: freeze
[ 5487.322535] Suspending device button_power:00
[ 5487.322538] button button_power:00: freeze
[ 5487.322541] Suspending device acpi_system:00
[ 5487.322543] acpi acpi_system:00: freeze
[ 5487.322546] Suspending device vtcon0
[ 5487.322549] Suspending device platform
[ 5487.322552] PM: snapshotting memory.
[ 5487.322555] platform bluetooth: LATE freeze
[ 5487.322559] iTCO_wdt iTCO_wdt: LATE freeze
[ 5487.322562] serial8250 serial8250: LATE freeze
[ 5487.322566] vesafb vesafb.0: LATE freeze
[ 5487.322568] platform pcspkr: LATE freeze
[ 5487.322571] sdhci 0000:01:09.4: LATE freeze
[ 5487.322573] tifm_7xx1 0000:01:09.3: LATE freeze
[ 5487.322575] ohci1394 0000:01:09.2: LATE freeze
[ 5487.322577] yenta_cardbus 0000:01:09.0: LATE freeze
[ 5487.322579] pci 0000:01:06.0: LATE freeze
[ 5487.322581] pci 0000:01:00.0: LATE freeze
[ 5487.322583] pci 0000:00:1f.6: LATE freeze
[ 5487.322584] Intel ICH 0000:00:1f.5: LATE freeze
[ 5487.322586] pci 0000:00:1f.3: LATE freeze
[ 5487.322588] pci 0000:00:1f.0: LATE freeze
[ 5487.322590] pci 0000:00:1e.0: LATE freeze
[ 5487.322592] pci 0000:00:02.1: LATE freeze
[ 5487.322594] pci 0000:00:02.0: LATE freeze
[ 5487.322596] pci 0000:00:00.3: LATE freeze
[ 5487.322598] pci 0000:00:00.1: LATE freeze
[ 5487.322599] agpgart-intel 0000:00:00.0: LATE freeze
[ 5487.322711] swsusp: critical section:
[ 5487.365827] swsusp: Need to copy 122651 pages
[ 5487.365831] swsusp: Normal pages needed: 114026 + 1024 + 24,
available pages: 122386

At this point, I had to hard power down.

[18018804.127770] Intel machine check architecture supported.
[18018804.127778] Intel machine check reporting enabled on CPU#0.
[18018804.128076] agpgart-intel 0000:00:00.0: EARLY resume
[18018804.128080] PCI: Calling quirk c01cbfe6 for 0000:00:00.0
[18018804.128083] pci 0000:00:00.1: EARLY resume
[18018804.128085] PCI: Calling quirk c01cbfe6 for 0000:00:00.1
[18018804.128087] pci 0000:00:00.3: EARLY resume
[18018804.128090] PCI: Calling quirk c01cbfe6 for 0000:00:00.3
[18018804.128092] pci 0000:00:02.0: EARLY resume
[18018804.128095] PCI: Calling quirk c01cbfe6 for 0000:00:02.0
[18018804.128097] pci 0000:00:02.1: EARLY resume
[18018804.128099] PCI: Calling quirk c01cbfe6 for 0000:00:02.1
[18018804.128102] uhci_hcd 0000:00:1d.0: EARLY resume
[18018804.128105] PCI: Calling quirk c01cbfe6 for 0000:00:1d.0
[18018804.128107] uhci_hcd 0000:00:1d.1: EARLY resume
[18018804.128110] PCI: Calling quirk c01cbfe6 for 0000:00:1d.1
[18018804.128112] uhci_hcd 0000:00:1d.2: EARLY resume
[18018804.128115] PCI: Calling quirk c01cbfe6 for 0000:00:1d.2
[18018804.128117] ehci_hcd 0000:00:1d.7: EARLY resume
[18018804.128120] PCI: Calling quirk c01cbfe6 for 0000:00:1d.7
[18018804.128122] pci 0000:00:1e.0: EARLY resume
[18018804.128125] PCI: Calling quirk c01cbfe6 for 0000:00:1e.0
[18018804.128127] pci 0000:00:1f.0: EARLY resume
[18018804.128129] PCI: Calling quirk c01cc232 for 0000:00:1f.0
[18018804.128132] PCI: Calling quirk c01cbfe6 for 0000:00:1f.0
[18018804.128135] ata_piix 0000:00:1f.1: EARLY resume
[18018804.128137] PCI: Calling quirk c01cbfe6 for 0000:00:1f.1
[18018804.128140] pci 0000:00:1f.3: EARLY resume
[18018804.128142] PCI: Calling quirk c01cbfe6 for 0000:00:1f.3
[18018804.128145] Intel ICH 0000:00:1f.5: EARLY resume
[18018804.128147] PCI: Calling quirk c01cbfe6 for 0000:00:1f.5
[18018804.128150] pci 0000:00:1f.6: EARLY resume
[18018804.128152] PCI: Calling quirk c01cbfe6 for 0000:00:1f.6
[18018804.128155] pci 0000:01:00.0: EARLY resume
[18018804.128157] PCI: Calling quirk c01cbfe6 for 0000:01:00.0
[18018804.128159] pci 0000:01:06.0: EARLY resume
[18018804.128162] PCI: Calling quirk c01cbfe6 for 0000:01:06.0
[18018804.128165] yenta_cardbus 0000:01:09.0: EARLY resume
[18018804.128167] PCI: Calling quirk c01cbfe6 for 0000:01:09.0
[18018804.128174] ohci1394 0000:01:09.2: EARLY resume
[18018804.128176] PCI: Calling quirk c01cbfe6 for 0000:01:09.2
[18018804.128179] tifm_7xx1 0000:01:09.3: EARLY resume
[18018804.128181] PCI: Calling quirk c01cbfe6 for 0000:01:09.3
[18018804.128184] sdhci 0000:01:09.4: EARLY resume
[18018804.128187] PCI: Calling quirk c01cbfe6 for 0000:01:09.4
[18018804.128193] platform pcspkr: EARLY resume
[18018804.128195] vesafb vesafb.0: EARLY resume
[18018804.128209] serial8250 serial8250: EARLY resume
[18018804.128212] i8042 i8042: EARLY resume
[18018804.128221] iTCO_wdt iTCO_wdt: EARLY resume
[18018804.128231] platform bluetooth: EARLY resume
[18018804.128269] PM: Image restored successfully.
[18018804.223556] acpi acpi_system:00: resuming
[18018804.223562] button button_power:00: resuming
[18018804.223566] processor ACPI0007:00: resuming
[18018804.223569] acpi device:00: resuming
[18018804.223573] ac ACPI0003:00: resuming
[18018804.223576] battery PNP0C0A:00: resuming
[18018804.223580] button PNP0C0D:00: resuming
[18018804.223583] button PNP0C0E:00: resuming
[18018804.223587] pci_root PNP0A03:00: resuming
[18018804.223590] acpi device:01: resuming
[18018804.223594] video video:00: resuming
[18018804.223597] acpi device:02: resuming
[18018804.223600] acpi device:03: resuming
[18018804.223604] acpi device:04: resuming
[18018804.223607] acpi device:05: resuming
[18018804.223610] acpi device:06: resuming
[18018804.223613] acpi device:07: resuming
[18018804.223617] acpi device:08: resuming
[18018804.223620] acpi device:09: resuming
[18018804.223623] acpi device:0a: resuming
[18018804.223627] pci_link PNP0C0F:00: resuming
[18018804.223630] pci_link PNP0C0F:01: resuming
[18018804.223634] pci_link PNP0C0F:02: resuming
[18018804.223637] pci_link PNP0C0F:03: resuming
[18018804.223640] pci_link PNP0C0F:04: resuming
[18018804.223644] pci_link PNP0C0F:05: resuming
[18018804.223647] pci_link PNP0C0F:06: resuming
[18018804.223650] pci_link PNP0C0F:07: resuming
[18018804.223654] acpi PNP0100:00: resuming
[18018804.223657] acpi PNP0000:00: resuming
[18018804.223660] acpi PNP0B00:00: resuming
[18018804.223664] acpi PNP0C04:00: resuming
[18018804.223667] acpi PNP0200:00: resuming
[18018804.223670] acpi PNP0C02:00: resuming
[18018804.223674] ec PNP0C09:00: resuming
[18018804.223677] acpi PNP0303:00: resuming
[18018804.223680] acpi SYN0110:00: resuming
[18018804.223683] acpi device:0b: resuming
[18018804.223686] acpi device:0c: resuming
[18018804.223690] acpi device:0d: resuming
[18018804.223693] acpi device:0e: resuming
[18018804.223696] acpi device:0f: resuming
[18018804.223700] acpi device:10: resuming
[18018804.223703] acpi device:11: resuming
[18018804.223706] acpi device:12: resuming
[18018804.223709] acpi device:13: resuming
[18018804.223713] acpi device:14: resuming
[18018804.223716] acpi device:15: resuming
[18018804.223719] acpi device:16: resuming
[18018804.223723] acpi device:17: resuming
[18018804.223726] acpi device:18: resuming
[18018804.223729] acpi pnp0c14:00: resuming
[18018804.223733] acpi thermal:00: resuming
[18018804.223736] acpi thermal:01: resuming
[18018804.223741] agpgart-intel 0000:00:00.0: resuming
[18018804.231873] pci 0000:00:00.1: resuming
[18018804.231910] pci 0000:00:00.3: resuming
[18018804.231939] pci 0000:00:02.0: resuming
[18018804.231999] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16
(level, low) -> IRQ 16
[18018804.232005] pci 0000:00:02.1: resuming
[18018804.232054] uhci_hcd 0000:00:1d.0: resuming
[18018804.232058] uhci_hcd 0000:00:1d.0: PCI legacy resume
[18018804.232063] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16
(level, low) -> IRQ 16
[18018804.232071] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[18018804.232110] uhci_hcd 0000:00:1d.0: uhci_resume
[18018804.232117] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[18018804.232119] uhci_hcd 0000:00:1d.0: Performing full reset
[18018804.232136] usb usb1: root hub lost power or was reset
[18018804.232141] usb usb1: suspend_rh
[18018804.232154] uhci_hcd 0000:00:1d.1: resuming
[18018804.232157] uhci_hcd 0000:00:1d.1: PCI legacy resume
[18018804.232162] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19
(level, low) -> IRQ 19
[18018804.232169] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[18018804.232207] uhci_hcd 0000:00:1d.1: uhci_resume
[18018804.232212] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[18018804.232215] uhci_hcd 0000:00:1d.1: Performing full reset
[18018804.232231] usb usb2: root hub lost power or was reset
[18018804.232234] usb usb2: suspend_rh
[18018804.232246] uhci_hcd 0000:00:1d.2: resuming
[18018804.232248] uhci_hcd 0000:00:1d.2: PCI legacy resume
[18018804.232253] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18
(level, low) -> IRQ 18
[18018804.232260] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[18018804.232298] uhci_hcd 0000:00:1d.2: uhci_resume
[18018804.232303] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[18018804.232306] uhci_hcd 0000:00:1d.2: Performing full reset
[18018804.232321] usb usb3: root hub lost power or was reset
[18018804.232324] usb usb3: suspend_rh
[18018804.232336] ehci_hcd 0000:00:1d.7: resuming
[18018804.232347] ehci_hcd 0000:00:1d.7: PCI D0, from previous PCI D3
[18018804.399106] ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 23
(level, low) -> IRQ 23
[18018804.399114] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[18018804.399176] ehci_hcd 0000:00:1d.7: lost power, restarting
[18018804.399178] usb usb4: root hub lost power or was reset
[18018804.399195] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0
ithresh=8 period=1024 Reset HALT
[18018804.403075] ehci_hcd 0000:00:1d.7: debug port 1
[18018804.403084] PCI: cache line size of 32 is not supported by
device 0000:00:1d.7
[18018804.403092] pci 0000:00:1e.0: resuming
[18018804.403114] PM: Writing back config space on device 0000:00:1e.0
at offset 7 (was 2803030, writing 22803030)
[18018804.403142] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[18018804.403148] pci 0000:00:1f.0: resuming
[18018804.403185] ata_piix 0000:00:1f.1: resuming
[18018804.403221] PM: Writing back config space on device 0000:00:1f.1
at offset 1 (was 2800003, writing 2800007)
[18018804.403238] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18
(level, low) -> IRQ 18
[18018804.403245] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[18018804.403276] pci 0000:00:1f.3: resuming
[18018804.403314] Intel ICH 0000:00:1f.5: resuming
[18018804.403351] PM: Writing back config space on device 0000:00:1f.5
at offset 1 (was 2900007, writing 2900003)
[18018804.403368] ACPI: PCI Interrupt 0000:00:1f.5[B] -> GSI 17
(level, low) -> IRQ 17
[18018804.403373] PCI: Enabling bus mastering for device 0000:00:1f.5
[18018804.403379] PCI: Setting latency timer of device 0000:00:1f.5 to 64
[ 5487.347627] pci 0000:00:1f.6: resuming
[ 5487.347680] pci 0000:01:00.0: resuming
[ 5487.347723] PM: Writing back config space on device 0000:01:00.0 at
offset 1 (was 2900107, writing 2900103)
[ 5487.347740] pci 0000:01:06.0: resuming
[ 5487.347784] PM: Writing back config space on device 0000:01:06.0 at
offset 1 (was 2900116, writing 2900102)
[ 5487.347802] yenta_cardbus 0000:01:09.0: resuming
[ 5487.347816] PM: Writing back config space on device 0000:01:09.0 at
offset f (was 34001ff, writing 5c001ff)
[ 5487.347848] PM: Writing back config space on device 0000:01:09.0 at
offset 3 (was 824000, writing 82a820)
[ 5487.374661] ohci1394 0000:01:09.2: resuming
[ 5487.387886] PM: Writing back config space on device 0000:01:09.2 at
offset f (was 4030300, writing 4030304)
[ 5487.387914] PM: Writing back config space on device 0000:01:09.2 at
offset 5 (was 0, writing e0200000)
[ 5487.387922] PM: Writing back config space on device 0000:01:09.2 at
offset 4 (was 0, writing e0207000)
[ 5487.387930] PM: Writing back config space on device 0000:01:09.2 at
offset 3 (was 800000, writing 804008)
[ 5487.387941] PM: Writing back config space on device 0000:01:09.2 at
offset 1 (was 2100000, writing 2100116)
[ 5487.437880] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[22]
MMIO=[e0207000-e02077ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[ 5487.437918] tifm_7xx1 0000:01:09.3: resuming
