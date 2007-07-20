Return-Path: <linux-kernel-owner+w=401wt.eu-S935251AbXGTINa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935251AbXGTINa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 04:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764260AbXGTINN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 04:13:13 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57399 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763646AbXGTINL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 04:13:11 -0400
Date: Fri, 20 Jul 2007 01:09:36 -0700
From: Greg KH <greg@kroah.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Rob Landley <rob@landley.net>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, Michael-Luke Jones <mlj28@cam.ac.uk>,
       Krzysztof Halasa <khc@pm.waw.pl>, Rod Whitby <rod@whitby.id.au>,
       Russell King <rmk@arm.linux.org.uk>, david@lang.hm
Subject: Re: Documentation for sysfs, hotplug, and firmware loading.
Message-ID: <20070720080936.GA22047@kroah.com>
References: <200707171703.31340.rob@landley.net> <200707181339.54192.rob@landley.net> <3ae72650707181633w244904a6l2cee81d307b7dda1@mail.gmail.com> <200707200114.28654.rob@landley.net> <20070720070001.GC25620@kroah.com> <20070720095401.68e9ce03@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070720095401.68e9ce03@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 09:54:01AM +0200, Cornelia Huck wrote:
> On Fri, 20 Jul 2007 00:00:01 -0700,
> Greg KH <greg@kroah.com> wrote:
> 
> > > I don't insist on it, mknod insists on it.  You cannot mknod a dev node 
> > > without specifying block or char.
> > > 
> > > You're saying that sysfs should provide major and minor numbers without 
> > > anywhere specifying "char" or "block", meaning the major and minor numbers 
> > > cannot be _used_.  I am insisting on getting the third piece of information 
> > > without which "major" and "minor" are useless.
> > > 
> > > I asked very specifically about this at OLS, several times.  What you're 
> > > telling me now seems to contradict what you told me then.
> > 
> > Here's the rule:
> > 	If the SUBSYSTEM is "block", it's a block device.  Otherwise
> > 	it's a char device.
> 
> That's actually quite confusing to the casual reader, since:
> 
> > But also realize that the majority of events you will get have nothing
> > to do with device nodes.  I think you are forgetting this fact.
> 
> So the rule should be:
> 	If the SUBSYSTEM is "block" (implying major/minor are provided),
> 	it's a block device.
> 	If the SUBSYSTEM is not "block", and major/minor are provided,
> 	it's a char device.
> 	If major/minor are not provided, the event/device is not
> 	relevant to device node creation.

Yes, that is much more descriptive, thanks.

greg k-h
