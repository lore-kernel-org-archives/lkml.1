Return-Path: <linux-kernel-owner+w=401wt.eu-S1754298AbYI3W3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbYI3W3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 18:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbYI3W3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 18:29:17 -0400
Received: from eastrmpop110.cox.net ([68.230.240.52]:50233 "EHLO
	eastrmpop110.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbYI3W3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 18:29:16 -0400
X-Greylist: delayed 1499 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Sep 2008 18:29:16 EDT
X-Authority-Analysis: v=1.0 c=1 a=6hjIF59KEesA:10 a=Va7NRdlGJY0A:10
 a=S7BzmoFTGKsA:10 a=aiW0uXYV6nF7mppGoAgA:9 a=XyEnhYJKAa5JpW8xUFJI0SPnffIA:4
 a=CWfAmLVWKswA:10
X-CM-Score: 0.00
Date: Tue, 30 Sep 2008 18:04:15 -0400
From: Christian <cjs@dhp.com>
To: linux-kernel@vger.kernel.org
Subject: Re: exception Emask 0x0 SAct 0x1 / SErr 0x0 action 0x2 frozen
Message-ID: <20080930220415.GC5334@dhp.com>
Reply-To: Christian <cjs@dhp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm also experiencing the same issue..

These messages have been coming in from time to time (sometimes a couple per day).  I've tried getting around with this with various kernel settings such as noapic with no luck.

The drives are running on a Supermicro 8 port SATA card (AOC-SAT2-MV8) that's plugged into a standard PCI slot (not pci-x).

01:07.0 SCSI storage controller: Marvell Technology Group Ltd. MV88SX6081 8-port SATA II PCI-X Controller (rev 09)



ata10.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
ata10.00: cmd 61/08:00:3f:59:70/00:00:74:00:00/40 tag 0 ncq 4096 out
         res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
ata10.00: status: { DRDY }
ata10: hard resetting link
ata10: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata10.00: max_sectors limited to 256 for NCQ
ata10.00: max_sectors limited to 256 for NCQ
ata10.00: configured for UDMA/133
ata10: EH complete
sd 9:0:0:0: [sdg] 1953525168 512-byte hardware sectors (1000205 MB)
sd 9:0:0:0: [sdg] Write Protect is off
sd 9:0:0:0: [sdg] Mode Sense: 00 3a 00 00
sd 9:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

ata11.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
ata11.00: cmd 60/18:00:bf:61:58/00:00:35:00:00/40 tag 0 ncq 12288 in
         res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
ata11.00: status: { DRDY }
ata11: hard resetting link
ata11: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata11.00: max_sectors limited to 256 for NCQ
ata11.00: max_sectors limited to 256 for NCQ
ata11.00: configured for UDMA/133
ata11: EH complete
sd 10:0:0:0: [sdh] 1953525168 512-byte hardware sectors (1000205 MB)
sd 10:0:0:0: [sdh] Write Protect is off
sd 10:0:0:0: [sdh] Mode Sense: 00 3a 00 00
sd 10:0:0:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

ata9.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
ata9.00: cmd 61/08:00:3f:59:70/00:00:74:00:00/40 tag 0 ncq 4096 out
         res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
ata9.00: status: { DRDY }
ata9: hard resetting link
ata9: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata9.00: max_sectors limited to 256 for NCQ
ata9.00: max_sectors limited to 256 for NCQ
ata9.00: configured for UDMA/133
ata9: EH complete
sd 8:0:0:0: [sdf] 1953525168 512-byte hardware sectors (1000205 MB)
sd 8:0:0:0: [sdf] Write Protect is off
sd 8:0:0:0: [sdf] Mode Sense: 00 3a 00 00
sd 8:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA


