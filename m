Return-Path: <linux-kernel-owner+w=401wt.eu-S1762982AbXGKMK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762982AbXGKMK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 08:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756698AbXGKMKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 08:10:20 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:55425 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678AbXGKMKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 08:10:19 -0400
To: nigel@nigel.suspend2.net
CC: miklos@szeredi.hu, rjw@sisk.pl, a1426z@gawab.com, jeremy@goop.org,
       jbms@cmu.edu, pavel@ucw.cz, nickpiggin@yahoo.com.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-reply-to: <200707112200.43613.nigel@nigel.suspend2.net> (message from Nigel
	Cunningham on Wed, 11 Jul 2007 22:00:42 +1000)
Subject: Re: Hibernation Redesign
References: <200707081737.21932.a1426z@gawab.com> <200707111350.41806.rjw@sisk.pl> <E1I8amY-00009H-00@dorka.pomaz.szeredi.hu> <200707112200.43613.nigel@nigel.suspend2.net>
Message-Id: <E1I8b0l-0000DB-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 11 Jul 2007 14:09:39 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Freezing of tasks is slowing down suspend.  Don't know how serious
> > this is, suspend is pretty fast, but could possibly be even faster.
> 
> It's FUD. Freezing of tasks normally takes next to no time. I've never 
> understood the rediculously long timeout it has. If freezing succeeds, all 
> processes are frozen within 1/2 a second tops. If it fails, nothing is going 
> to change in the following 19.5 seconds (or whatever it is if I don't 
> remember the value properly).

Right.  The 20s timeout is again a sign of brokenness.

If we expect something to fail, it should fail immediately, without
waiting for arbitrary timeouts.

And if we don't expect it to fail, why the timeout?

Of course we know it can fail (network problems, etc), so it's wrong
whatever way we look at it.

Miklos
