Return-Path: <linux-kernel-owner+w=401wt.eu-S1763390AbZEHOMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763390AbZEHOMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 10:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758219AbZEHOMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 10:12:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45415 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029AbZEHOMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 10:12:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@tuxonice.net
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Date: Fri, 8 May 2009 16:11:41 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <20090507215112.GC14611@elf.ucw.cz> <1241746459.19600.246.camel@nigel-laptop>
In-Reply-To: <1241746459.19600.246.camel@nigel-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905081611.41865.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 May 2009, Nigel Cunningham wrote:
> Hi.
> 
> On Thu, 2009-05-07 at 23:51 +0200, Pavel Machek wrote:
> > On Thu 2009-05-07 19:42:54, Rafael J. Wysocki wrote:
> > > On Thursday 07 May 2009, Pavel Machek wrote:
> > > > Hi!
> > > > 
> > > > > I'd like to submit TuxOnIce for review, with a view to seeking to get it
> > > > > merged, perhaps in 2.6.31 or .32 (depending upon what needs work before
> > > > > it can be merged) and the willingness of those who matter.
> > ...
> > > > To summarise disadvantages:
> > > > 
> > > > - only core has 8000 LoC
> > > > - it does stuff that can be easily done in userspace
> > > >      (and that todays distros _do_ in userspace).
> > > > - it duplicates uswsusp functionality.
> > > > - compared to [u]swsusp, it received little testing
> > > 
> > > Actually, I see advantages of working together versus fighting flame wars.
> > > Please stop that, I'm not going to take part in it this time.
> > 
> > Ok, so what do you propose? Merging tuxonice into 2.6.32, resulting in
> > having swsusp,uswsusp *and* tuxonice to maintain? I hope not.
> > 
> > If we are talking about improving mainline to allow tuxonice
> > functionality... then yes, that sounds reasonable.
> 
> I'd like to see use have all three for one or two releases of vanilla,
> just to give time to work out any issues that haven't been foreseen.
> Once we're all that there are confident there are no regressions with
> TuxOnIce, I'd remove swsusp. That's my ideal plan of attack.

So this is an idea to replace our current hibernation implementation with
TuxOnIce.

Which unfortunately I don't agree with.

I think we can get _one_ implementation out of the three, presumably keeping
the user space interface that will keep the current s2disk binaries happy, by
merging TuxOnIce code _gradually_.  No "all at once" approach, please.

And by "merging" I mean _exactly_ that.  Not adding new code and throwing
away the old one.

While I can work on creating one hibernation implementation by taking the
best ideas from all of the implementation we have at hand, I surely won't be
working on replacing our current code with TuxOnIce.  If that disappoints you,
then I'm sorry.

Best,
Rafael
