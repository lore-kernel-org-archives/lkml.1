Return-Path: <linux-kernel-owner+w=401wt.eu-S1758064AbZBKRb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064AbZBKRb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 12:31:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755059AbZBKRbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 12:31:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40796 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753193AbZBKRbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 12:31:46 -0500
Date: Wed, 11 Feb 2009 18:31:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>, Tony Luck <tony.luck@intel.com>,
       Mike Travis <travis@sgi.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/8] git pull request for tip/tracing/core
Message-ID: <20090211173131.GA27546@elte.hu>
References: <20090208054955.777429253@goodmis.org> <20090209093751.GD7930@elte.hu> <20090211153650.GA19576@elte.hu> <alpine.DEB.1.10.0902111147450.15438@gandalf.stny.rr.com> <alpine.DEB.1.10.0902111158380.15438@gandalf.stny.rr.com> <20090211171622.GA13239@elte.hu> <alpine.DEB.1.10.0902111227570.15438@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902111227570.15438@gandalf.stny.rr.com>
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

> On Wed, 11 Feb 2009, Ingo Molnar wrote:
> > > 
> > > I just looked at alpha and arm, I'm now looking at ia64. And this could
> > > be an issue, since it has 14 bits for hard irqs.
> > > 
> > > What would be the impact to make the preempt count a long?
> > 
> > Assembly code has to be audited i guess, whether it's treated as an int anywhere. 
> > Should work i guess.
> 
> Before we go and make the change, Peter brought up a good point on IRC. Is 
> there any reason that ia64 needs 1 << 14 IRQs?  That's 16384!
> 
> Perhaps the better solution wolud be (if possible), to simply lower the 
> number of bits.

i'm the wrong person to be asked about that. (Cc:-ed the right people)

	Ingo
