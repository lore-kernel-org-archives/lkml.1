Return-Path: <linux-kernel-owner+w=401wt.eu-S1759314AbYHORXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759314AbYHORXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 13:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbYHORXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 13:23:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36269 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbYHORXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 13:23:21 -0400
Date: Fri, 15 Aug 2008 19:22:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: John Kacur <jkacur@gmail.com>, Rabin Vincent <rabin@rab.in>,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] lockdep: fix build if CONFIG_PROVE_LOCKING not defined
Message-ID: <20080815172258.GC23600@elte.hu>
References: <520f0cf10808150857u5803d86cj205e671f640c81c4@mail.gmail.com> <20080815093305.6975ec7e@extreme>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080815093305.6975ec7e@extreme>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Hemminger <shemminger@vyatta.com> wrote:

> If CONFIG_PROVE_LOCKING not defined, then no dependency information
> is available.

applied to tip/core/urgent, thanks Stephen. I'm wondering, could you 
send me the config that produces the build error? I do fairly 
comprehensive build testing but this one does not seem to trigger.

	Ingo
