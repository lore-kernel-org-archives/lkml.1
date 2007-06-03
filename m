Return-Path: <linux-kernel-owner+w=401wt.eu-S1752093AbXFCOX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbXFCOX1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 10:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbXFCOXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 10:23:20 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:37813 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbXFCOXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 10:23:19 -0400
Message-ID: <4662CED4.1000506@garzik.org>
Date: Sun, 03 Jun 2007 10:23:16 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Linux 2.6.21.3] CDRW drive not recognised by PATA (ata_piix)
References: <336034.8278.qm@web52901.mail.re2.yahoo.com>
In-Reply-To: <336034.8278.qm@web52901.mail.re2.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Rankin wrote:
> Hi,
> 
> I have tried replacing the old IDE layer on my dual P4 machine with the PATA driver instead, but
> the CDRW drive on the second IDE bus (the old /dev/hdd drive) is never recognised:
> 
> ata1: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001ffa0 irq 14
> ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001ffa8 irq 15
> scsi0 : ata_piix
> ata1.00: ATA-6: IC35L090AVV207-0, V23OA66A, max UDMA/100
> ata1.00: 156250000 sectors, multi 8: LBA48 
> ata1.00: configured for UDMA/100
> scsi1 : ata_piix
> ata2.00: ATAPI, max UDMA/33
> ata2.01: ATAPI, max UDMA/33
> ata2.00: configured for UDMA/33
> ata2.01: qc timeout (cmd 0xef)
> ata2.01: failed to set xfermode (err_mask=0x4)

Grab the 'always use polling SETXFER' patch...

	Jeff



