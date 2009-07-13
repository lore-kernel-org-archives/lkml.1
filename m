Return-Path: <linux-kernel-owner+w=401wt.eu-S1754804AbZGMIvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbZGMIvh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 04:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754725AbZGMIvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 04:51:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58947 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202AbZGMIvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 04:51:35 -0400
Date: Mon, 13 Jul 2009 10:51:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: a.p.zijlstra@chello.nl, andi@firstfloor.org, fweisbec@gmail.com,
       acme@redhat.com, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH][RFC] Adding information of counts processes acquired
	how many spinlocks to schedstat
Message-ID: <20090713085119.GA6757@elte.hu>
References: <1247230336.7529.34.camel@twins> <20090712.162337.287595819039280884.mitake@dcl.info.waseda.ac.jp> <1247405045.6733.2.camel@laptop> <20090713.150612.886429910823138064.mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090713.150612.886429910823138064.mitake@dcl.info.waseda.ac.jp>
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


* Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:

> > Yeah, steve broke it, but then Jason fixed it again, but his 
> > patches might not have made it in yet.
> > 
> >   http://lkml.org/lkml/2009/7/6/313
> 
> Wow! I can obtain lock_acquire with Jason's patch,
> 
> % perf stat -e lockdep:lock_acquire sleep 1
> 
>  Performance counter stats for 'sleep 1':
> 
>            1420  lockdep:lock_acquire
> 
>     1.004953591  seconds time elapsed
> 
> I wanted this.
> So I don't have nothing to do.., but thanks Jason!

I gave some review feedback about those patches, see:

   http://lkml.org/lkml/2009/7/13/360

Once they are addressed we can try them in -tip.

	Ingo
