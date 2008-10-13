Return-Path: <linux-kernel-owner+w=401wt.eu-S1757311AbYJMOaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbYJMOaH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 10:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755041AbYJMO3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 10:29:55 -0400
Received: from mail.ku-gbr.de ([81.3.11.18]:39257 "EHLO ku-gbr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754970AbYJMO3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 10:29:54 -0400
Date: Mon, 13 Oct 2008 16:29:51 +0200
From: Konstantin Kletschke <lists@ku-gbr.de>
To: linux-kernel@vger.kernel.org
Subject: Re: SATA Cold Boot problems on >2.6.25 with NV
Message-ID: <20081013142951.GB23124@anita.doom>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <48E89839.5030307@panasas.com> <48E899F9.9040206@kernel.org> <20081006211906.GA31148@anita.doom> <20081006212307.GA881@anita.doom> <48EAB535.8010203@kernel.org> <20081007060357.GA16761@anita.doom> <48EB1993.1030606@panasas.com> <20081008080848.GA20525@anita.doom> <48F3088C.9010002@kernel.org> <48F308E8.4030503@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F308E8.4030503@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2008-10-13 17:38 +0900 schrieb Tejun Heo:

> Also, can you please repeat the test several times and see whether there

Still I have the last suggested patch running and the machine solves to
boot cold any time (I am shure meanwhile, turned off the whole sunday it
botted this morning and so on - any time).

Consistent is this issue telling something about MISSCLASSIFIED:

sata_nv 0000:00:0a.0: version 3.5
ACPI: PCI Interrupt Link [LTID] enabled at IRQ 21
sata_nv 0000:00:0a.0: PCI INT A -> Link[LTID] -> GSI 21 (level, low) -> IRQ 21
sata_nv 0000:00:0a.0: setting latency timer to 64
scsi0 : sata_nv
scsi1 : sata_nv
ata1: SATA max UDMA/133 cmd 0xf80 ctl 0xf00 bmdma 0xd800 irq 21
ata2: SATA max UDMA/133 cmd 0xe80 ctl 0xe00 bmdma 0xd808 irq 21
ata1: hard resetting link
ata1: link is slow to respond, please be patient (ready=0)
ata1: SRST failed (errno=-16)
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1: link online but device misclassified, retrying
ata1: hard resetting link
ata1: link is slow to respond, please be patient (ready=0)
ata1: SRST failed (errno=-16)
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1: link online but device misclassified, retrying
ata1: hard resetting link
XXX CLASSIFY 01:00:00
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: SAMSUNG HD753LJ, 1AA01106, max UDMA7
ata1.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/133
ata1: EH complete
ata2: hard resetting link
ata2: SATA link down (SStatus 0 SControl 300)
ata2: EH complete
isa bounce pool size: 16 pages
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD753LJ  1AA0 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 1465149168 512-byte hardware sectors (750156 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 1465149168 512-byte hardware sectors (750156 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 >
sd 0:0:0:0: [sda] Attached SCSI disk

It struggles a bit then (a couple of seconds?), but solves to boot.

> are some patterns?  And please also try pre-2.6.26 kernel a few times

This is consitent now.

> just to make sure it's not some bad coincidence.

I will check this out but need to look if this is possible with my nfsv4
issues then, I will report.

Konsti


-- 
GPG KeyID EF62FCEF
Fingerprint: 13C9 B16B 9844 EC15 CC2E  A080 1E69 3FDA EF62 FCEF
