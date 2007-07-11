Return-Path: <linux-kernel-owner+w=401wt.eu-S1762203AbXGKSOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762203AbXGKSOB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 14:14:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756312AbXGKSNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 14:13:51 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:57574
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755312AbXGKSNu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 14:13:50 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: leoli@freescale.com
Subject: Re: Documentation of kernel messages (Summary)
Date: Wed, 11 Jul 2007 14:13:02 -0400
User-Agent: KMail/1.9.6
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
References: <E1I7wsz-0007oJ-DE@w-gerrit.beaverton.ibm.com> <200707101212.38981.rob@landley.net> <1184163990.23373.46.camel@Gundam>
In-Reply-To: <1184163990.23373.46.camel@Gundam>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707111413.03513.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 July 2007 10:26:30 am Li Yang wrote:
> There are quite a lot kernel developers for each of the popular
> language, AFAIK.  For non-popular languages, there shouldn't be
> translation available in the first place.

I don't distinguish between "popular" and "non-popular" languages.  If 
somebody's willing to do the translation work, it's popular.  If nobody's 
willing to do the work, then even a language 1/3 of the planet's population 
speaks isn't "popular" for kernel development.

I wouldn't discourage a translator into Klingon if they were willing to keep 
their translation up to date and/or it actually resulted in patches.

> It was really a surprise when 
> I post my Chinese translation on the LKML so many Chinese speakers have
> commented on the translation and encouraged the translation work.  They
> are not visible as they usually don't talk too much.  :) So I set up the
> Chinese kernel development maillist(linux-kernel@zh-kernel.org), there
> will be more and more experienced kernel developer who can read and
> update the Chinese documents after they read the translated
> documentation and become kernel hacker.

The chinese mailing list is highly cool, and my first instinct was to note it 
on kernel.org/doc, but it would be better if the chinese website I already 
link to notes it instead.  (That way I don't have to worry about how to 
spam-guard your email address. :)

This also highlights the need for language maintainers to help the patches go 
upstream to the english list.  (If we can avoid armchair commentators 
saddling them with the task of translating the entire Documentation directory 
and keeping such a translation up to date, we might actually get one too.  
Fielding patches and questions sounds like plenty to me...)

Could you ask on said list if anyone is likely to volunteer for the position?  
(JUST translating patches and questions, as part of pushing code upstream.)

> > Merging into the kernel is a great way to keep CODE up to date.  Don't
> > think
> > it's magic pixie dust for documentation.  It never has been before.
>
> IMHO, having contribution merged into the kernel has the MAGIC to
> attract people to work for recognition.  When more and more people
> volunteer to work on it, the documentation will be up to date magically.

Obvious counter-arguments include the floppy driver, the floppy tape driver, 
the tty layer, and most of the existing english Documentation directory...

I'll happily stay out of the way of people who actually want to merge 
translations of documentation into the kernel.  I reserve the right to say "I 
told you so" in about five years.

> > Ah, but It's not a language maintainer's job to update documentation.
> > It's
> > their job to ACCEPT PATCHES.  Translate patches, translate questions
> > back and
> > forth.  This has NOTHING to do with documentation unless they're
> > converting
> > documentation accompanying the patch one way; into english.
>
> Language maintainers can integrate updates to the documentation just
> like integrating any updates to the code.  Working on the documentation
> is ,IMHO, a perfect task for novice kernel hacker to get familiar with
> the process.

>From a language maintainer's perspective documentation patches wouldn't be any 
different than any other patches.  Translate the description and questions 
going back and forth.  The patch itself doesn't get translated when it's C 
and applies to scripts/kconfig/, why would it when it's UTF-8 and applies to 
Documentation/?

Of course this brings up the question "what kind of function and variable 
names do chinese people pick?"  (I honestly don't know, but I note that 
attempts to use names that don't fit in 7-bit ascii would probably be frowned 
upon in a big way...)

> It won't be too hard if the work is shared by a community.  Like the one
> I'm trying to establish.

A list works fine as a point of contact.  I note that in general, maintainers 
are individuals (who delegate like mad, of course), because otherwise agenda 
items languish with everyone thinking it's someone else's responsibility.

http://www.trumanlibrary.org/buckstop.htm

> - Leo
>
> Advertisement time:
> Chinese kernel development community http://zh-kernel.org    :)

Hmmm...  Now I'm wondering if I should link directly to the docs pages of the 
chinese and japanese sites, or to the top level community pages?

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
