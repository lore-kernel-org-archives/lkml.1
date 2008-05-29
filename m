Return-Path: <linux-kernel-owner+w=401wt.eu-S1754351AbYE2C2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbYE2C2L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 22:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187AbYE2C17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 22:27:59 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:45793 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbYE2C16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 22:27:58 -0400
Date: Wed, 28 May 2008 20:27:41 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2008-discuss]  Fixing the Kernel Janitors project
Message-ID: <20080529022741.GO22636@parisc-linux.org>
References: <1211995212.3445.52.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211995212.3445.52.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2008 at 12:20:12PM -0500, James Bottomley wrote:
> In the spirit of having a more process than technical based kernel
> summit, I'd like to put the topic of the kernel Janitors project up for
> discussion.

I suspect many of the people contributing to this thread aren't on the
kernel-janitors list.  They're only seeing janitorial-style patches hit
them in the face, and they know they don't like it.

> On the other hand, as a
> maintainer, when there's people yelling me at about patches not being
> included plus a persistent regressions list and about ten bug reports to
> track down, the last thing I want to see within a million miles of my
> inbox is a white space fixing patch.

Part of the problem is that whitespace fixing patches are treated like
they're real patches.  We get conflicts with real patches, they're pinged
like they're real patches, and the contributors name gets put in the
shortlog like it was a real patch.

I liked the trivial service that Rusty had setup.  Patch started getting
conflicts?  Dropped.  Pinged?  By an automated device, not by akpm.  We
didn't have contributor names back then, but maybe we should anonymise
whitespace patches -- just accept that something that could have been
done by a machine isn't worth attaching a name to.

> The most obvious solution might be to shut the Janitors project down, or
> at least more tightly manage its TODO list (although a lot of what gets
> seen as janitorial patches, like whitespace fixes, isn't on the TODO
> list in the first place).

Also, a lot of the trivial patches don't come across the janitors list
first, so shutting the project down will not, IMO, reduce the problem.
So, most obvious, but wrong ;-)

> However, since the purpose is to get new
> people involved with kernel development, perhaps we should repurpose the
> project so it actually does this.  My suggestion is that we replace it
> with the kernel bugs project.  Kudos for finding bugs, more for finding
> better ways of finding bugs, and the most for finding and actually
> fixing a bug.  

That's a good idea.  We'd all be happier if more people spent time on
bug triage, investigation and fixing.

> Perhaps we should simply start the discussion with the premise that we
> want to encourage new people to do useful work and draw them into the
> development community and see where it leads.

There are some of those things going on in the current janitors project,
it's just they're drowned out by the noise.  I'd like to mention a few.

Mark Asselstine has been working to remove the last remnants of cli/sti
from the kernel.  I believe patches to get rid of them all are now
either merged or sitting in trees waiting to be merged.  I found him
receptive to feedback and willing to sit down and really analyse a
driver to figure out what was going on.  If he chooses to continue his
kernel hacking career, he'll be a great asset.

Julia Lawall has a fun tool that spots patterns which are buggy.  I've
worked on a number of patches with her recently where we compare
unsigned integers < 0.  Again, we need people to look at the piece of
code in context to figure out what the original author meant (not too
dissimilar from the coverity reports).

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
