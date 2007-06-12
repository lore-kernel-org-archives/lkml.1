Return-Path: <linux-kernel-owner+w=401wt.eu-S1758450AbXFLI5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450AbXFLI5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 04:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755164AbXFLI5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 04:57:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38001 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754997AbXFLI5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 04:57:36 -0400
Date: Tue, 12 Jun 2007 10:57:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tobias Gerschner <tobias.gerschner@gmail.com>
Cc: Miguel Figueiredo <elmig@debianpt.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck@vds.kolivas.org
Subject: Re: call for more SD versus CFS comparisons (was: Re: [ck]
	Mainline plans)
Message-ID: <20070612085730.GA17964@elte.hu>
References: <466DE921.9030709@debianpt.org> <ea7e82ce0706120039n675a361emc214b2ecca964b75@mail.gmail.com> <20070612083620.GA10557@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070612083620.GA10557@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> * Tobias Gerschner <tobias.gerschner@gmail.com> wrote:
> 
> > I did run massive_intr.c for 60 secs with increasing nproc ( 
> > 10,20,30,40,50,60) waiting for effects.
> > 
> > Below a small table of the results
> > 
> > 2.6.21.1-cfs-v16
> > 
> > nproc ,  usability result
> > 
> > 10 , serious frame drops , Firefox  hardly recognizes clicked links,
> > but still usable
> > 20 - 30, usability loss ( somehow under cfs firefox never finished 
> > user requests like displaying web pages or opening new pages , no 
> > feedback anymore, sudden changes on the desktop )
> 
> ouch! The expected load-testing result under CFS should be something 
> like this:
> 
>    http://bhhdoa.org.au/pipermail/ck/2007-June/007817.html

i have just tried the same workload with cfs and with sd048 from -ck, 
and cannot reproduce this. To make sure it's not some other change in 
-ck, could you try the pure SD patches ontop of 2.6.21.1 too:

 http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.21/2.6.21-ck2/patches/2.6.21-sd-0.48.patch
 http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.21/2.6.21-ck2/patches/sched-sd-0.48-interactive_tunable.patch

	Ingo
