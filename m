Return-Path: <linux-kernel-owner+w=401wt.eu-S1752656AbZIXWey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbZIXWey (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 18:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbZIXWex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 18:34:53 -0400
Received: from mail001.aei.ca ([206.123.6.130]:60651 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585AbZIXWew convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 18:34:52 -0400
From: Ed Tomlinson <edt@aei.ca>
To: LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>
Subject: Strange .31 freeze - ata related
Date: Thu, 24 Sep 2009 18:34:53 -0400
User-Agent: KMail/1.11.4 (Linux/2.6.31.1-ejt-crc; KDE/4.2.4; x86_64; ; )
Cc: linux-ide@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200909241834.53852.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just had a strange freeze with 2.6.31.1-rc1.  Looking at the console log from startup I see that ata4 & ata5 have nothing connected.
Later while working the box stalled.  Checking the serial console I say messages from ata4 & ata5...  There really is nothing plugged
into the connectors.  Any ideas on what might have happened?

Thanks
Ed

>From startup:

[    2.138060] ata4: SATA link down (SStatus 0 SControl 300)
[    2.138064] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.138417] ata5: SATA link down (SStatus 0 SControl 300)
[    2.138818] ata3.00: ATA-8: WDC WD10EADS-00L5B1, 01.01A01, max UDMA/133
[    2.138820] ata3.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    2.140637] ata3.00: configured for UDMA/133
[    2.142441] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.153147] ata2.00: ATA-7: WDC WD3200KS-00PFB0, 21.00M21, max UDMA/133
[    2.153150] ata2.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 1)
[    2.153878] ata2.00: configured for UDMA/133
[    2.198790] ata6: SATA link down (SStatus 0 SControl 300)
[    2.545040] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.556880] ata1.00: ATA-7: Maxtor 6L250S0, BACE1G10, max UDMA/133
[    2.566684] ata1.00: 490234752 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.580221] ata1.00: configured for UDMA/133

Last messages before it stalled:

[49844.950401] ata4: exception Emask 0x73 SAct 0x0 SErr 0xffffffff action 0xe frozen
[49844.950630] ata5: exception Emask 0x73 SAct 0x0 SErr 0xffffffff action 0xe frozen
[49844.950677] ata5: irq_stat 0xffffffff, unknown FIS 00000000 00000000 00000000 00000000, host bus
[49844.950725] ata5: SError: { RecovData RecovComm UnrecovData Persist Proto HostInt PHYRdyChg PHYInt CommWake 10B8B Dispar BadCRC
[49844.950863] ata5: hard resett
