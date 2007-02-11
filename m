Return-Path: <linux-kernel-owner+w=401wt.eu-S932915AbXBKXcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915AbXBKXcW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 18:32:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932914AbXBKXcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 18:32:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39437 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932821AbXBKXcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 18:32:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@nigel.suspend2.net
Subject: Re: NAK new drivers without proper power management?
Date: Mon, 12 Feb 2007 00:29:22 +0100
User-Agent: KMail/1.9.5
Cc: Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no> <200702110144.17783.rjw@sisk.pl> <1171233655.4493.78.camel@nigel.suspend2.net>
In-Reply-To: <1171233655.4493.78.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702120029.23657.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 11 February 2007 23:40, Nigel Cunningham wrote:
> Hi.
> 
> On Sun, 2007-02-11 at 01:44 +0100, Rafael J. Wysocki wrote:
> > > Well, it's probably more acceptable than silently doing nothing and the 
> > > device failing or locking up the machine on resume, but I couldn't agree 
> > > more that it's not what we want to be encouraging. Perfect may be the 
> > > enemy of the good, but "works except no power management" is hardly what 
> > > I would call good these days, more like pretty sloppy..
> > 
> > I think there are situations in which it can be justified, like:
> > - The driver is not entirely finished, but we want to merge it early, because
> > of many potential users,
> > - The driver has only a few users who aren't interested in the suspend/resume
> > functionality,
> 
> How do you determine that? How many users have to want suspend/resume
> functionality before you say "Ok. It has to be done now"?

That depends on what the driver author tells us.  If he says there's only one
such device in the world and it needs a Linux drivers, but the system in
question will never be suspended, that will be fine, I think.  There are such
cases already and I see no reason why there won't be any more in the future.

> > - The device is undocumented and we don't know how to make it handle the
> > suspend/resume (we may learn that in the future or not).
> 
> If we know how to initialise/cleanup, we know a good portion of what is
> needed for suspend/resume. Sure, for some video chipsets, you need more
> (you need to know how to reprogram the whole thing after S3), but
> they're the exception. Yes, there are other cases. But on the whole,
> we're not talking about esoteric knowledge.

No, in general this is not _that_ simple.  Please browse the archives of
bcm43xx-dev, for example.

While I agree that the support for suspend and resume _is_ generally important,
I also admit that there are situations in which it doesn't matter and there are
many people who won't care a whit for it.

Greetings,
Rafael 
