Return-Path: <linux-kernel-owner+w=401wt.eu-S1757262AbYFSAWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbYFSAWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 20:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754839AbYFSAWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 20:22:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40090 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754661AbYFSAWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 20:22:15 -0400
Date: Thu, 19 Jun 2008 02:21:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: arjan@linux.intel.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       tglx@linutronix.de, linville@tuxdriver.com, davej@redhat.com,
       gregkh@suse.de
Subject: Re: Oops report for the week preceding June 16th, 2008
Message-ID: <20080619002126.GA19724@elte.hu>
References: <20080617092023.GA20621@elte.hu> <20080617.022652.76635616.davem@davemloft.net> <20080617153356.GA3510@elte.hu> <20080617.145153.229833994.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080617.145153.229833994.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 17 Jun 2008 17:33:56 +0200
> 
> > v2.6.24 was no doubt a huge step in the right direction but it came 
> > too late and we are still suffering from the fallout today as we 
> > have not reached test cycle equilibrium yet: by the time mainline 
> > gets the patches a new large batch comes up, invalidating much of 
> > mainline's role and forcing distros to gamble with (much untested 
> > and thus detached from reality) experimental branches.
> > 
> > That's my main point: when we mess up and dont merge OSS driver code 
> > that was out there in time - and we messed up big time with wireless 
> > - we should admit the screwup and swallow the bitter pill.
> 
> Your point seems to be that, even though we've acknowledged and 
> entirely corrected the problem now, you still will whack us over the 
> head and complain because it took in your opinion too long to get to 
> that point.

from the discussion it was not at all clear to me that you appear to 
agree with me - all i saw really was that you tried to ridicule my 
position.

> How nice.  That makes the wireless folks feel great I imagine.

my only worry was about the current situation, which, according to 
kerneloops.org, with 17442 oopses reported against v2.6.25, isnt 
anything to feel too great about. (And that's not limited to wireless in 
any way - there is a rather prominent tick_broadcast_oneshot_control() 
soft lockup entry as well that we are trying to figure out.)

It will all get better i'm sure - we now finally have objective 
visibility of bugs as they happen to users.

	Ingo
