Return-Path: <linux-kernel-owner+w=401wt.eu-S932920AbXBKXkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920AbXBKXkL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 18:40:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932922AbXBKXkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 18:40:11 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:54423 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932920AbXBKXkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 18:40:09 -0500
Subject: Re: NAK new drivers without proper power management?
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>
In-Reply-To: <200702120029.23657.rjw@sisk.pl>
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no>
	 <200702110144.17783.rjw@sisk.pl>
	 <1171233655.4493.78.camel@nigel.suspend2.net>
	 <200702120029.23657.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 12 Feb 2007 10:40:08 +1100
Message-Id: <1171237208.4493.139.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, 2007-02-12 at 00:29 +0100, Rafael J. Wysocki wrote:
> > On Sun, 2007-02-11 at 01:44 +0100, Rafael J. Wysocki wrote:
> > > > Well, it's probably more acceptable than silently doing nothing and the 
> > > > device failing or locking up the machine on resume, but I couldn't agree 
> > > > more that it's not what we want to be encouraging. Perfect may be the 
> > > > enemy of the good, but "works except no power management" is hardly what 
> > > > I would call good these days, more like pretty sloppy..
> > > 
> > > I think there are situations in which it can be justified, like:
> > > - The driver is not entirely finished, but we want to merge it early, because
> > > of many potential users,
> > > - The driver has only a few users who aren't interested in the suspend/resume
> > > functionality,
> > 
> > How do you determine that? How many users have to want suspend/resume
> > functionality before you say "Ok. It has to be done now"?
> 
> That depends on what the driver author tells us.  If he says there's only one
> such device in the world and it needs a Linux drivers, but the system in
> question will never be suspended, that will be fine, I think.  There are such
> cases already and I see no reason why there won't be any more in the future.
> 
> > > - The device is undocumented and we don't know how to make it handle the
> > > suspend/resume (we may learn that in the future or not).
> > 
> > If we know how to initialise/cleanup, we know a good portion of what is
> > needed for suspend/resume. Sure, for some video chipsets, you need more
> > (you need to know how to reprogram the whole thing after S3), but
> > they're the exception. Yes, there are other cases. But on the whole,
> > we're not talking about esoteric knowledge.
> 
> No, in general this is not _that_ simple.  Please browse the archives of
> bcm43xx-dev, for example.

Yeah. The problems of not having documentation + having to reassociate
and so on.

> While I agree that the support for suspend and resume _is_ generally important,
> I also admit that there are situations in which it doesn't matter and there are
> many people who won't care a whit for it.

Ok, but that's the exception, right? Not the rule? So in those cases, an
exception is made.

Regards,

Nigel

