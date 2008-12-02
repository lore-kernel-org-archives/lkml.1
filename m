Return-Path: <linux-kernel-owner+w=401wt.eu-S1753244AbYLBII0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbYLBII0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 03:08:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbYLBIIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 03:08:16 -0500
Received: from nn7.de ([85.214.94.156]:51094 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbYLBIIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 03:08:15 -0500
Subject: ST31500341AS vs ICH10, exception Emask 0x50 SAct 0x1 SErr 0x280900
	action 0x6 frozen
From: Soeren Sonnenburg <kernel@nn7.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux-ide <linux-ide@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 02 Dec 2008 09:08:09 +0100
Message-Id: <1228205289.29251.32.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I just purchased a seagate 1.5TB drive ST31500341AS, with firmware
revision CC1G (which according to seagate is not affected by the cache
flush bug) and I am getting the errors below (after almost a day of
uptime without problems). The drive is replacing a 750G variant from
seagate with which I had months of uptime and no errors whatsoever.

I hope anyone has an idea?

- relevant part of hdparm -I and lspci

ATA device, with non-removable media
	Model Number:       ST31500341AS                            
	Firmware Revision:  CC1G    
	Transport:          Serial

00:1f.2 SATA controller: Intel Corporation 82801JI (ICH10 Family) SATA
AHCI Controller

- the error(tm)

ata3.00: exception Emask 0x50 SAct 0x1 SErr 0x280900 action 0x6 frozen
ata3.00: irq_stat 0x08000000, interface fatal error
ata3: SError: { UnrecovData HostInt 10B8B BadCRC }
ata3.00: cmd 60/00:00:20:d4:66/01:00:1e:00:00/40 tag 0 ncq 131072 in
         res 40/00:00:20:d4:66/00:00:1e:00:00/40 Emask 0x50 (ATA bus error)
ata3.00: status: { DRDY }
ata3: hard resetting link
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: both IDENTIFYs aborted, assuming NODEV
ata3.00: revalidation failed (errno=-2)
ata3: hard resetting link
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: configured for UDMA/133
ata3: EH complete
sd 2:0:0:0: [sdc] 2930277168 512-byte hardware sectors (1500302 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata3.00: exception Emask 0x10 SAct 0x1 SErr 0x280100 action 0x6 frozen
ata3.00: irq_stat 0x08000000, interface fatal error
ata3: SError: { UnrecovData 10B8B BadCRC }
ata3.00: cmd 60/00:00:30:12:67/01:00:1e:00:00/40 tag 0 ncq 131072 in
         res 40/00:00:30:12:67/00:00:1e:00:00/40 Emask 0x10 (ATA bus error)
ata3.00: status: { DRDY }
ata3: hard resetting link
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: both IDENTIFYs aborted, assuming NODEV
ata3.00: revalidation failed (errno=-2)
ata3: hard resetting link
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: configured for UDMA/133
ata3: EH complete
sd 2:0:0:0: [sdc] 2930277168 512-byte hardware sectors (1500302 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata3.00: exception Emask 0x10 SAct 0x1 SErr 0x280100 action 0x6 frozen
ata3.00: irq_stat 0x08000000, interface fatal error
ata3: SError: { UnrecovData 10B8B BadCRC }
ata3.00: cmd 60/00:00:30:17:67/01:00:1e:00:00/40 tag 0 ncq 131072 in
         res 40/00:00:30:17:67/00:00:1e:00:00/40 Emask 0x10 (ATA bus error)
ata3.00: status: { DRDY }
ata3: hard resetting link
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: both IDENTIFYs aborted, assuming NODEV
ata3.00: revalidation failed (errno=-2)
ata3: hard resetting link
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: configured for UDMA/133
ata3: EH complete
sd 2:0:0:0: [sdc] 2930277168 512-byte hardware sectors (1500302 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata3: limiting SATA link speed to 1.5 Gbps
ata3.00: exception Emask 0x10 SAct 0x1 SErr 0x280100 action 0x6 frozen
ata3.00: irq_stat 0x08000000, interface fatal error
ata3: SError: { UnrecovData 10B8B BadCRC }
ata3.00: cmd 60/00:00:30:19:67/01:00:1e:00:00/40 tag 0 ncq 131072 in
         res 40/00:00:30:19:67/00:00:1e:00:00/40 Emask 0x10 (ATA bus error)
ata3.00: status: { DRDY }
ata3: hard resetting link
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: both IDENTIFYs aborted, assuming NODEV
ata3.00: revalidation failed (errno=-2)
ata3: hard resetting link
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: configured for UDMA/133
ata3: exception Emask 0x40 SAct 0x0 SErr 0x80800 action 0x7 t4
ata3: irq_stat 0x40000001
ata3: SError: { HostInt 10B8B }
ata3: hard resetting link
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: failed to IDENTIFY (I/O error, err_mask=0x100)
ata3.00: revalidation failed (errno=-5)
ata3: hard resetting link
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: configured for UDMA/133
ata3: exception Emask 0x50 SAct 0x0 SErr 0x80800 action 0x7 t3
ata3: irq_stat 0x08000002, interface fatal error
ata3: SError: { HostInt 10B8B }
ata3: hard resetting link
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: configured for UDMA/133
ata3: EH complete
sd 2:0:0:0: [sdc] 2930277168 512-byte hardware sectors (1500302 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sdc] 2930277168 512-byte hardware sectors (1500302 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata3.00: exception Emask 0x50 SAct 0x3 SErr 0x280900 action 0x6 frozen
ata3.00: irq_stat 0x08000000, interface fatal error
ata3: SError: { UnrecovData HostInt 10B8B BadCRC }
ata3.00: cmd 60/00:00:30:19:67/01:00:1e:00:00/40 tag 0 ncq 131072 in
         res 40/00:08:30:1a:67/00:00:1e:00:00/40 Emask 0x50 (ATA bus error)
ata3.00: status: { DRDY }
ata3.00: cmd 60/00:08:30:1a:67/01:00:1e:00:00/40 tag 1 ncq 131072 in
         res 40/00:08:30:1a:67/00:00:1e:00:00/40 Emask 0x50 (ATA bus error)
ata3.00: status: { DRDY }
ata3: hard resetting link
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: both IDENTIFYs aborted, assuming NODEV
ata3.00: revalidation failed (errno=-2)
ata3: hard resetting link
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: configured for UDMA/133
ata3: exception Emask 0x40 SAct 0x0 SErr 0x80800 action 0x7 t4
ata3: irq_stat 0x40000001
ata3: SError: { HostInt 10B8B }
ata3: hard resetting link
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: configured for UDMA/133
ata3: EH complete
sd 2:0:0:0: [sdc] 2930277168 512-byte hardware sectors (1500302 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sdc] 2930277168 512-byte hardware sectors (1500302 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata3.00: exception Emask 0x50 SAct 0x3 SErr 0x280900 action 0x6 frozen
ata3.00: irq_stat 0x08000000, interface fatal error
ata3: SError: { UnrecovData HostInt 10B8B BadCRC }
ata3.00: cmd 60/00:00:30:1a:67/01:00:1e:00:00/40 tag 0 ncq 131072 in
         res 40/00:08:30:19:67/00:00:1e:00:00/40 Emask 0x50 (ATA bus error)
ata3.00: status: { DRDY }
ata3.00: cmd 60/00:08:30:19:67/01:00:1e:00:00/40 tag 1 ncq 131072 in
         res 40/00:08:30:19:67/00:00:1e:00:00/40 Emask 0x50 (ATA bus error)
ata3.00: status: { DRDY }
ata3: hard resetting link
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: both IDENTIFYs aborted, assuming NODEV
ata3.00: revalidation failed (errno=-2)
ata3: hard resetting link
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: configured for UDMA/133
ata3: exception Emask 0x40 SAct 0x0 SErr 0x80800 action 0x7 t4
ata3: irq_stat 0x40000001
ata3: SError: { HostInt 10B8B }
ata3: hard resetting link
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: configured for UDMA/133
ata3: EH complete
sd 2:0:0:0: [sdc] 2930277168 512-byte hardware sectors (1500302 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sdc] 2930277168 512-byte hardware sectors (1500302 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata3.00: limiting speed to UDMA/100:PIO4
ata3.00: exception Emask 0x50 SAct 0x3 SErr 0x280900 action 0x6 frozen
ata3.00: irq_stat 0x08000000, interface fatal error
ata3: SError: { UnrecovData HostInt 10B8B BadCRC }
ata3.00: cmd 60/00:00:30:19:67/01:00:1e:00:00/40 tag 0 ncq 131072 in
         res 40/00:08:30:1a:67/00:00:1e:00:00/40 Emask 0x50 (ATA bus error)
ata3.00: status: { DRDY }
ata3.00: cmd 60/00:08:30:1a:67/01:00:1e:00:00/40 tag 1 ncq 131072 in
         res 40/00:08:30:1a:67/00:00:1e:00:00/40 Emask 0x50 (ATA bus error)
ata3.00: status: { DRDY }
ata3: hard resetting link
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: both IDENTIFYs aborted, assuming NODEV
ata3.00: revalidation failed (errno=-2)
ata3: hard resetting link
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: configured for UDMA/100
ata3: exception Emask 0x40 SAct 0x0 SErr 0x80800 action 0x7 t4
ata3: irq_stat 0x40000001
ata3: SError: { HostInt 10B8B }
ata3: hard resetting link
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: configured for UDMA/100
ata3: EH complete
sd 2:0:0:0: [sdc] 2930277168 512-byte hardware sectors (1500302 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sdc] 2930277168 512-byte hardware sectors (1500302 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata3.00: exception Emask 0x50 SAct 0x3 SErr 0x280900 action 0x6 frozen
ata3.00: irq_stat 0x08000000, interface fatal error
ata3: SError: { UnrecovData HostInt 10B8B BadCRC }
ata3.00: cmd 60/00:00:30:1a:67/01:00:1e:00:00/40 tag 0 ncq 131072 in
         res 40/00:08:30:19:67/00:00:1e:00:00/40 Emask 0x50 (ATA bus error)
ata3.00: status: { DRDY }
ata3.00: cmd 60/00:08:30:19:67/01:00:1e:00:00/40 tag 1 ncq 131072 in
         res 40/00:08:30:19:67/00:00:1e:00:00/40 Emask 0x50 (ATA bus error)
ata3.00: status: { DRDY }
ata3: hard resetting link
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: both IDENTIFYs aborted, assuming NODEV
ata3.00: revalidation failed (errno=-2)
ata3: hard resetting link
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: configured for UDMA/100
ata3: exception Emask 0x40 SAct 0x0 SErr 0x80800 action 0x7 t4
ata3: irq_stat 0x40000001
ata3: SError: { HostInt 10B8B }
ata3: hard resetting link
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: configured for UDMA/100
ata3: EH complete
sd 2:0:0:0: [sdc] 2930277168 512-byte hardware sectors (1500302 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sdc] 2930277168 512-byte hardware sectors (1500302 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata3.00: limiting speed to UDMA/33:PIO4
ata3.00: exception Emask 0x50 SAct 0x3 SErr 0x280900 action 0x6 frozen
ata3.00: irq_stat 0x08000000, interface fatal error
ata3: SError: { UnrecovData HostInt 10B8B BadCRC }
ata3.00: cmd 60/00:00:30:19:67/01:00:1e:00:00/40 tag 0 ncq 131072 in
         res 40/00:08:30:1a:67/00:00:1e:00:00/40 Emask 0x50 (ATA bus error)
ata3.00: status: { DRDY }
ata3.00: cmd 60/00:08:30:1a:67/01:00:1e:00:00/40 tag 1 ncq 131072 in
         res 40/00:08:30:1a:67/00:00:1e:00:00/40 Emask 0x50 (ATA bus error)
ata3.00: status: { DRDY }
ata3: hard resetting link
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: both IDENTIFYs aborted, assuming NODEV
ata3.00: revalidation failed (errno=-2)
ata3: hard resetting link
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: configured for UDMA/33
ata3: exception Emask 0x40 SAct 0x0 SErr 0x80800 action 0x7 t4
ata3: irq_stat 0x40000001
ata3: SError: { HostInt 10B8B }
ata3: hard resetting link
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: configured for UDMA/33
sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
        72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
        1e 67 1a 30 
sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
end_request: I/O error, dev sdc, sector 510073136
ata3: EH complete
sd 2:0:0:0: [sdc] 2930277168 512-byte hardware sectors (1500302 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sdc] 2930277168 512-byte hardware sectors (1500302 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata3.00: exception Emask 0x50 SAct 0x3 SErr 0x280900 action 0x6 frozen
ata3.00: irq_stat 0x08000000, interface fatal error
ata3: SError: { UnrecovData HostInt 10B8B BadCRC }
ata3.00: cmd 60/00:00:30:1a:67/01:00:1e:00:00/40 tag 0 ncq 131072 in
         res 40/00:08:30:19:67/00:00:1e:00:00/40 Emask 0x50 (ATA bus error)
ata3.00: status: { DRDY }
ata3.00: cmd 60/08:08:30:19:67/00:00:1e:00:00/40 tag 1 ncq 4096 in
         res 40/00:08:30:19:67/00:00:1e:00:00/40 Emask 0x50 (ATA bus error)
ata3.00: status: { DRDY }
ata3: hard resetting link
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: both IDENTIFYs aborted, assuming NODEV
ata3.00: revalidation failed (errno=-2)
ata3: hard resetting link
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: configured for UDMA/33
ata3: exception Emask 0x40 SAct 0x0 SErr 0x80800 action 0x7 t4
ata3: irq_stat 0x40000001
ata3: SError: { HostInt 10B8B }
ata3: hard resetting link
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: failed to IDENTIFY (I/O error, err_mask=0x100)
ata3.00: revalidation failed (errno=-5)
ata3: hard resetting link
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: failed to IDENTIFY (I/O error, err_mask=0x100)
ata3.00: revalidation failed (errno=-5)
ata3.00: limiting speed to UDMA/33:PIO3
ata3: hard resetting link
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: configured for UDMA/33
ata3: exception Emask 0x50 SAct 0x0 SErr 0x80800 action 0x7 t3
ata3: irq_stat 0x08000002, interface fatal error
ata3: SError: { HostInt 10B8B }
ata3: hard resetting link
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: configured for UDMA/33
sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
        72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
        1e 67 19 30 
sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
end_request: I/O error, dev sdc, sector 510073392
ata3: EH complete
sd 2:0:0:0: [sdc] 2930277168 512-byte hardware sectors (1500302 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sdc] 2930277168 512-byte hardware sectors (1500302 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata3.00: exception Emask 0x50 SAct 0x1 SErr 0x280900 action 0x6 frozen
ata3.00: irq_stat 0x08000000, interface fatal error
ata3: SError: { UnrecovData HostInt 10B8B BadCRC }
ata3.00: cmd 60/08:00:40:19:67/00:00:1e:00:00/40 tag 0 ncq 4096 in
         res 40/00:00:40:19:67/00:00:1e:00:00/40 Emask 0x50 (ATA bus error)
ata3.00: status: { DRDY }
ata3: hard resetting link
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: both IDENTIFYs aborted, assuming NODEV
ata3.00: revalidation failed (errno=-2)
ata3: hard resetting link
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: configured for UDMA/33
ata3: exception Emask 0x40 SAct 0x0 SErr 0x80800 action 0x7 t4
ata3: irq_stat 0x40000001
ata3: SError: { HostInt 10B8B }
ata3: hard resetting link
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: configured for UDMA/33
ata3: EH complete
sd 2:0:0:0: [sdc] 2930277168 512-byte hardware sectors (1500302 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sdc] 2930277168 512-byte hardware sectors (1500302 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata3.00: exception Emask 0x50 SAct 0x1 SErr 0x280900 action 0x6 frozen
ata3.00: irq_stat 0x08000000, interface fatal error
ata3: SError: { UnrecovData HostInt 10B8B BadCRC }
ata3.00: cmd 60/08:00:48:19:67/00:00:1e:00:00/40 tag 0 ncq 4096 in
         res 40/00:00:48:19:67/00:00:1e:00:00/40 Emask 0x50 (ATA bus error)
ata3.00: status: { DRDY }
ata3: hard resetting link
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: both IDENTIFYs aborted, assuming NODEV
ata3.00: revalidation failed (errno=-2)
ata3: hard resetting link
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: configured for UDMA/33
ata3: exception Emask 0x40 SAct 0x0 SErr 0x80800 action 0x7 t4
ata3: irq_stat 0x40000001
ata3: SError: { HostInt 10B8B }
ata3: hard resetting link
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: qc timeout (cmd 0xec)
ata3.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata3.00: revalidation failed (errno=-5)
ata3: hard resetting link
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: configured for UDMA/33
ata3: exception Emask 0x40 SAct 0x0 SErr 0x80800 action 0x7 t3
ata3: SError: { HostInt 10B8B }
ata3: hard resetting link
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: configured for UDMA/33
ata3: EH complete
sd 2:0:0:0: [sdc] 2930277168 512-byte hardware sectors (1500302 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sdc] 2930277168 512-byte hardware sectors (1500302 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata3.00: exception Emask 0x50 SAct 0x1 SErr 0x280900 action 0x6 frozen
ata3.00: irq_stat 0x08000000, interface fatal error
ata3: SError: { UnrecovData HostInt 10B8B BadCRC }
ata3.00: cmd 60/08:00:48:19:67/00:00:1e:00:00/40 tag 0 ncq 4096 in
         res 40/00:00:48:19:67/00:00:1e:00:00/40 Emask 0x50 (ATA bus error)
ata3.00: status: { DRDY }
ata3: hard resetting link
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: both IDENTIFYs aborted, assuming NODEV
ata3.00: revalidation failed (errno=-2)
ata3: hard resetting link
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: configured for UDMA/33
ata3: exception Emask 0x40 SAct 0x0 SErr 0x80800 action 0x7 t4
ata3: irq_stat 0x40000001
ata3: SError: { HostInt 10B8B }
ata3: hard resetting link
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: configured for UDMA/33
ata3: EH complete

Soeren
