Return-Path: <linux-kernel-owner+w=401wt.eu-S934260AbZDHQOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934260AbZDHQOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 12:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934277AbZDHQOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 12:14:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40370 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934273AbZDHQOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 12:14:20 -0400
Date: Wed, 8 Apr 2009 18:13:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] kbuild: work around distcc/icecc madness
Message-ID: <20090408161344.GF16759@elte.hu>
References: <alpine.LFD.2.00.0903192121300.29264@localhost.localdomain> <20090320092234.GA3792@elte.hu> <alpine.LFD.2.00.0903201127360.29264@localhost.localdomain> <20090320185917.GB6224@elte.hu> <alpine.LFD.2.00.0903202010250.29264@localhost.localdomain> <20090320193334.GA19501@elte.hu> <alpine.LFD.2.00.0903202123310.29264@localhost.localdomain> <20090321141800.GB22029@elte.hu> <alpine.LFD.2.00.0904022327540.12916@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904022327540.12916@localhost.localdomain>
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Sat, 21 Mar 2009, Ingo Molnar wrote:
> > 
> > I'll try to reproduce it once more and see what's going on.
> 
> It'd be nice if you could spare some time and try to figure out 
> what's going on. Everytime I forget to apply that patch to one of 
> my trees I run into random full kernel rebuilds, which becomes 
> pretty annoying. Especially when I try to reproduce some user 
> problem with the users's config which is usually based on some 
> distro config + some random changes (i.e. builds every random 
> driver and some more).

sure - queued it up in tip:out-of-tree and will yell once i see it 
break again.

	Ingo
