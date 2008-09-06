Return-Path: <linux-kernel-owner+w=401wt.eu-S1755018AbYIFSZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018AbYIFSZI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 14:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754696AbYIFSYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 14:24:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55825 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbYIFSYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 14:24:53 -0400
Date: Sat, 6 Sep 2008 20:24:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joe Korty <joe.korty@ccur.com>
Cc: Leon Woestenberg <leon.woestenberg@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] shrink printk timestamp field
Message-ID: <20080906182438.GC21872@elte.hu>
References: <20080827151759.GA10678@tsunami.ccur.com> <20080829163540.634e86d9.akpm@linux-foundation.org> <20080830143808.GA10821@tsunami.ccur.com> <20080830101618.b6c2e1ab.akpm@linux-foundation.org> <c384c5ea0808301047g7b3658can77b41e5906d306b6@mail.gmail.com> <20080830185730.GA12660@tsunami.ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080830185730.GA12660@tsunami.ccur.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0125]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joe Korty <joe.korty@ccur.com> wrote:

> >> Of course it's useful.  If you're working on performance or latency 
> >> in a disk, network or USB driver, microsecond resolution is about 
> >> right.
> >
> > I second this. If we have timestamps enables, let it be useful for 
> > all current uses. The 3 digits extra are very cheap useful 
> > information in that area (without resorting to more elaborate 
> > methods like the recently merged latency tracer).
> > 
> > Rather than cut 3 digits off, maybe fix some of the too-wide prints 
> > would solve the posters issue better.
> > 
> > Can we please have this patch non-committed or reverted?
> 
> I have no objection...

ok, i've zapped it from tip/core/printk.

	Ingo
