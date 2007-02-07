Return-Path: <linux-kernel-owner+w=401wt.eu-S965637AbXBGDXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965637AbXBGDXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 22:23:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030238AbXBGDXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 22:23:40 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:57974 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965620AbXBGDXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 22:23:40 -0500
Message-ID: <45C94639.9020509@garzik.org>
Date: Tue, 06 Feb 2007 22:23:37 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [QUESTION] ATA: abnormal status 0x80 on port 0xCC07
References: <6bffcb0e0702031044v601e4fc3icf859544af292789@mail.gmail.com>
In-Reply-To: <6bffcb0e0702031044v601e4fc3icf859544af292789@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski wrote:
> Hi Jeff,
> 
> What does this mean?
> 
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata1.00: cmd c8/00:08:67:40:68/00:00:00:00:00/e3 tag 0 cdb 0x0 data 4096 in
>         res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata1: soft resetting port
> ata1.00: configured for UDMA/133
> ata1: EH complete
> SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
> sda: Write Protect is off
> sda: Mode Sense: 00 3a 00 00
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata1.00: cmd c8/00:00:c3:52:43/00:00:00:00:00/ea tag 0 cdb 0x0 data 
> 131072 in
>         res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata1: soft resetting port
> ata1.00: configured for UDMA/133
> ata1: EH complete
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata1.00: cmd c8/00:00:c3:52:43/00:00:00:00:00/ea tag 0 cdb 0x0 data 
> 131072 in
>         res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata1: soft resetting port
> ata1.00: configured for UDMA/133
> ata1: EH complete
> SCSI device sda: write cache: enabled, read cache: enabled, doesn't 
> support DPO
> or FUA
> SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
> sda: Write Protect is off
> sda: Mode Sense: 00 3a 00 00
> SCSI device sda: write cache: enabled, read cache: enabled, doesn't 

timeouts usually mean that an interrupt was not delivered, when the 
driver was expecting one.

All the usual suspects apply: this could be a system hardware problem 
(check cables and PSU), heat problem, BIOS or ACPI problem, hard drive 
failure, or ATA driver problem.

	Jeff



