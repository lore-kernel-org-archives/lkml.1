Return-Path: <linux-kernel-owner+w=401wt.eu-S1765040AbYETMXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765040AbYETMXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 08:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755243AbYETMXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 08:23:14 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:60341 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917AbYETMXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 08:23:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:subject:date:mime-version:content-type:content-transfer-encoding:x-priority:x-msmail-priority:x-mailer:x-mimeole;
        b=fp8Gk80Dx6euFbEg7q6HadoRYRWOYXGRC9crWI8ChlwD/+pyGSGGzgVf4Q30r73oVBB3FTN2w2qGRlexi/QRkcEiMB6G9lwZpKq+ZwsOxOkPaP8mxzoGy60d7W6Wc+UGfIiE1xS8P9yBNJXGAR9k+qcpgPjv7i6d+pp9HeBAEMg=
Message-ID: <001901c8ba74$4662ec80$01fca8c0@microsof60b8d6>
From: "Gavin Shan" <shan.gavin.cn@gmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: PIIX4 DMA Timeout
Date: Tue, 20 May 2008 20:23:11 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m4KCNPHl024328

Hi All,

There has one MV64460 on my board, which includes 2 PCI bridges. PIIX4 is on slot 3 of PCI1.
But now, IDE driver reported it's timeouted on DMA operation. Thanks in advance for your
suggestions.

Resources of PIIX4 function 1
=====================
0001:00:03.1: idx=0 flags=0x20000110 start=0x00000000 end=0x00000007
0001:00:03.1: idx=1 flags=0x20000110 start=0x00000000 end=0x00000000
0001:00:03.1: idx=2 flags=0x20000110 start=0x00000000 end=0x00000007
0001:00:03.1: idx=3 flags=0x20000110 start=0x00000000 end=0x00000000
0001:00:03.1: idx=4 flags=0x00000101 start=0xd8000000 end=0xd800000f

Console Output
============
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
PIIX4: IDE controller at PCI slot 0001:00:03.1
0001:00:03.1: idx=0 flags=0x20000110 start=0x00000000 end=0x00000007
0001:00:03.1: idx=1 flags=0x20000110 start=0x00000000 end=0x00000000
0001:00:03.1: idx=2 flags=0x20000110 start=0x00000000 end=0x00000007
0001:00:03.1: idx=3 flags=0x20000110 start=0x00000000 end=0x00000000
0001:00:03.1: idx=4 flags=0x00000101 start=0xd8000000 end=0xd800000f
PIIX4: chipset revision 1
PIIX4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xd8000000-0xd8000007, BIOS settings: hda:pio, hdb:pio
    ide1: BM-DMA at 0xd8000008-0xd800000f, BIOS settings: hdc:pio, hdd:pio
hdc: HTE721010G9AT00, ATA DISK drive
hdc: max request size: 512KiB
hdc: 195371568 sectors (100030 MB) w/7539KiB Cache, CHS=16383/255/63, UDMA(33)
hdc: cache flushes supported
 hdc:<4>hdc: dma_timer_expiry: dma status == 0x26
hdc: DMA interrupt recovery
hdc: lost interrupt
hdc: dma_intr: status=0x58 { DriveReady SeekComplete DataRequest }
ide: failed opcode was: unknown
hdc: DMA disabled
ide1: reset: success
 hdc2 hdc3 hdc4

Thanks in advance,
Gavinÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
