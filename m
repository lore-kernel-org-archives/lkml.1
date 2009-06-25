Return-Path: <linux-kernel-owner+w=401wt.eu-S1757730AbZFYPeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730AbZFYPeu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 11:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbZFYPem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 11:34:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53360 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783AbZFYPem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 11:34:42 -0400
Date: Thu, 25 Jun 2009 17:34:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland Dreier <rdreier@cisco.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf_counter tools: shorten names for events
Message-ID: <20090625153406.GA12918@elte.hu>
References: <1245760130.3776.6.camel@localhost.localdomain> <20090623195656.GC8777@elte.hu> <1245876060.3038.7.camel@localhost.localdomain> <20090625093346.GD23547@elte.hu> <1245934522.5308.39.camel@hpdv5.satnam> <ada3a9ol58t.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ada3a9ol58t.fsf@cisco.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Roland Dreier <rdreier@cisco.com> wrote:

>  >       266590464  L1d-loads             (scaled from 23.03%)
> 
> IMHO "L1d" is too abbreviated for it to be obvious that it means 
> L1 data cache.  If you want something really short maybe "L1-d$" 
> might be a little clearer, but I stil like "L1-dcache" best.

i changed it to L1-d$ / L1-i$.

> The formatting of aligning things is nice defitely but we could 
> also shorten lines by saying "scaled from" in fewer characters 
> maybe?  (I have to admit I don't know what "scaled from X%" means 
> in this case so I can't suggest something better, but the fact 
> that I can't easily tell what it means probably suggests that the 
> wording could be improved)

Indeed, the '(scaled from 12.3%)' message should i guess be changed 
to:

  (9.43x scaled)

( and a multiplicative factor is more expressive anyway, than the 
  percentage of from where we scale up. )

	Ingo
