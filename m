Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbXFPFdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbXFPFdS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 01:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbXFPFdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 01:33:11 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:60167
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbXFPFdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 01:33:09 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Sat, 16 Jun 2007 01:33:12 -0400
User-Agent: KMail/1.9.6
Cc: Michael Gerdau <mgd@technosis.de>, Daniel Hazelton <dhazelton@enter.net>,
       Alexandre Oliva <aoliva@redhat.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm> <200706152103.06921.rob@landley.net> <alpine.LFD.0.98.0706151814380.14121@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706151814380.14121@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706160133.14204.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 June 2007 21:29:22 Linus Torvalds wrote:
> On Fri, 15 Jun 2007, Rob Landley wrote:
> > Technically what they're holding back is _trademark_ rights, which are a
> > different area of IP law and not addressed by the GPL.  (I know you know
> > this, but just for the record...)
>
> No, technically Red Hat really *does* have copyrights of their own.

They do have copyrights.  They license them under the GPL, and afterwards they 
still have them.

> Red Hat owns the "compilation copyright" on their distribution. That
> means, for example, that even if they have _only_ open source programs on
> their DVD image, you still are not necessarily able (without their
> permission) to set up a "cheap-cd's" kind of operation, and sell their
> CD-ROM/DVD images for a lower price.

I agree that they have this right, but that wasn't the rationale they gave in 
the cease and desist letters they sent out in 2001.  Those said it was ok to 
redistribute, but you can't use their trademarks to promote it when you did 
so:
http://www.newsforge.com/article.pl?sid=01/12/10/2014239&mode=thread

[Rummages around for their current policy statement...]

The restriction is embodied in their "trademark guidelines and policies":
http://www.redhat.com/about/companyprofile/trademark/

If you open the PDF:
http://www.redhat.com/f/pdf/corp/RH-3573_284204_TM_Gd.pdf

Page one, the right hand side talks about copyright, second paragraph:

> At the same time, the combined body of work that consitutes Red Hat (R)
> Enterprise Linux (R) is a collective work which has been organized by Red
> hat, and Red hat holds the copyright in that collective work.  Red hat then
> permits others to copy, modify and redistribute the collective work.  To
> grant this permission Red hat usually uses the GNU General Public License
> ("GPL") version 2 and Red Hat's own End User License Agreement.  Although
> software licensed under the GPL is "open source software," Red Hat retains
> ownership of the copyright in its collective work.  If someone violates the
> GPL regarding that collective work, only Red Hat, as the copyright owner and
> licensor of that collective work, has legal authority to enforce the GPL
> against the violator.  Although Red hat "owns" the collective work, in
> licenseing it under the GPL, Red Hat grants broad rights in the collective
> work to others.  Neither the GPL nor Red Hat's End User License Agreement
> grant any right to use Red hat's trademarks in the redistribution of the
> collective work.

That seems to say that their compilation copyright is also licensed under the 
GPL, and what they're not giving permission to use is the trademark.

> So yes, they do own the Red Hat trademark too, but they fundamentally do
> own copyrights over and beyond those of the individual programs they
> distribute!

I agree they claim compilation copyrights.  But they seem to have licensed 
their compilation copyrights under GPLv2.

If they're including GPLed works in the compilation, this may actually be a 
requirement.  (Lawyers would happily fight over this issue for months: 
asserting a copyright over the aggregation takes the "mere" out of it, don't 
you think?  Is a compilation a derived work of the components that were 
compiled, at least for the purposes of GPLv2?  Can it be "mere aggregation" 
if you're enforcing a copyright on that aggregation?  Does it not then become 
a larger work with GPL components?  I dunno.)

You'll notice that back under Bob Young, Red Hat carefully didn't go there, by 
licensing the compilation GPLv2 and segregating incompatibly licensed content 
to a separate CD.  After the IPO, he retired and different management took 
over, and introduced Red Hat Enterprise to eat Sun's market[1], and who knows 
what they're thinking now?  I suspect their lawyers still want the 
GPL-incompatible stuff on a separate CD so they can sleep at night.

(Either that, or they just don't assert a compilation copyright, but why give 
that up if they don't have to?)

> Now, I think it so happens that the RHEL DVD's contains other programs
> than just open source, and that you couldn't legally copy them *anyway*,
> but that's a different issue.

The existence of CentOS seems to argue against this.  They say:

> The vast majority of changes made will be made to comply with the upstream
> vendor's re-distribution policies concerning trademarked names or logos.
> Any other changes made will be spelled out in the Release Notes for the
> individual CentOS product.

I haven't noticed any specific non-GPL packages removed from Centos.  Buried 
down in their FAQ they say they're building the same set of packages as are 
in Red Hat Enterprise AS.

I suspect the reason for a lack of obvious proprietary stuff in the RHEL base 
distro is that Red Hat's lawyers don't want to give up the option to enforce 
the compilation copyright on said base distro, but also don't want to raise 
the spectre of enforcing a copyright on a derived work of GPL code (the 
compilation, which includes GPL code and if copyrighted probably isn't "mere 
aggregation") that contains code which can't be licensed under the GPL.

I don't know the answer to this one.  This is the sort of thing that gives 
lawyers ulcers.  (And yachts.)  But I can believe their lawyers want to keep 
their options open if they're sufficiently unsure how the hypothetical would 
play out in court...

> Also, happily, a lot of vendors do not *want* to exercise their
> copyright in the compilation, so you can go to cheapbytes.com, and you'll
> find Fedora CD's, OpenSuSE CD's, Ubuntu CD's, etc, and as far as I know,
> they're all perfectly legal.

Red Hat created the "Fedora" trademark to have a separate and more liberally 
licensed trademark that people like cheapbytes.com could use without 
reflecting on Red Hat Enterprise.  Unfortunately, trying to find reference 
for this is non-obvious, because, the Fedora Trademarks page is: 
http://fedoraproject.org/wiki/Legal/TrademarkGuidelines

Which contains no actual content, but instead links to a fedora.redhat.com 
page which is 404. :P

But again, it's trademark not copyright they're restricting.

> > The five main areas of IP law as I understand them are copyright, patent,
> > trademark, contract, and trade secret.
>
> I'd not put contract there, but fair enough. But what I was really trying
> to point out is that there are many different "levels" of copyright.
>
> So you can own a "copyright in the compilation" - which just means that
> you own the details of how you set it all together - _without_ actually
> necessarily owning the copyrights in any of the individual packages
> (although you obviously have to have a license to _make_ a compilation of
> them - but the GPLv2 is one such license).

Sure, it's spelled out in some detail by the copyright office right here:
http://www.copyright.gov/circs/circ14.html#compilations

And in less penetrable legalese here [2]:
http://www.copyright.gov/title17/92chap1.html#103

However, mostly I just deal with straightforward derivative works when 
worrying about GPL enforcement.  (When I brought up compilation copyright to 
the SFLC guys last year in relation to enforcing the busybox copyrights, they 
didn't think they needed to go there since between Erik and myself they 
represent copyrights to a significant portion of the entire codebase, 
including the central plumbing you can't run the thing without).

Intellectual property law has been a hobby of mine ever since I visited the 
Patent and Trademark office in washington DC with my grandfather back in the 
90's, and picked up the big green brochures explaining this stuff.  I think I 
still have the badge in a box somewhere.  There's all SORTS of weird corner 
cases to this stuff.  (Did you know the federal government can't create a 
copyright?  Everything created by federal employees is automatically in the 
public domain.  So the way they get around that is they hire contractors, 
have them create copyrighted materials, and transfer the copyrights to the 
government...)

> 			Linus

Rob

[1] Large purchasing contracts, especially for government projects, often cap 
a supplier's profits at a percentage of costs.  This means the way for a 
supplier to get a larger profit off the contract is to user more expensive 
components.  So they'd rather grab $5000/seat OS than a $20/seat OS because 
the same 10% profit is $500 vs $2.  This is a big reason you saw lots of 
Solaris and AIX and such in Navy bids 10 years ago: it was popular _because_ 
it was expensive.  Then Red Hat figured out "wait, you mean if I can come up 
with an excuse to charge a couple orders of magnitude more per seat, MORE 
people will buy it?"  And they invented "Red Hat Enterprise" to soak that 
kind of purchaser for all they were worth, and it was so lucrative they 
retreated up into that space to attack the soft underbelly of Sun...

[2]  The section relating specifically to computer programs is interesting 
reading too:  http://www.copyright.gov/title17/92chap1.html#117

The stuff about "archival copies" is explicitly statutory.  When I first heard 
about it I thought it was just case law...
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
