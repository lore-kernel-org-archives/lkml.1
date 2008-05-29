Return-Path: <linux-kernel-owner+w=401wt.eu-S1754912AbYE2C3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbYE2C3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 22:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187AbYE2C3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 22:29:06 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54607 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbYE2C3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 22:29:05 -0400
Date: Wed, 28 May 2008 19:26:32 -0700
From: Greg KH <greg@kroah.com>
To: Dave Jones <davej@redhat.com>, "Luck, Tony" <tony.luck@intel.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       David Woodhouse <dwmw2@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2008-discuss] Fixing the Kernel Janitors project
Message-ID: <20080529022632.GB5180@kroah.com>
References: <20080528225136.GA29014@kroah.com> <1FE6DD409037234FAB833C420AA843EC016FFF69@orsmsx424.amr.corp.intel.com> <20080529003657.GA17505@kroah.com> <20080529010055.GA31952@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529010055.GA31952@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2008 at 09:00:55PM -0400, Dave Jones wrote:
> On Wed, May 28, 2008 at 05:36:57PM -0700, Greg Kroah-Hartman wrote:
>  > On Wed, May 28, 2008 at 04:23:52PM -0700, Luck, Tony wrote:
>  > > > My raw numbers show that the number of individual kernel contributors
>  > > > continues to increase with every release, so this might not be as much
>  > > > of a problem as it's made out to be.
>  > > 
>  > > That depends on whether we are gradually adding to the pool
>  > > of developers, or seeing an increasing stream of newcomers
>  > > who supply a patch or two before disappearing again.
>  > > 
>  > > If you look at the list of contributors some old release for
>  > > which we have good data (say 2.6.16).  How many of those people
>  > > contributed to each of the following releases? Does the
>  > > decay curve look steeper or more gentle if you start from
>  > > a more recent release?
>  > 
>  > I don't know, I haven't tracked the people individually that way, only
>  > looked at the basic numbers of developers per release.
> 
> Are you just doing something like
>  git log v2.6.16..v2.6.17 | grep ^Author: | sort -u| wc -l  

Ah, if it were only so easy :)

> or do you have some script that maps addresses to people ?
> One person may appear once in 2.6.20, and then a half dozen times
> in 2.6.21 if they use multiple email addresses for example.
> (Also, typos, and people using full hostnames in their sign-off's
>  instead of email addresses skew this somewhat).
> 
> I'm guessing the latter, due to the graph thing you did. Pointers?

Yes, it's the later.  Jon Corbet has a great little python tool that we
have used to create the "who is writing the kernel" series of articles.
I've been using it to keep track of who maps to what email address and
for what company for a while now.

An older version can be found at:
	http://www.kernel.org/pub/linux/kernel/people/gregkh/kernel_history/
it's the 'gitdm' tool there.  I don't know if he has an updated version
around anywhere, I suppose as it looks like I'm doing the releases for
it, I can put up a new snapshot if people are really interested.

I also have "cleaned up" versions of the kernel log files for just the
reason you say above.  You would not believe the number of times some
people mispell their own name in a single kernel release...  That makes
it easier to do this kind of mapping.  The cleaned up logs are in that
directory as well.

thanks,

greg k-h
