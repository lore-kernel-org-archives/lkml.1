Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894AbZFYJYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbZFYJYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 05:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbZFYJYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 05:24:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42224 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695AbZFYJYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 05:24:41 -0400
Date: Thu, 25 Jun 2009 11:24:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf_counter tools: shorten names for events
Message-ID: <20090625092409.GC23547@elte.hu>
References: <1245760130.3776.6.camel@localhost.localdomain> <20090623195656.GC8777@elte.hu> <1245876060.3038.7.camel@localhost.localdomain> <alpine.LFD.2.00.0906242253270.2767@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0906242253270.2767@localhost.localdomain>
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Thu, 25 Jun 2009, Jaswinder Singh Rajput wrote:
> > On Tue, 2009-06-23 at 21:56 +0200, Ingo Molnar wrote:
> > 
> >       248064467  L1-data-Cache-Load-Referencees  (scaled from 23.27%)
> >       283542921  dL1-loads             (scaled from 23.28%)
> 
> Where is the point of this? dL1-loads is a completely non 
> intuitive artificial abbreviation.

blame me :)

I found L1-data-Cache-Load-References way too long and i asked for 
suggestions and came up with my list of abbreviations.

I found 'dL1' intuitive because we use 'dTLB' and 'iTLB' as well.

How about L1-data-loads ?

	Ingo
