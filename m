Return-Path: <linux-kernel-owner+w=401wt.eu-S1754282AbYECThl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbYECThl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 15:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbYECThU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 15:37:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60143 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643AbYECThT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 15:37:19 -0400
Date: Sat, 3 May 2008 21:37:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: a.p.zijlstra@chello.nl, efault@gmx.de, elendil@planet.nl,
       parag.warudkar@gmail.com, linux-kernel@vger.kernel.org,
       guichaz@yahoo.fr, andi@firstfloor.org
Subject: Re: 'global' rq->clock
Message-ID: <20080503193701.GA25097@elte.hu>
References: <20080503082849.GA29605@elte.hu> <20080503.020502.226847930.davem@davemloft.net> <20080503101016.GA18801@elte.hu> <20080503.122734.01023096.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080503.122734.01023096.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Sat, 3 May 2008 12:10:16 +0200
> 
> > ( although please note that the growing generalization that goes on
> >   _did_ find a subtle nohz problem on sparc64 early in the merge 
> >   window, so it's not like these changes are totally useless to you. 
> >   )
> 
> Note that this bug theoretically exists on every platform, even x86, 
> and only sparc64 is fixed at the moment by adding the 
> irq_{entry,exit}() guards around all of it's IPI handlers.
> 
> Just a reminder.

yeah, indeed - it's masked on x86 by the suckiness of most clockevents 
hw timers. We dont get unlimited sleep time like sparc64 does :-/

	Ingo
