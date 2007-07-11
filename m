Return-Path: <linux-kernel-owner+w=401wt.eu-S1764183AbXGKOQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764183AbXGKOQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 10:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760162AbXGKOQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 10:16:39 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:51265 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758665AbXGKOQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 10:16:38 -0400
Subject: Re: Documentation of kernel messages (Summary)
From: Li Yang <leoli@freescale.com>
Reply-To: leoli@freescale.com
To: Rob Landley <rob@landley.net>
Cc: Gerrit Huizenga <gh@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Kunai, Takashi" <kunai@linux-foundation.jp>,
       holzheu@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, lf_kernel_messages@linux-foundation.org,
       mtk-manpages@gmx.net, jack@suse.cz, randy.dunlap@oracle.com,
       gregkh@suse.de, pavel@ucw.cz, tim.bird@am.sony.com, arjan@infradead.org,
       sam@ravnborg.org, jengelh@computergmbh.de, joe@perches.com,
       auke-jan.h.kok@intel.com, hansendc@us.ibm.com, davem@davemloft.net,
       Valdis.Kletnieks@vt.edu, kenistoj@us.ibm.com, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, linux-doc@vger.kernel.org
In-Reply-To: <200707101212.38981.rob@landley.net>
References: <E1I7wsz-0007oJ-DE@w-gerrit.beaverton.ibm.com>
	 <200707101212.38981.rob@landley.net>
Content-Type: text/plain
Organization: Freescale Semiconductor
Date: Wed, 11 Jul 2007 22:26:30 +0800
Message-Id: <1184163990.23373.46.camel@Gundam>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jul 2007 14:16:03.0453 (UTC) FILETIME=[039732D0:01C7C3C6]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-11 at 00:12 +0800, Rob Landley wrote:
> On Monday 09 July 2007 13:18:57 Gerrit Huizenga wrote: 
> > On Mon, 09 Jul 2007 12:48:24 EDT, Rob Landley wrote: 
> > > In regard to translating kernel messages: 
> > > 
> > > On Monday 09 July 2007 01:36:31 H. Peter Anvin wrote: 
> > > > Kunai, Takashi wrote: 
> > > > > (1) Your kernel development proposal will be greatly supported
> by 
> > > > > Japanese vendor community. At the same time, it needs support
> from 
> > > > > the kernel communities, as well. 
> > > > 
> > > > There is a very strong reason for the kernel community to NOT
> support 
> > > > this: it makes it much harder to deal with bug reports. 
> > > 
> > > Agreed. 
> > 
> > [...] 
> > 
> > > As for the documentation translations themselves, I note that
> Eric 
> > > Raymond dissuaded me from actually hosting translations of kernel 
> > > documentation on http://kernel.org/doc due to his experience with 
> > > translations of his own writings.  If he hosts the translations on
> his 
> > > website, they never get updated again.  But if he makes the
> contributor 
> > > host them on their own website, then they sometimes get updated. 
> > > 
> > > For my part, I can't _tell_ when a given translation is out of
> date 
> > > because I can't read it, and I certainly can't update it.  So I
> agree 
> > > with Eric and I'm linking to sites hosting kernel documentation in
> other 
> > > languages rather than hosting them myself.  I've got a good link
> to a 
> > > Japanese site, need to ping the contributors of the chinese
> documentation 
> > > and see if they have a site for it... 
> > 
> > Yeah, but it seems like having a translations directory in the
> kernel 
> > avoids that problem - anyone can update, it is a single source, no
> digging 
> > for sites that aren't tied to the kernel, available in the distros 
> > directly, etc.
> 
> No.  It doesn't help.
> 
> 99% of the kernel directory is C.  That means any random passerby can
> review 
> code.  Everyone who has the kernel tarball should be able to review
> code 
> that's in there, plus when you compile it breaks.  So merging _code_
> into the 
> kernel helps keep it up to date.
> 
> Merging documentation into the kernel doesn't help keep it up to date,
> because 
> documentation being out of date doesn't break the build.  It may get
> the 
> documentation more review, but the existing state of Documentation/*
> argues 
> against that.  It's a struggle to keep the english versions on the
> same 
> continent as "up to date" or "complete", and most of the _good_
> documentation 
> is out in OLS papers and such (which I'm off indexing as we speak).
> 
> Now add in the non-english nature of the new Documentation/stale 
> subdirectories you're proposing.  Almost nobody in the existing
> kernel 
> community can even _read_ this documentation, let alone update it.
> People 
> who update Documentation/* _can't_ update the translations, and that
> will 
> _never_change_.

There are quite a lot kernel developers for each of the popular
language, AFAIK.  For non-popular languages, there shouldn't be
translation available in the first place.  It was really a surprise when
I post my Chinese translation on the LKML so many Chinese speakers have
commented on the translation and encouraged the translation work.  They
are not visible as they usually don't talk too much.  :) So I set up the
Chinese kernel development maillist(linux-kernel@zh-kernel.org), there
will be more and more experienced kernel developer who can read and
update the Chinese documents after they read the translated
documentation and become kernel hacker.

> 
> Merging into the kernel is a great way to keep CODE up to date.  Don't
> think 
> it's magic pixie dust for documentation.  It never has been before.

IMHO, having contribution merged into the kernel has the MAGIC to
attract people to work for recognition.  When more and more people
volunteer to work on it, the documentation will be up to date magically.

> 
> > I'm not sure that the web site hosting argument is a good one.
> Arch 
> > maintainers and Language Maintainers have some similarities.
> 
> Ah, but It's not a language maintainer's job to update documentation.
> It's 
> their job to ACCEPT PATCHES.  Translate patches, translate questions
> back and 
> forth.  This has NOTHING to do with documentation unless they're
> converting 
> documentation accompanying the patch one way; into english.

Language maintainers can integrate updates to the documentation just
like integrating any updates to the code.  Working on the documentation
is ,IMHO, a perfect task for novice kernel hacker to get familiar with
the process.

> 
> > Also, being 
> > able to clearly mark which version of a document was last
> translated 
> > would help a bit with the fact that most of us aren't proficient in
> all 
> > of the world's languages.
> 
> Keeping translations up to date is not something I can do, and thus
> not my 
> problem.
> 
> > But, knowing who the translation maintainer is, 
> > and when the translation was last updated allows both the original
> doc 
> > maintainer and the translation document maintainer to see when a
> document 
> > likely needs to be updated.  And that is probably good enough.
> 
> Thank you.  You've just scared away all potential language maintainers
> by 
> making them think we want them to translate all the world's existing 
> documentation.  Do you know how long it takes just to read through
> the 
> existing Documentation directory?  (Have you done it?)
> 
> When I'm talking about language maintainers I am NOT looking for them
> to 
> translate existing documentation or keep Documentation/* up to date
> for some 
> other langauge.  That's a more than full-time job.  I've been looking
> around 
> for weeks for someone to just accept Japanese patches, and everybody
> I've 
> talked to says it's too much time commitment without any extra work
> piled on 
> top of it in by armchair commentators who won't be _doing_ that work.

It won't be too hard if the work is shared by a community.  Like the one
I'm trying to establish.

- Leo

Advertisement time:
Chinese kernel development community http://zh-kernel.org    :)



