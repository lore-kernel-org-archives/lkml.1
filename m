Return-Path: <linux-kernel-owner+w=401wt.eu-S1761869AbYARN5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761869AbYARN5o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 08:57:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758866AbYARN5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 08:57:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45056 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757491AbYARN5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 08:57:36 -0500
Date: Fri, 18 Jan 2008 14:57:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matt Mackall <mpm@selenic.com>
Cc: Michael Opdenacker <michael-lists@free-electrons.com>,
       linux-kernel@vger.kernel.org, Linux-tiny@selenic.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: fix unconditional
	arch/x86/kernel/pcspeaker.c?compiling
Message-ID: <20080118135704.GB12702@elte.hu>
References: <200801171643.49301.michael-lists@free-electrons.com> <478F8AEC.1080209@free-electrons.com> <1200590031.5332.19.camel@cinder.waste.org> <200801172315.29976.michael-lists@free-electrons.com> <20080118110252.GA17397@elte.hu> <47909821.1090907@free-electrons.com> <20080118122540.GH11044@elte.hu> <20080118122926.GA15216@elte.hu> <4790A385.800@free-electrons.com> <1200664214.4001.24.camel@cinder.waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200664214.4001.24.camel@cinder.waste.org>
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


* Matt Mackall <mpm@selenic.com> wrote:

> > I can propose a corresponding patch, and I'd suggest to make 
> > CONFIG_PCSPEAKER depend on CONFIG_EMBEDDED.
> 
> No, don't. It's fine the way it is. If INPUT_PCSPKR isn't set, we 
> don't support the speaker, end of story.

yeah.

> Also, bear in mind that there is a fair amount of lower-hanging fruit 
> than this, so bouncing a bunch of patches back and forth to make this 
> perfect is not the best use of people's time.

as long as it's arch/x86 stuff i can pick up patches no problem.

[ Sidenote: "too small" and "too insignificant" is not a patch attribute
  that is in my vocabulary - by definition the best patches are very
  small and very insignificant (they just happen to end up doing
  something cool a 1000 steps later ;-) 99% of our problems come from
  'too large' and 'too intrusive' patches. ]

	Ingo
