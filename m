Return-Path: <linux-kernel-owner+w=401wt.eu-S1767202AbXDEWMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767202AbXDEWMW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 18:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767349AbXDEWMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 18:12:22 -0400
Received: from lucidpixels.com ([75.144.35.66]:48661 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767202AbXDEWMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 18:12:21 -0400
Date: Thu, 5 Apr 2007 18:12:20 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: linux-kernel@vger.kernel.org
Subject: Any Intel folks on the list? Intel PCI-E bridge ACPI resource question
Message-ID: <Pine.LNX.4.64.0704051809160.14476@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

http://www.ussg.iu.edu/hypermail/linux/kernel/0701.3/0315.html

I have similar issues as this poster-- I was wondering (if anyone) had an 
idea to the root cause of this issue; is it a problem with the chipset, 
the BIOS revision?

Mobo: Intel DG965WHMKR
BIOS: 1666

Is it only Intel Chipsets that suffer from this problem?

... or is it a way the kernel handles ACPI/IO-APIC/etc?

Justin.

(again, the dmesg output posted earlier (below))

[369143.916093] ata13.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 
frozen
[369143.916100] ata13.00: (irq_stat 0x00020002, failed to transmit command 
FIS)
[369143.916107] ata13.00: cmd ca/00:00:97:1a:d5/00:00:00:00:00/e9 tag 0 
cdb 0x0 data 131072 out
[369143.916109]          res 93/37:00:00:00:00/00:00:40:00:93/00 Emask 
0x12 (ATA bus error)
[369143.916116] ata13: hard resetting port
[369146.145915] ata13: softreset failed (port not ready)
[369146.145922] ata13: follow-up softreset failed, retrying in 5 secs
[369151.146035] ata13: hard resetting port
[369153.376736] ata13: softreset failed (port not ready)
[369153.376743] ata13: follow-up softreset failed, retrying in 5 secs
[369158.376664] ata13: hard resetting port
[369160.608025] ata13: softreset failed (port not ready)
[369160.608033] ata13: reset failed, giving up
[369160.608036] ata13.00: disabled
[369160.608043] ata13: EH pending after completion, repeating EH (cnt=4)
[369160.718365] ata13: exception Emask 0x10 SAct 0x0 SErr 0x4050000 action 
0x6 frozen
[369160.718370] ata13: (irq_stat 0x00060002, failed to transmit command 
FIS)
[369161.238432] ata13: waiting for device to spin up (8 secs)
[369168.715610] ata13: hard resetting port
[369170.946658] ata13: softreset failed (port not ready)
[369170.946666] ata13: follow-up softreset failed, retrying in 5 secs
[369175.946249] ata13: hard resetting port
[369178.167644] ata13: softreset failed (port not ready)
[369178.167651] ata13: follow-up softreset failed, retrying in 5 secs
[369183.167742] ata13: hard resetting port
[369185.398497] ata13: softreset failed (port not ready)
[369185.398504] ata13: reset failed, giving up
[369185.398522] sd 12:0:0:0: SCSI error: return code = 0x08000002
[369185.398526] sdl: Current [descriptor]: sense key: Aborted Command
[369185.398532]     Additional sense: Scsi parity error
[369185.398539] Descriptor sense data with sense descriptors (in hex):
[369185.398544]         72 0b 47 00 00 00 00 0c 00 0a 80 00 00 00 00 00
[369185.398572]         00 00 00 00
[369185.398581] end_request: I/O error, dev sdl, sector 164960919
[369185.398586] raid5: Disk failure on sdl1, disabling device. Operation 
continuing on 3 devices
[369185.398617] sd 12:0:0:0: rejecting I/O to offline device
[369185.398625] ata13: EH complete
[369185.398635] ata13.00: detaching (SCSI 12:0:0:0)
[369185.398676] sd 12:0:0:0: SCSI error: return code = 0x00010000
[369185.398680] end_request: I/O error, dev sdl, sector 164961175
[369185.398702] raid5:md3: read error not correctable (sector 164962304 on 
sdl1).
[369185.398707] raid5:md3: read error not correctable (sector 164962312 on 
sdl1).
[369185.398711] raid5:md3: read error not correctable (sector 164962320 on 
sdl1).
[369185.398716] raid5:md3: read error not correctable (sector 164962328 on 
sdl1).
[369185.398760] Synchronizing SCSI cache for disk sdl:
[369185.398784] FAILED
[369185.398785]   status = 0, message = 00, host = 4, driver = 00
[369185.398786]   <3>scsi 12:0:0:0: rejecting I/O to dead device
[369185.404619] scsi 12:0:0:0: rejecting I/O to dead device
[369185.404641] scsi 12:0:0:0: rejecting I/O to dead device
[369185.404662] scsi 12:0:0:0: rejecting I/O to dead device
[369185.404682] scsi 12:0:0:0: rejecting I/O to dead device
[369185.404686] scsi 12:0:0:0: rejecting I/O to dead device
[369185.404691] scsi 12:0:0:0: rejecting I/O to dead device
[369185.404712] scsi 12:0:0:0: rejecting I/O to dead device
[369185.404732] scsi 12:0:0:0: rejecting I/O to dead device
[369185.404753] scsi 12:0:0:0: rejecting I/O to dead device
[369185.404774] scsi 12:0:0:0: rejecting I/O to dead device
[369185.404794] scsi 12:0:0:0: rejecting I/O to dead device
[369185.404815] scsi 12:0:0:0: rejecting I/O to dead device
[369185.404844] scsi 12:0:0:0: rejecting I/O to dead device
[369185.404863] scsi 12:0:0:0: rejecting I/O to dead device
[369185.404882] scsi 12:0:0:0: rejecting I/O to dead device
[369185.404900] scsi 12:0:0:0: rejecting I/O to dead device
[369185.404918] scsi 12:0:0:0: rejecting I/O to dead device
[369185.404937] scsi 12:0:0:0: rejecting I/O to dead device
[369185.404956] scsi 12:0:0:0: rejecting I/O to dead device
[369185.413938] RAID5 conf printout:
[369185.413944]  --- rd:4 wd:3
[369185.413948]  disk 0, o:1, dev:sdi1
[369185.413950]  disk 1, o:1, dev:sdj1
[369185.413953]  disk 2, o:0, dev:sdl1
[369185.413956]  disk 3, o:1, dev:sdg1
[369185.418873] RAID5 conf printout:
[369185.418878]  --- rd:4 wd:3
[369185.418881]  disk 0, o:1, dev:sdi1
[369185.418884]  disk 1, o:1, dev:sdj1
[369185.418887]  disk 3, o:1, dev:sdg1

