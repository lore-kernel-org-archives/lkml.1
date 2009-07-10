Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbZGJJlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbZGJJlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 05:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725AbZGJJlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 05:41:04 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:53425 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbZGJJlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 05:41:01 -0400
To: linux-usb@vger.kernel.org, linux-input@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: usb mouse not responding after resume
Message-Id: <E1MPCb9-0007w0-BK@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 10 Jul 2009 11:40:55 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes after resume the usb mouse plugged into my T60 notebook
isn't working.  Unplugging and replugging it fixes the problem.  A
keyboard is also plugged in, which works normally every time.

This has been happening on and off from about 2.6.30-rc* but in
2.6.31-rc* seems to be getting more frequent.

Here's the suspend-resume-replug part of the dmesg.  Not sure if it is
enough, I'd be happy to provide more info.

Thanks,
Miklos


[102771.212722] wlan0: disassociating by local choice (reason=3)
[102771.729222] uhci_hcd 0000:00:1d.0: release dev 8 ep81-INT, period 8, phase 4, 93 us
[102771.743591] PM: Syncing filesystems ... done.
[102771.751825] Freezing user space processes ... (elapsed 0.00 seconds) done.
[102771.753393] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[102771.753461] Suspending console(s) (use no_console_suspend to debug)
[102771.757237] usb 2-2: usb suspend
[102771.773217] uhci_hcd 0000:00:1d.0: release dev 6 ep81-INT, period 16, phase 8, 118 us
[102771.776231] usb 2-1: usb suspend
[102771.818219] usb 5-2: usb suspend
[102773.020265] hub 5-0:1.0: hub_suspend
[102773.020271] usb usb5: bus suspend
[102773.020274] usb usb5: suspend_rh
[102773.020302] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[102773.020383] sd 0:0:0:0: [sda] Stopping disk
[102773.452780] hub 2-0:1.0: hub_suspend
[102773.452785] usb usb2: bus suspend
[102773.452788] usb usb2: suspend_rh
[102773.453928] nsc-ircc 00:0a: disabled
[102773.468396] e1000e 0000:02:00.0: PCI INT A disabled
[102773.468406] e1000e 0000:02:00.0: PME# enabled
[102773.516076] PIIX_IDE 0000:00:1f.1: PCI INT C disabled
[102773.516091] ehci_hcd 0000:00:1d.7: PCI INT D disabled
[102773.516095] uhci_hcd 0000:00:1d.3: uhci_pci_suspend
[102773.516103] uhci_hcd 0000:00:1d.3: PCI INT D disabled
[102773.516106] uhci_hcd 0000:00:1d.2: uhci_pci_suspend
[102773.516114] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[102773.516118] uhci_hcd 0000:00:1d.1: uhci_pci_suspend
[102773.516126] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[102773.516129] uhci_hcd 0000:00:1d.0: uhci_pci_suspend
[102773.516136] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[102773.532084] HDA Intel 0000:00:1b.0: PCI INT B disabled
[102773.548676] ehci_hcd 0000:00:1d.7: wakeup: 0
[102773.548691] ehci_hcd 0000:00:1d.7: PME# disabled
[102773.596078] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
[102773.596083] ehci_hcd 0000:00:1d.7: --> PCI D3hot
[102773.596117] uhci_hcd 0000:00:1d.3: wakeup: 0
[102773.596121] uhci_hcd 0000:00:1d.3: --> PCI D0
[102773.596154] uhci_hcd 0000:00:1d.2: wakeup: 0
[102773.628074] uhci_hcd 0000:00:1d.2: power state changed by ACPI to D3
[102773.628077] uhci_hcd 0000:00:1d.2: --> PCI D3hot
[102773.628111] uhci_hcd 0000:00:1d.1: wakeup: 0
[102773.628114] uhci_hcd 0000:00:1d.1: --> PCI D0
[102773.628148] uhci_hcd 0000:00:1d.0: wakeup: 0
[102773.740063] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D3
[102773.740065] uhci_hcd 0000:00:1d.0: --> PCI D3hot
[102773.892066] ACPI: Preparing to enter system sleep state S3
[102774.412220] Disabling non-boot CPUs ...
[102774.516021] CPU 1 is now offline
[102774.516024] lockdep: fixing up alternatives.
[102774.516026] SMP alternatives: switching to UP code
[102774.520992] CPU0 attaching NULL sched-domain.
[102774.520996] CPU1 attaching NULL sched-domain.
[102774.521007] CPU0 attaching NULL sched-domain.
[102774.521305] CPU1 is down
[102774.521363] Extended CMOS year: 2000
[102774.521363] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[102774.521363] Back to C!
[102774.521363] CPU0: Thermal monitoring handled by SMI
[102774.521363] Extended CMOS year: 2000
[102774.521363] Enabling non-boot CPUs ...
[102774.524178] lockdep: fixing up alternatives.
[102774.524181] SMP alternatives: switching to SMP code
[102774.528667] Booting processor 1 APIC 0x1 ip 0x6000
[102774.520742] Initializing CPU#1
[102774.520742] Calibrating delay using timer specific routine.. 3657.54 BogoMIPS (lpj=7315096)
[102774.520742] CPU: L1 I cache: 32K, L1 D cache: 32K
[102774.520742] CPU: L2 cache: 2048K
[102774.520742] CPU: Physical Processor ID: 0
[102774.520742] CPU: Processor Core ID: 1
[102774.520742] mce: CPU supports 6 MCE banks
[102774.520742] CPU1: Thermal monitoring enabled (TM2)
[102774.520742] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[102774.617524] CPU1: Intel(R) Core(TM)2 CPU         T5600  @ 1.83GHz stepping 06
[102774.617568] CPU0 attaching NULL sched-domain.
[102774.621015] Switched to high resolution mode on CPU 1
[102774.628024] CPU0 attaching sched-domain:
[102774.628027]  domain 0: span 0-1 level MC
[102774.628030]   groups: 0 1
[102774.628037] CPU1 attaching sched-domain:
[102774.628039]  domain 0: span 0-1 level MC
[102774.628042]   groups: 1 0
[102774.628846] CPU1 is up
[102774.628849] ACPI: Waking up from system sleep state S3
[102775.852177] pcieport-driver 0000:00:01.0: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
[102775.852243] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100106, writing 0x100102)
[102775.852305] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x1 (was 0x180107, writing 0x100507)
[102775.852387] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
[102775.852467] pcieport-driver 0000:00:1c.2: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
[102775.852523] pcieport-driver 0000:00:1c.3: restoring config space at offset 0xf (was 0x40400, writing 0x4040b)
[102775.852538] pcieport-driver 0000:00:1c.3: restoring config space at offset 0x9 (was 0x10001, writing 0xe421e421)
[102775.852545] pcieport-driver 0000:00:1c.3: restoring config space at offset 0x8 (was 0x0, writing 0xebf0ea00)
[102775.852552] pcieport-driver 0000:00:1c.3: restoring config space at offset 0x7 (was 0x20000000, writing 0x9080)
[102775.852563] pcieport-driver 0000:00:1c.3: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[102775.852572] pcieport-driver 0000:00:1c.3: restoring config space at offset 0x1 (was 0x100000, writing 0x100507)
[102776.020062] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[102776.020094] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[102776.020132] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[102776.052072] uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
[102776.052103] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[102776.052140] uhci_hcd 0000:00:1d.3: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[102776.052188] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900106, writing 0x2900102)
[102776.052209] ehci_hcd 0000:00:1d.7: PME# disabled
[102776.052245] pci 0000:00:1e.0: restoring config space at offset 0x1 (was 0x100005, writing 0x100007)
[102776.052338] PIIX_IDE 0000:00:1f.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2880005)
[102776.052384] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00007, writing 0x2b00407)
[102776.052999] iwl3945 0000:03:00.0: restoring config space at offset 0x1 (was 0x100106, writing 0x100506)
[102776.053129] pci 0000:15:00.0: restoring config space at offset 0xf (was 0x34001ff, writing 0x3c0010b)
[102776.053137] pci 0000:15:00.0: restoring config space at offset 0xe (was 0x0, writing 0xa4fc)
[102776.053144] pci 0000:15:00.0: restoring config space at offset 0xd (was 0x0, writing 0xa400)
[102776.053152] pci 0000:15:00.0: restoring config space at offset 0xc (was 0x0, writing 0xa0fc)
[102776.053159] pci 0000:15:00.0: restoring config space at offset 0xb (was 0x0, writing 0xa000)
[102776.053166] pci 0000:15:00.0: restoring config space at offset 0xa (was 0x0, writing 0xc3fff000)
[102776.053174] pci 0000:15:00.0: restoring config space at offset 0x9 (was 0x0, writing 0xc0000000)
[102776.053181] pci 0000:15:00.0: restoring config space at offset 0x8 (was 0x0, writing 0xe3fff000)
[102776.053189] pci 0000:15:00.0: restoring config space at offset 0x7 (was 0x0, writing 0xe0000000)
[102776.053196] pci 0000:15:00.0: restoring config space at offset 0x6 (was 0x0, writing 0xb0171615)
[102776.053206] pci 0000:15:00.0: restoring config space at offset 0x4 (was 0x0, writing 0xe4300000)
[102776.053213] pci 0000:15:00.0: restoring config space at offset 0x3 (was 0x20000, writing 0x2a808)
[102776.053223] pci 0000:15:00.0: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100007)
[102776.186004] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[102776.186013] HDA Intel 0000:00:1b.0: setting latency timer to 64
[102776.272335] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[102776.272348] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[102776.272352] uhci_hcd 0000:00:1d.0: uhci_pci_resume
[102776.272358] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x2f00
[102776.272360] uhci_hcd 0000:00:1d.0: Performing full reset
[102776.272384] usb usb2: root hub lost power or was reset
[102776.272387] usb usb2: suspend_rh
[102776.272429] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[102776.272437] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[102776.272445] uhci_hcd 0000:00:1d.1: uhci_pci_resume
[102776.272450] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x2000
[102776.272452] uhci_hcd 0000:00:1d.1: Performing full reset
[102776.272475] usb usb3: root hub lost power or was reset
[102776.272477] usb usb3: suspend_rh
[102776.272509] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[102776.272517] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[102776.272521] uhci_hcd 0000:00:1d.2: uhci_pci_resume
[102776.272526] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x2000
[102776.272528] uhci_hcd 0000:00:1d.2: Performing full reset
[102776.272551] usb usb4: root hub lost power or was reset
[102776.272553] usb usb4: suspend_rh
[102776.272579] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[102776.272593] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[102776.272597] uhci_hcd 0000:00:1d.3: uhci_pci_resume
[102776.272601] uhci_hcd 0000:00:1d.3: uhci_check_and_reset_hc: legsup = 0x2000
[102776.272604] uhci_hcd 0000:00:1d.3: Performing full reset
[102776.272627] usb usb5: root hub lost power or was reset
[102776.272629] usb usb5: suspend_rh
[102776.272667] ehci_hcd 0000:00:1d.7: PME# disabled
[102776.272678] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[102776.272685] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[102776.272728] pci 0000:00:1e.0: setting latency timer to 64
[102776.272743] PIIX_IDE 0000:00:1f.1: PCI INT C -> GSI 16 (level, low) -> IRQ 16
[102776.272785] PIIX_IDE 0000:00:1f.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2880005)
[102776.272802] PIIX_IDE 0000:00:1f.1: setting latency timer to 64
[102776.272908] ahci 0000:00:1f.2: setting latency timer to 64
[102776.273054] pci 0000:01:00.0: PME# disabled
[102776.273243] e1000e 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[102776.273246] e1000e 0000:02:00.0: pci_enable_pcie_error_reporting failed 0xfffffffb
[102776.273261] e1000e 0000:02:00.0: setting latency timer to 64
[102776.273278] e1000e 0000:02:00.0: PME# disabled
[102776.273287] e1000e 0000:02:00.0: PME# disabled
[102776.273394] e1000e 0000:02:00.0: irq 30 for MSI/MSI-X
[102776.331638] pci 0000:15:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[102776.332524] nsc-ircc 00:0a: activated
[102776.337453] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[102776.337712] hda: UDMA/33 mode selected
[102776.338691] usb usb1: usb resume
[102776.338695] ehci_hcd 0000:00:1d.7: resume root hub
[102776.372065] ehci_hcd 0000:00:1d.7: port 1 low speed --> companion
[102776.468232] ehci_hcd 0000:00:1d.7: port 8 full speed --> companion
[102776.468237] ehci_hcd 0000:00:1d.7: GetStatus port 8 status 003801 POWER OWNER sig=j CONNECT
[102776.468245] ehci_hcd 0000:00:1d.7: GetStatus port 1 status 003002 POWER OWNER sig=se0 CSC
[102776.484062] hub 1-0:1.0: hub_resume
[102776.484101] ehci_hcd 0000:00:1d.7: GetStatus port 8 status 003002 POWER OWNER sig=se0 CSC
[102776.588066] usb usb2: usb resume
[102776.588068] usb usb2: wakeup_rh
[102776.592079] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[102776.605251] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[102776.605255] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[102776.605259] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[102776.608953] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[102776.608956] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[102776.608960] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[102776.610486] ata1.00: configured for UDMA/100
[102776.613934] ata1.00: configured for UDMA/100
[102776.628037] ata1: EH complete
[102776.628330] hub 2-0:1.0: hub_reset_resume
[102776.628333] hub 2-0:1.0: trying to enable port power on non-switchable hub
[102776.732046] uhci_hcd 0000:00:1d.0: port 1 portsc 01ab,00
[102776.732051] hub 2-0:1.0: port 1: status 0301 change 0003
[102776.732069] uhci_hcd 0000:00:1d.0: port 2 portsc 008a,00
[102776.732073] hub 2-0:1.0: port 2: status 0100 change 0003
[102776.836063] sd 0:0:0:0: [sda] Starting disk
[102776.857464] usb usb5: usb resume
[102776.857467] usb usb5: wakeup_rh
[102776.896039] hub 5-0:1.0: hub_reset_resume
[102776.896042] hub 5-0:1.0: trying to enable port power on non-switchable hub
[102777.000052] uhci_hcd 0000:00:1d.3: port 2 portsc 009b,00
[102777.000056] hub 5-0:1.0: port 2: status 0101 change 0003
[102777.105874] usb 5-2: finish reset-resume
[102777.216044] usb 5-2: reset full speed USB device using uhci_hcd and address 2
[102777.352039] usb 5-2: ep0 maxpacket = 8
[102777.370553] usb 2-1: finish reset-resume
[102777.628043] usb 2-1: reset low speed USB device using uhci_hcd and address 6
[102777.935086] uhci_hcd 0000:00:1d.0: reserve dev 6 ep81-INT, period 16, phase 8, 118 us
[102777.935110] hub 2-0:1.0: port 2 status 0000.0100 after resume, -19
[102777.935113] usb 2-2: can't resume, status -19
[102777.935115] hub 2-0:1.0: logical disconnect on port 2
[102777.936039] Restarting tasks ... 
[102777.936117] hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0004
[102777.936129] ehci_hcd 0000:00:1d.7: GetStatus port 2 status 001c03 POWER sig=? CSC CONNECT
[102777.936140] hub 1-0:1.0: port 2, status 0501, change 0001, 480 Mb/s
[102777.963324] done.
[102778.064066] hub 1-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x501
[102778.120235] ehci_hcd 0000:00:1d.7: port 2 full speed --> companion
[102778.120243] ehci_hcd 0000:00:1d.7: GetStatus port 2 status 003c01 POWER OWNER sig=? CONNECT
[102778.120251] hub 1-0:1.0: port 2 not reset yet, waiting 50ms
[102778.176051] ehci_hcd 0000:00:1d.7: GetStatus port 2 status 003002 POWER OWNER sig=se0 CSC
[102778.176088] hub 2-0:1.0: state 7 ports 2 chg 0006 evt 0000
[102778.176102] hub 2-0:1.0: port 1, status 0303, change 0000, 1.5 Mb/s
[102778.176113] hub 2-0:1.0: port 2, status 0100, change 0000, 12 Mb/s
[102778.176117] usb 2-2: USB disconnect, address 8
[102778.176120] usb 2-2: unregistering device
[102778.176128] usb 2-2: usb_disable_device nuking all URBs
[102778.176136] usb 2-2: unregistering interface 2-2:1.0
[102778.208408] usb 2-2:1.0: uevent
[102778.208675] usb 2-2: uevent
[102778.208704] hub 5-0:1.0: state 7 ports 2 chg 0004 evt 0000
[102778.208722] hub 5-0:1.0: port 2, status 0103, change 0000, 12 Mb/s
[102778.208728] hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0004
[102778.393703] e1000e 0000:02:00.0: irq 30 for MSI/MSI-X
[102778.449167] e1000e 0000:02:00.0: irq 30 for MSI/MSI-X
[102780.816048] hub 1-0:1.0: hub_suspend
[102780.816066] usb usb1: bus auto-suspend
[102780.816072] ehci_hcd 0000:00:1d.7: suspend root hub
[102790.448116] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0004
[102790.448138] uhci_hcd 0000:00:1d.0: port 2 portsc 0082,00
[102790.448157] hub 2-0:1.0: port 2, status 0100, change 0001, 12 Mb/s
[102790.576099] hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x100
[102791.260669] wlan0: authenticate with AP 00:12:17:49:ea:50
[102791.262564] wlan0: authenticated
[102791.262570] wlan0: associate with AP 00:12:17:49:ea:50
[102791.264953] wlan0: RX AssocResp from 00:12:17:49:ea:50 (capab=0x411 status=0 aid=3)
[102791.264960] wlan0: associated
[102792.866026] usb usb1: usb resume
[102792.866035] ehci_hcd 0000:00:1d.7: resume root hub
[102792.900077] ehci_hcd 0000:00:1d.7: port 2 low speed --> companion
[102792.928128] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0004
[102792.928150] uhci_hcd 0000:00:1d.0: port 2 portsc 01a3,00
[102792.928169] hub 2-0:1.0: port 2, status 0301, change 0001, 1.5 Mb/s
[102792.996057] ehci_hcd 0000:00:1d.7: GetStatus port 2 status 003002 POWER OWNER sig=se0 CSC
[102793.012079] hub 1-0:1.0: hub_resume
[102793.056066] hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x301
[102793.168078] usb 2-2: new low speed USB device using uhci_hcd and address 9
[102793.323104] usb 2-2: skipped 1 descriptor after interface
[102793.328109] usb 2-2: default language 0x0409
[102793.344100] usb 2-2: udev 9, busnum 2, minor = 136
[102793.344111] usb 2-2: New USB device found, idVendor=045e, idProduct=0084
[102793.344117] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[102793.344123] usb 2-2: Product: Basic Optical Mouse
[102793.344128] usb 2-2: Manufacturer: Microsoft
[102793.344405] usb 2-2: uevent
[102793.344444] usb 2-2: usb_probe_device
[102793.344451] usb 2-2: configuration #1 chosen from 1 choice
[102793.347098] usb 2-2: adding 2-2:1.0 (config #1, interface 0)
[102793.347164] usb 2-2:1.0: uevent
[102793.347205] usbhid 2-2:1.0: usb_probe_interface
[102793.347210] usbhid 2-2:1.0: usb_probe_interface - got id
[102793.363947] input: Microsoft Basic Optical Mouse as /class/input/input14
[102793.364121] uhci_hcd 0000:00:1d.0: reserve dev 9 ep81-INT, period 8, phase 4, 93 us
[102793.364227] generic-usb 0003:045E:0084.0008: input,hidraw1: USB HID v1.10 Mouse [Microsoft Basic Optical Mouse] on usb-0000:00:1d.0-2/input0
[102793.364324] hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0000
[102793.364333] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0004
[102795.275987] wlan0: deauthenticated (Reason: 15)
[102795.816080] hub 1-0:1.0: hub_suspend
[102795.816097] usb usb1: bus auto-suspend
[102795.816103] ehci_hcd 0000:00:1d.7: suspend root hub
