Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbYASMWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbYASMWo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 07:22:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbYASMWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 07:22:34 -0500
Received: from [90.184.2.114] ([90.184.2.114]:20301 "EHLO mail.jaquet.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbYASMWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 07:22:33 -0500
X-Greylist: delayed 314 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Jan 2008 07:22:32 EST
Date: Sat, 19 Jan 2008 13:17:15 +0100
From: Rasmus Andersen <rasmus@avlebavle.dk>
To: linux-kernel@vger.kernel.org
Subject: Help with intrepeting SATA log messages
Message-ID: <20080119121715.GA6860@avlebavle.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I was hoping that you could help me interpret these SATA errors from my
brand new Western Digital disk (at end). Also, this disk seems to refuse
smart commands:


# smartctl -s on -o on -S on /dev/sda
smartctl version 5.37 [i686-pc-linux-gnu] Copyright (C) 2002-6 Bruce
Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF ENABLE/DISABLE COMMANDS SECTION ===
SMART Enabled.
Error SMART Status command failed
Please get assistance from http://smartmontools.sourceforge.net/
Values from ATA status return descriptor are:
 00     09 0c 00 00 00 00 00 00  00 00 00 00 00 50
 A mandatory SMART command failed: exiting. To continue, add one or more
 '-T permissive' options.


Whats up with that? :)

Thanks in advance,
  Rasmus



md: recovery of RAID array md0
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
md: using 128k window, over a total of 198306240 blocks.
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: (BMDMA2 stat 0x181ca109)
ata1.00: cmd 25/00:00:3f:aa:0b/00:03:01:00:00/e0 tag 0 cdb 0x0 data 393216 in
         res 51/00:00:01:00:00/00:00:01:00:00/e0 Emask 0x1 (device error)
ata1.00: configured for UDMA/33
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: (BMDMA2 stat 0x181ca109)
ata1.00: cmd 25/00:00:3f:aa:0b/00:03:01:00:00/e0 tag 0 cdb 0x0 data 393216 in
         res 51/00:00:01:00:00/00:00:01:00:00/e0 Emask 0x1 (device error)
ata1.00: configured for UDMA/33
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: (BMDMA2 stat 0x181ca109)
ata1.00: cmd 25/00:00:3f:aa:0b/00:03:01:00:00/e0 tag 0 cdb 0x0 data 393216 in
         res 51/00:00:01:00:00/00:00:01:00:00/e0 Emask 0x1 (device error)
ata1.00: configured for UDMA/33
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: (BMDMA2 stat 0x181ca109)
ata1.00: cmd 25/00:00:3f:aa:0b/00:03:01:00:00/e0 tag 0 cdb 0x0 data 393216 in
         res 51/00:00:01:00:00/00:00:01:00:00/e0 Emask 0x1 (device error)
ata1.00: configured for UDMA/33
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: (BMDMA2 stat 0x181ca109)
ata1.00: cmd 25/00:00:3f:aa:0b/00:03:01:00:00/e0 tag 0 cdb 0x0 data 393216 in
         res 51/00:00:01:00:00/00:00:01:00:00/e0 Emask 0x1 (device error)
ata1.00: configured for UDMA/33
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: (BMDMA2 stat 0x181ca109)
ata1.00: cmd 25/00:00:3f:aa:0b/00:03:01:00:00/e0 tag 0 cdb 0x0 data 393216 in
         res 51/00:00:01:00:00/00:00:01:00:00/e0 Emask 0x1 (device error)
ata1.00: configured for UDMA/33
sd 0:0:0:0: [sda] Result: hostbyte=0x00 driverbyte=0x08
sd 0:0:0:0: [sda] Sense Key : 0xb [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
        72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
        01 00 00 01 
sd 0:0:0:0: [sda] ASC=0x0 ASCQ=0x0
end_request: I/O error, dev sda, sector 17541695
ata1: EH complete
sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: (BMDMA2 stat 0x181ca109)
ata1.00: cmd 25/00:00:bf:ad:0b/00:04:01:00:00/e0 tag 0 cdb 0x0 data 524288 in
         res 51/00:00:01:00:00/00:00:01:00:00/e0 Emask 0x1 (device error)
ata1.00: configured for UDMA/33
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: (BMDMA2 stat 0x181ca109)
ata1.00: cmd 25/00:00:bf:ad:0b/00:04:01:00:00/e0 tag 0 cdb 0x0 data 524288 in
         res 51/00:00:01:00:00/00:00:01:00:00/e0 Emask 0x1 (device error)
ata1.00: configured for UDMA/33
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: (BMDMA2 stat 0x181ca109)
ata1.00: cmd 25/00:00:bf:ad:0b/00:04:01:00:00/e0 tag 0 cdb 0x0 data 524288 in
         res 51/00:00:01:00:00/00:00:01:00:00/e0 Emask 0x1 (device error)
ata1.00: configured for UDMA/33
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: (BMDMA2 stat 0x181ca109)
ata1.00: cmd 25/00:00:bf:ad:0b/00:04:01:00:00/e0 tag 0 cdb 0x0 data 524288 in
         res 51/00:00:01:00:00/00:00:01:00:00/e0 Emask 0x1 (device error)
ata1.00: configured for UDMA/33
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: (BMDMA2 stat 0x181ca109)
ata1.00: cmd 25/00:00:bf:ad:0b/00:04:01:00:00/e0 tag 0 cdb 0x0 data 524288 in
         res 51/00:00:01:00:00/00:00:01:00:00/e0 Emask 0x1 (device error)
ata1.00: configured for UDMA/33
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: (BMDMA2 stat 0x181ca109)
ata1.00: cmd 25/00:00:bf:ad:0b/00:04:01:00:00/e0 tag 0 cdb 0x0 data 524288 in
         res 51/00:00:01:00:00/00:00:01:00:00/e0 Emask 0x1 (device error)
ata1.00: configured for UDMA/33
sd 0:0:0:0: [sda] Result: hostbyte=0x00 driverbyte=0x08
sd 0:0:0:0: [sda] Sense Key : 0xb [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
        72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
        01 00 00 01 
sd 0:0:0:0: [sda] ASC=0x0 ASCQ=0x0
end_request: I/O error, dev sda, sector 17542591
ata1: EH complete
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: (BMDMA2 stat 0x181ca109)
ata1.00: cmd 25/00:00:bf:b5:0b/00:04:01:00:00/e0 tag 0 cdb 0x0 data 524288 in
         res 51/00:00:01:00:00/00:00:01:00:00/e0 Emask 0x1 (device error)
ata1.00: configured for UDMA/33
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: (BMDMA2 stat 0x181ca109)
ata1.00: cmd 25/00:00:bf:b5:0b/00:04:01:00:00/e0 tag 0 cdb 0x0 data 524288 in
         res 51/00:00:01:00:00/00:00:01:00:00/e0 Emask 0x1 (device error)
ata1.00: configured for UDMA/33
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: (BMDMA2 stat 0x181ca109)
ata1.00: cmd 25/00:00:bf:b5:0b/00:04:01:00:00/e0 tag 0 cdb 0x0 data 524288 in
         res 51/00:00:01:00:00/00:00:01:00:00/e0 Emask 0x1 (device error)
ata1.00: configured for UDMA/33
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: (BMDMA2 stat 0x181ca109)
ata1.00: cmd 25/00:00:bf:b5:0b/00:04:01:00:00/e0 tag 0 cdb 0x0 data 524288 in
         res 51/00:00:01:00:00/00:00:01:00:00/e0 Emask 0x1 (device error)
ata1.00: configured for UDMA/33
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: (BMDMA2 stat 0x181ca109)
ata1.00: cmd 25/00:00:bf:b5:0b/00:04:01:00:00/e0 tag 0 cdb 0x0 data 524288 in
         res 51/00:00:01:00:00/00:00:01:00:00/e0 Emask 0x1 (device error)
ata1.00: configured for UDMA/33
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: (BMDMA2 stat 0x181ca109)
ata1.00: cmd 25/00:00:bf:b5:0b/00:04:01:00:00/e0 tag 0 cdb 0x0 data 524288 in
         res 51/00:00:01:00:00/00:00:01:00:00/e0 Emask 0x1 (device error)
ata1.00: configured for UDMA/33
sd 0:0:0:0: [sda] Result: hostbyte=0x00 driverbyte=0x08
sd 0:0:0:0: [sda] Sense Key : 0xb [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
        72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
        01 00 00 01 
sd 0:0:0:0: [sda] ASC=0x0 ASCQ=0x0
end_request: I/O error, dev sda, sector 17544639
ata1: EH complete
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: (BMDMA2 stat 0x181ca109)
ata1.00: cmd c8/00:08:cf:ab:0b/00:00:00:00:00/e1 tag 0 cdb 0x0 data 4096 in
         res 51/00:00:01:00:00/00:00:01:00:00/e1 Emask 0x1 (device error)
ata1.00: configured for UDMA/33
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: (BMDMA2 stat 0x181ca109)
ata1.00: cmd c8/00:08:cf:ab:0b/00:00:00:00:00/e1 tag 0 cdb 0x0 data 4096 in
         res 51/00:00:01:00:00/00:00:01:00:00/e1 Emask 0x1 (device error)
ata1.00: configured for UDMA/33
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: (BMDMA2 stat 0x181ca109)
ata1.00: cmd c8/00:08:cf:ab:0b/00:00:00:00:00/e1 tag 0 cdb 0x0 data 4096 in
         res 51/00:00:01:00:00/00:00:01:00:00/e1 Emask 0x1 (device error)
ata1.00: configured for UDMA/33
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: (BMDMA2 stat 0x181ca109)
ata1.00: cmd c8/00:08:cf:ab:0b/00:00:00:00:00/e1 tag 0 cdb 0x0 data 4096 in
         res 51/00:00:01:00:00/00:00:01:00:00/e1 Emask 0x1 (device error)
ata1.00: configured for UDMA/33
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: (BMDMA2 stat 0x181ca109)
ata1.00: cmd c8/00:08:cf:ab:0b/00:00:00:00:00/e1 tag 0 cdb 0x0 data 4096 in
         res 51/00:00:01:00:00/00:00:01:00:00/e1 Emask 0x1 (device error)
ata1.00: configured for UDMA/33
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: (BMDMA2 stat 0x181ca109)
ata1.00: cmd c8/00:08:cf:ab:0b/00:00:00:00:00/e1 tag 0 cdb 0x0 data 4096 in
         res 51/00:00:01:00:00/00:00:01:00:00/e1 Emask 0x1 (device error)
ata1.00: configured for UDMA/33
sd 0:0:0:0: [sda] Result: hostbyte=0x00 driverbyte=0x08
sd 0:0:0:0: [sda] Sense Key : 0xb [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
        72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
        01 00 00 01 
sd 0:0:0:0: [sda] ASC=0x0 ASCQ=0x0
end_request: I/O error, dev sda, sector 17542095
ata1: EH complete
raid1: sda: unrecoverable I/O read error for block 17542016
sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: (BMDMA2 stat 0x181ca109)
ata1.00: cmd c8/00:08:17:b1:0b/00:00:00:00:00/e1 tag 0 cdb 0x0 data 4096 in
         res 51/00:00:01:00:00/00:00:01:00:00/e1 Emask 0x1 (device error)
ata1.00: configured for UDMA/33
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: (BMDMA2 stat 0x181ca109)
ata1.00: cmd c8/00:08:17:b1:0b/00:00:00:00:00/e1 tag 0 cdb 0x0 data 4096 in
         res 51/00:00:01:00:00/00:00:01:00:00/e1 Emask 0x1 (device error)
ata1.00: configured for UDMA/33
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: (BMDMA2 stat 0x181ca109)
ata1.00: cmd c8/00:08:17:b1:0b/00:00:00:00:00/e1 tag 0 cdb 0x0 data 4096 in
         res 51/00:00:01:00:00/00:00:01:00:00/e1 Emask 0x1 (device error)
ata1.00: configured for UDMA/33
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: (BMDMA2 stat 0x181ca109)
ata1.00: cmd c8/00:08:17:b1:0b/00:00:00:00:00/e1 tag 0 cdb 0x0 data 4096 in
         res 51/00:00:01:00:00/00:00:01:00:00/e1 Emask 0x1 (device error)
ata1.00: configured for UDMA/33
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: (BMDMA2 stat 0x181ca109)
ata1.00: cmd c8/00:08:17:b1:0b/00:00:00:00:00/e1 tag 0 cdb 0x0 data 4096 in
         res 51/00:00:01:00:00/00:00:01:00:00/e1 Emask 0x1 (device error)
ata1.00: configured for UDMA/33
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: (BMDMA2 stat 0x181ca109)
ata1.00: cmd c8/00:08:17:b1:0b/00:00:00:00:00/e1 tag 0 cdb 0x0 data 4096 in
         res 51/00:00:01:00:00/00:00:01:00:00/e1 Emask 0x1 (device error)
ata1.00: configured for UDMA/33
sd 0:0:0:0: [sda] Result: hostbyte=0x00 driverbyte=0x08
sd 0:0:0:0: [sda] Sense Key : 0xb [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
        72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
        01 00 00 01 
sd 0:0:0:0: [sda] ASC=0x0 ASCQ=0x0
end_request: I/O error, dev sda, sector 17543447
ata1: EH complete
raid1: sda: unrecoverable I/O read error for block 17543296
sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: (BMDMA2 stat 0x181ca109)
ata1.00: cmd c8/00:08:5f:b6:0b/00:00:00:00:00/e1 tag 0 cdb 0x0 data 4096 in
         res 51/00:00:01:00:00/00:00:01:00:00/e1 Emask 0x1 (device error)
ata1.00: configured for UDMA/33
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: (BMDMA2 stat 0x181ca109)
ata1.00: cmd c8/00:08:5f:b6:0b/00:00:00:00:00/e1 tag 0 cdb 0x0 data 4096 in
         res 51/00:00:01:00:00/00:00:01:00:00/e1 Emask 0x1 (device error)
ata1.00: configured for UDMA/33
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: (BMDMA2 stat 0x181ca109)
ata1.00: cmd c8/00:08:5f:b6:0b/00:00:00:00:00/e1 tag 0 cdb 0x0 data 4096 in
         res 51/00:00:01:00:00/00:00:01:00:00/e1 Emask 0x1 (device error)
ata1.00: configured for UDMA/33
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: (BMDMA2 stat 0x181ca109)
ata1.00: cmd c8/00:08:5f:b6:0b/00:00:00:00:00/e1 tag 0 cdb 0x0 data 4096 in
         res 51/00:00:01:00:00/00:00:01:00:00/e1 Emask 0x1 (device error)
ata1.00: configured for UDMA/33
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: (BMDMA2 stat 0x181ca109)
ata1.00: cmd c8/00:08:5f:b6:0b/00:00:00:00:00/e1 tag 0 cdb 0x0 data 4096 in
         res 51/00:00:01:00:00/00:00:01:00:00/e1 Emask 0x1 (device error)
ata1.00: configured for UDMA/33
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: (BMDMA2 stat 0x181ca109)
ata1.00: cmd c8/00:08:5f:b6:0b/00:00:00:00:00/e1 tag 0 cdb 0x0 data 4096 in
         res 51/00:00:01:00:00/00:00:01:00:00/e1 Emask 0x1 (device error)
ata1.00: configured for UDMA/33
sd 0:0:0:0: [sda] Result: hostbyte=0x00 driverbyte=0x08
sd 0:0:0:0: [sda] Sense Key : 0xb [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
        72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
        01 00 00 01 
sd 0:0:0:0: [sda] ASC=0x0 ASCQ=0x0
end_request: I/O error, dev sda, sector 17544799
ata1: EH complete
raid1: sda: unrecoverable I/O read error for block 17544704
sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
md: md0: recovery done.
RAID1 conf printout:
 --- wd:1 rd:2
 disk 0, wo:1, o:1, dev:sdb1
 disk 1, wo:0, o:1, dev:sda1
RAID1 conf printout:
 --- wd:1 rd:2
 disk 1, wo:0, o:1, dev:sda1
RAID1 conf printout:
 --- wd:1 rd:2
 disk 0, wo:1, o:1, dev:sdb1
 disk 1, wo:0, o:1, dev:sda1
md: recovery of RAID array md0
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
md: using 128k window, over a total of 198306240 blocks.
