Return-Path: <linux-kernel-owner+w=401wt.eu-S933590AbXFFPeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933590AbXFFPeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 11:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759777AbXFFPeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 11:34:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:3836 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbXFFPeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 11:34:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=b4zCMPBcWDt30ZZB6ztxvllt/3dLizpljqZqJW1/RffnRabwjP8AkceDY6qPgC9heVQoSrRDEUfoqjZwAxOy/+e5NPhToHSaR0rqR3vLqI3CA8gG0cAdTvbjf/wdZD/98nbOHWr145r1rdQnuR444QSDYsYy5Q5kZwPOITWxbCo=
Message-ID: <4666D3F8.4010002@gmail.com>
Date: Wed, 06 Jun 2007 17:34:16 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: akpm@linux-foundation.org, htejun@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1
References: <200706061421.l56ELDfB004305@harpo.it.uu.se>
In-Reply-To: <200706061421.l56ELDfB004305@harpo.it.uu.se>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson napsal(a):
> On Wed, 06 Jun 2007 15:04:00 +0200, Jiri Slaby wrote:
>> Andrew Morton napsal(a):
>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm1/
>> It freezes during bootup while searching for sata drives on sata_promise. There
>> were 2 issues with sata_promise in -rc4 IIRC, one was fixed, the latter remains
>> unresolved. Or, should be this solved too, Mikael, Tejun and is this yet
>> eanother problem? (In this case I'll post dmesg and co.)
> 
> I know of only one sata_promise-specific issue in 2.6.22-rc4.
> Tejun's "sata_promise: use TF interface for polling NODATA commands"
> patch posted today fixes it.

It's in that -mm, so I think, this seems to be another problem.

> If there are any other sata_promise-specific issues, please
> let us know.

ACPI: PCI Interrupt 0000:02:01.0[A] -> GSI 21 (level, low) -> IRQ 19
sata_promise 0000:02:01.0: PATA port found
scsi4 : sata_promise
scsi5 : sata_promise
scsi6 : sata_promise
ata5: SATA max UDMA/133 cmd 0xf8812200 ctl 0xf8812238 bmdma 0x00000000 irq 0
ata6: SATA max UDMA/133 cmd 0xf8812280 ctl 0xf88122b8 bmdma 0x00000000 irq 0
ata7: PATA max UDMA/133 cmd 0xf8812300 ctl 0xf8812338 bmdma 0x00000000 irq 0
ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata5.00: ata_hpa_resize 1: sectors = 156301488, hpa_sectors = 156301488
ata5.00: ATA-7: SAMSUNG HD080HJ, WT100-41, max UDMA7
ata5.00: 156301488 sectors, multi 0: LBA48 NCQ (depth 0/32)
ata5.00: qc timeout (cmd 0xef)
ata5.00: failed to set xfermode (err_mask=0x4)
ata5: failed to recover some devices, retrying in 5 secs
ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata5.00: ata_hpa_resize 1: sectors = 156301488, hpa_sectors = 156301488
ata5.00: qc timeout (cmd 0xef)
ata5.00: failed to set xfermode (err_mask=0x4)
ata5.00: limiting speed to UDMA/133:PIO3
ata5: failed to recover some devices, retrying in 5 secs
ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata5.00: ata_hpa_resize 1: sectors = 156301488, hpa_sectors = 156301488
ata5.00: qc timeout (cmd 0xef)
ata5.00: failed to set xfermode (err_mask=0x4)
ata5.00: disabled

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E

