Return-Path: <linux-kernel-owner+w=401wt.eu-S1751826AbXBEQ41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbXBEQ41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 11:56:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbXBEQ41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 11:56:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43395 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbXBEQ40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 11:56:26 -0500
Date: Mon, 5 Feb 2007 17:52:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
Message-ID: <20070205165233.GA4781@elte.hu>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org> <20070205084523.GA21858@elte.hu> <1170682488.29759.795.camel@pmac.infradead.org> <20070205155627.GA8354@elte.hu> <1170692539.29759.856.camel@pmac.infradead.org> <20070205162635.GA755@elte.hu> <20070205164603.GC4563@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070205164603.GC4563@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Russell King <rmk+lkml@arm.linux.org.uk> wrote:

> and the rest (ie, except integrator, versatile and ixp4xx) has:
> 
> config ARCH_SHARK
>         bool "Shark"
>         select PCI
> 
> IOW, the "PCI support" question isn't offered for platforms which 
> require PCI to be present, but is offered on platforms where it's 
> optional.

yeah. I think this also fits into the special-case i mentioned: it isnt 
connected to something user-selectable, it's a side-effect of the first 
'feature selection' the user does: 'what platform do you compile your 
kernel on'. As such it is a convenience group-selection.

i.e. what we have behind this is still a clean tree of dependencies.

The mess begins i think when options with real code behind them start to 
grow back and forth dependencies in form of criss-crossing 'depends on' 
and 'select' instances.

	Ingo
