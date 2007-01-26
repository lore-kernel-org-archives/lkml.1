Return-Path: <linux-kernel-owner+w=401wt.eu-S1751702AbXAZWU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702AbXAZWU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 17:20:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbXAZWU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 17:20:29 -0500
Received: from ns2.suse.de ([195.135.220.15]:59994 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701AbXAZWU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 17:20:28 -0500
Date: Fri, 26 Jan 2007 14:19:33 -0800
From: Greg KH <gregkh@suse.de>
To: David Brownell <david-b@pacbell.net>, akpm@osdl.org
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix /sys/device/.../power/state regression
Message-ID: <20070126221933.GA11008@suse.de>
References: <20061219185223.GA13256@srcf.ucam.org> <20070125050009.GA8672@srcf.ucam.org> <20070126204140.GA8407@suse.de> <200701261356.42171.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200701261356.42171.david-b@pacbell.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 26, 2007 at 01:56:41PM -0800, David Brownell wrote:
> > Or am I misstating that long thread?  David, your thoughts?
> 
> My recollection of that thread was that *NOBODY* claimed that a
> replacement of that (broken-by-design) mechanism would ever exist.
> 
> However, there was some interesting discussion of just how to fix
> the wireless adapters.  There appeared to be consensus that the
> right solution involved "ifdown wlan0" (or whatever) ought to power
> down that adapter, in the way Matthew wanted.
> 
> I thought the resolution was that fixing a few of those drivers
> should solve the problem Matthew needed resolved, and that in
> the meanwhile "rmmod drivername" should suffice.  There also seemed
> to be agreement that power management for wireless devices needed
> more work; there might need to be a state between "down/off" and
> "configured and able to talk IP".

Ok, that sounds like what I thought the thread resolved too.

Andrew, please drop this patch from your queue, and I'll make sure the
stable tree doesn't get it either.

thanks,

greg k-h
