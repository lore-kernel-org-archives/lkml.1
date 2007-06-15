Return-Path: <linux-kernel-owner+w=401wt.eu-S1756990AbXFOAa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990AbXFOAa2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 20:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbXFOAaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 20:30:11 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:33537
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbXFOAaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 20:30:09 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Sean <seanlkml@sympatico.ca>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Thu, 14 Jun 2007 20:30:08 -0400
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Valdis.Kletnieks@vt.edu,
       Daniel Hazelton <dhazelton@enter.net>,
       Alexandre Oliva <aoliva@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
References: <466A3EC6.6030706@netone.net.tr> <alpine.LFD.0.98.0706140850470.14121@woody.linux-foundation.org> <20070614131409.9a5800dc.seanlkml@sympatico.ca>
In-Reply-To: <20070614131409.9a5800dc.seanlkml@sympatico.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706142030.09435.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 June 2007 13:14:09 Sean wrote:
> On Thu, 14 Jun 2007 09:01:32 -0700 (PDT)
>
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > In other words, we're just *much* better off with a friendly license and
> > not trying to force people to choose sides, than with the rabid idealism
> > that was - and still is - the FSF. The FSF always makes for this horrible
> > "you're with us, or you're against us" black-and-white mentality, where
> > there are "evil" companies (Tivo) and "good" companies (although I dunno
> > if the FSF really sees anybody as truly "good").
>
> Linus,
>
> If you really believe that then why didn't you choose a BSD license
> for Linux?

BSD licenses encourage forking.  Specifically, if a BSD-licensed project 
becomes significantly commercially valuable, there's an incentive for 
companies to hire your developers away to work on a proprietary fork.

When Sun Microsystems started up in 1982, they hired away Bill Joy to work on 
a closed version of BSD (SunOS).  When Berkeley shut down the CSRG, BSDi 
hired those developers to work on another closed source BSD variant.  More 
recently, Apple hired people like Jordan Hubbard away from FreeBSD to do yet 
another fork: MacOS X.  The loss of people hurts the original project.

With BSD licensed code, companies can say "work on the codebase you love as a 
day job, and you can still work on the open version at night".  Then work 
them 90 hours/week.  Or even "we'll release this code open source after we 
can't sell it anymore, a year or two from now".  And then the deadline never 
comes, or the codebase is irrelevant by then, or too far diverged to merge.  
You won't get all the developers, but you'll get enough to cost the open 
project momentum.  BSD is 30 years old and the free version is still a pale 
shadow of its proprietary forks like MacOS X or the bits of it Windows 
incorporated.

Now think about trying to do that to a GPL project.  If you hire the 
developers away, they have to work on a _different_ codebase.  Much less 
compelling, both for the hirer and the hiree.  If you think Linux is 
compelling enough to commercialize, you MUST do so within the terms of the 
GPL or not do it at all.  You can't do a closed fork and distribute the 
result.  Maybe this means companies aren't as quick to jump on the bandwagon 
trying to commercialize it, but the project can then grow larger without 
interference until commercial participation _is_ compelling, on its own 
merits, despite being unable to corner the market on it.

> Instead you chose a license which enforced the so called tit-for-tat
> policy you think is fair.  But people who prefer the BSD license may
> think you're a moron for forcing your political agenda (ie. tit-for-tat)
> on users of your code.

It's not political, it's pragmatic.  GPLv2 has tangible benefits for project 
maintainers.

> The point of all that being, you _do_ believe 
> in enforcing restrictions or you wouldn't like the GPL v2.
>
> So you draw the line of "fairness" and belief that people will
> do-the-right-thing somewhere short of the BSD license.  Why is it
> so hard then to accept that the FSF draws the line short of the
> GPLv2 after having gained practical experience with it
> since its release?

Nobody objects to the FSF putting out new licenses if it changes its mind 
about what it wants to do.  They object to it pestering those of us 
continuing to use the old license because we prefer it to the new one.

The FSF _does_ draw the line in a different place than the Linux developers.  
Hence the Linux developers don't want to use the new license, they prefer the 
old one from back before Stallman went insane.  They have that right, and 
Stallman trying to deny them that right in the name of "freedom" is deeply 
ironic.

> You can argue till the cows come home the belief that _your_
> restrictions are more fair, moral and reasonable than theirs.

It's not the FSF's code being licensed.  It's the Linux developers' code being 
licensed.  The people who write the code get to choose the license.

> But at the end of the day it's all just a matter of opinion about
> what constitutes fair and reasonable.

Why is Linus's opinion less valuable than Stallman's when it comes to the 
license under which the project Linus founded, and which Linus still 
maintains, is distributed?

> You think its a fair trade 
> that you get code back, the FSF think its fair that people can hack
> and run the code anywhere its used..  It all comes down to the
> author of the code getting to attach whatever restrictions they
> choose.

Exactly.  And Linus likes GPLv2.  As do I.

> Sean

Rob
