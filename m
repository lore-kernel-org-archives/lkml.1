Return-Path: <linux-kernel-owner+w=401wt.eu-S936226AbXG2VBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936226AbXG2VBh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 17:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763209AbXG2VBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 17:01:30 -0400
Received: from canuck.infradead.org ([209.217.80.40]:49435 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbXG2VB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 17:01:29 -0400
Date: Sun, 29 Jul 2007 14:01:07 -0700
From: Greg KH <greg@kroah.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] undefined reference to `kobject_actions'
Message-ID: <20070729210107.GA22492@kroah.com>
References: <20070729193401.GA18225@flint.arm.linux.org.uk> <20070729193704.GA27994@flint.arm.linux.org.uk> <1185739145.2469.0.camel@lov.localdomain> <20070729204110.GB18225@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070729204110.GB18225@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2007 at 09:41:10PM +0100, Russell King wrote:
> On Sun, Jul 29, 2007 at 09:59:05PM +0200, Kay Sievers wrote:
> > 
> > On Sun, 2007-07-29 at 20:37 +0100, Russell King wrote:
> > > On Sun, Jul 29, 2007 at 08:34:01PM +0100, Russell King wrote:
> > > > Many ARM platforms fail to build with the following:
> > > > 
> > > > drivers/built-in.o: In function `store_uevent':
> > > > hid-input.c:(.text+0x19c4c): undefined reference to `kobject_actions'
> > > > 
> > > > It appears that if hotplug is disabled, kobject_actions is ifdef'd
> > > > away but hid-input still references it.
> > > 
> > > What I also meant to say is that it looks like it's caused by
> > > commit 60a96a59569bab85571d0089682109bd3324e896.
> > > 
> > > Presumably if hotplug is disabled, we want store_uevent to be
> > > removed as well?
> > 
> > Does this patch fix it?
> >   http://lkml.org/lkml/2007/7/20/143
> 
> Yup, thanks.  Any idea when this fix will hit mainline?  Looks like
> it's 9 days old, and it fixes real build errors.

I've been at OSCON all last week, this will go to Linus on Monday.
Sorry for the delay, conference season sucks at times...

thanks,

greg k-h
