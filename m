Return-Path: <linux-kernel-owner+w=401wt.eu-S1756791AbZAKAEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbZAKAEu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 19:04:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbZAKAEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 19:04:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:32872 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878AbZAKAEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 19:04:41 -0500
Date: Sun, 11 Jan 2009 01:04:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Jes Sorensen <jes@sgi.com>,
       Jack Steiner <steiner@sgi.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: bad patch in sched.c
Message-ID: <20090111000435.GF20843@elte.hu>
References: <496797C4.6000601@sgi.com> <200901102234.37460.rusty@rustcorp.com.au> <20090110121847.GA26459@elte.hu> <4968D79C.10602@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4968D79C.10602@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> Ingo Molnar wrote:
> > * Rusty Russell <rusty@rustcorp.com.au> wrote:
> > 
> >> cpumask: fix CONFIG_NUMA=y sched.c
> > 
> > doesnt build:
> > 
> > kernel/sched.c: In function â€˜__build_sched_domainsâ€™:
> > kernel/sched.c:7701: error: â€˜struct static_sched_domainâ€™ has no member named â€˜sgâ€™
> > 
> > 	Ingo
> Hi,
> 
> This one does compile and fix it.

applied to tip/sched/urgent, thanks Mike!

	Ingo
