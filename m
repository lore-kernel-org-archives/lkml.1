Return-Path: <linux-kernel-owner+w=401wt.eu-S933274AbXFRWPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933274AbXFRWPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 18:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932939AbXFRWP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 18:15:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44326 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932909AbXFRWPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 18:15:25 -0400
Date: Mon, 18 Jun 2007 23:15:12 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Alexandre Oliva <aoliva@redhat.com>
Cc: Daniel Hazelton <dhazelton@enter.net>, Bron Gondwana <brong@fastmail.fm>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070618221511.GI21478@ftp.linux.org.uk>
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br> <200706161817.36657.dhazelton@enter.net> <orodjfmjsr.fsf@oliva.athome.lsd.ic.unicamp.br> <200706162306.14516.dhazelton@enter.net> <orwsy3l0jv.fsf@oliva.athome.lsd.ic.unicamp.br> <20070617051451.GD21478@ftp.linux.org.uk> <orps3vjf93.fsf@oliva.athome.lsd.ic.unicamp.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <orps3vjf93.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2007 at 02:56:24AM -0300, Alexandre Oliva wrote:
> Can you please acknowledge that it doesn't, such that I can feel I've
> fulfilled my goal of dispelling the myth that the GPLv3 changes the
> spirit of the GPL?

No.  I don't do metaphysics.  This thread alone has shown that the
notion is not well-defined *at* *all*, to the point of being useless
and seriously misleading.  I.e. the phrase about similar spirit
should be replaced with something far more explicit and very, very
hard to miss.  I don't think you need more proof that people *do*
interpret it in very different ways, with quite unpleasant results.
 
> > GPLv3, with your involvement in its development or not, sucks rocks,
> > thanks to what you call anti-tivoization section.
> 
> Is it correct to say that you share Linus' opinion, that the only
> problem with the GPLv3 is the anti-tivoization provision?

No.  If you want a basic splitup by sections compared to GPLv2,
	1	-	at least not better; attempts at being precise
			end up creating a no-common-sense-land *and*
			turn out to leave serious unanswered questions
			in that area.
	2	-	no opinion on actual changes
	3	-	more or less an improvement
	4,5	-	about on par with v2, modulo wording in (5)
	6	-	much worse
	7	-	if I want to give additional permissions, I don't
			want them stripped, for fsck sake!  There is a
			bog-standard mechanism for _that_ (dual-licensing),
			thank you very much.  I.e. that section looks like				a pile of dishonest PR games, pardon the redundance.
	8	-	on par
	9	-	on par, modulo piss-poor attempt to define "modify"
			backfiring here (e.g. prelinking constitutes
			modification according to it, so does running rdev(8),
			etc., etc.)
	10	-	no opinion on actual changes
	11	-	improvement
	12	-	on par (aside of basic bad writing, but there are
			much worse problems *not* with wording, so that's
			not interesting)
	13	-	special-case kludges are fun, aren't they (specifically
			"linking"?), but in any case, that's secondary.
			FWIW, I'm not fond of ideas behind Affero, so if
			anything, that's a point against v3.
	14	-	... and thank you very much for keeping such a lovely
			source of periodic clusterfucks in v3 as well.
			I think it's painfully obvious for everyone in this
			thread that reference to "spirit" is a recipe for
			massive disagreements down the road.  If you want the
			words you are using to be interpreted your way, use
			ones that have commonly agreed upon meaning.  The
			measure is "do other people read it differently?",
			not "how sure I am in deriving the meaning I want from
			the words I've used?".  Related problem is that
			version choice rules _must_ be stated in maximally
			unambiguous and hard to miss way.  Look through
			Bernd-produced parts of this thread and you'll see
			the reason why it is needed.
			Moving that into terms and conditions is a good step,
			but it's still not enough.  E.g. you really want
			to be explicit on the form (in)sufficient to specify
			the version of license.
	the rest	on par.

Overall: definitely worse than v2.  v2 + (3) + (11) would be an improvement,
provided that v2 section 9 is cleaned up.

> To make this more concrete, if there was a hypothetical GPLv2.9,
> consisting of GPLv3dd4 minus the "installation information"
> requirements for user products, (i) Would you consider it a better
> license than GPLv2?
	Negative, see above
 (ii) Better for Linux?
	Negative, for kernel as well as for userland
(iii) Enough to go through the trouble of switching?
	See above.

In other words, I don't see any chance for v3 to be a good choice
for anything I write, kernel or userland.  If I end up sending patches
to v3 projects, I'll put the patches under BSDL and let them convert
on merge.

Note that this is *not* about the problems with wording; those also exist,
of course (_that_ is a final draft?), but that's a separate story and it
interests me only inasmuch as it is caused by inherent problems with meaning
of section in question.
