Return-Path: <linux-kernel-owner+w=401wt.eu-S1761197AbXIJT3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761197AbXIJT3y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 15:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758681AbXIJT3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 15:29:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53386 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757252AbXIJT3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 15:29:35 -0400
Date: Mon, 10 Sep 2007 21:29:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, Andi Kleen <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       kbuild devel <kbuild-devel@lists.sourceforge.net>
Subject: Re: [RFC] kbuild - introduce vdir to make life easier for x86_64
Message-ID: <20070910192920.GA2080@elte.hu>
References: <20070910191138.GA31541@uranus.ravnborg.org> <1189452121.25767.42.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1189452121.25767.42.camel@chaos>
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Mon, 2007-09-10 at 21:11 +0200, Sam Ravnborg wrote:
> > One of the complaints raised about the current x86_64 Makfiles are 
> > the ugliness needed to reuse code from i386. Andi asked me if we 
> > could do something in kbuild to make this less ugly and below are 
> > the hack I could come up with.
> 
> while in general this is definitely a nice change, it does not really 
> solve the real problem of code scattered across two architectures. The 
> Makefile polishing is the least thing we care about.
> 
> Thanks,

i'd like to add it here that Makefile polishing is important - it's just 
that in the context of arch/*x86* the Makefile impact of the current 
cross-arch code sharing practice is one of the smaller problems and the 
Makefiles get cleaned up via the arch/x86 merge anyway.

	Ingo
