Return-Path: <linux-kernel-owner+w=401wt.eu-S1758009AbXI1ItO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009AbXI1ItO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 04:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbXI1Is7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 04:48:59 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:3458 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754485AbXI1Is7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 04:48:59 -0400
Date: Fri, 28 Sep 2007 10:48:41 +0200
From: Martin Michlmayr <tbm@cyrius.com>
To: Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH][resend] fix IDE legacy mode resources
Message-ID: <20070928084840.GA5542@derision.cyrius.com>
References: <20070824115559.06250ec0.yoichi_yuasa@tripeaks.co.jp> <20070824161442.GB15305@kroah.com> <20070824173713.2bc20bac@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070824173713.2bc20bac@the-village.bc.nu>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Alan Cox <alan@lxorguk.ukuu.org.uk> [2007-08-24 17:37]:
> >>     PCI: Unable to reserve I/O region #1:8@f00001f0 for device 0000:00:09.1
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

Can this patch be added now or does there have to be more discussion?
I need this patch for IDE and PATA to work on my MIPS Cobalt.
Yoichi's original patch and explanation can be found at
http://lkml.org/lkml/2007/8/23/411
-- 
Martin Michlmayr
http://www.cyrius.com/
