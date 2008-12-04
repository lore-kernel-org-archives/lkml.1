Return-Path: <linux-kernel-owner+w=401wt.eu-S1756583AbYLDGXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583AbYLDGXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 01:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753886AbYLDGXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 01:23:09 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:52921 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824AbYLDGXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 01:23:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:x-mailer:mime-version:subject:date:cc;
        b=Llqq0Qff+5C9J7//ZEONah1XJDwlCN3meFis0JyHEb2JLmMKZIlR5d7/5o0msk2Igt
         Ev1mXXygcjNcZuaveL5udGibboikp9q7tyxgtgOpOZggeuOIRfHJwqSfXhp0sQg26QvK
         3q4vqN+0AtehiUy8wGE992UCuHrwa/zttlcdQ=
References: <200812021113.50519.ml_linuxkernel_20080830@kcore.org> <49376E8A.1070503@shaw.ca>
Message-Id: <D29D5D17-36AA-4974-BB2B-7E28E8306F52@gmail.com>
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: Robert Hancock <hancockr@shaw.ca>
In-Reply-To: <49376E8A.1070503@shaw.ca>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (5G77)
Mime-Version: 1.0 (iPhone Mail 5G77)
Subject: Re: 2.6.27 - swncq problem with nforce 570 and ST3320620AS?
Date: Wed, 3 Dec 2008 22:22:57 -0800
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was receiving the { DRDY }
thing with some .config option
  from Some distro I was using,
Then revered to my f*^%ed
Up .config and all was good.
Try experimenting if this helps.

justin P. Mattock



On Dec 3, 2008, at 9:45 PM, Robert Hancock <hancockr@shaw.ca> wrote:

> Jan De Luyck wrote:
>> Hello,
>> I switched not too long ago to 2.6.27-series, and since then I've  
>> been getting this now and then at bootup:
>> This was with 2.6.27.4, upgraded today to 2.6.27.7.
>> Disk in question is:
>> ATA device, with non-removable media
>>        Model Number:        
>> ST3320620AS                                   Serial Number:       
>> 9QF1QMGA
>>        Firmware Revision:  3.AAE   whocares kernel: ata4: EH in  
>> SWNCQ mode,QC:qc_active 0x6 sactive 0x6
>> whocares kernel: ata4: SWNCQ:qc_active 0x6 defer_bits 0x0  
>> last_issue_tag 0x2
>> whocares kernel:   dhfis 0x6 dmafis 0x2 sdbfis 0x0
>> whocares kernel: ata4: ATA_REG 0x40 ERR_REG 0x0
>> whocares kernel: ata4: tag : dhfis dmafis sdbfis sacitve
>> whocares kernel: ata4: tag 0x1: 1 1 0 1
>> whocares kernel: ata4: tag 0x2: 1 0 0 1
>> whocares kernel: ata4.00: exception Emask 0x0 SAct 0x6 SErr  
>> 0x1800000 action 0x6 frozen
>> whocares kernel: ata4: SError: { LinkSeq TrStaTrns }
>> whocares kernel: ata4.00: cmd 60/3e:08:61:00:00/00:00:00:00:00/40  
>> tag 1 ncq 31744 in
>> whocares kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00  
>> Emask 0x4 (timeout)
>> whocares kernel: ata4.00: status: { DRDY }
>> whocares kernel: ata4.00: cmd 60/02:10:bf:d6:42/00:00:25:00:00/40  
>> tag 2 ncq 1024 in
>> whocares kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00  
>> Emask 0x4 (timeout)
>> whocares kernel: ata4.00: status: { DRDY }
>> whocares kernel: ata4: hard resetting link
>> whocares kernel: ata4: SATA link up 3.0 Gbps (SStatus 123 SControl  
>> 300)
>> whocares kernel: ata4.00: configured for UDMA/133
>> whocares kernel: ata4: EH complete
>> whocares kernel: sd 3:0:0:0: [sdd] 625142448 512-byte hardware  
>> sectors (320073 MB)
>> whocares kernel: sd 3:0:0:0: [sdd] Write Protect is off
>> whocares kernel: sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
>> whocares kernel: sd 3:0:0:0: [sdd] Write cache: enabled, read  
>> cache: enabled, doesn't support DPO or FUA
>> ...
>> whocares kernel: XFS mounting filesystem sdd1
>> whocares kernel: ata4: EH in SWNCQ mode,QC:qc_active 0xF sactive 0xF
>> whocares kernel: ata4: SWNCQ:qc_active 0x1 defer_bits 0xE  
>> last_issue_tag 0x0
>> whocares kernel:   dhfis 0x1 dmafis 0x1 sdbfis 0x0
>> whocares kernel: ata4: ATA_REG 0x40 ERR_REG 0x0
>> whocares kernel: ata4: tag : dhfis dmafis sdbfis sacitve
>> whocares kernel: ata4: tag 0x0: 1 1 0 1
>> whocares kernel: ata4.00: exception Emask 0x0 SAct 0xf SErr  
>> 0x400000 action 0x6 frozen
>> whocares kernel: ata4: SError: { Handshk }
>> whocares kernel: ata4.00: cmd 61/00:00:9f:8d:a2/04:00:12:00:00/40  
>> tag 0 ncq 524288 out
>> whocares kernel:          res 40/00:00:00:00:00/00:00:00:00:00/40  
>> Emask 0x4 (timeout)
>> whocares kernel: ata4.00: status: { DRDY }
>> whocares kernel: ata4.00: cmd 61/00:08:9f:91:a2/04:00:12:00:00/40  
>> tag 1 ncq 524288 out
>> whocares kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00  
>> Emask 0x4 (timeout)
>> whocares kernel: ata4.00: status: { DRDY }
>> whocares kernel: ata4.00: cmd 61/00:10:9f:95:a2/04:00:12:00:00/40  
>> tag 2 ncq 524288 out
>> whocares kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00  
>> Emask 0x4 (timeout)
>> whocares kernel: ata4.00: status: { DRDY }
>> whocares kernel: ata4.00: cmd 61/00:18:9f:99:a2/04:00:12:00:00/40  
>> tag 3 ncq 524288 out
>> whocares kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00  
>> Emask 0x4 (timeout)
>> whocares kernel: ata4.00: status: { DRDY }
>> whocares kernel: ata4: hard resetting link
>> whocares kernel: ata4: SATA link up 3.0 Gbps (SStatus 123 SControl  
>> 300)
>> whocares kernel: ata4.00: configured for UDMA/133
>> whocares kernel: ata4: EH complete
>> whocares kernel: sd 3:0:0:0: [sdd] 625142448 512-byte hardware  
>> sectors (320073 MB)
>> whocares kernel: sd 3:0:0:0: [sdd] Write Protect is off
>> whocares kernel: sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
>> whocares kernel: sd 3:0:0:0: [sdd] Write cache: enabled, read  
>> cache: enabled, doesn't support DPO or FUA
>> whocares kernel: ata4: EH in SWNCQ mode,QC:qc_active 0xF sactive 0xF
>> whocares kernel: ata4: SWNCQ:qc_active 0x1 defer_bits 0xE  
>> last_issue_tag 0x0
>> whocares kernel:   dhfis 0x1 dmafis 0x1 sdbfis 0x0
>> whocares kernel: ata4: ATA_REG 0x40 ERR_REG 0x0
>> whocares kernel: ata4: tag : dhfis dmafis sdbfis sacitve
>> whocares kernel: ata4: tag 0x0: 1 1 0 1
>> whocares kernel: ata4.00: exception Emask 0x0 SAct 0xf SErr  
>> 0x400000 action 0x6 frozen
>> whocares kernel: ata4: SError: { Handshk }
>> whocares kernel: ata4.00: cmd 61/00:00:9f:99:a2/04:00:12:00:00/40  
>> tag 0 ncq 524288 out
>> whocares kernel:          res 40/00:00:00:00:00/00:00:00:00:00/40  
>> Emask 0x4 (timeout)
>> whocares kernel: ata4.00: status: { DRDY }
>> whocares kernel: ata4.00: cmd 61/00:08:9f:95:a2/04:00:12:00:00/40  
>> tag 1 ncq 524288 out
>> whocares kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00  
>> Emask 0x4 (timeout)
>> whocares kernel: ata4.00: status: { DRDY }
>> whocares kernel: ata4.00: cmd 61/00:10:9f:91:a2/04:00:12:00:00/40  
>> tag 2 ncq 524288 out
>> whocares kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00  
>> Emask 0x4 (timeout)
>> whocares kernel: ata4.00: status: { DRDY }
>> whocares kernel: ata4.00: cmd 61/00:18:9f:8d:a2/04:00:12:00:00/40  
>> tag 3 ncq 524288 out
>> whocares kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00  
>> Emask 0x4 (timeout)
>> whocares kernel: ata4.00: status: { DRDY }
>> whocares kernel: ata4: hard resetting link
>> whocares kernel: ata4: SATA link up 3.0 Gbps (SStatus 123 SControl  
>> 300)
>> whocares kernel: ata4.00: configured for UDMA/133
>> whocares kernel: ata4: EH complete
>> whocares kernel: sd 3:0:0:0: [sdd] 625142448 512-byte hardware  
>> sectors (320073 MB)
>> whocares kernel: sd 3:0:0:0: [sdd] Write Protect is off
>> whocares kernel: sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
>> whocares kernel: sd 3:0:0:0: [sdd] Write cache: enabled, read  
>> cache: enabled, doesn't support DPO or FUA
>> whocares kernel: Ending clean XFS mount for filesystem: sdd1
>> ...
>> Anyone any idea what might be causing this?
>> I have several disks of the same type in my PC, with different  
>> firmwares though - this is the only one exhibiting this problem.
>
> This fact and the fact that those SError bits are showing up does  
> potentially point to a hardware issue.. perhaps a problem with the  
> cable, or this drive is somehow getting worse power than the others?
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
