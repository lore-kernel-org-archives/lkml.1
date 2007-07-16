Return-Path: <linux-kernel-owner+w=401wt.eu-S1764217AbXGPL6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764217AbXGPL6B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 07:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757180AbXGPL5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 07:57:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34346 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755621AbXGPL5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 07:57:52 -0400
Date: Mon, 16 Jul 2007 13:57:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH/RFC] msleep() with hrtimers
Message-ID: <20070716115744.GA14131@elte.hu>
References: <19044.1184539364@lwn.net> <Pine.LNX.4.64.0707161325040.1818@scrub.home> <20070716114734.GA12010@elte.hu> <Pine.LNX.4.64.0707161353350.1818@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707161353350.1818@scrub.home>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Roman Zippel <zippel@linux-m68k.org> wrote:


> > > One possible problem here is that setting up that timer can be 
> > > considerably more expensive, for a relative timer you have to read 
> > > the current time, which can be quite expensive (e.g. your machine 
> > > now uses the PIT timer, because TSC was deemed unstable).
> >
> > i dont think there's any significant overhead. The OLPC folks are 
> > pretty sensitive to performance, so if there was any genuine 
> > measurable overhead due to this, i'd expect them to report it. And 
> > even if there _was_ overhead, it would be well worth its price, the 
> > legacies of HZ are clearly biting the OLPC project here. The sooner 
> > we get rid of HZ dependencies and HZ artifacts, the better.
>
> How is a sleep function relevant to performace?

i'm not sure how your question relates/connects to what i wrote above, 
could you please re-phrase your question into a bit more verbose form so 
that i can answer it? Thanks,

	Ingo
