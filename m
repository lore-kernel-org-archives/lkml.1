Return-Path: <linux-kernel-owner+w=401wt.eu-S1753309AbYGaRtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbYGaRtd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 13:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755277AbYGaRtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 13:49:15 -0400
Received: from iabervon.org ([66.92.72.58]:49277 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039AbYGaRtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 13:49:14 -0400
Date: Thu, 31 Jul 2008 13:49:12 -0400 (EDT)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Jonathan Corbet <corbet@lwn.net>
cc: Alex Chiang <achiang@hp.com>, LKML <linux-kernel@vger.kernel.org>,
       Amanda McPherson <amanda@amcpherson.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH, RFC] A development process document
In-Reply-To: <20080731101738.1bf4281c@bike.lwn.net>
Message-ID: <alpine.LNX.1.00.0807311249320.19665@iabervon.org>
References: <20080729143015.0f79cf37@bike.lwn.net> <20080731062305.GA18070@ldl.fc.hp.com> <20080731101738.1bf4281c@bike.lwn.net>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2008, Jonathan Corbet wrote:

> On Thu, 31 Jul 2008 00:23:05 -0600
> Alex Chiang <achiang@hp.com> wrote:
> 
> > Overall, a great document, as expected from you. I've replied with
> > "content" comments below.
> 
> I've applied most of them, thanks.
>  
> > But it occurs to me that sending "style" comments to the editor of
> > LWN is something akin to, well, some combination of Prometheus,
> > Icarus, ravenous vultures, rabid penguins, and telling Linus that
> > his choice of $EDITOR sucks, which is to say, "unwise".
> 
> Naw, English always needs debugging too.
>  
> > You've got url reference for some quotes but not all. Would it be
> > possible to track them all down? Sorry for asking for all the extra
> > work, but I think the references are useful, especially if the
> > motivated reader actually visits said reference and gets all sides of
> > the story.
> 
> I'll see what I can do.  Some of the older ones are kind of hard to find. 
>  
> > > +Patches must be prepared against a specific version of the
> > > kernel.  As a +general rule, a patch should be based on the current
> > > mainline as found in +Linus's git tree.  It may become necessary to
> > > make versions against -mm,
> >    ^^^^^^^
> > Hm, is this the new recommended style? Grammar school taught me that
> > it should be "Linus'" but I've noticed a gradually changing but
> > inconsistently applied new school style.
> 
> I actually researched that a while back.  The rule, as far as I can tell
> (and to the extent that English has real rules) is that the trailing "s" is
> elided only when making a possessive of a plural noun.  "Linus", being very
> much a unique, singular entity, needs to be "Linus's" in the possessive
> form.
>  
> > > +If you have a significant series of patches, it is customary to
> > > send an +introductory description as part zero.  In general, the
> > > second and
> > 
> > This directly conflicts with akpm's advice:
> > 
> > 	http://www.zipworld.com.au/~akpm/linux/patches/stuff/tpp.txt
> > 
> > Section 6(b).
> 
> Interesting; Andrew didn't mention that in his review.  I think the intro
> postings can be very useful in understanding a patch series as a whole.
> Maybe I'll put in something about how anything which should be in the
> changelogs needs to go with the actual patches.

If you include a [0/N], it's a cover letter, not a changelog portion. It 
can be a useful way of providing context to reviewers as to the intended 
total effect. Each of the patches should make sense standalone, but it's 
not always clear from the individual patches what the total benefit is, 
and a 0/N that explains can be worthwhile (and you'd want to make that 
announcement to the mailing list, but not get it into the history).

For example, if you have a series of patches that remove use of an old API 
from various places, each of those patches cleans up some piece of code, 
and these changelogs would say so, but it wouldn't be accurate (especially 
if 5/N gets dropped or reverted later) to say anywhere that you've removed 
all in-kernel use of the API; it's useful to include a cover letter that 
says so.

The same sort of text can be included in individual patches, after the 
tags and before the patch text, by putting a line '---' ahead of it; git, 
by default, puts a per-patch diffstat there, but you can add other stuff 
that will be helpful to reviewers but not future developers, like "this 
should fix Andrew's laptop".

	-Daniel
*This .sig left intentionally blank*
