Return-Path: <linux-kernel-owner+w=401wt.eu-S934252AbXKPVCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934252AbXKPVCZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 16:02:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933526AbXKPVCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 16:02:05 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41616 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764930AbXKPVCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 16:02:03 -0500
Date: Fri, 16 Nov 2007 12:56:18 -0800
From: Greg KH <greg@kroah.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Driver core: fix race in __device_release_driver
Message-ID: <20071116205618.GA12133@kroah.com>
References: <Pine.LNX.4.44L0.0711161151340.3268-100000@iolanthe.rowland.org> <20071116203748.GA11770@kroah.com> <1195245955.2533.153.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1195245955.2533.153.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2007 at 03:45:55PM -0500, David Woodhouse wrote:
> On Fri, 2007-11-16 at 12:37 -0800, Greg KH wrote:
> > Is this something that you all feel is worth getting in for 2.6.24?
> > Does it fix a regression that just showed up, or is just a bugfix for
> > something that people finally realized has always been there?
> 
> The latter. We just happen to kick the wireless device in the head by
> toggling its out-of-band reset signal when we unload the driver, which
> causes us to trigger this "unlikely" race with almost 100% reliability.
> But it's always been there, AFAICT.
> 
> > Can it wait for 2.6.25 to get some more testing in -mm?
> 
> Yeah, I think so.

Thanks for letting me know, I'll add it to the proper place in my queue.

greg k-h
