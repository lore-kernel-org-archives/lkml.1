Return-Path: <linux-kernel-owner+w=401wt.eu-S1761679AbXGXDBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761679AbXGXDBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 23:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755534AbXGXDBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 23:01:32 -0400
Received: from xenotime.net ([66.160.160.81]:34021 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755481AbXGXDBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 23:01:32 -0400
Date: Mon, 23 Jul 2007 20:06:17 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Rob Landley <rob@landley.net>
Subject: Re: [PATCH 1/7] lguest: documentation pt I: Preparation
Message-Id: <20070723200617.87507f16.rdunlap@xenotime.net>
In-Reply-To: <20070723192113.0eaa0ad8.rdunlap@xenotime.net>
References: <1184980678.6344.1.camel@localhost.localdomain>
	<20070723171238.1a832b31.akpm@linux-foundation.org>
	<20070723192113.0eaa0ad8.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2007 19:21:13 -0700 Randy Dunlap wrote:

> On Mon, 23 Jul 2007 17:12:38 -0700 Andrew Morton wrote:
> 
> > On Sat, 21 Jul 2007 11:17:58 +1000
> > Rusty Russell <rusty@rustcorp.com.au> wrote:
> > 
> > > The netfilter code had very good documentation: the Netfilter Hacking
> > > HOWTO.  Noone ever read it.
> > > 
> > > So this time I'm trying something different, using a bit of
> > > Knuthiness.  Start with drivers/lguest/README.
> > 
> > um.
> > 
> > I'm OK with merging patches and given lguest's newness, the timestamp on
> > these patches, the fact that they don't change code generation (right?) and
> > my reluctance to carry large do-nothing patches for two months, I'd be OK
> > with squeaking them into 2.6.23.
> > 
> > But I worry that you're proposing adding what appears to be new
> > Documentation-related machinery and infrastructure when there's already
> > increased activity in that area from other people and we might all be
> > headed in different directions and stuff.
> > 
> > So first I think we'd best form a kernel kommittee and mull this for a
> > while (preferably months) to screw you around as much as poss, OK?  ;)
> > 
> > Items for consideration would be:
> > 
> > - if this stuff is good, shouldn't other code be using it?  If so, is
> >   this new infrastructure in the correct place?
> 
> I wouldn't mind having a new doc infrastructure, but I don't see this as it.
> 
> > - if, otoh, this infrastructure is _not_ suitable for other code, well,
> >   what was wrong with it?
> 
> I think that we don't want to give up html/pdf/ps output formats in
> favor of just text or C source code.  If we do continue to have
> multiple "rich" output formats, we need even more rich syntax rules
> than we have right now.  OTOH, if we dump all of those rich output
> formats, we have less tool spice that is needed.
> 
> (I'm not ignoring Andrew's question here.  I'm just applying the
> 7 patches/series and looking at it more.)
> 
> > - if the requirement is good, perhaps alternative implementations should
> >   be explored (dunno what).
> 
> Yes, but I dunno what either.
> 
> 
> > IOW, I'd be interested in hearing Rob and Randy's opinions on it all,
> > please.
> 
> It's great that Rusty took the time to produce all of this documentation.
> Few people do that today.
> 
> Were current kernel-doc tools not sufficient?  If not, why not?

A:  Nope, kernel-doc won't weave the code + docs together based on a
prefix and order number (e.g., H:310).

Neat as that is, I'm concerned that it will be difficult to maintain
(the order numbers at least -- or are they just difficult to set up
the first time?).

Advantage:  it does keep the source code + doc text together.
Martin (former kernel-doc maintainer) was going to come up with
some way to do this, but he abandoned it.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
