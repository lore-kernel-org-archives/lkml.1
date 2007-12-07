Return-Path: <linux-kernel-owner+w=401wt.eu-S1753199AbXLGCNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbXLGCNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 21:13:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754404AbXLGCMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 21:12:54 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:35775 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754393AbXLGCMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 21:12:53 -0500
Message-ID: <4758AC23.2080107@garzik.org>
Date: Thu, 06 Dec 2007 21:12:51 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Tom Lanyon <tomlanyon@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Failure with SATA DVD-RW
References: <cd32a0620712041608o7733db74xf4975dec44925730@mail.gmail.com>
In-Reply-To: <cd32a0620712041608o7733db74xf4975dec44925730@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tom Lanyon wrote:
> Hi list,
> 
> Just built a new machine with a Pioneer SATA DVD drive and linux
> distro install CDs are not recognising it. The drive is connected to
> the ICH9R southbridge of an Intel P35 chipset motherboard.
> 
> I can boot from the CD/DVD so the drive itself is working, but the
> kernel reports the following:
> 
> scsi4: ahci
> ata5: SATA link up at 1.5 Gbps (SStatus 113 SControl 300)
> ata5.00: ATAPI, max UDMA/66
> ata5.00: qc timeout (cmd 0xef)
> ata5.00: failed to set xfermode (err_mask=0x104)
> ata5.00: limiting speed to UDMA/44
> ata5: failed to recover some devices, retrying in 5 secs
> ata5: port is slow to respond, please be patient (Status 0x80)
> ata5: port failed to respond (30 secs, status 0x80)
> ata5: COMRESET failed (device not ready)
> ata5: hardreset failed, retrying in 5 secs
> ata5: SATA link up at 1.5 Gbps (SStatus 113 SControl 300)
> ata5.00: ATAPI, max UDMA/66
> ata5.00: qc timeout (cmd 0xef)
> ata5.00: failed to set xfermode (err_mask=0x104)
> ata5.00: limiting speed to PIO0
> ata5: failed to recover some devices, retrying in 5 secs
> ata5: port is slow to respond, please be patient (Status 0x80)
> ata5: port failed to respond (30 secs, status 0x80)
> ata5: COMRESET failed (device not ready)
> ata5: hardreset failed, retrying in 5 secs
> ata5.00: ATAPI, max UDMA/66
> ata5.00: qc timeout (cmd 0xef)
> ata5.00: failed to set xfermode (err_mask=0x104)
> ata5.00: disabled
> 
> This is 2.6.19 (probably with a few distribution patches) on an
> install CD. I also tried setting the SATA controller to a 'compatible
> IDE' mode and the hard drives and DVD drive are detected and work
> properly.
> 
> Any ideas what to try to get it working under AHCI?

How does a remotely recent kernel behave?  :)

There have been a metric ton^2 of fixes in this specific area, in the 12 
months since 2.6.19 came out.

	Jeff


