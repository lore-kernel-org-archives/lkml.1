Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949AbXKSGS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbXKSGS6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 01:18:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbXKSGSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 01:18:50 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:55726 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbXKSGSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 01:18:49 -0500
Message-ID: <1618816c0711182218o538f659ci68b8fb0680f1f38c@mail.gmail.com>
Date: Sun, 18 Nov 2007 23:18:48 -0700
From: "Raymano Garibaldi" <raymano@faunos.com>
To: "Denys Vlasenko" <vda.linux@googlemail.com>
Subject: Re: [BUG] USB_PERSIST
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200711182037.57725.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1618816c0711182014n293b9429y53bfcf219a624260@mail.gmail.com>
	 <200711182037.57725.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The last time I tried this and it worked was 2.6.21. Below is a
portion of the kernel log file where I had a USB storage device
attached to the computer, then suspended the computer, while computer
was suspended detached and reattached the USB storage device, and
resumed the computer.

--------------------------------------------------------------------------------------------------------------------------------
Nov 18 23:07:42 myfaun Stopping tasks ... done.
Nov 18 23:07:42 myfaun Suspending console(s)
Nov 18 23:07:42 myfaun sd 2:0:0:0: [sda] Synchronizing SCSI cache
Nov 18 23:07:42 myfaun sd 2:0:0:0: [sda] Stopping disk
Nov 18 23:07:42 myfaun ACPI handle has no context!
Nov 18 23:07:42 myfaun ACPI handle has no context!
Nov 18 23:07:42 myfaun ACPI: PCI interrupt for device 0000:00:1f.2 disabled
Nov 18 23:07:42 myfaun ACPI: PCI interrupt for device 0000:00:1f.1 disabled
Nov 18 23:07:42 myfaun ACPI: PCI interrupt for device 0000:00:1d.7 disabled
Nov 18 23:07:42 myfaun ACPI: PCI interrupt for device 0000:00:1d.3 disabled
Nov 18 23:07:42 myfaun ACPI: PCI interrupt for device 0000:00:1d.2 disabled
Nov 18 23:07:42 myfaun ACPI: PCI interrupt for device 0000:00:1d.1 disabled
Nov 18 23:07:42 myfaun ACPI: PCI interrupt for device 0000:00:1d.0 disabled
Nov 18 23:07:42 myfaun ACPI: PCI interrupt for device 0000:00:1b.0 disabled
Nov 18 23:07:42 myfaun Disabling non-boot CPUs ...
Nov 18 23:07:42 myfaun CPU 1 is now offline
Nov 18 23:07:42 myfaun SMP alternatives: switching to UP code
Nov 18 23:07:42 myfaun CPU1 is down
Nov 18 23:07:42 myfaun Intel machine check architecture supported.
Nov 18 23:07:42 myfaun Intel machine check reporting enabled on CPU#0.
Nov 18 23:07:42 myfaun CPU0: Intel P4/Xeon Extended MCE MSRs (24) available
Nov 18 23:07:42 myfaun CPU0: Thermal monitoring enabled
Nov 18 23:07:42 myfaun Back to C!
Nov 18 23:07:42 myfaun Enabling non-boot CPUs ...
Nov 18 23:07:42 myfaun SMP alternatives: switching to SMP code
Nov 18 23:07:42 myfaun Booting processor 1/1 eip 3000
Nov 18 23:07:42 myfaun Initializing CPU#1
Nov 18 23:07:42 myfaun Calibrating delay using timer specific
routine.. 6004.38 BogoMIPS (lpj=10003815)
Nov 18 23:07:42 myfaun CPU: After generic identify, caps: bfebfbff
20100000 00000000 00000000 0000e49d 00000000 00000001 00000000
Nov 18 23:07:42 myfaun monitor/mwait feature present.
Nov 18 23:07:42 myfaun CPU: Trace cache: 12K uops, L1 D cache: 16K
Nov 18 23:07:42 myfaun CPU: L2 cache: 2048K
Nov 18 23:07:42 myfaun CPU: Physical Processor ID: 0
Nov 18 23:07:42 myfaun CPU: Processor Core ID: 1
Nov 18 23:07:42 myfaun CPU: After all inits, caps: bfebfbff 20100000
00000000 0000b180 0000e49d 00000000 00000001 00000000
Nov 18 23:07:42 myfaun Intel machine check architecture supported.
Nov 18 23:07:42 myfaun Intel machine check reporting enabled on CPU#1.
Nov 18 23:07:42 myfaun CPU1: Intel P4/Xeon Extended MCE MSRs (24) available
Nov 18 23:07:42 myfaun CPU1: Thermal monitoring enabled
Nov 18 23:07:42 myfaun CPU1: Intel(R) Pentium(R) D CPU 3.00GHz stepping 05
Nov 18 23:07:42 myfaun CPU1 is up
Nov 18 23:07:42 myfaun ACPI: Unable to turn cooling device [dfe34dc8] 'off'
Nov 18 23:07:42 myfaun Switched to high resolution mode on CPU 1
Nov 18 23:07:42 myfaun ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16
(level, low) -> IRQ 19
Nov 18 23:07:42 myfaun PM: Writing back config space on device
0000:00:1b.0 at offset f (was 100, writing 105)
Nov 18 23:07:42 myfaun PM: Writing back config space on device
0000:00:1b.0 at offset 4 (was 4, writing fdff8004)
Nov 18 23:07:42 myfaun PM: Writing back config space on device
0000:00:1b.0 at offset 3 (was 0, writing 8)
Nov 18 23:07:42 myfaun PM: Writing back config space on device
0000:00:1b.0 at offset 1 (was 100000, writing 100002)
Nov 18 23:07:42 myfaun ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16
(level, low) -> IRQ 19
Nov 18 23:07:42 myfaun PCI: Setting latency timer of device 0000:00:1b.0 to 64
Nov 18 23:07:42 myfaun ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23
(level, low) -> IRQ 18
Nov 18 23:07:42 myfaun PCI: Setting latency timer of device 0000:00:1d.0 to 64
Nov 18 23:07:42 myfaun ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19
(level, low) -> IRQ 17
Nov 18 23:07:42 myfaun PCI: Setting latency timer of device 0000:00:1d.1 to 64
Nov 18 23:07:42 myfaun ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18
(level, low) -> IRQ 16
Nov 18 23:07:42 myfaun PCI: Setting latency timer of device 0000:00:1d.2 to 64
Nov 18 23:07:42 myfaun ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16
(level, low) -> IRQ 19
Nov 18 23:07:42 myfaun PCI: Setting latency timer of device 0000:00:1d.3 to 64
Nov 18 23:07:42 myfaun PCI: Enabling device 0000:00:1d.7 (0000 -> 0002)
Nov 18 23:07:42 myfaun ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23
(level, low) -> IRQ 18
Nov 18 23:07:42 myfaun PCI: Setting latency timer of device 0000:00:1d.7 to 64
Nov 18 23:07:42 myfaun PM: Writing back config space on device
0000:00:1d.7 at offset f (was 100, writing 107)
Nov 18 23:07:42 myfaun PM: Writing back config space on device
0000:00:1d.7 at offset 4 (was 0, writing fdfff000)
Nov 18 23:07:42 myfaun PCI: Setting latency timer of device 0000:00:1e.0 to 64
Nov 18 23:07:42 myfaun PM: Writing back config space on device
0000:00:1f.1 at offset 8 (was f001, writing fa01)
Nov 18 23:07:42 myfaun ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18
(level, low) -> IRQ 16
Nov 18 23:07:42 myfaun PCI: Setting latency timer of device 0000:00:1f.1 to 64
Nov 18 23:07:42 myfaun ata2: port disabled. ignoring.
Nov 18 23:07:42 myfaun ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19
(level, low) -> IRQ 17
Nov 18 23:07:42 myfaun PCI: Setting latency timer of device 0000:00:1f.2 to 64
Nov 18 23:07:42 myfaun pnp: Failed to activate device 00:07.
Nov 18 23:07:42 myfaun pnp: Failed to activate device 00:08.
Nov 18 23:07:42 myfaun e100: eth0: e100_watchdog: link up, 100Mbps, full-duplex
Nov 18 23:07:42 myfaun ata4: SATA link down (SStatus 0 SControl 300)
Nov 18 23:07:42 myfaun ata6: SATA link down (SStatus 0 SControl 300)
Nov 18 23:07:42 myfaun ata5: SATA link down (SStatus 0 SControl 300)
Nov 18 23:07:42 myfaun ata1.00: configured for UDMA/33
Nov 18 23:07:42 myfaun sd 2:0:0:0: [sda] Starting disk
Nov 18 23:07:42 myfaun ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Nov 18 23:07:42 myfaun ata3.00: configured for UDMA/100
Nov 18 23:07:42 myfaun sd 2:0:0:0: [sda] 488397168 512-byte hardware
sectors (250059 MB)
Nov 18 23:07:42 myfaun sd 2:0:0:0: [sda] Write Protect is off
Nov 18 23:07:42 myfaun sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
Nov 18 23:07:42 myfaun sd 2:0:0:0: [sda] Write cache: enabled, read
cache: enabled, doesn't support DPO or FUA
Nov 18 23:07:42 myfaun Restarting tasks ... <6>usb 5-6: USB
disconnect, address 5
Nov 18 23:07:42 myfaun sd 9:0:0:0: [sdf] READ CAPACITY failed
Nov 18 23:07:42 myfaun sd 9:0:0:0: [sdf] Result: hostbyte=0x01 driverbyte=0x00
Nov 18 23:07:42 myfaun sd 9:0:0:0: [sdf] Sense not available.
Nov 18 23:07:42 myfaun sd 9:0:0:0: [sdf] Write Protect is off
Nov 18 23:07:42 myfaun sd 9:0:0:0: [sdf] Mode Sense: 00 00 00 00
Nov 18 23:07:42 myfaun sd 9:0:0:0: [sdf] Assuming drive cache: write through
Nov 18 23:07:42 myfaun done.
Nov 18 23:07:42 myfaun usb 5-6: new high speed USB device using
ehci_hcd and address 6
Nov 18 23:07:42 myfaun usb 5-6: configuration #1 chosen from 1 choice
Nov 18 23:07:42 myfaun scsi10 : SCSI emulation for USB Mass Storage devices
Nov 18 23:07:42 myfaun usb-storage: device found at 6
Nov 18 23:07:42 myfaun usb-storage: waiting for device to settle before scanning
Nov 18 23:07:48 myfaun scsi 10:0:0:0: Direct-Access     USB 2.0  Flash
Disk       1.00 PQ: 0 ANSI: 2
Nov 18 23:07:48 myfaun sd 10:0:0:0: [sdg] 1982464 512-byte hardware
sectors (1015 MB)
Nov 18 23:07:48 myfaun sd 10:0:0:0: [sdg] Write Protect is off
Nov 18 23:07:48 myfaun sd 10:0:0:0: [sdg] Mode Sense: 03 00 00 00
Nov 18 23:07:48 myfaun sd 10:0:0:0: [sdg] Assuming drive cache: write through
Nov 18 23:07:48 myfaun sd 10:0:0:0: [sdg] 1982464 512-byte hardware
sectors (1015 MB)
Nov 18 23:07:48 myfaun sd 10:0:0:0: [sdg] Write Protect is off
Nov 18 23:07:48 myfaun sd 10:0:0:0: [sdg] Mode Sense: 03 00 00 00
Nov 18 23:07:48 myfaun sd 10:0:0:0: [sdg] Assuming drive cache: write through
Nov 18 23:07:48 myfaun sdg: sdg1 sdg2
Nov 18 23:07:48 myfaun sd 10:0:0:0: [sdg] Attached SCSI removable disk
Nov 18 23:07:48 myfaun sd 10:0:0:0: Attached scsi generic sg6 type 0
Nov 18 23:07:48 myfaun usb-storage: device scan complete

--------------------------------------------------------------------------------------------------------------------------------

Thanks,
Raymano G.

On 11/18/07, Denys Vlasenko <vda.linux@googlemail.com> wrote:
> On Sunday 18 November 2007 20:14, Raymano Garibaldi wrote:
> > In kernel 2.6.23.8 USB_PERSIST feature does not work if the same USB
> > device is detached and reattached while computer is suspended. The
> > mount points for the USB storage device mounted before suspend are
> > lost and the device has to be remounted after resume.
>
> Does it work in 2.6.23.7? What messages you see in the kernel logs
> (in both kernels, good and bad)?
> --
> vda
>
