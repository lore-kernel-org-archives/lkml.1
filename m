Return-Path: <linux-kernel-owner+w=401wt.eu-S1753391AbYJ0Tfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbYJ0Tfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 15:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbYJ0Tfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 15:35:36 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38092 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbYJ0Tff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 15:35:35 -0400
Message-ID: <49061803.4060707@garzik.org>
Date: Mon, 27 Oct 2008 15:35:31 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Harald Dunkel <harald.dunkel@t-online.de>
CC: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27.3, ata_piix: cannot play audio CD, "disk change detected"
References: <490615E9.7070607@t-online.de>
In-Reply-To: <490615E9.7070607@t-online.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harald Dunkel wrote:
> Hi folks,
> 
> If I insert an audio CD in my sata drive to play it via grip, then
> it fails. Grip does not even show the list of audio tracks, nor does
> it play the CD. Instead there is a kernel message saying
> 
> [ 6730.836999] sr0: CDROM not ready yet.
> [ 6732.838572] sr0: disc change detected.
> [ 6783.659021] ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
> [ 6783.659034] ata4.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
> [ 6783.659035]          cdb 1b 00 00 00 02 00 00 00  00 00 00 00 00 00 00 00
> [ 6783.659036]          res 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> [ 6783.659038] ata4.00: status: { DRDY }
> [ 6783.659046] ata4: hard resetting link
> [ 6784.115039] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [ 6785.622185] ata4.00: configured for UDMA/100
> [ 6785.622193] ata4: EH complete
> 
> 
> The same CDs work fine with an USB CD drive attached to the same
> PC, so this might be a sata driver issue. (BTW, stopping hal doesn't
> make a difference. Data CDs work fine.)
> 
> Any idea what goes wrong here? Does grip violate the SCSI protocol
> here?  Is there something I could try to help to track this down?

hmmmm, I used to see something similar on ICH7 but it went away.

Can you try various strategies associated with interrupts (trying to 
determine the cause of the timeouts), such as booting with "noapic", 
"acpi=off", and/or pci=biosirq.

	Jeff


