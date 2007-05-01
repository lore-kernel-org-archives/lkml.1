Return-Path: <linux-kernel-owner+w=401wt.eu-S1423088AbXEAKRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423088AbXEAKRo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161677AbXEAKRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:17:44 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:33077 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161676AbXEAKRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:17:35 -0400
X-Originating-Ip: 74.109.98.66
Date: Tue, 1 May 2007 06:16:35 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Willy Tarreau <w@1wt.eu>
cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, linux-pcmcia@lists.infradead.org
Subject: Re: pcmcia ioctl removal
In-Reply-To: <20070501094400.GX943@1wt.eu>
Message-ID: <Pine.LNX.4.64.0705010600140.9375@localhost.localdomain>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
 <20070501084623.GB14364@infradead.org> <Pine.LNX.4.64.0705010514300.9162@localhost.localdomain>
 <20070501094400.GX943@1wt.eu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007, Willy Tarreau wrote:

> On Tue, May 01, 2007 at 05:16:13AM -0400, Robert P. J. Day wrote:
... snip ...
> > in other words, the PCMCIA ioctl feature *has* been listed as
> > obsolete for quite some time, and is already a *year and a half*
> > overdue for removal.
> >
> > in short, it's annoying to take the position that stuff can't be
> > deleted without warning, then turn around and be reluctant to remove
> > stuff for which *more than ample warning* has already been given.
> > doing that just makes a joke of the features removal file, and makes
> > you wonder what its purpose is in the first place.
> >
> > a little consistency would be nice here, don't you think?
>
> No, it just shows how useless this file is.

agreed.  it's mildly entertaining to have watched this raging
discussion over the last few days regarding bugs and emails and
bugzilla and adrian's regressions, while the one feature that's meant
to track aging and removable kernel features is essentially valueless,
and no one seems to care.

> What is needed is a big warning during usage, not a file that nobody
> reads.

agreed there as well.  but short of that, it would still be nice if
people took a minute, perused the feature removal file, and at least
brought it up-to-date.  if it's going to have any value, then:

1) all proposed removal dates should be reviewed to make sure they're
still meaningful,

2) stuff that's overdue for removal should be either removed, or have
its expiry date brought forward, and

3) stuff in the kernel tree that is understood to be obsolete or
nearly so should have an entry added to that file, so that the clock
can at least *start* ticking for that stuff, and you can at least say
you *tried* to warn current users.

as a start, i posted last month the results of running the simple
command:

  $ grep -iw obsolete $(find . -name Kconfig\*)

and some of what was printed is clearly misleading.  (don't worry,
tilman -- we're not going to reopen that whole isdn4linux thing. :-)

i mean, what of the following is actually obsolete:

  * traffic policing
  * IP6 Userspace queueing via NETLINK
  * IP Userspace queueing via NETLINK
  * ebt: ulog support
  * Traffic Shaper

and so on (and there's that legacy PM thing as well).

> I'm sorry for your patch which may get delayed a lot.

obviously, leaving stuff like that in the kernel doesn't actually
*hurt* anything but, yeah, it's a tad annoying to invest a few minutes
to do some janitor work based on what should be killable, submit the
patch, then have people freak out about how that is still an essential
feature.

bottom line:  if you want janitor folks to help out with cleanup, make
sure they know what can legitimately be cleaned, and stop wasting
peoples' time.

rday

p.s.  now if there were only a way to, say, tag various kernel
features as "obsolete" or "deprecated" ...  :-)

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
