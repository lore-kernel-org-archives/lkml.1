Return-Path: <linux-kernel-owner+w=401wt.eu-S1758694AbXFNXo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758694AbXFNXo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 19:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578AbXFNXoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 19:44:22 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:51229
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546AbXFNXoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 19:44:21 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Thu, 14 Jun 2007 19:44:19 -0400
User-Agent: KMail/1.9.6
Cc: Robin Getz <rgetz@blackfin.uclinux.org>,
       "Daniel Hazelton" <dhazelton@enter.net>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Greg KH" <greg@kroah.com>,
       "debian developer" <debiandev@gmail.com>, david@lang.hm,
       "Tarkan Erimer" <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>, mingo@elte.hu
References: <466A3EC6.6030706@netone.net.tr> <200706141014.21574.rgetz@blackfin.uclinux.org> <or1wgefmyn.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <or1wgefmyn.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706141944.21280.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 June 2007 13:46:40 Alexandre Oliva wrote:
> On Jun 14, 2007, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> > On Thu 14 Jun 2007 01:07, Alexandre Oliva pondered:
> >> then maybe the small
> >> company could have been more careful about the regulations.  There are
> >> various ways to prevent these changes that don't involve imposing
> >> restrictions of modification on any software in the device, all the
> >> way from hardware-constrained output power to hardware-verified
> >> authorized configuration parameters.
> >
> > As a person pretty familiar with the hardware in these types of
> > devices - this just isn't practical.
>
> I actually left out the most obvious one: store the program in ROM.
> Is that not practical?
>
> You're claiming that adding hardware locks and chains and bolts,
> implemented with help from the loader software, is simpler than just
> using ROM?

As far as I know, I'm the first one who brought up the "the current GPLv3 
draft forbids burning your code into ROM, you idiots" argument back before 
Bruce Perens cost the BusyBox project my services over this very issue.  (Not 
that I didn't lock the license of that down to v2 and chase him away before I 
left, I was just too disgusted to ever again contribute to a project he'd 
named.  Yeah, I hold a grudge.)

Although it's kind of amusing to watch you attempt to dictate terms to 
hardware manufacturers, the answer to your question is "yes".  Having flash 
is sometimes simpler and cheaper than having ROM.  It means you don't have to 
burn a new mask to bump the firmware revision (especially on a low-volume 
production run, where "low volume" here is tens or hundreds of thousands 
instead of millions).  It makes the thing a lot more field serviceable (you 
can upgrade the firmware without a chip puller).  It means one physical chip 
can give you both read-only and persistent writeable storage.   And flash 
chips produced in high enough unit volumes honestly can be cheaper than a 
custom ROM, pricing in semiconductors is all about unit volume.

> Well, then, ok: do all that loader and hardware signature-checking
> dancing, sign the image, store it in the machine, and throw the
> signing key away.  This should be good for the highly-regulated areas
> you're talking about.  And then, since you can no longer modify the
> program, you don't have to let the user do that any more.  Problem
> solved.

A) Does that actually satisfy the terms of GPLv3?  If so, can't they just wait 
until they get sued and destroy the keys then?

B) There are actually manufacturers who would be happy with your straw man.  
Lots of companies in the far east produce products that infringe on patents 
from 30 different competitors, and rather than try to license everything 
(which isn't even always possible) they spin off a shell company (or nested 
series thereof), design and manufacture a product, sell a production run of 
them into the distribution channel, and then dissolve the shell company 
before the inventory hits retailers.  But the time anybody is in a position 
to take an enforcement action, the company to take the action against is 
gone.  (Who are you going to sue, customers who bought the devices?  The 
distributors who bought the inventory in good faith, and will then refuse to 
distribute any of YOUR product if you attack 'em?)  There's always the 
possibility that somebody will sit down and follow the paper trail back to 
the parent company (through the multiple legal jurisdictions where nobody 
speaks english), but since they're likely as not to destroy this kind of info 
_anyway_ while burying their trail...

Rob
