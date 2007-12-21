Return-Path: <linux-kernel-owner+w=401wt.eu-S1755871AbXLUA7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871AbXLUA7M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 19:59:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbXLUA65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 19:58:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52911 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074AbXLUA64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 19:58:56 -0500
Date: Fri, 21 Dec 2007 01:58:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 0/5] x86: another attempt at x86 pagetable unification
Message-ID: <20071221005832.GB21860@elte.hu>
References: <20071219223534.129042140@goop.org> <20071220094940.GA14227@elte.hu> <20071220112022.GA15832@elte.hu> <476AD9EA.7010108@goop.org> <20071220213906.GB11897@elte.hu> <476AE7D6.9000600@goop.org> <20071220222429.GA28029@elte.hu> <476B0E59.5070503@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476B0E59.5070503@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Well, testing for bisectability requires compiling each patch as its 
> applied, which gets painful for something like this where any change 
> will rebuild the world.  And dealing with patch conflicts caused by 
> changing early patches in the series is never fun.

that's true. The 'rej' tool helps alot though. ( Plus a distcc cluster 
that builds a distro kernel in 45-50 seconds from scratch ;)

> But I'm refactoring the series into smaller pieces now.  Knowing what 
> the outcome should look like, and there the pitfalls are, makes it 
> fairly easy.

ok, great :-)

	Ingo
