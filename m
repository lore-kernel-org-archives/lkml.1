Return-Path: <linux-kernel-owner+w=401wt.eu-S1752157AbYIWMIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbYIWMIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 08:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbYIWMH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 08:07:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37220 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbYIWMH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 08:07:59 -0400
Date: Tue, 23 Sep 2008 14:07:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Steigerwald <ms@teamix.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] CFS scheduler: documentation about scheduling policies
Message-ID: <20080923120741.GA1077@elte.hu>
References: <200809231101.41624.ms@teamix.de> <200809231348.50834.ms@teamix.de> <20080923115045.GG14840@elte.hu> <200809231401.23432.ms@teamix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809231401.23432.ms@teamix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Martin Steigerwald <ms@teamix.de> wrote:

> Am Dienstag, 23. September 2008 schrieb Ingo Molnar:
> > * Martin Steigerwald <ms@teamix.de> wrote:
> > > > please use -p1 to create patches - or since you've just set up the
> > > > tip/master tracking, do something like:
> > >
> > > Okay, lets see how this works out.
> > >
> > > ---
> > > From a57581d4ec3b13f63920b89c336ac9c93c6cf9f0 Mon Sep 17 00:00:00 2001
> > > From: Martin Steigerwald <ms@teamix.de>
> > > Date: Tue, 23 Sep 2008 13:45:46 +0200
> > > Subject: [PATCH] CFS: Documentation about scheduling policies
> >
> > Applied to tip/sched/devel, merged it into tip/master and pushed the
> > result out - thanks Martin.
> >
> > this was a perfect patch :)
> 
> Thanks. Now I can learn how I can update my local tip-master ;-). 
> Hmmm, git pull seemed to do the trick although it did not touch 
> Documentation/scheduler/sched-design-CFS.txt again. Seems it detected 
> that I applied the patch I sent you already.

yes.

the best way to update is to have tip as a remote and to update via 'git 
remote update'. Then you can do "git merge tip/master" - or if this does 
not work (tip/master is an integration branch and has to be reset 
occasionally) then you can do a 'git-reset --hard tip/master' to switch 
over to the new tree.

NOTE: a hard reset means you'll lose local commits. If you want to carry 
them over then do something like:

 git rebase -i --onto tip/master 123412341234

where 123412341234 is the sha1 of the previous tip/master you based your 
local changes on.

> Will it be in 2.6.28 or even in 2.6.27? 8-)

yes, it's queued up for v2.6.28. For v2.6.27 we [in -tip] dont do 
documentation updates starting at around -rc4 or so (to reduce the 
upstream churn).

> Looking forward to further documentation patches - these can't break 
> any code ;-).

definitely ;-)

	Ingo
