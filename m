Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbYAVUuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbYAVUuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 15:50:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbYAVUuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 15:50:11 -0500
Received: from [193.231.233.15] ([193.231.233.15]:40752 "HELO crystal.rdstm.ro"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1751393AbYAVUuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 15:50:10 -0500
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jan 2008 15:50:09 EST
X-Mail-Scanner: Scanned by qSheff-II-2.1-r2 (http://www.enderunix.org/qsheff/)
Date: Tue, 22 Jan 2008 22:43:43 +0200 (EET)
From: Dan Nica <timi@crystal.rdstm.ro>
To: linux-kernel@vger.kernel.org
Subject: SiI 3512 Serial ATA Controller - kernel 2.6.23
Message-ID: <Pine.LNX.4.63.0801222230470.4758@crystal.rdstm.ro>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello

I have a problem with a serial ata controller
that uses a SiI 3512 chip.

when I'm trying to add a device thats on the 3512 controller 
to the array that I have, it give me lots of errors in dmesg
like this:

ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x2400000 action 0x0
ata3.00: BMDMA2 stat 0x8652001
ata3.00: cmd 35/00:80:3f:5c:03/00:02:00:00:00/e0 tag 0 cdb 0x0 data 327680 
out
         res 51/04:80:3f:5e:03/00:00:00:00:00/e0 Emask 0x1 (device error)
ata3.00: configured for UDMA/100
ata3: EH complete
sd 2:0:0:0: [sdc] 976773168 512-byte hardware sectors (500108 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x2400000 action 0x2 frozen
ata3.00: cmd 35/00:80:bf:75:03/00:02:00:00:00/e0 tag 0 cdb 0x0 data 327680 
out
         res 40/00:80:3f:5e:03/00:00:00:00:00/e0 Emask 0x4 (timeout)
ata3: port is slow to respond, please be patient (Status 0xd1)
ata3: device not ready (errno=-16), forcing hardreset
ata3: hard resetting port
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: configured for UDMA/100
...........

is this a bug, is there a patch, or a workaround ? 
I desperately need to grow the array (which is a raid5) with 
the new harddrives :(

10x for help
--
Dan
