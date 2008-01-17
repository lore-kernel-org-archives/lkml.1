Return-Path: <linux-kernel-owner+w=401wt.eu-S1758694AbYAQWY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758694AbYAQWY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:24:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755960AbYAQWYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:24:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34426 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754876AbYAQWYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:24:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@nigel.suspend2.net
Subject: Re: echo mem > /sys/power/state
Date: Thu, 17 Jan 2008 23:27:13 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, Zan Lynx <zlynx@acm.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org
References: <20080116222445.6f7ff66e.akpm@linux-foundation.org> <200801172238.17176.rjw@sisk.pl> <478FCC90.60605@nigel.suspend2.net>
In-Reply-To: <478FCC90.60605@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801172327.13961.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 17 of January 2008, Nigel Cunningham wrote:
> Hi.
> 
> Rafael J. Wysocki wrote:
> > On Thursday, 17 of January 2008, Andrew Morton wrote:
> >> On Thu, 17 Jan 2008 10:36:51 -0700 Zan Lynx <zlynx@acm.org> wrote:
> >>
> >>> On Wed, 2008-01-16 at 22:24 -0800, Andrew Morton wrote:
> >>>> So I take everyone's latest and greatest product and injudiciously type the
> >>>> above command.  The result five minutes later is at
> >>>> http://userweb.kernel.org/~akpm/borkage.jpg.  See if you can count all the bugs.
> >>>>
> >>>> Sorry, but I've had it with this stuff and I'm tired of fixing everyone else's
> >>>> stuff.  I'm just going to ship it.  Good luck.
> >>> Heh.  Laptop suspend to anything has been so broken for so long in the
> >>> -mm series on my Compaq R3000 that I didn't even know it was ever
> >>> supposed to work.
> >> It gets broken more often than anything else.  I do test each release on
> >> two laptops and I get to do a lot of bisection searching and
> >> grumpygramming as a result.
> >>
> >> Probably it would be more efficient to have the people who wrote the code
> >> also test it.
> > 
> > Well, that would certainly help.
> > 
> > I do test all of my patches and generally all of the patches I sign off, but
> > surely that's not enough.
> 
> It is far too easy to take a cursory glance, say 'That looks okay' and
> move on to the next thing, isn't it? I was horrified when I saw the list
> of acks etc (including me) on the commit with the helper_unlock issue we
> just fixed. It's truly scary to think that none of us looked closely
> enough to pick that up at the time.

Well, the code in question was not in the patch, so if you didn't actually look
at the _patched_ kmod.c, you would have a little chance to spot it.  I
overlooked it, even though I did look at the patched file ...

Still, this particular problem hasn't been triggering it testing for quite some
time.

Greetings,
Rafael
