Return-Path: <linux-kernel-owner+w=401wt.eu-S1760480AbZFKPxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760480AbZFKPxI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 11:53:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757149AbZFKPxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 11:53:00 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56236 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654AbZFKPw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 11:52:59 -0400
Date: Thu, 11 Jun 2009 16:52:45 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: David Miller <davem@davemloft.net>, swetland@google.com,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       san@android.com, rlove@google.com
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090611155245.GA20460@n2100.arm.linux.org.uk>
References: <20090611111821.GK795@n2100.arm.linux.org.uk> <20090611.042226.28424489.davem@davemloft.net> <20090611114911.GL795@n2100.arm.linux.org.uk> <20090611.050030.169859977.davem@davemloft.net> <20090611123852.GM795@n2100.arm.linux.org.uk> <20090611132117.GH7523@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090611132117.GH7523@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 03:21:17PM +0200, Pavel Machek wrote:
> On Thu 2009-06-11 13:38:52, Russell King - ARM Linux wrote:
> > On Thu, Jun 11, 2009 at 05:00:30AM -0700, David Miller wrote:
> > > From: Russell King - ARM Linux <linux@arm.linux.org.uk>
> > > Date: Thu, 11 Jun 2009 12:49:12 +0100
> > > 
> > > > I can not keep up with the number of patches that need to be
> > > > reviewed and ultimately merged.  I know this, and I freely admit it,
> > > > and I have done so on many occasions.
> > > 
> > > Then split up the responsibilities to other people instead of being
> > > the choke point.  Controlling everything isn't so important.
> > 
> > Don't you think that I've been trying to get other people to be more
> > involved?
> > 
> > - I've been pushing people to send patches to the relevent mailing
> >   list(s) and maintainer(s) for years.
> 
> The patch system is actively harmful here, because you either send the
> system for discussion, or for inclusion. Picking the patches from the
> mailing list when there are no significant comments (as done on lkml)
> seems to work better. 

That's your view - I used to do the "picking patches from the mailing
list" thing, and the result was that patches got dropped at an alarming
rate.

That's exactly why I created the patch system - to provide a solution
for that problem.

That problem still exists today - I still operate with email in a way
which means if I don't deal with something as soon as I see it, it gets
filed away and almost never looked at again - even if I re-mark the
message as 'New'.  That means if it's inconvenient to apply a patch
(because the machine with the git trees on is powered down) then the
patch tends to get lost.

Hey, I'm useless with email, there's nothing new there.  I know this
so I created a way to solve it.

With the patch system, it remains visible to me without the clutter of
lots of other email, and therefore stands a much better chance of being
applied.

It is just rather unfortunate that since the patch system was written,
a different kind of patch format was invented which isn't compatible
with the patch system, and it doesn't cope well with this other format.

But hey, if you want me to drop lots of patches, then sure just send
them by email.  Just expect to nag me a lot more about applying your
patch.
