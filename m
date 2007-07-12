Return-Path: <linux-kernel-owner+w=401wt.eu-S932769AbXGLNwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932769AbXGLNwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 09:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763504AbXGLNwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 09:52:18 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:53466 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932657AbXGLNwN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 09:52:13 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: Documentation of kernel messages (Summary)
Date: Thu, 12 Jul 2007 21:53:54 +0800
Message-ID: <989B956029373F45A0B8AF0297081890F05F2F@zch01exm26.fsl.freescale.net>
In-Reply-To: <200707111413.03513.rob@landley.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Documentation of kernel messages (Summary)
Thread-Index: AcfD51JzLYGiUFo0QpSTWf8OAW9BLAAmANAA
From: "Li Yang-r58472" <LeoLi@freescale.com>
To: "Rob Landley" <rob@landley.net>
Cc: "Gerrit Huizenga" <gh@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Kunai, Takashi" <kunai@linux-foundation.jp>,
       <holzheu@linux.vnet.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>,
       <lf_kernel_messages@linux-foundation.org>, <mtk-manpages@gmx.net>,
       <jack@suse.cz>, <randy.dunlap@oracle.com>, <gregkh@suse.de>,
       <pavel@ucw.cz>, <tim.bird@am.sony.com>, <arjan@infradead.org>,
       <sam@ravnborg.org>, <jengelh@computergmbh.de>, <joe@perches.com>,
       <auke-jan.h.kok@intel.com>, <hansendc@us.ibm.com>,
       <davem@davemloft.net>, <Valdis.Kletnieks@vt.edu>, <kenistoj@us.ibm.com>,
       <schwidefsky@de.ibm.com>, <heiko.carstens@de.ibm.com>,
       <linux-doc@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 12, 2007 2:13 AM Rob Landley wrote:
> On Wednesday 11 July 2007 10:26:30 am Li Yang wrote:
> > There are quite a lot kernel developers for each of the popular
> > language, AFAIK.  For non-popular languages, there shouldn't be
> > translation available in the first place.
> 
> I don't distinguish between "popular" and "non-popular" languages.  If
> somebody's willing to do the translation work, it's popular.  If
nobody's
> willing to do the work, then even a language 1/3 of the planet's
population
> speaks isn't "popular" for kernel development.
> 
> I wouldn't discourage a translator into Klingon if they were willing
to keep
> their translation up to date and/or it actually resulted in patches.
> 
> > It was really a surprise when
> > I post my Chinese translation on the LKML so many Chinese speakers
have
> > commented on the translation and encouraged the translation work.
They
> > are not visible as they usually don't talk too much.  :) So I set up
the
> > Chinese kernel development maillist(linux-kernel@zh-kernel.org),
there
> > will be more and more experienced kernel developer who can read and
> > update the Chinese documents after they read the translated
> > documentation and become kernel hacker.
> 
> The chinese mailing list is highly cool, and my first instinct was to
note it
> on kernel.org/doc, but it would be better if the chinese website I
already
> link to notes it instead.  (That way I don't have to worry about how
to
> spam-guard your email address. :)

The benefit of a localized maillist is that patches can be reviewed and
commented in native language for common problems (like style, API).

> 
> This also highlights the need for language maintainers to help the
patches go
> upstream to the english list.  (If we can avoid armchair commentators
> saddling them with the task of translating the entire Documentation
directory
> and keeping such a translation up to date, we might actually get one
too.
> Fielding patches and questions sounds like plenty to me...)

I do think the documentation translation is very necessary even when
there is a language maintainer, especially for the policy documents as
HOWTO, codestyle , and etc.  The contributors should go through these
policies and check their code for compliance before going to the
language maintainer for help, or there will be too much for the language
maintainer to translate.  The language maintainer doesn't need to
translate all the documents himself, but he can help to coordinate the
translation effort and help to make it update to date.

> 
> Could you ask on said list if anyone is likely to volunteer for the
position?
> (JUST translating patches and questions, as part of pushing code
upstream.)

If we do need a contact person, I can do it.  However I don't think
there will be much translation work to do here.  As I stated before,
most Chinese programmers are more or less capable of read/write
technical English.  The difficult part is to let them know the benefit
of merging code in kernel and teach them how to do it.  That's why the
policy documents in native language will be very useful.

> 
> > > Merging into the kernel is a great way to keep CODE up to date.
Don't
> > > think
> > > it's magic pixie dust for documentation.  It never has been
before.
> >
> > IMHO, having contribution merged into the kernel has the MAGIC to
> > attract people to work for recognition.  When more and more people
> > volunteer to work on it, the documentation will be up to date
magically.
> 
> Obvious counter-arguments include the floppy driver, the floppy tape
driver,
> the tty layer, and most of the existing english Documentation
directory...
> 
> I'll happily stay out of the way of people who actually want to merge
> translations of documentation into the kernel.  I reserve the right to
say "I
> told you so" in about five years.
> 
> > > Ah, but It's not a language maintainer's job to update
documentation.
> > > It's
> > > their job to ACCEPT PATCHES.  Translate patches, translate
questions
> > > back and
> > > forth.  This has NOTHING to do with documentation unless they're
> > > converting
> > > documentation accompanying the patch one way; into english.
> >
> > Language maintainers can integrate updates to the documentation just
> > like integrating any updates to the code.  Working on the
documentation
> > is ,IMHO, a perfect task for novice kernel hacker to get familiar
with
> > the process.
> 
> From a language maintainer's perspective documentation patches
wouldn't be any
> different than any other patches.  Translate the description and
questions
> going back and forth.  The patch itself doesn't get translated when
it's C
> and applies to scripts/kconfig/, why would it when it's UTF-8 and
applies to
> Documentation/?
> 
> Of course this brings up the question "what kind of function and
variable
> names do chinese people pick?"  (I honestly don't know, but I note
that
> attempts to use names that don't fit in 7-bit ascii would probably be
frowned
> upon in a big way...)
> 
> > It won't be too hard if the work is shared by a community.  Like the
one
> > I'm trying to establish.
> 
> A list works fine as a point of contact.  I note that in general,
maintainers
> are individuals (who delegate like mad, of course), because otherwise
agenda
> items languish with everyone thinking it's someone else's
responsibility.

Got it.  I can do it as long as it doesn't consume too much time.  :)

> 
> http://www.trumanlibrary.org/buckstop.htm
> 
> > - Leo
> >
> > Advertisement time:
> > Chinese kernel development community http://zh-kernel.org    :)
> 
> Hmmm...  Now I'm wondering if I should link directly to the docs pages
of the
> chinese and japanese sites, or to the top level community pages?

The documents and maillist are also linked in the front page.  It's
better to link the top level page.

- Leo
