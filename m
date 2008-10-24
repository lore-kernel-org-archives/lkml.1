Return-Path: <linux-kernel-owner+w=401wt.eu-S1757821AbYJXSBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821AbYJXSBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 14:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751801AbYJXSA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 14:00:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47240 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357AbYJXSA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 14:00:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Maciej Rutecki" <maciej.rutecki@gmail.com>
Subject: Re: [Re: Linux 2.6.28-rc1] scsi 4:0:0:0: timing out command, waited 22s
Date: Fri, 24 Oct 2008 20:05:25 +0200
User-Agent: KMail/1.9.9
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org,
       "SCSI development list" <linux-scsi@vger.kernel.org>
References: <8db1092f0810241057j51f0b70eo3cea4499422f0d38@mail.gmail.com>
In-Reply-To: <8db1092f0810241057j51f0b70eo3cea4499422f0d38@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810242005.26328.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 24 of October 2008, Maciej Rutecki wrote:
> During boot I have this message:
> 
> ata_piix 0000:00:1f.1: version 2.12
> ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> ata_piix 0000:00:1f.1: setting latency timer to 64
> scsi4 : ata_piix
> scsi5 : ata_piix
> ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x60a0 irq 14
> ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x60a8 irq 15
> ata5.00: ATAPI: MATSHITADVD-RAM UJ-840S, 1.11, max MWDMA2
> ata5.00: configured for MWDMA2
> ata6: port disabled. ignoring.
> scsi 4:0:0:0: timing out command, waited 22s
> scsi 4:0:0:0: timing out command, waited 22s
> scsi 4:0:0:0: timing out command, waited 22s
> scsi 4:0:0:0: timing out command, waited 22s
> scsi 4:0:0:0: timing out command, waited 22s
> scsi 4:0:0:0: timing out command, waited 22s
> 	ata5: WARNING: synchronous SCSI scan failed without making any progress,
>                   switching to async
> 
> DVD drive doesn't work. Under 2.6.27 (stable and -rc) works OK.
> 
> Dmesg ang config:
> http://unixy.pl/maciek/download/kernel/2.6.28-rc1/

Fixed in the Linus' tree:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e013e13bf605b9e6b702adffbe2853cfc60e7806

Thanks,
Rafael
