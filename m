Return-Path: <linux-kernel-owner+w=401wt.eu-S1757202AbXGHSNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202AbXGHSNI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 14:13:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbXGHSM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 14:12:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36726 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551AbXGHSMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 14:12:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Sun, 8 Jul 2007 20:20:18 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>, Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Matthew Garrett <mjg59@srcf.ucam.org>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <Pine.LNX.4.44L0.0707071215140.19734-100000@netrider.rowland.org> <1183855362.3388.233.camel@localhost.localdomain>
In-Reply-To: <1183855362.3388.233.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707082020.19709.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 8 July 2007 02:42, Benjamin Herrenschmidt wrote:
> On Sat, 2007-07-07 at 12:17 -0400, Alan Stern wrote:
> > On Sat, 7 Jul 2007, Benjamin Herrenschmidt wrote:
> > 
> > > > > And guess what ? It's what we do on powerbooks, and it works fine,
> > > > > without a freezer :-)
> > 
> > > If you remember, one of the things I've been advocating has always been
> > > that we should put on hold all plug activity (unplug might be alright as
> > > long as the user events are just delayed) when we start suspending. No
> > > new devices, no new bindings. "hub" type devices are respondible for
> > > bringing in the new stuff after resume.
> > 
> > Which is exactly my point.  It _doesn't_ work fine without a freezer, 
> > because the USB stack currently relies on the freezer to prevent plug 
> > activity.
> 
> Putting on hold plug activity has nothing, NOTHING, to do with the half
> assed piece of deadlocking crap we have now we call a freezer.

Well, no matter how much bad names you will call it, that's what in use
right now and it's not _that_ easy to get rid of.

I'm perfectly fine with readying drivers etc. for dropping the freezer, but
in the meantime bugs in the freezer need to be fixed, if possible.

And if it deadlocks, there is a bug in it.

> As long as you guys keep mixing up all the issues and coming up with
> totally bogus solutions that cannot work, we won't have a useful suspend
> (either to RAM or to disk) in linux. 

Discussion at this level would be totally counterproductive and wouldn't lead
to anything constructive, so let me avoid commenting your abusive remarks.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
