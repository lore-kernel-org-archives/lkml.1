Return-Path: <linux-kernel-owner+w=401wt.eu-S1757921AbZFYP0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921AbZFYP0t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 11:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbZFYP0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 11:26:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43510 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbZFYP0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 11:26:41 -0400
Date: Thu, 25 Jun 2009 17:26:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland Dreier <rdreier@cisco.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf_counter tools: shorten names for events
Message-ID: <20090625152622.GB10868@elte.hu>
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

> 
>  >       266590464  L1d-loads             (scaled from 23.03%)
> 
> IMHO "L1d" is too abbreviated for it to be obvious that it means 
> L1 data cache.  If you want something really short maybe "L1-d$" 
> might be a little clearer, but I stil like "L1-dcache" best.

I find 'dcache' extremely confusing given that we have a dcache in 
Linux already.

	Ingo
