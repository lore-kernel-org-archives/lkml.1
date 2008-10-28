Return-Path: <linux-kernel-owner+w=401wt.eu-S1753454AbYJ1SUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbYJ1SUt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 14:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633AbYJ1SUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 14:20:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:44386 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502AbYJ1SUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 14:20:38 -0400
Date: Tue, 28 Oct 2008 11:14:02 -0700
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Shawn Bohrer <shawn.bohrer@gmail.com>, David Schleef <ds@schleef.org>,
       Frank Mori Hess <fmhess@users.sourceforge.net>,
       Ian Abbott <abbotti@mev.co.uk>, linux-kernel@vger.kernel.org,
       Wolfgang Beiter <w.beiter@aon.at>,
       Guenter Gebhardt <g.gebhardt@meilhaus.de>
Subject: Re: staging: me4000 and relation to other data acquisition devices
Message-ID: <20081028181402.GB4873@suse.de>
References: <20081028154918.GA5630@mediacenter> <20081028163456.GA4278@suse.de> <20081028103337.a021e85d.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081028103337.a021e85d.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 10:33:37AM -0700, Randy Dunlap wrote:
> On Tue, 28 Oct 2008 09:34:56 -0700 Greg KH wrote:
> 
> > On Tue, Oct 28, 2008 at 10:49:18AM -0500, Shawn Bohrer wrote:
> > > I have some questions about the user-kernel interface of the me4000
> > > driver.  From my looking through the code it seems specific to the
> > > me4000 hardware which does concern me since there are hundreds of
> > > different data acquisition devices from many different vendors.  In my
> > > opinion it would beneficial if at the very least all of these devices
> > > shared a common device interface.
> > 
> > I totally agree.
> > 
> > The me4000's user interface is not "set in stone" and needs to be fixed
> > up in order to move into the main kernel tree.
> > 
> > > Additionally there is the out of tree Comedi project:
> > > 
> > > http://comedi.org
> > > 
> > > Which supports this hardware, and many more, with a generic device
> > > interface.  There may be other reason not to merge Comedi (I know they
> > > have a desire to maintain support of their RT support), but I can't help
> > > but feel that merging the me4000 driver without thinking about the
> > > hundreds of other devices out there is a mistake.
> > 
> > I would love to get comedi into the kernel tree.  People have talked
> > about it for years now, is it time for me to just take a snapshot and
> > place it in drivers/staging/ for everyone to then work on cleaning up
> > properly?
> 
> Greg,
> 
> Maybe I missed it at the beginning of the staging tree, but would you
> explain which drivers you will or will not put into the staging tree?
> 
> E.g., what if someone doesn't want their driver merged into mainline?

Of course, if someone doesn't want their code in the staging tree, I
will not add it, that's just being "nice".

As for what I will not put into staging, right now I'm sticking with
drivers only, no filesystems (people have asked already).  I don't think
we have seen any drivers that I will not put into the staging tree yet.

thanks,

greg k-h
