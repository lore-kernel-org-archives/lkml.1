Return-Path: <linux-kernel-owner+w=401wt.eu-S1753161AbZEIHfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbZEIHfj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 03:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbZEIHfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 03:35:08 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33801 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848AbZEIHfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 03:35:07 -0400
Message-ID: <4A053229.5010406@garzik.org>
Date: Sat, 09 May 2009 03:35:05 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: v.virvilis@biovista.com
CC: linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: SATA disks resets in a md setup
References: <200905081739.46206.v.virvilis@biovista.com>
In-Reply-To: <200905081739.46206.v.virvilis@biovista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vassilis Virvilis wrote:
> [ 9351.377961] ata2: SError: { PHYRdyChg PHYInt 10B8B Dispar }
> [ 9351.377983] ata2.00: cmd b0/d5:01:09:4f:c2/00:00:00:00:00/00 tag 0 pio 512 in
> [ 9351.377985]          res 50/00:00:b6:46:6a/00:00:13:00:00/e0 Emask 0x10 (ATA bus error)
[...]
> [10665.354196] ata2: SError: { UnrecovData Handshk }
> [10665.354196] ata2.00: cmd 35/00:00:27:ae:7a/00:04:01:00:00/e0 tag 0 dma 524288 out
> [10665.354196]          res 50/00:00:26:ae:7a/00:00:01:00:00/e0 Emask 0x10 (ATA bus error)
[...]
> and my filesystem is dead. /dev/sdb is deleted from /dev. I have to reboot and even then linux can't find the ata2 /dev/sdb.
> I have to remove power for 1-2 min for the disk to become accessible again.
> 
> Do you think the disk is bad or something?


For hardware details, see 
http://ata.wiki.kernel.org/index.php/Libata_error_messages

The ATA bus is the cable connection, so an ATA bus error typically means

- problem with your cable, or
- your motherboard's SATA port, or
- your drive's SATA port, or
- "dirty power" supply, or
- some other cause for cable interference

Regards,

	Jeff



