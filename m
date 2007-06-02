Return-Path: <linux-kernel-owner+w=401wt.eu-S1762995AbXFBBk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762995AbXFBBk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 21:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758131AbXFBBkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 21:40:22 -0400
Received: from mail0.lsil.com ([147.145.40.20]:50762 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757307AbXFBBkU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 21:40:20 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: megaraid.c, all kernel versions, problem with multi-luns
Date: Fri, 1 Jun 2007 19:40:16 -0600
Message-ID: <0631C836DBF79F42B5A60C8C8D4E8229B138A0@NAMAIL2.ad.lsil.com>
In-Reply-To: <ec36785a0705301609t62676c76q3a2b726bf51d50db@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: megaraid.c, all kernel versions, problem with multi-luns
Thread-Index: AcejD+6iK3pC8H51RKKT0wT3OBXv9ABptMgQ
From: "Patro, Sumant" <Sumant.Patro@lsi.com>
To: "Reinaldo Carvalho" <reinaldow@gmail.com>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 02 Jun 2007 01:40:17.0995 (UTC) FILETIME=[F97B29B0:01C7A4B6]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please check with the server provider if multi-lun is supported with the
adapter you are using.

--Sumant

-----Original Message-----
From: linux-kernel-owner@vger.kernel.org
[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Reinaldo
Carvalho
Sent: Wednesday, May 30, 2007 4:10 PM
To: linux-kernel@vger.kernel.org
Subject: megaraid.c, all kernel versions, problem with multi-luns

Hi,

I have a Dell PowerEdge Expandable RAID controller, with a hardware
Raid-5 at Channel 01 running perfectly, and a nCipher Crypter at Channel
02.

This controller doesn't correctly detect devices (e.g. nCipher
Crypter) with multiples LUNs. Only one LUN is detected.

At another controller (e.g. Adaptec 79xx) two LUNs were detect. I
compiled 2.6.8, 2.6.18 and 2.6.21.3 to test megaraid driver and all
failed detecting two LUNs.

I think that this is a firmware problem, but i'd like have some
opinions.

I read some docs
(http://www.suse.de/~garloff/linux/scsi-scan/scsi-scanning.html,
http://www.ictp.trieste.it/~radionet/nuc1996/ref/howto-html/scsi-howto-2
.html)
and this problem doesn't seem to be simple.

Best regards,

More information with Dell PowerEdge Expandable RAID controller (LSI
Logic MegaRaid):

Attached devices:
Host: scsi0 Channel: 00 Id: 06 Lun: 00
  Vendor: PE/PV    Model: 1x5 SCSI BP      Rev: 1.0
  Type:   Processor                        ANSI  SCSI revision: 02
Host: scsi0 Channel: 01 Id: 00 Lun: 00
  Vendor: nCipher  Model: Fastness Crypto  Rev: 2*00
  Type:   Processor                        ANSI  SCSI revision: 02
Host: scsi0 Channel: 02 Id: 00 Lun: 00
  Vendor: MegaRAID Model: LD 0 RAID5  279G Rev: 522A
  Type:   Direct-Access                    ANSI  SCSI revision: 02


14:0e.0 RAID bus controller: Dell PowerEdge Expandable RAID controller
4 (rev 06)
        Subsystem: Dell PowerEdge Expandable RAID Controller 4e/Di
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping+ SERR+ FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (32000ns min), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 22
        Region 0: Memory at d7ff0000 (32-bit, prefetchable) [size=64K]
        Region 2: Memory at defc0000 (32-bit, non-prefetchable)
[size=256K]
        Expansion ROM at df000000 [disabled] [size=128K]
        Capabilities: <access denied>

14:0e.0 0104: 1028:0013 (rev 06)


Information with Adaptec 79xx or others SCSI controllers:

Host: scsi0 Channel: 01 Id: 00 Lun: 00
  Vendor: nCipher  Model: Fastness Crypto  Rev: 2*00
  Type:   Processor                        ANSI  SCSI revision: 02
Host: scsi0 Channel: 01 Id: 00 Lun: 01
  Vendor: nCipher  Model: Fastness Crypto  Rev: 2*00
  Type:   Processor                        ANSI  SCSI revision: 02


--
Reinaldo Carvalho
-
To unsubscribe from this list: send the line "unsubscribe linux-kernel"
in the body of a message to majordomo@vger.kernel.org More majordomo
info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
