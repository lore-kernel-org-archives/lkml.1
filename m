Return-Path: <linux-kernel-owner+w=401wt.eu-S1759129AbYFJXHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759129AbYFJXHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 19:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755685AbYFJXGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 19:06:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48920 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923AbYFJXGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 19:06:47 -0400
Date: Tue, 10 Jun 2008 16:05:22 -0700
From: Greg KH <greg@kroah.com>
To: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [ANNOUNCE] linux-staging tree created
Message-ID: <20080610230522.GA25100@kroah.com>
References: <20080610190540.GA25066@kroah.com> <20080610225222.GG8397@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080610225222.GG8397@mit.edu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 06:52:22PM -0400, Theodore Tso wrote:
> On Tue, Jun 10, 2008 at 12:05:40PM -0700, Greg KH wrote:
> > PURPOSE
> > 
> > The linux-staging tree was created to hold drivers and filesystems and
> > other semi-major additions to the Linux kernel that are not ready to be
> > merged at this point in time.  It is here for companies and authors to
> > get a wider range of testing, and to allow for other members of the
> > community to help with the development of these features for the
> > eventual inclusion into the main kernel tree.
> > 
> > This tree will be included in the daily linux-next builds, and will get
> > testing by all users of that tree.
> 
> Does this mean that the nature of linux-next is changing?  I thought
> the whole point of linux-next was only to have what would be pushed to
> Linus in the near future, so we could check for patch compatibility
> issues.  For that reason, for example, I don't push the unstable set
> of patches in the ext4 tree to linux-next, since they aren't ready for
> merging yet in their current form.  
> 
> But if linux-staging is going to be pushed to linux-next, doesn't that
> violate the ground rules of Linux-next?  Or are we allowing in this
> case because these are filesystems and/or device drivers that don't
> exist at all in the mainline tree yet?

I'm asking for the rule to be bent for this tree, not that the whole
nature of linux-next is changing.

-staging is for only whole new drivers/filesystems, not changes/features
to existing code that is not yet ready for merging.  The main reason
these drivers are not in mainline is usually:
	- coding style issues
	- sparse cleanups needed
	- ioctl 32/64 cleanups
	- locking review
	- direct access to hardware through memory pointers (only works
	  on x86)

If you look at what I currently have, there's nothing earth-shattering
there, but there is stuff that users can use to get hardware to work
that currently is not supported on kernel.org kernels at all.

It would be nice if distros also pick it up if they want to support
these devices and give me some feedback.  There are 2 big network
drivers in there that support a wide range of devices that some people
would like to see working :)

thanks,

greg k-h
