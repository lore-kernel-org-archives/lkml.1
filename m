Return-Path: <linux-kernel-owner+w=401wt.eu-S1030969AbXDWDQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030969AbXDWDQk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 23:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030975AbXDWDQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 23:16:40 -0400
Received: from s2.yuriev.com ([69.31.8.140]:39456 "HELO s2.yuriev.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1030969AbXDWDQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 23:16:40 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Apr 2007 23:16:39 EDT
Date: Sun, 22 Apr 2007 23:56:22 -0400
From: alex=lists-linux-kernel@yuriev.com
To: linux-kernel@vger.kernel.org
Subject: SATA errors/messages after upgrade to 2.6.20.7
Message-ID: <20070423035622.GB10106@s2.yuriev.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



It is a Samsung HD501LJ SATA drive connected to 631xESB/632xESB controller.
Reading and writing every block of the drive does not generate any other
errors/failures. This is observed in 2.6.20.7 like a clockwork on any
badblocks -v run or rebuild of a MD raid1 array onto the disk. 

It, however, was not observed on 2.6.18 in 182 badblocks -v runs followed by
rebuild of MD raid1 array.

Any idea what it might be?

Apr 23 14:45:34 stdsrv-x86-64bit kernel: ata4.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0
Apr 23 14:45:34 stdsrv-x86-64bit kernel: ata4.00: (irq_stat 0x40000008)
Apr 23 14:45:34 stdsrv-x86-64bit kernel: ata4.00: cmd 60/80:00:14:16:c4/00:00:05:00:00/40 tag 0 cdb 0x0 data 65536 in
Apr 23 14:45:34 stdsrv-x86-64bit kernel:          res 51/40:00:40:16:c4/6f:00:05:00:00/40 Emask 0x9 (media error)
Apr 23 14:45:34 stdsrv-x86-64bit kernel: ata4.00: configured for UDMA/133
Apr 23 14:45:34 stdsrv-x86-64bit kernel: ata4: EH complete
Apr 23 14:45:37 stdsrv-x86-64bit kernel: ata4.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0
Apr 23 14:45:37 stdsrv-x86-64bit kernel: ata4.00: (irq_stat 0x40000008)
Apr 23 14:45:37 stdsrv-x86-64bit kernel: ata4.00: cmd 60/80:00:14:16:c4/00:00:05:00:00/40 tag 0 cdb 0x0 data 65536 in
Apr 23 14:45:37 stdsrv-x86-64bit kernel:          res 51/40:00:40:16:c4/6f:00:05:00:00/40 Emask 0x9 (media error)
Apr 23 14:45:37 stdsrv-x86-64bit kernel: ata4.00: configured for UDMA/133
Apr 23 14:45:37 stdsrv-x86-64bit kernel: ata4: EH complete
Apr 23 14:45:40 stdsrv-x86-64bit kernel: ata4.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0
Apr 23 14:45:49 stdsrv-x86-64bit kernel: ata4.00: (irq_stat 0x40000008)
Apr 23 14:45:49 stdsrv-x86-64bit kernel: ata4.00: cmd 60/80:00:14:16:c4/00:00:05:00:00/40 tag 0 cdb 0x0 data 65536 in
Apr 23 14:45:49 stdsrv-x86-64bit kernel:          res 51/40:00:40:16:c4/6f:00:05:00:00/40 Emask 0x9 (media error)
Apr 23 14:45:49 stdsrv-x86-64bit kernel: ata4.00: configured for UDMA/133
Apr 23 14:45:50 stdsrv-x86-64bit kernel: ata4: EH complete
Apr 23 14:45:50 stdsrv-x86-64bit kernel: ata4.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0
Apr 23 14:45:50 stdsrv-x86-64bit kernel: ata4.00: (irq_stat 0x40000008)
Apr 23 14:45:50 stdsrv-x86-64bit kernel: ata4.00: cmd 60/80:00:14:16:c4/00:00:05:00:00/40 tag 0 cdb 0x0 data 65536 in
Apr 23 14:45:51 stdsrv-x86-64bit kernel:          res 51/40:00:40:16:c4/6f:00:05:00:00/40 Emask 0x9 (media error)
Apr 23 14:45:51 stdsrv-x86-64bit kernel: ata4.00: configured for UDMA/133
Apr 23 14:45:51 stdsrv-x86-64bit kernel: ata4: EH complete
Apr 23 14:45:51 stdsrv-x86-64bit kernel: ata4.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0
Apr 23 14:45:52 stdsrv-x86-64bit kernel: ata4.00: (irq_stat 0x40000008)
Apr 23 14:45:52 stdsrv-x86-64bit kernel: ata4.00: cmd 60/80:00:14:16:c4/00:00:05:00:00/40 tag 0 cdb 0x0 data 65536 in
Apr 23 14:45:52 stdsrv-x86-64bit kernel:          res 51/40:00:40:16:c4/6f:00:05:00:00/40 Emask 0x9 (media error)
Apr 23 14:45:52 stdsrv-x86-64bit kernel: ata4.00: configured for UDMA/133
Apr 23 14:45:52 stdsrv-x86-64bit kernel: ata4: EH complete
Apr 23 14:45:52 stdsrv-x86-64bit kernel: ata4.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0
Apr 23 14:45:53 stdsrv-x86-64bit kernel: ata4.00: (irq_stat 0x40000008)
Apr 23 14:45:53 stdsrv-x86-64bit kernel: ata4.00: cmd 60/80:00:14:16:c4/00:00:05:00:00/40 tag 0 cdb 0x0 data 65536 in
Apr 23 14:45:53 stdsrv-x86-64bit kernel:          res 51/40:00:40:16:c4/6f:00:05:00:00/40 Emask 0x9 (media error)
Apr 23 14:45:54 stdsrv-x86-64bit kernel: ata4.00: configured for UDMA/133
Apr 23 14:45:54 stdsrv-x86-64bit kernel: ata4: EH complete
Apr 23 14:45:54 stdsrv-x86-64bit kernel: SCSI device sdd: 976773168 512-byte hdwr sectors (500108 MB)
Apr 23 14:45:54 stdsrv-x86-64bit kernel: sdd: Write Protect is off
Apr 23 14:45:54 stdsrv-x86-64bit kernel: SCSI device sdd: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Apr 23 14:45:54 stdsrv-x86-64bit kernel: SCSI device sdd: 976773168 512-byte hdwr sectors (500108 MB)
Apr 23 14:45:55 stdsrv-x86-64bit kernel: sdd: Write Protect is off
Apr 23 14:45:55 stdsrv-x86-64bit kernel: SCSI device sdd: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
