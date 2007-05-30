Return-Path: <linux-kernel-owner+w=401wt.eu-S1758097AbXE3XKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097AbXE3XKP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 19:10:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756340AbXE3XJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 19:09:52 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:48628 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852AbXE3XJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 19:09:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=aPvUKpRBJuXNdQ/OjKG/NDu7oxRG8X2aU001GicsUST/ZoakfpE2/xCRdgyfzLM5GFWqkac6IaAknudRTtktJrBBOHuWKcUBnyhpAeBAn+4RRHCrwfXey2Qmn9H+saad0HUapF9l5osepC3TwuMSjd1Dm1y/GA+KhMgUVkGPZHE=
Message-ID: <ec36785a0705301609t62676c76q3a2b726bf51d50db@mail.gmail.com>
Date: Wed, 30 May 2007 20:09:44 -0300
From: "Reinaldo Carvalho" <reinaldow@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: megaraid.c, all kernel versions, problem with multi-luns
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a Dell PowerEdge Expandable RAID controller, with a hardware
Raid-5 at Channel 01 running perfectly, and a nCipher Crypter at
Channel 02.

This controller doesn't correctly detect devices (e.g. nCipher
Crypter) with multiples LUNs. Only one LUN is detected.

At another controller (e.g. Adaptec 79xx) two LUNs were detect. I
compiled 2.6.8, 2.6.18 and 2.6.21.3 to test megaraid driver and all
failed detecting two LUNs.

I think that this is a firmware problem, but i'd like have some opinions.

I read some docs
(http://www.suse.de/~garloff/linux/scsi-scan/scsi-scanning.html,
http://www.ictp.trieste.it/~radionet/nuc1996/ref/howto-html/scsi-howto-2.html)
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
        Region 2: Memory at defc0000 (32-bit, non-prefetchable) [size=256K]
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
