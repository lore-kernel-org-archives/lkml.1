Return-Path: <linux-kernel-owner+w=401wt.eu-S1755716AbYJ3AOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716AbYJ3AOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 20:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751108AbYJ3AOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 20:14:00 -0400
Received: from ns.suse.de ([195.135.220.2]:53772 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbYJ3AN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 20:13:59 -0400
Date: Wed, 29 Oct 2008 17:02:10 -0700
From: Greg KH <gregkh@suse.de>
To: Wolfgang Beiter <w.beiter@aon.at>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Shawn Bohrer <shawn.bohrer@gmail.com>,
       David Schleef <ds@schleef.org>,
       Frank Mori Hess <fmhess@users.sourceforge.net>,
       Ian Abbott <abbotti@mev.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: staging: me4000 and relation to other data acquisition devices
Message-ID: <20081030000210.GA23359@suse.de>
References: <20081028154918.GA5630@mediacenter> <20081028163456.GA4278@suse.de> <20081028103337.a021e85d.rdunlap@xenotime.net> <20081028181402.GB4873@suse.de> <20081029151202.GB2190@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029151202.GB2190@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 04:12:02PM +0100, Wolfgang Beiter wrote:
> On  [28.10.2008 11:14], Greg KH wrote:
> > On Tue, Oct 28, 2008 at 10:33:37AM -0700, Randy Dunlap wrote:
> > > On Tue, 28 Oct 2008 09:34:56 -0700 Greg KH wrote:
> > > 
> > > > On Tue, Oct 28, 2008 at 10:49:18AM -0500, Shawn Bohrer wrote:
> > > > > I have some questions about the user-kernel interface of the me4000
> > > > > driver.  From my looking through the code it seems specific to the
> > > > > me4000 hardware which does concern me since there are hundreds of
> > > > > different data acquisition devices from many different vendors.  In my
> > > > > opinion it would beneficial if at the very least all of these devices
> > > > > shared a common device interface.
> > > > 
> > > > I totally agree.
> > > > 
> > > > The me4000's user interface is not "set in stone" and needs to be fixed
> > > > up in order to move into the main kernel tree.
> > > > 
> > > > > Additionally there is the out of tree Comedi project:
> > > > > 
> > > > > http://comedi.org
> > > > > 
> > > > > Which supports this hardware, and many more, with a generic device
> > > > > interface.  There may be other reason not to merge Comedi (I know they
> > > > > have a desire to maintain support of their RT support), but I can't help
> > > > > but feel that merging the me4000 driver without thinking about the
> > > > > hundreds of other devices out there is a mistake.
> > > > 
> > > > I would love to get comedi into the kernel tree.  People have talked
> > > > about it for years now, is it time for me to just take a snapshot and
> > > > place it in drivers/staging/ for everyone to then work on cleaning up
> > > > properly?
> > > 
> > > Greg,
> > > 
> > > Maybe I missed it at the beginning of the staging tree, but would you
> > > explain which drivers you will or will not put into the staging tree?
> > > 
> > > E.g., what if someone doesn't want their driver merged into mainline?
> > 
> > Of course, if someone doesn't want their code in the staging tree, I
> > will not add it, that's just being "nice".
> > 
> > As for what I will not put into staging, right now I'm sticking with
> > drivers only, no filesystems (people have asked already).  I don't think
> > we have seen any drivers that I will not put into the staging tree yet.
> > 
> > thanks,
> > 
> > greg k-h
> 
> sorry for causing the disput since the inital point to this may
> belong to me.
> 
> At the beginning of this year, reading about the LDP (linux driver
> project), this encouraged me to write an e-mail to Mr. Kroah-Hartman,
> asking for me4000 driver support.
> 
> Pointing out that there are still mexxxx driver downloads on
> www.sourceforge.net, although the drivers are no more supported by the
> vendor and wont built with newer linux kernels, I felt it's a good idea.

Yes, it's fine, don't worry about it.

If we can add the comedi code, that would be even better overall, and
provide the common interface we really need for these kinds of devices
in Linux.

thanks,

greg k-h
