Return-Path: <linux-kernel-owner+w=401wt.eu-S1756624AbXFCRrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624AbXFCRrJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 13:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbXFCRqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 13:46:55 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:55375 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbXFCRqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 13:46:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IL+ALyHWBH4wSHLk6C8Y5neuMUsnmiPA7ISLIYEzTjazUHDguHssnYbPLXEWYClvaFFofyWtOOEvTGaxqDkqvNOkqpr/yJEW2PlXnTBr3iwMvOBu1oRudL3xXewM0noa8Oo/1KmTGDSB/UkcfPww7gptGZrUYxNPwH7CGKWpmus=
Message-ID: <9d2cd630706031046n2bd77585o7c0df1c5fea5167f@mail.gmail.com>
Date: Sun, 3 Jun 2007 19:46:52 +0200
From: "Gregor Jasny" <gjasny@googlemail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [PATCH] Re: Linux v2.6.22-rc3
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <466196AD.3090502@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.98.0705252008210.26602@woody.linux-foundation.org>
	 <9d2cd630705270801m2826be60p3f802c502b26c531@mail.gmail.com>
	 <466196AD.3090502@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/6/2, Jeff Garzik <jeff@garzik.org>:
> Does this patch change the behavior at all?

No. It still times out. I've raised the first timeout to 60 seconds
but still no luck.

[   19.403632] ata_piix 0000:00:07.1: version 2.11
[   19.404013] scsi0 : ata_piix
[   19.404482] scsi1 : ata_piix
[   19.404836] ata1: PATA max UDMA/33 cmd 0x000101f0 ctl 0x000103f6
bmdma 0x00010860 irq 14
[   19.405443] ata2: PATA max UDMA/33 cmd 0x00010170 ctl 0x00010376
bmdma 0x00010868 irq 15
[    0.663333] Marking TSC unstable due to: possible TSC halt in C2.
[    0.666666] Time: acpi_pm clocksource has been installed.
[    0.666666] Switched to NOHz mode on CPU #0
[    0.716666] ata1.00: ata_hpa_resize 1: sectors = 78242976,
hpa_sectors = 78242976
[    0.716666] ata1.00: ATA-7: SAMSUNG MP0402H, UC100-14, max UDMA/100
[    0.733333] ata1.00: 78242976 sectors, multi 8: LBA48
[    0.753333] ata1.00: ata_hpa_resize 1: sectors = 78242976,
hpa_sectors = 78242976
[    0.766666] ata1.00: configured for UDMA/33
[    1.379999] Clocksource tsc unstable (delta = -498119555 ns)
[   10.793332] ata2: SRST failed (errno=-16)
[   20.813331] ata2: SRST failed (errno=-16)
[   55.833327] ata2: SRST failed (errno=-16)
[   60.853327] ata2: SRST failed (errno=-16)
[   60.866660] ata2: reset failed, giving up
[   60.879993] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG
MP0402H  UC10 PQ: 0 ANSI: 5

Cheers,
Gregor
