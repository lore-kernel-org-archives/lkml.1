Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbYJ3AO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbYJ3AO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 20:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755070AbYJ3AOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 20:14:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:38467 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754883AbYJ3AOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 20:14:04 -0400
Date: Wed, 29 Oct 2008 17:04:23 -0700
From: Greg KH <gregkh@suse.de>
To: Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: David Schleef <ds@schleef.org>,
       Frank Mori Hess <fmhess@users.sourceforge.net>,
       Ian Abbott <abbotti@mev.co.uk>, linux-kernel@vger.kernel.org,
       Wolfgang Beiter <w.beiter@aon.at>
Subject: Re: staging: me4000 and relation to other data acquisition devices
Message-ID: <20081030000423.GB23359@suse.de>
References: <20081028154918.GA5630@mediacenter> <20081028163456.GA4278@suse.de> <20081029173719.GB5630@mediacenter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029173719.GB5630@mediacenter>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 12:37:19PM -0500, Shawn Bohrer wrote:
> On Tue, Oct 28, 2008 at 09:34:56AM -0700, Greg KH wrote:
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
> I think that is up to the Comedi maintainers.  If the Comedi maintainers
> do not want to head in that direction, I'm sure the me4000 driver
> currently in drivers/staging/ would benefit from their review.

Ok, David, Frank, Ian, what do you think?

I can take a snapshot of the development tree right now, put it into
drivers/staging/comedi/ and then work with you all, and the hundreds of
kernel developers to get the code into "mergable" shape to get it merged
into the main kernel tree.

By moving it into the staging tree now, you get the benifit of those
other developers helping out with this effort, and the benifit of the
code being added to all the distros and more users using it, and not
having to build and install their own versions.

I'll be glad to do this, and maintain it if need be.  Your codebase is
great, and it provides a much needed standard interface for this type of
device for Linux.

thanks,

greg k-h
