Return-Path: <linux-kernel-owner+w=401wt.eu-S1763936AbXJZHTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763936AbXJZHTb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 03:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765536AbXJZHRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 03:17:20 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:3728 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765465AbXJZHRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 03:17:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=DM6wIO38AFbw+CnDR2ZFUThSttWqHhyprJXfpLPJsFTQAgaoKcSXQUE2MyXetRSPGcKdS3vCx4sDV8gWcPHhRYIHKmvrfX8UJYE3IFE4LFvE3pwNSJjfzHiA+5Lg/NfJjSrahaM7GXrmn6QC4t/oXyopGB5jdWI/zhC4+3fy3qM=
Message-ID: <877aabc40710260017s76d9df1cq5f0dec00920a6772@mail.gmail.com>
Date: Fri, 26 Oct 2007 12:47:15 +0530
From: "Amit Shah" <amitshah@gmx.net>
To: "Jeff Garzik" <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: sata_nv: MCP51: SWNCQ messages
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: c6417b1333927991
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is what I get even with your libata-dev tree, upstream-linus
branch pulled on top of 2.6.24-rc1

[   22.427990] NFORCE-MCP51: IDE controller (0x10de:0x0265 rev 0xa1)
at  PCI slot 0000:00:0d.0
[   22.428006] NFORCE-MCP51: not 100% native mode: will probe irqs later
[   22.428011] NFORCE-MCP51: 0000:00:0d.0 (rev a1) UDMA133 controller
[   22.428016]     ide0: BM-DMA at 0xf400-0xf407, BIOS settings:
hda:DMA, hdb:DMA
[   22.428024]     ide1: BM-DMA at 0xf408-0xf40f, BIOS settings:
hdc:DMA, hdd:DMA
[   22.428030] Probing IDE interface ide0...
[   22.440137] sd 1:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
[   22.440148] sd 1:0:0:0: [sda] Write Protect is off
[   22.440150] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   22.440161] sd 1:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   22.440197] sd 1:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
[   22.440204] sd 1:0:0:0: [sda] Write Protect is off
[   22.440206] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   22.440216] sd 1:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   22.440219]  sda:hda: HL-DT-ST DVDRAM GSA-H44N, ATAPI CD/DVD-ROM drive
[   23.404042] hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[   23.405095] hda: selected mode 0x44
[   23.405573] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   23.408351] Probing IDE interface ide1...
[   23.934284] hda: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB
Cache, UDMA(66)
[   23.934293] Uniform CD-ROM driver Revision: 3.20
[   52.394470] ata2: EH in SWNCQ mode,QC:qc_active 0x1 sactive 0x1
[   52.394475] ata2: SWNCQ:qc_active 0x1 defer_bits 0x0 last_issue_tag 0x0
[   52.394476]   dhfis 0x0 dmafis 0x1 sdbfis 0x0
[   52.394479] ata2: ATA_REG 0x40 ERR_REG 0x0
[   52.394480] ata2: tag : dhfis dmafis sdbfis sacitve
[   52.394482] ata2: tag 0x0: 0 1 0 0
[   52.394493] ata2.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
[   52.394498] ata2.00: cmd 60/08:00:00:00:00/00:00:00:00:00/40 tag 0
cdb 0x0 data 4096 in
[   52.394499]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[   52.394501] ata2.00: status: { DRDY }
[   52.394508] ata2: hard resetting link
[   52.849792] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   52.971677] ata2.00: configured for UDMA/133
[   52.971685] ata2: EH complete
[   52.971749] sd 1:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
[   52.971759] sd 1:0:0:0: [sda] Write Protect is off
[   52.971760] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   52.971773] sd 1:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   82.926704] ata2: EH in SWNCQ mode,QC:qc_active 0x1 sactive 0x1
[   82.926736] ata2: SWNCQ:qc_active 0x1 defer_bits 0x0 last_issue_tag 0x0
[   82.926737]   dhfis 0x0 dmafis 0x1 sdbfis 0x0
[   82.926766] ata2: ATA_REG 0x40 ERR_REG 0x0
[   82.926792] ata2: tag : dhfis dmafis sdbfis sacitve
[   82.926819] ata2: tag 0x0: 0 1 0 0
[   82.926854] ata2.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
[   82.926885] ata2.00: cmd 60/08:00:00:00:00/00:00:00:00:00/40 tag 0
cdb 0x0 data 4096 in
[   82.926887]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[   82.926918] ata2.00: status: { DRDY }
[   82.926949] ata2: hard resetting link
[   83.382022] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   83.509315] ata2.00: configured for UDMA/133
[   83.509324] ata2: EH complete
[   83.509385] sd 1:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
[   83.509395] sd 1:0:0:0: [sda] Write Protect is off
[   83.509397] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   83.509409] sd 1:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[  113.463919] ata2: EH in SWNCQ mode,QC:qc_active 0x1 sactive 0x1
[  113.463949] ata2: SWNCQ:qc_active 0x1 defer_bits 0x0 last_issue_tag 0x0
[  113.463950]   dhfis 0x0 dmafis 0x1 sdbfis 0x0
[  113.463980] ata2: ATA_REG 0x40 ERR_REG 0x0
[  113.464006] ata2: tag : dhfis dmafis sdbfis sacitve
[  113.464033] ata2: tag 0x0: 0 1 0 0
[  113.464065] ata2.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
[  113.464097] ata2.00: cmd 60/08:00:00:00:00/00:00:00:00:00/40 tag 0
cdb 0x0 data 4096 in
[  113.464098]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[  113.464129] ata2.00: status: { DRDY }


-- 
Amit Shah
http://www.amitshah.net/
