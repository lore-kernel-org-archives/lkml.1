Return-Path: <linux-kernel-owner+w=401wt.eu-S965686AbXDGJYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965686AbXDGJYP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 05:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965692AbXDGJYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 05:24:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38924 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965686AbXDGJYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 05:24:14 -0400
Date: Sat, 7 Apr 2007 11:24:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] [sched] redundant reschedule when set_user_nice() boosts a prio of a task from the "expired" array
Message-ID: <20070407092401.GB16356@elte.hu>
References: <b647ffbd0704040704k2e4b3abcyfadc7662dff37f5b@mail.gmail.com> <20070404141546.GA862@elte.hu> <b647ffbd0704041305t2a140369q56cf9f0746b8fd86@mail.gmail.com> <20070406170319.2c961eba.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070406170319.2c961eba.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> so
> 
> - your code only gets publically tested in its against-staircase 
>   version
> 
> - the against-mainline version will get merged without having been
>   publically tested outside of staircase
> 
> which is probably all OK for a 2.6.22-rc1 thing, provided Ingo can 
> give a confident ack.

it looks good to me - and once i get a non-whitespace-damaged patch i'll 
put it into -rt so we'll have testing. (this patch should have at most a 
latency impact, if we forget to preempt somewhere, and -rt users are 
quite touchy about latencies.)

> Where are we at with staircase anyway?  Is it looking like a 2.6.22 
> thing? I don't personally think we've yet seen enough serious 
> performance testing to permit a merge, apart from other issues...

yes, that's my thinking too at the moment. I'd also like to see a 
summary of 'open design questions' list from Mike (if Mike has 
time/energy for that?) - many questions were raised, a good number of 
them were answered, various changes done to SD but there's no good 
summary of the current state of affairs.

	Ingo
