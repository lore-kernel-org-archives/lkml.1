Return-Path: <linux-kernel-owner+w=401wt.eu-S1758666AbZCUOSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666AbZCUOSt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 10:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754196AbZCUOSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 10:18:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40544 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914AbZCUOSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 10:18:39 -0400
Date: Sat, 21 Mar 2009 15:18:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] kbuild: work around distcc/icecc madness
Message-ID: <20090321141800.GB22029@elte.hu>
References: <alpine.LFD.2.00.0903192121300.29264@localhost.localdomain> <20090320092234.GA3792@elte.hu> <alpine.LFD.2.00.0903201127360.29264@localhost.localdomain> <20090320185917.GB6224@elte.hu> <alpine.LFD.2.00.0903202010250.29264@localhost.localdomain> <20090320193334.GA19501@elte.hu> <alpine.LFD.2.00.0903202123310.29264@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903202123310.29264@localhost.localdomain>
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

> On Fri, 20 Mar 2009, Ingo Molnar wrote:
> > i dont do anything weird. i use:
> > 
> > CROSS_COMPILE='distcc 
> > /opt/crosstool/gcc-4.2.2-glibc-2.3.6/i686-unknown-linux-gnu/bin/i686-unknown-linux-gnu-'
> > 
> > host compiler was never supposed to be the same in terms of 
> > capability as target compiler.
> 
> Hmm. Then something else is going wrong. The kernel build system 
> checks the target compiler not the host one.
> 
> Is your distcc setup using the same compilers on all your machines 
> in the build cluster ?

yes - i have versions hardcoded via absolute pathnames like above, 
and each distcc node has the exact same layout as above. (and it's 
hard to mess up explicit versions like that)

I'll try to reproduce it once more and see what's going on.

	Ingo
