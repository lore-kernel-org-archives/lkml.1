Return-Path: <linux-kernel-owner+w=401wt.eu-S1755612AbYHCUbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612AbYHCUbF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 16:31:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754381AbYHCUax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 16:30:53 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:29284 "EHLO
	pd6mo1no-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753754AbYHCUaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 16:30:52 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=5rW-5UJGG99LPoD6YTsA:9 a=lg-_jd7fMRu-bbedVGkA:7 a=-v9R2VhDpNyU_sk4TgwJSxn2yC0A:4 a=8_TzU-rOkHMA:10 a=haiq3Cp6CaIA:10
Message-ID: <4896157A.2020907@shaw.ca>
Date: Sun, 03 Aug 2008 14:30:50 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Juergen Kreileder <jk@blackdown.de>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: SW-IOMMU / ata_piix errors with 2.6.27-rc1
References: <fa.64b92XSd5HpCdpOYcDENnJSZJyw@ifi.uio.no>
In-Reply-To: <fa.64b92XSd5HpCdpOYcDENnJSZJyw@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Juergen Kreileder wrote:
> Hi,
> 
> I get lots of errors like this with 2.6.27-rc1 on my
> Macbook Pro (3rd generation), 2.6.26 seems to work fine:
> 
> [  907.524509] DMA: Out of SW-IOMMU space for 45056 bytes at device 0000:00:1f.2
> [  907.524783] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> [  907.524796] ata3.00: cmd 35/00:50:08:91:5c/00:01:0f:00:00/e0 tag 0 dma 172032 out
> [  907.524798]          res 50/00:00:ff:90:5c/00:00:0f:00:00/ef Emask 0x40 (internal error)
> [  907.524805] ata3.00: status: { DRDY }
> [  907.646590] ata3.00: configured for UDMA/133
> [  907.646624] ata3: EH complete
> [  907.647028] DMA: Out of SW-IOMMU space for 45056 bytes at device 0000:00:1f.2
> [  907.647139] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> [  907.647161] ata3.00: cmd 35/00:50:08:91:5c/00:01:0f:00:00/e0 tag 0 dma 172032 out
> [  907.647166]          res 50/00:00:af:ea:42/00:00:25:00:00/e0 Emask 0x40 (internal error)
> [  907.647178] ata3.00: status: { DRDY }
> [  907.693193] ata3.00: configured for UDMA/133
> [  907.693225] ata3: EH complete
> [  907.693629] DMA: Out of SW-IOMMU space for 45056 bytes at device 0000:00:1f.2
> [  907.693684] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> [  907.693696] ata3.00: cmd 35/00:50:08:91:5c/00:01:0f:00:00/e0 tag 0 dma 172032 out
> [  907.693698]          res 50/00:00:af:ea:42/00:00:25:00:00/e0 Emask 0x40 (internal error)
> [  907.693784] ata3.00: status: { DRDY }
> [  907.739868] ata3.00: configured for UDMA/133
> [  907.739899] ata3: EH complete
> [  907.740255] DMA: Out of SW-IOMMU space for 45056 bytes at device 0000:00:1f.2
> [  907.740255] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> [  907.740389] ata3.00: cmd 35/00:50:08:91:5c/00:01:0f:00:00/e0 tag 0 dma 172032 out
> [  907.740394]          res 50/00:00:af:ea:42/00:00:25:00:00/e0 Emask 0x40 (internal error)
> [  907.740406] ata3.00: status: { DRDY }
> [  907.785818] ata3.00: configured for UDMA/133
> [  907.785850] ata3: EH complete
> [  907.786124] DMA: Out of SW-IOMMU space for 45056 bytes at device 0000:00:1f.2
> [  907.786206] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> [  907.786230] ata3.00: cmd 35/00:50:08:91:5c/00:01:0f:00:00/e0 tag 0 dma 172032 out
> [  907.786235]          res 50/00:00:af:ea:42/00:00:25:00:00/e0 Emask 0x40 (internal error)
> [  907.786249] ata3.00: status: { DRDY }
> [  907.831742] ata3.00: configured for UDMA/133
> [  907.831774] ata3: EH complete
> [  907.832087] DMA: Out of SW-IOMMU space for 45056 bytes at device 0000:00:1f.2
> [  907.832163] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> [  907.832186] ata3.00: cmd 35/00:50:08:91:5c/00:01:0f:00:00/e0 tag 0 dma 172032 out
> [  907.832191]          res 50/00:00:af:ea:42/00:00:25:00:00/e0 Emask 0x40 (internal error)
> [  907.832284] ata3.00: status: { DRDY }
> [  907.877603] ata3.00: configured for UDMA/133
> [  907.877646] sd 2:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
> [  907.877654] sd 2:0:0:0: [sda] Sense Key : Aborted Command [current] [descriptor]
> [  907.877664] Descriptor sense data with sense descriptors (in hex):
> [  907.877668]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
> [  907.877688]         25 42 ea af 
> [  907.877696] sd 2:0:0:0: [sda] Add. Sense: No additional sense information
> [  907.877704] end_request: I/O error, dev sda, sector 257724680
> [  907.877714] Buffer I/O error on device sda3, logical block 7728326
> [  907.877718] lost page write due to I/O error on sda3
> [  907.877727] Buffer I/O error on device sda3, logical block 7728327
> [  907.877731] lost page write due to I/O error on sda3
> [  907.877737] Buffer I/O error on device sda3, logical block 7728328
> [  907.877741] lost page write due to I/O error on sda3
> [  907.877747] Buffer I/O error on device sda3, logical block 7728329
> [  907.877751] lost page write due to I/O error on sda3
> [  907.877757] Buffer I/O error on device sda3, logical block 7728330
> [  907.877762] lost page write due to I/O error on sda3
> [  907.877767] Buffer I/O error on device sda3, logical block 7728331
> [  907.877771] lost page write due to I/O error on sda3
> [  907.877777] Buffer I/O error on device sda3, logical block 7728332
> [  907.877781] lost page write due to I/O error on sda3
> [  907.877787] Buffer I/O error on device sda3, logical block 7728333
> [  907.877791] lost page write due to I/O error on sda3
> [  907.877797] Buffer I/O error on device sda3, logical block 7728334
> [  907.877801] lost page write due to I/O error on sda3
> [  907.877864] ata3: EH complete
> [  907.878318] DMA: Out of SW-IOMMU space for 36864 bytes at device 0000:00:1f.2
> ..
> ..
> ..
> 
> I'm running an x86-64 kernel and the machine has 4GB.
> 
> [    2.819749] ata_piix 0000:00:1f.1: version 2.12
> [    2.819811] ata_piix 0000:00:1f.1: power state changed by ACPI to D0
> [    2.819816] ata_piix 0000:00:1f.1: PCI INT A -> GSI 21 (level, low) -> IRQ 21
> [    2.819850] ata_piix 0000:00:1f.1: setting latency timer to 64
> [    2.819941] scsi0 : ata_piix
> [    2.820165] scsi1 : ata_piix
> [    2.820621] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x60e0 irq 14
> [    2.820623] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x60e8 irq 15
> [    2.975131] ata1.00: ATAPI: MATSHITADVD-R   UJ-857E, ZA0E, max UDMA/66
> [    2.981027] ata1.00: configured for UDMA/66
> [    3.155025] scsi 0:0:0:0: CD-ROM            MATSHITA DVD-R   UJ-857E  ZA0E PQ: 0 ANSI: 5
> [    3.155025] ata_piix 0000:00:1f.2: PCI INT B -> GSI 18 (level, low) -> IRQ 18
> [    3.155025] ata_piix 0000:00:1f.2: MAP [ P0 -- -- -- ]
> [    3.155025] ata_piix 0000:00:1f.2: setting latency timer to 64
> [    3.171708] scsi2 : ata_piix
> [    3.183270] scsi3 : ata_piix
> [    3.184051] ata3: SATA max UDMA/133 cmd 0x60f8 ctl 0x6114 bmdma 0x6020 irq 18
> [    3.184053] ata4: SATA max UDMA/133 cmd 0x60f0 ctl 0x6110 bmdma 0x6028 irq 18
> [    3.355353] ata3.00: ATA-8: SAMSUNG HM320JI, 2SS00_01, max UDMA7
> [    3.355358] ata3.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
> [    3.379686] ata3.00: configured for UDMA/133
> [    3.563969] scsi 2:0:0:0: Direct-Access     ATA      SAMSUNG HM320JI  2SS0 PQ: 0 ANSI: 5
> [    3.576523] scsi 0:0:0:0: Attached scsi generic sg0 type 5
> [    3.576555] scsi 2:0:0:0: Attached scsi generic sg1 type 0
> [    3.578422] Driver 'sd' needs updating - please use bus_type methods
> [    3.578503] sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
> [    3.578521] sd 2:0:0:0: [sda] Write Protect is off
> [    3.578522] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    3.578550] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    3.578625] sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
> [    3.578643] sd 2:0:0:0: [sda] Write Protect is off
> [    3.578644] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    3.578678] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    3.578680]  sda:<6>usb 7-1: configuration #1 chosen from 1 choice
> [    4.174973]  sda1 sda2 sda3 sda4 sda5
> [    4.175168] sd 2:0:0:0: [sda] Attached SCSI disk
> 
> 
> 00:1f.2 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) SATA IDE Controller (rev 03) (prog-if 8f [Master SecP SecO PriP PriO])
>         Subsystem: Apple Computer Inc. Device 00a0
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin B routed to IRQ 18
>         Region 0: I/O ports at 60f8 [size=8]
>         Region 1: I/O ports at 6114 [size=4]
>         Region 2: I/O ports at 60f0 [size=8]
>         Region 3: I/O ports at 6110 [size=4]
>         Region 4: I/O ports at 6020 [size=16]
>         Region 5: I/O ports at 1000 [size=16]
>         Capabilities: <access denied>
>         Kernel driver in use: ata_piix
>         Kernel modules: ata_piix, pata_acpi, ata_generic
> 
> 
> Any suggestions?

You can try increasing the swiotlb size by booting with swiotlb=65536 
(for 128MB) or swiotlb=131072 (for 256MB), and see if that makes the 
problem go away.. It's unclear why you'd be running out of SWIOTLB space 
now, though, if 2.6.26 worked fine..

I wonder why Apple hasn't set up the SATA controller in AHCI mode on 
these machines. If they had, you wouldn't have this problem as it would 
support 64-bit DMA and not need the SWIOTLB.
