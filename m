Return-Path: <linux-kernel-owner+w=401wt.eu-S1759363AbYH2VkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759363AbYH2VkO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 17:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbYH2Vj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 17:39:59 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:19381 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbYH2Vj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 17:39:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=mcSy+Yvu6B/e1wGGCf5Yha5RucVF9QujSXYQm3RLIFdePCBEdatN/fZJYx9ho06Q5H
         EBs/5zZU7dGUylqQK4syqbBusbg/RTyXnBotwHkzx1xnWBrwhA0YROu78bEipmmF7ESQ
         7/29I7rXcXsphKF3pWdNyFoZ2CYh0d6FFqVDw=
Message-ID: <86802c440808291439o156f4f28v4b93e0105b4fe3b3@mail.gmail.com>
Date: Fri, 29 Aug 2008 14:39:57 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Alexander Huemer" <alexander.huemer@sbg.ac.at>
Subject: Re: 2.6.27 mtrr fixes do not work
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Helge Hafting" <helge.hafting@aitel.hist.no>
In-Reply-To: <48B849BD.4000405@sbg.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4899AF8E.20105@sbg.ac.at>
	 <86802c440808251322l72546d59o90c4e0b87c81538c@mail.gmail.com>
	 <48B31508.6020305@sbg.ac.at>
	 <86802c440808251344h697a27d0i91486a836d258cb@mail.gmail.com>
	 <86802c440808251624u181a98eesd8a19ea6fd3d8d8c@mail.gmail.com>
	 <48B34056.5080100@sbg.ac.at>
	 <86802c440808251633s7bf8ecb2ua6ef187b5be563db@mail.gmail.com>
	 <48B81138.4060601@sbg.ac.at>
	 <86802c440808291043s774d3913k85de758f2e23b24b@mail.gmail.com>
	 <48B849BD.4000405@sbg.ac.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 12:10 PM, Alexander Huemer
<alexander.huemer@sbg.ac.at> wrote:
> http://xx.vu/~ahuemer/dmesg_5.txt
> http://xx.vu/~ahuemer/lspci_vvxxx.txt
> http://xx.vu/~ahuemer/lspci_tv.txt
>

pci 0000:00:1e.0:   IO window: 0x3000-0x3fff
pci 0000:00:1e.0:   MEM window: 0xdc300000-0xdc3fffff
pci 0000:00:1e.0:   PREFETCH window: 0x000000d8000000-0x000000dbffffff

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d9)
(prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=20, subordinate=20, sec-latency=32
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: dc300000-dc3fffff
	Prefetchable memory behind bridge: 00000000d8000000-00000000dbffffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Subsystem: Tyan Computer Device 5397
00: 86 80 4e 24 07 00 10 00 d9 01 04 06 00 00 01 00
10: 00 00 00 00 00 00 00 00 00 20 20 20 30 30 80 22
20: 30 dc 30 dc 01 d8 f1 db 00 00 00 00 00 00 00 00
30: 00 00 00 00 50 00 00 00 00 00 00 00 ff 00 0c 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 0d 00 00 00 f1 10 97 53 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 80 0f 01 00 00 00 00 00

20:05.0 VGA compatible controller: XGI Technology Inc. (eXtreme
Graphics Innovation) Volari Z7 (prog-if 00 [VGA controller])
	Subsystem: XGI Technology Inc. (eXtreme Graphics Innovation) Volari Z7
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	BIST result: 00
	Region 0: Memory at d8000000 (32-bit, prefetchable) [size=64M]
	Region 1: Memory at dc300000 (32-bit, non-prefetchable) [size=256K]
	Region 2: I/O ports at 3000 [size=128]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: ca 18 20 00 03 00 30 02 00 00 00 03 00 00 00 80
10: 08 00 00 d8 00 00 30 dc 01 30 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 ca 18 20 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 00 00 00 00
40: 01 00 02 06 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

mtrr: 0xd8000000,0x2000000 overlaps existing 0xd8000000,0x800000

so it seems your card HW said it need 64M,

someone (BIOS or vgabios?) set 8M for it at first. and with write-back...

   # cat /proc/mtrr
   reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
   reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
   reg02: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
   reg03: base=0xd8000000 (3456MB), size=   8MB: write-back, count=1

before loading X drivers, need to remove that entry at first.

echo "disable=3" > /proc/mtrr

YH
