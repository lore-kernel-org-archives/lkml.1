Return-Path: <linux-kernel-owner+w=401wt.eu-S934830AbXFGUhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934830AbXFGUhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 16:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760755AbXFGUhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 16:37:06 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:33731 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758791AbXFGUhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 16:37:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TmoKo8hLivs0S0Liq996xknnwMiQAPK6QTXHB7yIYVNypKjLRffLek3FEvgQfFw4faA6xJrtdpUH4pIZCBOsluHcC9aQF2qfgind62JORCSMgZikJD2klUdlpqpb7rAH7U9Cktvnzb4JEorJTiJJMkXSkL3HDcCEqAQDlRnTITE=
Message-ID: <9d2cd630706071337j76cfb3c0h93b1150064b2ce59@mail.gmail.com>
Date: Thu, 7 Jun 2007 22:37:03 +0200
From: "Gregor Jasny" <gjasny@googlemail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: [PATCH] Re: Linux v2.6.22-rc3
Cc: "Jeff Garzik" <jeff@garzik.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <4667B347.9040900@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.98.0705252008210.26602@woody.linux-foundation.org>
	 <9d2cd630705270801m2826be60p3f802c502b26c531@mail.gmail.com>
	 <466196AD.3090502@garzik.org>
	 <9d2cd630706031046n2bd77585o7c0df1c5fea5167f@mail.gmail.com>
	 <46667466.4010500@gmail.com>
	 <9d2cd630706062322v2d73b32dp1da56f97e2069fff@mail.gmail.com>
	 <4667B347.9040900@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/6/7, Tejun Heo <htejun@gmail.com>:
> Ah.. okay.  Now I see what's going on.  Jeff, this is another device
> which doesn't set nsect and lbal to 1 after reset.  Gregor, please try
> the attached patch.

It works like a charm.

Thanks for debugging.

Gregor


[  307.605884] ata_piix 0000:00:07.1: version 2.11
[  307.606268] scsi0 : ata_piix
[  307.606728] scsi1 : ata_piix
[  307.607080] ata1: PATA max UDMA/33 cmd 0x000101f0 ctl 0x000103f6
bmdma 0x00010860 irq 14
[  307.607790] ata2: PATA max UDMA/33 cmd 0x00010170 ctl 0x00010376
bmdma 0x00010868 irq 15
[    0.656666] Marking TSC unstable due to: possible TSC halt in C2.
[    0.659999] Time: acpi_pm clocksource has been installed.
[    0.659999] Switched to NOHz mode on CPU #0
[    0.703333] ata1: ata_bus_post_reset: EXIT3
[    0.709999] ata1.00: ata_hpa_resize 1: sectors = 78242976,
hpa_sectors = 78242976
[    0.723333] ata1.00: ATA-7: SAMSUNG MP0402H, UC100-14, max UDMA/100
[    0.739999] ata1.00: 78242976 sectors, multi 8: LBA48
[    0.763333] ata1.00: ata_hpa_resize 1: sectors = 78242976,
hpa_sectors = 78242976
[    0.776666] ata1.00: configured for UDMA/33
[    0.799999] ata2: ata_bus_post_reset: EXIT3
[    0.973333] ata2.00: ATAPI, max UDMA/33
[    1.146666] ata2.00: configured for UDMA/33
[    1.159999] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG
MP0402H  UC10 PQ: 0 ANSI: 5
[...]
[    1.326666] scsi 1:0:0:0: CD-ROM            SAMSUNG  CD-ROM SN-124
  N102 PQ: 0
