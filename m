Return-Path: <linux-kernel-owner+w=401wt.eu-S1766811AbXDSPSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766811AbXDSPSa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 11:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766814AbXDSPSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 11:18:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44519 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766811AbXDSPS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 11:18:29 -0400
Date: Thu, 19 Apr 2007 17:18:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070419151803.GB30959@elte.hu>
References: <20070413202100.GA9957@elte.hu> <20070414020424.GB14544@wotan.suse.de> <20070414063254.GB14875@elte.hu> <20070414064334.GA19463@elte.hu> <20070414080833.GL943@1wt.eu> <20070414083625.GM943@1wt.eu> <20070414105338.GB19454@elte.hu> <20070414130101.GA2538@1wt.eu> <20070419090144.GA17100@elte.hu> <20070419125438.GA27584@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070419125438.GA27584@1wt.eu>
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


* Willy Tarreau <w@1wt.eu> wrote:

> You can certainly script it with -geometry. But it is the wrong 
> application for this matter, because you benchmark X more than 
> glxgears itself. What would be better is something like a line 
> rotating 360 degrees and doing some short stuff between each degree, 
> so that X is not much sollicitated, but the CPU would be spent more on 
> the processes themselves.

at least on my setup glxgears goes via DRI/DRM so there's no X 
scheduling inbetween at all, and the visual appearance of glxgears is a 
direct function of its scheduling.

	Ingo
