Return-Path: <linux-kernel-owner+w=401wt.eu-S1757301AbXGHKnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301AbXGHKnP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 06:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753600AbXGHKnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 06:43:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58731 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbXGHKnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 06:43:01 -0400
Date: Sun, 8 Jul 2007 12:42:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org, suresh.b.siddha@intel.com,
       corey.d.gough@intel.com, Pekka Enberg <penberg@cs.helsinki.fi>,
       akpm@linux-foundation.org, Matt Mackall <mpm@selenic.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
Message-ID: <20070708104243.GA12175@elte.hu>
References: <20070708034952.022985379@sgi.com> <20070708035018.074510057@sgi.com> <20070708075119.GA16631@elte.hu> <4690B1A4.4010703@yahoo.com.au> <20070708095422.GA2744@elte.hu> <4690BB0A.4030801@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4690BB0A.4030801@yahoo.com.au>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> >cool. I was referring to something else: people were running -rt on 
> >their beefy desktop boxes with several gigs of RAM they complained 
> >about the slowdown that is caused by SLOB's linear list walking.
> 
> That is what I meant by scalable to large memories. It is not perfect, 
> but it is much better now. I noticed huge slowdowns too when test 
> booting the slob RCU patch on my 4GB desktop, so I did a few things to 
> improve freelist walking as well (the patches are in -mm, prefixed 
> with slob-).

ah, good - i only looked at the upstream mm/slob.c git-log. I like those 
4 slob-* patches in -mm: in particular slob-remove-bigblock-tracking.patch
and slob-rework-freelist-handling.patch are really elegant. Simplicity of 
slob does not seem to suffer either.

	Ingo
