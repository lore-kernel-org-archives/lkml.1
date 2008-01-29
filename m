Return-Path: <linux-kernel-owner+w=401wt.eu-S1764929AbYA2R55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764929AbYA2R55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 12:57:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753521AbYA2R5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 12:57:49 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:61564 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875AbYA2R5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 12:57:48 -0500
Date: Tue, 29 Jan 2008 12:55:59 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Problem with ata layer in 2.6.24
In-reply-to: <BAY101-W159C6F9F2C09199889AA3C8350@phx.gbl>
To: Adam Turk <bofh1234@hotmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <200801291255.59375.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <BAY101-W159C6F9F2C09199889AA3C8350@phx.gbl>
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 January 2008, Adam Turk wrote:
>I just found this thread and it looks like it will fix my problem too.  I
> have an IDE cd-rw drive and 2 SCSI hard drives.  My ide cd-rw drive hasn't
> been showing up.  I looked at setting scsi cdrom support
> (CONFIG_BLOCK_DEV_SR) but it doesn't mention anything about ide drives
> using libata. I know the drive is being detecting by looking at dmesg:
>ata_piix 0000:00:07.1: version 2.12
>scsi1 : ata_piix
>scsi2 : ata_piix
>ata1: PATA max UDMA/33 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
>ata2: PATA max UDMA/33 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
>ata1.00: ATAPI: Memorex 52MAXX 3252AJ1, 4WS2, max UDMA/33
>ata1.00: configured for UDMA/33
>ata2: port disabled. ignoring.
>scsi 1:0:0:0: CD-ROM            Memorex  52MAXX 3252AJ1   4WS2 PQ: 0 ANSI: 5
>if this works then it really needs to move and be renamed.  I am compiling
> with DEV_SR set.
>
>Just my $0.02 but may be worth more or less,
>Adam
>
That fixed me right up, Adam, & k3b is once again as happy as a clam.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Main's Law:
	For every action there is an equal and opposite government program.
