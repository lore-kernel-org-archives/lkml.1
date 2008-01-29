Return-Path: <linux-kernel-owner+w=401wt.eu-S1764690AbYA2RmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764690AbYA2RmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 12:42:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756300AbYA2RmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 12:42:06 -0500
Received: from bay0-omc3-s1.bay0.hotmail.com ([65.54.246.201]:21501 "EHLO
	bay0-omc3-s1.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755905AbYA2RmF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 12:42:05 -0500
Message-ID: <BAY101-W159C6F9F2C09199889AA3C8350@phx.gbl>
X-Originating-IP: [99.147.122.210]
From: Adam Turk <bofh1234@hotmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: Re: Problem with ata layer in 2.6.24
Date: Tue, 29 Jan 2008 12:42:04 -0500
Importance: Normal
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 29 Jan 2008 17:42:04.0516 (UTC) FILETIME=[42CD3A40:01C8629E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I just found this thread and it looks like it will fix my problem too.  I have an IDE cd-rw drive and 2 SCSI hard drives.  My ide cd-rw drive hasn't been showing up.  I looked at setting scsi cdrom support (CONFIG_BLOCK_DEV_SR) but it doesn't mention anything about ide drives using libata.
I know the drive is being detecting by looking at dmesg:
ata_piix 0000:00:07.1: version 2.12
scsi1 : ata_piix
scsi2 : ata_piix
ata1: PATA max UDMA/33 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
ata2: PATA max UDMA/33 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
ata1.00: ATAPI: Memorex 52MAXX 3252AJ1, 4WS2, max UDMA/33
ata1.00: configured for UDMA/33
ata2: port disabled. ignoring.
scsi 1:0:0:0: CD-ROM            Memorex  52MAXX 3252AJ1   4WS2 PQ: 0 ANSI: 5
if this works then it really needs to move and be renamed.  I am compiling with DEV_SR set.

Just my $0.02 but may be worth more or less,
Adam


_________________________________________________________________
Need to know the score, the latest news, or you need your Hotmail®-get your "fix".
http://www.msnmobilefix.com/Default.aspx