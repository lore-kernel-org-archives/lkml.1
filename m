Return-Path: <linux-kernel-owner+w=401wt.eu-S1765050AbYARVKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765050AbYARVKB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 16:10:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761375AbYARVJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 16:09:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55634 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759708AbYARVJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 16:09:53 -0500
Date: Fri, 18 Jan 2008 22:09:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matt Mackall <mpm@selenic.com>
Cc: Michael Opdenacker <michael-lists@free-electrons.com>,
       linux-kernel@vger.kernel.org, Linux-tiny@selenic.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: fix unconditional
	arch/x86/kernel/pcspeaker.c?compiling
Message-ID: <20080118210938.GE10717@elte.hu>
References: <1200590031.5332.19.camel@cinder.waste.org> <200801172315.29976.michael-lists@free-electrons.com> <20080118110252.GA17397@elte.hu> <47909821.1090907@free-electrons.com> <20080118122540.GH11044@elte.hu> <20080118122926.GA15216@elte.hu> <4790A385.800@free-electrons.com> <1200664214.4001.24.camel@cinder.waste.org> <4790D3E3.4060409@free-electrons.com> <1200676219.3835.8.camel@cinder.waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200676219.3835.8.camel@cinder.waste.org>
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

> > Sounds fine! Don't hesitate to let us know about the lower-hanging 
> > fruit you're thinking about. Here are the main things I have so far:
> > 
> >     * Ideas in the existing Linux-Tiny patchset.
> >     * Disable support for non-Intel processors in x86 (cyrix.c,
> >       centaur.c, transmeta.c, nexgen.c, umc.c in arch/x86/kernel/cpu).
> >       As far as I remember, I saved 15 KB when I first experimented with
> >       this).
> 
> Isn't that already in -tiny?

btw., are there any pending arch/x86 bits in -tiny? (stupid question: 
were can i get the most uptodate version of -tiny from?)

	Ingo
