Return-Path: <linux-kernel-owner+w=401wt.eu-S1756911AbXICLAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbXICLAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 07:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753894AbXICLAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 07:00:37 -0400
Received: from highlandsun.propagation.net ([66.221.212.168]:3856 "EHLO
	highlandsun.propagation.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753354AbXICLAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 07:00:36 -0400
X-Greylist: delayed 2039 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Sep 2007 07:00:36 EDT
Message-ID: <46DBE1FD.10409@symas.com>
Date: Mon, 03 Sep 2007 03:29:17 -0700
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.9a8pre) Gecko/2007082216 SeaMonkey/2.0a1pre
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: 2.6.22.6 pata_via cable detect
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Still have a slight glitch here. I have 2 hard drives on the primary channel, 
detected correctly as 80-wire and UDMA100. I have a DVD burner on the secondary 
channel, detected incorrectly as 40-wire. (It's sitting by itself on an 80-wire 
cable.) This is on an Asus A8V-Deluxe.

Here's the dmesg output after a "modprobe pata_via"

pata_via 0000:00:0f.1: version 0.3.1
ACPI: PCI Interrupt 0000:00:0f.1[A] -> GSI 20 (level, low) -> IRQ 20
scsi5 : pata_via
scsi6 : pata_via
ata6: PATA max UDMA/133 cmd 0x00000000000101f0 ctl 0x00000000000103f6 bmdma 
0x000000000001fc00 irq 14
ata7: PATA max UDMA/133 cmd 0x0000000000010170 ctl 0x0000000000010376 bmdma 
0x000000000001fc08 irq 15
ata6.00: ATA-6: WDC WD2000JB-00DUA0, 70.13G70, max UDMA/100
ata6.00: 390721968 sectors, multi 16: LBA48
ata6.01: ATA-7: WDC WD5000AAKB-00UKA0, 07.01N01, max UDMA/100
ata6.01: 976773168 sectors, multi 16: LBA48
ata6.00: configured for UDMA/100
ata6.01: configured for UDMA/100
ata7.00: ATAPI: LITE-ON DVDRW LH-20A1H, LL07, max UDMA/66
ata7.00: limited to UDMA/33 due to 40-wire cable
ata7.00: configured for UDMA/33
scsi 5:0:0:0: Direct-Access     ATA      WDC WD2000JB-00D 70.1 PQ: 0 ANSI: 5
sd 5:0:0:0: [sde] 390721968 512-byte hardware sectors (200050 MB)
sd 5:0:0:0: [sde] Write Protect is off
sd 5:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
sd 5:0:0:0: [sde] 390721968 512-byte hardware sectors (200050 MB)
sd 5:0:0:0: [sde] Write Protect is off
sd 5:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
  sde: sde1
sd 5:0:0:0: [sde] Attached SCSI disk
sd 5:0:0:0: Attached scsi generic sg4 type 0
scsi 5:0:1:0: Direct-Access     ATA      WDC WD5000AAKB-0 07.0 PQ: 0 ANSI: 5
sd 5:0:1:0: [sdf] 976773168 512-byte hardware sectors (500108 MB)
sd 5:0:1:0: [sdf] Write Protect is off
sd 5:0:1:0: [sdf] Mode Sense: 00 3a 00 00
sd 5:0:1:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
sd 5:0:1:0: [sdf] 976773168 512-byte hardware sectors (500108 MB)
sd 5:0:1:0: [sdf] Write Protect is off
sd 5:0:1:0: [sdf] Mode Sense: 00 3a 00 00
sd 5:0:1:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
  sdf: unknown partition table
sd 5:0:1:0: [sdf] Attached SCSI disk
sd 5:0:1:0: Attached scsi generic sg5 type 0
scsi 6:0:0:0: CD-ROM            LITE-ON  DVDRW LH-20A1H   LL07 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 6:0:0:0: Attached scsi CD-ROM sr0
sr 6:0:0:0: Attached scsi generic sg6 type 5

Let me know what other info you need.
-- 
   -- Howard Chu
   Chief Architect, Symas Corp.  http://www.symas.com
   Director, Highland Sun        http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP     http://www.openldap.org/project/
