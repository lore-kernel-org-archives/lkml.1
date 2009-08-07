Return-Path: <linux-kernel-owner+w=401wt.eu-S1757035AbZHGHpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035AbZHGHpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 03:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755546AbZHGHpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 03:45:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39320 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754982AbZHGHpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 03:45:30 -0400
Date: Fri, 7 Aug 2009 09:45:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf tools: Fix reading of perf.data file header
Message-ID: <20090807074525.GA20292@elte.hu>
References: <20090629192913.GA29295@elte.hu> <4A7B0C02.7060704@inria.fr> <1249580428.4975.14.camel@laptop> <4A7B175B.8030000@inria.fr> <1249585061.4975.17.camel@laptop> <4A7B28EA.20903@inria.fr> <20090806195924.GA22411@elte.hu> <4A7B68C3.7040706@inria.fr> <20090807063226.GA29532@elte.hu> <4A7BD9EC.8000801@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7BD9EC.8000801@inria.fr>
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


* Brice Goglin <Brice.Goglin@inria.fr> wrote:

> Ingo Molnar wrote:
> > Ok, there's indeed a flag clash with -s/--sort as you noticed.
> >
> > -S looks good to me, how about going one step further and changing 
> > perf record to use -S/--stat as well, to make the flag consistent 
> > across all tools?
> 
> Sure, but perf stat already uses -S for --scale :)

heh :-)

I completely forgot about it. And since we now have --scale enabled 
by default (and it doesnt make much sense to disable it i guess), it 
would not be a big issue to rename that -c/--scale to free up that 
flag for -S/--stat?

	Ingo
