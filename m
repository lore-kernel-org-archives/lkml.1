Return-Path: <linux-kernel-owner+w=401wt.eu-S1161309AbXDSJCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161309AbXDSJCI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 05:02:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161374AbXDSJCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 05:02:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42212 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161309AbXDSJCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 05:02:06 -0400
Date: Thu, 19 Apr 2007 11:01:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070419090144.GA17100@elte.hu>
References: <20070413202100.GA9957@elte.hu> <20070414020424.GB14544@wotan.suse.de> <20070414063254.GB14875@elte.hu> <20070414064334.GA19463@elte.hu> <20070414080833.GL943@1wt.eu> <20070414083625.GM943@1wt.eu> <20070414105338.GB19454@elte.hu> <20070414130101.GA2538@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070414130101.GA2538@1wt.eu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Willy Tarreau <w@1wt.eu> wrote:

> Good idea. The machine I'm typing from now has 1000 scheddos running 
> at +19, and 12 gears at nice 0. [...]

> From time to time, one of the 12 aligned gears will quickly perform a 
> full quarter of round while others slowly turn by a few degrees. In 
> fact, while I don't know this process's CPU usage pattern, there's 
> something useful in it : it allows me to visually see when process 
> accelerate/decelerate. [...]

cool idea - i have just tried this and it rocks - you can easily see the 
'nature' of CPU time distribution just via visual feedback. (Is there 
any easy way to start up 12 glxgears fully aligned, or does one always 
have to mouse around to get them into proper position?)

btw., i am using another method to quickly judge X's behavior: i started 
the 'snowflakes' plugin in Beryl on Fedora 7, which puts a nice smooth 
opengl-rendered snow fall on the desktop background. That gives me an 
idea about how well X is scheduling under various workloads, without 
having to instrument it explicitly.

	Ingo
