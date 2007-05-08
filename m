Return-Path: <linux-kernel-owner+w=401wt.eu-S968165AbXEHQQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968165AbXEHQQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 12:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934891AbXEHQQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 12:16:24 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:36593 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934893AbXEHQQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 12:16:23 -0400
X-Originating-Ip: 99.246.112.70
Date: Tue, 8 May 2007 12:14:33 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Adrian Bunk <bunk@stusta.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] Create a top-level "Space-critical features" menu.
In-Reply-To: <20070508085654.GG4226@stusta.de>
Message-ID: <Pine.LNX.4.64.0705081205440.8750@localhost.localdomain>
References: <Pine.LNX.4.64.0705080356020.10881@localhost.localdomain>
 <20070508085654.GG4226@stusta.de>
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

On Tue, 8 May 2007, Adrian Bunk wrote:

> On Tue, May 08, 2007 at 04:06:30AM -0400, Robert P. J. Day wrote:
> >
> >   i've always hated that lower-level menu under "General setup":
> >
> > Configure standard kernel features (for small systems)  --->
> >
> > which buries the choice of de-selecting features to save space one
> > level down without really explaining what it's all about.  so i just
> > shifted all of that up to the top under what i think is a more
> > meaningful name.
> >
> >   this patch is also why i asked earlier why top-level menu entries
> > have no "help" text -- because, in this case, it would be useful for
> > someone looking at the config screen to see that choice and be able to
> > ask, "hey, i wonder what *that's* all about", and get help along the
> > lines of:
> >
> >   "these features are normally selected but, if you're strapped for
> > space, such as with embedded systems, you might consider turning some
> > of them off.  if space isn't an issue, you might as well just leave
> > them as they are."  (or something like that.)
> >...
>
> I'm against it:
>
> I don't have numbers, but I'd expect the vast majority of people
> building kernels to be people with low kernel knowledge building for
> an i386/x86_64 system.

i agree.  but a number of people have already suggested that that
lower-level menu

  "Configure standard kernel features (for small systems)" --->

is not well-designed.  and the very people you're talking about will
see that and not be quite sure what it represents.  and they
*certainly* won't realize that *not* selecting it will have
consequences in other menus.

that particular menu is confusing for a number of reasons:

1) it's badly named
2) it has no help to explain it
3) even if you don't select it, it will still have some sub-menu
entries, which is non-intuitive
4) it's not at all clear that, if you don't select it, other possible
config entries all over the source tree won't be available.

> OTOH, people developing embedded systems are most likely more
> familiar with kernel internals.

i'm betting even embedded people might not understand what's going on
there.  it's particularly confusing since, if you choose that option,
you will suddenly see a number of additional "small system" features
you can turn off, but there's no indication that options all over the
tree are suddenly becoming visible.

note:  i have no problem with some kind of overall, top-level option
that does this sort of thing.  i just don't think the current
technique is the right way.  in fact, i think it's awful, and i'd love
to see it made more obvious.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
