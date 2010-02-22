Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab0BVPYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 10:24:50 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:34743 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534Ab0BVPYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 10:24:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:content-type;
        b=N+fY2BI6Bt1pxmEL+nF0WgfxhQuOjW/JFbfTwbik1cwgaMDyLYh/bqnna3+6P/gnw8
         sr6wGIkslRAUrvU6DM0Zmdqsf6ff+OQnLQ37kfkdfHDV8/+YRpIH+XoXChEFS4/MnBGy
         lHWGlDHgVAdy5hdtSSEUYftK6GRerrQ4cS++w=
MIME-Version: 1.0
In-Reply-To: <2c242de41002220307s52b6e7ak9640ff5cbe34ee6@mail.gmail.com>
References: <2c242de41002220307s52b6e7ak9640ff5cbe34ee6@mail.gmail.com>
From: "Stefano Z." <mie.iscrizioni@gmail.com>
Date: Mon, 22 Feb 2010 16:24:22 +0100
X-Google-Sender-Auth: d836dd2fb51e449d
Message-ID: <2c242de41002220724n609edfbdn6d521d59d37665b1@mail.gmail.com>
Subject: Re: [kernel26] Very high power consumption and cpu usage on laptop 
	with any kernel26-2.6.32.*
To: mie.iscrizioni@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ok, sorry for the few info i have attached to my precedent mail ;-)
below some other info that can be useful to identify my problem:

root ~ #  powertop -d
PowerTOP 1.11   (C) 2007, 2008 Intel Corporation

Raccolta dati per 15 secondi


Your CPU supports the following C-states : C1 C2 C3 C4
Your BIOS reports the following C-states : C1 C4
Cn	          Avg residency
C0 (cpu occupata)      (27,9%)
polling		  0,0ms ( 0,0%)
C1 mwait	  0,1ms ( 0,1%)
C4 mwait	  0,0ms (72,0%)
P-states (frequencies)
Wakeups-from-idle per second : 35734,7	interval: 15,0s
no ACPI power usage estimate available
Top causes for wakeups:
  26,2% (118,3)          chromium : hrtimer_start_range_ns (hrtimer_wakeup)
  21,7% ( 98,1)     <kernel core> : hrtimer_start_range_ns (tick_sched_timer)
  18,3% ( 82,7)       <interrupt> : extra timer interrupt
  13,6% ( 61,3)      <kernel IPI> : Rescheduling interrupts
   4,1% ( 18,7)     <kernel core> : hrtimer_start (tick_sched_timer)
   3,5% ( 15,8)       <interrupt> : uhci_hcd:usb3, uhci_hcd:usb6, ath9k
   3,3% ( 14,9)          chromium : sys_epoll_wait (process_timeout)
   2,2% ( 10,0)     <kernel core> : run_timer_softirq (ath_ani_calibrate)
   1,7% (  7,9)     <kernel core> : usb_hcd_poll_rh_status (rh_timer_func)
   0,9% (  4,2)              phy0 : queue_delayed_work (delayed_work_timer_fn)
   0,8% (  3,7)          zfs-fuse : hrtimer_start_range_ns (hrtimer_wakeup)
   0,5% (  2,1)       <interrupt> : i915
   0,4% (  1,9)   USB device  3-1 : USB Receiver (Logitech)
   0,4% (  1,6)                 X : i915_add_request (i915_hangcheck_elapsed)
   0,3% (  1,3)               exe : hrtimer_start_range_ns (hrtimer_wakeup)
   0,2% (  1,0)   multiload-apple : hrtimer_start_range_ns (hrtimer_wakeup)
   0,2% (  0,9)                 X : queue_delayed_work (delayed_work_timer_fn)
   0,2% (  0,9)          zfs-fuse : read_events (timeout_func)
   0,1% (  0,7)       <interrupt> : ahci
   0,1% (  0,6)      <kernel IPI> : TLB shootdowns
   0,1% (  0,5)    sensors-applet : hrtimer_start_range_ns (hrtimer_wakeup)
   0,1% (  0,4)      <kernel IPI> : Function call interrupts
   0,1% (  0,3)                 X : intel_mark_busy (intel_crtc_idle_timer)
   0,1% (  0,3)   /usr/bin/termin : hrtimer_start_range_ns (hrtimer_wakeup)
   0,1% (  0,3)     <kernel core> : enqueue_task_rt (sched_rt_period_timer)
   0,1% (  0,3)   system-tools-ba : hrtimer_start_range_ns (hrtimer_wakeup)
   0,1% (  0,3)            compiz : hrtimer_start_range_ns (hrtimer_wakeup)
   0,1% (  0,3)          nautilus : hrtimer_start_range_ns (hrtimer_wakeup)
   0,0% (  0,2)              init : hrtimer_start_range_ns (hrtimer_wakeup)
   0,0% (  0,2)      wicd-monitor : hrtimer_start_range_ns (hrtimer_wakeup)
   0,0% (  0,2)      clock-applet : hrtimer_start_range_ns (hrtimer_wakeup)
   0,0% (  0,2)       gnome-panel : hrtimer_start_range_ns (hrtimer_wakeup)
   0,0% (  0,1)          ddclient : hrtimer_start_range_ns (hrtimer_wakeup)
   0,0% (  0,1)          gconfd-2 : hrtimer_start_range_ns (hrtimer_wakeup)
   0,0% (  0,1)         flush-8:0 : bdi_writeback_task (process_timeout)
   0,0% (  0,1)          events/0 : queue_delayed_work (delayed_work_timer_fn)
   0,0% (  0,1)             cupsd : sys_epoll_wait (process_timeout)
   0,0% (  0,1)        flush-0:15 : bdi_writeback_task (process_timeout)
   0,0% (  0,1)       bdi-default : bdi_forker_task (process_timeout)
   0,0% (  0,1)          chromium : run_timer_softirq (sync_supers_timer_fn)
   0,0% (  0,1)                 X : hrtimer_start_range_ns (hrtimer_wakeup)
   0,0% (  0,1)     <kernel core> : sk_reset_timer (tcp_delack_timer)
   0,0% (  0,1)   battstat-applet : hrtimer_start_range_ns (hrtimer_wakeup)
   0,0% (  0,1)              wicd : start_this_handle (commit_timeout)
   0,0% (  0,1)     <kernel core> : run_timer_softirq (sta_info_cleanup)
   0,0% (  0,1)     <kernel core> : inet_twdr_hangman (inet_twdr_hangman)

A USB device is active 100,0% of the time:
USB device  3-1 : USB Receiver (Logitech)

Suggestion: Enable USB autosuspend by pressing the U key or adding
usbcore.autosuspend=1 to the kernel command line in the grub config

Suggestion: increase the VM dirty writeback time from 5,00 to 15 seconds with:
  echo 1500 > /proc/sys/vm/dirty_writeback_centisecs
This wakes the disk up less frequently for background VM activity

Suggestion: Enable SATA ALPM link power management via:
  echo min_power > /sys/class/scsi_host/host0/link_power_management_policy
or press the S key.

Recent USB suspend statistics
Active  Device name
100,0%	USB device  4-2 : HP Integrated Module (Broadcom Corp)
100,0%	USB device  3-1 : USB Receiver (Logitech)
100,0%	USB device  2-4 : HP Webcam-50 (QCM)
  0,0%	USB device usb7 : UHCI Host Controller (Linux 2.6.32-ARCH uhci_hcd)
  0,0%	USB device usb6 : UHCI Host Controller (Linux 2.6.32-ARCH uhci_hcd)
  0,0%	USB device usb5 : UHCI Host Controller (Linux 2.6.32-ARCH uhci_hcd)
100,0%	USB device usb4 : UHCI Host Controller (Linux 2.6.32-ARCH uhci_hcd)
100,0%	USB device usb3 : UHCI Host Controller (Linux 2.6.32-ARCH uhci_hcd)
100,0%	USB device usb2 : EHCI Host Controller (Linux 2.6.32-ARCH ehci_hcd)
  0,0%	USB device usb1 : EHCI Host Controller (Linux 2.6.32-ARCH ehci_hcd)

--

root ~ #  dmidecode
# dmidecode 2.10
SMBIOS 2.6 present.
24 structures occupying 1185 bytes.
Table at 0x000E8280.

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
	Vendor: Hewlett-Packard
	Version: F.12
	Release Date: 12/11/2009
	ROM Size: 2048 kB
	Characteristics:
		PCI is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		Boot from CD is supported
		Selectable boot is supported
		BIOS ROM is socketed
		EDD is supported
		Japanese floppy for NEC 9800 1.2 MB is supported (int 13h)
		Japanese floppy for Toshiba 1.2 MB is supported (int 13h)
		5.25"/360 kB floppy services are supported (int 13h)
		5.25"/1.2 MB floppy services are supported (int 13h)
		3.5"/720 kB floppy services are supported (int 13h)
		3.5"/2.88 MB floppy services are supported (int 13h)
		8042 keyboard services are supported (int 9h)
		CGA/mono video services are supported (int 10h)
		ACPI is supported
		USB legacy is supported
		Targeted content distribution is supported
	BIOS Revision: 15.18
	Firmware Revision: 73.13

Handle 0x0001, DMI type 1, 27 bytes
System Information
	Manufacturer: Hewlett-Packard
	Product Name: HP Pavilion dm1 Notebook PC
	Version: 048C110000241B00000320000
	Serial Number: CNF9513F0Z
	UUID: 39464E43-3135-4633-305A-00269EC4496F
	Wake-up Type: Power Switch
	SKU Number: VY489EA#ABZ
	Family: 103C_5335KV

Handle 0x0002, DMI type 2, 16 bytes
Base Board Information
	Manufacturer: Hewlett-Packard
	Product Name: 3663
	Version: 49.0D
	Serial Number: CNF9513F0Z
	Asset Tag: Base Board Asset Tag
	Features:
		Board is a hosting board
		Board is replaceable
	Location In Chassis: Base Board Chassis Location
	Chassis Handle: 0x0003
	Type: Motherboard
	Contained Object Handles: 0

Handle 0x0003, DMI type 3, 22 bytes
Chassis Information
	Manufacturer: Hewlett-Packard
	Type: Notebook
	Lock: Not Present
	Version: N/A
	Serial Number: None
	Asset Tag: Not Specified
	Boot-up State: Safe
	Power Supply State: Safe
	Thermal State: Safe
	Security Status: None
	OEM Information: 0x0000001B
	Height: Unspecified
	Number Of Power Cords: 1
	Contained Elements: 0

Handle 0x0004, DMI type 16, 15 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: None
	Maximum Capacity: 5 GB
	Error Information Handle: Not Provided
	Number Of Devices: 2

Handle 0x0005, DMI type 17, 28 bytes
Memory Device
	Array Handle: 0x0004
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 1024 MB
	Form Factor: SODIMM
	Set: None
	Locator: DIMM0
	Bank Locator: BANK 0
	Type: <OUT OF SPEC>
	Type Detail: Synchronous
	Speed: 800 MHz
	Manufacturer: Micron
	Serial Number: 00000000
	Asset Tag: Unknown
	Part Number: 8JSF12864HZ-1G1F1F
	Rank: Unknown

Handle 0x0006, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0003FFFFFFF
	Range Size: 1 GB
	Physical Device Handle: 0x0005
	Memory Array Mapped Address Handle: 0x0009
	Partition Row Position: 2
	Interleave Position: 1
	Interleaved Data Depth: 1

Handle 0x0007, DMI type 17, 28 bytes
Memory Device
	Array Handle: 0x0004
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 1024 MB
	Form Factor: SODIMM
	Set: None
	Locator: DIMM1
	Bank Locator: BANK 2
	Type: <OUT OF SPEC>
	Type Detail: Synchronous
	Speed: 800 MHz
	Manufacturer: Micron
	Serial Number: E633576E
	Asset Tag: Unknown
	Part Number: 8JSF12864HZ-1G4F1
	Rank: Unknown

Handle 0x0008, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0003FFFFFFF
	Range Size: 1 GB
	Physical Device Handle: 0x0007
	Memory Array Mapped Address Handle: 0x0009
	Partition Row Position: 2
	Interleave Position: 2
	Interleaved Data Depth: 1

Handle 0x0009, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0007FFFFFFF
	Range Size: 2 GB
	Physical Array Handle: 0x0004
	Partition Width: 0

Handle 0x000A, DMI type 4, 42 bytes
Processor Information
	Socket Designation: CPU
	Type: Central Processor
	Family: Core 2 Duo
	Manufacturer: Intel(R) Corporation
	ID: 7A 06 01 00 FF FB EB BF
	Signature: Type 0, Family 6, Model 23, Stepping 10
	Flags:
		FPU (Floating-point unit on-chip)
		VME (Virtual mode extension)
		DE (Debugging extension)
		PSE (Page size extension)
		TSC (Time stamp counter)
		MSR (Model specific registers)
		PAE (Physical address extension)
		MCE (Machine check exception)
		CX8 (CMPXCHG8 instruction supported)
		APIC (On-chip APIC hardware supported)
		SEP (Fast system call)
		MTRR (Memory type range registers)
		PGE (Page global enable)
		MCA (Machine check architecture)
		CMOV (Conditional move instruction supported)
		PAT (Page attribute table)
		PSE-36 (36-bit page size extension)
		CLFSH (CLFLUSH instruction supported)
		DS (Debug store)
		ACPI (ACPI supported)
		MMX (MMX technology supported)
		FXSR (Fast floating-point save and restore)
		SSE (Streaming SIMD extensions)
		SSE2 (Streaming SIMD extensions 2)
		SS (Self-snoop)
		HTT (Hyper-threading technology)
		TM (Thermal monitor supported)
		PBE (Pending break enabled)
	Version: Genuine Intel(R) CPU           U2300  @ 1.20GHz
	Voltage: 1.6 V
	External Clock: 800 MHz
	Max Speed: 1200 MHz
	Current Speed: 1200 MHz
	Status: Populated, Enabled
	Upgrade: Other
	L1 Cache Handle: 0x000D
	L2 Cache Handle: 0x000B
	L3 Cache Handle: Not Provided
	Serial Number: Not Specified
	Asset Tag: FFFF
	Part Number: Not Specified
	Core Count: 2
	Core Enabled: 2
	Thread Count: 2
	Characteristics:
		64-bit capable

Handle 0x000B, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L2 Cache
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 1024 kB
	Maximum Size: 1024 kB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Unified
	Associativity: 4-way Set-associative

Handle 0x000C, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L1 Cache
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 32 kB
	Maximum Size: 32 kB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Instruction
	Associativity: 8-way Set-associative

Handle 0x000D, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L1 Cache
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 32 kB
	Maximum Size: 32 kB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Data
	Associativity: 8-way Set-associative

Handle 0x000E, DMI type 9, 17 bytes
System Slot Information
	Designation: PCI Express Graphic X16
	Type: x16 PCI Express
	Current Usage: Available
	Length: Other
	ID: 0
	Characteristics:
		PME signal is supported
		Hot-plug devices are supported

Handle 0x000F, DMI type 9, 17 bytes
System Slot Information
	Designation: PCI Express-0
	Type: x1 PCI Express
	Current Usage: Available
	Length: Other
	ID: 0
	Characteristics:
		PME signal is supported
		Hot-plug devices are supported

Handle 0x0010, DMI type 10, 6 bytes
On Board Device Information
	Type: Video
	Status: Enabled
	Description:

Handle 0x0011, DMI type 22, 26 bytes
Portable Battery
	Location: Primary
	Manufacturer: SMP-LG26B3
	Name: PT06055
	Design Capacity: 5100 mWh
	Design Voltage: 10800 mV
	SBDS Version: 1.1
	Maximum Error: 1%
	SBDS Serial Number: 0F7D
	SBDS Manufacture Date: 2009-12-04
	SBDS Chemistry: LION
	OEM-specific Information: 0x00000000

Handle 0x0012, DMI type 11, 5 bytes
OEM Strings
	String 1: $HP$
	String 2: LOC#ABZ
	String 3: ABS 70/71 78 79 7A 7B
	String 4: CNB1 048C110000241B00000320000

Handle 0x0013, DMI type 15, 29 bytes
System Event Log
	Area Length: 32672 bytes
	Header Start Offset: 0x0000
	Data Start Offset: 0x0000
	Access Method: General-purpose non-volatile data functions
	Access Address: 0x0000
	Status: Valid, Not Full
	Change Token: 0x12345678
	Header Format: OEM-specific
	Supported Log Type Descriptors: 3
	Descriptor 1: POST memory resize
	Data Format 1: None
	Descriptor 2: POST error
	Data Format 2: POST results bitmap
	Descriptor 3: Log area reset/cleared
	Data Format 3: None

Handle 0x0014, DMI type 32, 20 bytes
System Boot Information
	Status: No errors detected

Handle 0x0015, DMI type 41, 11 bytes
Onboard Device
	Reference Designation: Mobile Intel(R) Series Express Chipset Family
	Type: Video
	Status: Enabled
	Type Instance: 1
	Bus Address: 0000:00:02.0

Handle 0x0016, DMI type 41, 11 bytes
Onboard Device
	Reference Designation: Atheros AR9285 802.11b/g/n WiFi Adapter
	Type: Ethernet
	Status: Enabled
	Type Instance: 1
	Bus Address: 0000:02:00.0

Handle 0x0017, DMI type 127, 4 bytes
End Of Table

--

root ~ #  lspci -vvv
00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory
Controller Hub (rev 07)
	Subsystem: Hewlett-Packard Company Device 3663
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=0a <?>
	Kernel driver in use: agpgart-intel
	Kernel modules: intel-agp

00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series
Chipset Integrated Graphics Controller (rev 07) (prog-if 00 [VGA
controller])
	Subsystem: Hewlett-Packard Company Device 3663
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 26
	Region 0: Memory at 90000000 (64-bit, non-prefetchable) [size=4M]
	Region 2: Memory at 80000000 (64-bit, prefetchable) [size=256M]
	Region 4: I/O ports at 40f0 [size=8]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4169
	Capabilities: [d0] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: i915
	Kernel modules: i915

00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset
Integrated Graphics Controller (rev 07)
	Subsystem: Hewlett-Packard Company Device 3663
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Region 0: Memory at 92400000 (64-bit, non-prefetchable) [size=1M]
	Capabilities: [d0] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #4 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Device 3663
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 4: I/O ports at 40c0 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2
EHCI Controller #2 (rev 03) (prog-if 20 [EHCI])
	Subsystem: Hewlett-Packard Company Device 3663
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 19
	Region 0: Memory at 94505c00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio
Controller (rev 03)
	Subsystem: Hewlett-Packard Company Device 3663
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 22
	Region 0: Memory at 94500000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE- FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0
<64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
		VC1:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=1 ArbSelect=Fixed TC/VC=00
			Status:	NegoPending- InProgress-
	Capabilities: [130 v1] Root Complex Link
		Desc:	PortNumber=0f ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB-
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
Port 1 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: 93500000-944fffff
	Prefetchable memory behind bridge: 0000000090400000-00000000913fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<256ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #0, PowerLimit 6.500W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4159
	Capabilities: [90] Subsystem: Hewlett-Packard Company Device 3663
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=01 ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB-
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
Port 2 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: 92500000-934fffff
	Prefetchable memory behind bridge: 0000000091400000-00000000923fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<256ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #1, PowerLimit 6.500W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn+ PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4161
	Capabilities: [90] Subsystem: Hewlett-Packard Company Device 3663
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=02 ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB-
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #1 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Device 3663
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 20
	Region 4: I/O ports at 40a0 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #2 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Device 3663
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 4: I/O ports at 4080 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #3 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Device 3663
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 16
	Region 4: I/O ports at 4060 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.3 USB Controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #6 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Device 3663
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 4: I/O ports at 4040 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2
EHCI Controller #1 (rev 03) (prog-if 20 [EHCI])
	Subsystem: Hewlett-Packard Company Device 3663
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 20
	Region 0: Memory at 94505800 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 93)
(prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=32
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Subsystem: Hewlett-Packard Company Device 3663

00:1f.0 ISA bridge: Intel Corporation ICH9M-E LPC Interface Controller (rev 03)
	Subsystem: Hewlett-Packard Company Device 3663
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=0c <?>
	Kernel modules: iTCO_wdt

00:1f.2 SATA controller: Intel Corporation ICH9M/M-E SATA AHCI
Controller (rev 03) (prog-if 01 [AHCI 1.0])
	Subsystem: Hewlett-Packard Company Device 3663
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 27
	Region 0: I/O ports at 40e8 [size=8]
	Region 1: I/O ports at 40fc [size=4]
	Region 2: I/O ports at 40e0 [size=8]
	Region 3: I/O ports at 40f8 [size=4]
	Region 4: I/O ports at 4020 [size=32]
	Region 5: Memory at 94505000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [80] MSI: Enable+ Count=1/16 Maskable- 64bit-
		Address: fee0300c  Data: 4179
	Capabilities: [70] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
	Capabilities: [b0] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ahci
	Kernel modules: ahci

00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 03)
	Subsystem: Hewlett-Packard Company Device 3663
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at 94506000 (64-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at 4000 [size=32]
	Kernel driver in use: i801_smbus
	Kernel modules: i2c-i801

00:1f.6 Signal processing controller: Intel Corporation 82801I (ICH9
Family) Thermal Subsystem (rev 03)
	Subsystem: Hewlett-Packard Company Device 3663
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin C routed to IRQ 11
	Region 0: Memory at 94504000 (64-bit, non-prefetchable) [size=4K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-

02:00.0 Network controller: Atheros Communications Inc. AR9285
Wireless Network Adapter (PCI-Express) (rev 01)
	Subsystem: Hewlett-Packard Company Device 3040
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at 93500000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2- AuxCurrent=375mA PME(D0+,D1+,D2-,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [60] Express (v2) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<512ns, L1 <64us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [140 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [160 v1] Device Serial Number 00-15-17-ff-ff-24-14-12
	Capabilities: [170 v1] Power Budgeting <?>
	Kernel driver in use: ath9k
	Kernel modules: ath9k

03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
	Subsystem: Hewlett-Packard Company Device 3663
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at 2000 [size=256]
	Region 2: Memory at 91410000 (64-bit, prefetchable) [size=4K]
	Region 4: Memory at 91400000 (64-bit, prefetchable) [size=64K]
	Expansion ROM at 91420000 [disabled] [size=64K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [70] Express (v2) Endpoint, MSI 01
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <128ns, L1 <2us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<512ns, L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [ac] MSI-X: Enable- Count=2 Masked-
		Vector table: BAR=4 offset=00000000
		PBA: BAR=4 offset=00000800
	Capabilities: [cc] Vital Product Data
		Unknown small resource type 00, will not decode more.
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [140 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [160 v1] Device Serial Number 00-00-00-00-00-00-00-00
	Kernel modules: r8169

--

please ask for other useful info you eventually need !

thanks

On Mon, Feb 22, 2010 at 12:07 PM, Stefano Z. <mie.iscrizioni@gmail.com> wrote:
> hello,
>
> please take a look to this problem:
>
> http://bugs.archlinux.org/task/17771
>
> thanks !
>
