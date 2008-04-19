Return-Path: <linux-kernel-owner+w=401wt.eu-S1754613AbYDSFRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbYDSFRO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 01:17:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbYDSFRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 01:17:03 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:3848 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbYDSFRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 01:17:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=AhF8mwH40BzRpCVRhvzyaTS19TD2PnsYikCGExakQ5rHo7FcaWMaJYAV3i8o71uPkd3rd1Ni5j6oRpo1rOxBqzZNTN3UPp9AMibaf4GXSyzWNnh5vkre4DisARFg9Vz8GAxeu5Cp0NycCa9FcWbxoi+TqiOG1zARtVF1cA1VPBQ=
Message-ID: <a44ae5cd0804182217y1f94cceeq12115c379de7c58a@mail.gmail.com>
Date: Sat, 19 Apr 2008 01:17:00 -0400
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.25-mm1 -- Is this just my drive dying?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ 6288.201390] ata1.00: configured for UDMA/100
[ 6288.201428] sd 0:0:0:0: [sda] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE,SUGGEST_OK
[ 6288.201435] sd 0:0:0:0: [sda] Sense Key : Medium Error [current] [descriptor]
[ 6288.201445] Descriptor sense data with sense descriptors (in hex):
[ 6288.201449]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
[ 6288.201471]         00 94 45 27
[ 6288.201480] sd 0:0:0:0: [sda] Add. Sense: Unrecovered read error -
auto reallocate failed
[ 6288.201489] end_request: I/O error, dev sda, sector 9717031
[ 6288.201497] Buffer I/O error on device sda1, logical block 1214621
[ 6288.203810] ata1: EH complete
[ 6288.203921] sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
[ 6288.203973] sd 0:0:0:0: [sda] Write Protect is off
[ 6288.203979] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 6288.205413] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[ 6288.275427] sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
[ 6288.283499] sd 0:0:0:0: [sda] Write Protect is off
[ 6288.283511] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 6288.300123] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[ 6293.184073] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[ 6293.184084] ata1.00: BMDMA stat 0x65
[ 6293.184093] ata1.00: cmd c8/00:08:27:45:94/00:00:00:00:00/e0 tag 0
dma 4096 in
[ 6293.184096]          res 51/40:08:27:45:94/00:00:00:00:00/e0 Emask
0x9 (media error)
[ 6293.184102] ata1.00: status: { DRDY ERR }
[ 6293.184105] ata1.00: error: { UNC }
[ 6293.437665] ata1: nv_mode_filter: 0x3f01f&0x3f01f->0x3f01f,
BIOS=0x3f000 (0xc600c0c0) ACPI=0x3f01f (20:600:0x13)
[ 6293.455826] ata1.00: configured for UDMA/100
[ 6293.456164] ata1: EH complete
[ 6297.565208] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[ 6297.565220] ata1.00: BMDMA stat 0x65
[ 6297.565230] ata1.00: cmd c8/00:08:27:45:94/00:00:00:00:00/e0 tag 0
dma 4096 in
[ 6297.565232]          res 51/40:08:27:45:94/00:00:00:00:00/e0 Emask
0x9 (media error)
[ 6297.565238] ata1.00: status: { DRDY ERR }
[ 6297.565241] ata1.00: error: { UNC }
[ 6297.573427] ata1: nv_mode_filter: 0x3f01f&0x3f01f->0x3f01f,
BIOS=0x3f000 (0xc600c0c0) ACPI=0x3f01f (20:600:0x13)
[ 6297.591539] ata1.00: configured for UDMA/100
[ 6297.592592] ata1: EH complete
[ 6301.177009] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[ 6301.177021] ata1.00: BMDMA stat 0x65
[ 6301.177031] ata1.00: cmd c8/00:08:27:45:94/00:00:00:00:00/e0 tag 0
dma 4096 in
[ 6301.177033]          res 51/40:08:28:45:94/00:00:00:00:00/e0 Emask
0x9 (media error)
[ 6301.177039] ata1.00: status: { DRDY ERR }
[ 6301.177042] ata1.00: error: { UNC }
[ 6301.186274] ata1: nv_mode_filter: 0x3f01f&0x3f01f->0x3f01f,
BIOS=0x3f000 (0xc600c0c0) ACPI=0x3f01f (20:600:0x13)
[ 6301.206197] ata1.00: configured for UDMA/100
[ 6301.206413] ata1: EH complete
[ 6308.750919] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[ 6308.750930] ata1.00: BMDMA stat 0x65
[ 6308.750939] ata1.00: cmd c8/00:08:27:45:94/00:00:00:00:00/e0 tag 0
dma 4096 in
[ 6308.750942]          res 51/40:08:28:45:94/00:00:00:00:00/e0 Emask
0x9 (media error)
[ 6308.750948] ata1.00: status: { DRDY ERR }
[ 6308.750951] ata1.00: error: { UNC }
[ 6308.757809] ata1: nv_mode_filter: 0x3f01f&0x3f01f->0x3f01f,
BIOS=0x3f000 (0xc600c0c0) ACPI=0x3f01f (20:600:0x13)
[ 6308.773842] ata1.00: configured for UDMA/100
[ 6308.774057] ata1: EH complete
[ 6315.576605] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[ 6315.576616] ata1.00: BMDMA stat 0x65
[ 6315.576627] ata1.00: cmd c8/00:08:27:45:94/00:00:00:00:00/e0 tag 0
dma 4096 in
[ 6315.576629]          res 51/40:08:28:45:94/00:00:00:00:00/e0 Emask
0x9 (media error)
[ 6315.576635] ata1.00: status: { DRDY ERR }
[ 6315.576638] ata1.00: error: { UNC }
[ 6315.588519] ata1: nv_mode_filter: 0x3f01f&0x3f01f->0x3f01f,
BIOS=0x3f000 (0xc600c0c0) ACPI=0x3f01f (20:600:0x13)
[ 6315.608523] ata1.00: configured for UDMA/100
[ 6315.608711] ata1: EH complete
[ 6319.857408] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[ 6319.857420] ata1.00: BMDMA stat 0x65
[ 6319.857429] ata1.00: cmd c8/00:08:27:45:94/00:00:00:00:00/e0 tag 0
dma 4096 in
[ 6319.857432]          res 51/40:08:28:45:94/00:00:00:00:00/e0 Emask
0x9 (media error)
[ 6319.857437] ata1.00: status: { DRDY ERR }
[ 6319.857441] ata1.00: error: { UNC }
[ 6319.865305] ata1: nv_mode_filter: 0x3f01f&0x3f01f->0x3f01f,
BIOS=0x3f000 (0xc600c0c0) ACPI=0x3f01f (20:600:0x13)
[ 6319.889939] ata1.00: configured for UDMA/100
[ 6319.889979] sd 0:0:0:0: [sda] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE,SUGGEST_OK
[ 6319.889986] sd 0:0:0:0: [sda] Sense Key : Medium Error [current] [descriptor]
[ 6319.889996] Descriptor sense data with sense descriptors (in hex):
[ 6319.890000]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
[ 6319.890023]         00 94 45 28
[ 6319.890031] sd 0:0:0:0: [sda] Add. Sense: Unrecovered read error -
auto reallocate failed
[ 6319.890040] end_request: I/O error, dev sda, sector 9717032
[ 6319.890049] Buffer I/O error on device sda1, logical block 1214621
[ 6319.890108] ata1: EH complete
[ 6319.890220] sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
[ 6319.890277] sd 0:0:0:0: [sda] Write Protect is off
[ 6319.890282] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 6319.890380] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[ 6319.890477] sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
[ 6319.890529] sd 0:0:0:0: [sda] Write Protect is off
[ 6319.890535] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 6319.890631] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[ 6338.213321] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[ 6338.213332] ata1.00: BMDMA stat 0x65
[ 6338.213342] ata1.00: cmd c8/00:08:17:02:db/00:00:00:00:00/e0 tag 0
dma 4096 in
[ 6338.213344]          res 51/40:08:17:02:db/00:00:00:00:00/e0 Emask
0x9 (media error)
[ 6338.213350] ata1.00: status: { DRDY ERR }
[ 6338.213353] ata1.00: error: { UNC }
[ 6338.222357] ata1: nv_mode_filter: 0x3f01f&0x3f01f->0x3f01f,
BIOS=0x3f000 (0xc600c0c0) ACPI=0x3f01f (20:600:0x13)
