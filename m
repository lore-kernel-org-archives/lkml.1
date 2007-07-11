Return-Path: <linux-kernel-owner+w=401wt.eu-S933156AbXGKU5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933156AbXGKU5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 16:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933151AbXGKU5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 16:57:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51708 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933142AbXGKU47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 16:56:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Hibernation Redesign
Date: Wed, 11 Jul 2007 23:04:26 +0200
User-Agent: KMail/1.9.5
Cc: nigel@nigel.suspend2.net, a1426z@gawab.com, jeremy@goop.org, jbms@cmu.edu,
       pavel@ucw.cz, nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <200707081737.21932.a1426z@gawab.com> <200707111427.27598.rjw@sisk.pl> <E1I8bKJ-0000IO-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1I8bKJ-0000IO-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707112304.28010.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 11 July 2007 14:29, Miklos Szeredi wrote:
> > > > > Freezing of tasks is slowing down suspend.  Don't know how serious
> > > > > this is, suspend is pretty fast, but could possibly be even faster.
> > > > 
> > > > It's FUD. Freezing of tasks normally takes next to no time. I've never 
> > > > understood the rediculously long timeout it has. If freezing succeeds, all 
> > > > processes are frozen within 1/2 a second tops. If it fails, nothing is going 
> > > > to change in the following 19.5 seconds (or whatever it is if I don't 
> > > > remember the value properly).
> > > 
> > > Right.  The 20s timeout is again a sign of brokenness.
> > 
> > Are you still serious?
> > 
> > > If we expect something to fail, it should fail immediately, without
> > > waiting for arbitrary timeouts.
> > 
> > I don't agree.  If you think so, then please tell me what the softlockup
> > infrastructure is for.
> > 
> > > And if we don't expect it to fail, why the timeout?
> > 
> > We know that it can fail, so we use the timeout to detect failures.
> >  
> > > Of course we know it can fail (network problems, etc), so it's wrong
> > > whatever way we look at it.
> > 
> > Are you trying to say that whatever can fail is wrong?
> 
> No. Sorry about the sloppy sentence.
> 
> What I was trying to say, is that if we _know_ that the suspend can
> fail, it is wrong to have a timeout to determine that it will fail.

Hmm, I'm not sure what you mean ...

If there are conditions in which it's not a good idea to hibernate (let's
consider hibernation only for clarity), I think we can use a timeout.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
