Return-Path: <linux-kernel-owner+w=401wt.eu-S1765976AbXHXXub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765976AbXHXXub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 19:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756727AbXHXXuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 19:50:19 -0400
Received: from canuck.infradead.org ([209.217.80.40]:36968 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbXHXXuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 19:50:17 -0400
Date: Fri, 24 Aug 2007 16:44:43 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Martin Michlmayr <tbm@cyrius.com>
Subject: Re: [PATCH][resend] fix IDE legacy mode resources
Message-ID: <20070824234443.GA19595@kroah.com>
References: <20070824115559.06250ec0.yoichi_yuasa@tripeaks.co.jp> <20070824161442.GB15305@kroah.com> <20070824173713.2bc20bac@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070824173713.2bc20bac@the-village.bc.nu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 05:37:13PM +0100, Alan Cox wrote:
> >>     PCI: Unable to reserve I/O region #1:8@f00001f0 for device 0000:00:09.1
> > > 
> > > In some architectures, PCI bus regions have the offset from PCI resources.
> > > For this reason, pci_setup_device() should set PCI bus regions to dev->resource[]. 
> > 
> > I thought this patch was rejected in the past as it broke other
> > machines.
> 
> News to me.
> 
> Ths one looks sane and is different to the one Andrew has been fiddling
> with to stop broken X servers from crashing.

Ok, I confused it with that one, sorry.  But as this is in the same
area, some one needs to sort it all out :(

thanks,

greg k-h
