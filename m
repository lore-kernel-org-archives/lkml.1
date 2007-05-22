Return-Path: <linux-kernel-owner+w=401wt.eu-S933793AbXEVK6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933793AbXEVK6Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 06:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758482AbXEVK6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 06:58:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37434 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757659AbXEVK6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 06:58:03 -0400
Date: Tue, 22 May 2007 12:57:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Con Kolivas <kernel@kolivas.org>
Cc: Antonino Ingargiola <tritemio@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ray Lee <ray-lk@madrabbit.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: swap prefetch improvements
Message-ID: <20070522105710.GA12833@elte.hu>
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <200705222037.54741.kernel@kolivas.org> <20070522104648.GA10622@elte.hu> <200705222054.46488.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705222054.46488.kernel@kolivas.org>
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


* Con Kolivas <kernel@kolivas.org> wrote:

> On Tuesday 22 May 2007 20:46, Ingo Molnar wrote:
> > It clearly should not consider 'itself' as IO activity. This 
> > suggests some bug in the 'detect activity' mechanism, agreed? I'm 
> > wondering whether you are seeing the same problem, or is all 
> > swap-prefetch IO on your system continuous until it's done [or some 
> > other IO comes inbetween]?
> 
> When nothing else is happening anywhere on the system it reads in 
> bursts and goes to sleep during journal writeout.

hm, what do you call 'journal writeout' here that would be happening on 
my system?

	Ingo
