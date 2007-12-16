Return-Path: <linux-kernel-owner+w=401wt.eu-S1765181AbXLPXXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765181AbXLPXXg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 18:23:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757905AbXLPXX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 18:23:26 -0500
Received: from powered.by.stone-is.net ([87.238.163.201]:55653 "EHLO
	vps.dupondje.be" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753424AbXLPXXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 18:23:25 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Dec 2007 18:23:24 EST
Message-ID: <4765B192.8050401@dupondje.be>
Date: Mon, 17 Dec 2007 00:15:30 +0100
From: Jean-Louis Dupond <info@dupondje.be>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: sata_mv not working with a RocketRaid 2220
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm trying to get my HighPoint RocketRaid Controller working with the 
sata_mv drivers.
But something is not working correctly :(

Kernel version 2.6.23.11 (also tried 2.6.24-rc5 with same results)
Controller in lspci: Marvell Technology Group Ltd. MV88SX6081 8-port 
SATA II PCI-X Controller (rev 07)

   1.
      Dec 16 22:44:29 localhost kernel: sata_mv 0000:05:08.0: Gen-II 32
      slots 8 ports SCSI mode IRQ via INTx
   2.
      Dec 16 22:44:29 localhost kernel: scsi4 : sata_mv
   3.
      Dec 16 22:44:29 localhost kernel: scsi5 : sata_mv
   4.
      Dec 16 22:44:29 localhost kernel: scsi6 : sata_mv
   5.
      Dec 16 22:44:29 localhost kernel: scsi7 : sata_mv
   6.
      Dec 16 22:44:29 localhost kernel: scsi8 : sata_mv
   7.
      Dec 16 22:44:29 localhost kernel: scsi9 : sata_mv
   8.
      Dec 16 22:44:29 localhost kernel: scsi10 : sata_mv
   9.
      Dec 16 22:44:29 localhost kernel: scsi11 : sata_mv
  10.
      Dec 16 22:44:29 localhost kernel: ata5: SATA max UDMA/133 cmd
      0x0000000000000000 ctl 0xffffc20010122120 bmdma 0x0000000000000000
      irq 16
  11.
      Dec 16 22:44:29 localhost kernel: ata6: SATA max UDMA/133 cmd
      0x0000000000000000 ctl 0xffffc20010124120 bmdma 0x0000000000000000
      irq 16
  12.
      Dec 16 22:44:29 localhost kernel: ata7: SATA max UDMA/133 cmd
      0x0000000000000000 ctl 0xffffc20010126120 bmdma 0x0000000000000000
      irq 16
  13.
      Dec 16 22:44:29 localhost kernel: ata8: SATA max UDMA/133 cmd
      0x0000000000000000 ctl 0xffffc20010128120 bmdma 0x0000000000000000
      irq 16
  14.
      Dec 16 22:44:29 localhost kernel: ata9: SATA max UDMA/133 cmd
      0x0000000000000000 ctl 0xffffc20010132120 bmdma 0x0000000000000000
      irq 16
  15.
      Dec 16 22:44:29 localhost kernel: ata10: SATA max UDMA/133 cmd
      0x0000000000000000 ctl 0xffffc20010134120 bmdma 0x0000000000000000
      irq 16
  16.
      Dec 16 22:44:29 localhost kernel: ata11: SATA max UDMA/133 cmd
      0x0000000000000000 ctl 0xffffc20010136120 bmdma 0x0000000000000000
      irq 16
  17.
      Dec 16 22:44:29 localhost kernel: ata12: SATA max UDMA/133 cmd
      0x0000000000000000 ctl 0xffffc20010138120 bmdma 0x0000000000000000
      irq 16
  18.
      Dec 16 22:44:29 localhost kernel: ata5: SATA link up 3.0 Gbps
      (SStatus 123 SControl 300)
  19.
      Dec 16 22:44:29 localhost kernel: ata5.00: ATA-7: SAMSUNG SP2504C,
      VT100-33, max UDMA7
  20.
      Dec 16 22:44:29 localhost kernel: ata5.00: 488397168 sectors,
      multi 0: LBA48 NCQ (depth 0/32)
  21.
      Dec 16 22:44:29 localhost kernel: ata5.00: configured for UDMA/133
  22.
      Dec 16 22:44:29 localhost kernel: ata6: SATA link up 3.0 Gbps
      (SStatus 123 SControl 300)
  23.
      Dec 16 22:44:29 localhost kernel: ata6.00: ATA-7: SAMSUNG SP2504C,
      VT100-33, max UDMA7
  24.
      Dec 16 22:44:29 localhost kernel: ata6.00: 488397168 sectors,
      multi 0: LBA48 NCQ (depth 0/32)
  25.
      Dec 16 22:44:29 localhost kernel: ata6.00: configured for UDMA/133
  26.
      Dec 16 22:44:29 localhost kernel: ata7: SATA link up 3.0 Gbps
      (SStatus 123 SControl 300)
  27.
      Dec 16 22:44:29 localhost kernel: ata7.00: ATA-7: SAMSUNG SP2504C,
      VT100-33, max UDMA7
  28.
      Dec 16 22:44:29 localhost kernel: ata7.00: 488397168 sectors,
      multi 0: LBA48 NCQ (depth 0/32)
  29.
      Dec 16 22:44:29 localhost kernel: ata7.00: configured for UDMA/133
  30.
      Dec 16 22:44:29 localhost kernel: ata8: SATA link up 3.0 Gbps
      (SStatus 123 SControl 300)
  31.
      Dec 16 22:44:29 localhost kernel: ata8.00: ATA-7: SAMSUNG SP2504C,
      VT100-33, max UDMA7
  32.
      Dec 16 22:44:29 localhost kernel: ata8.00: 488397168 sectors,
      multi 0: LBA48 NCQ (depth 0/32)
  33.
      Dec 16 22:44:29 localhost kernel: ata8.00: configured for UDMA/133
  34.
      Dec 16 22:44:29 localhost kernel: ata9: SATA link up 3.0 Gbps
      (SStatus 123 SControl 300)
  35.
      Dec 16 22:44:29 localhost kernel: ata9.00: ATA-7: SAMSUNG SP2504C,
      VT100-33, max UDMA7
  36.
      Dec 16 22:44:29 localhost kernel: ata9.00: 488397168 sectors,
      multi 0: LBA48 NCQ (depth 0/32)
  37.
      Dec 16 22:44:29 localhost kernel: ata9.00: configured for UDMA/133
  38.
      Dec 16 22:44:29 localhost kernel: ata10: SATA link down (SStatus 0
      SControl 300)
  39.
      Dec 16 22:44:29 localhost kernel: ata11: SATA link up 3.0 Gbps
      (SStatus 123 SControl 300)
  40.
      Dec 16 22:44:29 localhost kernel: ata11.00: ATA-7: SAMSUNG
      SP2504C, VT100-33, max UDMA7
  41.
      Dec 16 22:44:29 localhost kernel: ata11.00: 488397168 sectors,
      multi 0: LBA48 NCQ (depth 0/32)
  42.
      Dec 16 22:44:29 localhost kernel: ata11.00: configured for UDMA/133
  43.
      Dec 16 22:44:29 localhost kernel: ata12: SATA link down (SStatus 0
      SControl 300)
  44.
      Dec 16 22:44:29 localhost kernel: scsi 4:0:0:0: Direct-Access    
      ATA      SAMSUNG SP2504C  VT10 PQ: 0 ANSI: 5
  45.
      Dec 16 22:44:29 localhost kernel: sd 4:0:0:0: [sdb] 488397168
      512-byte hardware sectors (250059 MB)
  46.
      Dec 16 22:44:29 localhost kernel: sd 4:0:0:0: [sdb] Write Protect
      is off
  47.
      Dec 16 22:44:29 localhost kernel: sd 4:0:0:0: [sdb] Mode Sense: 00
      3a 00 00
  48.
      Dec 16 22:44:29 localhost kernel: sd 4:0:0:0: [sdb] Write cache:
      enabled, read cache: enabled, doesn't support DPO or FUA
  49.
      Dec 16 22:44:29 localhost kernel: sd 4:0:0:0: [sdb] 488397168
      512-byte hardware sectors (250059 MB)
  50.
      Dec 16 22:44:29 localhost kernel: sd 4:0:0:0: [sdb] Write Protect
      is off
  51.
      Dec 16 22:44:29 localhost kernel: sd 4:0:0:0: [sdb] Mode Sense: 00
      3a 00 00
  52.
      Dec 16 22:44:29 localhost kernel: sd 4:0:0:0: [sdb] Write cache:
      enabled, read cache: enabled, doesn't support DPO or FUA
  53.
      Dec 16 22:44:29 localhost kernel:  sdb:<3>ata5.00: exception Emask
      0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
  54.
      Dec 16 22:44:29 localhost kernel: ata5.00: cmd
      c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
  55.
      Dec 16 22:44:29 localhost kernel:          res
      40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
  56.
      Dec 16 22:44:29 localhost kernel: ata5: soft resetting port
  57.
      Dec 16 22:44:29 localhost kernel: ata5: SATA link up 3.0 Gbps
      (SStatus 123 SControl 300)
  58.
      Dec 16 22:44:29 localhost kernel: ata5.00: configured for UDMA/133
  59.
      Dec 16 22:44:29 localhost kernel: ata5: EH complete
  60.
      Dec 16 22:44:29 localhost kernel: ata5.00: exception Emask 0x0
      SAct 0x0 SErr 0x0 action 0x2 frozen
  61.
      Dec 16 22:44:29 localhost kernel: ata5.00: cmd
      c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
  62.
      Dec 16 22:44:29 localhost kernel:          res
      40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
  63.
      Dec 16 22:44:29 localhost kernel: ata5: soft resetting port
  64.
      Dec 16 22:44:29 localhost kernel: ata5: SATA link up 3.0 Gbps
      (SStatus 123 SControl 300)
  65.
      Dec 16 22:44:29 localhost kernel: ata5.00: configured for UDMA/133
  66.
      Dec 16 22:44:29 localhost kernel: ata5: EH complete
  67.
      Dec 16 22:44:29 localhost kernel: ata5.00: exception Emask 0x0
      SAct 0x0 SErr 0x0 action 0x2 frozen
  68.
      Dec 16 22:44:29 localhost kernel: ata5.00: cmd
      c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
  69.
      Dec 16 22:44:29 localhost kernel:          res
      40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
  70.
      Dec 16 22:44:29 localhost kernel: ata5: soft resetting port
  71.
      Dec 16 22:44:29 localhost kernel: ata5: SATA link up 3.0 Gbps
      (SStatus 123 SControl 300)
  72.
      Dec 16 22:44:29 localhost kernel: ata5.00: configured for UDMA/133
  73.
      Dec 16 22:44:29 localhost kernel: ata5: EH complete
  74.
      Dec 16 22:44:29 localhost kernel: ata5: limiting SATA link speed
      to 1.5 Gbps
  75.
      Dec 16 22:44:29 localhost kernel: ata5.00: exception Emask 0x0
      SAct 0x0 SErr 0x0 action 0x6 frozen
  76.
      Dec 16 22:44:29 localhost kernel: ata5.00: cmd
      c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
  77.
      Dec 16 22:44:29 localhost kernel:          res
      40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
  78.
      Dec 16 22:44:29 localhost kernel: ata5: hard resetting port
  79.
      Dec 16 22:44:29 localhost kernel: ata5: SATA link up 3.0 Gbps
      (SStatus 123 SControl 300)
  80.
      Dec 16 22:44:29 localhost kernel: ata5.00: configured for UDMA/133
  81.
      Dec 16 22:44:29 localhost kernel: ata5: EH complete
  82.
      Dec 16 22:44:29 localhost kernel: ata5.00: exception Emask 0x0
      SAct 0x0 SErr 0x0 action 0x2 frozen
  83.
      Dec 16 22:44:29 localhost kernel: ata5.00: cmd
      c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
  84.
      Dec 16 22:44:29 localhost kernel:          res
      40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
  85.
      Dec 16 22:44:29 localhost kernel: ata5: hard resetting port
  86.
      Dec 16 22:44:29 localhost kernel: ata5: SATA link up 3.0 Gbps
      (SStatus 123 SControl 300)
  87.
      Dec 16 22:44:29 localhost kernel: ata5.00: configured for UDMA/133


