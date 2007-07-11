Return-Path: <linux-kernel-owner+w=401wt.eu-S1763354AbXGKMTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763354AbXGKMTw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 08:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762143AbXGKMTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 08:19:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49839 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760739AbXGKMTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 08:19:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Hibernation Redesign
Date: Wed, 11 Jul 2007 14:27:26 +0200
User-Agent: KMail/1.9.5
Cc: nigel@nigel.suspend2.net, a1426z@gawab.com, jeremy@goop.org, jbms@cmu.edu,
       pavel@ucw.cz, nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <200707081737.21932.a1426z@gawab.com> <200707112200.43613.nigel@nigel.suspend2.net> <E1I8b0l-0000DB-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1I8b0l-0000DB-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707111427.27598.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 11 July 2007 14:09, Miklos Szeredi wrote:
> > > Freezing of tasks is slowing down suspend.  Don't know how serious
> > > this is, suspend is pretty fast, but could possibly be even faster.
> > 
> > It's FUD. Freezing of tasks normally takes next to no time. I've never 
> > understood the rediculously long timeout it has. If freezing succeeds, all 
> > processes are frozen within 1/2 a second tops. If it fails, nothing is going 
> > to change in the following 19.5 seconds (or whatever it is if I don't 
> > remember the value properly).
> 
> Right.  The 20s timeout is again a sign of brokenness.

Are you still serious?

> If we expect something to fail, it should fail immediately, without
> waiting for arbitrary timeouts.

I don't agree.  If you think so, then please tell me what the softlockup
infrastructure is for.

> And if we don't expect it to fail, why the timeout?

We know that it can fail, so we use the timeout to detect failures.
 
> Of course we know it can fail (network problems, etc), so it's wrong
> whatever way we look at it.

Are you trying to say that whatever can fail is wrong?

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
