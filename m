Return-Path: <linux-kernel-owner+w=401wt.eu-S1753714AbYLZIu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714AbYLZIu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 03:50:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbYLZIuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 03:50:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34577 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914AbYLZIuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 03:50:18 -0500
Date: Fri, 26 Dec 2008 09:49:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH for -tip 3/4] proc: remove ifdef CONFIG_SPARSE_IRQ from
	stat.c
Message-ID: <20081226084958.GD755@elte.hu>
References: <20081226131855.5CB2.KOSAKI.MOTOHIRO@jp.fujitsu.com> <86802c440812252036h37d4886bucab9ff3591f94821@mail.gmail.com> <20081226141743.5CB5.KOSAKI.MOTOHIRO@jp.fujitsu.com> <86802c440812252159v6129a385qb900be42845ac90a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440812252159v6129a385qb900be42845ac90a@mail.gmail.com>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> > hm, instead, How about following patch?
> >
> > =======
> > Subject: [PATCH] proc: remove ifdef CONFIG_SPARSE_IRQ from stat.c
> > Impact: cleanup

> nice. much clean.

applied all four patches to tip/irq/sparseirq:

 18eefed: irq: simplify for_each_irq_desc() usage
 26ddd8d: proc: remove ifdef CONFIG_SPARSE_IRQ from stat.c
 f9af0e7: irq: for_each_irq_desc() move to irqnr.h
 51bc39f: hrtimer: remove #include <linux/irq.h>

the whole series is very nice and removes quite a bit of irq_desc usage 
complexity. Thanks guys,

	Ingo
