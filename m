Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066AbXFGGXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbXFGGXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 02:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbXFGGXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 02:23:00 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:6637 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbXFGGW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 02:22:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CFY/3oJ7NNAR3JoB203kWcKsaRgxojmtuhfQXzdS9cbEEuFRFbIlsuRg8PpTtITYwocC3zfHbn0PXMP4zmGSoMjFN/UBtVPlvTAFXIKNcMZpyUZbz3u0v2fkl7jSY2K7lXFzewQTNO9tX5ntzOnjPwfJ1SaU/DgDt2IeOgTLYhA=
Message-ID: <9d2cd630706062322v2d73b32dp1da56f97e2069fff@mail.gmail.com>
Date: Thu, 7 Jun 2007 08:22:57 +0200
From: "Gregor Jasny" <gjasny@googlemail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: [PATCH] Re: Linux v2.6.22-rc3
Cc: "Jeff Garzik" <jeff@garzik.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <46667466.4010500@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.98.0705252008210.26602@woody.linux-foundation.org>
	 <9d2cd630705270801m2826be60p3f802c502b26c531@mail.gmail.com>
	 <466196AD.3090502@garzik.org>
	 <9d2cd630706031046n2bd77585o7c0df1c5fea5167f@mail.gmail.com>
	 <46667466.4010500@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/6/6, Tejun Heo <htejun@gmail.com>:
> Let's see where we're failing.

[  186.849280] ata_piix 0000:00:07.1: version 2.11
[  186.849665] scsi0 : ata_piix
[  186.850241] scsi1 : ata_piix
[  186.850596] ata1: PATA max UDMA/33 cmd 0x000101f0 ctl 0x000103f6
bmdma 0x00010860 irq 14
[  186.851203] ata2: PATA max UDMA/33 cmd 0x00010170 ctl 0x00010376
bmdma 0x00010868 irq 15
[    0.656666] Marking TSC unstable due to: possible TSC halt in C2.
[    0.659999] Time: acpi_pm clocksource has been installed.
[    0.659999] Switched to NOHz mode on CPU #0
[    0.659999] ata1: ata_bus_post_reset: EXIT3
[    0.709999] ata1.00: ata_hpa_resize 1: sectors = 78242976,
hpa_sectors = 78242976
[    0.723333] ata1.00: ATA-7: SAMSUNG MP0402H, UC100-14, max UDMA/100
[    0.739999] ata1.00: 78242976 sectors, multi 8: LBA48
[    0.763333] ata1.00: ata_hpa_resize 1: sectors = 78242976,
hpa_sectors = 78242976
[    0.776666] ata1.00: configured for UDMA/33
[    1.376666] Clocksource tsc unstable (delta = -498091579 ns)
[   10.799998] ata2: ata_bus_post_reset: EXIT1
[   10.813332] ata2: SRST failed (errno=-16)
[   20.836664] ata2: ata_bus_post_reset: EXIT1
[   20.849997] ata2: SRST failed (errno=-16)
[   55.869994] ata2: ata_bus_post_reset: EXIT1
[   55.883327] ata2: SRST failed (errno=-16)
[   60.903327] ata2: ata_bus_post_reset: EXIT1
[   60.916660] ata2: SRST failed (errno=-16)
[   60.929993] ata2: reset failed, giving up
[   60.946660] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG
MP0402H  UC10 PQ: 0 ANSI: 5

Thanks,
Gregor
