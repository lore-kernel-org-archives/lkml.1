Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbXCPPhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbXCPPhF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 11:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbXCPPhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 11:37:05 -0400
Received: from wilma.widomaker.com ([204.17.220.5]:1542 "EHLO
	wilma.widomaker.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbXCPPhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 11:37:03 -0400
Date: Fri, 16 Mar 2007 11:36:57 -0400
From: Charles Shannon Hendrix <shannon@widomaker.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: SATA problems in 2.6.20.3
Message-ID: <20070316113657.161e5315@daydream.goid.lan>
Organization: Big Endian
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-slackware-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I normally run a modified 2.6.19 kernel and it works great.

I recently tried 2.6.20 and had severe SATA problems with it.

Yesterday I tried 2.6.20.3, and the problems are still there.

Relevant /var/log/messages entries:

Mar 14 20:45:11 daydream kernel: ata3: EH in ADMA mode, notifier 0x0
notifier_er ror 0x0 gen_ctl 0x1501000 status 0x400
Mar 14 20:45:11 daydream kernel: ata3: CPB 0: ctl_flags 0x1f, resp_flags 0x0
Mar 14 20:45:11 daydream kernel: ata3: CPB 1: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:45:11 daydream kernel: ata3: CPB 2: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:45:11 daydream kernel: ata3: CPB 3: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:45:11 daydream kernel: ata3: CPB 4: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:45:11 daydream kernel: ata3: CPB 5: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:45:11 daydream kernel: ata3: CPB 6: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:45:11 daydream kernel: ata3: CPB 7: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:45:11 daydream kernel: ata3: CPB 8: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:45:11 daydream kernel: ata3: CPB 9: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:45:11 daydream kernel: ata3: CPB 10: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:45:11 daydream kernel: ata3: CPB 11: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:45:11 daydream kernel: ata3: CPB 12: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:45:12 daydream kernel: ata3: CPB 13: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:45:12 daydream kernel: ata3: CPB 14: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:45:12 daydream kernel: ata3: CPB 15: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:45:12 daydream kernel: ata3: CPB 16: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:45:12 daydream kernel: ata3: CPB 17: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:45:12 daydream kernel: ata3: CPB 18: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:45:12 daydream kernel: ata3: CPB 19: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:45:12 daydream kernel: ata3: CPB 20: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:45:12 daydream kernel: ata3: CPB 21: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:45:12 daydream kernel: ata3: CPB 22: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:45:12 daydream kernel: ata3: CPB 23: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:45:12 daydream kernel: ata3: CPB 24: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:45:12 daydream kernel: ata3: CPB 25: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:45:12 daydream kernel: ata3: CPB 26: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:45:13 daydream kernel: ata3: CPB 27: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:45:13 daydream kernel: ata3: CPB 28: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:45:13 daydream kernel: ata3: CPB 29: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:45:13 daydream kernel: ata3: CPB 30: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:45:13 daydream kernel: ata3: Resetting port
Mar 14 20:45:13 daydream kernel: ata3.00: exception Emask 0x0 SAct 0x1 SErr
0x0 action 0x2 frozen
Mar 14 20:45:13 daydream kernel: ata3.00: cmd
61/40:00:ed:39:b1/00:00:04:00:00/4 0 tag 0 cdb 0x0 data 32768 out
Mar 14 20:45:13 daydream kernel:          res
40/00:00:00:00:00/00:00:00:00:00/0 0 Emask 0x4 (timeout)
Mar 14 20:45:13 daydream kernel: ata3: soft resetting port
Mar 14 20:45:13 daydream kernel: ata3: SATA link up 1.5 Gbps (SStatus 113
SContr ol 300)
Mar 14 20:45:13 daydream kernel: ata3.00: configured for UDMA/133
Mar 14 20:45:13 daydream kernel: ata3: EH complete
Mar 14 20:45:13 daydream kernel: SCSI device sdc: 156301488 512-byte hdwr
sector s (80026 MB)
Mar 14 20:45:13 daydream kernel: sdc: Write Protect is off
Mar 14 20:45:13 daydream kernel: sdc: Mode Sense: 00 3a 00 00
Mar 14 20:45:14 daydream kernel: SCSI device sdc: write cache: enabled, read
cac he: enabled, doesn't support DPO or FUA
Mar 14 20:49:12 daydream kernel: ata3: EH in ADMA mode, notifier 0x0
notifier_er ror 0x0 gen_ctl 0x1501000 status 0x400
Mar 14 20:49:12 daydream kernel: ata3: CPB 0: ctl_flags 0x1f, resp_flags 0x0
Mar 14 20:49:12 daydream kernel: ata3: CPB 0: ctl_flags 0x1f, resp_flags 0x0
Mar 14 20:49:12 daydream kernel: ata3: CPB 1: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:49:12 daydream kernel: ata3: CPB 2: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:49:12 daydream kernel: ata3: CPB 3: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:49:12 daydream kernel: ata3: CPB 4: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:49:12 daydream kernel: ata3: CPB 5: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:49:12 daydream kernel: ata3: CPB 6: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:49:12 daydream kernel: ata3: CPB 7: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:49:12 daydream kernel: ata3: CPB 8: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:49:12 daydream kernel: ata3: CPB 9: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:49:12 daydream kernel: ata3: CPB 10: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:49:12 daydream kernel: ata3: CPB 11: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:49:18 daydream kernel: ata3: CPB 12: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:49:23 daydream kernel: ata3: CPB 13: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:49:23 daydream kernel: ata3: CPB 14: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:49:23 daydream kernel: ata3: CPB 15: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:49:26 daydream kernel: ata3: CPB 16: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:49:26 daydream kernel: ata3: CPB 17: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:49:26 daydream kernel: ata3: CPB 18: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:49:26 daydream kernel: ata3: CPB 19: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:49:27 daydream kernel: ata3: CPB 20: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:49:27 daydream kernel: ata3: CPB 21: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:49:27 daydream kernel: ata3: CPB 22: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:49:27 daydream kernel: ata3: CPB 23: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:49:28 daydream kernel: ata3: CPB 24: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:49:28 daydream kernel: ata3: CPB 25: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:49:28 daydream kernel: ata3: CPB 26: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:49:28 daydream kernel: ata3: CPB 27: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:49:28 daydream kernel: ata3: CPB 28: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:49:32 daydream kernel: ata3: CPB 29: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:49:32 daydream kernel: ata3: CPB 30: ctl_flags 0x1f, resp_flags 0x1
Mar 14 20:49:32 daydream kernel: ata3: Resetting port
Mar 14 20:49:32 daydream kernel: ata3.00: exception Emask 0x0 SAct 0x1 SErr
0x0 action 0x2 frozen
Mar 14 20:49:32 daydream kernel: ata3.00: cmd
61/40:00:0d:35:b0/00:00:04:00:00/4 0 tag 0 cdb 0x0 data 32768 out
Mar 14 20:49:33 daydream kernel:          res
40/00:00:00:00:00/00:00:00:00:00/0 0 Emask 0x4 (timeout)
Mar 14 20:49:33 daydream kernel: ata3: soft resetting port
Mar 14 20:49:33 daydream kernel: ata3: SATA link up 1.5 Gbps (SStatus 113
SContr ol 300)
Mar 14 20:49:33 daydream kernel: ata3.00: configured for UDMA/133
Mar 14 20:49:33 daydream kernel: ata3: EH complete











-- 
shannon           | Meddle not in the affairs of Wizards, for thou art 
                  | crunchy, and taste good with ketchup. 
                  |        -- stolen from Tom Manos' signature file
