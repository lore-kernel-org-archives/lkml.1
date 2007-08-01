Return-Path: <linux-kernel-owner+w=401wt.eu-S1761484AbXHAGTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761484AbXHAGTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 02:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756505AbXHAGTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 02:19:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38940 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754605AbXHAGTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 02:19:14 -0400
Date: Wed, 1 Aug 2007 08:19:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [rfc] balance-on-fork NUMA placement
Message-ID: <20070801061901.GA10134@elte.hu>
References: <20070731054142.GB11306@wotan.suse.de> <20070731080114.GA12367@elte.hu> <20070801002114.GB31006@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070801002114.GB31006@wotan.suse.de>
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


* Nick Piggin <npiggin@suse.de> wrote:

> > _after_ the dup_task_struct(). Then change sched_fork() to return a 
> > CPU number - hence we dont have a separate sched_fork_suggest_cpu() 
> > initialization function, only one, obvious sched_fork() function. 
> > Agreed?
> 
> That puts task struct, kernel stack, thread info on the wrong node.

ok, i missed that - your patch looks then fine to me.

	Ingo
