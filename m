Return-Path: <linux-kernel-owner+w=401wt.eu-S932195AbYBNRrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195AbYBNRrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 12:47:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751723AbYBNRrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 12:47:19 -0500
Received: from mail.gmx.net ([213.165.64.20]:37204 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751574AbYBNRrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 12:47:09 -0500
X-Authenticated: #815327
X-Provags-ID: V01U2FsdGVkX19Pey8cDAZPN+m/6opMEfGGUS8F5G5BwYf6odN64r
	tLbAK+/QDFBWyy
Date: Thu, 14 Feb 2008 18:47:00 +0100
From: Malte =?UTF-8?B?U2NocsO2ZGVy?= <maltesch@gmx.de>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Regression: kernel 2.6.24{,.1} ahci problem, does not boot (resend)
Message-ID: <20080214184700.0bd3837d@highlander.home.lan>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/GPiFJRMCvokmLGRK0RFfbdH";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/GPiFJRMCvokmLGRK0RFfbdH
Content-Type: multipart/mixed; boundary="MP_/Vd/D6xBF56+nJrKUKI5XFXp"

--MP_/Vd/D6xBF56+nJrKUKI5XFXp
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,
on one of my machines neither 2.6.24 nor 2.6.24.1 work.
The system is 64bit on Athlon X2 and ATI-Chipset (SB600).

Extract from the kernel messages during boot:

[   66.943103] ahci 0000:00:12.0: controller can't do 64bit DMA, forcing 32=
bit
[   66.950374] ahci 0000:00:12.0: controller can't do PMP, turning off CAP_=
PMP
[   67.956470] ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0x=
f impl SATA mode
[   67.964996] ahci 0000:00:12.0: flags: ncq sntf ilck pm led clo pio slum =
part
[   67.972820] scsi0 : ahci
[   67.975699] scsi1 : ahci
[   67.978445] scsi2 : ahci
[   67.981178] scsi3 : ahci
[   67.983949] ata1: SATA max UDMA/133 abar m1024@0xfadffc00 port 0xfadffd0=
0 irq 509
[   67.991825] ata2: SATA max UDMA/133 abar m1024@0xfadffc00 port 0xfadffd8=
0 irq 509
[   67.999729] ata3: SATA max UDMA/133 abar m1024@0xfadffc00 port 0xfadffe0=
0 irq 509
[   68.007619] ata4: SATA max UDMA/133 abar m1024@0xfadffc00 port 0xfadffe8=
0 irq 509
[   68.470669] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   98.431945] ata1.00: qc timeout (cmd 0xec)
[   98.454907] ata1.00: failed to IDENTIFY (I/O error, err_mask=3D0x4)
[   98.461296] ata1: failed to recover some devices, retrying in 5 secs
[  103.916773] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  133.878045] ata1.00: qc timeout (cmd 0xec)
[  133.882371] ata1.00: failed to IDENTIFY (I/O error, err_mask=3D0x4)
[  133.888797] ata1: failed to recover some devices, retrying in 5 secs
[  139.343901] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  169.305174] ata1.00: qc timeout (cmd 0xec)
[  169.309534] ata1.00: failed to IDENTIFY (I/O error, err_mask=3D0x4)
[  169.315926] ata1: failed to recover some devices, retrying in 5 secs
[  174.771030] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)

The complete boot-log (captured via serial console), lspci output,
output of hdparm -I and the kernel config are attached.

The PC has one IDE-drive and four SATA-drives (see hdparm.txt).
If I wait long enough, the IDE-drive get's recognized and I can
continue the boot process, but the SATA-drives are never recognized.
The system work's fine with kernel 2.6.23.11 (later kernels not tested).

I hope someone can help ...

Regards
--=20
---------------------------------------
Malte Schr=C3=B6der
MalteSch@gmx.de
ICQ# 68121508
---------------------------------------


--MP_/Vd/D6xBF56+nJrKUKI5XFXp
Content-Type: text/plain; name=lspci.txt
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=lspci.txt

00:00.0 Host bridge: ATI Technologies Inc RD580 [CrossFire Xpress 3200] Chi=
pset Host Bridge
00:04.0 PCI bridge: ATI Technologies Inc RS480 PCI Bridge
00:05.0 PCI bridge: ATI Technologies Inc RS480 PCI Bridge
00:12.0 SATA controller: ATI Technologies Inc SB600 Non-Raid-5 SATA
00:13.0 USB Controller: ATI Technologies Inc SB600 USB (OHCI0)
00:13.1 USB Controller: ATI Technologies Inc SB600 USB (OHCI1)
00:13.2 USB Controller: ATI Technologies Inc SB600 USB (OHCI2)
00:13.3 USB Controller: ATI Technologies Inc SB600 USB (OHCI3)
00:13.4 USB Controller: ATI Technologies Inc SB600 USB (OHCI4)
00:13.5 USB Controller: ATI Technologies Inc SB600 USB Controller (EHCI)
00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 13)
00:14.1 IDE interface: ATI Technologies Inc SB600 IDE
00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia
00:14.3 ISA bridge: ATI Technologies Inc SB600 PCI to LPC Bridge
00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Hyp=
erTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Add=
ress Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRA=
M Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Mis=
cellaneous Control
01:00.0 Ethernet controller: Intel Corporation 82572EI Gigabit Ethernet Con=
troller (Copper) (rev 06)
02:00.0 SATA controller: JMicron Technologies, Inc. JMicron 20360/20363 AHC=
I Controller (rev 02)
03:01.0 VGA compatible controller: Matrox Graphics, Inc. MGA 1064SG [Mystiq=
ue] (rev 02)
03:03.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host Control=
ler (rev c0)
03:04.0 Ethernet controller: Marvell Technology Group Ltd. 88E8001 Gigabit =
Ethernet Controller (rev 13)
#                                                                          =
     root@hades ~ # lspci -vvv
00:00.0 Host bridge: ATI Technologies Inc RD580 [CrossFire Xpress 3200] Chi=
pset Host Bridge
	Subsystem: ATI Technologies Inc RD580 [CrossFire Xpress 3200] Chipset Host=
 Bridge
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0

00:04.0 PCI bridge: ATI Technologies Inc RS480 PCI Bridge (prog-if 00 [Norm=
al decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=3D0
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: fae00000-faefffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3col=
d+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [58] Express (v1) Root Port (Slot-), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE- FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <64ns, =
L1 <1us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt-=
 ABWMgmt-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=3D0/0 =
Enable+
		Address: fee0300c  Data: 4149
	Capabilities: [b0] Subsystem: ATI Technologies Inc Unknown device 5952
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Kernel driver in use: pcieport-driver

00:05.0 PCI bridge: ATI Technologies Inc RS480 PCI Bridge (prog-if 00 [Norm=
al decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=3D00, secondary=3D02, subordinate=3D02, sec-latency=3D0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: faf00000-faffffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3col=
d+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [58] Express (v1) Root Port (Slot-), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE- FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <64ns, =
L1 <1us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt-=
 ABWMgmt-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=3D0/0 =
Enable+
		Address: fee0300c  Data: 4151
	Capabilities: [b0] Subsystem: ATI Technologies Inc Unknown device 5952
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Kernel driver in use: pcieport-driver

00:12.0 SATA controller: ATI Technologies Inc SB600 Non-Raid-5 SATA (prog-i=
f 01 [AHCI 1.0])
	Subsystem: ASUSTeK Computer Inc. Unknown device 8232
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 96, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 509
	Region 0: I/O ports at b000 [size=3D8]
	Region 1: I/O ports at a000 [size=3D4]
	Region 2: I/O ports at 9000 [size=3D8]
	Region 3: I/O ports at 8000 [size=3D4]
	Region 4: I/O ports at 7000 [size=3D16]
	Region 5: Memory at fadffc00 (32-bit, non-prefetchable) [size=3D1K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3col=
d-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=3D0/2 =
Enable+
		Address: 00000000fee0300c  Data: 4169
	Capabilities: [70] SATA HBA <?>
	Kernel driver in use: ahci
	Kernel modules: ahci

00:13.0 USB Controller: ATI Technologies Inc SB600 USB (OHCI0) (prog-if 10 =
[OHCI])
	Subsystem: ATI Technologies Inc SB600 USB (OHCI0)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Steppi=
ng- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at fadfe000 (32-bit, non-prefetchable) [size=3D4K]
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit- Queue=3D0/0 =
Enable-
		Address: 00000000  Data: 0000
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:13.1 USB Controller: ATI Technologies Inc SB600 USB (OHCI1) (prog-if 10 =
[OHCI])
	Subsystem: ATI Technologies Inc SB600 USB (OHCI1)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Steppi=
ng- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at fadfd000 (32-bit, non-prefetchable) [size=3D4K]
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit- Queue=3D0/0 =
Enable-
		Address: 00000000  Data: 0000
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:13.2 USB Controller: ATI Technologies Inc SB600 USB (OHCI2) (prog-if 10 =
[OHCI])
	Subsystem: ATI Technologies Inc SB600 USB (OHCI2)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Steppi=
ng- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at fadfc000 (32-bit, non-prefetchable) [size=3D4K]
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit- Queue=3D0/0 =
Enable-
		Address: 00000000  Data: 0000
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:13.3 USB Controller: ATI Technologies Inc SB600 USB (OHCI3) (prog-if 10 =
[OHCI])
	Subsystem: ATI Technologies Inc SB600 USB (OHCI3)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Steppi=
ng- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at fadf7000 (32-bit, non-prefetchable) [size=3D4K]
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit- Queue=3D0/0 =
Enable-
		Address: 00000000  Data: 0000
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:13.4 USB Controller: ATI Technologies Inc SB600 USB (OHCI4) (prog-if 10 =
[OHCI])
	Subsystem: ATI Technologies Inc SB600 USB (OHCI4)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Steppi=
ng- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at fadf6000 (32-bit, non-prefetchable) [size=3D4K]
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit- Queue=3D0/0 =
Enable-
		Address: 00000000  Data: 0000
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:13.5 USB Controller: ATI Technologies Inc SB600 USB Controller (EHCI) (p=
rog-if 20 [EHCI])
	Subsystem: ATI Technologies Inc SB600 USB Controller (EHCI)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Steppi=
ng- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin D routed to IRQ 19
	Region 0: Memory at fadff800 (32-bit, non-prefetchable) [size=3D256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2+,D3hot+,D3col=
d-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
		Bridge: PM- B3+
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit- Queue=3D0/0 =
Enable-
		Address: 00000000  Data: 0000
	Capabilities: [e4] Debug port: BAR=3D1 offset=3D00e0
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 13)
	Subsystem: ASUSTeK Computer Inc. Unknown device 4385
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Region 0: I/O ports at 0b00 [size=3D16]
	Region 1: Memory at fed00000 (32-bit, non-prefetchable) [size=3D1K]
	Capabilities: [b0] HyperTransport: MSI Mapping Enable- Fixed+

00:14.1 IDE interface: ATI Technologies Inc SB600 IDE (prog-if 8a [Master S=
ecP PriP])
	Subsystem: ATI Technologies Inc SB600 IDE
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Interrupt: pin A routed to IRQ 16
	Region 0: I/O ports at 01f0 [size=3D8]
	Region 1: I/O ports at 03f4 [size=3D1]
	Region 2: I/O ports at 0170 [size=3D8]
	Region 3: I/O ports at 0374 [size=3D1]
	Region 4: I/O ports at ff00 [size=3D16]
	Capabilities: [70] Message Signalled Interrupts: Mask- 64bit- Queue=3D0/0 =
Enable-
		Address: 00000000  Data: 0000
	Kernel driver in use: pata_atiixp
	Kernel modules: pata_atiixp

00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia
	Subsystem: ATI Technologies Inc SBx00 Azalia
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dslow >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin ? routed to IRQ 16
	Region 0: Memory at fadf0000 (64-bit, non-prefetchable) [size=3D16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D55mA PME(D0+,D1-,D2-,D3hot+,D3co=
ld+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=3D0/0 =
Enable-
		Address: 0000000000000000  Data: 0000
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:14.3 ISA bridge: ATI Technologies Inc SB600 PCI to LPC Bridge
	Subsystem: ATI Technologies Inc SB600 PCI to LPC Bridge
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge (prog-if 0=
1 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Bus: primary=3D00, secondary=3D03, subordinate=3D03, sec-latency=3D64
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: fb000000-fbffffff
	Prefetchable memory behind bridge: f9800000-f9ffffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Hyp=
erTransport Technology Configuration
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Capabilities: [80] HyperTransport: Host or Secondary Interface
		!!! Possibly incomplete decoding
		Command: WarmRst+ DblEnd-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=3D0
		Link Config: MLWI=3D16bit MLWO=3D16bit LWI=3D16bit LWO=3D16bit
		Revision ID: 1.02

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Add=
ress Map
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRA=
M Controller
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Mis=
cellaneous Control
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Capabilities: [f0] Secure device <?>
	Kernel driver in use: k8temp
	Kernel modules: k8temp

01:00.0 Ethernet controller: Intel Corporation 82572EI Gigabit Ethernet Con=
troller (Copper) (rev 06)
	Subsystem: Intel Corporation PRO/1000 PT Desktop Adapter
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at faee0000 (32-bit, non-prefetchable) [size=3D128K]
	Region 1: Memory at faec0000 (32-bit, non-prefetchable) [size=3D128K]
	Region 2: I/O ports at cc00 [size=3D32]
	Expansion ROM at faea0000 [disabled] [size=3D128K]
	Capabilities: [c8] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3col=
d+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D1 PME-
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=3D0/0 =
Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [e0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0 <4us, L1 <=
64us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt-=
 ABWMgmt-
	Kernel driver in use: e1000
	Kernel modules: e1000

02:00.0 SATA controller: JMicron Technologies, Inc. JMicron 20360/20363 AHC=
I Controller (rev 02) (prog-if 01 [AHCI 1.0])
	Subsystem: ASUSTeK Computer Inc. Unknown device 8202
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 17
	Region 0: I/O ports at dc00 [size=3D8]
	Region 1: I/O ports at d880 [size=3D4]
	Region 2: I/O ports at d800 [size=3D8]
	Region 3: I/O ports at d480 [size=3D4]
	Region 4: I/O ports at d400 [size=3D16]
	Region 5: Memory at faffe000 (32-bit, non-prefetchable) [size=3D8K]
	Capabilities: [68] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot+,D3col=
d-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [50] Express (v1) Legacy Endpoint, MSI 01
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0 <1us, L1 <=
16us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt-=
 ABWMgmt-
	Kernel driver in use: ahci
	Kernel modules: ahci

03:01.0 VGA compatible controller: Matrox Graphics, Inc. MGA 1064SG [Mystiq=
ue] (rev 02) (prog-if 00 [VGA controller])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng+ SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Interrupt: pin A routed to IRQ 9
	Region 0: Memory at fbffc000 (32-bit, non-prefetchable) [size=3D16K]
	Region 1: Memory at f9800000 (32-bit, prefetchable) [size=3D8M]
	Region 2: Memory at fb000000 (32-bit, non-prefetchable) [size=3D8M]
	Expansion ROM at fb820000 [disabled] [size=3D64K]

03:03.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host Control=
ler (rev c0) (prog-if 10 [OHCI])
	Subsystem: ASUSTeK Computer Inc. Unknown device 81fe
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Steppi=
ng- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (8000ns max), Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 3
	Region 0: Memory at fbffb800 (32-bit, non-prefetchable) [size=3D2K]
	Region 1: I/O ports at ec00 [size=3D128]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2+ AuxCurrent=3D0mA PME(D0-,D1-,D2+,D3hot+,D3col=
d+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

03:04.0 Ethernet controller: Marvell Technology Group Ltd. 88E8001 Gigabit =
Ethernet Controller (rev 13)
	Subsystem: ASUSTeK Computer Inc. Marvell 88E8001 Gigabit Ethernet Controll=
er (Asus)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Steppi=
ng- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (5750ns min, 7750ns max), Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at fbff4000 (32-bit, non-prefetchable) [size=3D16K]
	Region 1: I/O ports at e800 [size=3D256]
	Expansion ROM at fb800000 [disabled] [size=3D128K]
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2+,D3hot+,D3col=
d+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D1 PME-
	Capabilities: [50] Vital Product Data <?>
	Kernel driver in use: skge
	Kernel modules: skge

#                                                                          =
     root@hades ~ # lspci -vvvn
00:00.0 0600: 1002:5952
	Subsystem: 1002:5952
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0

00:04.0 0604: 1002:5a36 (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=3D0
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: fae00000-faefffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3col=
d+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [58] Express (v1) Root Port (Slot-), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE- FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <64ns, =
L1 <1us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt-=
 ABWMgmt-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=3D0/0 =
Enable+
		Address: fee0300c  Data: 4149
	Capabilities: [b0] Subsystem: 1002:5952
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Kernel driver in use: pcieport-driver

00:05.0 0604: 1002:5a37 (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=3D00, secondary=3D02, subordinate=3D02, sec-latency=3D0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: faf00000-faffffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3col=
d+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [58] Express (v1) Root Port (Slot-), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE- FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <64ns, =
L1 <1us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt-=
 ABWMgmt-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=3D0/0 =
Enable+
		Address: fee0300c  Data: 4151
	Capabilities: [b0] Subsystem: 1002:5952
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Kernel driver in use: pcieport-driver

00:12.0 0106: 1002:4380 (prog-if 01 [AHCI 1.0])
	Subsystem: 1043:8232
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 96, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 509
	Region 0: I/O ports at b000 [size=3D8]
	Region 1: I/O ports at a000 [size=3D4]
	Region 2: I/O ports at 9000 [size=3D8]
	Region 3: I/O ports at 8000 [size=3D4]
	Region 4: I/O ports at 7000 [size=3D16]
	Region 5: Memory at fadffc00 (32-bit, non-prefetchable) [size=3D1K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3col=
d-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=3D0/2 =
Enable+
		Address: 00000000fee0300c  Data: 4169
	Capabilities: [70] SATA HBA <?>
	Kernel driver in use: ahci
	Kernel modules: ahci

00:13.0 0c03: 1002:4387 (prog-if 10 [OHCI])
	Subsystem: 1002:4387
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Steppi=
ng- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at fadfe000 (32-bit, non-prefetchable) [size=3D4K]
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit- Queue=3D0/0 =
Enable-
		Address: 00000000  Data: 0000
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:13.1 0c03: 1002:4388 (prog-if 10 [OHCI])
	Subsystem: 1002:4388
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Steppi=
ng- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at fadfd000 (32-bit, non-prefetchable) [size=3D4K]
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit- Queue=3D0/0 =
Enable-
		Address: 00000000  Data: 0000
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:13.2 0c03: 1002:4389 (prog-if 10 [OHCI])
	Subsystem: 1002:4389
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Steppi=
ng- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at fadfc000 (32-bit, non-prefetchable) [size=3D4K]
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit- Queue=3D0/0 =
Enable-
		Address: 00000000  Data: 0000
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:13.3 0c03: 1002:438a (prog-if 10 [OHCI])
	Subsystem: 1002:438a
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Steppi=
ng- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at fadf7000 (32-bit, non-prefetchable) [size=3D4K]
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit- Queue=3D0/0 =
Enable-
		Address: 00000000  Data: 0000
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:13.4 0c03: 1002:438b (prog-if 10 [OHCI])
	Subsystem: 1002:438b
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Steppi=
ng- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at fadf6000 (32-bit, non-prefetchable) [size=3D4K]
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit- Queue=3D0/0 =
Enable-
		Address: 00000000  Data: 0000
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:13.5 0c03: 1002:4386 (prog-if 20 [EHCI])
	Subsystem: 1002:4386
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Steppi=
ng- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin D routed to IRQ 19
	Region 0: Memory at fadff800 (32-bit, non-prefetchable) [size=3D256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2+,D3hot+,D3col=
d-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
		Bridge: PM- B3+
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit- Queue=3D0/0 =
Enable-
		Address: 00000000  Data: 0000
	Capabilities: [e4] Debug port: BAR=3D1 offset=3D00e0
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:14.0 0c05: 1002:4385 (rev 13)
	Subsystem: 1043:4385
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Region 0: I/O ports at 0b00 [size=3D16]
	Region 1: Memory at fed00000 (32-bit, non-prefetchable) [size=3D1K]
	Capabilities: [b0] HyperTransport: MSI Mapping Enable- Fixed+

00:14.1 0101: 1002:438c (prog-if 8a [Master SecP PriP])
	Subsystem: 1002:438c
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Interrupt: pin A routed to IRQ 16
	Region 0: I/O ports at 01f0 [size=3D8]
	Region 1: I/O ports at 03f4 [size=3D1]
	Region 2: I/O ports at 0170 [size=3D8]
	Region 3: I/O ports at 0374 [size=3D1]
	Region 4: I/O ports at ff00 [size=3D16]
	Capabilities: [70] Message Signalled Interrupts: Mask- 64bit- Queue=3D0/0 =
Enable-
		Address: 00000000  Data: 0000
	Kernel driver in use: pata_atiixp
	Kernel modules: pata_atiixp

00:14.2 0403: 1002:4383
	Subsystem: 1002:4383
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dslow >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin ? routed to IRQ 16
	Region 0: Memory at fadf0000 (64-bit, non-prefetchable) [size=3D16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D55mA PME(D0+,D1-,D2-,D3hot+,D3co=
ld+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=3D0/0 =
Enable-
		Address: 0000000000000000  Data: 0000
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:14.3 0601: 1002:438d
	Subsystem: 1002:438d
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:14.4 0604: 1002:4384 (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Bus: primary=3D00, secondary=3D03, subordinate=3D03, sec-latency=3D64
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: fb000000-fbffffff
	Prefetchable memory behind bridge: f9800000-f9ffffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:18.0 0600: 1022:1100
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Capabilities: [80] HyperTransport: Host or Secondary Interface
		!!! Possibly incomplete decoding
		Command: WarmRst+ DblEnd-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=3D0
		Link Config: MLWI=3D16bit MLWO=3D16bit LWI=3D16bit LWO=3D16bit
		Revision ID: 1.02

00:18.1 0600: 1022:1101
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-

00:18.2 0600: 1022:1102
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-

00:18.3 0600: 1022:1103
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Capabilities: [f0] Secure device <?>
	Kernel driver in use: k8temp
	Kernel modules: k8temp

01:00.0 0200: 8086:10b9 (rev 06)
	Subsystem: 8086:1083
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at faee0000 (32-bit, non-prefetchable) [size=3D128K]
	Region 1: Memory at faec0000 (32-bit, non-prefetchable) [size=3D128K]
	Region 2: I/O ports at cc00 [size=3D32]
	Expansion ROM at faea0000 [disabled] [size=3D128K]
	Capabilities: [c8] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3col=
d+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D1 PME-
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=3D0/0 =
Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [e0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0 <4us, L1 <=
64us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt-=
 ABWMgmt-
	Kernel driver in use: e1000
	Kernel modules: e1000

02:00.0 0106: 197b:2360 (rev 02) (prog-if 01 [AHCI 1.0])
	Subsystem: 1043:8202
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 17
	Region 0: I/O ports at dc00 [size=3D8]
	Region 1: I/O ports at d880 [size=3D4]
	Region 2: I/O ports at d800 [size=3D8]
	Region 3: I/O ports at d480 [size=3D4]
	Region 4: I/O ports at d400 [size=3D16]
	Region 5: Memory at faffe000 (32-bit, non-prefetchable) [size=3D8K]
	Capabilities: [68] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot+,D3col=
d-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [50] Express (v1) Legacy Endpoint, MSI 01
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0 <1us, L1 <=
16us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt-=
 ABWMgmt-
	Kernel driver in use: ahci
	Kernel modules: ahci

03:01.0 0300: 102b:051a (rev 02) (prog-if 00 [VGA controller])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng+ SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Interrupt: pin A routed to IRQ 9
	Region 0: Memory at fbffc000 (32-bit, non-prefetchable) [size=3D16K]
	Region 1: Memory at f9800000 (32-bit, prefetchable) [size=3D8M]
	Region 2: Memory at fb000000 (32-bit, non-prefetchable) [size=3D8M]
	Expansion ROM at fb820000 [disabled] [size=3D64K]

03:03.0 0c00: 1106:3044 (rev c0) (prog-if 10 [OHCI])
	Subsystem: 1043:81fe
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Steppi=
ng- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (8000ns max), Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 3
	Region 0: Memory at fbffb800 (32-bit, non-prefetchable) [size=3D2K]
	Region 1: I/O ports at ec00 [size=3D128]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2+ AuxCurrent=3D0mA PME(D0-,D1-,D2+,D3hot+,D3col=
d+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

03:04.0 0200: 11ab:4320 (rev 13)
	Subsystem: 1043:811a
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Steppi=
ng- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (5750ns min, 7750ns max), Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at fbff4000 (32-bit, non-prefetchable) [size=3D16K]
	Region 1: I/O ports at e800 [size=3D256]
	Expansion ROM at fb800000 [disabled] [size=3D128K]
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2+,D3hot+,D3col=
d+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D1 PME-
	Capabilities: [50] Vital Product Data <?>
	Kernel driver in use: skge
	Kernel modules: skge

2-bit, non-prefetchable) [size=3D2K]
	Region 1: I/O ports at ec00 [size=3D128]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2+ AuxCurrent=3D0mA PME(D0-,D1-,D2+,D3hot+,D3col=
d+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

03:04.0 0200: 11ab:4320 (rev 13)
	Subsystem: 1043:811a
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Steppi=
ng- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (5750ns min, 7750ns max), Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at fbff4000 (32-bit, non-prefetchable) [size=3D16K]
	Region 1: I/O ports at e800 [size=3D256]
	Expansion ROM at fb800000 [disabled] [size=3D128K]
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2+,D3hot+,D3col=
d+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D1 PME-
	Capabilities: [50] Vital Product Data <?>
	Kernel driver in use: skge
	Kernel modules: skge


--MP_/Vd/D6xBF56+nJrKUKI5XFXp
Content-Type: text/plain; name=boot.txt
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=boot.txt

[    0.000000] Linux version 2.6.24.1 (root@highlander) (gcc version 4.2.3 =
(Debian 4.2.3-1)) #1 SMP Sat Feb 9 11:07:57 CET 2008
[    0.000000] Command line: root=3DLABEL=3DROOT ro vga=3Dextended console=
=3Dtty0 console=3DttyS0,115200
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000098000 (usable)
[    0.000000]  BIOS-e820: 0000000000098000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007ffb0000 (usable)
[    0.000000]  BIOS-e820: 000000007ffb0000 - 000000007ffbe000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007ffbe000 - 000000007ffe0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007ffe0000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff700000 - 0000000100000000 (reserved)
[    0.000000] end_pfn_map =3D 1048576
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000FB400, 0024 (r2 ACPIAM)
[    0.000000] ACPI: XSDT 7FFB0100, 005C (r1 NEC              1000709 MSFT =
      97)
[    0.000000] ACPI: FACP 7FFB0290, 00F4 (r3 A_M_I_ OEMFACP   1000709 MSFT =
      97)
[    0.000000] ACPI: DSDT 7FFB05B0, 7A34 (r1  A0578 A0578000        0 INTL =
20060113)
[    0.000000] ACPI: FACS 7FFBE000, 0040
[    0.000000] ACPI: APIC 7FFB0390, 005C (r1 A_M_I_ OEMAPIC   1000709 MSFT =
      97)
[    0.000000] ACPI: MCFG 7FFB03F0, 003C (r1 A_M_I_ OEMMCFG   1000709 MSFT =
      97)
[    0.000000] ACPI: SLIC 7FFB0430, 0176 (r1 NEC              1000709 MSFT =
      97)
[    0.000000] ACPI: OEMB 7FFBE040, 0060 (r1 A_M_I_ AMI_OEM   1000709 MSFT =
      97)
[    0.000000] ACPI: HPET 7FFB7FF0, 0038 (r1 A_M_I_ OEMHPET   1000709 MSFT =
      97)
[    0.000000] ACPI: SSDT 7FFB8030, 0248 (r1 A_M_I_ POWERNOW        1 AMD  =
       1)
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      152
[    0.000000]     0:      256 ->   524208
[    0.000000] ATI board detected. Disabling timer routing over 8254.
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 88000000 (gap: 80000000=
:7f700000)
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 32624 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 516128
[    0.000000] Kernel command line: root=3DLABEL=3DROOT ro vga=3Dextended c=
onsole=3Dtty0 console=3DttyS0,115200
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] TSC calibrated against HPET
[   64.698527] Marking TSC unstable due to TSCs unsynchronized
[   64.698529] time.c: Detected 2405.448 MHz processor.
[   64.717798] Console: colour VGA+ 80x50
[   64.717801] console [tty0] enabled
[   64.722885] console [ttyS0] enabled
[   65.067150] Dentry cache hash table entries: 262144 (order: 9, 2097152 b=
ytes)
[   65.075705] Inode-cache hash table entries: 131072 (order: 8, 1048576 by=
tes)
[   65.083276] Checking aperture...
[   65.086596] CPU 0: aperture @ fede000000 size 32 MB
[   65.091565] Aperture too small (32 MB)
[   65.104495] No AGP bridge found
[   65.123646] Memory: 2057172k/2096832k available (1727k kernel code, 3866=
4k reserved, 832k data, 208k init)
[   65.133447] SLUB: Genslabs=3D11, HWalign=3D64, Order=3D0-1, MinObjects=
=3D4, CPUs=3D2, Nodes=3D1
[   65.200682] Calibrating delay using timer specific routine.. 4813.71 Bog=
oMIPS (lpj=3D2406857)
[   65.209255] Mount-cache hash table entries: 256
[   65.213953] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[   65.221183] CPU: L2 Cache: 512K (64 bytes/line)
[   65.225804] CPU: Physical Processor ID: 0
[   65.229901] CPU: Processor Core ID: 0
[   65.233673] SMP alternatives: switching to UP code
[   65.240501] ACPI: Core revision 20070126
[   65.257607] Using local APIC timer interrupts.
[   65.303873] Detected 12.528 MHz APIC timer.
[   65.308504] SMP alternatives: switching to SMP code
[   65.313735] Booting processor 1/2 APIC 0x1
[   65.328391] Initializing CPU#1
[   65.388759] Calibrating delay using timer specific routine.. 4810.82 Bog=
oMIPS (lpj=3D2405413)
[   65.388765] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[   65.388766] CPU: L2 Cache: 512K (64 bytes/line)
[   65.388768] CPU: Physical Processor ID: 0
[   65.388770] CPU: Processor Core ID: 1
[   65.388833] AMD Athlon(tm) 64 X2 Dual Core Processor 4600+ stepping 02
[   65.388438] Brought up 2 CPUs
[   65.429529] net_namespace: 120 bytes
[   65.434696] NET: Registered protocol family 16
[   65.439321] ACPI: bus type pci registered
[   65.443482] PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
[   65.450006] PCI: Not using MMCONFIG.
[   65.453666] PCI: Using configuration type 1
[   65.465629] ACPI: Interpreter enabled
[   65.469380] ACPI: (supports S0 S5)
[   65.473018] ACPI: Using IOAPIC for interrupt routing
[   65.478330] Error attaching device data
[   65.482257] Error attaching device data
[   65.493960] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   65.519948] PCI: Transparent bridge - 0000:00:14.4
[   65.543144] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 10 11 12 14 15=
) *0, disabled.
[   65.552382] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 10 11 12 14 15=
) *0, disabled.
[   65.563083] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 10 11 12 14 15=
) *0, disabled.
[   65.572305] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 10 11 12 14 15=
) *0, disabled.
[   65.581538] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 10 11 12 14 15=
) *0, disabled.
[   65.590788] ACPI: PCI Interrupt Link [LNKF] (IRQs 9) *0, disabled.
[   65.597553] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 11 12 14 15=
) *0, disabled.
[   65.606785] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 10 11 12 14 15=
) *0, disabled.
[   65.615977] ACPI Warning (tbutils-0217): Incorrect checksum in table [OE=
MB] -  0E, should be 05 [20070126]
[   65.627180] Linux Plug and Play Support v0.97 (c) Adam Belay
[   65.632940] pnp: PnP ACPI init
[   65.636085] ACPI: bus type pnp registered
[   65.643944] pnp: PnP ACPI: found 15 devices
[   65.648223] ACPI: ACPI bus type pnp unregistered
[   65.653012] PCI: Using ACPI for IRQ routing
[   65.657285] PCI: If a device doesn't work, try "pci=3Drouteirq".  If it =
helps, post a report
[   65.669853] DMAR:No DMAR devices found
[   65.673842] Time: hpet clocksource has been installed.
[   65.680913] system 00:06: ioport range 0x4d0-0x4d1 has been reserved
[   65.688638] system 00:06: ioport range 0x40b-0x40b has been reserved
[   65.695080] system 00:06: ioport range 0x4d6-0x4d6 has been reserved
[   65.701527] system 00:06: ioport range 0xc00-0xc01 has been reserved
[   65.707973] system 00:06: ioport range 0xc14-0xc14 has been reserved
[   65.714420] system 00:06: ioport range 0xc50-0xc51 has been reserved
[   65.720865] system 00:06: ioport range 0xc52-0xc52 has been reserved
[   65.727312] system 00:06: ioport range 0xc6c-0xc6c has been reserved
[   65.733758] system 00:06: ioport range 0xc6f-0xc6f has been reserved
[   65.740205] system 00:06: ioport range 0xcd0-0xcd1 has been reserved
[   65.746652] system 00:06: ioport range 0xcd2-0xcd3 has been reserved
[   65.754353] system 00:06: ioport range 0xcd4-0xcd5 has been reserved
[   65.760800] system 00:06: ioport range 0xcd6-0xcd7 has been reserved
[   65.767247] system 00:06: ioport range 0xcd8-0xcdf has been reserved
[   65.773692] system 00:06: ioport range 0x800-0x89f has been reserved
[   65.780138] system 00:06: ioport range 0xb10-0xb1f has been reserved
[   65.786585] system 00:06: ioport range 0x900-0x90f has been reserved
[   65.793033] system 00:06: ioport range 0x910-0x91f has been reserved
[   65.799475] system 00:06: ioport range 0xfe00-0xfefe has been reserved
[   65.806096] system 00:06: iomem range 0xffb80000-0xffbfffff could not be=
 reserved
[   65.813700] system 00:06: iomem range 0xfff00000-0xffffffff could not be=
 reserved
[   65.822524] system 00:06: iomem range 0xff600000-0xff60ffff has been res=
erved
[   65.829759] system 00:09: iomem range 0xfec00000-0xfec00fff has been res=
erved
[   65.836992] system 00:09: iomem range 0xfee00000-0xfee00fff could not be=
 reserved
[   65.844603] system 00:0b: ioport range 0xe00-0xe0f has been reserved
[   65.851047] system 00:0b: ioport range 0xe80-0xe8f has been reserved
[   65.857492] system 00:0b: ioport range 0xf40-0xf4f has been reserved
[   65.863942] system 00:0b: ioport range 0xa30-0xa3f has been reserved
[   65.870390] system 00:0c: iomem range 0xe0000000-0xefffffff has been res=
erved
[   65.877617] system 00:0d: iomem range 0xf0000000-0xf08fffff has been res=
erved
[   65.886130] system 00:0e: iomem range 0x0-0x9ffff could not be reserved
[   65.892845] system 00:0e: iomem range 0xc0000-0xcffff has been reserved
[   65.899554] system 00:0e: iomem range 0xe0000-0xfffff could not be reser=
ved
[   65.906608] system 00:0e: iomem range 0x100000-0x7fffffff could not be r=
eserved
[   65.914035] system 00:0e: iomem range 0x0-0x0 could not be reserved
[   65.920687] PCI: Bridge: 0000:00:04.0
[   65.924440]   IO window: c000-cfff
[   65.927933]   MEM window: fae00000-faefffff
[   65.932210]   PREFETCH window: disabled.
[   65.936224] PCI: Bridge: 0000:00:05.0
[   65.939977]   IO window: d000-dfff
[   65.944741]   MEM window: faf00000-faffffff
[   65.949014]   PREFETCH window: disabled.
[   65.953030] PCI: Bridge: 0000:00:14.4
[   65.956786]   IO window: e000-efff
[   65.960280]   MEM window: fb000000-fbffffff
[   65.964557]   PREFETCH window: f9800000-f9ffffff
[   65.969289] NET: Registered protocol family 2
[   65.983447] IP route cache hash table entries: 65536 (order: 7, 524288 b=
ytes)
[   65.991146] TCP established hash table entries: 262144 (order: 10, 41943=
04 bytes)
[   66.000367] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[   66.008808] TCP: Hash tables configured (established 262144 bind 65536)
[   66.015522] TCP reno registered
[   66.021450] checking if image is initramfs... it is
[   66.222261] Freeing initrd memory: 3541k freed
[   66.229213] audit: initializing netlink socket (disabled)
[   66.234715] audit(1202556795.894:1): initialized
[   66.241291] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 254)
[   66.248835] io scheduler noop registered
[   66.252872] io scheduler deadline registered (default)
[   66.374221] assign_interrupt_mode Found MSI capability
[   66.379547] assign_interrupt_mode Found MSI capability
[   66.406794] Real Time Clock Driver v1.12ac
[   66.411021] Linux agpgart interface v0.102
[   66.415227] Serial: 8250/16550 driver $Revision: 1.90 $ 2 ports, IRQ sha=
ring disabled
[   66.423300] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[   66.429858] 00:0a: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[   66.436053] RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 =
blocksize
[   66.443722] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[   66.450000] PNP: PS/2 appears to have AUX port disabled, if this is inco=
rrect please boot with i8042.nopnp
[   66.459857] serio: i8042 KBD port at 0x60,0x64 irq 1
[   66.464968] mice: PS/2 mouse device common for all mice
[   66.470318] cpuidle: using governor ladder
[   66.474511] cpuidle: using governor menu
[   66.478550] TCP cubic registered
[   66.481981] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[   66.488239] Freeing unused kernel memory: 208k freed
Loading, please wait...

^[^[[   66.513140] input: AT Translated Set 2 keyboard as /devices/platform=
/i8042/serio0/input/input0
Begin: Loading essential drivers... ...
[   66.575266] NET: Registered protocol family 1
Done.
Begin: Running /scripts/init-premount ...
[   66.631328] ACPI: duty_cycle spans bit 4
[   66.772225] SCSI subsystem initialized
[   66.776251] Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
[   66.783020] Copyright (c) 1999-2006 Intel Corporation.
[   66.788456] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -=
> IRQ 16
[   66.844296] e1000: 0000:01:00.0: e1000_check_options: Interrupt Throttli=
ng Rate (ints/sec) set to dynamic conservative mode
[   66.856474] e1000: 0000:01:00.0: e1000_probe: (PCI Express:2.5Gb/s:Width=
 x1) 00:1b:21:04:f5:02
[   66.891985] Floppy drive(s): fd0 is 1.44M
[   66.898775] usbcore: registered new interface driver usbfs
[   66.904582] usbcore: registered new interface driver hub
[   66.910971] FDC 0 is a post-1991 82077
[   66.915627] usbcore: registered new device driver usb
[   66.928261] e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connecti=
on
[   66.935081] ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 21 (level, low) -=
> IRQ 21
[   66.943103] ahci 0000:00:12.0: controller can't do 64bit DMA, forcing 32=
bit
[   66.950374] ahci 0000:00:12.0: controller can't do PMP, turning off CAP_=
PMP
[   67.307246] udev: renamed network interface eth0 to eth1
[   67.956470] ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0x=
f impl SATA mode
[   67.964996] ahci 0000:00:12.0: flags: ncq sntf ilck pm led clo pio slum =
part
[   67.972820] scsi0 : ahci
[   67.975699] scsi1 : ahci
[   67.978445] scsi2 : ahci
[   67.981178] scsi3 : ahci
[   67.983949] ata1: SATA max UDMA/133 abar m1024@0xfadffc00 port 0xfadffd0=
0 irq 509
[   67.991825] ata2: SATA max UDMA/133 abar m1024@0xfadffc00 port 0xfadffd8=
0 irq 509
[   67.999729] ata3: SATA max UDMA/133 abar m1024@0xfadffc00 port 0xfadffe0=
0 irq 509
[   68.007619] ata4: SATA max UDMA/133 abar m1024@0xfadffc00 port 0xfadffe8=
0 irq 509
[   68.470669] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   98.431945] ata1.00: qc timeout (cmd 0xec)
[   98.454907] ata1.00: failed to IDENTIFY (I/O error, err_mask=3D0x4)
[   98.461296] ata1: failed to recover some devices, retrying in 5 secs
[  103.916773] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  133.878045] ata1.00: qc timeout (cmd 0xec)
[  133.882371] ata1.00: failed to IDENTIFY (I/O error, err_mask=3D0x4)
[  133.888797] ata1: failed to recover some devices, retrying in 5 secs
[  139.343901] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  169.305174] ata1.00: qc timeout (cmd 0xec)
[  169.309534] ata1.00: failed to IDENTIFY (I/O error, err_mask=3D0x4)
[  169.315926] ata1: failed to recover some devices, retrying in 5 secs
[  174.771030] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  175.232784] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  205.194064] ata2.00: qc timeout (cmd 0xec)
[  205.198424] ata2.00: failed to IDENTIFY (I/O error, err_mask=3D0x4)
[  205.204834] ata2: failed to recover some devices, retrying in 5 secs
[  210.659913] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  240.621188] ata2.00: qc timeout (cmd 0xec)
[  240.625543] ata2.00: failed to IDENTIFY (I/O error, err_mask=3D0x4)
[  240.631935] ata2: failed to recover some devices, retrying in 5 secs
[  246.087042] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Done.
Begin: Mounting root file system... ...
Begin: Running /scripts/local-top ...
Begin: Loading MD modules ...
[  246.499384] xor: automatically using best checksumming function: generic=
_sse
[  246.511385]    generic_sse:  7332.000 MB/sec
[  246.515867] xor: using function: generic_sse (7332.000 MB/sec)
[  246.522249] async_tx: api initialized (sync-only)
[  246.547341] raid6: int64x1   2187 MB/s
[  246.567319] raid6: int64x2   2863 MB/s
[  246.587285] raid6: int64x4   2679 MB/s
[  246.607266] raid6: int64x8   2359 MB/s
[  246.628217] raid6: sse2x1    3417 MB/s
[  246.648189] raid6: sse2x2    4453 MB/s
[  246.668158] raid6: sse2x4    4605 MB/s
[  246.672126] raid6: using algorithm sse2x4 (4605 MB/s)
[  246.677478] md: raid6 personality registered for level 6
[  246.683066] md: raid5 personality registered for level 5
[  246.688675] md: raid4 personality registered for level 4
Success: loaded module raid456.
Done.
Begin: Assembling all MD arrays ...
mdadm: No devices listed in conf file were found.
Failure: failed to assemble all arrays.
Done.
Begin: Executing udevtrigger again ...
Done.
Done.
Begin: Waiting for root file system... ...
[  276.048325] ata2.00: qc timeout (cmd 0xec)
[  276.052689] ata2.00: failed to IDENTIFY (I/O error, err_mask=3D0x4)
[  276.059068] ata2: failed to recover some devices, retrying in 5 secs
[  281.514182] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  281.975740] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  311.936762] ata3.00: qc timeout (cmd 0xec)
[  311.941123] ata3.00: failed to IDENTIFY (I/O error, err_mask=3D0x4)
[  311.947544] ata3: failed to recover some devices, retrying in 5 secs
[  317.402620] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  347.363902] ata3.00: qc timeout (cmd 0xec)
[  347.368261] ata3.00: failed to IDENTIFY (I/O error, err_mask=3D0x4)
[  347.374662] ata3: failed to recover some devices, retrying in 5 secs
[  352.829756] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  382.791027] ata3.00: qc timeout (cmd 0xec)
[  382.795389] ata3.00: failed to IDENTIFY (I/O error, err_mask=3D0x4)
[  382.801766] ata3: failed to recover some devices, retrying in 5 secs
[  388.256887] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  388.718190] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  418.679474] ata4.00: qc timeout (cmd 0xec)
[  418.683838] ata4.00: failed to IDENTIFY (I/O error, err_mask=3D0x4)
[  418.690243] ata4: failed to recover some devices, retrying in 5 secs
[  424.145329] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Done.
ALERT!  /dev/disk/by-label/ROOT does not exist.  Dropping to a shell!
	Check your root=3D boot argument (cat /proc/cmdline)
Check for missing modules (cat /proc/modules), or device files (ls /dev)


BusyBox v1.1.3 (Debian 1:1.1.3-5) Built-in shell (ash)
Enter 'help' for a list of built-in commands.

/bin/sh: can't access tty; job control turned off
(initramfs) [  454.106607] ata4.00: qc timeout (cmd 0xec)
[  454.110965] ata4.00: failed to IDENTIFY (I/O error, err_mask=3D0x4)
[  454.117416] ata4: failed to recover some devices, retrying in 5 secs
[  459.572452] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  489.538076] ata4.00: failed to IDENTIFY (I/O error, err_mask=3D0x4)
[  489.544474] ata4: failed to recover some devices, retrying in 5 secs
[  494.999579] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  495.005723] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 17 (level, low) -=
> IRQ 17

After pressing Ctrl+d:

(initramfs) [  496.012632] ahci 0000:02:00.0: AHCI 0001.0000 32 slots 1 por=
ts 3 Gbps 0x1 impl SATA mode
[  496.021143] ahci 0000:02:00.0: flags: 64bit ncq pm led clo pmp pio slum =
part
[  496.028696] scsi4 : ahci
[  496.031469] ata5: SATA max UDMA/133 abar m8192@0xfaffe000 port 0xfaffe10=
0 irq 17
[  496.343573] ata5: SATA link down (SStatus 0 SControl 300)
[  496.349201] ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, low) -=
> IRQ 16
[  496.357258] scsi5 : pata_atiixp
[  496.361114] scsi6 : pata_atiixp
[  496.365577] ata6: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq=
 14
[  496.372877] ata7: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq=
 15
[  496.553906] ata6.00: ATA-6: IC35L120AVV207-0, V24OA66A, max UDMA/100
[  496.560570] ata6.00: 241254720 sectors, multi 16: LBA48
[  496.575833] ata6.00: configured for UDMA/100
[  496.730650] scsi 5:0:0:0: Direct-Access     ATA      IC35L120AVV207-0 V2=
4O PQ: 0 ANSI: 5
[  496.739714] ACPI: PCI Interrupt 0000:03:04.0[A] -> <6>ACPI: PCI Interrup=
t 0000:00:13.5[D] -> GSI 19 (level, low) -> IRQ 19
[  496.751453] GSI 23 (level, low) -> IRQ 23
[  496.751051] ehci_hcd 0000:00:13.5: EHCI Host Controller
[  496.751228] ehci_hcd 0000:00:13.5: new USB bus registered, assigned bus =
number 1
[  496.751292] ehci_hcd 0000:00:13.5: debug port 1
[  496.751304] ehci_hcd 0000:00:13.5: irq 19, io mem 0xfadff800
[  496.779858] skge 1.13 addr 0xfbff4000 irq 23 chip Yukon-Lite rev 9
[  496.779521] ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00, driver 10=
 Dec 2004
[  496.779620] usb usb1: configuration #1 chosen from 1 choice
[  496.779638] hub 1-0:1.0: USB hub found
[  496.779645] hub 1-0:1.0: 10 ports detected
[  496.808602] skge eth0: addr 00:1b:fc:68:3c:19
[  496.812824] Driver 'sd' needs updating - please use bus_type methods
[  496.819580] sd 5:0:0:0: [sda] 241254720 512-byte hardware sectors (12352=
2 MB)
[  496.827071] sd 5:0:0:0: [sda] Write Protect is off
[  496.832158] sd 5:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[  496.841697] sd 5:0:0:0: [sda] 241254720 512-byte hardware sectors (12352=
2 MB)
[  496.849236] sd 5:0:0:0: [sda] Write Protect is off
[  496.854331] sd 5:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[  496.863837]  sda:<6>ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 16 (level=
, low) -> IRQ 16
[  496.886372] ohci_hcd 0000:00:13.0: OHCI Host Controller
[  496.891939] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus =
number 2
[  496.894907]  sda1 sda2 < sda5<6>ohci_hcd 0000:00:13.0: irq 16, io mem 0x=
fadfe000
[  496.908266]  sda6 sda7 sda8 >
[  496.934106] sd 5:0:0:0: [sda] Attached SCSI disk
[  496.963310] usb usb2: configuration #1 chosen from 1 choice
[  496.969160] hub 2-0:1.0: USB hub found
[  496.973181] hub 2-0:1.0: 2 ports detected
[  497.078118] ACPI: PCI Interrupt 0000:00:13.1[B] -> GSI 17 (level, low) -=
> IRQ 17
[  497.086121] ohci_hcd 0000:00:13.1: OHCI Host Controller
[  497.091695] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus =
number 3
[  497.099462] ohci_hcd 0000:00:13.1: irq 17, io mem 0xfadfd000
[  497.160009] usb usb3: configuration #1 chosen from 1 choice
[  497.165872] hub 3-0:1.0: USB hub found
[  497.169888] hub 3-0:1.0: 2 ports detected
[  497.274808] ACPI: PCI Interrupt 0000:00:13.2[C] -> GSI 18 (level, low) -=
> IRQ 18
[  497.282831] ohci_hcd 0000:00:13.2: OHCI Host Controller
[  497.288412] ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus =
number 4
[  497.296219] ohci_hcd 0000:00:13.2: irq 18, io mem 0xfadfc000
[  497.356703] usb usb4: configuration #1 chosen from 1 choice
[  497.362612] hub 4-0:1.0: USB hub found
[  497.366595] hub 4-0:1.0: 2 ports detected
[  497.471530] ACPI: PCI Interrupt 0000:00:13.3[B] -> GSI 17 (level, low) -=
> IRQ 17
[  497.479528] ohci_hcd 0000:00:13.3: OHCI Host Controller
[  497.485119] ohci_hcd 0000:00:13.3: new USB bus registered, assigned bus =
number 5
[  497.492927] ohci_hcd 0000:00:13.3: irq 17, io mem 0xfadf7000
[  497.554399] usb usb5: configuration #1 chosen from 1 choice
[  497.560310] hub 5-0:1.0: USB hub found
[  497.564309] hub 5-0:1.0: 2 ports detected
[  497.669207] ACPI: PCI Interrupt 0000:00:13.4[C] -> GSI 18 (level, low) -=
> IRQ 18
[  497.677188] ohci_hcd 0000:00:13.4: OHCI Host Controller
[  497.682736] ohci_hcd 0000:00:13.4: new USB bus registered, assigned bus =
number 6
[  497.690554] ohci_hcd 0000:00:13.4: irq 18, io mem 0xfadf6000
[  497.751118] usb usb6: configuration #1 chosen from 1 choice
[  497.775596] hub 6-0:1.0: USB hub found
[  497.779546] hub 6-0:1.0: 2 ports detected

(initramfs) Begin: Running /scripts/local-premount ...
Done.
[  519.925022] kjournald starting.  Commit interval 5 seconds
Begin: Running /[  519.925472] EXT3-fs: mounted filesystem with ordered dat=
a mode.
scripts/local-bottom ...
Done.
Done.
Begin: Running /scripts/init-bottom ...
Done.
Mount failed for selinuxfs on /selinux:  No such file or directory
INIT: version 2.86 booting
/etc/rcS.d/S00clear_glcd: line 3: /usr/local/bin/showtext: No such file or =
directory
Setting hostname to 'hades'...done.
* Files under mount point '/lib/init/rw' will be hidden.
Starting the hotplug events dispatcher: udevd.
Synthesizing the initial hotplug events...done.
Waiting for /dev to be fully populated...[  522.800446] input: Power Button=
 (FF) as /devices/virtual/input/input1
[  522.812370] ACPI: Power Button (FF) [PWRF]
[  522.816811] input: Power Button (CM) as /devices/virtual/input/input2
[  522.829340] ACPI: Power Button (CM) [PWRB]
[  522.912153] input: PC Speaker as /devices/platform/pcspkr/input/input3
[  523.277893] ACPI: PCI Interrupt 0000:00:14.2[A] -> GSI 16 (level, low) -=
> IRQ 16
[  523.358550] hda_codec: Unknown model for AD1988, trying auto-probe from =
BIOS...
done.
Setting parameters of disc: (none).
Setting the system clock.
System Clock set to: Sat Feb  9 11:40:56 UTC 2008.
Activating swap:swapon on /dev/s[  524.985605] Unable to find swap-space si=
gnature
da2
swapon: /dev/sda2: Invalid argument
swapon: cannot canonicalize /dev/sdb2: No such file or directory
swapon on /dev/sdb2
swapon: cannot stat /dev/sdb2: No such file or directory
swapon: cannot canonicalize /dev/sdc2: No such file or directory
swapon on /dev/sdc2
swapon: cannot stat /dev/sdc2: No such file or directory
swapon: cannot canonicalize /dev/sde7: No such file or directory
swapon on /dev/sde7
swapon: cannot stat /dev/sde7: No such file or directory
 failed!
Will now check root file system:fsck 1.40.5 (27-Jan-2008)
[/sbin/fsck.ext3 (1) -- /] fsck.ext3 -y -C0 /dev/sda5
e2fsck 1.40.5 (27-Jan-2008)
ROOT: clean, 144797/610432 files, 749592/1220932 blocks
.
[  525.289726] EXT3 FS on sda5, internal journal
Setting the system clock.
System Clock set to: Sat Feb  9 11:40:57 UTC 2008.
Cleaning up ifupdown....
Loading kernel module ppdev.
[  525.827503] ppdev: user-space parallel port driver
Loading kernel module k8temp.
Loading kernel module fuse.
[  525.877267] fuse init (API version 7.9)
Loading kernel module tun.
[  525.890020] tun: Universal TUN/TAP device driver, 1.6
[  525.895353] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Loading kernel module i2c-viapro.
Loading kernel module eeprom.
Loading kernel module k8temp.
Loading kernel module w83627hf.
FATAL: Error inserting w83627hf (/lib/modules/2.6.24.1/kernel/drivers/hwmon=
/w83627hf.ko): No such device
Loading kernel module powernow-k8.
[  525.944988] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processo=
r 4600+ processors (2 cpu cores) (version 2.20.00)
[  525.957316] powernow-k8:    0 : fid 0x10 (2400 MHz), vid 0xc
[  525.963284] powernow-k8:    1 : fid 0xe (2200 MHz), vid 0xe
[  525.969159] powernow-k8:    2 : fid 0xc (2000 MHz), vid 0x10
[  525.975119] powernow-k8:    3 : fid 0xa (1800 MHz), vid 0x10
[  525.981038] powernow-k8:    4 : fid 0x2 (1000 MHz), vid 0x12
Loading kernel module cpufreq-ondemand.
Loading kernel module kqemu.
[  526.267753] md: md0 stopped.
Assembling MD array md0...failed (no devices found).
Generating udev events for MD arrays...done.
Will now check all file systems.
fsck 1.40.5 (27-Jan-2008)
Checking all file systems.
[/sbin/fsck.ext3 (1) -- /files] fsck.ext3 -y -C0 LABEL=3DFILES
fsck.ext3: Unable to resolve 'LABEL=3DFILES'
[/sbin/fsck.ext3 (1) -- /boot] fsck.ext3 -y -C0 /dev/sda1
e2fsck 1.40.5 (27-Jan-2008)
BOOT: clean, 5780/48192 files, 24940/96358 blocks
[/sbin/fsck.ext3 (1) -- /var] fsck.ext3 -y -C0 /dev/sda6
e2fsck 1.40.5 (27-Jan-2008)
VAR: clean, 6410/611648 files, 191188/1220932 blocks
[/sbin/fsck.ext3 (1) -- /home] fsck.ext3 -y -C0 /dev/sda8
e2fsck 1.40.5 (27-Jan-2008)
HOME: clean, 120009/13615104 files, 9138673/27202053 blocks
fsck died with exit status 8
* File system check failed.
A log is being saved in /var/log/fsck/checkfs if that location is writable.
Please repair the file system manually.
* A maintenance shell will now be started.
CONTROL-D will terminate this shell and resume system boot.
Give root password for maintenance
(or type Control-D to continue):


--MP_/Vd/D6xBF56+nJrKUKI5XFXp
Content-Type: text/plain; name=config-2.6.24.1
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=config-2.6.24.1

Iw0KIyBBdXRvbWF0aWNhbGx5IGdlbmVyYXRlZCBtYWtlIGNvbmZpZzogZG9uJ3QgZWRpdA0KIyBM
aW51eCBrZXJuZWwgdmVyc2lvbjogMi42LjI0LjENCiMgU2F0IEZlYiAgOSAxMTowNTo0NyAyMDA4
DQojDQpDT05GSUdfNjRCSVQ9eQ0KIyBDT05GSUdfWDg2XzMyIGlzIG5vdCBzZXQNCkNPTkZJR19Y
ODZfNjQ9eQ0KQ09ORklHX1g4Nj15DQpDT05GSUdfR0VORVJJQ19USU1FPXkNCkNPTkZJR19HRU5F
UklDX0NNT1NfVVBEQVRFPXkNCkNPTkZJR19DTE9DS1NPVVJDRV9XQVRDSERPRz15DQpDT05GSUdf
R0VORVJJQ19DTE9DS0VWRU5UUz15DQpDT05GSUdfR0VORVJJQ19DTE9DS0VWRU5UU19CUk9BRENB
U1Q9eQ0KQ09ORklHX0xPQ0tERVBfU1VQUE9SVD15DQpDT05GSUdfU1RBQ0tUUkFDRV9TVVBQT1JU
PXkNCkNPTkZJR19TRU1BUEhPUkVfU0xFRVBFUlM9eQ0KQ09ORklHX01NVT15DQpDT05GSUdfWk9O
RV9ETUE9eQ0KIyBDT05GSUdfUVVJQ0tMSVNUIGlzIG5vdCBzZXQNCkNPTkZJR19HRU5FUklDX0lT
QV9ETUE9eQ0KQ09ORklHX0dFTkVSSUNfSU9NQVA9eQ0KQ09ORklHX0dFTkVSSUNfQlVHPXkNCkNP
TkZJR19HRU5FUklDX0hXRUlHSFQ9eQ0KQ09ORklHX0FSQ0hfTUFZX0hBVkVfUENfRkRDPXkNCkNP
TkZJR19ETUk9eQ0KQ09ORklHX1JXU0VNX0dFTkVSSUNfU1BJTkxPQ0s9eQ0KIyBDT05GSUdfUldT
RU1fWENIR0FERF9BTEdPUklUSE0gaXMgbm90IHNldA0KIyBDT05GSUdfQVJDSF9IQVNfSUxPRzJf
VTMyIGlzIG5vdCBzZXQNCiMgQ09ORklHX0FSQ0hfSEFTX0lMT0cyX1U2NCBpcyBub3Qgc2V0DQpD
T05GSUdfR0VORVJJQ19DQUxJQlJBVEVfREVMQVk9eQ0KQ09ORklHX0dFTkVSSUNfVElNRV9WU1lT
Q0FMTD15DQpDT05GSUdfQVJDSF9TVVBQT1JUU19PUFJPRklMRT15DQpDT05GSUdfWk9ORV9ETUEz
Mj15DQpDT05GSUdfQVJDSF9QT1BVTEFURVNfTk9ERV9NQVA9eQ0KQ09ORklHX0FVRElUX0FSQ0g9
eQ0KQ09ORklHX0dFTkVSSUNfSEFSRElSUVM9eQ0KQ09ORklHX0dFTkVSSUNfSVJRX1BST0JFPXkN
CkNPTkZJR19HRU5FUklDX1BFTkRJTkdfSVJRPXkNCiMgQ09ORklHX0tUSU1FX1NDQUxBUiBpcyBu
b3Qgc2V0DQpDT05GSUdfREVGQ09ORklHX0xJU1Q9Ii9saWIvbW9kdWxlcy8kVU5BTUVfUkVMRUFT
RS8uY29uZmlnIg0KDQojDQojIEdlbmVyYWwgc2V0dXANCiMNCkNPTkZJR19FWFBFUklNRU5UQUw9
eQ0KQ09ORklHX0xPQ0tfS0VSTkVMPXkNCkNPTkZJR19JTklUX0VOVl9BUkdfTElNSVQ9MzINCkNP
TkZJR19MT0NBTFZFUlNJT049IiINCkNPTkZJR19MT0NBTFZFUlNJT05fQVVUTz15DQpDT05GSUdf
U1dBUD15DQpDT05GSUdfU1lTVklQQz15DQpDT05GSUdfU1lTVklQQ19TWVNDVEw9eQ0KQ09ORklH
X1BPU0lYX01RVUVVRT15DQojIENPTkZJR19CU0RfUFJPQ0VTU19BQ0NUIGlzIG5vdCBzZXQNCiMg
Q09ORklHX1RBU0tTVEFUUyBpcyBub3Qgc2V0DQojIENPTkZJR19VU0VSX05TIGlzIG5vdCBzZXQN
CiMgQ09ORklHX1BJRF9OUyBpcyBub3Qgc2V0DQpDT05GSUdfQVVESVQ9eQ0KIyBDT05GSUdfQVVE
SVRTWVNDQUxMIGlzIG5vdCBzZXQNCkNPTkZJR19JS0NPTkZJRz15DQpDT05GSUdfSUtDT05GSUdf
UFJPQz15DQpDT05GSUdfTE9HX0JVRl9TSElGVD0xNQ0KIyBDT05GSUdfQ0dST1VQUyBpcyBub3Qg
c2V0DQojIENPTkZJR19GQUlSX0dST1VQX1NDSEVEIGlzIG5vdCBzZXQNCiMgQ09ORklHX1NZU0ZT
X0RFUFJFQ0FURUQgaXMgbm90IHNldA0KQ09ORklHX1JFTEFZPXkNCkNPTkZJR19CTEtfREVWX0lO
SVRSRD15DQpDT05GSUdfSU5JVFJBTUZTX1NPVVJDRT0iIg0KQ09ORklHX0NDX09QVElNSVpFX0ZP
Ul9TSVpFPXkNCkNPTkZJR19TWVNDVEw9eQ0KIyBDT05GSUdfRU1CRURERUQgaXMgbm90IHNldA0K
Q09ORklHX1VJRDE2PXkNCkNPTkZJR19TWVNDVExfU1lTQ0FMTD15DQpDT05GSUdfS0FMTFNZTVM9
eQ0KIyBDT05GSUdfS0FMTFNZTVNfRVhUUkFfUEFTUyBpcyBub3Qgc2V0DQpDT05GSUdfSE9UUExV
Rz15DQpDT05GSUdfUFJJTlRLPXkNCkNPTkZJR19CVUc9eQ0KQ09ORklHX0VMRl9DT1JFPXkNCkNP
TkZJR19CQVNFX0ZVTEw9eQ0KQ09ORklHX0ZVVEVYPXkNCkNPTkZJR19BTk9OX0lOT0RFUz15DQpD
T05GSUdfRVBPTEw9eQ0KQ09ORklHX1NJR05BTEZEPXkNCkNPTkZJR19FVkVOVEZEPXkNCkNPTkZJ
R19TSE1FTT15DQpDT05GSUdfVk1fRVZFTlRfQ09VTlRFUlM9eQ0KQ09ORklHX1NMVUJfREVCVUc9
eQ0KIyBDT05GSUdfU0xBQiBpcyBub3Qgc2V0DQpDT05GSUdfU0xVQj15DQojIENPTkZJR19TTE9C
IGlzIG5vdCBzZXQNCkNPTkZJR19TTEFCSU5GTz15DQpDT05GSUdfUlRfTVVURVhFUz15DQojIENP
TkZJR19USU5ZX1NITUVNIGlzIG5vdCBzZXQNCkNPTkZJR19CQVNFX1NNQUxMPTANCkNPTkZJR19N
T0RVTEVTPXkNCkNPTkZJR19NT0RVTEVfVU5MT0FEPXkNCkNPTkZJR19NT0RVTEVfRk9SQ0VfVU5M
T0FEPXkNCkNPTkZJR19NT0RWRVJTSU9OUz15DQojIENPTkZJR19NT0RVTEVfU1JDVkVSU0lPTl9B
TEwgaXMgbm90IHNldA0KQ09ORklHX0tNT0Q9eQ0KQ09ORklHX1NUT1BfTUFDSElORT15DQpDT05G
SUdfQkxPQ0s9eQ0KIyBDT05GSUdfQkxLX0RFVl9JT19UUkFDRSBpcyBub3Qgc2V0DQpDT05GSUdf
QkxLX0RFVl9CU0c9eQ0KQ09ORklHX0JMT0NLX0NPTVBBVD15DQoNCiMNCiMgSU8gU2NoZWR1bGVy
cw0KIw0KQ09ORklHX0lPU0NIRURfTk9PUD15DQojIENPTkZJR19JT1NDSEVEX0FTIGlzIG5vdCBz
ZXQNCkNPTkZJR19JT1NDSEVEX0RFQURMSU5FPXkNCiMgQ09ORklHX0lPU0NIRURfQ0ZRIGlzIG5v
dCBzZXQNCiMgQ09ORklHX0RFRkFVTFRfQVMgaXMgbm90IHNldA0KQ09ORklHX0RFRkFVTFRfREVB
RExJTkU9eQ0KIyBDT05GSUdfREVGQVVMVF9DRlEgaXMgbm90IHNldA0KIyBDT05GSUdfREVGQVVM
VF9OT09QIGlzIG5vdCBzZXQNCkNPTkZJR19ERUZBVUxUX0lPU0NIRUQ9ImRlYWRsaW5lIg0KQ09O
RklHX1BSRUVNUFRfTk9USUZJRVJTPXkNCg0KIw0KIyBQcm9jZXNzb3IgdHlwZSBhbmQgZmVhdHVy
ZXMNCiMNCkNPTkZJR19USUNLX09ORVNIT1Q9eQ0KQ09ORklHX05PX0haPXkNCkNPTkZJR19ISUdI
X1JFU19USU1FUlM9eQ0KQ09ORklHX0dFTkVSSUNfQ0xPQ0tFVkVOVFNfQlVJTEQ9eQ0KQ09ORklH
X1NNUD15DQpDT05GSUdfWDg2X1BDPXkNCiMgQ09ORklHX1g4Nl9FTEFOIGlzIG5vdCBzZXQNCiMg
Q09ORklHX1g4Nl9WT1lBR0VSIGlzIG5vdCBzZXQNCiMgQ09ORklHX1g4Nl9OVU1BUSBpcyBub3Qg
c2V0DQojIENPTkZJR19YODZfU1VNTUlUIGlzIG5vdCBzZXQNCiMgQ09ORklHX1g4Nl9CSUdTTVAg
aXMgbm90IHNldA0KIyBDT05GSUdfWDg2X1ZJU1dTIGlzIG5vdCBzZXQNCiMgQ09ORklHX1g4Nl9H
RU5FUklDQVJDSCBpcyBub3Qgc2V0DQojIENPTkZJR19YODZfRVM3MDAwIGlzIG5vdCBzZXQNCiMg
Q09ORklHX1g4Nl9WU01QIGlzIG5vdCBzZXQNCiMgQ09ORklHX00zODYgaXMgbm90IHNldA0KIyBD
T05GSUdfTTQ4NiBpcyBub3Qgc2V0DQojIENPTkZJR19NNTg2IGlzIG5vdCBzZXQNCiMgQ09ORklH
X001ODZUU0MgaXMgbm90IHNldA0KIyBDT05GSUdfTTU4Nk1NWCBpcyBub3Qgc2V0DQojIENPTkZJ
R19NNjg2IGlzIG5vdCBzZXQNCiMgQ09ORklHX01QRU5USVVNSUkgaXMgbm90IHNldA0KIyBDT05G
SUdfTVBFTlRJVU1JSUkgaXMgbm90IHNldA0KIyBDT05GSUdfTVBFTlRJVU1NIGlzIG5vdCBzZXQN
CiMgQ09ORklHX01QRU5USVVNNCBpcyBub3Qgc2V0DQojIENPTkZJR19NSzYgaXMgbm90IHNldA0K
IyBDT05GSUdfTUs3IGlzIG5vdCBzZXQNCkNPTkZJR19NSzg9eQ0KIyBDT05GSUdfTUNSVVNPRSBp
cyBub3Qgc2V0DQojIENPTkZJR19NRUZGSUNFT04gaXMgbm90IHNldA0KIyBDT05GSUdfTVdJTkNI
SVBDNiBpcyBub3Qgc2V0DQojIENPTkZJR19NV0lOQ0hJUDIgaXMgbm90IHNldA0KIyBDT05GSUdf
TVdJTkNISVAzRCBpcyBub3Qgc2V0DQojIENPTkZJR19NR0VPREVHWDEgaXMgbm90IHNldA0KIyBD
T05GSUdfTUdFT0RFX0xYIGlzIG5vdCBzZXQNCiMgQ09ORklHX01DWVJJWElJSSBpcyBub3Qgc2V0
DQojIENPTkZJR19NVklBQzNfMiBpcyBub3Qgc2V0DQojIENPTkZJR19NVklBQzcgaXMgbm90IHNl
dA0KIyBDT05GSUdfTVBTQyBpcyBub3Qgc2V0DQojIENPTkZJR19NQ09SRTIgaXMgbm90IHNldA0K
IyBDT05GSUdfR0VORVJJQ19DUFUgaXMgbm90IHNldA0KQ09ORklHX1g4Nl9MMV9DQUNIRV9CWVRF
Uz02NA0KQ09ORklHX1g4Nl9JTlRFUk5PREVfQ0FDSEVfQllURVM9NjQNCkNPTkZJR19YODZfQ01Q
WENIRz15DQpDT05GSUdfWDg2X0wxX0NBQ0hFX1NISUZUPTYNCkNPTkZJR19YODZfR09PRF9BUElD
PXkNCkNPTkZJR19YODZfSU5URUxfVVNFUkNPUFk9eQ0KQ09ORklHX1g4Nl9VU0VfUFBST19DSEVD
S1NVTT15DQpDT05GSUdfWDg2X1RTQz15DQpDT05GSUdfWDg2X01JTklNVU1fQ1BVX0ZBTUlMWT02
NA0KQ09ORklHX0hQRVRfVElNRVI9eQ0KQ09ORklHX0hQRVRfRU1VTEFURV9SVEM9eQ0KQ09ORklH
X0dBUlRfSU9NTVU9eQ0KQ09ORklHX0NBTEdBUllfSU9NTVU9eQ0KQ09ORklHX0NBTEdBUllfSU9N
TVVfRU5BQkxFRF9CWV9ERUZBVUxUPXkNCkNPTkZJR19TV0lPVExCPXkNCkNPTkZJR19OUl9DUFVT
PTgNCiMgQ09ORklHX1NDSEVEX1NNVCBpcyBub3Qgc2V0DQpDT05GSUdfU0NIRURfTUM9eQ0KIyBD
T05GSUdfUFJFRU1QVF9OT05FIGlzIG5vdCBzZXQNCkNPTkZJR19QUkVFTVBUX1ZPTFVOVEFSWT15
DQojIENPTkZJR19QUkVFTVBUIGlzIG5vdCBzZXQNCiMgQ09ORklHX1BSRUVNUFRfQktMIGlzIG5v
dCBzZXQNCkNPTkZJR19YODZfTE9DQUxfQVBJQz15DQpDT05GSUdfWDg2X0lPX0FQSUM9eQ0KQ09O
RklHX1g4Nl9NQ0U9eQ0KIyBDT05GSUdfWDg2X01DRV9JTlRFTCBpcyBub3Qgc2V0DQpDT05GSUdf
WDg2X01DRV9BTUQ9eQ0KIyBDT05GSUdfTUlDUk9DT0RFIGlzIG5vdCBzZXQNCkNPTkZJR19YODZf
TVNSPXkNCkNPTkZJR19YODZfQ1BVSUQ9eQ0KIyBDT05GSUdfTlVNQSBpcyBub3Qgc2V0DQpDT05G
SUdfQVJDSF9GTEFUTUVNX0VOQUJMRT15DQpDT05GSUdfQVJDSF9TUEFSU0VNRU1fRU5BQkxFPXkN
CkNPTkZJR19TRUxFQ1RfTUVNT1JZX01PREVMPXkNCkNPTkZJR19GTEFUTUVNX01BTlVBTD15DQoj
IENPTkZJR19ESVNDT05USUdNRU1fTUFOVUFMIGlzIG5vdCBzZXQNCiMgQ09ORklHX1NQQVJTRU1F
TV9NQU5VQUwgaXMgbm90IHNldA0KQ09ORklHX0ZMQVRNRU09eQ0KQ09ORklHX0ZMQVRfTk9ERV9N
RU1fTUFQPXkNCiMgQ09ORklHX1NQQVJTRU1FTV9TVEFUSUMgaXMgbm90IHNldA0KQ09ORklHX1NQ
QVJTRU1FTV9WTUVNTUFQX0VOQUJMRT15DQpDT05GSUdfU1BMSVRfUFRMT0NLX0NQVVM9NA0KQ09O
RklHX1JFU09VUkNFU182NEJJVD15DQpDT05GSUdfWk9ORV9ETUFfRkxBRz0xDQpDT05GSUdfQk9V
TkNFPXkNCkNPTkZJR19WSVJUX1RPX0JVUz15DQpDT05GSUdfTVRSUj15DQpDT05GSUdfU0VDQ09N
UD15DQojIENPTkZJR19DQ19TVEFDS1BST1RFQ1RPUiBpcyBub3Qgc2V0DQojIENPTkZJR19IWl8x
MDAgaXMgbm90IHNldA0KIyBDT05GSUdfSFpfMjUwIGlzIG5vdCBzZXQNCiMgQ09ORklHX0haXzMw
MCBpcyBub3Qgc2V0DQpDT05GSUdfSFpfMTAwMD15DQpDT05GSUdfSFo9MTAwMA0KQ09ORklHX0tF
WEVDPXkNCkNPTkZJR19DUkFTSF9EVU1QPXkNCkNPTkZJR19QSFlTSUNBTF9TVEFSVD0weDIwMDAw
MA0KIyBDT05GSUdfUkVMT0NBVEFCTEUgaXMgbm90IHNldA0KQ09ORklHX1BIWVNJQ0FMX0FMSUdO
PTB4MjAwMDAwDQpDT05GSUdfSE9UUExVR19DUFU9eQ0KQ09ORklHX0FSQ0hfRU5BQkxFX01FTU9S
WV9IT1RQTFVHPXkNCg0KIw0KIyBQb3dlciBtYW5hZ2VtZW50IG9wdGlvbnMNCiMNCkNPTkZJR19Q
TT15DQojIENPTkZJR19QTV9MRUdBQ1kgaXMgbm90IHNldA0KIyBDT05GSUdfUE1fREVCVUcgaXMg
bm90IHNldA0KQ09ORklHX1NVU1BFTkRfU01QX1BPU1NJQkxFPXkNCiMgQ09ORklHX1NVU1BFTkQg
aXMgbm90IHNldA0KQ09ORklHX0hJQkVSTkFUSU9OX1NNUF9QT1NTSUJMRT15DQojIENPTkZJR19I
SUJFUk5BVElPTiBpcyBub3Qgc2V0DQpDT05GSUdfQUNQST15DQpDT05GSUdfQUNQSV9QUk9DRlM9
eQ0KQ09ORklHX0FDUElfUFJPQ0ZTX1BPV0VSPXkNCkNPTkZJR19BQ1BJX1NZU0ZTX1BPV0VSPXkN
CkNPTkZJR19BQ1BJX1BST0NfRVZFTlQ9eQ0KQ09ORklHX0FDUElfQUM9bQ0KQ09ORklHX0FDUElf
QkFUVEVSWT1tDQpDT05GSUdfQUNQSV9CVVRUT049bQ0KQ09ORklHX0FDUElfVklERU89bQ0KQ09O
RklHX0FDUElfRkFOPW0NCiMgQ09ORklHX0FDUElfRE9DSyBpcyBub3Qgc2V0DQpDT05GSUdfQUNQ
SV9QUk9DRVNTT1I9bQ0KQ09ORklHX0FDUElfSE9UUExVR19DUFU9eQ0KQ09ORklHX0FDUElfVEhF
Uk1BTD1tDQojIENPTkZJR19BQ1BJX0FTVVMgaXMgbm90IHNldA0KIyBDT05GSUdfQUNQSV9UT1NI
SUJBIGlzIG5vdCBzZXQNCkNPTkZJR19BQ1BJX0JMQUNLTElTVF9ZRUFSPTANCiMgQ09ORklHX0FD
UElfREVCVUcgaXMgbm90IHNldA0KQ09ORklHX0FDUElfRUM9eQ0KQ09ORklHX0FDUElfUE9XRVI9
eQ0KQ09ORklHX0FDUElfU1lTVEVNPXkNCkNPTkZJR19YODZfUE1fVElNRVI9eQ0KQ09ORklHX0FD
UElfQ09OVEFJTkVSPW0NCiMgQ09ORklHX0FDUElfU0JTIGlzIG5vdCBzZXQNCg0KIw0KIyBDUFUg
RnJlcXVlbmN5IHNjYWxpbmcNCiMNCkNPTkZJR19DUFVfRlJFUT15DQpDT05GSUdfQ1BVX0ZSRVFf
VEFCTEU9eQ0KIyBDT05GSUdfQ1BVX0ZSRVFfREVCVUcgaXMgbm90IHNldA0KQ09ORklHX0NQVV9G
UkVRX1NUQVQ9eQ0KIyBDT05GSUdfQ1BVX0ZSRVFfU1RBVF9ERVRBSUxTIGlzIG5vdCBzZXQNCkNP
TkZJR19DUFVfRlJFUV9ERUZBVUxUX0dPVl9QRVJGT1JNQU5DRT15DQojIENPTkZJR19DUFVfRlJF
UV9ERUZBVUxUX0dPVl9VU0VSU1BBQ0UgaXMgbm90IHNldA0KIyBDT05GSUdfQ1BVX0ZSRVFfREVG
QVVMVF9HT1ZfT05ERU1BTkQgaXMgbm90IHNldA0KIyBDT05GSUdfQ1BVX0ZSRVFfREVGQVVMVF9H
T1ZfQ09OU0VSVkFUSVZFIGlzIG5vdCBzZXQNCkNPTkZJR19DUFVfRlJFUV9HT1ZfUEVSRk9STUFO
Q0U9eQ0KQ09ORklHX0NQVV9GUkVRX0dPVl9QT1dFUlNBVkU9bQ0KQ09ORklHX0NQVV9GUkVRX0dP
Vl9VU0VSU1BBQ0U9bQ0KQ09ORklHX0NQVV9GUkVRX0dPVl9PTkRFTUFORD1tDQpDT05GSUdfQ1BV
X0ZSRVFfR09WX0NPTlNFUlZBVElWRT1tDQoNCiMNCiMgQ1BVRnJlcSBwcm9jZXNzb3IgZHJpdmVy
cw0KIw0KIyBDT05GSUdfWDg2X0FDUElfQ1BVRlJFUSBpcyBub3Qgc2V0DQpDT05GSUdfWDg2X1BP
V0VSTk9XX0s4PW0NCkNPTkZJR19YODZfUE9XRVJOT1dfSzhfQUNQST15DQojIENPTkZJR19YODZf
U1BFRURTVEVQX0NFTlRSSU5PIGlzIG5vdCBzZXQNCiMgQ09ORklHX1g4Nl9QNF9DTE9DS01PRCBp
cyBub3Qgc2V0DQoNCiMNCiMgc2hhcmVkIG9wdGlvbnMNCiMNCiMgQ09ORklHX1g4Nl9BQ1BJX0NQ
VUZSRVFfUFJPQ19JTlRGIGlzIG5vdCBzZXQNCiMgQ09ORklHX1g4Nl9TUEVFRFNURVBfTElCIGlz
IG5vdCBzZXQNCkNPTkZJR19DUFVfSURMRT15DQpDT05GSUdfQ1BVX0lETEVfR09WX0xBRERFUj15
DQpDT05GSUdfQ1BVX0lETEVfR09WX01FTlU9eQ0KDQojDQojIEJ1cyBvcHRpb25zIChQQ0kgZXRj
LikNCiMNCkNPTkZJR19QQ0k9eQ0KQ09ORklHX1BDSV9ESVJFQ1Q9eQ0KQ09ORklHX1BDSV9NTUNP
TkZJRz15DQpDT05GSUdfUENJX0RPTUFJTlM9eQ0KQ09ORklHX0RNQVI9eQ0KQ09ORklHX0RNQVJf
R0ZYX1dBPXkNCkNPTkZJR19ETUFSX0ZMT1BQWV9XQT15DQpDT05GSUdfUENJRVBPUlRCVVM9eQ0K
Q09ORklHX1BDSUVBRVI9eQ0KQ09ORklHX0FSQ0hfU1VQUE9SVFNfTVNJPXkNCkNPTkZJR19QQ0lf
TVNJPXkNCiMgQ09ORklHX1BDSV9MRUdBQ1kgaXMgbm90IHNldA0KQ09ORklHX0hUX0lSUT15DQpD
T05GSUdfSVNBX0RNQV9BUEk9eQ0KQ09ORklHX0s4X05CPXkNCiMgQ09ORklHX1BDQ0FSRCBpcyBu
b3Qgc2V0DQojIENPTkZJR19IT1RQTFVHX1BDSSBpcyBub3Qgc2V0DQoNCiMNCiMgRXhlY3V0YWJs
ZSBmaWxlIGZvcm1hdHMgLyBFbXVsYXRpb25zDQojDQpDT05GSUdfQklORk1UX0VMRj15DQpDT05G
SUdfQklORk1UX01JU0M9bQ0KQ09ORklHX0lBMzJfRU1VTEFUSU9OPXkNCkNPTkZJR19JQTMyX0FP
VVQ9bQ0KQ09ORklHX0NPTVBBVD15DQpDT05GSUdfQ09NUEFUX0ZPUl9VNjRfQUxJR05NRU5UPXkN
CkNPTkZJR19TWVNWSVBDX0NPTVBBVD15DQoNCiMNCiMgTmV0d29ya2luZw0KIw0KQ09ORklHX05F
VD15DQoNCiMNCiMgTmV0d29ya2luZyBvcHRpb25zDQojDQpDT05GSUdfUEFDS0VUPW0NCkNPTkZJ
R19QQUNLRVRfTU1BUD15DQpDT05GSUdfVU5JWD1tDQpDT05GSUdfWEZSTT15DQpDT05GSUdfWEZS
TV9VU0VSPW0NCiMgQ09ORklHX1hGUk1fU1VCX1BPTElDWSBpcyBub3Qgc2V0DQpDT05GSUdfWEZS
TV9NSUdSQVRFPXkNCkNPTkZJR19ORVRfS0VZPW0NCkNPTkZJR19ORVRfS0VZX01JR1JBVEU9eQ0K
Q09ORklHX0lORVQ9eQ0KQ09ORklHX0lQX01VTFRJQ0FTVD15DQojIENPTkZJR19JUF9BRFZBTkNF
RF9ST1VURVIgaXMgbm90IHNldA0KQ09ORklHX0lQX0ZJQl9IQVNIPXkNCiMgQ09ORklHX0lQX1BO
UCBpcyBub3Qgc2V0DQojIENPTkZJR19ORVRfSVBJUCBpcyBub3Qgc2V0DQpDT05GSUdfTkVUX0lQ
R1JFPW0NCkNPTkZJR19ORVRfSVBHUkVfQlJPQURDQVNUPXkNCkNPTkZJR19JUF9NUk9VVEU9eQ0K
IyBDT05GSUdfSVBfUElNU01fVjEgaXMgbm90IHNldA0KQ09ORklHX0lQX1BJTVNNX1YyPXkNCiMg
Q09ORklHX0FSUEQgaXMgbm90IHNldA0KIyBDT05GSUdfU1lOX0NPT0tJRVMgaXMgbm90IHNldA0K
Q09ORklHX0lORVRfQUg9bQ0KQ09ORklHX0lORVRfRVNQPW0NCkNPTkZJR19JTkVUX0lQQ09NUD1t
DQpDT05GSUdfSU5FVF9YRlJNX1RVTk5FTD1tDQpDT05GSUdfSU5FVF9UVU5ORUw9bQ0KQ09ORklH
X0lORVRfWEZSTV9NT0RFX1RSQU5TUE9SVD1tDQpDT05GSUdfSU5FVF9YRlJNX01PREVfVFVOTkVM
PW0NCkNPTkZJR19JTkVUX1hGUk1fTU9ERV9CRUVUPW0NCkNPTkZJR19JTkVUX0xSTz15DQpDT05G
SUdfSU5FVF9ESUFHPW0NCkNPTkZJR19JTkVUX1RDUF9ESUFHPW0NCiMgQ09ORklHX1RDUF9DT05H
X0FEVkFOQ0VEIGlzIG5vdCBzZXQNCkNPTkZJR19UQ1BfQ09OR19DVUJJQz15DQpDT05GSUdfREVG
QVVMVF9UQ1BfQ09ORz0iY3ViaWMiDQpDT05GSUdfVENQX01ENVNJRz15DQojIENPTkZJR19JUF9W
UyBpcyBub3Qgc2V0DQpDT05GSUdfSVBWNj1tDQpDT05GSUdfSVBWNl9QUklWQUNZPXkNCkNPTkZJ
R19JUFY2X1JPVVRFUl9QUkVGPXkNCkNPTkZJR19JUFY2X1JPVVRFX0lORk89eQ0KQ09ORklHX0lQ
VjZfT1BUSU1JU1RJQ19EQUQ9eQ0KQ09ORklHX0lORVQ2X0FIPW0NCkNPTkZJR19JTkVUNl9FU1A9
bQ0KQ09ORklHX0lORVQ2X0lQQ09NUD1tDQpDT05GSUdfSVBWNl9NSVA2PW0NCkNPTkZJR19JTkVU
Nl9YRlJNX1RVTk5FTD1tDQpDT05GSUdfSU5FVDZfVFVOTkVMPW0NCkNPTkZJR19JTkVUNl9YRlJN
X01PREVfVFJBTlNQT1JUPW0NCkNPTkZJR19JTkVUNl9YRlJNX01PREVfVFVOTkVMPW0NCkNPTkZJ
R19JTkVUNl9YRlJNX01PREVfQkVFVD1tDQpDT05GSUdfSU5FVDZfWEZSTV9NT0RFX1JPVVRFT1BU
SU1JWkFUSU9OPW0NCkNPTkZJR19JUFY2X1NJVD1tDQpDT05GSUdfSVBWNl9UVU5ORUw9bQ0KQ09O
RklHX0lQVjZfTVVMVElQTEVfVEFCTEVTPXkNCkNPTkZJR19JUFY2X1NVQlRSRUVTPXkNCkNPTkZJ
R19ORVRXT1JLX1NFQ01BUks9eQ0KQ09ORklHX05FVEZJTFRFUj15DQojIENPTkZJR19ORVRGSUxU
RVJfREVCVUcgaXMgbm90IHNldA0KQ09ORklHX0JSSURHRV9ORVRGSUxURVI9eQ0KDQojDQojIENv
cmUgTmV0ZmlsdGVyIENvbmZpZ3VyYXRpb24NCiMNCkNPTkZJR19ORVRGSUxURVJfTkVUTElOSz1t
DQpDT05GSUdfTkVURklMVEVSX05FVExJTktfUVVFVUU9bQ0KQ09ORklHX05FVEZJTFRFUl9ORVRM
SU5LX0xPRz1tDQpDT05GSUdfTkZfQ09OTlRSQUNLX0VOQUJMRUQ9bQ0KQ09ORklHX05GX0NPTk5U
UkFDSz1tDQpDT05GSUdfTkZfQ1RfQUNDVD15DQpDT05GSUdfTkZfQ09OTlRSQUNLX01BUks9eQ0K
Q09ORklHX05GX0NPTk5UUkFDS19TRUNNQVJLPXkNCkNPTkZJR19ORl9DT05OVFJBQ0tfRVZFTlRT
PXkNCkNPTkZJR19ORl9DVF9QUk9UT19HUkU9bQ0KQ09ORklHX05GX0NUX1BST1RPX1NDVFA9bQ0K
Q09ORklHX05GX0NUX1BST1RPX1VEUExJVEU9bQ0KQ09ORklHX05GX0NPTk5UUkFDS19BTUFOREE9
bQ0KQ09ORklHX05GX0NPTk5UUkFDS19GVFA9bQ0KQ09ORklHX05GX0NPTk5UUkFDS19IMzIzPW0N
CkNPTkZJR19ORl9DT05OVFJBQ0tfSVJDPW0NCkNPTkZJR19ORl9DT05OVFJBQ0tfTkVUQklPU19O
Uz1tDQpDT05GSUdfTkZfQ09OTlRSQUNLX1BQVFA9bQ0KQ09ORklHX05GX0NPTk5UUkFDS19TQU5F
PW0NCkNPTkZJR19ORl9DT05OVFJBQ0tfU0lQPW0NCkNPTkZJR19ORl9DT05OVFJBQ0tfVEZUUD1t
DQpDT05GSUdfTkZfQ1RfTkVUTElOSz1tDQpDT05GSUdfTkVURklMVEVSX1hUQUJMRVM9bQ0KQ09O
RklHX05FVEZJTFRFUl9YVF9UQVJHRVRfQ0xBU1NJRlk9bQ0KQ09ORklHX05FVEZJTFRFUl9YVF9U
QVJHRVRfQ09OTk1BUks9bQ0KQ09ORklHX05FVEZJTFRFUl9YVF9UQVJHRVRfRFNDUD1tDQpDT05G
SUdfTkVURklMVEVSX1hUX1RBUkdFVF9NQVJLPW0NCkNPTkZJR19ORVRGSUxURVJfWFRfVEFSR0VU
X05GUVVFVUU9bQ0KQ09ORklHX05FVEZJTFRFUl9YVF9UQVJHRVRfTkZMT0c9bQ0KQ09ORklHX05F
VEZJTFRFUl9YVF9UQVJHRVRfTk9UUkFDSz1tDQpDT05GSUdfTkVURklMVEVSX1hUX1RBUkdFVF9U
UkFDRT1tDQpDT05GSUdfTkVURklMVEVSX1hUX1RBUkdFVF9TRUNNQVJLPW0NCkNPTkZJR19ORVRG
SUxURVJfWFRfVEFSR0VUX0NPTk5TRUNNQVJLPW0NCkNPTkZJR19ORVRGSUxURVJfWFRfVEFSR0VU
X1RDUE1TUz1tDQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX0NPTU1FTlQ9bQ0KQ09ORklHX05F
VEZJTFRFUl9YVF9NQVRDSF9DT05OQllURVM9bQ0KQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9D
T05OTElNSVQ9bQ0KQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9DT05OTUFSSz1tDQpDT05GSUdf
TkVURklMVEVSX1hUX01BVENIX0NPTk5UUkFDSz1tDQpDT05GSUdfTkVURklMVEVSX1hUX01BVENI
X0RDQ1A9bQ0KQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9EU0NQPW0NCkNPTkZJR19ORVRGSUxU
RVJfWFRfTUFUQ0hfRVNQPW0NCkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfSEVMUEVSPW0NCkNP
TkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfTEVOR1RIPW0NCkNPTkZJR19ORVRGSUxURVJfWFRfTUFU
Q0hfTElNSVQ9bQ0KQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9NQUM9bQ0KQ09ORklHX05FVEZJ
TFRFUl9YVF9NQVRDSF9NQVJLPW0NCkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfUE9MSUNZPW0N
CkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfTVVMVElQT1JUPW0NCkNPTkZJR19ORVRGSUxURVJf
WFRfTUFUQ0hfUEhZU0RFVj1tDQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX1BLVFRZUEU9bQ0K
Q09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9RVU9UQT1tDQpDT05GSUdfTkVURklMVEVSX1hUX01B
VENIX1JFQUxNPW0NCkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfU0NUUD1tDQpDT05GSUdfTkVU
RklMVEVSX1hUX01BVENIX1NUQVRFPW0NCkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfU1RBVElT
VElDPW0NCkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfU1RSSU5HPW0NCkNPTkZJR19ORVRGSUxU
RVJfWFRfTUFUQ0hfVENQTVNTPW0NCkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfVElNRT1tDQpD
T05GSUdfTkVURklMVEVSX1hUX01BVENIX1UzMj1tDQpDT05GSUdfTkVURklMVEVSX1hUX01BVENI
X0hBU0hMSU1JVD1tDQoNCiMNCiMgSVA6IE5ldGZpbHRlciBDb25maWd1cmF0aW9uDQojDQpDT05G
SUdfTkZfQ09OTlRSQUNLX0lQVjQ9bQ0KQ09ORklHX05GX0NPTk5UUkFDS19QUk9DX0NPTVBBVD15
DQojIENPTkZJR19JUF9ORl9RVUVVRSBpcyBub3Qgc2V0DQpDT05GSUdfSVBfTkZfSVBUQUJMRVM9
bQ0KQ09ORklHX0lQX05GX01BVENIX0lQUkFOR0U9bQ0KQ09ORklHX0lQX05GX01BVENIX1RPUz1t
DQpDT05GSUdfSVBfTkZfTUFUQ0hfUkVDRU5UPW0NCkNPTkZJR19JUF9ORl9NQVRDSF9FQ049bQ0K
Q09ORklHX0lQX05GX01BVENIX0FIPW0NCkNPTkZJR19JUF9ORl9NQVRDSF9UVEw9bQ0KQ09ORklH
X0lQX05GX01BVENIX09XTkVSPW0NCkNPTkZJR19JUF9ORl9NQVRDSF9BRERSVFlQRT1tDQpDT05G
SUdfSVBfTkZfRklMVEVSPW0NCkNPTkZJR19JUF9ORl9UQVJHRVRfUkVKRUNUPW0NCkNPTkZJR19J
UF9ORl9UQVJHRVRfTE9HPW0NCkNPTkZJR19JUF9ORl9UQVJHRVRfVUxPRz1tDQpDT05GSUdfTkZf
TkFUPW0NCkNPTkZJR19ORl9OQVRfTkVFREVEPXkNCkNPTkZJR19JUF9ORl9UQVJHRVRfTUFTUVVF
UkFERT1tDQpDT05GSUdfSVBfTkZfVEFSR0VUX1JFRElSRUNUPW0NCkNPTkZJR19JUF9ORl9UQVJH
RVRfTkVUTUFQPW0NCkNPTkZJR19JUF9ORl9UQVJHRVRfU0FNRT1tDQpDT05GSUdfTkZfTkFUX1NO
TVBfQkFTSUM9bQ0KQ09ORklHX05GX05BVF9QUk9UT19HUkU9bQ0KQ09ORklHX05GX05BVF9GVFA9
bQ0KQ09ORklHX05GX05BVF9JUkM9bQ0KQ09ORklHX05GX05BVF9URlRQPW0NCkNPTkZJR19ORl9O
QVRfQU1BTkRBPW0NCkNPTkZJR19ORl9OQVRfUFBUUD1tDQpDT05GSUdfTkZfTkFUX0gzMjM9bQ0K
Q09ORklHX05GX05BVF9TSVA9bQ0KQ09ORklHX0lQX05GX01BTkdMRT1tDQpDT05GSUdfSVBfTkZf
VEFSR0VUX1RPUz1tDQpDT05GSUdfSVBfTkZfVEFSR0VUX0VDTj1tDQpDT05GSUdfSVBfTkZfVEFS
R0VUX1RUTD1tDQpDT05GSUdfSVBfTkZfVEFSR0VUX0NMVVNURVJJUD1tDQpDT05GSUdfSVBfTkZf
UkFXPW0NCkNPTkZJR19JUF9ORl9BUlBUQUJMRVM9bQ0KQ09ORklHX0lQX05GX0FSUEZJTFRFUj1t
DQpDT05GSUdfSVBfTkZfQVJQX01BTkdMRT1tDQoNCiMNCiMgSVB2NjogTmV0ZmlsdGVyIENvbmZp
Z3VyYXRpb24gKEVYUEVSSU1FTlRBTCkNCiMNCkNPTkZJR19ORl9DT05OVFJBQ0tfSVBWNj1tDQoj
IENPTkZJR19JUDZfTkZfUVVFVUUgaXMgbm90IHNldA0KQ09ORklHX0lQNl9ORl9JUFRBQkxFUz1t
DQpDT05GSUdfSVA2X05GX01BVENIX1JUPW0NCkNPTkZJR19JUDZfTkZfTUFUQ0hfT1BUUz1tDQpD
T05GSUdfSVA2X05GX01BVENIX0ZSQUc9bQ0KQ09ORklHX0lQNl9ORl9NQVRDSF9ITD1tDQpDT05G
SUdfSVA2X05GX01BVENIX09XTkVSPW0NCkNPTkZJR19JUDZfTkZfTUFUQ0hfSVBWNkhFQURFUj1t
DQpDT05GSUdfSVA2X05GX01BVENIX0FIPW0NCkNPTkZJR19JUDZfTkZfTUFUQ0hfTUg9bQ0KQ09O
RklHX0lQNl9ORl9NQVRDSF9FVUk2ND1tDQpDT05GSUdfSVA2X05GX0ZJTFRFUj1tDQpDT05GSUdf
SVA2X05GX1RBUkdFVF9MT0c9bQ0KQ09ORklHX0lQNl9ORl9UQVJHRVRfUkVKRUNUPW0NCkNPTkZJ
R19JUDZfTkZfTUFOR0xFPW0NCkNPTkZJR19JUDZfTkZfVEFSR0VUX0hMPW0NCkNPTkZJR19JUDZf
TkZfUkFXPW0NCg0KIw0KIyBCcmlkZ2U6IE5ldGZpbHRlciBDb25maWd1cmF0aW9uDQojDQpDT05G
SUdfQlJJREdFX05GX0VCVEFCTEVTPW0NCkNPTkZJR19CUklER0VfRUJUX0JST1VURT1tDQpDT05G
SUdfQlJJREdFX0VCVF9UX0ZJTFRFUj1tDQpDT05GSUdfQlJJREdFX0VCVF9UX05BVD1tDQpDT05G
SUdfQlJJREdFX0VCVF84MDJfMz1tDQpDT05GSUdfQlJJREdFX0VCVF9BTU9ORz1tDQpDT05GSUdf
QlJJREdFX0VCVF9BUlA9bQ0KQ09ORklHX0JSSURHRV9FQlRfSVA9bQ0KQ09ORklHX0JSSURHRV9F
QlRfTElNSVQ9bQ0KQ09ORklHX0JSSURHRV9FQlRfTUFSSz1tDQpDT05GSUdfQlJJREdFX0VCVF9Q
S1RUWVBFPW0NCkNPTkZJR19CUklER0VfRUJUX1NUUD1tDQpDT05GSUdfQlJJREdFX0VCVF9WTEFO
PW0NCkNPTkZJR19CUklER0VfRUJUX0FSUFJFUExZPW0NCkNPTkZJR19CUklER0VfRUJUX0ROQVQ9
bQ0KQ09ORklHX0JSSURHRV9FQlRfTUFSS19UPW0NCkNPTkZJR19CUklER0VfRUJUX1JFRElSRUNU
PW0NCkNPTkZJR19CUklER0VfRUJUX1NOQVQ9bQ0KQ09ORklHX0JSSURHRV9FQlRfTE9HPW0NCkNP
TkZJR19CUklER0VfRUJUX1VMT0c9bQ0KQ09ORklHX0lQX0RDQ1A9bQ0KQ09ORklHX0lORVRfREND
UF9ESUFHPW0NCkNPTkZJR19JUF9EQ0NQX0FDS1ZFQz15DQoNCiMNCiMgRENDUCBDQ0lEcyBDb25m
aWd1cmF0aW9uIChFWFBFUklNRU5UQUwpDQojDQpDT05GSUdfSVBfRENDUF9DQ0lEMj1tDQojIENP
TkZJR19JUF9EQ0NQX0NDSUQyX0RFQlVHIGlzIG5vdCBzZXQNCkNPTkZJR19JUF9EQ0NQX0NDSUQz
PW0NCkNPTkZJR19JUF9EQ0NQX1RGUkNfTElCPW0NCiMgQ09ORklHX0lQX0RDQ1BfQ0NJRDNfREVC
VUcgaXMgbm90IHNldA0KQ09ORklHX0lQX0RDQ1BfQ0NJRDNfUlRPPTEwMA0KQ09ORklHX0lQX1ND
VFA9bQ0KIyBDT05GSUdfU0NUUF9EQkdfTVNHIGlzIG5vdCBzZXQNCiMgQ09ORklHX1NDVFBfREJH
X09CSkNOVCBpcyBub3Qgc2V0DQojIENPTkZJR19TQ1RQX0hNQUNfTk9ORSBpcyBub3Qgc2V0DQpD
T05GSUdfU0NUUF9ITUFDX1NIQTE9eQ0KIyBDT05GSUdfU0NUUF9ITUFDX01ENSBpcyBub3Qgc2V0
DQpDT05GSUdfVElQQz1tDQojIENPTkZJR19USVBDX0FEVkFOQ0VEIGlzIG5vdCBzZXQNCiMgQ09O
RklHX1RJUENfREVCVUcgaXMgbm90IHNldA0KIyBDT05GSUdfQVRNIGlzIG5vdCBzZXQNCkNPTkZJ
R19CUklER0U9bQ0KQ09ORklHX1ZMQU5fODAyMVE9bQ0KIyBDT05GSUdfREVDTkVUIGlzIG5vdCBz
ZXQNCkNPTkZJR19MTEM9bQ0KIyBDT05GSUdfTExDMiBpcyBub3Qgc2V0DQojIENPTkZJR19JUFgg
aXMgbm90IHNldA0KIyBDT05GSUdfQVRBTEsgaXMgbm90IHNldA0KIyBDT05GSUdfWDI1IGlzIG5v
dCBzZXQNCiMgQ09ORklHX0xBUEIgaXMgbm90IHNldA0KIyBDT05GSUdfRUNPTkVUIGlzIG5vdCBz
ZXQNCiMgQ09ORklHX1dBTl9ST1VURVIgaXMgbm90IHNldA0KQ09ORklHX05FVF9TQ0hFRD15DQoN
CiMNCiMgUXVldWVpbmcvU2NoZWR1bGluZw0KIw0KQ09ORklHX05FVF9TQ0hfQ0JRPW0NCkNPTkZJ
R19ORVRfU0NIX0hUQj1tDQpDT05GSUdfTkVUX1NDSF9IRlNDPW0NCkNPTkZJR19ORVRfU0NIX1BS
SU89bQ0KQ09ORklHX05FVF9TQ0hfUlI9bQ0KQ09ORklHX05FVF9TQ0hfUkVEPW0NCkNPTkZJR19O
RVRfU0NIX1NGUT1tDQpDT05GSUdfTkVUX1NDSF9URVFMPW0NCkNPTkZJR19ORVRfU0NIX1RCRj1t
DQpDT05GSUdfTkVUX1NDSF9HUkVEPW0NCkNPTkZJR19ORVRfU0NIX0RTTUFSSz1tDQpDT05GSUdf
TkVUX1NDSF9ORVRFTT1tDQpDT05GSUdfTkVUX1NDSF9JTkdSRVNTPW0NCg0KIw0KIyBDbGFzc2lm
aWNhdGlvbg0KIw0KQ09ORklHX05FVF9DTFM9eQ0KQ09ORklHX05FVF9DTFNfQkFTSUM9bQ0KQ09O
RklHX05FVF9DTFNfVENJTkRFWD1tDQpDT05GSUdfTkVUX0NMU19ST1VURTQ9bQ0KQ09ORklHX05F
VF9DTFNfUk9VVEU9eQ0KQ09ORklHX05FVF9DTFNfRlc9bQ0KQ09ORklHX05FVF9DTFNfVTMyPW0N
CiMgQ09ORklHX0NMU19VMzJfUEVSRiBpcyBub3Qgc2V0DQpDT05GSUdfQ0xTX1UzMl9NQVJLPXkN
CkNPTkZJR19ORVRfQ0xTX1JTVlA9bQ0KQ09ORklHX05FVF9DTFNfUlNWUDY9bQ0KQ09ORklHX05F
VF9FTUFUQ0g9eQ0KQ09ORklHX05FVF9FTUFUQ0hfU1RBQ0s9MzINCkNPTkZJR19ORVRfRU1BVENI
X0NNUD1tDQpDT05GSUdfTkVUX0VNQVRDSF9OQllURT1tDQpDT05GSUdfTkVUX0VNQVRDSF9VMzI9
bQ0KQ09ORklHX05FVF9FTUFUQ0hfTUVUQT1tDQpDT05GSUdfTkVUX0VNQVRDSF9URVhUPW0NCkNP
TkZJR19ORVRfQ0xTX0FDVD15DQpDT05GSUdfTkVUX0FDVF9QT0xJQ0U9bQ0KQ09ORklHX05FVF9B
Q1RfR0FDVD1tDQpDT05GSUdfR0FDVF9QUk9CPXkNCkNPTkZJR19ORVRfQUNUX01JUlJFRD1tDQpD
T05GSUdfTkVUX0FDVF9JUFQ9bQ0KQ09ORklHX05FVF9BQ1RfTkFUPW0NCkNPTkZJR19ORVRfQUNU
X1BFRElUPW0NCkNPTkZJR19ORVRfQUNUX1NJTVA9bQ0KIyBDT05GSUdfTkVUX0NMU19QT0xJQ0Ug
aXMgbm90IHNldA0KQ09ORklHX05FVF9DTFNfSU5EPXkNCkNPTkZJR19ORVRfU0NIX0ZJRk89eQ0K
DQojDQojIE5ldHdvcmsgdGVzdGluZw0KIw0KIyBDT05GSUdfTkVUX1BLVEdFTiBpcyBub3Qgc2V0
DQojIENPTkZJR19IQU1SQURJTyBpcyBub3Qgc2V0DQojIENPTkZJR19JUkRBIGlzIG5vdCBzZXQN
CiMgQ09ORklHX0JUIGlzIG5vdCBzZXQNCkNPTkZJR19BRl9SWFJQQz1tDQojIENPTkZJR19BRl9S
WFJQQ19ERUJVRyBpcyBub3Qgc2V0DQpDT05GSUdfUlhLQUQ9bQ0KQ09ORklHX0ZJQl9SVUxFUz15
DQoNCiMNCiMgV2lyZWxlc3MNCiMNCiMgQ09ORklHX0NGRzgwMjExIGlzIG5vdCBzZXQNCkNPTkZJ
R19XSVJFTEVTU19FWFQ9eQ0KIyBDT05GSUdfTUFDODAyMTEgaXMgbm90IHNldA0KIyBDT05GSUdf
SUVFRTgwMjExIGlzIG5vdCBzZXQNCiMgQ09ORklHX1JGS0lMTCBpcyBub3Qgc2V0DQojIENPTkZJ
R19ORVRfOVAgaXMgbm90IHNldA0KDQojDQojIERldmljZSBEcml2ZXJzDQojDQoNCiMNCiMgR2Vu
ZXJpYyBEcml2ZXIgT3B0aW9ucw0KIw0KQ09ORklHX1VFVkVOVF9IRUxQRVJfUEFUSD0iL3NiaW4v
aG90cGx1ZyINCkNPTkZJR19TVEFOREFMT05FPXkNCkNPTkZJR19QUkVWRU5UX0ZJUk1XQVJFX0JV
SUxEPXkNCkNPTkZJR19GV19MT0FERVI9bQ0KIyBDT05GSUdfU1lTX0hZUEVSVklTT1IgaXMgbm90
IHNldA0KQ09ORklHX0NPTk5FQ1RPUj1tDQojIENPTkZJR19NVEQgaXMgbm90IHNldA0KQ09ORklH
X1BBUlBPUlQ9bQ0KQ09ORklHX1BBUlBPUlRfUEM9bQ0KIyBDT05GSUdfUEFSUE9SVF9TRVJJQUwg
aXMgbm90IHNldA0KQ09ORklHX1BBUlBPUlRfUENfRklGTz15DQojIENPTkZJR19QQVJQT1JUX1BD
X1NVUEVSSU8gaXMgbm90IHNldA0KIyBDT05GSUdfUEFSUE9SVF9HU0MgaXMgbm90IHNldA0KIyBD
T05GSUdfUEFSUE9SVF9BWDg4Nzk2IGlzIG5vdCBzZXQNCkNPTkZJR19QQVJQT1JUXzEyODQ9eQ0K
Q09ORklHX1BBUlBPUlRfTk9UX1BDPXkNCkNPTkZJR19QTlA9eQ0KIyBDT05GSUdfUE5QX0RFQlVH
IGlzIG5vdCBzZXQNCg0KIw0KIyBQcm90b2NvbHMNCiMNCkNPTkZJR19QTlBBQ1BJPXkNCkNPTkZJ
R19CTEtfREVWPXkNCkNPTkZJR19CTEtfREVWX0ZEPW0NCiMgQ09ORklHX1BBUklERSBpcyBub3Qg
c2V0DQojIENPTkZJR19CTEtfQ1BRX0RBIGlzIG5vdCBzZXQNCiMgQ09ORklHX0JMS19DUFFfQ0lT
U19EQSBpcyBub3Qgc2V0DQojIENPTkZJR19CTEtfREVWX0RBQzk2MCBpcyBub3Qgc2V0DQojIENP
TkZJR19CTEtfREVWX1VNRU0gaXMgbm90IHNldA0KIyBDT05GSUdfQkxLX0RFVl9DT1dfQ09NTU9O
IGlzIG5vdCBzZXQNCkNPTkZJR19CTEtfREVWX0xPT1A9bQ0KQ09ORklHX0JMS19ERVZfQ1JZUFRP
TE9PUD1tDQpDT05GSUdfQkxLX0RFVl9OQkQ9bQ0KIyBDT05GSUdfQkxLX0RFVl9TWDggaXMgbm90
IHNldA0KIyBDT05GSUdfQkxLX0RFVl9VQiBpcyBub3Qgc2V0DQpDT05GSUdfQkxLX0RFVl9SQU09
eQ0KQ09ORklHX0JMS19ERVZfUkFNX0NPVU5UPTE2DQpDT05GSUdfQkxLX0RFVl9SQU1fU0laRT00
MDk2DQpDT05GSUdfQkxLX0RFVl9SQU1fQkxPQ0tTSVpFPTEwMjQNCiMgQ09ORklHX0NEUk9NX1BL
VENEVkQgaXMgbm90IHNldA0KQ09ORklHX0FUQV9PVkVSX0VUSD1tDQpDT05GSUdfTUlTQ19ERVZJ
Q0VTPXkNCiMgQ09ORklHX0lCTV9BU00gaXMgbm90IHNldA0KIyBDT05GSUdfUEhBTlRPTSBpcyBu
b3Qgc2V0DQojIENPTkZJR19FRVBST01fOTNDWDYgaXMgbm90IHNldA0KIyBDT05GSUdfU0dJX0lP
QzQgaXMgbm90IHNldA0KIyBDT05GSUdfVElGTV9DT1JFIGlzIG5vdCBzZXQNCiMgQ09ORklHX0ZV
SklUU1VfTEFQVE9QIGlzIG5vdCBzZXQNCiMgQ09ORklHX01TSV9MQVBUT1AgaXMgbm90IHNldA0K
IyBDT05GSUdfU09OWV9MQVBUT1AgaXMgbm90IHNldA0KIyBDT05GSUdfVEhJTktQQURfQUNQSSBp
cyBub3Qgc2V0DQojIENPTkZJR19JREUgaXMgbm90IHNldA0KDQojDQojIFNDU0kgZGV2aWNlIHN1
cHBvcnQNCiMNCkNPTkZJR19SQUlEX0FUVFJTPW0NCkNPTkZJR19TQ1NJPW0NCkNPTkZJR19TQ1NJ
X0RNQT15DQojIENPTkZJR19TQ1NJX1RHVCBpcyBub3Qgc2V0DQojIENPTkZJR19TQ1NJX05FVExJ
TksgaXMgbm90IHNldA0KQ09ORklHX1NDU0lfUFJPQ19GUz15DQoNCiMNCiMgU0NTSSBzdXBwb3J0
IHR5cGUgKGRpc2ssIHRhcGUsIENELVJPTSkNCiMNCkNPTkZJR19CTEtfREVWX1NEPW0NCiMgQ09O
RklHX0NIUl9ERVZfU1QgaXMgbm90IHNldA0KIyBDT05GSUdfQ0hSX0RFVl9PU1NUIGlzIG5vdCBz
ZXQNCkNPTkZJR19CTEtfREVWX1NSPW0NCiMgQ09ORklHX0JMS19ERVZfU1JfVkVORE9SIGlzIG5v
dCBzZXQNCkNPTkZJR19DSFJfREVWX1NHPW0NCiMgQ09ORklHX0NIUl9ERVZfU0NIIGlzIG5vdCBz
ZXQNCg0KIw0KIyBTb21lIFNDU0kgZGV2aWNlcyAoZS5nLiBDRCBqdWtlYm94KSBzdXBwb3J0IG11
bHRpcGxlIExVTnMNCiMNCiMgQ09ORklHX1NDU0lfTVVMVElfTFVOIGlzIG5vdCBzZXQNCkNPTkZJ
R19TQ1NJX0NPTlNUQU5UUz15DQpDT05GSUdfU0NTSV9MT0dHSU5HPXkNCiMgQ09ORklHX1NDU0lf
U0NBTl9BU1lOQyBpcyBub3Qgc2V0DQpDT05GSUdfU0NTSV9XQUlUX1NDQU49bQ0KDQojDQojIFND
U0kgVHJhbnNwb3J0cw0KIw0KIyBDT05GSUdfU0NTSV9TUElfQVRUUlMgaXMgbm90IHNldA0KIyBD
T05GSUdfU0NTSV9GQ19BVFRSUyBpcyBub3Qgc2V0DQpDT05GSUdfU0NTSV9JU0NTSV9BVFRSUz1t
DQojIENPTkZJR19TQ1NJX1NBU19BVFRSUyBpcyBub3Qgc2V0DQojIENPTkZJR19TQ1NJX1NBU19M
SUJTQVMgaXMgbm90IHNldA0KIyBDT05GSUdfU0NTSV9TUlBfQVRUUlMgaXMgbm90IHNldA0KQ09O
RklHX1NDU0lfTE9XTEVWRUw9eQ0KQ09ORklHX0lTQ1NJX1RDUD1tDQojIENPTkZJR19CTEtfREVW
XzNXX1hYWFhfUkFJRCBpcyBub3Qgc2V0DQojIENPTkZJR19TQ1NJXzNXXzlYWFggaXMgbm90IHNl
dA0KIyBDT05GSUdfU0NTSV9BQ0FSRCBpcyBub3Qgc2V0DQojIENPTkZJR19TQ1NJX0FBQ1JBSUQg
aXMgbm90IHNldA0KIyBDT05GSUdfU0NTSV9BSUM3WFhYIGlzIG5vdCBzZXQNCiMgQ09ORklHX1ND
U0lfQUlDN1hYWF9PTEQgaXMgbm90IHNldA0KIyBDT05GSUdfU0NTSV9BSUM3OVhYIGlzIG5vdCBz
ZXQNCiMgQ09ORklHX1NDU0lfQUlDOTRYWCBpcyBub3Qgc2V0DQojIENPTkZJR19TQ1NJX0FEVkFO
U1lTIGlzIG5vdCBzZXQNCiMgQ09ORklHX1NDU0lfQVJDTVNSIGlzIG5vdCBzZXQNCiMgQ09ORklH
X01FR0FSQUlEX05FV0dFTiBpcyBub3Qgc2V0DQojIENPTkZJR19NRUdBUkFJRF9MRUdBQ1kgaXMg
bm90IHNldA0KIyBDT05GSUdfTUVHQVJBSURfU0FTIGlzIG5vdCBzZXQNCiMgQ09ORklHX1NDU0lf
SFBUSU9QIGlzIG5vdCBzZXQNCiMgQ09ORklHX1NDU0lfQlVTTE9HSUMgaXMgbm90IHNldA0KIyBD
T05GSUdfU0NTSV9ETVgzMTkxRCBpcyBub3Qgc2V0DQojIENPTkZJR19TQ1NJX0VBVEEgaXMgbm90
IHNldA0KIyBDT05GSUdfU0NTSV9GVVRVUkVfRE9NQUlOIGlzIG5vdCBzZXQNCiMgQ09ORklHX1ND
U0lfSVBTIGlzIG5vdCBzZXQNCiMgQ09ORklHX1NDU0lfSU5JVElPIGlzIG5vdCBzZXQNCiMgQ09O
RklHX1NDU0lfSU5JQTEwMCBpcyBub3Qgc2V0DQojIENPTkZJR19TQ1NJX1BQQSBpcyBub3Qgc2V0
DQojIENPTkZJR19TQ1NJX0lNTSBpcyBub3Qgc2V0DQojIENPTkZJR19TQ1NJX1NURVggaXMgbm90
IHNldA0KIyBDT05GSUdfU0NTSV9TWU01M0M4WFhfMiBpcyBub3Qgc2V0DQojIENPTkZJR19TQ1NJ
X0lQUiBpcyBub3Qgc2V0DQojIENPTkZJR19TQ1NJX1FMT0dJQ18xMjgwIGlzIG5vdCBzZXQNCiMg
Q09ORklHX1NDU0lfUUxBX0ZDIGlzIG5vdCBzZXQNCiMgQ09ORklHX1NDU0lfUUxBX0lTQ1NJIGlz
IG5vdCBzZXQNCiMgQ09ORklHX1NDU0lfTFBGQyBpcyBub3Qgc2V0DQojIENPTkZJR19TQ1NJX0RD
Mzk1eCBpcyBub3Qgc2V0DQojIENPTkZJR19TQ1NJX0RDMzkwVCBpcyBub3Qgc2V0DQojIENPTkZJ
R19TQ1NJX0RFQlVHIGlzIG5vdCBzZXQNCiMgQ09ORklHX1NDU0lfU1JQIGlzIG5vdCBzZXQNCkNP
TkZJR19BVEE9bQ0KIyBDT05GSUdfQVRBX05PTlNUQU5EQVJEIGlzIG5vdCBzZXQNCkNPTkZJR19B
VEFfQUNQST15DQpDT05GSUdfU0FUQV9BSENJPW0NCiMgQ09ORklHX1NBVEFfU1ZXIGlzIG5vdCBz
ZXQNCiMgQ09ORklHX0FUQV9QSUlYIGlzIG5vdCBzZXQNCiMgQ09ORklHX1NBVEFfTVYgaXMgbm90
IHNldA0KIyBDT05GSUdfU0FUQV9OViBpcyBub3Qgc2V0DQojIENPTkZJR19QRENfQURNQSBpcyBu
b3Qgc2V0DQojIENPTkZJR19TQVRBX1FTVE9SIGlzIG5vdCBzZXQNCkNPTkZJR19TQVRBX1BST01J
U0U9bQ0KQ09ORklHX1NBVEFfU1g0PW0NCiMgQ09ORklHX1NBVEFfU0lMIGlzIG5vdCBzZXQNCiMg
Q09ORklHX1NBVEFfU0lMMjQgaXMgbm90IHNldA0KIyBDT05GSUdfU0FUQV9TSVMgaXMgbm90IHNl
dA0KIyBDT05GSUdfU0FUQV9VTEkgaXMgbm90IHNldA0KQ09ORklHX1NBVEFfVklBPW0NCiMgQ09O
RklHX1NBVEFfVklURVNTRSBpcyBub3Qgc2V0DQojIENPTkZJR19TQVRBX0lOSUMxNjJYIGlzIG5v
dCBzZXQNCiMgQ09ORklHX1BBVEFfQUNQSSBpcyBub3Qgc2V0DQojIENPTkZJR19QQVRBX0FMSSBp
cyBub3Qgc2V0DQpDT05GSUdfUEFUQV9BTUQ9bQ0KIyBDT05GSUdfUEFUQV9BUlRPUCBpcyBub3Qg
c2V0DQpDT05GSUdfUEFUQV9BVElJWFA9bQ0KIyBDT05GSUdfUEFUQV9DTUQ2NDBfUENJIGlzIG5v
dCBzZXQNCiMgQ09ORklHX1BBVEFfQ01ENjRYIGlzIG5vdCBzZXQNCiMgQ09ORklHX1BBVEFfQ1M1
NTIwIGlzIG5vdCBzZXQNCiMgQ09ORklHX1BBVEFfQ1M1NTMwIGlzIG5vdCBzZXQNCiMgQ09ORklH
X1BBVEFfQ1lQUkVTUyBpcyBub3Qgc2V0DQojIENPTkZJR19QQVRBX0VGQVIgaXMgbm90IHNldA0K
IyBDT05GSUdfQVRBX0dFTkVSSUMgaXMgbm90IHNldA0KIyBDT05GSUdfUEFUQV9IUFQzNjYgaXMg
bm90IHNldA0KIyBDT05GSUdfUEFUQV9IUFQzN1ggaXMgbm90IHNldA0KIyBDT05GSUdfUEFUQV9I
UFQzWDJOIGlzIG5vdCBzZXQNCiMgQ09ORklHX1BBVEFfSFBUM1gzIGlzIG5vdCBzZXQNCiMgQ09O
RklHX1BBVEFfSVQ4MjFYIGlzIG5vdCBzZXQNCiMgQ09ORklHX1BBVEFfSVQ4MjEzIGlzIG5vdCBz
ZXQNCiMgQ09ORklHX1BBVEFfSk1JQ1JPTiBpcyBub3Qgc2V0DQojIENPTkZJR19QQVRBX1RSSUZM
RVggaXMgbm90IHNldA0KIyBDT05GSUdfUEFUQV9NQVJWRUxMIGlzIG5vdCBzZXQNCiMgQ09ORklH
X1BBVEFfTVBJSVggaXMgbm90IHNldA0KIyBDT05GSUdfUEFUQV9PTERQSUlYIGlzIG5vdCBzZXQN
CiMgQ09ORklHX1BBVEFfTkVUQ0VMTCBpcyBub3Qgc2V0DQojIENPTkZJR19QQVRBX05TODc0MTAg
aXMgbm90IHNldA0KIyBDT05GSUdfUEFUQV9OUzg3NDE1IGlzIG5vdCBzZXQNCiMgQ09ORklHX1BB
VEFfT1BUSSBpcyBub3Qgc2V0DQojIENPTkZJR19QQVRBX09QVElETUEgaXMgbm90IHNldA0KIyBD
T05GSUdfUEFUQV9QRENfT0xEIGlzIG5vdCBzZXQNCiMgQ09ORklHX1BBVEFfUkFESVNZUyBpcyBu
b3Qgc2V0DQojIENPTkZJR19QQVRBX1JaMTAwMCBpcyBub3Qgc2V0DQojIENPTkZJR19QQVRBX1ND
MTIwMCBpcyBub3Qgc2V0DQojIENPTkZJR19QQVRBX1NFUlZFUldPUktTIGlzIG5vdCBzZXQNCiMg
Q09ORklHX1BBVEFfUERDMjAyN1ggaXMgbm90IHNldA0KIyBDT05GSUdfUEFUQV9TSUw2ODAgaXMg
bm90IHNldA0KIyBDT05GSUdfUEFUQV9TSVMgaXMgbm90IHNldA0KIyBDT05GSUdfUEFUQV9WSUEg
aXMgbm90IHNldA0KIyBDT05GSUdfUEFUQV9XSU5CT05EIGlzIG5vdCBzZXQNCkNPTkZJR19NRD15
DQpDT05GSUdfQkxLX0RFVl9NRD1tDQpDT05GSUdfTURfTElORUFSPW0NCkNPTkZJR19NRF9SQUlE
MD1tDQpDT05GSUdfTURfUkFJRDE9bQ0KQ09ORklHX01EX1JBSUQxMD1tDQpDT05GSUdfTURfUkFJ
RDQ1Nj1tDQpDT05GSUdfTURfUkFJRDVfUkVTSEFQRT15DQpDT05GSUdfTURfTVVMVElQQVRIPW0N
CkNPTkZJR19NRF9GQVVMVFk9bQ0KQ09ORklHX0JMS19ERVZfRE09bQ0KIyBDT05GSUdfRE1fREVC
VUcgaXMgbm90IHNldA0KQ09ORklHX0RNX0NSWVBUPW0NCkNPTkZJR19ETV9TTkFQU0hPVD1tDQpD
T05GSUdfRE1fTUlSUk9SPW0NCkNPTkZJR19ETV9aRVJPPW0NCiMgQ09ORklHX0RNX01VTFRJUEFU
SCBpcyBub3Qgc2V0DQpDT05GSUdfRE1fREVMQVk9bQ0KQ09ORklHX0RNX1VFVkVOVD15DQojIENP
TkZJR19GVVNJT04gaXMgbm90IHNldA0KDQojDQojIElFRUUgMTM5NCAoRmlyZVdpcmUpIHN1cHBv
cnQNCiMNCiMgQ09ORklHX0ZJUkVXSVJFIGlzIG5vdCBzZXQNCiMgQ09ORklHX0lFRUUxMzk0IGlz
IG5vdCBzZXQNCiMgQ09ORklHX0kyTyBpcyBub3Qgc2V0DQojIENPTkZJR19NQUNJTlRPU0hfRFJJ
VkVSUyBpcyBub3Qgc2V0DQpDT05GSUdfTkVUREVWSUNFUz15DQojIENPTkZJR19ORVRERVZJQ0VT
X01VTFRJUVVFVUUgaXMgbm90IHNldA0KQ09ORklHX0lGQj1tDQojIENPTkZJR19EVU1NWSBpcyBu
b3Qgc2V0DQpDT05GSUdfQk9ORElORz1tDQpDT05GSUdfTUFDVkxBTj1tDQojIENPTkZJR19FUVVB
TElaRVIgaXMgbm90IHNldA0KQ09ORklHX1RVTj1tDQpDT05GSUdfVkVUSD1tDQojIENPTkZJR19O
RVRfU0IxMDAwIGlzIG5vdCBzZXQNCiMgQ09ORklHX0FSQ05FVCBpcyBub3Qgc2V0DQojIENPTkZJ
R19QSFlMSUIgaXMgbm90IHNldA0KQ09ORklHX05FVF9FVEhFUk5FVD15DQpDT05GSUdfTUlJPW0N
CiMgQ09ORklHX0hBUFBZTUVBTCBpcyBub3Qgc2V0DQojIENPTkZJR19TVU5HRU0gaXMgbm90IHNl
dA0KIyBDT05GSUdfQ0FTU0lOSSBpcyBub3Qgc2V0DQpDT05GSUdfTkVUX1ZFTkRPUl8zQ09NPXkN
CkNPTkZJR19WT1JURVg9bQ0KIyBDT05GSUdfVFlQSE9PTiBpcyBub3Qgc2V0DQojIENPTkZJR19O
RVRfVFVMSVAgaXMgbm90IHNldA0KIyBDT05GSUdfSFAxMDAgaXMgbm90IHNldA0KIyBDT05GSUdf
SUJNX05FV19FTUFDX1pNSUkgaXMgbm90IHNldA0KIyBDT05GSUdfSUJNX05FV19FTUFDX1JHTUlJ
IGlzIG5vdCBzZXQNCiMgQ09ORklHX0lCTV9ORVdfRU1BQ19UQUggaXMgbm90IHNldA0KIyBDT05G
SUdfSUJNX05FV19FTUFDX0VNQUM0IGlzIG5vdCBzZXQNCkNPTkZJR19ORVRfUENJPXkNCiMgQ09O
RklHX1BDTkVUMzIgaXMgbm90IHNldA0KIyBDT05GSUdfQU1EODExMV9FVEggaXMgbm90IHNldA0K
IyBDT05GSUdfQURBUFRFQ19TVEFSRklSRSBpcyBub3Qgc2V0DQojIENPTkZJR19CNDQgaXMgbm90
IHNldA0KIyBDT05GSUdfRk9SQ0VERVRIIGlzIG5vdCBzZXQNCiMgQ09ORklHX0VFUFJPMTAwIGlz
IG5vdCBzZXQNCkNPTkZJR19FMTAwPW0NCiMgQ09ORklHX0ZFQUxOWCBpcyBub3Qgc2V0DQojIENP
TkZJR19OQVRTRU1JIGlzIG5vdCBzZXQNCiMgQ09ORklHX05FMktfUENJIGlzIG5vdCBzZXQNCiMg
Q09ORklHXzgxMzlDUCBpcyBub3Qgc2V0DQpDT05GSUdfODEzOVRPTz1tDQojIENPTkZJR184MTM5
VE9PX1BJTyBpcyBub3Qgc2V0DQojIENPTkZJR184MTM5VE9PX1RVTkVfVFdJU1RFUiBpcyBub3Qg
c2V0DQojIENPTkZJR184MTM5VE9PXzgxMjkgaXMgbm90IHNldA0KIyBDT05GSUdfODEzOV9PTERf
UlhfUkVTRVQgaXMgbm90IHNldA0KQ09ORklHX1NJUzkwMD1tDQojIENPTkZJR19FUElDMTAwIGlz
IG5vdCBzZXQNCiMgQ09ORklHX1NVTkRBTkNFIGlzIG5vdCBzZXQNCkNPTkZJR19WSUFfUkhJTkU9
bQ0KQ09ORklHX1ZJQV9SSElORV9NTUlPPXkNCkNPTkZJR19WSUFfUkhJTkVfTkFQST15DQojIENP
TkZJR19TQzkyMDMxIGlzIG5vdCBzZXQNCiMgQ09ORklHX05FVF9QT0NLRVQgaXMgbm90IHNldA0K
Q09ORklHX05FVERFVl8xMDAwPXkNCiMgQ09ORklHX0FDRU5JQyBpcyBub3Qgc2V0DQojIENPTkZJ
R19ETDJLIGlzIG5vdCBzZXQNCkNPTkZJR19FMTAwMD1tDQpDT05GSUdfRTEwMDBfTkFQST15DQoj
IENPTkZJR19FMTAwMF9ESVNBQkxFX1BBQ0tFVF9TUExJVCBpcyBub3Qgc2V0DQpDT05GSUdfRTEw
MDBFPW0NCiMgQ09ORklHX0lQMTAwMCBpcyBub3Qgc2V0DQojIENPTkZJR19OUzgzODIwIGlzIG5v
dCBzZXQNCiMgQ09ORklHX0hBTUFDSEkgaXMgbm90IHNldA0KIyBDT05GSUdfWUVMTE9XRklOIGlz
IG5vdCBzZXQNCiMgQ09ORklHX1I4MTY5IGlzIG5vdCBzZXQNCiMgQ09ORklHX1NJUzE5MCBpcyBu
b3Qgc2V0DQpDT05GSUdfU0tHRT1tDQojIENPTkZJR19TS0dFX0RFQlVHIGlzIG5vdCBzZXQNCkNP
TkZJR19TS1kyPW0NCiMgQ09ORklHX1NLWTJfREVCVUcgaXMgbm90IHNldA0KIyBDT05GSUdfU0s5
OExJTiBpcyBub3Qgc2V0DQojIENPTkZJR19WSUFfVkVMT0NJVFkgaXMgbm90IHNldA0KQ09ORklH
X1RJR09OMz1tDQpDT05GSUdfQk5YMj1tDQojIENPTkZJR19RTEEzWFhYIGlzIG5vdCBzZXQNCiMg
Q09ORklHX0FUTDEgaXMgbm90IHNldA0KIyBDT05GSUdfTkVUREVWXzEwMDAwIGlzIG5vdCBzZXQN
CiMgQ09ORklHX1RSIGlzIG5vdCBzZXQNCg0KIw0KIyBXaXJlbGVzcyBMQU4NCiMNCiMgQ09ORklH
X1dMQU5fUFJFODAyMTEgaXMgbm90IHNldA0KIyBDT05GSUdfV0xBTl84MDIxMSBpcyBub3Qgc2V0
DQoNCiMNCiMgVVNCIE5ldHdvcmsgQWRhcHRlcnMNCiMNCkNPTkZJR19VU0JfQ0FUQz1tDQpDT05G
SUdfVVNCX0tBV0VUSD1tDQpDT05GSUdfVVNCX1BFR0FTVVM9bQ0KQ09ORklHX1VTQl9SVEw4MTUw
PW0NCkNPTkZJR19VU0JfVVNCTkVUPW0NCkNPTkZJR19VU0JfTkVUX0FYODgxN1g9bQ0KQ09ORklH
X1VTQl9ORVRfQ0RDRVRIRVI9bQ0KQ09ORklHX1VTQl9ORVRfRE05NjAxPW0NCkNPTkZJR19VU0Jf
TkVUX0dMNjIwQT1tDQpDT05GSUdfVVNCX05FVF9ORVQxMDgwPW0NCkNPTkZJR19VU0JfTkVUX1BM
VVNCPW0NCkNPTkZJR19VU0JfTkVUX01DUzc4MzA9bQ0KQ09ORklHX1VTQl9ORVRfUk5ESVNfSE9T
VD1tDQpDT05GSUdfVVNCX05FVF9DRENfU1VCU0VUPW0NCkNPTkZJR19VU0JfQUxJX001NjMyPXkN
CkNPTkZJR19VU0JfQU4yNzIwPXkNCkNPTkZJR19VU0JfQkVMS0lOPXkNCkNPTkZJR19VU0JfQVJN
TElOVVg9eQ0KQ09ORklHX1VTQl9FUFNPTjI4ODg9eQ0KQ09ORklHX1VTQl9LQzIxOTA9eQ0KQ09O
RklHX1VTQl9ORVRfWkFVUlVTPW0NCiMgQ09ORklHX1dBTiBpcyBub3Qgc2V0DQojIENPTkZJR19G
RERJIGlzIG5vdCBzZXQNCiMgQ09ORklHX0hJUFBJIGlzIG5vdCBzZXQNCiMgQ09ORklHX1BMSVAg
aXMgbm90IHNldA0KQ09ORklHX1BQUD1tDQpDT05GSUdfUFBQX01VTFRJTElOSz15DQpDT05GSUdf
UFBQX0ZJTFRFUj15DQpDT05GSUdfUFBQX0FTWU5DPW0NCkNPTkZJR19QUFBfU1lOQ19UVFk9bQ0K
Q09ORklHX1BQUF9ERUZMQVRFPW0NCkNPTkZJR19QUFBfQlNEQ09NUD1tDQpDT05GSUdfUFBQX01Q
UEU9bQ0KQ09ORklHX1BQUE9FPW0NCkNPTkZJR19QUFBPTDJUUD1tDQojIENPTkZJR19TTElQIGlz
IG5vdCBzZXQNCkNPTkZJR19TTEhDPW0NCiMgQ09ORklHX05FVF9GQyBpcyBub3Qgc2V0DQojIENP
TkZJR19TSEFQRVIgaXMgbm90IHNldA0KQ09ORklHX05FVENPTlNPTEU9bQ0KQ09ORklHX05FVENP
TlNPTEVfRFlOQU1JQz15DQpDT05GSUdfTkVUUE9MTD15DQpDT05GSUdfTkVUUE9MTF9UUkFQPXkN
CkNPTkZJR19ORVRfUE9MTF9DT05UUk9MTEVSPXkNCiMgQ09ORklHX0lTRE4gaXMgbm90IHNldA0K
IyBDT05GSUdfUEhPTkUgaXMgbm90IHNldA0KDQojDQojIElucHV0IGRldmljZSBzdXBwb3J0DQoj
DQpDT05GSUdfSU5QVVQ9eQ0KQ09ORklHX0lOUFVUX0ZGX01FTUxFU1M9bQ0KQ09ORklHX0lOUFVU
X1BPTExERVY9bQ0KDQojDQojIFVzZXJsYW5kIGludGVyZmFjZXMNCiMNCkNPTkZJR19JTlBVVF9N
T1VTRURFVj15DQojIENPTkZJR19JTlBVVF9NT1VTRURFVl9QU0FVWCBpcyBub3Qgc2V0DQpDT05G
SUdfSU5QVVRfTU9VU0VERVZfU0NSRUVOX1g9MTI4MA0KQ09ORklHX0lOUFVUX01PVVNFREVWX1ND
UkVFTl9ZPTEwMjQNCkNPTkZJR19JTlBVVF9KT1lERVY9bQ0KQ09ORklHX0lOUFVUX0VWREVWPW0N
CiMgQ09ORklHX0lOUFVUX0VWQlVHIGlzIG5vdCBzZXQNCg0KIw0KIyBJbnB1dCBEZXZpY2UgRHJp
dmVycw0KIw0KQ09ORklHX0lOUFVUX0tFWUJPQVJEPXkNCkNPTkZJR19LRVlCT0FSRF9BVEtCRD15
DQojIENPTkZJR19LRVlCT0FSRF9TVU5LQkQgaXMgbm90IHNldA0KIyBDT05GSUdfS0VZQk9BUkRf
TEtLQkQgaXMgbm90IHNldA0KIyBDT05GSUdfS0VZQk9BUkRfWFRLQkQgaXMgbm90IHNldA0KIyBD
T05GSUdfS0VZQk9BUkRfTkVXVE9OIGlzIG5vdCBzZXQNCiMgQ09ORklHX0tFWUJPQVJEX1NUT1dB
V0FZIGlzIG5vdCBzZXQNCkNPTkZJR19JTlBVVF9NT1VTRT15DQpDT05GSUdfTU9VU0VfUFMyPW0N
CkNPTkZJR19NT1VTRV9QUzJfQUxQUz15DQpDT05GSUdfTU9VU0VfUFMyX0xPR0lQUzJQUD15DQpD
T05GSUdfTU9VU0VfUFMyX1NZTkFQVElDUz15DQpDT05GSUdfTU9VU0VfUFMyX0xJRkVCT09LPXkN
CkNPTkZJR19NT1VTRV9QUzJfVFJBQ0tQT0lOVD15DQojIENPTkZJR19NT1VTRV9QUzJfVE9VQ0hL
SVQgaXMgbm90IHNldA0KIyBDT05GSUdfTU9VU0VfU0VSSUFMIGlzIG5vdCBzZXQNCkNPTkZJR19N
T1VTRV9BUFBMRVRPVUNIPW0NCiMgQ09ORklHX01PVVNFX1ZTWFhYQUEgaXMgbm90IHNldA0KIyBD
T05GSUdfSU5QVVRfSk9ZU1RJQ0sgaXMgbm90IHNldA0KIyBDT05GSUdfSU5QVVRfVEFCTEVUIGlz
IG5vdCBzZXQNCiMgQ09ORklHX0lOUFVUX1RPVUNIU0NSRUVOIGlzIG5vdCBzZXQNCkNPTkZJR19J
TlBVVF9NSVNDPXkNCkNPTkZJR19JTlBVVF9QQ1NQS1I9bQ0KIyBDT05GSUdfSU5QVVRfQVRMQVNf
QlROUyBpcyBub3Qgc2V0DQpDT05GSUdfSU5QVVRfQVRJX1JFTU9URT1tDQpDT05GSUdfSU5QVVRf
QVRJX1JFTU9URTI9bQ0KQ09ORklHX0lOUFVUX0tFWVNQQU5fUkVNT1RFPW0NCiMgQ09ORklHX0lO
UFVUX1BPV0VSTUFURSBpcyBub3Qgc2V0DQpDT05GSUdfSU5QVVRfWUVBTElOSz1tDQpDT05GSUdf
SU5QVVRfVUlOUFVUPW0NCg0KIw0KIyBIYXJkd2FyZSBJL08gcG9ydHMNCiMNCkNPTkZJR19TRVJJ
Tz15DQpDT05GSUdfU0VSSU9fSTgwNDI9eQ0KQ09ORklHX1NFUklPX1NFUlBPUlQ9eQ0KIyBDT05G
SUdfU0VSSU9fQ1Q4MkM3MTAgaXMgbm90IHNldA0KIyBDT05GSUdfU0VSSU9fUEFSS0JEIGlzIG5v
dCBzZXQNCiMgQ09ORklHX1NFUklPX1BDSVBTMiBpcyBub3Qgc2V0DQpDT05GSUdfU0VSSU9fTElC
UFMyPXkNCiMgQ09ORklHX1NFUklPX1JBVyBpcyBub3Qgc2V0DQojIENPTkZJR19HQU1FUE9SVCBp
cyBub3Qgc2V0DQoNCiMNCiMgQ2hhcmFjdGVyIGRldmljZXMNCiMNCkNPTkZJR19WVD15DQpDT05G
SUdfVlRfQ09OU09MRT15DQpDT05GSUdfSFdfQ09OU09MRT15DQojIENPTkZJR19WVF9IV19DT05T
T0xFX0JJTkRJTkcgaXMgbm90IHNldA0KIyBDT05GSUdfU0VSSUFMX05PTlNUQU5EQVJEIGlzIG5v
dCBzZXQNCg0KIw0KIyBTZXJpYWwgZHJpdmVycw0KIw0KQ09ORklHX1NFUklBTF84MjUwPXkNCkNP
TkZJR19TRVJJQUxfODI1MF9DT05TT0xFPXkNCkNPTkZJR19GSVhfRUFSTFlDT05fTUVNPXkNCkNP
TkZJR19TRVJJQUxfODI1MF9QQ0k9eQ0KQ09ORklHX1NFUklBTF84MjUwX1BOUD15DQpDT05GSUdf
U0VSSUFMXzgyNTBfTlJfVUFSVFM9Mg0KQ09ORklHX1NFUklBTF84MjUwX1JVTlRJTUVfVUFSVFM9
Mg0KIyBDT05GSUdfU0VSSUFMXzgyNTBfRVhURU5ERUQgaXMgbm90IHNldA0KDQojDQojIE5vbi04
MjUwIHNlcmlhbCBwb3J0IHN1cHBvcnQNCiMNCkNPTkZJR19TRVJJQUxfQ09SRT15DQpDT05GSUdf
U0VSSUFMX0NPUkVfQ09OU09MRT15DQojIENPTkZJR19TRVJJQUxfSlNNIGlzIG5vdCBzZXQNCkNP
TkZJR19VTklYOThfUFRZUz15DQpDT05GSUdfTEVHQUNZX1BUWVM9eQ0KQ09ORklHX0xFR0FDWV9Q
VFlfQ09VTlQ9MjU2DQpDT05GSUdfUFJJTlRFUj1tDQojIENPTkZJR19MUF9DT05TT0xFIGlzIG5v
dCBzZXQNCkNPTkZJR19QUERFVj1tDQojIENPTkZJR19JUE1JX0hBTkRMRVIgaXMgbm90IHNldA0K
IyBDT05GSUdfSFdfUkFORE9NIGlzIG5vdCBzZXQNCiMgQ09ORklHX05WUkFNIGlzIG5vdCBzZXQN
CkNPTkZJR19SVEM9eQ0KIyBDT05GSUdfUjM5NjQgaXMgbm90IHNldA0KIyBDT05GSUdfQVBQTElD
T00gaXMgbm90IHNldA0KIyBDT05GSUdfTVdBVkUgaXMgbm90IHNldA0KIyBDT05GSUdfUEM4NzM2
eF9HUElPIGlzIG5vdCBzZXQNCiMgQ09ORklHX1JBV19EUklWRVIgaXMgbm90IHNldA0KIyBDT05G
SUdfSFBFVCBpcyBub3Qgc2V0DQojIENPTkZJR19IQU5HQ0hFQ0tfVElNRVIgaXMgbm90IHNldA0K
IyBDT05GSUdfVENHX1RQTSBpcyBub3Qgc2V0DQojIENPTkZJR19URUxDTE9DSyBpcyBub3Qgc2V0
DQpDT05GSUdfREVWUE9SVD15DQpDT05GSUdfSTJDPW0NCkNPTkZJR19JMkNfQk9BUkRJTkZPPXkN
CkNPTkZJR19JMkNfQ0hBUkRFVj1tDQoNCiMNCiMgSTJDIEFsZ29yaXRobXMNCiMNCkNPTkZJR19J
MkNfQUxHT0JJVD1tDQpDT05GSUdfSTJDX0FMR09QQ0Y9bQ0KQ09ORklHX0kyQ19BTEdPUENBPW0N
Cg0KIw0KIyBJMkMgSGFyZHdhcmUgQnVzIHN1cHBvcnQNCiMNCiMgQ09ORklHX0kyQ19BTEkxNTM1
IGlzIG5vdCBzZXQNCiMgQ09ORklHX0kyQ19BTEkxNTYzIGlzIG5vdCBzZXQNCiMgQ09ORklHX0ky
Q19BTEkxNVgzIGlzIG5vdCBzZXQNCiMgQ09ORklHX0kyQ19BTUQ3NTYgaXMgbm90IHNldA0KIyBD
T05GSUdfSTJDX0FNRDgxMTEgaXMgbm90IHNldA0KIyBDT05GSUdfSTJDX0k4MDEgaXMgbm90IHNl
dA0KIyBDT05GSUdfSTJDX0k4MTAgaXMgbm90IHNldA0KIyBDT05GSUdfSTJDX1BJSVg0IGlzIG5v
dCBzZXQNCiMgQ09ORklHX0kyQ19ORk9SQ0UyIGlzIG5vdCBzZXQNCiMgQ09ORklHX0kyQ19PQ09S
RVMgaXMgbm90IHNldA0KIyBDT05GSUdfSTJDX1BBUlBPUlQgaXMgbm90IHNldA0KIyBDT05GSUdf
STJDX1BBUlBPUlRfTElHSFQgaXMgbm90IHNldA0KIyBDT05GSUdfSTJDX1BST1NBVkFHRSBpcyBu
b3Qgc2V0DQojIENPTkZJR19JMkNfU0FWQUdFNCBpcyBub3Qgc2V0DQpDT05GSUdfSTJDX1NJTVRF
Qz1tDQojIENPTkZJR19JMkNfU0lTNTU5NSBpcyBub3Qgc2V0DQojIENPTkZJR19JMkNfU0lTNjMw
IGlzIG5vdCBzZXQNCiMgQ09ORklHX0kyQ19TSVM5NlggaXMgbm90IHNldA0KIyBDT05GSUdfSTJD
X1RBT1NfRVZNIGlzIG5vdCBzZXQNCiMgQ09ORklHX0kyQ19TVFVCIGlzIG5vdCBzZXQNCkNPTkZJ
R19JMkNfVElOWV9VU0I9bQ0KIyBDT05GSUdfSTJDX1ZJQSBpcyBub3Qgc2V0DQpDT05GSUdfSTJD
X1ZJQVBSTz1tDQojIENPTkZJR19JMkNfVk9PRE9PMyBpcyBub3Qgc2V0DQoNCiMNCiMgTWlzY2Vs
bGFuZW91cyBJMkMgQ2hpcCBzdXBwb3J0DQojDQojIENPTkZJR19TRU5TT1JTX0RTMTMzNyBpcyBu
b3Qgc2V0DQojIENPTkZJR19TRU5TT1JTX0RTMTM3NCBpcyBub3Qgc2V0DQojIENPTkZJR19EUzE2
ODIgaXMgbm90IHNldA0KQ09ORklHX1NFTlNPUlNfRUVQUk9NPW0NCiMgQ09ORklHX1NFTlNPUlNf
UENGODU3NCBpcyBub3Qgc2V0DQojIENPTkZJR19TRU5TT1JTX1BDQTk1MzkgaXMgbm90IHNldA0K
IyBDT05GSUdfU0VOU09SU19QQ0Y4NTkxIGlzIG5vdCBzZXQNCiMgQ09ORklHX1NFTlNPUlNfTUFY
Njg3NSBpcyBub3Qgc2V0DQojIENPTkZJR19TRU5TT1JTX1RTTDI1NTAgaXMgbm90IHNldA0KIyBD
T05GSUdfSTJDX0RFQlVHX0NPUkUgaXMgbm90IHNldA0KIyBDT05GSUdfSTJDX0RFQlVHX0FMR08g
aXMgbm90IHNldA0KIyBDT05GSUdfSTJDX0RFQlVHX0JVUyBpcyBub3Qgc2V0DQojIENPTkZJR19J
MkNfREVCVUdfQ0hJUCBpcyBub3Qgc2V0DQoNCiMNCiMgU1BJIHN1cHBvcnQNCiMNCiMgQ09ORklH
X1NQSSBpcyBub3Qgc2V0DQojIENPTkZJR19TUElfTUFTVEVSIGlzIG5vdCBzZXQNCiMgQ09ORklH
X1cxIGlzIG5vdCBzZXQNCkNPTkZJR19QT1dFUl9TVVBQTFk9eQ0KIyBDT05GSUdfUE9XRVJfU1VQ
UExZX0RFQlVHIGlzIG5vdCBzZXQNCiMgQ09ORklHX1BEQV9QT1dFUiBpcyBub3Qgc2V0DQojIENP
TkZJR19CQVRURVJZX0RTMjc2MCBpcyBub3Qgc2V0DQpDT05GSUdfSFdNT049eQ0KQ09ORklHX0hX
TU9OX1ZJRD1tDQojIENPTkZJR19TRU5TT1JTX0FCSVRVR1VSVSBpcyBub3Qgc2V0DQojIENPTkZJ
R19TRU5TT1JTX0FCSVRVR1VSVTMgaXMgbm90IHNldA0KIyBDT05GSUdfU0VOU09SU19BRDc0MTgg
aXMgbm90IHNldA0KIyBDT05GSUdfU0VOU09SU19BRE0xMDIxIGlzIG5vdCBzZXQNCiMgQ09ORklH
X1NFTlNPUlNfQURNMTAyNSBpcyBub3Qgc2V0DQojIENPTkZJR19TRU5TT1JTX0FETTEwMjYgaXMg
bm90IHNldA0KIyBDT05GSUdfU0VOU09SU19BRE0xMDI5IGlzIG5vdCBzZXQNCiMgQ09ORklHX1NF
TlNPUlNfQURNMTAzMSBpcyBub3Qgc2V0DQojIENPTkZJR19TRU5TT1JTX0FETTkyNDAgaXMgbm90
IHNldA0KIyBDT05GSUdfU0VOU09SU19BRFQ3NDcwIGlzIG5vdCBzZXQNCkNPTkZJR19TRU5TT1JT
X0s4VEVNUD1tDQojIENPTkZJR19TRU5TT1JTX0FTQjEwMCBpcyBub3Qgc2V0DQojIENPTkZJR19T
RU5TT1JTX0FUWFAxIGlzIG5vdCBzZXQNCiMgQ09ORklHX1NFTlNPUlNfRFMxNjIxIGlzIG5vdCBz
ZXQNCiMgQ09ORklHX1NFTlNPUlNfSTVLX0FNQiBpcyBub3Qgc2V0DQojIENPTkZJR19TRU5TT1JT
X0Y3MTgwNUYgaXMgbm90IHNldA0KIyBDT05GSUdfU0VOU09SU19GNzE4ODJGRyBpcyBub3Qgc2V0
DQojIENPTkZJR19TRU5TT1JTX0Y3NTM3NVMgaXMgbm90IHNldA0KIyBDT05GSUdfU0VOU09SU19G
U0NIRVIgaXMgbm90IHNldA0KIyBDT05GSUdfU0VOU09SU19GU0NQT1MgaXMgbm90IHNldA0KIyBD
T05GSUdfU0VOU09SU19GU0NITUQgaXMgbm90IHNldA0KIyBDT05GSUdfU0VOU09SU19HTDUxOFNN
IGlzIG5vdCBzZXQNCiMgQ09ORklHX1NFTlNPUlNfR0w1MjBTTSBpcyBub3Qgc2V0DQojIENPTkZJ
R19TRU5TT1JTX0NPUkVURU1QIGlzIG5vdCBzZXQNCiMgQ09ORklHX1NFTlNPUlNfSVQ4NyBpcyBu
b3Qgc2V0DQojIENPTkZJR19TRU5TT1JTX0xNNjMgaXMgbm90IHNldA0KIyBDT05GSUdfU0VOU09S
U19MTTc1IGlzIG5vdCBzZXQNCiMgQ09ORklHX1NFTlNPUlNfTE03NyBpcyBub3Qgc2V0DQojIENP
TkZJR19TRU5TT1JTX0xNNzggaXMgbm90IHNldA0KIyBDT05GSUdfU0VOU09SU19MTTgwIGlzIG5v
dCBzZXQNCiMgQ09ORklHX1NFTlNPUlNfTE04MyBpcyBub3Qgc2V0DQojIENPTkZJR19TRU5TT1JT
X0xNODUgaXMgbm90IHNldA0KIyBDT05GSUdfU0VOU09SU19MTTg3IGlzIG5vdCBzZXQNCiMgQ09O
RklHX1NFTlNPUlNfTE05MCBpcyBub3Qgc2V0DQojIENPTkZJR19TRU5TT1JTX0xNOTIgaXMgbm90
IHNldA0KIyBDT05GSUdfU0VOU09SU19MTTkzIGlzIG5vdCBzZXQNCiMgQ09ORklHX1NFTlNPUlNf
TUFYMTYxOSBpcyBub3Qgc2V0DQojIENPTkZJR19TRU5TT1JTX01BWDY2NTAgaXMgbm90IHNldA0K
IyBDT05GSUdfU0VOU09SU19QQzg3MzYwIGlzIG5vdCBzZXQNCiMgQ09ORklHX1NFTlNPUlNfUEM4
NzQyNyBpcyBub3Qgc2V0DQojIENPTkZJR19TRU5TT1JTX1NJUzU1OTUgaXMgbm90IHNldA0KIyBD
T05GSUdfU0VOU09SU19ETUUxNzM3IGlzIG5vdCBzZXQNCiMgQ09ORklHX1NFTlNPUlNfU01TQzQ3
TTEgaXMgbm90IHNldA0KIyBDT05GSUdfU0VOU09SU19TTVNDNDdNMTkyIGlzIG5vdCBzZXQNCiMg
Q09ORklHX1NFTlNPUlNfU01TQzQ3QjM5NyBpcyBub3Qgc2V0DQojIENPTkZJR19TRU5TT1JTX1RI
TUM1MCBpcyBub3Qgc2V0DQojIENPTkZJR19TRU5TT1JTX1ZJQTY4NkEgaXMgbm90IHNldA0KIyBD
T05GSUdfU0VOU09SU19WVDEyMTEgaXMgbm90IHNldA0KIyBDT05GSUdfU0VOU09SU19WVDgyMzEg
aXMgbm90IHNldA0KQ09ORklHX1NFTlNPUlNfVzgzNzgxRD1tDQojIENPTkZJR19TRU5TT1JTX1c4
Mzc5MUQgaXMgbm90IHNldA0KIyBDT05GSUdfU0VOU09SU19XODM3OTJEIGlzIG5vdCBzZXQNCiMg
Q09ORklHX1NFTlNPUlNfVzgzNzkzIGlzIG5vdCBzZXQNCiMgQ09ORklHX1NFTlNPUlNfVzgzTDc4
NVRTIGlzIG5vdCBzZXQNCkNPTkZJR19TRU5TT1JTX1c4MzYyN0hGPW0NCiMgQ09ORklHX1NFTlNP
UlNfVzgzNjI3RUhGIGlzIG5vdCBzZXQNCiMgQ09ORklHX1NFTlNPUlNfSERBUFMgaXMgbm90IHNl
dA0KIyBDT05GSUdfU0VOU09SU19BUFBMRVNNQyBpcyBub3Qgc2V0DQojIENPTkZJR19IV01PTl9E
RUJVR19DSElQIGlzIG5vdCBzZXQNCiMgQ09ORklHX1dBVENIRE9HIGlzIG5vdCBzZXQNCg0KIw0K
IyBTb25pY3MgU2lsaWNvbiBCYWNrcGxhbmUNCiMNCkNPTkZJR19TU0JfUE9TU0lCTEU9eQ0KIyBD
T05GSUdfU1NCIGlzIG5vdCBzZXQNCg0KIw0KIyBNdWx0aWZ1bmN0aW9uIGRldmljZSBkcml2ZXJz
DQojDQojIENPTkZJR19NRkRfU001MDEgaXMgbm90IHNldA0KDQojDQojIE11bHRpbWVkaWEgZGV2
aWNlcw0KIw0KQ09ORklHX1ZJREVPX0RFVj1tDQpDT05GSUdfVklERU9fVjRMMT15DQpDT05GSUdf
VklERU9fVjRMMV9DT01QQVQ9eQ0KQ09ORklHX1ZJREVPX1Y0TDI9eQ0KQ09ORklHX1ZJREVPX0NB
UFRVUkVfRFJJVkVSUz15DQojIENPTkZJR19WSURFT19BRFZfREVCVUcgaXMgbm90IHNldA0KQ09O
RklHX1ZJREVPX0hFTFBFUl9DSElQU19BVVRPPXkNCkNPTkZJR19WSURFT19UVkFVRElPPW0NCkNP
TkZJR19WSURFT19UREE3NDMyPW0NCkNPTkZJR19WSURFT19UREE5ODc1PW0NCkNPTkZJR19WSURF
T19NU1AzNDAwPW0NCkNPTkZJR19WSURFT19DUzUzTDMyQT1tDQpDT05GSUdfVklERU9fV004Nzc1
PW0NCkNPTkZJR19WSURFT19XTTg3Mzk9bQ0KQ09ORklHX1ZJREVPX1ZQMjdTTVBYPW0NCkNPTkZJ
R19WSURFT19PVjc2NzA9bQ0KQ09ORklHX1ZJREVPX1NBQTcxMVg9bQ0KQ09ORklHX1ZJREVPX1RW
UDUxNTA9bQ0KQ09ORklHX1ZJREVPX0NYMjU4NDA9bQ0KQ09ORklHX1ZJREVPX0NYMjM0MVg9bQ0K
Q09ORklHX1ZJREVPX1NBQTcxMjc9bQ0KQ09ORklHX1ZJREVPX1VQRDY0MDMxQT1tDQpDT05GSUdf
VklERU9fVVBENjQwODM9bQ0KIyBDT05GSUdfVklERU9fVklWSSBpcyBub3Qgc2V0DQpDT05GSUdf
VklERU9fQlQ4NDg9bQ0KQ09ORklHX1ZJREVPX0JUODQ4X0RWQj15DQpDT05GSUdfVklERU9fU0FB
NjU4OD1tDQojIENPTkZJR19WSURFT19CV1FDQU0gaXMgbm90IHNldA0KIyBDT05GSUdfVklERU9f
Q1FDQU0gaXMgbm90IHNldA0KIyBDT05GSUdfVklERU9fVzk5NjYgaXMgbm90IHNldA0KIyBDT05G
SUdfVklERU9fQ1BJQSBpcyBub3Qgc2V0DQpDT05GSUdfVklERU9fQ1BJQTI9bQ0KIyBDT05GSUdf
VklERU9fU0FBNTI0NkEgaXMgbm90IHNldA0KIyBDT05GSUdfVklERU9fU0FBNTI0OSBpcyBub3Qg
c2V0DQojIENPTkZJR19UVU5FUl8zMDM2IGlzIG5vdCBzZXQNCiMgQ09ORklHX1ZJREVPX1NUUkFE
SVMgaXMgbm90IHNldA0KIyBDT05GSUdfVklERU9fWk9SQU4gaXMgbm90IHNldA0KQ09ORklHX1ZJ
REVPX1NBQTcxMzQ9bQ0KQ09ORklHX1ZJREVPX1NBQTcxMzRfQUxTQT1tDQpDT05GSUdfVklERU9f
U0FBNzEzNF9EVkI9bQ0KIyBDT05GSUdfVklERU9fTVhCIGlzIG5vdCBzZXQNCiMgQ09ORklHX1ZJ
REVPX0RQQyBpcyBub3Qgc2V0DQojIENPTkZJR19WSURFT19IRVhJVU1fT1JJT04gaXMgbm90IHNl
dA0KIyBDT05GSUdfVklERU9fSEVYSVVNX0dFTUlOSSBpcyBub3Qgc2V0DQpDT05GSUdfVklERU9f
Q1g4OD1tDQpDT05GSUdfVklERU9fQ1g4OF9BTFNBPW0NCkNPTkZJR19WSURFT19DWDg4X0JMQUNL
QklSRD1tDQpDT05GSUdfVklERU9fQ1g4OF9EVkI9bQ0KQ09ORklHX1ZJREVPX0NYODhfVlAzMDU0
PW0NCkNPTkZJR19WSURFT19DWDIzODg1PW0NCkNPTkZJR19WSURFT19JVlRWPW0NCkNPTkZJR19W
SURFT19DQUZFX0NDSUM9bQ0KQ09ORklHX1Y0TF9VU0JfRFJJVkVSUz15DQpDT05GSUdfVklERU9f
UFZSVVNCMj1tDQpDT05GSUdfVklERU9fUFZSVVNCMl8yOVhYWD15DQpDT05GSUdfVklERU9fUFZS
VVNCMl8yNFhYWD15DQpDT05GSUdfVklERU9fUFZSVVNCMl9TWVNGUz15DQojIENPTkZJR19WSURF
T19QVlJVU0IyX0RFQlVHSUZDIGlzIG5vdCBzZXQNCkNPTkZJR19WSURFT19FTTI4WFg9bQ0KQ09O
RklHX1ZJREVPX1VTQlZJU0lPTj1tDQpDT05GSUdfVklERU9fVVNCVklERU89bQ0KQ09ORklHX1VT
Ql9WSUNBTT1tDQpDT05GSUdfVVNCX0lCTUNBTT1tDQpDT05GSUdfVVNCX0tPTklDQVdDPW0NCkNP
TkZJR19VU0JfUVVJQ0tDQU1fTUVTU0VOR0VSPW0NCkNPTkZJR19VU0JfRVQ2MVgyNTE9bQ0KQ09O
RklHX1ZJREVPX09WQ0FNQ0hJUD1tDQpDT05GSUdfVVNCX1c5OTY4Q0Y9bQ0KQ09ORklHX1VTQl9P
VjUxMT1tDQpDT05GSUdfVVNCX1NFNDAxPW0NCkNPTkZJR19VU0JfU045QzEwMj1tDQpDT05GSUdf
VVNCX1NUVjY4MD1tDQpDT05GSUdfVVNCX1pDMDMwMT1tDQpDT05GSUdfVVNCX1BXQz1tDQojIENP
TkZJR19VU0JfUFdDX0RFQlVHIGlzIG5vdCBzZXQNCkNPTkZJR19VU0JfWlIzNjRYWD1tDQpDT05G
SUdfUkFESU9fQURBUFRFUlM9eQ0KIyBDT05GSUdfUkFESU9fR0VNVEVLX1BDSSBpcyBub3Qgc2V0
DQojIENPTkZJR19SQURJT19NQVhJUkFESU8gaXMgbm90IHNldA0KIyBDT05GSUdfUkFESU9fTUFF
U1RSTyBpcyBub3Qgc2V0DQpDT05GSUdfVVNCX0RTQlI9bQ0KQ09ORklHX0RWQl9DT1JFPW0NCkNP
TkZJR19EVkJfQ09SRV9BVFRBQ0g9eQ0KQ09ORklHX0RWQl9DQVBUVVJFX0RSSVZFUlM9eQ0KDQoj
DQojIFN1cHBvcnRlZCBTQUE3MTQ2IGJhc2VkIFBDSSBBZGFwdGVycw0KIw0KQ09ORklHX0RWQl9B
VjcxMTA9bQ0KQ09ORklHX0RWQl9BVjcxMTBfT1NEPXkNCkNPTkZJR19EVkJfQlVER0VUPW0NCkNP
TkZJR19EVkJfQlVER0VUX0NJPW0NCkNPTkZJR19EVkJfQlVER0VUX0FWPW0NCkNPTkZJR19EVkJf
QlVER0VUX1BBVENIPW0NCg0KIw0KIyBTdXBwb3J0ZWQgVVNCIEFkYXB0ZXJzDQojDQpDT05GSUdf
RFZCX1VTQj1tDQojIENPTkZJR19EVkJfVVNCX0RFQlVHIGlzIG5vdCBzZXQNCkNPTkZJR19EVkJf
VVNCX0E4MDA9bQ0KQ09ORklHX0RWQl9VU0JfRElCVVNCX01CPW0NCiMgQ09ORklHX0RWQl9VU0Jf
RElCVVNCX01CX0ZBVUxUWSBpcyBub3Qgc2V0DQpDT05GSUdfRFZCX1VTQl9ESUJVU0JfTUM9bQ0K
Q09ORklHX0RWQl9VU0JfRElCMDcwMD1tDQpDT05GSUdfRFZCX1VTQl9VTVRfMDEwPW0NCkNPTkZJ
R19EVkJfVVNCX0NYVVNCPW0NCkNPTkZJR19EVkJfVVNCX005MjBYPW0NCkNPTkZJR19EVkJfVVNC
X0dMODYxPW0NCkNPTkZJR19EVkJfVVNCX0FVNjYxMD1tDQpDT05GSUdfRFZCX1VTQl9ESUdJVFY9
bQ0KQ09ORklHX0RWQl9VU0JfVlA3MDQ1PW0NCkNPTkZJR19EVkJfVVNCX1ZQNzAyWD1tDQpDT05G
SUdfRFZCX1VTQl9HUDhQU0s9bQ0KQ09ORklHX0RWQl9VU0JfTk9WQV9UX1VTQjI9bQ0KQ09ORklH
X0RWQl9VU0JfVFRVU0IyPW0NCkNPTkZJR19EVkJfVVNCX0RUVDIwMFU9bQ0KQ09ORklHX0RWQl9V
U0JfT1BFUkExPW0NCkNPTkZJR19EVkJfVVNCX0FGOTAwNT1tDQpDT05GSUdfRFZCX1VTQl9BRjkw
MDVfUkVNT1RFPW0NCkNPTkZJR19EVkJfVFRVU0JfQlVER0VUPW0NCkNPTkZJR19EVkJfVFRVU0Jf
REVDPW0NCkNPTkZJR19EVkJfQ0lORVJHWVQyPW0NCiMgQ09ORklHX0RWQl9DSU5FUkdZVDJfVFVO
SU5HIGlzIG5vdCBzZXQNCg0KIw0KIyBTdXBwb3J0ZWQgRmxleENvcElJIChCMkMyKSBBZGFwdGVy
cw0KIw0KQ09ORklHX0RWQl9CMkMyX0ZMRVhDT1A9bQ0KQ09ORklHX0RWQl9CMkMyX0ZMRVhDT1Bf
UENJPW0NCkNPTkZJR19EVkJfQjJDMl9GTEVYQ09QX1VTQj1tDQojIENPTkZJR19EVkJfQjJDMl9G
TEVYQ09QX0RFQlVHIGlzIG5vdCBzZXQNCg0KIw0KIyBTdXBwb3J0ZWQgQlQ4NzggQWRhcHRlcnMN
CiMNCkNPTkZJR19EVkJfQlQ4WFg9bQ0KDQojDQojIFN1cHBvcnRlZCBQbHV0bzIgQWRhcHRlcnMN
CiMNCkNPTkZJR19EVkJfUExVVE8yPW0NCg0KIw0KIyBTdXBwb3J0ZWQgRFZCIEZyb250ZW5kcw0K
Iw0KDQojDQojIEN1c3RvbWlzZSBEVkIgRnJvbnRlbmRzDQojDQojIENPTkZJR19EVkJfRkVfQ1VT
VE9NSVNFIGlzIG5vdCBzZXQNCg0KIw0KIyBEVkItUyAoc2F0ZWxsaXRlKSBmcm9udGVuZHMNCiMN
CkNPTkZJR19EVkJfU1RWMDI5OT1tDQpDT05GSUdfRFZCX0NYMjQxMTA9bQ0KQ09ORklHX0RWQl9D
WDI0MTIzPW0NCkNPTkZJR19EVkJfVERBODA4Mz1tDQpDT05GSUdfRFZCX01UMzEyPW0NCkNPTkZJ
R19EVkJfVkVTMVg5Mz1tDQpDT05GSUdfRFZCX1M1SDE0MjA9bQ0KQ09ORklHX0RWQl9UREExMDA4
Nj1tDQoNCiMNCiMgRFZCLVQgKHRlcnJlc3RyaWFsKSBmcm9udGVuZHMNCiMNCkNPTkZJR19EVkJf
U1A4ODcwPW0NCkNPTkZJR19EVkJfU1A4ODdYPW0NCkNPTkZJR19EVkJfQ1gyMjcwMD1tDQpDT05G
SUdfRFZCX0NYMjI3MDI9bQ0KQ09ORklHX0RWQl9MNjQ3ODE9bQ0KQ09ORklHX0RWQl9UREExMDA0
WD1tDQpDT05GSUdfRFZCX05YVDYwMDA9bQ0KQ09ORklHX0RWQl9NVDM1Mj1tDQpDT05GSUdfRFZC
X1pMMTAzNTM9bQ0KQ09ORklHX0RWQl9ESUIzMDAwTUI9bQ0KQ09ORklHX0RWQl9ESUIzMDAwTUM9
bQ0KQ09ORklHX0RWQl9ESUI3MDAwTT1tDQpDT05GSUdfRFZCX0RJQjcwMDBQPW0NCg0KIw0KIyBE
VkItQyAoY2FibGUpIGZyb250ZW5kcw0KIw0KQ09ORklHX0RWQl9WRVMxODIwPW0NCkNPTkZJR19E
VkJfVERBMTAwMjE9bQ0KQ09ORklHX0RWQl9UREExMDAyMz1tDQpDT05GSUdfRFZCX1NUVjAyOTc9
bQ0KDQojDQojIEFUU0MgKE5vcnRoIEFtZXJpY2FuL0tvcmVhbiBUZXJyZXN0cmlhbC9DYWJsZSBE
VFYpIGZyb250ZW5kcw0KIw0KQ09ORklHX0RWQl9OWFQyMDBYPW0NCkNPTkZJR19EVkJfT1I1MTIx
MT1tDQpDT05GSUdfRFZCX09SNTExMzI9bQ0KQ09ORklHX0RWQl9CQ00zNTEwPW0NCkNPTkZJR19E
VkJfTEdEVDMzMFg9bQ0KQ09ORklHX0RWQl9TNUgxNDA5PW0NCg0KIw0KIyBUdW5lcnMvUExMIHN1
cHBvcnQNCiMNCkNPTkZJR19EVkJfUExMPW0NCkNPTkZJR19EVkJfVERBODI2WD1tDQpDT05GSUdf
RFZCX1REQTgyN1g9bQ0KQ09ORklHX0RWQl9UVU5FUl9RVDEwMTA9bQ0KQ09ORklHX0RWQl9UVU5F
Ul9NVDIwNjA9bQ0KQ09ORklHX0RWQl9UVU5FUl9NVDIyNjY9bQ0KQ09ORklHX0RWQl9UVU5FUl9N
VDIxMzE9bQ0KQ09ORklHX0RWQl9UVU5FUl9ESUIwMDcwPW0NCg0KIw0KIyBNaXNjZWxsYW5lb3Vz
IGRldmljZXMNCiMNCkNPTkZJR19EVkJfTE5CUDIxPW0NCkNPTkZJR19EVkJfSVNMNjQyMT1tDQpD
T05GSUdfRFZCX1RVQTYxMDA9bQ0KQ09ORklHX1ZJREVPX1NBQTcxNDY9bQ0KQ09ORklHX1ZJREVP
X1NBQTcxNDZfVlY9bQ0KQ09ORklHX1ZJREVPX1RVTkVSPW0NCiMgQ09ORklHX1ZJREVPX1RVTkVS
X0NVU1RPTUlaRSBpcyBub3Qgc2V0DQpDT05GSUdfVFVORVJfTVQyMFhYPW0NCkNPTkZJR19UVU5F
Ul9UREE4MjkwPW0NCkNPTkZJR19UVU5FUl9URUE1NzYxPW0NCkNPTkZJR19UVU5FUl9URUE1NzY3
PW0NCkNPTkZJR19UVU5FUl9TSU1QTEU9bQ0KQ09ORklHX1ZJREVPQlVGX0dFTj1tDQpDT05GSUdf
VklERU9CVUZfRE1BX1NHPW0NCkNPTkZJR19WSURFT0JVRl9EVkI9bQ0KQ09ORklHX1ZJREVPX0JU
Q1g9bQ0KQ09ORklHX1ZJREVPX0lSX0kyQz1tDQpDT05GSUdfVklERU9fSVI9bQ0KQ09ORklHX1ZJ
REVPX1RWRUVQUk9NPW0NCkNPTkZJR19EQUI9eQ0KQ09ORklHX1VTQl9EQUJVU0I9bQ0KDQojDQoj
IEdyYXBoaWNzIHN1cHBvcnQNCiMNCkNPTkZJR19BR1A9eQ0KQ09ORklHX0FHUF9BTUQ2ND15DQoj
IENPTkZJR19BR1BfSU5URUwgaXMgbm90IHNldA0KIyBDT05GSUdfQUdQX1NJUyBpcyBub3Qgc2V0
DQpDT05GSUdfQUdQX1ZJQT1tDQpDT05GSUdfRFJNPW0NCiMgQ09ORklHX0RSTV9UREZYIGlzIG5v
dCBzZXQNCiMgQ09ORklHX0RSTV9SMTI4IGlzIG5vdCBzZXQNCiMgQ09ORklHX0RSTV9SQURFT04g
aXMgbm90IHNldA0KIyBDT05GSUdfRFJNX01HQSBpcyBub3Qgc2V0DQojIENPTkZJR19EUk1fU0lT
IGlzIG5vdCBzZXQNCiMgQ09ORklHX0RSTV9WSUEgaXMgbm90IHNldA0KIyBDT05GSUdfRFJNX1NB
VkFHRSBpcyBub3Qgc2V0DQojIENPTkZJR19WR0FTVEFURSBpcyBub3Qgc2V0DQpDT05GSUdfVklE
RU9fT1VUUFVUX0NPTlRST0w9bQ0KIyBDT05GSUdfRkIgaXMgbm90IHNldA0KQ09ORklHX0JBQ0tM
SUdIVF9MQ0RfU1VQUE9SVD15DQpDT05GSUdfTENEX0NMQVNTX0RFVklDRT1tDQpDT05GSUdfQkFD
S0xJR0hUX0NMQVNTX0RFVklDRT1tDQojIENPTkZJR19CQUNLTElHSFRfQ09SR0kgaXMgbm90IHNl
dA0KIyBDT05GSUdfQkFDS0xJR0hUX1BST0dFQVIgaXMgbm90IHNldA0KDQojDQojIERpc3BsYXkg
ZGV2aWNlIHN1cHBvcnQNCiMNCiMgQ09ORklHX0RJU1BMQVlfU1VQUE9SVCBpcyBub3Qgc2V0DQoN
CiMNCiMgQ29uc29sZSBkaXNwbGF5IGRyaXZlciBzdXBwb3J0DQojDQpDT05GSUdfVkdBX0NPTlNP
TEU9eQ0KIyBDT05GSUdfVkdBQ09OX1NPRlRfU0NST0xMQkFDSyBpcyBub3Qgc2V0DQpDT05GSUdf
VklERU9fU0VMRUNUPXkNCkNPTkZJR19EVU1NWV9DT05TT0xFPXkNCkNPTkZJR19GT05UXzh4MTY9
eQ0KDQojDQojIFNvdW5kDQojDQpDT05GSUdfU09VTkQ9bQ0KDQojDQojIEFkdmFuY2VkIExpbnV4
IFNvdW5kIEFyY2hpdGVjdHVyZQ0KIw0KQ09ORklHX1NORD1tDQpDT05GSUdfU05EX1RJTUVSPW0N
CkNPTkZJR19TTkRfUENNPW0NCkNPTkZJR19TTkRfSFdERVA9bQ0KQ09ORklHX1NORF9SQVdNSURJ
PW0NCkNPTkZJR19TTkRfU0VRVUVOQ0VSPW0NCkNPTkZJR19TTkRfU0VRX0RVTU1ZPW0NCkNPTkZJ
R19TTkRfT1NTRU1VTD15DQpDT05GSUdfU05EX01JWEVSX09TUz1tDQpDT05GSUdfU05EX1BDTV9P
U1M9bQ0KQ09ORklHX1NORF9QQ01fT1NTX1BMVUdJTlM9eQ0KQ09ORklHX1NORF9TRVFVRU5DRVJf
T1NTPXkNCkNPTkZJR19TTkRfUlRDVElNRVI9bQ0KIyBDT05GSUdfU05EX1NFUV9SVENUSU1FUl9E
RUZBVUxUIGlzIG5vdCBzZXQNCkNPTkZJR19TTkRfRFlOQU1JQ19NSU5PUlM9eQ0KIyBDT05GSUdf
U05EX1NVUFBPUlRfT0xEX0FQSSBpcyBub3Qgc2V0DQpDT05GSUdfU05EX1ZFUkJPU0VfUFJPQ0ZT
PXkNCiMgQ09ORklHX1NORF9WRVJCT1NFX1BSSU5USyBpcyBub3Qgc2V0DQojIENPTkZJR19TTkRf
REVCVUcgaXMgbm90IHNldA0KDQojDQojIEdlbmVyaWMgZGV2aWNlcw0KIw0KQ09ORklHX1NORF9N
UFU0MDFfVUFSVD1tDQpDT05GSUdfU05EX0RVTU1ZPW0NCkNPTkZJR19TTkRfVklSTUlEST1tDQpD
T05GSUdfU05EX01UUEFWPW0NCiMgQ09ORklHX1NORF9NVFM2NCBpcyBub3Qgc2V0DQpDT05GSUdf
U05EX1NFUklBTF9VMTY1NTA9bQ0KQ09ORklHX1NORF9NUFU0MDE9bQ0KQ09ORklHX1NORF9QT1JU
TUFOMlg0PW0NCg0KIw0KIyBQQ0kgZGV2aWNlcw0KIw0KIyBDT05GSUdfU05EX0FEMTg4OSBpcyBu
b3Qgc2V0DQojIENPTkZJR19TTkRfQUxTMzAwIGlzIG5vdCBzZXQNCiMgQ09ORklHX1NORF9BTFM0
MDAwIGlzIG5vdCBzZXQNCiMgQ09ORklHX1NORF9BTEk1NDUxIGlzIG5vdCBzZXQNCiMgQ09ORklH
X1NORF9BVElJWFAgaXMgbm90IHNldA0KIyBDT05GSUdfU05EX0FUSUlYUF9NT0RFTSBpcyBub3Qg
c2V0DQojIENPTkZJR19TTkRfQVU4ODEwIGlzIG5vdCBzZXQNCiMgQ09ORklHX1NORF9BVTg4MjAg
aXMgbm90IHNldA0KIyBDT05GSUdfU05EX0FVODgzMCBpcyBub3Qgc2V0DQojIENPTkZJR19TTkRf
QVpUMzMyOCBpcyBub3Qgc2V0DQojIENPTkZJR19TTkRfQlQ4N1ggaXMgbm90IHNldA0KIyBDT05G
SUdfU05EX0NBMDEwNiBpcyBub3Qgc2V0DQojIENPTkZJR19TTkRfQ01JUENJIGlzIG5vdCBzZXQN
CiMgQ09ORklHX1NORF9DUzQyODEgaXMgbm90IHNldA0KIyBDT05GSUdfU05EX0NTNDZYWCBpcyBu
b3Qgc2V0DQojIENPTkZJR19TTkRfQ1M1NTMwIGlzIG5vdCBzZXQNCiMgQ09ORklHX1NORF9EQVJM
QTIwIGlzIG5vdCBzZXQNCiMgQ09ORklHX1NORF9HSU5BMjAgaXMgbm90IHNldA0KIyBDT05GSUdf
U05EX0xBWUxBMjAgaXMgbm90IHNldA0KIyBDT05GSUdfU05EX0RBUkxBMjQgaXMgbm90IHNldA0K
IyBDT05GSUdfU05EX0dJTkEyNCBpcyBub3Qgc2V0DQojIENPTkZJR19TTkRfTEFZTEEyNCBpcyBu
b3Qgc2V0DQojIENPTkZJR19TTkRfTU9OQSBpcyBub3Qgc2V0DQojIENPTkZJR19TTkRfTUlBIGlz
IG5vdCBzZXQNCiMgQ09ORklHX1NORF9FQ0hPM0cgaXMgbm90IHNldA0KIyBDT05GSUdfU05EX0lO
RElHTyBpcyBub3Qgc2V0DQojIENPTkZJR19TTkRfSU5ESUdPSU8gaXMgbm90IHNldA0KIyBDT05G
SUdfU05EX0lORElHT0RKIGlzIG5vdCBzZXQNCiMgQ09ORklHX1NORF9FTVUxMEsxIGlzIG5vdCBz
ZXQNCiMgQ09ORklHX1NORF9FTVUxMEsxWCBpcyBub3Qgc2V0DQojIENPTkZJR19TTkRfRU5TMTM3
MCBpcyBub3Qgc2V0DQojIENPTkZJR19TTkRfRU5TMTM3MSBpcyBub3Qgc2V0DQojIENPTkZJR19T
TkRfRVMxOTM4IGlzIG5vdCBzZXQNCiMgQ09ORklHX1NORF9FUzE5NjggaXMgbm90IHNldA0KIyBD
T05GSUdfU05EX0ZNODAxIGlzIG5vdCBzZXQNCkNPTkZJR19TTkRfSERBX0lOVEVMPW0NCkNPTkZJ
R19TTkRfSERBX0hXREVQPXkNCkNPTkZJR19TTkRfSERBX0NPREVDX1JFQUxURUs9eQ0KQ09ORklH
X1NORF9IREFfQ09ERUNfQU5BTE9HPXkNCkNPTkZJR19TTkRfSERBX0NPREVDX1NJR01BVEVMPXkN
CkNPTkZJR19TTkRfSERBX0NPREVDX1ZJQT15DQpDT05GSUdfU05EX0hEQV9DT0RFQ19BVElIRE1J
PXkNCkNPTkZJR19TTkRfSERBX0NPREVDX0NPTkVYQU5UPXkNCkNPTkZJR19TTkRfSERBX0NPREVD
X0NNRURJQT15DQpDT05GSUdfU05EX0hEQV9DT0RFQ19TSTMwNTQ9eQ0KQ09ORklHX1NORF9IREFf
R0VORVJJQz15DQojIENPTkZJR19TTkRfSERBX1BPV0VSX1NBVkUgaXMgbm90IHNldA0KIyBDT05G
SUdfU05EX0hEU1AgaXMgbm90IHNldA0KIyBDT05GSUdfU05EX0hEU1BNIGlzIG5vdCBzZXQNCiMg
Q09ORklHX1NORF9JQ0UxNzEyIGlzIG5vdCBzZXQNCiMgQ09ORklHX1NORF9JQ0UxNzI0IGlzIG5v
dCBzZXQNCiMgQ09ORklHX1NORF9JTlRFTDhYMCBpcyBub3Qgc2V0DQojIENPTkZJR19TTkRfSU5U
RUw4WDBNIGlzIG5vdCBzZXQNCiMgQ09ORklHX1NORF9LT1JHMTIxMiBpcyBub3Qgc2V0DQojIENP
TkZJR19TTkRfTUFFU1RSTzMgaXMgbm90IHNldA0KIyBDT05GSUdfU05EX01JWEFSVCBpcyBub3Qg
c2V0DQojIENPTkZJR19TTkRfTk0yNTYgaXMgbm90IHNldA0KIyBDT05GSUdfU05EX1BDWEhSIGlz
IG5vdCBzZXQNCiMgQ09ORklHX1NORF9SSVBUSURFIGlzIG5vdCBzZXQNCiMgQ09ORklHX1NORF9S
TUUzMiBpcyBub3Qgc2V0DQojIENPTkZJR19TTkRfUk1FOTYgaXMgbm90IHNldA0KIyBDT05GSUdf
U05EX1JNRTk2NTIgaXMgbm90IHNldA0KIyBDT05GSUdfU05EX1NPTklDVklCRVMgaXMgbm90IHNl
dA0KIyBDT05GSUdfU05EX1RSSURFTlQgaXMgbm90IHNldA0KIyBDT05GSUdfU05EX1ZJQTgyWFgg
aXMgbm90IHNldA0KIyBDT05GSUdfU05EX1ZJQTgyWFhfTU9ERU0gaXMgbm90IHNldA0KIyBDT05G
SUdfU05EX1ZYMjIyIGlzIG5vdCBzZXQNCiMgQ09ORklHX1NORF9ZTUZQQ0kgaXMgbm90IHNldA0K
DQojDQojIFVTQiBkZXZpY2VzDQojDQpDT05GSUdfU05EX1VTQl9BVURJTz1tDQpDT05GSUdfU05E
X1VTQl9VU1gyWT1tDQpDT05GSUdfU05EX1VTQl9DQUlBUT1tDQpDT05GSUdfU05EX1VTQl9DQUlB
UV9JTlBVVD15DQoNCiMNCiMgU3lzdGVtIG9uIENoaXAgYXVkaW8gc3VwcG9ydA0KIw0KIyBDT05G
SUdfU05EX1NPQyBpcyBub3Qgc2V0DQoNCiMNCiMgU29DIEF1ZGlvIHN1cHBvcnQgZm9yIFN1cGVy
SA0KIw0KDQojDQojIE9wZW4gU291bmQgU3lzdGVtDQojDQojIENPTkZJR19TT1VORF9QUklNRSBp
cyBub3Qgc2V0DQpDT05GSUdfSElEX1NVUFBPUlQ9eQ0KQ09ORklHX0hJRD1tDQojIENPTkZJR19I
SURfREVCVUcgaXMgbm90IHNldA0KIyBDT05GSUdfSElEUkFXIGlzIG5vdCBzZXQNCg0KIw0KIyBV
U0IgSW5wdXQgRGV2aWNlcw0KIw0KQ09ORklHX1VTQl9ISUQ9bQ0KIyBDT05GSUdfVVNCX0hJRElO
UFVUX1BPV0VSQk9PSyBpcyBub3Qgc2V0DQpDT05GSUdfSElEX0ZGPXkNCkNPTkZJR19ISURfUElE
PXkNCkNPTkZJR19MT0dJVEVDSF9GRj15DQpDT05GSUdfUEFOVEhFUkxPUkRfRkY9eQ0KQ09ORklH
X1RIUlVTVE1BU1RFUl9GRj15DQpDT05GSUdfWkVST1BMVVNfRkY9eQ0KQ09ORklHX1VTQl9ISURE
RVY9eQ0KDQojDQojIFVTQiBISUQgQm9vdCBQcm90b2NvbCBkcml2ZXJzDQojDQpDT05GSUdfVVNC
X0tCRD1tDQpDT05GSUdfVVNCX01PVVNFPW0NCkNPTkZJR19VU0JfU1VQUE9SVD15DQpDT05GSUdf
VVNCX0FSQ0hfSEFTX0hDRD15DQpDT05GSUdfVVNCX0FSQ0hfSEFTX09IQ0k9eQ0KQ09ORklHX1VT
Ql9BUkNIX0hBU19FSENJPXkNCkNPTkZJR19VU0I9bQ0KIyBDT05GSUdfVVNCX0RFQlVHIGlzIG5v
dCBzZXQNCg0KIw0KIyBNaXNjZWxsYW5lb3VzIFVTQiBvcHRpb25zDQojDQpDT05GSUdfVVNCX0RF
VklDRUZTPXkNCkNPTkZJR19VU0JfREVWSUNFX0NMQVNTPXkNCkNPTkZJR19VU0JfRFlOQU1JQ19N
SU5PUlM9eQ0KQ09ORklHX1VTQl9TVVNQRU5EPXkNCiMgQ09ORklHX1VTQl9QRVJTSVNUIGlzIG5v
dCBzZXQNCiMgQ09ORklHX1VTQl9PVEcgaXMgbm90IHNldA0KDQojDQojIFVTQiBIb3N0IENvbnRy
b2xsZXIgRHJpdmVycw0KIw0KQ09ORklHX1VTQl9FSENJX0hDRD1tDQpDT05GSUdfVVNCX0VIQ0lf
U1BMSVRfSVNPPXkNCkNPTkZJR19VU0JfRUhDSV9ST09UX0hVQl9UVD15DQpDT05GSUdfVVNCX0VI
Q0lfVFRfTkVXU0NIRUQ9eQ0KIyBDT05GSUdfVVNCX0lTUDExNlhfSENEIGlzIG5vdCBzZXQNCkNP
TkZJR19VU0JfT0hDSV9IQ0Q9bQ0KIyBDT05GSUdfVVNCX09IQ0lfQklHX0VORElBTl9ERVNDIGlz
IG5vdCBzZXQNCiMgQ09ORklHX1VTQl9PSENJX0JJR19FTkRJQU5fTU1JTyBpcyBub3Qgc2V0DQpD
T05GSUdfVVNCX09IQ0lfTElUVExFX0VORElBTj15DQojIENPTkZJR19VU0JfVUhDSV9IQ0QgaXMg
bm90IHNldA0KIyBDT05GSUdfVVNCX1NMODExX0hDRCBpcyBub3Qgc2V0DQojIENPTkZJR19VU0Jf
UjhBNjY1OTdfSENEIGlzIG5vdCBzZXQNCg0KIw0KIyBVU0IgRGV2aWNlIENsYXNzIGRyaXZlcnMN
CiMNCkNPTkZJR19VU0JfQUNNPW0NCkNPTkZJR19VU0JfUFJJTlRFUj1tDQoNCiMNCiMgTk9URTog
VVNCX1NUT1JBR0UgZW5hYmxlcyBTQ1NJLCBhbmQgJ1NDU0kgZGlzayBzdXBwb3J0Jw0KIw0KDQoj
DQojIG1heSBhbHNvIGJlIG5lZWRlZDsgc2VlIFVTQl9TVE9SQUdFIEhlbHAgZm9yIG1vcmUgaW5m
b3JtYXRpb24NCiMNCkNPTkZJR19VU0JfU1RPUkFHRT1tDQojIENPTkZJR19VU0JfU1RPUkFHRV9E
RUJVRyBpcyBub3Qgc2V0DQpDT05GSUdfVVNCX1NUT1JBR0VfREFUQUZBQj15DQpDT05GSUdfVVNC
X1NUT1JBR0VfRlJFRUNPTT15DQpDT05GSUdfVVNCX1NUT1JBR0VfSVNEMjAwPXkNCkNPTkZJR19V
U0JfU1RPUkFHRV9EUENNPXkNCkNPTkZJR19VU0JfU1RPUkFHRV9VU0JBVD15DQpDT05GSUdfVVNC
X1NUT1JBR0VfU0REUjA5PXkNCkNPTkZJR19VU0JfU1RPUkFHRV9TRERSNTU9eQ0KQ09ORklHX1VT
Ql9TVE9SQUdFX0pVTVBTSE9UPXkNCkNPTkZJR19VU0JfU1RPUkFHRV9BTEFVREE9eQ0KQ09ORklH
X1VTQl9TVE9SQUdFX0tBUk1BPXkNCiMgQ09ORklHX1VTQl9MSUJVU1VBTCBpcyBub3Qgc2V0DQoN
CiMNCiMgVVNCIEltYWdpbmcgZGV2aWNlcw0KIw0KQ09ORklHX1VTQl9NREM4MDA9bQ0KQ09ORklH
X1VTQl9NSUNST1RFSz1tDQpDT05GSUdfVVNCX01PTj15DQoNCiMNCiMgVVNCIHBvcnQgZHJpdmVy
cw0KIw0KQ09ORklHX1VTQl9VU1M3MjA9bQ0KDQojDQojIFVTQiBTZXJpYWwgQ29udmVydGVyIHN1
cHBvcnQNCiMNCkNPTkZJR19VU0JfU0VSSUFMPW0NCkNPTkZJR19VU0JfU0VSSUFMX0dFTkVSSUM9
eQ0KQ09ORklHX1VTQl9TRVJJQUxfQUlSQ0FCTEU9bQ0KIyBDT05GSUdfVVNCX1NFUklBTF9BSVJQ
UklNRSBpcyBub3Qgc2V0DQojIENPTkZJR19VU0JfU0VSSUFMX0FSSzMxMTYgaXMgbm90IHNldA0K
IyBDT05GSUdfVVNCX1NFUklBTF9CRUxLSU4gaXMgbm90IHNldA0KQ09ORklHX1VTQl9TRVJJQUxf
Q0gzNDE9bQ0KIyBDT05GSUdfVVNCX1NFUklBTF9XSElURUhFQVQgaXMgbm90IHNldA0KIyBDT05G
SUdfVVNCX1NFUklBTF9ESUdJX0FDQ0VMRVBPUlQgaXMgbm90IHNldA0KIyBDT05GSUdfVVNCX1NF
UklBTF9DUDIxMDEgaXMgbm90IHNldA0KIyBDT05GSUdfVVNCX1NFUklBTF9DWVBSRVNTX004IGlz
IG5vdCBzZXQNCiMgQ09ORklHX1VTQl9TRVJJQUxfRU1QRUcgaXMgbm90IHNldA0KIyBDT05GSUdf
VVNCX1NFUklBTF9GVERJX1NJTyBpcyBub3Qgc2V0DQojIENPTkZJR19VU0JfU0VSSUFMX0ZVTlNP
RlQgaXMgbm90IHNldA0KQ09ORklHX1VTQl9TRVJJQUxfVklTT1I9bQ0KIyBDT05GSUdfVVNCX1NF
UklBTF9JUEFRIGlzIG5vdCBzZXQNCiMgQ09ORklHX1VTQl9TRVJJQUxfSVIgaXMgbm90IHNldA0K
IyBDT05GSUdfVVNCX1NFUklBTF9FREdFUE9SVCBpcyBub3Qgc2V0DQojIENPTkZJR19VU0JfU0VS
SUFMX0VER0VQT1JUX1RJIGlzIG5vdCBzZXQNCiMgQ09ORklHX1VTQl9TRVJJQUxfR0FSTUlOIGlz
IG5vdCBzZXQNCiMgQ09ORklHX1VTQl9TRVJJQUxfSVBXIGlzIG5vdCBzZXQNCiMgQ09ORklHX1VT
Ql9TRVJJQUxfS0VZU1BBTl9QREEgaXMgbm90IHNldA0KIyBDT05GSUdfVVNCX1NFUklBTF9LRVlT
UEFOIGlzIG5vdCBzZXQNCiMgQ09ORklHX1VTQl9TRVJJQUxfS0xTSSBpcyBub3Qgc2V0DQojIENP
TkZJR19VU0JfU0VSSUFMX0tPQklMX1NDVCBpcyBub3Qgc2V0DQojIENPTkZJR19VU0JfU0VSSUFM
X01DVF9VMjMyIGlzIG5vdCBzZXQNCkNPTkZJR19VU0JfU0VSSUFMX01PUzc3MjA9bQ0KQ09ORklH
X1VTQl9TRVJJQUxfTU9TNzg0MD1tDQojIENPTkZJR19VU0JfU0VSSUFMX05BVk1BTiBpcyBub3Qg
c2V0DQojIENPTkZJR19VU0JfU0VSSUFMX1BMMjMwMyBpcyBub3Qgc2V0DQpDT05GSUdfVVNCX1NF
UklBTF9PVEk2ODU4PW0NCiMgQ09ORklHX1VTQl9TRVJJQUxfSFA0WCBpcyBub3Qgc2V0DQojIENP
TkZJR19VU0JfU0VSSUFMX1NBRkUgaXMgbm90IHNldA0KQ09ORklHX1VTQl9TRVJJQUxfU0lFUlJB
V0lSRUxFU1M9bQ0KIyBDT05GSUdfVVNCX1NFUklBTF9USSBpcyBub3Qgc2V0DQojIENPTkZJR19V
U0JfU0VSSUFMX0NZQkVSSkFDSyBpcyBub3Qgc2V0DQojIENPTkZJR19VU0JfU0VSSUFMX1hJUkNP
TSBpcyBub3Qgc2V0DQpDT05GSUdfVVNCX1NFUklBTF9PUFRJT049bQ0KIyBDT05GSUdfVVNCX1NF
UklBTF9PTU5JTkVUIGlzIG5vdCBzZXQNCiMgQ09ORklHX1VTQl9TRVJJQUxfREVCVUcgaXMgbm90
IHNldA0KDQojDQojIFVTQiBNaXNjZWxsYW5lb3VzIGRyaXZlcnMNCiMNCkNPTkZJR19VU0JfRU1J
NjI9bQ0KQ09ORklHX1VTQl9FTUkyNj1tDQpDT05GSUdfVVNCX0FEVVRVWD1tDQpDT05GSUdfVVNC
X0FVRVJTV0FMRD1tDQpDT05GSUdfVVNCX1JJTzUwMD1tDQpDT05GSUdfVVNCX0xFR09UT1dFUj1t
DQpDT05GSUdfVVNCX0xDRD1tDQpDT05GSUdfVVNCX0JFUlJZX0NIQVJHRT1tDQpDT05GSUdfVVNC
X0xFRD1tDQpDT05GSUdfVVNCX0NZUFJFU1NfQ1k3QzYzPW0NCkNPTkZJR19VU0JfQ1lUSEVSTT1t
DQojIENPTkZJR19VU0JfUEhJREdFVCBpcyBub3Qgc2V0DQpDT05GSUdfVVNCX0lETU9VU0U9bQ0K
IyBDT05GSUdfVVNCX0ZURElfRUxBTiBpcyBub3Qgc2V0DQpDT05GSUdfVVNCX0FQUExFRElTUExB
WT1tDQpDT05GSUdfVVNCX1NJU1VTQlZHQT1tDQpDT05GSUdfVVNCX1NJU1VTQlZHQV9DT049eQ0K
Q09ORklHX1VTQl9MRD1tDQojIENPTkZJR19VU0JfVFJBTkNFVklCUkFUT1IgaXMgbm90IHNldA0K
Q09ORklHX1VTQl9JT1dBUlJJT1I9bQ0KIyBDT05GSUdfVVNCX1RFU1QgaXMgbm90IHNldA0KDQoj
DQojIFVTQiBEU0wgbW9kZW0gc3VwcG9ydA0KIw0KDQojDQojIFVTQiBHYWRnZXQgU3VwcG9ydA0K
Iw0KIyBDT05GSUdfVVNCX0dBREdFVCBpcyBub3Qgc2V0DQojIENPTkZJR19NTUMgaXMgbm90IHNl
dA0KIyBDT05GSUdfTkVXX0xFRFMgaXMgbm90IHNldA0KIyBDT05GSUdfSU5GSU5JQkFORCBpcyBu
b3Qgc2V0DQojIENPTkZJR19FREFDIGlzIG5vdCBzZXQNCiMgQ09ORklHX1JUQ19DTEFTUyBpcyBu
b3Qgc2V0DQojIENPTkZJR19ETUFERVZJQ0VTIGlzIG5vdCBzZXQNCiMgQ09ORklHX0FVWERJU1BM
QVkgaXMgbm90IHNldA0KQ09ORklHX1ZJUlRVQUxJWkFUSU9OPXkNCkNPTkZJR19LVk09bQ0KIyBD
T05GSUdfS1ZNX0lOVEVMIGlzIG5vdCBzZXQNCkNPTkZJR19LVk1fQU1EPW0NCg0KIw0KIyBVc2Vy
c3BhY2UgSS9PDQojDQpDT05GSUdfVUlPPW0NCkNPTkZJR19VSU9fQ0lGPW0NCg0KIw0KIyBGaXJt
d2FyZSBEcml2ZXJzDQojDQpDT05GSUdfRUREPXkNCiMgQ09ORklHX0RFTExfUkJVIGlzIG5vdCBz
ZXQNCiMgQ09ORklHX0RDREJBUyBpcyBub3Qgc2V0DQpDT05GSUdfRE1JSUQ9eQ0KDQojDQojIEZp
bGUgc3lzdGVtcw0KIw0KQ09ORklHX0VYVDJfRlM9bQ0KQ09ORklHX0VYVDJfRlNfWEFUVFI9eQ0K
IyBDT05GSUdfRVhUMl9GU19QT1NJWF9BQ0wgaXMgbm90IHNldA0KIyBDT05GSUdfRVhUMl9GU19T
RUNVUklUWSBpcyBub3Qgc2V0DQojIENPTkZJR19FWFQyX0ZTX1hJUCBpcyBub3Qgc2V0DQpDT05G
SUdfRVhUM19GUz1tDQpDT05GSUdfRVhUM19GU19YQVRUUj15DQpDT05GSUdfRVhUM19GU19QT1NJ
WF9BQ0w9eQ0KQ09ORklHX0VYVDNfRlNfU0VDVVJJVFk9eQ0KQ09ORklHX0VYVDRERVZfRlM9bQ0K
Q09ORklHX0VYVDRERVZfRlNfWEFUVFI9eQ0KQ09ORklHX0VYVDRERVZfRlNfUE9TSVhfQUNMPXkN
CkNPTkZJR19FWFQ0REVWX0ZTX1NFQ1VSSVRZPXkNCkNPTkZJR19KQkQ9bQ0KIyBDT05GSUdfSkJE
X0RFQlVHIGlzIG5vdCBzZXQNCkNPTkZJR19KQkQyPW0NCiMgQ09ORklHX0pCRDJfREVCVUcgaXMg
bm90IHNldA0KQ09ORklHX0ZTX01CQ0FDSEU9bQ0KQ09ORklHX1JFSVNFUkZTX0ZTPW0NCiMgQ09O
RklHX1JFSVNFUkZTX0NIRUNLIGlzIG5vdCBzZXQNCiMgQ09ORklHX1JFSVNFUkZTX1BST0NfSU5G
TyBpcyBub3Qgc2V0DQpDT05GSUdfUkVJU0VSRlNfRlNfWEFUVFI9eQ0KIyBDT05GSUdfUkVJU0VS
RlNfRlNfUE9TSVhfQUNMIGlzIG5vdCBzZXQNCiMgQ09ORklHX1JFSVNFUkZTX0ZTX1NFQ1VSSVRZ
IGlzIG5vdCBzZXQNCiMgQ09ORklHX0pGU19GUyBpcyBub3Qgc2V0DQpDT05GSUdfRlNfUE9TSVhf
QUNMPXkNCiMgQ09ORklHX1hGU19GUyBpcyBub3Qgc2V0DQojIENPTkZJR19HRlMyX0ZTIGlzIG5v
dCBzZXQNCiMgQ09ORklHX09DRlMyX0ZTIGlzIG5vdCBzZXQNCiMgQ09ORklHX01JTklYX0ZTIGlz
IG5vdCBzZXQNCiMgQ09ORklHX1JPTUZTX0ZTIGlzIG5vdCBzZXQNCkNPTkZJR19JTk9USUZZPXkN
CkNPTkZJR19JTk9USUZZX1VTRVI9eQ0KIyBDT05GSUdfUVVPVEEgaXMgbm90IHNldA0KQ09ORklH
X0ROT1RJRlk9eQ0KIyBDT05GSUdfQVVUT0ZTX0ZTIGlzIG5vdCBzZXQNCkNPTkZJR19BVVRPRlM0
X0ZTPW0NCkNPTkZJR19GVVNFX0ZTPW0NCg0KIw0KIyBDRC1ST00vRFZEIEZpbGVzeXN0ZW1zDQoj
DQpDT05GSUdfSVNPOTY2MF9GUz1tDQpDT05GSUdfSk9MSUVUPXkNCkNPTkZJR19aSVNPRlM9eQ0K
Q09ORklHX1VERl9GUz1tDQpDT05GSUdfVURGX05MUz15DQoNCiMNCiMgRE9TL0ZBVC9OVCBGaWxl
c3lzdGVtcw0KIw0KQ09ORklHX0ZBVF9GUz1tDQpDT05GSUdfTVNET1NfRlM9bQ0KQ09ORklHX1ZG
QVRfRlM9bQ0KQ09ORklHX0ZBVF9ERUZBVUxUX0NPREVQQUdFPTQzNw0KQ09ORklHX0ZBVF9ERUZB
VUxUX0lPQ0hBUlNFVD0iaXNvODg1OS0xIg0KIyBDT05GSUdfTlRGU19GUyBpcyBub3Qgc2V0DQoN
CiMNCiMgUHNldWRvIGZpbGVzeXN0ZW1zDQojDQpDT05GSUdfUFJPQ19GUz15DQpDT05GSUdfUFJP
Q19LQ09SRT15DQpDT05GSUdfUFJPQ19WTUNPUkU9eQ0KQ09ORklHX1BST0NfU1lTQ1RMPXkNCkNP
TkZJR19TWVNGUz15DQpDT05GSUdfVE1QRlM9eQ0KIyBDT05GSUdfVE1QRlNfUE9TSVhfQUNMIGlz
IG5vdCBzZXQNCiMgQ09ORklHX0hVR0VUTEJGUyBpcyBub3Qgc2V0DQojIENPTkZJR19IVUdFVExC
X1BBR0UgaXMgbm90IHNldA0KQ09ORklHX0NPTkZJR0ZTX0ZTPW0NCg0KIw0KIyBNaXNjZWxsYW5l
b3VzIGZpbGVzeXN0ZW1zDQojDQojIENPTkZJR19BREZTX0ZTIGlzIG5vdCBzZXQNCiMgQ09ORklH
X0FGRlNfRlMgaXMgbm90IHNldA0KQ09ORklHX0VDUllQVF9GUz1tDQojIENPTkZJR19IRlNfRlMg
aXMgbm90IHNldA0KIyBDT05GSUdfSEZTUExVU19GUyBpcyBub3Qgc2V0DQojIENPTkZJR19CRUZT
X0ZTIGlzIG5vdCBzZXQNCiMgQ09ORklHX0JGU19GUyBpcyBub3Qgc2V0DQojIENPTkZJR19FRlNf
RlMgaXMgbm90IHNldA0KQ09ORklHX0NSQU1GUz15DQojIENPTkZJR19WWEZTX0ZTIGlzIG5vdCBz
ZXQNCiMgQ09ORklHX0hQRlNfRlMgaXMgbm90IHNldA0KIyBDT05GSUdfUU5YNEZTX0ZTIGlzIG5v
dCBzZXQNCiMgQ09ORklHX1NZU1ZfRlMgaXMgbm90IHNldA0KIyBDT05GSUdfVUZTX0ZTIGlzIG5v
dCBzZXQNCkNPTkZJR19ORVRXT1JLX0ZJTEVTWVNURU1TPXkNCkNPTkZJR19ORlNfRlM9bQ0KQ09O
RklHX05GU19WMz15DQpDT05GSUdfTkZTX1YzX0FDTD15DQpDT05GSUdfTkZTX1Y0PXkNCiMgQ09O
RklHX05GU19ESVJFQ1RJTyBpcyBub3Qgc2V0DQpDT05GSUdfTkZTRD1tDQpDT05GSUdfTkZTRF9W
Ml9BQ0w9eQ0KQ09ORklHX05GU0RfVjM9eQ0KQ09ORklHX05GU0RfVjNfQUNMPXkNCkNPTkZJR19O
RlNEX1Y0PXkNCkNPTkZJR19ORlNEX1RDUD15DQpDT05GSUdfTE9DS0Q9bQ0KQ09ORklHX0xPQ0tE
X1Y0PXkNCkNPTkZJR19FWFBPUlRGUz1tDQpDT05GSUdfTkZTX0FDTF9TVVBQT1JUPW0NCkNPTkZJ
R19ORlNfQ09NTU9OPXkNCkNPTkZJR19TVU5SUEM9bQ0KQ09ORklHX1NVTlJQQ19HU1M9bQ0KQ09O
RklHX1NVTlJQQ19CSU5EMzQ9eQ0KQ09ORklHX1JQQ1NFQ19HU1NfS1JCNT1tDQpDT05GSUdfUlBD
U0VDX0dTU19TUEtNMz1tDQojIENPTkZJR19TTUJfRlMgaXMgbm90IHNldA0KQ09ORklHX0NJRlM9
bQ0KIyBDT05GSUdfQ0lGU19TVEFUUyBpcyBub3Qgc2V0DQojIENPTkZJR19DSUZTX1dFQUtfUFdf
SEFTSCBpcyBub3Qgc2V0DQpDT05GSUdfQ0lGU19YQVRUUj15DQpDT05GSUdfQ0lGU19QT1NJWD15
DQojIENPTkZJR19DSUZTX0RFQlVHMiBpcyBub3Qgc2V0DQpDT05GSUdfQ0lGU19FWFBFUklNRU5U
QUw9eQ0KIyBDT05GSUdfQ0lGU19VUENBTEwgaXMgbm90IHNldA0KIyBDT05GSUdfTkNQX0ZTIGlz
IG5vdCBzZXQNCiMgQ09ORklHX0NPREFfRlMgaXMgbm90IHNldA0KIyBDT05GSUdfQUZTX0ZTIGlz
IG5vdCBzZXQNCg0KIw0KIyBQYXJ0aXRpb24gVHlwZXMNCiMNCkNPTkZJR19QQVJUSVRJT05fQURW
QU5DRUQ9eQ0KIyBDT05GSUdfQUNPUk5fUEFSVElUSU9OIGlzIG5vdCBzZXQNCiMgQ09ORklHX09T
Rl9QQVJUSVRJT04gaXMgbm90IHNldA0KIyBDT05GSUdfQU1JR0FfUEFSVElUSU9OIGlzIG5vdCBz
ZXQNCiMgQ09ORklHX0FUQVJJX1BBUlRJVElPTiBpcyBub3Qgc2V0DQojIENPTkZJR19NQUNfUEFS
VElUSU9OIGlzIG5vdCBzZXQNCkNPTkZJR19NU0RPU19QQVJUSVRJT049eQ0KIyBDT05GSUdfQlNE
X0RJU0tMQUJFTCBpcyBub3Qgc2V0DQojIENPTkZJR19NSU5JWF9TVUJQQVJUSVRJT04gaXMgbm90
IHNldA0KIyBDT05GSUdfU09MQVJJU19YODZfUEFSVElUSU9OIGlzIG5vdCBzZXQNCiMgQ09ORklH
X1VOSVhXQVJFX0RJU0tMQUJFTCBpcyBub3Qgc2V0DQpDT05GSUdfTERNX1BBUlRJVElPTj15DQoj
IENPTkZJR19MRE1fREVCVUcgaXMgbm90IHNldA0KIyBDT05GSUdfU0dJX1BBUlRJVElPTiBpcyBu
b3Qgc2V0DQojIENPTkZJR19VTFRSSVhfUEFSVElUSU9OIGlzIG5vdCBzZXQNCiMgQ09ORklHX1NV
Tl9QQVJUSVRJT04gaXMgbm90IHNldA0KIyBDT05GSUdfS0FSTUFfUEFSVElUSU9OIGlzIG5vdCBz
ZXQNCkNPTkZJR19FRklfUEFSVElUSU9OPXkNCiMgQ09ORklHX1NZU1Y2OF9QQVJUSVRJT04gaXMg
bm90IHNldA0KQ09ORklHX05MUz1tDQpDT05GSUdfTkxTX0RFRkFVTFQ9InV0ZjgiDQpDT05GSUdf
TkxTX0NPREVQQUdFXzQzNz1tDQpDT05GSUdfTkxTX0NPREVQQUdFXzczNz1tDQpDT05GSUdfTkxT
X0NPREVQQUdFXzc3NT1tDQpDT05GSUdfTkxTX0NPREVQQUdFXzg1MD1tDQpDT05GSUdfTkxTX0NP
REVQQUdFXzg1Mj1tDQpDT05GSUdfTkxTX0NPREVQQUdFXzg1NT1tDQpDT05GSUdfTkxTX0NPREVQ
QUdFXzg1Nz1tDQpDT05GSUdfTkxTX0NPREVQQUdFXzg2MD1tDQpDT05GSUdfTkxTX0NPREVQQUdF
Xzg2MT1tDQpDT05GSUdfTkxTX0NPREVQQUdFXzg2Mj1tDQpDT05GSUdfTkxTX0NPREVQQUdFXzg2
Mz1tDQpDT05GSUdfTkxTX0NPREVQQUdFXzg2ND1tDQpDT05GSUdfTkxTX0NPREVQQUdFXzg2NT1t
DQpDT05GSUdfTkxTX0NPREVQQUdFXzg2Nj1tDQpDT05GSUdfTkxTX0NPREVQQUdFXzg2OT1tDQpD
T05GSUdfTkxTX0NPREVQQUdFXzkzNj1tDQpDT05GSUdfTkxTX0NPREVQQUdFXzk1MD1tDQpDT05G
SUdfTkxTX0NPREVQQUdFXzkzMj1tDQpDT05GSUdfTkxTX0NPREVQQUdFXzk0OT1tDQpDT05GSUdf
TkxTX0NPREVQQUdFXzg3ND1tDQpDT05GSUdfTkxTX0lTTzg4NTlfOD1tDQpDT05GSUdfTkxTX0NP
REVQQUdFXzEyNTA9bQ0KQ09ORklHX05MU19DT0RFUEFHRV8xMjUxPW0NCkNPTkZJR19OTFNfQVND
SUk9bQ0KQ09ORklHX05MU19JU084ODU5XzE9bQ0KQ09ORklHX05MU19JU084ODU5XzI9bQ0KQ09O
RklHX05MU19JU084ODU5XzM9bQ0KQ09ORklHX05MU19JU084ODU5XzQ9bQ0KQ09ORklHX05MU19J
U084ODU5XzU9bQ0KQ09ORklHX05MU19JU084ODU5XzY9bQ0KQ09ORklHX05MU19JU084ODU5Xzc9
bQ0KQ09ORklHX05MU19JU084ODU5Xzk9bQ0KQ09ORklHX05MU19JU084ODU5XzEzPW0NCkNPTkZJ
R19OTFNfSVNPODg1OV8xND1tDQpDT05GSUdfTkxTX0lTTzg4NTlfMTU9bQ0KQ09ORklHX05MU19L
T0k4X1I9bQ0KQ09ORklHX05MU19LT0k4X1U9bQ0KQ09ORklHX05MU19VVEY4PW0NCkNPTkZJR19E
TE09bQ0KIyBDT05GSUdfRExNX0RFQlVHIGlzIG5vdCBzZXQNCiMgQ09ORklHX0lOU1RSVU1FTlRB
VElPTiBpcyBub3Qgc2V0DQoNCiMNCiMgS2VybmVsIGhhY2tpbmcNCiMNCkNPTkZJR19UUkFDRV9J
UlFGTEFHU19TVVBQT1JUPXkNCkNPTkZJR19QUklOVEtfVElNRT15DQpDT05GSUdfRU5BQkxFX1dB
Uk5fREVQUkVDQVRFRD15DQpDT05GSUdfRU5BQkxFX01VU1RfQ0hFQ0s9eQ0KQ09ORklHX01BR0lD
X1NZU1JRPXkNCiMgQ09ORklHX1VOVVNFRF9TWU1CT0xTIGlzIG5vdCBzZXQNCkNPTkZJR19ERUJV
R19GUz15DQojIENPTkZJR19IRUFERVJTX0NIRUNLIGlzIG5vdCBzZXQNCiMgQ09ORklHX0RFQlVH
X0tFUk5FTCBpcyBub3Qgc2V0DQojIENPTkZJR19TTFVCX0RFQlVHX09OIGlzIG5vdCBzZXQNCkNP
TkZJR19ERUJVR19CVUdWRVJCT1NFPXkNCiMgQ09ORklHX1NBTVBMRVMgaXMgbm90IHNldA0KQ09O
RklHX0VBUkxZX1BSSU5USz15DQoNCiMNCiMgU2VjdXJpdHkgb3B0aW9ucw0KIw0KQ09ORklHX0tF
WVM9eQ0KIyBDT05GSUdfS0VZU19ERUJVR19QUk9DX0tFWVMgaXMgbm90IHNldA0KIyBDT05GSUdf
U0VDVVJJVFkgaXMgbm90IHNldA0KQ09ORklHX1NFQ1VSSVRZX0ZJTEVfQ0FQQUJJTElUSUVTPXkN
CkNPTkZJR19YT1JfQkxPQ0tTPW0NCkNPTkZJR19BU1lOQ19DT1JFPW0NCkNPTkZJR19BU1lOQ19N
RU1DUFk9bQ0KQ09ORklHX0FTWU5DX1hPUj1tDQpDT05GSUdfQ1JZUFRPPXkNCkNPTkZJR19DUllQ
VE9fQUxHQVBJPXkNCkNPTkZJR19DUllQVE9fQUJMS0NJUEhFUj1tDQpDT05GSUdfQ1JZUFRPX0FF
QUQ9bQ0KQ09ORklHX0NSWVBUT19CTEtDSVBIRVI9bQ0KQ09ORklHX0NSWVBUT19IQVNIPW0NCkNP
TkZJR19DUllQVE9fTUFOQUdFUj1tDQpDT05GSUdfQ1JZUFRPX0hNQUM9bQ0KQ09ORklHX0NSWVBU
T19YQ0JDPW0NCkNPTkZJR19DUllQVE9fTlVMTD1tDQpDT05GSUdfQ1JZUFRPX01END1tDQpDT05G
SUdfQ1JZUFRPX01ENT15DQpDT05GSUdfQ1JZUFRPX1NIQTE9bQ0KQ09ORklHX0NSWVBUT19TSEEy
NTY9bQ0KQ09ORklHX0NSWVBUT19TSEE1MTI9bQ0KQ09ORklHX0NSWVBUT19XUDUxMj1tDQpDT05G
SUdfQ1JZUFRPX1RHUjE5Mj1tDQpDT05GSUdfQ1JZUFRPX0dGMTI4TVVMPW0NCkNPTkZJR19DUllQ
VE9fRUNCPW0NCkNPTkZJR19DUllQVE9fQ0JDPW0NCkNPTkZJR19DUllQVE9fUENCQz1tDQpDT05G
SUdfQ1JZUFRPX0xSVz1tDQpDT05GSUdfQ1JZUFRPX1hUUz1tDQpDT05GSUdfQ1JZUFRPX0NSWVBU
RD1tDQpDT05GSUdfQ1JZUFRPX0RFUz1tDQpDT05GSUdfQ1JZUFRPX0ZDUllQVD1tDQpDT05GSUdf
Q1JZUFRPX0JMT1dGSVNIPW0NCkNPTkZJR19DUllQVE9fVFdPRklTSD1tDQpDT05GSUdfQ1JZUFRP
X1RXT0ZJU0hfQ09NTU9OPW0NCkNPTkZJR19DUllQVE9fVFdPRklTSF9YODZfNjQ9bQ0KQ09ORklH
X0NSWVBUT19TRVJQRU5UPW0NCkNPTkZJR19DUllQVE9fQUVTPW0NCkNPTkZJR19DUllQVE9fQUVT
X1g4Nl82ND1tDQpDT05GSUdfQ1JZUFRPX0NBU1Q1PW0NCkNPTkZJR19DUllQVE9fQ0FTVDY9bQ0K
Q09ORklHX0NSWVBUT19URUE9bQ0KQ09ORklHX0NSWVBUT19BUkM0PW0NCkNPTkZJR19DUllQVE9f
S0hBWkFEPW0NCkNPTkZJR19DUllQVE9fQU5VQklTPW0NCkNPTkZJR19DUllQVE9fU0VFRD1tDQpD
T05GSUdfQ1JZUFRPX0RFRkxBVEU9bQ0KQ09ORklHX0NSWVBUT19NSUNIQUVMX01JQz1tDQpDT05G
SUdfQ1JZUFRPX0NSQzMyQz1tDQpDT05GSUdfQ1JZUFRPX0NBTUVMTElBPW0NCkNPTkZJR19DUllQ
VE9fVEVTVD1tDQpDT05GSUdfQ1JZUFRPX0FVVEhFTkM9bQ0KIyBDT05GSUdfQ1JZUFRPX0hXIGlz
IG5vdCBzZXQNCg0KIw0KIyBMaWJyYXJ5IHJvdXRpbmVzDQojDQpDT05GSUdfQklUUkVWRVJTRT15
DQpDT05GSUdfQ1JDX0NDSVRUPW0NCkNPTkZJR19DUkMxNj1tDQpDT05GSUdfQ1JDX0lUVV9UPW0N
CkNPTkZJR19DUkMzMj15DQpDT05GSUdfQ1JDNz1tDQpDT05GSUdfTElCQ1JDMzJDPW0NCkNPTkZJ
R19aTElCX0lORkxBVEU9eQ0KQ09ORklHX1pMSUJfREVGTEFURT1tDQpDT05GSUdfVEVYVFNFQVJD
SD15DQpDT05GSUdfVEVYVFNFQVJDSF9LTVA9bQ0KQ09ORklHX1RFWFRTRUFSQ0hfQk09bQ0KQ09O
RklHX1RFWFRTRUFSQ0hfRlNNPW0NCkNPTkZJR19QTElTVD15DQpDT05GSUdfSEFTX0lPTUVNPXkN
CkNPTkZJR19IQVNfSU9QT1JUPXkNCkNPTkZJR19IQVNfRE1BPXkNCg==

--MP_/Vd/D6xBF56+nJrKUKI5XFXp
Content-Type: text/plain; name=hdparm.txt
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=hdparm.txt


/dev/sda:

ATA device, with non-removable media
	Model Number:       Maxtor 6V250F0                         =20
	Serial Number:      V599EFKG           =20
	Firmware Revision:  VA111900
Standards:
	Used: ATA/ATAPI-7 T13 1532D revision 0=20
	Supported: 7 6 5 4=20
Configuration:
	Logical		max	current
	cylinders	16383	16383
	heads		16	16
	sectors/track	63	63
	--
	CHS current addressable sectors:   16514064
	LBA    user addressable sectors:  268435455
	LBA48  user addressable sectors:  490234752
	device size with M =3D 1024*1024:      239372 MBytes
	device size with M =3D 1000*1000:      251000 MBytes (251 GB)
Capabilities:
	LBA, IORDY(can be disabled)
	Queue depth: 32
	Standby timer values: spec'd by Standard, no device specific minimum
	R/W multiple sector transfer: Max =3D 16	Current =3D 0
	Advanced power management level: unknown setting (0x00fe)
	Recommended acoustic management value: 192, current value: 254
	DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6=20
	     Cycle time: min=3D120ns recommended=3D120ns
	PIO: pio0 pio1 pio2 pio3 pio4=20
	     Cycle time: no flow control=3D120ns  IORDY flow control=3D120ns
Commands/features:
	Enabled	Supported:
	   *	SMART feature set
	    	Security Mode feature set
	   *	Power Management feature set
	   *	Write cache
	   *	Look-ahead
	   *	Host Protected Area feature set
	   *	WRITE_VERIFY command
	   *	WRITE_BUFFER command
	   *	READ_BUFFER command
	   *	NOP cmd
	   *	DOWNLOAD_MICROCODE
	   *	Advanced Power Management feature set
	    	Power-Up In Standby feature set
	    	SET_FEATURES required to spinup after power up
	    	SET_MAX security extension
	   *	Automatic Acoustic Management feature set
	   *	48-bit Address feature set
	   *	Device Configuration Overlay feature set
	   *	Mandatory FLUSH_CACHE
	   *	FLUSH_CACHE_EXT
	   *	SMART error logging
	   *	SMART self-test
	    	Media Card Pass-Through
	   *	General Purpose Logging feature set
	   *	WRITE_{DMA|MULTIPLE}_FUA_EXT
	   *	64-bit World wide name
	   *	URG for READ_STREAM[_DMA]_EXT
	   *	URG for WRITE_STREAM[_DMA]_EXT
	   *	SATA-I signaling speed (1.5Gb/s)
	   *	SATA-II signaling speed (3.0Gb/s)
	   *	Native Command Queueing (NCQ)
	   *	Host-initiated interface power management
	   *	Software settings preservation
	   *	SMART Command Transport (SCT) feature set
	   *	SCT Data Tables (AC5)
Security:=20
	Master password revision code =3D 65534
		supported
	not	enabled
	not	locked
	not	frozen
	not	expired: security count
	not	supported: enhanced erase
Checksum: correct

/dev/sdb:

ATA device, with non-removable media
	Model Number:       Maxtor 6V250F0                         =20
	Serial Number:      V597WKKG           =20
	Firmware Revision:  VA111900
Standards:
	Used: ATA/ATAPI-7 T13 1532D revision 0=20
	Supported: 7 6 5 4=20
Configuration:
	Logical		max	current
	cylinders	16383	16383
	heads		16	16
	sectors/track	63	63
	--
	CHS current addressable sectors:   16514064
	LBA    user addressable sectors:  268435455
	LBA48  user addressable sectors:  490234752
	device size with M =3D 1024*1024:      239372 MBytes
	device size with M =3D 1000*1000:      251000 MBytes (251 GB)
Capabilities:
	LBA, IORDY(can be disabled)
	Queue depth: 32
	Standby timer values: spec'd by Standard, no device specific minimum
	R/W multiple sector transfer: Max =3D 16	Current =3D 0
	Advanced power management level: unknown setting (0x00fe)
	Recommended acoustic management value: 192, current value: 254
	DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6=20
	     Cycle time: min=3D120ns recommended=3D120ns
	PIO: pio0 pio1 pio2 pio3 pio4=20
	     Cycle time: no flow control=3D120ns  IORDY flow control=3D120ns
Commands/features:
	Enabled	Supported:
	   *	SMART feature set
	    	Security Mode feature set
	   *	Power Management feature set
	   *	Write cache
	   *	Look-ahead
	   *	Host Protected Area feature set
	   *	WRITE_VERIFY command
	   *	WRITE_BUFFER command
	   *	READ_BUFFER command
	   *	NOP cmd
	   *	DOWNLOAD_MICROCODE
	   *	Advanced Power Management feature set
	    	Power-Up In Standby feature set
	    	SET_FEATURES required to spinup after power up
	    	SET_MAX security extension
	   *	Automatic Acoustic Management feature set
	   *	48-bit Address feature set
	   *	Device Configuration Overlay feature set
	   *	Mandatory FLUSH_CACHE
	   *	FLUSH_CACHE_EXT
	   *	SMART error logging
	   *	SMART self-test
	    	Media Card Pass-Through
	   *	General Purpose Logging feature set
	   *	WRITE_{DMA|MULTIPLE}_FUA_EXT
	   *	64-bit World wide name
	   *	URG for READ_STREAM[_DMA]_EXT
	   *	URG for WRITE_STREAM[_DMA]_EXT
	   *	SATA-I signaling speed (1.5Gb/s)
	   *	SATA-II signaling speed (3.0Gb/s)
	   *	Native Command Queueing (NCQ)
	   *	Host-initiated interface power management
	   *	Software settings preservation
	   *	SMART Command Transport (SCT) feature set
	   *	SCT Data Tables (AC5)
Security:=20
	Master password revision code =3D 65534
		supported
	not	enabled
	not	locked
	not	frozen
	not	expired: security count
	not	supported: enhanced erase
Checksum: correct

/dev/sdc:

ATA device, with non-removable media
	Model Number:       Maxtor 6V250F0                         =20
	Serial Number:      V594HR0G           =20
	Firmware Revision:  VA111900
Standards:
	Used: ATA/ATAPI-7 T13 1532D revision 0=20
	Supported: 7 6 5 4=20
Configuration:
	Logical		max	current
	cylinders	16383	16383
	heads		16	16
	sectors/track	63	63
	--
	CHS current addressable sectors:   16514064
	LBA    user addressable sectors:  268435455
	LBA48  user addressable sectors:  490234752
	device size with M =3D 1024*1024:      239372 MBytes
	device size with M =3D 1000*1000:      251000 MBytes (251 GB)
Capabilities:
	LBA, IORDY(can be disabled)
	Queue depth: 32
	Standby timer values: spec'd by Standard, no device specific minimum
	R/W multiple sector transfer: Max =3D 16	Current =3D 0
	Advanced power management level: unknown setting (0x00fe)
	Recommended acoustic management value: 192, current value: 254
	DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6=20
	     Cycle time: min=3D120ns recommended=3D120ns
	PIO: pio0 pio1 pio2 pio3 pio4=20
	     Cycle time: no flow control=3D120ns  IORDY flow control=3D120ns
Commands/features:
	Enabled	Supported:
	   *	SMART feature set
	    	Security Mode feature set
	   *	Power Management feature set
	   *	Write cache
	   *	Look-ahead
	   *	Host Protected Area feature set
	   *	WRITE_VERIFY command
	   *	WRITE_BUFFER command
	   *	READ_BUFFER command
	   *	NOP cmd
	   *	DOWNLOAD_MICROCODE
	   *	Advanced Power Management feature set
	    	Power-Up In Standby feature set
	    	SET_FEATURES required to spinup after power up
	    	SET_MAX security extension
	   *	Automatic Acoustic Management feature set
	   *	48-bit Address feature set
	   *	Device Configuration Overlay feature set
	   *	Mandatory FLUSH_CACHE
	   *	FLUSH_CACHE_EXT
	   *	SMART error logging
	   *	SMART self-test
	    	Media Card Pass-Through
	   *	General Purpose Logging feature set
	   *	WRITE_{DMA|MULTIPLE}_FUA_EXT
	   *	64-bit World wide name
	   *	URG for READ_STREAM[_DMA]_EXT
	   *	URG for WRITE_STREAM[_DMA]_EXT
	   *	SATA-I signaling speed (1.5Gb/s)
	   *	SATA-II signaling speed (3.0Gb/s)
	   *	Native Command Queueing (NCQ)
	   *	Host-initiated interface power management
	   *	Software settings preservation
	   *	SMART Command Transport (SCT) feature set
	   *	SCT Data Tables (AC5)
Security:=20
	Master password revision code =3D 65534
		supported
	not	enabled
	not	locked
	not	frozen
	not	expired: security count
	not	supported: enhanced erase
Checksum: correct

/dev/sdd:

ATA device, with non-removable media
	Model Number:       MAXTOR STM3250820AS                    =20
	Serial Number:      6QE04C0J
	Firmware Revision:  3.AAE  =20
Standards:
	Supported: 7 6 5 4=20
	Likely used: 7
Configuration:
	Logical		max	current
	cylinders	16383	16383
	heads		16	16
	sectors/track	63	63
	--
	CHS current addressable sectors:   16514064
	LBA    user addressable sectors:  268435455
	LBA48  user addressable sectors:  488397168
	device size with M =3D 1024*1024:      238475 MBytes
	device size with M =3D 1000*1000:      250059 MBytes (250 GB)
Capabilities:
	LBA, IORDY(can be disabled)
	Queue depth: 32
	Standby timer values: spec'd by Standard, no device specific minimum
	R/W multiple sector transfer: Max =3D 16	Current =3D ?
	Recommended acoustic management value: 254, current value: 0
	DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6=20
	     Cycle time: min=3D120ns recommended=3D120ns
	PIO: pio0 pio1 pio2 pio3 pio4=20
	     Cycle time: no flow control=3D120ns  IORDY flow control=3D120ns
Commands/features:
	Enabled	Supported:
	   *	SMART feature set
	    	Security Mode feature set
	   *	Power Management feature set
	   *	Write cache
	   *	Look-ahead
	   *	Host Protected Area feature set
	   *	WRITE_BUFFER command
	   *	READ_BUFFER command
	   *	DOWNLOAD_MICROCODE
	    	SET_MAX security extension
	   *	48-bit Address feature set
	   *	Device Configuration Overlay feature set
	   *	Mandatory FLUSH_CACHE
	   *	FLUSH_CACHE_EXT
	   *	SMART error logging
	   *	SMART self-test
	   *	General Purpose Logging feature set
	   *	SATA-I signaling speed (1.5Gb/s)
	   *	SATA-II signaling speed (3.0Gb/s)
	   *	Native Command Queueing (NCQ)
	   *	Phy event counters
	    	Device-initiated interface power management
	   *	Software settings preservation
Security:=20
	Master password revision code =3D 65534
		supported
	not	enabled
	not	locked
	not	frozen
	not	expired: security count
	not	supported: enhanced erase
Checksum: correct

--MP_/Vd/D6xBF56+nJrKUKI5XFXp--

--Sig_/GPiFJRMCvokmLGRK0RFfbdH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHtH6X4q3E2oMjYtURAuUyAKChPStdeMiJBHDv4v3jQJBQOBpVMACgsZwd
jnj8z04aNSzd/J7s5cxaDNU=
=J+6k
-----END PGP SIGNATURE-----

--Sig_/GPiFJRMCvokmLGRK0RFfbdH--
