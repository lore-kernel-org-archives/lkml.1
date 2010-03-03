Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab0CCFhP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 00:37:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48920 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752006Ab0CCFhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 00:37:13 -0500
Date: Tue, 2 Mar 2010 21:37:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: 2.6.33 on jetway nc81-lf board
Message-Id: <20100302213709.951ee97b.akpm@linux-foundation.org>
In-Reply-To: <4B8C0598.2060000@xs4all.nl>
References: <4B8C0598.2060000@xs4all.nl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc lm-sensors)

On Mon, 01 Mar 2010 19:21:12 +0100 Udo van den Heuvel <udovdh@xs4all.nl> wrote:

> Hello,
> 
> I just compiled 2.6.33 on a Jetway NC81-LF board with AMD 235E CPU.
> While trying to get lm_sensors to work I get in dmesg stuff like:
> 
> f71882fg: Found f71862fg chip at 0x220, revision 18
> ACPI: I/O resource f71882fg [0x220-0x227] conflicts with ACPI region
> IP__ [0x225-0x226]
> ACPI: If an ACPI driver is available for this device, you should use it
> instead of the native driver
> ACPI: I/O resource piix4_smbus [0xb00-0xb07] conflicts with ACPI region
> SOR1 [0xb00-0xb0f]
> ACPI: If an ACPI driver is available for this device, you should use it
> instead of the native driver
> 
> 
> No other sensor-related modules are loaded.
> 
> What could be wrong?
> 
> # lspci
> 00:00.0 Host bridge: Advanced Micro Devices [AMD] RS780 Host Bridge
> 00:01.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge
> (int gfx)
> 00:04.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge
> (PCIE port 0)
> 00:05.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge
> (PCIE port 1)
> 00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA
> Controller [AHCI mode]
> 00:12.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0
> Controller
> 00:12.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller
> 00:12.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller
> 00:13.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0
> Controller
> 00:13.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller
> 00:13.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller
> 00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 3a)
> 00:14.1 IDE interface: ATI Technologies Inc SB700/SB800 IDE Controller
> 00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia (Intel HDA)
> 00:14.3 ISA bridge: ATI Technologies Inc SB700/SB800 LPC host controller
> 00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge
> 00:14.5 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI2
> Controller
> 00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron,
> Athlon64, Sempron] HyperTransport Configuration
> 00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron,
> Athlon64, Sempron] Address Map
> 00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron,
> Athlon64, Sempron] DRAM Controller
> 00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron,
> Athlon64, Sempron] Miscellaneous Control
> 00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron,
> Athlon64, Sempron] Link Control
> 01:05.0 VGA compatible controller: ATI Technologies Inc Radeon HD 3200
> Graphics
> 02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
> RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 02)
> 03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
> RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 02)
> 
> # dmesg|grep -i acpi
>  BIOS-e820: 00000000bffe0000 - 00000000bffe3000 (ACPI NVS)
>  BIOS-e820: 00000000bffe3000 - 00000000bfff0000 (ACPI data)
> ACPI: RSDP 00000000000f83d0 00024 (v02 RS780 )
> ACPI: XSDT 00000000bffe3080 0004C (v01 RS780  AWRDACPI 42302E31 AWRD
> 00000000)
> ACPI: FACP 00000000bffea480 000F4 (v03 RS780  AWRDACPI 42302E31 AWRD
> 00000000)
> ACPI: DSDT 00000000bffe3200 0724B (v01 RS780  AWRDACPI 00001000 MSFT
> 03000000)
> ACPI: FACS 00000000bffe0000 00040
> ACPI: SSDT 00000000bffea640 0095E (v01 PTLTD  POWERNOW 00000001  LTP
> 00000001)
> ACPI: HPET 00000000bffeafc0 00038 (v01 RS780  AWRDACPI 42302E31 AWRD
> 00000098)
> ACPI: MCFG 00000000bffeb000 0003C (v01 RS780  AWRDACPI 42302E31 AWRD
> 00000000)
> ACPI: APIC 00000000bffea580 00084 (v01 RS780  AWRDACPI 42302E31 AWRD
> 00000000)
> ACPI: Local APIC address 0xfee00000
> ACPI: PM-Timer IO Port: 0x4008
> ACPI: Local APIC address 0xfee00000
> ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
> ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
> ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
> ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
> ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
> ACPI: IRQ0 used by override.
> ACPI: IRQ2 used by override.
> ACPI: IRQ9 used by override.
> Using ACPI (MADT) for SMP configuration information
> ACPI: HPET id: 0x10b9a201 base: 0xfed00000
> ACPI: Core revision 20091214
> ACPI: bus type pci registered
> ACPI: EC: Look up EC in DSDT
> ACPI: Interpreter enabled
> ACPI: (supports S0 S5)
> ACPI: Using IOAPIC for interrupt routing
> ACPI: No dock devices found.
> ACPI: PCI Root Bridge [PCI0] (0000:00)
> pci_root PNP0A03:00: ignoring host bridge windows from ACPI; boot with
> "pci=use_crs" to use them
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE4._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE5._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
> ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
> ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
> ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
> ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
> ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
> ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
> ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11) *0, disabled.
> ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
> PCI: Using ACPI for IRQ routing
> pnp: PnP ACPI init
> ACPI: bus type pnp registered
> pnp: PnP ACPI: found 12 devices
> ACPI: ACPI bus type pnp unregistered
> ACPI Warning for \_TZ_.THRM._PSL: Return Package type mismatch at index
> 0 - found [NULL Object Descriptor], expected Reference
> (20091214/nspredef-1040)
> ACPI: Expecting a [Reference] package element, found type 0
> ACPI: Invalid passive threshold
> ACPI: Thermal Zone [THRM] (40 C)
> ACPI: Power Button [PWRB]
> ACPI: Power Button [PWRF]
> ACPI: Fan [FAN] (on)
> ACPI: I/O resource f71882fg [0x220-0x227] conflicts with ACPI region
> IP__ [0x225-0x226]
> ACPI: If an ACPI driver is available for this device, you should use it
> instead of the native driver
> (etc)
> 

