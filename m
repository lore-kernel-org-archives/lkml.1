Return-Path: <linux-kernel-owner+w=401wt.eu-S1751998AbXA3XGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbXA3XGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 18:06:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbXA3XGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 18:06:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37019 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbXA3XGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 18:06:09 -0500
Date: Tue, 30 Jan 2007 15:05:10 -0800
From: Greg KH <greg@kroah.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
Message-ID: <20070130230510.GA20039@kroah.com>
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com> <20070130191020.GF20642@kroah.com> <adaodogqpmx.fsf@cisco.com> <20070130195445.GE22022@kroah.com> <adazm80p4qp.fsf@cisco.com> <45BFC7F2.7090209@garzik.org> <adaac00p1rq.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adaac00p1rq.fsf@cisco.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 02:50:49PM -0800, Roland Dreier wrote:
>  > Which of these actively maintained and supported drivers work on only
>  > one platform[1], and are excluded from enterprise distros?  Can we
>  > truly count them as "many", as you repeatedly claim?
> 
> Why do we restrict this to actively maintained and supported drivers
> (I think abandonware drivers are highly relevant here...)?  And why
> are you asking about drivers that work on only one platform?  Greg
> promised support for every platform that has the right bus to plug a
> device into.  So things like drivers that don't work on SMP or 64-bit
> or big-endian platforms also violate that pledge, even if there's more
> than one 32-bit little-endian uniprocessor platform where the driver
> does work.

For almost all _new_ drivers, this is the case.  They are well supported
and build on all platforms.

Yes, there are plenty of old drivers that are marked BROKEN (look at the
scsi tree for some examples there), and some that still use cli (which
the kernel janitors keep trying to fix up but the very fact that no one
has the hardware to test their changes keeps that effort from going
anywhere.)  But that is not the case for new stuff, nor is it the case
for things I am offing here.

> I don't really understand why it's so hard to accept that sometimes
> even open specs aren't enough to get great Linux support.

Yeah, sometimes you really need someone who has the device in a machine
that still boots :)

thanks,

greg k-h
