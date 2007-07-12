Return-Path: <linux-kernel-owner+w=401wt.eu-S935723AbXGLWO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935723AbXGLWO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 18:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755828AbXGLWOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 18:14:49 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:44726 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755592AbXGLWOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 18:14:48 -0400
To: pavel@ucw.cz
CC: miklos@szeredi.hu, nigel@nigel.suspend2.net, rjw@sisk.pl, a1426z@gawab.com,
       jeremy@goop.org, jbms@cmu.edu, nickpiggin@yahoo.com.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-reply-to: <20070712091553.GC1866@elf.ucw.cz> (message from Pavel Machek on
	Thu, 12 Jul 2007 11:15:53 +0200)
Subject: Re: Hibernation Redesign
References: <200707081737.21932.a1426z@gawab.com> <200707111350.41806.rjw@sisk.pl> <E1I8amY-00009H-00@dorka.pomaz.szeredi.hu> <200707112200.43613.nigel@nigel.suspend2.net> <E1I8b0l-0000DB-00@dorka.pomaz.szeredi.hu> <20070712091553.GC1866@elf.ucw.cz>
Message-Id: <E1I96uz-0005Bl-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 13 Jul 2007 00:13:49 +0200
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
> Well, "scenario 1/2 - simple/tricky deadlock" is a sign of brokenness,
> too.

Sure.  But that one hasn't generated a single bug report (and never
will), because it's so insanely difficult to produce, even if one
explicitly wants to do that.  It will just never happen accidentally.

And even if it happens, there's absolutely no side affects on the rest
of the system.  You managed to make a process not react to SIGKILL,
well hurray.  You can do that more easily with ptrace().

Miklos
