Return-Path: <linux-kernel-owner+w=401wt.eu-S1763721AbZEHVEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763721AbZEHVEQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 17:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764090AbZEHVDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 17:03:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47307 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764022AbZEHVDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 17:03:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Date: Fri, 8 May 2009 23:03:01 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: nigel@tuxonice.net, Pavel Machek <pavel@ucw.cz>,
       linux-pm@lists.linux-foundation.org, tuxonice-devel@lists.tuxonice.net,
       linux-kernel@vger.kernel.org
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <1241746459.19600.246.camel@nigel-laptop> <200905082144.57955.bzolnier@gmail.com>
In-Reply-To: <200905082144.57955.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905082303.02677.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 May 2009, Bartlomiej Zolnierkiewicz wrote:
> On Friday 08 May 2009 03:34:19 Nigel Cunningham wrote:
> > Hi.
> > 
> > On Thu, 2009-05-07 at 23:51 +0200, Pavel Machek wrote:
> > > On Thu 2009-05-07 19:42:54, Rafael J. Wysocki wrote:
> > > > On Thursday 07 May 2009, Pavel Machek wrote:
> > > > > Hi!
> > > > > 
> > > > > > I'd like to submit TuxOnIce for review, with a view to seeking to get it
> > > > > > merged, perhaps in 2.6.31 or .32 (depending upon what needs work before
> > > > > > it can be merged) and the willingness of those who matter.
> > > ...
> > > > > To summarise disadvantages:
> > > > > 
> > > > > - only core has 8000 LoC
> > > > > - it does stuff that can be easily done in userspace
> > > > >      (and that todays distros _do_ in userspace).
> > > > > - it duplicates uswsusp functionality.
> > > > > - compared to [u]swsusp, it received little testing
> > > > 
> > > > Actually, I see advantages of working together versus fighting flame wars.
> > > > Please stop that, I'm not going to take part in it this time.
> > > 
> > > Ok, so what do you propose? Merging tuxonice into 2.6.32, resulting in
> > > having swsusp,uswsusp *and* tuxonice to maintain? I hope not.
> > > 
> > > If we are talking about improving mainline to allow tuxonice
> > > functionality... then yes, that sounds reasonable.
> > 
> > I'd like to see use have all three for one or two releases of vanilla,
> > just to give time to work out any issues that haven't been foreseen.
> > Once we're all that there are confident there are no regressions with
> > TuxOnIce, I'd remove swsusp. That's my ideal plan of attack.
> 
> Please proceed to Plan B then.
> 
> Adding third core code framework to do the same thing is out of question
> (probably same should have been said about adding second one in the past).
> 
> Moreover you will for sure hit much more regressions than you expect
> (I "love" seeing over and over again when people/companies get trapped
> into fallacy of superiority of their _own_ solution).
> 
> I really wouldn't consider teaming with Rafael to work on "swsuspOnTux"
> (evolving the in-kernel code while re-using chunks of TuxOnIce code) as
> a bad Plan B.  It has the potential of resulting in a solution clearly
> superior to all existing ones (TuxOnIce included).

Thanks for saying this Bart!  That also is my point, I think we can create a
hibernation implementation which is clearly better than all we have right now
by joining forces without the "my code is *so* much better than yours" kind of
argumentation.

Also, I think we should aim at targets that are possible to achieve.  Namely,
it is clear to me that various parts of TuxOnIce will have to be reviewed and
commented by the memory management people, the file systems people, the
architecture-dependent code maintainers and so on, and it is much easier to
get someone to have a look at a relatively short series of patches doing one
specific thing at a time than to have him review an entire subsystem.

Best,
Rafael
