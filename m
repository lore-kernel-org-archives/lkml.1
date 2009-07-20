Return-Path: <linux-kernel-owner+w=401wt.eu-S1752852AbZGTRGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbZGTRGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 13:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbZGTRGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 13:06:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47609 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509AbZGTRGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 13:06:33 -0400
Date: Mon, 20 Jul 2009 10:03:45 -0700
From: Greg KH <gregkh@suse.de>
To: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, virtualization@lists.osdl.org,
       Hank Janssen <hjanssen@microsoft.com>,
       Haiyang Zhang <haiyangz@microsoft.com>,
       Sam Ramji <sramji@microsoft.com>, shemminger@linux-foundation.org
Subject: Re: [patch 00/54] [Announce] Microsoft Hyper-V drivers for Linux
Message-ID: <20090720170345.GA23990@suse.de>
References: <20090720160025.GA20249@kroah.com>
 <20090720162810.GA22102@kroah.com>
 <20090720165941.GA15660@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090720165941.GA15660@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 12:59:41PM -0400, Dave Jones wrote:
> On Mon, Jul 20, 2009 at 09:28:10AM -0700, Greg KH wrote:
>  > On Mon, Jul 20, 2009 at 09:00:25AM -0700, Greg Kroah-Hartman wrote:
>  > > 
>  > > Hi all,
>  > > 
>  > > I'm happy to announce, that after many months of discussions, Microsoft
>  > > has released their Hyper-V Linux drivers under the GPLv2.  Following
>  > > this message, will be the patches that add the drivers to the
>  > > drivers/staging/ tree, and a whole bunch of cleanups.
>  > 
>  > Hm, for some reason my scripts to send patches out caused them to get
>  > eaten by the very good lkml filters.  (note, it was my fault, not
>  > lkml's).
>  > 
>  > So instead of trying to send them again, and spaming everyone who
>  > already got them, you can find them in my staging tree at:
>  > 	http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-05-staging/
>  > 
>  > If anyone wants me to post any of the individual 54 patches to them,
>  > please let me know.
> 
> Given the numerous cleanup patches that already exist, is there any reason
> to not just post the cleaned up drivers ?  It would certainly be more
> reviewable than the current pile.
> 
> Come to think of it, is there any value in merging the pre-cleaned up
> patches ? Why merge 54 patches to mainline when a half dozen will do ?

It's the "normal" way of cleaning up code.  Start with a known-working
piece of stuff, and incrementally clean it up.  This way if I mess any
of the individual steps up, it's easy to find the problem.  This has
already paid off in the past week working with the Microsoft developers
to get this into a buildable / workable state.

The code still needs lots of cleanup, and review, as is evident by the
TODO file.  It looks like the patches did get sent to the driver-devel
and virtualization lists, so you can see them there if you want to.

But if you want, I can post the 4 individual drivers as of right now,
what they will show up in the linux-next tree tomorrow if you want me
to.

thanks,

greg k-h
