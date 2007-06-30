Return-Path: <linux-kernel-owner+w=401wt.eu-S1756313AbXF3Siu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313AbXF3Siu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 14:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbXF3Sin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 14:38:43 -0400
Received: from wilma.widomaker.com ([204.17.220.5]:2138 "EHLO
	wilma.widomaker.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbXF3Sim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 14:38:42 -0400
Message-ID: <4686A32F.1010700@widomaker.com>
Date: Sat, 30 Jun 2007 14:38:39 -0400
From: Charles Shannon Hendrix <shannon@widomaker.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: SATA/ADMA TIMEOUTS, dmesg output
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Following this post is output from Linux kernel 2.6.21 showing ADMA timeouts.

2.6.21 has improved the situation over earlier kernels, but the problems do 
still occur.

nforce4 chipset, Seagate Barracuda SATA drives.

This is meant mainly as an additional data point in case it helps someone debug 
the problem.

-------------------------------------------------------------------------------


[192487.538000] SCSI device sdb: write cache: enabled, read cache: enabled, does
n't support DPO or FUA
[211093.118000] ata4: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl 0
x1501000 status 0x400 next cpb count 0x0 next cpb idx 0x0
[211093.118000] ata4: CPB 0: ctl_flags 0x9, resp_flags 0x0
[211093.118000] ata4: timeout waiting for ADMA IDLE, stat=0x400
[211093.118000] ata4: timeout waiting for ADMA LEGACY, stat=0x400
[211093.118000] ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
[211093.118000] ata4.00: cmd e7/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 d
ata 0
[211093.118000]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (time
out)
[211093.421000] ata4: soft resetting port
[211093.626000] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[211093.632000] ata4.00: configured for UDMA/133
[211093.632000] ata4: EH complete
[211093.632000] SCSI device sdb: 156301488 512-byte hdwr sectors (80026 MB)
[211093.632000] sdb: Write Protect is off
[211093.632000] sdb: Mode Sense: 00 3a 00 00
[211093.632000] SCSI device sdb: write cache: enabled, read cache: enabled, does
n't support DPO or FUA
[221976.072000] ata4: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl 0
x1501000 status 0x400 next cpb count 0x0 next cpb idx 0x0
[221976.072000] ata4: CPB 0: ctl_flags 0x9, resp_flags 0x0
[221976.072000] ata4: timeout waiting for ADMA IDLE, stat=0x400
[221976.072000] ata4: timeout waiting for ADMA LEGACY, stat=0x400
[221976.072000] ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
[221976.072000] ata4.00: cmd e7/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 d
ata 0
[221976.072000]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (time
out)
[221976.375000] ata4: soft resetting port
[221976.580000] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[221976.586000] ata4.00: configured for UDMA/133
[221976.586000] ata4: EH complete
[221976.587000] SCSI device sdb: 156301488 512-byte hdwr sectors (80026 MB)
[221976.587000] sdb: Write Protect is off
[221976.587000] sdb: Mode Sense: 00 3a 00 00
[221976.587000] SCSI device sdb: write cache: enabled, read cache: enabled, does
n't support DPO or FUA
[222045.513000] ata4: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl 0
x1501000 status 0x400 next cpb count 0x0 next cpb idx 0x0
[222045.513000] ata4: CPB 0: ctl_flags 0x9, resp_flags 0x0
[222045.513000] ata4: timeout waiting for ADMA IDLE, stat=0x400
[222045.513000] ata4: timeout waiting for ADMA LEGACY, stat=0x400
[222045.513000] ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
[222045.513000] ata4.00: cmd e7/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 d
ata 0
[222045.513000]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (time
out)
[222045.816000] ata4: soft resetting port
[222046.021000] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[222046.027000] ata4.00: configured for UDMA/133
[222046.027000] ata4: EH complete
[222046.027000] SCSI device sdb: 156301488 512-byte hdwr sectors (80026 MB)
[222046.027000] sdb: Write Protect is off
[222046.027000] sdb: Mode Sense: 00 3a 00 00
[222046.027000] SCSI device sdb: write cache: enabled, read cache: enabled, does
n't support DPO or FUA



-- 
shannon           | An Irishman is never drunk as long as he can hold onto
                   | one blade of grass and not fall off the face of the earth.
