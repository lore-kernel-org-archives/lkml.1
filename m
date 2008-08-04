Return-Path: <linux-kernel-owner+w=401wt.eu-S1753545AbYHDRp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbYHDRp5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 13:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbYHDRpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 13:45:49 -0400
Received: from smtp118.rog.mail.re2.yahoo.com ([68.142.225.234]:35273 "HELO
	smtp118.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750965AbYHDRpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 13:45:47 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Aug 2008 13:45:46 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:Content-Type;
  b=Cqbv0MbLYuH190pCSvs98CF/w0axS+n0pQnCaiYpQ4lAmWz2JbW3vPn15CKcEIrLDQdK45MVOgw9CR1gvDUHREm+ShenLUYyJxx5r+eLvrV1dUw+1f5BK/+heQJW0D7Jf7SrxiC/WzfPM5Q4/RjVf+oVWSupLq+tekf11KFjRGw=  ;
X-YMail-OSG: BSAM7T4VM1mTwx8gaJq1y_TszTEp1qDka7KNsp3HVfr1aS5NbQy8XnhnBj_VXhQPhQ--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <48973EB9.90408@rogers.com>
Date: Mon, 04 Aug 2008 13:39:05 -0400
From: David Stuart <dstuart@rogers.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Problems with disk + network on 2.6.25.11-60.fc8
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms050109090904040106020201"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms050109090904040106020201
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello everyone,

I have trawled the depths of the Internet, scoured the innermost reaches 
of the Usenet, and finally I arrive, beaten and bruised, at the steps to 
the Linux kernel mailing list, to seek advice from the penguins 
themselves. I humbly prostrate myself .. :)

My first request: Please CC me directly on replies as I am not 
subscribed to the list.

Now to the meat of it; I have been experiencing a lot of trouble with 
system freezes; but these are not crippling freezes in the sense that 
they come back after a few seconds. They are always accompanied by the 
following log in /var/log/messages:

----8<----8<----8<----8<----8<----8<----8<----8<----8<----8<----8<----8<----8<----8<----8<----8<
Aug  3 21:44:34 localhost kernel: ata1.00: exception Emask 0x0 SAct 0x0 
SErr 0x0 action 0x2 frozen
Aug  3 21:44:34 localhost kernel: ata1.00: cmd 
ca/00:40:b8:c9:f3/00:00:00:00:00/e8 tag 0 dma 32768 out
Aug  3 21:44:34 localhost kernel:          res 
40/00:78:00:00:00/00:00:00:00:00/50 Emask 0x4 (timeout)
Aug  3 21:44:34 localhost kernel: ata1.00: status: { DRDY }
Aug  3 21:44:39 localhost kernel: ata1: port is slow to respond, please 
be patient (Status 0x80)
Aug  3 21:44:44 localhost kernel: ata1: device not ready (errno=-16), 
forcing hardreset
Aug  3 21:44:44 localhost kernel: ata1: soft resetting link
Aug  3 21:44:45 localhost kernel: ata1.00: configured for UDMA/100
Aug  3 21:44:45 localhost kernel: ata1.01: configured for UDMA/100
Aug  3 21:44:45 localhost kernel: ata1: EH complete
Aug  3 21:44:45 localhost kernel: sd 0:0:0:0: [sda] 160086528 512-byte 
hardware sectors (81964 MB)
Aug  3 21:44:45 localhost kernel: sd 0:0:0:0: [sda] Write Protect is off
Aug  3 21:44:45 localhost kernel: sd 0:0:0:0: [sda] Write cache: 
enabled, read cache: enabled, doesn't support DPO or FUA
Aug  3 21:44:45 localhost kernel: sd 0:0:1:0: [sdb] 488397168 512-byte 
hardware sectors (250059 MB)
Aug  3 21:44:45 localhost kernel: sd 0:0:1:0: [sdb] Write Protect is off
Aug  3 21:44:45 localhost kernel: sd 0:0:1:0: [sdb] Write cache: 
enabled, read cache: enabled, doesn't support DPO or FUA
Aug  3 21:44:45 localhost kernel: sd 0:0:0:0: [sda] 160086528 512-byte 
hardware sectors (81964 MB)
Aug  3 21:44:45 localhost kernel: sd 0:0:0:0: [sda] Write Protect is off
Aug  3 21:44:45 localhost kernel: sd 0:0:0:0: [sda] Write cache: 
enabled, read cache: enabled, doesn't support DPO or FUA
Aug  3 21:44:45 localhost kernel: sd 0:0:1:0: [sdb] 488397168 512-byte 
hardware sectors (250059 MB)
Aug  3 21:44:45 localhost kernel: sd 0:0:1:0: [sdb] Write Protect is off
Aug  3 21:44:45 localhost kernel: sd 0:0:1:0: [sdb] Write cache: 
enabled, read cache: enabled, doesn't support DPO or FUA
----8<----8<----8<----8<----8<----8<----8<----8<----8<----8<----8<----8<----8<----8<----8<----8<


Now, I know what you're thinking, this problem has been reported a lot 
already. But, as I mentioned I have done a lot of searching online 
looking for answers. There are a number of posts which seem like related 
problems, especially if you search Google for "Exception emask". Most of 
these suggest a work-around of putting the following boot options:

noapic acpi=off

Let me assure you already that this workaround did not fix my problems. 
Nor does the flag "combined_mode=libata"; which was suggested elsewhere.

Another post suggests that smartd is the culprit; not only do I have the 
latest version of smartd (which was supposed to fix the issue), but even 
if I disable smartd I still see the same problem.

Yet another post indicates a problem with CD-ROM firmware. I have tried 
disconnecting my CD-ROM from the system, swapping it with another, all 
to no avail.

Yet another another post suggests that the skge (or its predecessor) was 
to blame; so I replaced the network card with another I have, using the 
8139cp driver. I still see the same problem.

Somewhere around this point, I gouged out my eyes and tore out my hair. 
Thank goodness I am good at touch-typing.

What I have noticed, is that I only receive this exception (which seems 
related to disk activity) when my machine is under heavy NETWORK LOAD; 
i.e. when I am downloading the latest kernel (to pick a random example). 
If there is no network activity the machine seems to be fine.

The hard drive which experiences the problems is running off a Maxtor 
Ultra100 IDE controller card (promise-based). It's possible that this is 
the culprit, but I am having a hard time moving the drive off this card 
because I have setup my main partition using LVM (possible, but 
non-obvious). I upgraded its firmware just in case, but that didn't help.

I do not believe that the drive itself has hardware problems because it 
behaves fine when network traffic is not present. Also I did not notice 
this problem until I upgraded to Fedora 7, which I believe was the first 
Fedora distro to change the way the hard drives were represented (from 
the old /dev/hdx system). I also use the following hdparms on the drive:

hdparm -S 120 /dev/sdb

At some point I thought this was the problem, but through trial and 
error I believe it is OK. However it is possible that my sleuthing 
abilities in this department are not up to snuff.

I am looking for any advice which will help me to workaround the 
problem. I am not a kernel developer but I am fine with advanced system 
configuration. I just want to have my smoothly running Linux box back again.

What follows is the usual system information:
===================================

[dave@localhost ~]$ uname -a
Linux localhost.localdomain 2.6.25.11-60.fc8 #1 SMP Mon Jul 21 01:40:51 
EDT 2008 x86_64 x86_64 x86_64 GNU/Linux

[dave@localhost ~]$ lspci -vv
00:00.0 Host bridge: VIA Technologies, Inc. K8T800Pro Host Bridge
        Subsystem: ASUSTeK Computer Inc. A8V Deluxe
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR- INTx-
        Latency: 64
        Region 0: Memory at <ignored> (32-bit, prefetchable)
        Capabilities: <access denied>
        Kernel driver in use: agpgart-amd64

00:00.1 Host bridge: VIA Technologies, Inc. K8T800Pro Host Bridge
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0

00:00.2 Host bridge: VIA Technologies, Inc. K8T800Pro Host Bridge
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0

00:00.3 Host bridge: VIA Technologies, Inc. K8T800Pro Host Bridge
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0

00:00.4 Host bridge: VIA Technologies, Inc. K8T800Pro Host Bridge
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0

00:00.7 Host bridge: VIA Technologies, Inc. K8T800Pro Host Bridge
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0

00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI bridge 
[K8T800/K8T890 South] (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        Memory behind bridge: faf00000-fbffffff
        Prefetchable memory behind bridge: e0000000-f9ffffff
        Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: <access denied>
        Kernel modules: shpchp

00:0d.0 Mass storage controller: Promise Technology, Inc. PDC20267 
(FastTrak100/Ultra100) (rev 02)
        Subsystem: Promise Technology, Inc. Ultra100
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64
        Interrupt: pin A routed to IRQ 18
        Region 0: I/O ports at a800 [size=8]
        Region 1: I/O ports at a400 [size=4]
        Region 2: I/O ports at a000 [size=8]
        Region 3: I/O ports at 9800 [size=4]
        Region 4: I/O ports at 9400 [size=64]
        Region 5: Memory at fab00000 (32-bit, non-prefetchable) [size=128K]
        Expansion ROM at faa00000 [disabled] [size=64K]
        Capabilities: <access denied>
        Kernel driver in use: pata_pdc202xx_old
        Kernel modules: pata_pdc202xx_old

00:0e.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL-8139/8139C/8139C+ (rev 10)
        Subsystem: Realtek Semiconductor Co., Ltd. RT8139
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (8000ns min, 16000ns max)
        Interrupt: pin A routed to IRQ 19
        Region 0: I/O ports at b000 [size=256]
        Region 1: Memory at fac00000 (32-bit, non-prefetchable) [size=256]
        Capabilities: <access denied>
        Kernel driver in use: 8139too
        Kernel modules: 8139too, 8139cp

00:0f.0 RAID bus controller: VIA Technologies, Inc. VIA VT6420 SATA RAID 
Controller (rev 80)
        Subsystem: ASUSTeK Computer Inc. A7V600/K8V Deluxe/K8V-X/A8V 
Deluxe motherboard
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64
        Interrupt: pin B routed to IRQ 20
        Region 0: I/O ports at d000 [size=8]
        Region 1: I/O ports at c800 [size=4]
        Region 2: I/O ports at c400 [size=8]
        Region 3: I/O ports at c000 [size=4]
        Region 4: I/O ports at b800 [size=16]
        Region 5: I/O ports at b400 [size=256]
        Capabilities: <access denied>
        Kernel driver in use: sata_via
        Kernel modules: sata_via

00:0f.1 IDE interface: VIA Technologies, Inc. 
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06) 
(prog-if 8a [Master SecP PriP])
        Subsystem: ASUSTeK Computer Inc. A7V600/K8V-X/A8V Deluxe motherboard
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32
        Interrupt: pin A routed to IRQ 20
        Region 0: [virtual] Memory at 000001f0 (32-bit, 
non-prefetchable) [size=8]
        Region 1: [virtual] Memory at 000003f0 (type 3, 
non-prefetchable) [size=1]
        Region 2: [virtual] Memory at 00000170 (32-bit, 
non-prefetchable) [size=8]
        Region 3: [virtual] Memory at 00000370 (type 3, 
non-prefetchable) [size=1]
        Region 4: I/O ports at fc00 [size=16]
        Capabilities: <access denied>
        Kernel driver in use: pata_via
        Kernel modules: pata_via, ata_generic, pata_acpi

00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
Controller (rev 81) (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. A7V600/K8V-X/A8V Deluxe motherboard
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 21
        Region 4: I/O ports at d400 [size=32]
        Capabilities: <access denied>
        Kernel driver in use: uhci_hcd
        Kernel modules: uhci-hcd

00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
Controller (rev 81) (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. A7V600/K8V-X/A8V Deluxe motherboard
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 21
        Region 4: I/O ports at d800 [size=32]
        Capabilities: <access denied>
        Kernel driver in use: uhci_hcd
        Kernel modules: uhci-hcd

00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
Controller (rev 81) (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. A7V600/K8V-X/A8V Deluxe motherboard
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin B routed to IRQ 21
        Region 4: I/O ports at e000 [size=32]
        Capabilities: <access denied>
        Kernel driver in use: uhci_hcd
        Kernel modules: uhci-hcd

00:10.3 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
Controller (rev 81) (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. A7V600/K8V-X/A8V Deluxe motherboard
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin B routed to IRQ 21
        Region 4: I/O ports at e400 [size=32]
        Capabilities: <access denied>
        Kernel driver in use: uhci_hcd
        Kernel modules: uhci-hcd

00:10.4 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 86) (prog-if 
20 [EHCI])
        Subsystem: ASUSTeK Computer Inc. A7V600/K8V-X/A8V Deluxe motherboard
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin C routed to IRQ 21
        Region 0: Memory at fae00000 (32-bit, non-prefetchable) [size=256]
        Capabilities: <access denied>
        Kernel driver in use: ehci_hcd
        Kernel modules: ehci-hcd

00:11.0 ISA bridge: VIA Technologies, Inc. VT8237 ISA bridge 
[KT600/K8T800/K8T890 South]
        Subsystem: ASUSTeK Computer Inc. A7V600/K8V-X/A8V Deluxe motherboard
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping+ SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Capabilities: <access denied>
        Kernel modules: i2c-viapro

00:11.5 Multimedia audio controller: VIA Technologies, Inc. 
VT8233/A/8235/8237 AC97 Audio Controller (rev 60)
        Subsystem: ASUSTeK Computer Inc. A8V Deluxe motherboard (Realtek 
ALC850 codec)
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin C routed to IRQ 22
        Region 0: I/O ports at e800 [size=256]
        Capabilities: <access denied>
        Kernel driver in use: VIA 82xx Audio
        Kernel modules: snd-via82xx

00:11.6 Communication controller: VIA Technologies, Inc. AC'97 Modem 
Controller (rev 80)
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin C routed to IRQ 22
        Region 0: I/O ports at 1000 [size=256]
        Capabilities: <access denied>
        Kernel modules: snd-via82xx-modem

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
HyperTransport Technology Configuration
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Capabilities: <access denied>

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Address Map
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
DRAM Controller
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Miscellaneous Control
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Kernel driver in use: k8temp
        Kernel modules: k8temp

01:00.0 VGA compatible controller: nVidia Corporation NV34 [GeForce FX 
5500] (rev a1) (prog-if 00 [VGA controller])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 248 (1250ns min, 250ns max)
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at fb000000 (32-bit, non-prefetchable) [size=16M]
        Region 1: Memory at e0000000 (32-bit, prefetchable) [size=256M]
        [virtual] Expansion ROM at faf00000 [disabled] [size=128K]
        Capabilities: <access denied>
        Kernel driver in use: nvidia
        Kernel modules: nvidia, nvidiafb

[dave@localhost ~]$ lsmod
Module                  Size  Used by
autofs4                28745  2
fuse                   51329  1
nf_conntrack_netbios_ns    11073  0
nf_conntrack_ipv4      17481  4
xt_multiport           11713  1
iptable_filter         11585  1
ip_tables              25681  1 iptable_filter
nf_conntrack_ipv6      23337  2
xt_state               10817  6
nf_conntrack           64849  4 
nf_conntrack_netbios_ns,nf_conntrack_ipv4,nf_conntrack_ipv6,xt_state
xt_tcpudp              11841  4
ip6table_filter        11457  1
ip6_tables             26961  1 ip6table_filter
x_tables               26185  5 
xt_multiport,ip_tables,xt_state,xt_tcpudp,ip6_tables
cpufreq_ondemand       15825  1
powernow_k8            24133  0
freq_table             13633  2 cpufreq_ondemand,powernow_k8
loop                   23365  0
dm_multipath           25425  0
ipv6                  277801  25 nf_conntrack_ipv6
snd_via82xx_modem      20685  0
sr_mod                 23813  0
cdrom                  40809  1 sr_mod
nvidia               8109360  24
snd_seq_dummy          11589  0
snd_via82xx            33385  4
snd_seq_oss            38081  0
snd_seq_midi_event     15297  1 snd_seq_oss
gameport               20049  1 snd_via82xx
snd_seq                58273  5 snd_seq_dummy,snd_seq_oss,snd_seq_midi_event
snd_ac97_codec        119705  2 snd_via82xx_modem,snd_via82xx
ac97_bus               10305  1 snd_ac97_codec
snd_pcm_oss            46657  0
snd_mpu401_uart        15681  1 snd_via82xx
snd_mixer_oss          22977  2 snd_pcm_oss
snd_rawmidi            29249  1 snd_mpu401_uart
snd_pcm                79561  4 
snd_via82xx_modem,snd_via82xx,snd_ac97_codec,snd_pcm_oss
pata_via               18629  0
snd_seq_device         15189  4 
snd_seq_dummy,snd_seq_oss,snd_seq,snd_rawmidi
i2c_viapro             16729  0
snd_timer              28625  2 snd_seq,snd_pcm
ata_generic            14917  0
snd                    62217  18 
snd_via82xx_modem,snd_via82xx,snd_seq_oss,snd_seq,snd_ac97_codec,snd_pcm_oss,snd_mpu401_uart,snd_mixer_oss,snd_rawmidi,snd_pcm,snd_seq_device,snd_timer
i2c_core               28769  2 nvidia,i2c_viapro
pata_acpi              14145  0
8139too                32065  0
k8temp                 13377  0
8139cp                 28225  0
hwmon                  11145  1 k8temp
soundcore              15073  2 snd
parport_pc             34793  0
mii                    13377  2 8139too,8139cp
pcspkr                 11329  0
button                 15841  0
snd_page_alloc         16593  3 snd_via82xx_modem,snd_via82xx,snd_pcm
parport                43121  1 parport_pc
shpchp                 38365  0
sg                     40865  0
floppy                 66153  0
sata_via               17989  0
dm_snapshot            23817  0
dm_zero                10433  0
dm_mirror              31557  0
dm_mod                 62201  9 dm_multipath,dm_snapshot,dm_zero,dm_mirror
pata_pdc202xx_old      15297  2
libata                148593  5 
pata_via,ata_generic,pata_acpi,sata_via,pata_pdc202xx_old
sd_mod                 33665  3
scsi_mod              151737  4 sr_mod,sg,libata,sd_mod
ext3                  131025  2
jbd                    52585  1 ext3
mbcache                15940  1 ext3
uhci_hcd               29921  0
ohci_hcd               29381  0
ehci_hcd               40141  0


(Yes, it's true I have the proprietary nvidia module installed, my 
kernel is unfortunately tainted. I don't think this is the problem but 
if it will help to get to the bottom of things, I will be happy to 
disable it for investigative purposes).

Thank you for any help you may offer.

David

-- 
The only way to keep your health is to eat what you don't want, drink
what you don't like, and do what you'd rather not.
                -- Mark Twain


--------------ms050109090904040106020201
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIJBzCC
At4wggJHoAMCAQICEHcAGlDwU0NqjFetNQ2D/hEwDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UE
BhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMT
I1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA4MDcxMjE2MDQ0NFoX
DTA5MDcxMjE2MDQ0NFowRDEfMB0GA1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjEhMB8G
CSqGSIb3DQEJARYSZHN0dWFydEByb2dlcnMuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
MIIBCgKCAQEAqUMveSpJ7k7kMyf5zbslvkiz9VGDfcnCQNOFLaw9y6j0jPvvkgIXtslpofj0
3/eARmjszsn/24Zn1/Iufz3xuc/XYYn7lQgf1PCTeV8bYTq81Kvh6srKbrYmPz06uXVhtGQC
vWuKL3SLtX3jI4ah5L/te5w+x/MDaflM8N0xb0UlRGeR80FwFSzk1qh+vyx+hWoUz0Gdmuc/
4AZUBvl3PzD0fNZP3FS8k7aBuAAQT1H5iUag8BFWmqAiR1QYWsjpcK4VwSfeSTDsEK7rcU4K
ukbhuxITTWrQHDqJJAIopvP8FocH/uAumuNFsZLp6jvJNOft02TiGuU2CWAL1ZCW9wIDAQAB
oy8wLTAdBgNVHREEFjAUgRJkc3R1YXJ0QHJvZ2Vycy5jb20wDAYDVR0TAQH/BAIwADANBgkq
hkiG9w0BAQUFAAOBgQBHbO5t4ZukqhZfwdR6RqNujNssesMxKwU2w/lXNxoPH5RssWsN3xi4
1AAJ8wAnEeuHqJi4TMVF6lMWAOSuJO/OQR2gDBysHT29jrJn0bUqgOeT7KC6A7wtjabbLK0n
/DK2cZovx/xBgVjWl7hpvk5qw6Clr4R21DbrA/GOMGcE8TCCAt4wggJHoAMCAQICEHcAGlDw
U0NqjFetNQ2D/hEwDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRo
YXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBG
cmVlbWFpbCBJc3N1aW5nIENBMB4XDTA4MDcxMjE2MDQ0NFoXDTA5MDcxMjE2MDQ0NFowRDEf
MB0GA1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjEhMB8GCSqGSIb3DQEJARYSZHN0dWFy
dEByb2dlcnMuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqUMveSpJ7k7k
Myf5zbslvkiz9VGDfcnCQNOFLaw9y6j0jPvvkgIXtslpofj03/eARmjszsn/24Zn1/Iufz3x
uc/XYYn7lQgf1PCTeV8bYTq81Kvh6srKbrYmPz06uXVhtGQCvWuKL3SLtX3jI4ah5L/te5w+
x/MDaflM8N0xb0UlRGeR80FwFSzk1qh+vyx+hWoUz0Gdmuc/4AZUBvl3PzD0fNZP3FS8k7aB
uAAQT1H5iUag8BFWmqAiR1QYWsjpcK4VwSfeSTDsEK7rcU4KukbhuxITTWrQHDqJJAIopvP8
FocH/uAumuNFsZLp6jvJNOft02TiGuU2CWAL1ZCW9wIDAQABoy8wLTAdBgNVHREEFjAUgRJk
c3R1YXJ0QHJvZ2Vycy5jb20wDAYDVR0TAQH/BAIwADANBgkqhkiG9w0BAQUFAAOBgQBHbO5t
4ZukqhZfwdR6RqNujNssesMxKwU2w/lXNxoPH5RssWsN3xi41AAJ8wAnEeuHqJi4TMVF6lMW
AOSuJO/OQR2gDBysHT29jrJn0bUqgOeT7KC6A7wtjabbLK0n/DK2cZovx/xBgVjWl7hpvk5q
w6Clr4R21DbrA/GOMGcE8TCCAz8wggKooAMCAQICAQ0wDQYJKoZIhvcNAQEFBQAwgdExCzAJ
BgNVBAYTAlpBMRUwEwYDVQQIEwxXZXN0ZXJuIENhcGUxEjAQBgNVBAcTCUNhcGUgVG93bjEa
MBgGA1UEChMRVGhhd3RlIENvbnN1bHRpbmcxKDAmBgNVBAsTH0NlcnRpZmljYXRpb24gU2Vy
dmljZXMgRGl2aXNpb24xJDAiBgNVBAMTG1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBDQTEr
MCkGCSqGSIb3DQEJARYccGVyc29uYWwtZnJlZW1haWxAdGhhd3RlLmNvbTAeFw0wMzA3MTcw
MDAwMDBaFw0xMzA3MTYyMzU5NTlaMGIxCzAJBgNVBAYTAlpBMSUwIwYDVQQKExxUaGF3dGUg
Q29uc3VsdGluZyAoUHR5KSBMdGQuMSwwKgYDVQQDEyNUaGF3dGUgUGVyc29uYWwgRnJlZW1h
aWwgSXNzdWluZyBDQTCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAxKY8VXNV+065ypla
HmjAdQRwnd/p/6Me7L3N9VvyGna9fww6YfK/Uc4B1OVQCjDXAmNaLIkVcI7dyfArhVqqP3FW
y688Cwfn8R+RNiQqE88r1fOCdz0Dviv+uxg+B79AgAJk16emu59l0cUqVIUPSAR/p7bRPGEE
QB5kGXJgt/sCAwEAAaOBlDCBkTASBgNVHRMBAf8ECDAGAQH/AgEAMEMGA1UdHwQ8MDowOKA2
oDSGMmh0dHA6Ly9jcmwudGhhd3RlLmNvbS9UaGF3dGVQZXJzb25hbEZyZWVtYWlsQ0EuY3Js
MAsGA1UdDwQEAwIBBjApBgNVHREEIjAgpB4wHDEaMBgGA1UEAxMRUHJpdmF0ZUxhYmVsMi0x
MzgwDQYJKoZIhvcNAQEFBQADgYEASIzRUIPqCy7MDaNmrGcPf6+svsIXoUOWlJ1/TCG4+DYf
qi2fNi/A9BxQIJNwPP2t4WFiw9k6GX6EsZkbAMUaC4J0niVQlGLH2ydxVyWN3amcOY6MIE9l
X5Xa9/eH1sYITq726jTlEBpbNU1341YheILcIRk13iSx0x1G/11fZU8xggNxMIIDbQIBATB2
MGIxCzAJBgNVBAYTAlpBMSUwIwYDVQQKExxUaGF3dGUgQ29uc3VsdGluZyAoUHR5KSBMdGQu
MSwwKgYDVQQDEyNUaGF3dGUgUGVyc29uYWwgRnJlZW1haWwgSXNzdWluZyBDQQIQdwAaUPBT
Q2qMV601DYP+ETAJBgUrDgMCGgUAoIIB0DAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwG
CSqGSIb3DQEJBTEPFw0wODA4MDQxNzM5MDVaMCMGCSqGSIb3DQEJBDEWBBQK8Vh0APYXqkWJ
UjoPX/CH6s/Q9jBfBgkqhkiG9w0BCQ8xUjBQMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAO
BggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgw
gYUGCSsGAQQBgjcQBDF4MHYwYjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25z
dWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJ
c3N1aW5nIENBAhB3ABpQ8FNDaoxXrTUNg/4RMIGHBgsqhkiG9w0BCRACCzF4oHYwYjELMAkG
A1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNV
BAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAhB3ABpQ8FNDaoxXrTUN
g/4RMA0GCSqGSIb3DQEBAQUABIIBAHmWpz8IstfsmvCZzkFdZ7P4TjI1WiDWIve0XqhjvxVf
gp/+RHl1y7yq1feW71lEceGIhVtia2x4RaBIXoEOtvtBkBQqHivgW4zKKdVkWiLm6oYbm7bx
bbIMizFp4yI6rvMzxufcFP2yPIpt2HC2YXo1oykZDNrjTadftOKsSc8a83rrYjXJ7glMXff7
yhOtL6V50RXdNC/WmbeQOeZ+0ppoPkVT0qOuJ9GIWMIBtlSAvfbasPspqlpoPeDk5tEfpQlq
XBk8QWC74hCGTwlkhlWJPSKb6WIpoRsWSAMZimO4SldMf4d6K3lVEd+AJ7XokYDW3lbqNUPM
Z0YKoKxZyDgAAAAAAAA=
--------------ms050109090904040106020201--
