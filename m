Return-Path: <linux-kernel-owner+w=401wt.eu-S1756708AbYAIAQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbYAIAQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 19:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbYAIAQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 19:16:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39945 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbYAIAQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 19:16:16 -0500
Date: Wed, 9 Jan 2008 01:15:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Rik van Riel <riel@redhat.com>,
       Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com,
       Linux Kernel <linux-kernel@vger.kernel.org>, trivial@kernel.org
Subject: Re: [PATCH 3/5] x86: coding style fixes in
	arch/x86/ia32/ia32_aout.c
Message-ID: <20080109001555.GA31289@elte.hu>
References: <20080108203233.01bb5c7f@paolo-desktop> <20080108150439.6388028e@bree.surriel.com> <20080108215247.GE14829@elte.hu> <20080108221722.GA27698@uranus.ravnborg.org> <20080108223554.GE21482@elte.hu> <20080108235719.GA28353@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108235719.GA28353@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> > > > Firstly, anyone with a forked kernel with outstanding patches 
> > > > that are not in x86.git only has themselves to blame. We want to 
> > > > actively discourage forking and sitting on patches too long.
> > > 
> > > Curious - what is the purpose of the x86.git tree these days?
> > 
> > what do want to imply by 'these days'?
> 
> I wondered when you wrote "anyone with a forked kernel with 
> outstanding patches that are not in x86.git" if this was only x86 
> specific patches or more than that. I could have a slev of patches in 
> the works for parts that are no x86 specific (which I unfortunately do 
> not have).

ah, i now understand what you mean. The stuff in -mm that touches 
arch/x86 is for actively maintained areas which are generally quite 
clean.

So this is not a problem in practice - massively unclean areas of code, 
which are the primary target for cleanups, are not actively developed. [ 
perhaps because there's some level of correlation between unclean code 
and lack of developer interest :-/ ]

	Ingo
