Return-Path: <linux-kernel-owner+w=401wt.eu-S1756532AbYJIVLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532AbYJIVLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 17:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754165AbYJIVLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 17:11:43 -0400
Received: from ns.suse.de ([195.135.220.2]:37601 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397AbYJIVLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 17:11:42 -0400
Date: Thu, 9 Oct 2008 14:08:29 -0700
From: Greg KH <gregkh@suse.de>
To: Adrian Bunk <bunk@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>, Jeff Mahoney <jeffm@suse.de>
Subject: Re: [patch 00/04] RFC: Staging tree (drivers/staging)
Message-ID: <20081009210829.GA5674@suse.de>
References: <20080924230054.GA27730@suse.de> <20081009210137.GA7126@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081009210137.GA7126@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 12:01:37AM +0300, Adrian Bunk wrote:
> On Wed, Sep 24, 2008 at 04:00:54PM -0700, Greg KH wrote:
> > As we all discussed at the Kernel Summit this past week, I said I would
> > create a drivers/staging directory and start throwing lots of drivers
> > that are not of "mergable" status into it.
> >...
> > The 3rd patch creates the drivers/staging/ directory and Kconfig entries
> > and adds it to the build system.
> > 
> > The 4th patch is an example of a driver that would go into this
> > directory, along with a driver_name.README file detailing what needs to
> > be done to this driver for cleanup/fixing, and who to contact about it.
> > It's also in such bad shape it doesn't even build against the kernel
> > kernel :)
> > 
> > (I'll fix that up before submitting, all drivers should at least build
> > properly...)
> > 
> > So, does this all look good to everyone?  Any questions/issues?
> > 
> > Oh, I guess I should add a MAINTAINER entry for this section of the
> > kernel, so to paraphrase Linus, I now get to be known as the "Maintainer
> > of Crap".
> 
> Sorry for being late in the discussion, I'm currently catching up with 
> my email backlog.
> 
> What does that mean in practice for kernel development?

Nothing.

> Will breaking crap be considered OK?

Yes.

> As an example, let's assume some crap drivers use the BKL in a way that 
> it might require the BKL in some core part of the kernel. Will the 
> person removing the BKL in the core part of the kernel be forced to fix 
> the locking of all possibly affected crap drivers no matter how broken 
> and undocumented it is, or can he simply ignore the crap and leave the 
> fixing to the Maintainer of Crap?

He can ignore the crap and leave the fixing to the Maintainer of Crap.

Although a short note to the Maintainer of Crap about the crap that
needs fixing in the tree of crap, would be polite, it is not required.

thanks,

greg "surrounded by crap" k-h
