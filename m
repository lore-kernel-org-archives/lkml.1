Return-Path: <linux-kernel-owner+w=401wt.eu-S1756317AbYKTTVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317AbYKTTVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 14:21:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbYKTTU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 14:20:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33292 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753859AbYKTTU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 14:20:57 -0500
Date: Thu, 20 Nov 2008 20:20:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@ozlabs.org,
       Milton Miller <miltonm@bga.com>, Matt Fleming <mjf@gentoo.org>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 0/5] powerpc: dynamic ftrace port
Message-ID: <20081120192009.GE3955@elte.hu>
References: <20081120190948.057007623@goodmis.org> <alpine.DEB.1.10.0811201412230.3378@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811201412230.3378@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 20 Nov 2008, Steven Rostedt wrote:
> > 
> >  1) I removed the changes to recordmcount.pl.  This is not a PowerPC
> >     change, although PowerPC needs it for dynamic ftrace. But
> >     the changes here can go via linux-tip.
> 
> Ingo,
> 
> I found that the recordmcount.pl change conflicts with a commit in 
> linux-next, which is not in tip nor mainline. The commit is:
> 
>    11ebca4a3f8337de2f4d1300bd307851d1191d53
>    sh: dynamic ftrace support.
> 
> Seems that this change came in through the sh repo. I have already 
> resolved the conflicts with my updates for PowerPC with this commit. 
> I can put this in a separate branch against linux-next if you like.
> 
> I would like to get the changes to recordmcount.pl for PowerPC in 
> linux-next soon, so I can also add a small clean up of this code. 
> Jim Radfort has some updates as well for his port to arm.

Could you please extract the sh bits from 11ebca4a so that we can 
apply it to tip/tracing/* standalone? It makes sense to carry it 
without having the other bits of the SH changes.

It will collide in linux-next but it will be a same-content collision 
with an easy enough (perhaps even automatic) resolution.

	Ingo
