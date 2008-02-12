Return-Path: <linux-kernel-owner+w=401wt.eu-S1763626AbYBLStU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763626AbYBLStU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 13:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758944AbYBLStJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 13:49:09 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:42963 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755951AbYBLStG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 13:49:06 -0500
Message-ID: <47B1EA0E.7080602@garzik.org>
Date: Tue, 12 Feb 2008 13:48:46 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, arjan@infradead.org,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
References: <20080211203146.3d28d1a0@laptopd505.fenrus.org> <20080212044314.GA4888@kroah.com> <20080211211751.3e265754@laptopd505.fenrus.org> <20080211.221126.230471463.davem@davemloft.net> <47B1CB08.4020101@garzik.org> <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org> <20080212174824.GA1919@kroah.com>
In-Reply-To: <20080212174824.GA1919@kroah.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> A lot of time that already happens today, between the different
> subsystem maintainers.  We routinely pass PCI and driver core changes
> through the network and scsi and ata trees in order to handle merge
> issues properly.  This already happened in a few places in the
> 2.6.25-rc1 merge cycle.


Yep.  I do that with the powerpc tree sometimes, too:  I'll ACK a 
drivers/net change that is obviously PPC-specific, and that drivers/net 
change will go in via paulus.

Like you said, it's done on a per-patch not git tree basis at the moment.

That sort of cooperation has become common: in areas of shared 
responsibility, request an ack, and then the "most obvious" person 
(generally the one with most merge dependencies) merges that 
shared-responsibility change along with some other changes specific to 
their own tree.

	Jeff



