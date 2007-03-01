Return-Path: <linux-kernel-owner+w=401wt.eu-S965052AbXCANh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965052AbXCANh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 08:37:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965057AbXCANh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 08:37:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60087 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965052AbXCANhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 08:37:55 -0500
Date: Thu, 1 Mar 2007 14:30:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Con Kolivas <kernel@kolivas.org>
Cc: tglx@linutronix.de, Mike Galbraith <efault@gmx.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc1: known regressions (v2) (part 2)
Message-ID: <20070301133004.GA32724@elte.hu>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> <200703012213.25629.kernel@kolivas.org> <1172748837.11473.53.camel@localhost.localdomain> <200703012305.53997.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703012305.53997.kernel@kolivas.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Con Kolivas <kernel@kolivas.org> wrote:

> [...] Even though I'm finding myself defending code that has already 
> been softly tagged for redundancy, let's be clear here; we're talking 
> about at most a further 70ms delay in scheduling a niced task in the 
> presence of a nice 0 task, which is a reasonable delay for ksoftirqd 
> which we nice the eyeballs out of in mainline. Considering under load 
> our scheduler has been known to cause scheduling delays of 10 seconds 
> I still don't see this as a bug. Dynticks just "points it out to us".

well, not running softirqs when we could is a bug. It's not a big bug, 
but it's a bug nevertheless. It doesnt matter that softirqs could be 
delayed even worse under high load - there was no 'high load' here.

	Ingo
