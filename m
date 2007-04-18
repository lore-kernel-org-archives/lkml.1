Return-Path: <linux-kernel-owner+w=401wt.eu-S2992964AbXDRSAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992964AbXDRSAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 14:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992968AbXDRSAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 14:00:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53269 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992964AbXDRSAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 14:00:17 -0400
Date: Wed, 18 Apr 2007 19:59:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Mackall <mpm@selenic.com>, Nick Piggin <npiggin@suse.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck list <ck@vds.kolivas.org>, Bill Huey <billh@gnuppy.monkey.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070418175936.GA11980@elte.hu>
References: <20070417070155.GF1057@wotan.suse.de> <20070417213954.GE11166@waste.org> <20070418031511.GA18452@wotan.suse.de> <20070418043831.GR11115@waste.org> <20070418050024.GF18452@wotan.suse.de> <20070418055525.GS11115@waste.org> <alpine.LFD.0.98.0704180742470.2828@woody.linux-foundation.org> <20070418152355.GU11115@waste.org> <alpine.LFD.0.98.0704181012470.2828@woody.linux-foundation.org> <20070418174945.GA7930@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070418174945.GA7930@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> In that sense 'fairness' is not global (and in fact it is almost 
> _never_ a global property, as X runs under root uid [*]), it is only 
> the most lowlevel scheduling machinery that can then be built upon. 
> [...]

perhaps a more fitting term would be 'precise group-scheduling'. Within 
the lowest level task group entity (be that thread group or uid group, 
etc.) 'precise scheduling' is equivalent to 'fairness'.

	Ingo
