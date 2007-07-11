Return-Path: <linux-kernel-owner+w=401wt.eu-S1763394AbXGKMad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763394AbXGKMad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 08:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759057AbXGKMa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 08:30:26 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:54335 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757498AbXGKMaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 08:30:25 -0400
To: rjw@sisk.pl
CC: miklos@szeredi.hu, nigel@nigel.suspend2.net, a1426z@gawab.com,
       jeremy@goop.org, jbms@cmu.edu, pavel@ucw.cz, nickpiggin@yahoo.com.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-reply-to: <200707111427.27598.rjw@sisk.pl>
Subject: Re: Hibernation Redesign
References: <200707081737.21932.a1426z@gawab.com> <200707112200.43613.nigel@nigel.suspend2.net> <E1I8b0l-0000DB-00@dorka.pomaz.szeredi.hu> <200707111427.27598.rjw@sisk.pl>
Message-Id: <E1I8bKJ-0000IO-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 11 Jul 2007 14:29:51 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > Freezing of tasks is slowing down suspend.  Don't know how serious
> > > > this is, suspend is pretty fast, but could possibly be even faster.
> > > 
> > > It's FUD. Freezing of tasks normally takes next to no time. I've never 
> > > understood the rediculously long timeout it has. If freezing succeeds, all 
> > > processes are frozen within 1/2 a second tops. If it fails, nothing is going 
> > > to change in the following 19.5 seconds (or whatever it is if I don't 
> > > remember the value properly).
> > 
> > Right.  The 20s timeout is again a sign of brokenness.
> 
> Are you still serious?
> 
> > If we expect something to fail, it should fail immediately, without
> > waiting for arbitrary timeouts.
> 
> I don't agree.  If you think so, then please tell me what the softlockup
> infrastructure is for.
> 
> > And if we don't expect it to fail, why the timeout?
> 
> We know that it can fail, so we use the timeout to detect failures.
>  
> > Of course we know it can fail (network problems, etc), so it's wrong
> > whatever way we look at it.
> 
> Are you trying to say that whatever can fail is wrong?

No. Sorry about the sloppy sentence.

What I was trying to say, is that if we _know_ that the suspend can
fail, it is wrong to have a timeout to determine that it will fail.

Miklos
