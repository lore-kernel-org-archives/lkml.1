Return-Path: <linux-kernel-owner+w=401wt.eu-S934741AbYBBUsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934741AbYBBUsy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 15:48:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763286AbYBBUso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 15:48:44 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:60276 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760530AbYBBUsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 15:48:43 -0500
Message-ID: <47A4D71F.3060009@garzik.org>
Date: Sat, 02 Feb 2008 15:48:31 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net,
       linux-scsi <linux-scsi@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch] pci: pci_enable_device_bars() fix
References: <20080201231147.GA18174@suse.de> <20080202111322.GA30767@elte.hu> <47A49171.2000003@garzik.org> <20080202170828.GA12748@elte.hu> <47A4A96D.2040709@garzik.org> <20080202175738.GA26560@elte.hu> <47A4BB3C.6050709@garzik.org> <20080202193524.GC27927@elte.hu>
In-Reply-To: <20080202193524.GC27927@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> so please tell me Jeff. If Greg, who is the super-maintainer of your 
> code area, and who deals with your code every day and changes it every 
> minute and hour, simply did not Cc: the SCSI list - how am i, a largely 
> outside party in this matter, supposed to notice that 3 maintainers and 
> 3 mailing lists in the Cc: were somehow not enough and that i was 
> supposed to grow the already sizable Cc: list even more?

Because, regardless of the situation, it's both common courtesy and wise 
practice to CC relevant driver maintainers, when you touch a driver.

And it's just common sense:  Greg simply does not know the intimate 
details of every PCI driver.  Nor do I.  Nor you.

In the case of lpfc here, we have an active driver maintainer, and an 
up-to-date MAINTAINERS entry.  Even if you are too slack to read 
MAINTAINERS, 'git log' would have given you the same info.

Don't pretend there is some benefit here to ignoring the people that 
best know the driver.  I don't buy that; it simply makes no engineering 
sense whatsoever.

	Jeff


