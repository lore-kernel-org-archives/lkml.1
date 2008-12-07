Return-Path: <linux-kernel-owner+w=401wt.eu-S1753654AbYLGVUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbYLGVUq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 16:20:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbYLGVUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 16:20:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34709 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbYLGVUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 16:20:36 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jan De Luyck <ml_linuxkernel_20080830@kcore.org>
Subject: Re: 2.6.27 - swncq problem with nforce 570 and ST3320620AS?
Date: Sun, 7 Dec 2008 22:20:05 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200812021113.50519.ml_linuxkernel_20080830@kcore.org>
In-Reply-To: <200812021113.50519.ml_linuxkernel_20080830@kcore.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812072220.06096.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 2 of December 2008, Jan De Luyck wrote:
> Hello,
> 
> I switched not too long ago to 2.6.27-series, and since then I've been getting this now and then at bootup:
> 
> This was with 2.6.27.4, upgraded today to 2.6.27.7.

Does it happen with the current mainline too?

Rafael


> Disk in question is:
> 
> ATA device, with non-removable media
>         Model Number:       ST3320620AS                           
>         Serial Number:      9QF1QMGA
>         Firmware Revision:  3.AAE   
> 
> whocares kernel: ata4: EH in SWNCQ mode,QC:qc_active 0x6 sactive 0x6
> whocares kernel: ata4: SWNCQ:qc_active 0x6 defer_bits 0x0 last_issue_tag 0x2
> whocares kernel:   dhfis 0x6 dmafis 0x2 sdbfis 0x0
> whocares kernel: ata4: ATA_REG 0x40 ERR_REG 0x0
> whocares kernel: ata4: tag : dhfis dmafis sdbfis sacitve
> whocares kernel: ata4: tag 0x1: 1 1 0 1
> whocares kernel: ata4: tag 0x2: 1 0 0 1
> whocares kernel: ata4.00: exception Emask 0x0 SAct 0x6 SErr 0x1800000 action 0x6 frozen
> whocares kernel: ata4: SError: { LinkSeq TrStaTrns }
> whocares kernel: ata4.00: cmd 60/3e:08:61:00:00/00:00:00:00:00/40 tag 1 ncq 31744 in
> whocares kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> whocares kernel: ata4.00: status: { DRDY }
> whocares kernel: ata4.00: cmd 60/02:10:bf:d6:42/00:00:25:00:00/40 tag 2 ncq 1024 in
> whocares kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> whocares kernel: ata4.00: status: { DRDY }
> whocares kernel: ata4: hard resetting link
> whocares kernel: ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> whocares kernel: ata4.00: configured for UDMA/133
> whocares kernel: ata4: EH complete
> whocares kernel: sd 3:0:0:0: [sdd] 625142448 512-byte hardware sectors (320073 MB)
> whocares kernel: sd 3:0:0:0: [sdd] Write Protect is off
> whocares kernel: sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
> whocares kernel: sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> ...
> whocares kernel: XFS mounting filesystem sdd1
> whocares kernel: ata4: EH in SWNCQ mode,QC:qc_active 0xF sactive 0xF
> whocares kernel: ata4: SWNCQ:qc_active 0x1 defer_bits 0xE last_issue_tag 0x0
> whocares kernel:   dhfis 0x1 dmafis 0x1 sdbfis 0x0
> whocares kernel: ata4: ATA_REG 0x40 ERR_REG 0x0
> whocares kernel: ata4: tag : dhfis dmafis sdbfis sacitve
> whocares kernel: ata4: tag 0x0: 1 1 0 1
> whocares kernel: ata4.00: exception Emask 0x0 SAct 0xf SErr 0x400000 action 0x6 frozen
> whocares kernel: ata4: SError: { Handshk }
> whocares kernel: ata4.00: cmd 61/00:00:9f:8d:a2/04:00:12:00:00/40 tag 0 ncq 524288 out
> whocares kernel:          res 40/00:00:00:00:00/00:00:00:00:00/40 Emask 0x4 (timeout)
> whocares kernel: ata4.00: status: { DRDY }
> whocares kernel: ata4.00: cmd 61/00:08:9f:91:a2/04:00:12:00:00/40 tag 1 ncq 524288 out
> whocares kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> whocares kernel: ata4.00: status: { DRDY }
> whocares kernel: ata4.00: cmd 61/00:10:9f:95:a2/04:00:12:00:00/40 tag 2 ncq 524288 out
> whocares kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> whocares kernel: ata4.00: status: { DRDY }
> whocares kernel: ata4.00: cmd 61/00:18:9f:99:a2/04:00:12:00:00/40 tag 3 ncq 524288 out
> whocares kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> whocares kernel: ata4.00: status: { DRDY }
> whocares kernel: ata4: hard resetting link
> whocares kernel: ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> whocares kernel: ata4.00: configured for UDMA/133
> whocares kernel: ata4: EH complete
> whocares kernel: sd 3:0:0:0: [sdd] 625142448 512-byte hardware sectors (320073 MB)
> whocares kernel: sd 3:0:0:0: [sdd] Write Protect is off
> whocares kernel: sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
> whocares kernel: sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> whocares kernel: ata4: EH in SWNCQ mode,QC:qc_active 0xF sactive 0xF
> whocares kernel: ata4: SWNCQ:qc_active 0x1 defer_bits 0xE last_issue_tag 0x0
> whocares kernel:   dhfis 0x1 dmafis 0x1 sdbfis 0x0
> whocares kernel: ata4: ATA_REG 0x40 ERR_REG 0x0
> whocares kernel: ata4: tag : dhfis dmafis sdbfis sacitve
> whocares kernel: ata4: tag 0x0: 1 1 0 1
> whocares kernel: ata4.00: exception Emask 0x0 SAct 0xf SErr 0x400000 action 0x6 frozen
> whocares kernel: ata4: SError: { Handshk }
> whocares kernel: ata4.00: cmd 61/00:00:9f:99:a2/04:00:12:00:00/40 tag 0 ncq 524288 out
> whocares kernel:          res 40/00:00:00:00:00/00:00:00:00:00/40 Emask 0x4 (timeout)
> whocares kernel: ata4.00: status: { DRDY }
> whocares kernel: ata4.00: cmd 61/00:08:9f:95:a2/04:00:12:00:00/40 tag 1 ncq 524288 out
> whocares kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> whocares kernel: ata4.00: status: { DRDY }
> whocares kernel: ata4.00: cmd 61/00:10:9f:91:a2/04:00:12:00:00/40 tag 2 ncq 524288 out
> whocares kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> whocares kernel: ata4.00: status: { DRDY }
> whocares kernel: ata4.00: cmd 61/00:18:9f:8d:a2/04:00:12:00:00/40 tag 3 ncq 524288 out
> whocares kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> whocares kernel: ata4.00: status: { DRDY }
> whocares kernel: ata4: hard resetting link
> whocares kernel: ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> whocares kernel: ata4.00: configured for UDMA/133
> whocares kernel: ata4: EH complete
> whocares kernel: sd 3:0:0:0: [sdd] 625142448 512-byte hardware sectors (320073 MB)
> whocares kernel: sd 3:0:0:0: [sdd] Write Protect is off
> whocares kernel: sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
> whocares kernel: sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> whocares kernel: Ending clean XFS mount for filesystem: sdd1
> ...
> 
> Anyone any idea what might be causing this?
> 
> I have several disks of the same type in my PC, with different firmwares though - this is the only 
> one exhibiting this problem.
