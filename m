Return-Path: <linux-kernel-owner+w=401wt.eu-S1759259AbXGBI21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259AbXGBI21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 04:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbXGBI2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 04:28:20 -0400
Received: from smtpout02s1.x-echo.com ([193.252.149.38]:55360 "EHLO
	smtpout02s1.x-echo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbXGBI2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 04:28:19 -0400
X-Greylist: delayed 465 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Jul 2007 04:28:18 EDT
Message-ID: <4688B546.1010701@lea-linux.com>
Date: Mon, 02 Jul 2007 10:20:22 +0200
From: serge <lkm@lea-linux.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [POSSIBLE BUG]: tg3 network is "lost"
Content-Type: multipart/mixed;
 boundary="------------020801030204040800050305"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020801030204040800050305
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello everybody.

This is a second post, because title was wrong on the first post. Please
excuse my english, i'm french.

I have a big trouble with several server, web server. They are all
debian sarge based.

Program that run on tem are principally Apache2, PHP5, Zend cluster with
session management, Postfix and NFS client


Theses servers work well and, suddendly, one of them lost network.

Let me describe when i say "lost network":
- The server doesn't answer to a ping, all network application on it
doesn't anwer too
- The server can't ping another server, or make another network connection
- The server loose NFS communication with the NFS server
- On the console, if i type ifconfig i see the interface configured with
it's own IP
- On the console if i launch iptraf i only see icmp host unrechable message
- On the console if i type "mii-tool" it say that link is 100FX
negociated and link is UP
- The only way i have found to solve the trouble is to launch
"/etc/init.d/network restart". the network come back.
- When the server "lost" network, i don't have any message even with
debug activated on kernel
- When i restart network, i have these kernel message (seems to be
"normal"):

92554.221511] PM: Writing back config space on device 0000:02:02.0 at
offset b (was 164814e4, writing d00e11)
[492554.221528] PM: Writing back config space on device 0000:02:02.0 at
offset 3 (was 804000, writing 804010)
[492554.221534] PM: Writing back config space on device 0000:02:02.0 at
offset 2 (was 2000000, writing 2000010)
[492554.221540] PM: Writing back config space on device 0000:02:02.0 at
offset 1 (was 2b00000, writing 2b00146)
[492554.525866] PM: Writing back config space on device 0000:02:02.0 at
offset b (was 164814e4, writing d00e11)
[492554.525883] PM: Writing back config space on device 0000:02:02.0 at
offset 3 (was 804000, writing 804010)
[492554.525889] PM: Writing back config space on device 0000:02:02.0 at
offset 2 (was 2000000, writing 2000010)
[492554.525895] PM: Writing back config space on device 0000:02:02.0 at
offset 1 (was 2b00000, writing 2b00146)
[492556.321312] tg3: eth0: Link is up at 100 Mbps, full duplex.
[492556.321334] tg3: eth0: Flow control is on for TX and on for RX.


- Theses server are IP statics (not DHCP client).
- This is not cable or switch trouble (servers are on different switch)
- They are kernel 2.6.19.3, but we have the same trouble with other
kernel like 2.6.17.1


I attach you some information about server, like lspci -vvv, config.gz.


Thanks for reading me and for your help.










--------------020801030204040800050305
Content-Type: application/gzip;
 name="config.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="config.gz"

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
5tLxEENkyfdy/wOKTTelFG8AAA==
--------------020801030204040800050305
Content-Type: text/plain;
 name="lscpi_vvv.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="lscpi_vvv.txt"

0000:00:00.0 Host bridge: Intel Corp. Server Memory Controller Hub (rev 0c)
	Subsystem: Compaq Computer Corporation: Unknown device 3200
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Capabilities: [40] #09 [4105]

0000:00:02.0 PCI bridge: Intel Corp. Memory Controller Hub PCI Express Port A0 (rev 0c) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 0x10 (64 bytes)
	Bus: primary=00, secondary=0d, subordinate=0f, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Message Signalled Interrupts: 64bit- Queue=0/1 Enable-
		Address: fee00000  Data: 0000
	Capabilities: [64] #10 [0041]

0000:00:04.0 PCI bridge: Intel Corp. Memory Controller Hub PCI Express Port B0 (rev 0c) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 0x10 (64 bytes)
	Bus: primary=00, secondary=06, subordinate=0c, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Message Signalled Interrupts: 64bit- Queue=0/1 Enable-
		Address: fee00000  Data: 0000
	Capabilities: [64] #10 [0041]

0000:00:06.0 PCI bridge: Intel Corp. Memory Controller Hub PCI Express Port C0 (rev 0c) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 0x10 (64 bytes)
	Bus: primary=00, secondary=03, subordinate=05, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Message Signalled Interrupts: 64bit- Queue=0/1 Enable-
		Address: fee00000  Data: 0000
	Capabilities: [64] #10 [0041]

0000:00:1c.0 PCI bridge: Intel Corp. 6300ESB 64-bit PCI-X Bridge (rev 02) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, Cache Line Size: 0x10 (64 bytes)
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=64
	I/O behind bridge: 00004000-00004fff
	Memory behind bridge: fdf00000-fdffffff
	Prefetchable memory behind bridge: 00000000e2000000-00000000e2000000
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: [50] PCI-X bridge device.
		Secondary Status: 64bit+, 133MHz-, SCD-, USC-, SCO-, SRD- Freq=1
		Status: Bus=0 Dev=28 Func=0 64bit+ 133MHz- SCD- USC-, SCO-, SRD-
		: Upstream: Capacity=65535, Commitment Limit=0
		: Downstream: Capacity=65535, Commitment Limit=0

0000:00:1d.0 USB Controller: Intel Corp. 6300ESB USB Universal Host Controller (rev 02) (prog-if 00 [UHCI])
	Subsystem: Compaq Computer Corporation: Unknown device 3201
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 4: I/O ports at 5000 [size=32]

0000:00:1d.1 USB Controller: Intel Corp. 6300ESB USB Universal Host Controller (rev 02) (prog-if 00 [UHCI])
	Subsystem: Compaq Computer Corporation: Unknown device 3201
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 4: I/O ports at 5020 [size=32]

0000:00:1d.4 System peripheral: Intel Corp. 6300ESB Watchdog Timer (rev 02)
	Subsystem: Compaq Computer Corporation: Unknown device 3201
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Region 0: Memory at fbef0000 (32-bit, non-prefetchable) [size=16]

0000:00:1d.5 PIC: Intel Corp. 6300ESB I/O Advanced Programmable Interrupt Controller (rev 02) (prog-if 20 [IO(X)-APIC])
	Subsystem: Compaq Computer Corporation: Unknown device 3201
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Capabilities: [50] PCI-X non-bridge device.
		Command: DPERE- ERO- RBC=0 OST=0
		Status: Bus=0 Dev=29 Func=5 64bit+ 133MHz- SCD- USC-, DC=simple, DMMRBC=0, DMOST=0, DMCRS=0, RSCEM-

0000:00:1d.7 USB Controller: Intel Corp. 6300ESB USB2 Enhanced Host Controller (rev 02) (prog-if 20 [EHCI])
	Subsystem: Compaq Computer Corporation: Unknown device 3201
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin D routed to IRQ 23
	Region 0: Memory at fbee0000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] #0a [2080]

0000:00:1e.0 PCI bridge: Intel Corp. 82801 PCI Bridge (rev 0a) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
	I/O behind bridge: 00001000-00003fff
	Memory behind bridge: fbf00000-fcffffff
	Prefetchable memory behind bridge: e2100000-e21fffff
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-

0000:00:1f.0 ISA bridge: Intel Corp. 6300ESB LPC Interface Controller (rev 02)
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0

0000:00:1f.1 IDE interface: Intel Corp. 6300ESB PATA Storage Controller (rev 02) (prog-if 8a [Master SecP PriP])
	Subsystem: Compaq Computer Corporation: Unknown device 3201
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 18
	Region 0: I/O ports at <ignored>
	Region 1: I/O ports at <ignored>
	Region 2: I/O ports at <ignored>
	Region 3: I/O ports at <ignored>
	Region 4: I/O ports at 0500 [size=16]
	Region 5: Memory at e2200000 (32-bit, non-prefetchable) [size=1K]

0000:01:03.0 VGA compatible controller: ATI Technologies Inc Rage XL (rev 27) (prog-if 00 [VGA])
	Subsystem: Compaq Computer Corporation: Unknown device 001e
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (2000ns min), Cache Line Size: 0x10 (64 bytes)
	Region 0: Memory at fc000000 (32-bit, non-prefetchable) [size=16M]
	Region 1: I/O ports at 3000 [size=256]
	Region 2: Memory at fbff0000 (32-bit, non-prefetchable) [size=4K]
	Expansion ROM at e2100000 [disabled] [size=128K]
	Capabilities: [5c] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0000:01:04.0 System peripheral: Compaq Computer Corporation Integrated Lights Out Controller (rev 01)
	Subsystem: Compaq Computer Corporation: Unknown device b206
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin A routed to IRQ 21
	Region 0: I/O ports at 1800 [size=256]
	Region 1: Memory at fbfe0000 (32-bit, non-prefetchable) [size=512]
	Capabilities: [f0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0000:01:04.2 System peripheral: Compaq Computer Corporation Integrated Lights Out  Processor (rev 01)
	Subsystem: Compaq Computer Corporation: Unknown device b206
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping+ SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, Cache Line Size: 0x10 (64 bytes)
	Interrupt: pin B routed to IRQ 22
	Region 0: I/O ports at 3400 [size=256]
	Region 1: Memory at fbfd0000 (32-bit, non-prefetchable) [size=2K]
	Region 2: Memory at fbfc0000 (32-bit, non-prefetchable) [size=8K]
	Region 3: Memory at fbf00000 (32-bit, non-prefetchable) [size=512K]
	Expansion ROM at e2120000 [disabled] [size=64K]
	Capabilities: [f0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable+ DSel=0 DScale=0 PME-

0000:02:01.0 RAID bus controller: Compaq Computer Corporation Smart Array 64xx (rev 01)
	Subsystem: Compaq Computer Corporation: Unknown device 4091
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, Cache Line Size: 0x10 (64 bytes)
	Interrupt: pin A routed to IRQ 24
	Region 0: Memory at fdff0000 (64-bit, non-prefetchable) [size=8K]
	Region 2: I/O ports at 4000 [size=256]
	Region 3: Memory at fdf80000 (64-bit, non-prefetchable) [size=256K]
	Expansion ROM at e2000000 [disabled] [size=256K]
	Capabilities: [d0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [dc] PCI-X non-bridge device.
		Command: DPERE- ERO+ RBC=0 OST=4
		Status: Bus=2 Dev=1 Func=0 64bit+ 133MHz+ SCD- USC-, DC=simple, DMMRBC=2, DMOST=4, DMCRS=2, RSCEM-
	Capabilities: [f0] Vital Product Data

0000:02:02.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5704 Gigabit Ethernet (rev 10)
	Subsystem: Compaq Computer Corporation NC7782 Gigabit Server Adapter (PCI-X, 10,100,1000-T)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (16000ns min), Cache Line Size: 0x10 (64 bytes)
	Interrupt: pin A routed to IRQ 25
	Region 0: Memory at fdf70000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: [40] 	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable+ DSel=0 DScale=1 PME-
	Capabilities: [50] Vital Product Data
	Capabilities: [58] Message Signalled Interrupts: 64bit+ Queue=0/3 Enable-
		Address: 7afffd25fbf79f6c  Data: 7fdc

0000:02:02.1 Ethernet controller: Broadcom Corporation NetXtreme BCM5704 Gigabit Ethernet (rev 10)
	Subsystem: Compaq Computer Corporation NC7782 Gigabit Server Adapter (PCI-X, 10,100,1000-T)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (16000ns min), Cache Line Size: 0x10 (64 bytes)
	Interrupt: pin B routed to IRQ 26
	Region 0: Memory at fdf60000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: [40] 	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [50] Vital Product Data
	Capabilities: [58] Message Signalled Interrupts: 64bit+ Queue=0/3 Enable-
		Address: 0408d1a0bbaf2020  Data: 8c80

0000:06:00.0 PCI bridge: Intel Corp. PCI Bridge Hub A (rev 09) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 0x10 (64 bytes)
	Bus: primary=06, secondary=07, subordinate=09, sec-latency=64
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: [44] #10 [0071]
	Capabilities: [5c] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [6c] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [d8] 
0000:06:00.2 PCI bridge: Intel Corp. PCI Bridge Hub B (rev 09) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 0x10 (64 bytes)
	Bus: primary=06, secondary=0a, subordinate=0c, sec-latency=64
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: [44] #10 [0071]
	Capabilities: [5c] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [6c] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [d8] 

--------------020801030204040800050305--
