Return-Path: <linux-kernel-owner+w=401wt.eu-S1759374AbXGEIs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759374AbXGEIs0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 04:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758036AbXGEIsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 04:48:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35806 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757545AbXGEIsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 04:48:18 -0400
Date: Thu, 5 Jul 2007 10:48:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Sattler <tsattler@gmx.de>
Subject: Re: [PATCH] debug workqueue flushing deadlocks with lockdep
Message-ID: <20070705084806.GB3476@elte.hu>
References: <1183577668.9662.11.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183577668.9662.11.camel@johannes.berg>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Johannes Berg <johannes@sipsolutions.net> wrote:

> This patch adds a fake lock to each workqueue in order to debug things 
> where you have something like
> 
>   my_function() -> lock(); ...; flush_workqueue(); ...
> vs
>   run_workqueue() -> my_work() -> ...; lock(); ...
> 
> which can obviously deadlock if my_work is scheduled when my_function()
> is invoked (but hasn't locked yet.)
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

i'm still impressed by the elegancy of your idea :)

Acked-by: Ingo Molnar <mingo@elte.hu>

btw., small patch format comment: it would be useful (in the future) to 
send such combined patches as:

 [patch 0/2] general description
 [patch 1/2] first patch
 [patch 2/2] second patch

	Ingo
