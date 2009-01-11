Return-Path: <linux-kernel-owner+w=401wt.eu-S1753577AbZAKDrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbZAKDrd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 22:47:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750815AbZAKDrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 22:47:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60604 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbZAKDrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 22:47:24 -0500
Date: Sun, 11 Jan 2009 04:46:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matt Mackall <mpm@selenic.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sparseirq: make some func to be used with genirq
Message-ID: <20090111034646.GA28520@elte.hu>
References: <496534B1.6080902@kernel.org> <20090108120619.GF1539@elte.hu> <1231435078.3178.278.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231435078.3178.278.camel@calx>
User-Agent: Mutt/1.5.18 (2008-05-17)
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

> On Thu, 2009-01-08 at 13:06 +0100, Ingo Molnar wrote:
> > (Matt Cc:-ed)
> > 
> > Matt, does this look good to you? The point of this cleanup would be to 
> > make desc->timer_rand_state depend on hardirq (the presence of irq_desc[]) 
> > - not sparseirq (which does not make much sense).
> 
> Seems fine.
> 
> Signed-off-by: Matt Mackall <mpm@selenic.com>

applied it to tip/irq/urgent, thanks guys!

	Ingo
