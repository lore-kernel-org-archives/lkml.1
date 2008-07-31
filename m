Return-Path: <linux-kernel-owner+w=401wt.eu-S1753569AbYGaQfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbYGaQfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 12:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbYGaQfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 12:35:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42370 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbYGaQfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 12:35:08 -0400
Date: Thu, 31 Jul 2008 18:34:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lockdep: change scheduler annotation
Message-ID: <20080731163456.GE26393@elte.hu>
References: <20080728.161318.38361710.davem@davemloft.net> <20080728235133.GA7956@elte.hu> <20080728.174415.154327359.davem@davemloft.net> <20080729.214503.126934382.davem@davemloft.net> <1217417217.8157.23.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217417217.8157.23.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0190]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> While thinking about David's patch it _finally_ dawned on me that 
> there is no reason we have a lock class per cpu..

/me arghs too! :)

> Sorry for being dense :-/
> 
> The below changes the annotation from a lock class per cpu, to a 
> single nested lock, as the scheduler never holds more that 2 rq locks 
> at a time anyway.
> 
> If there was code requiring holding all rq locks this would not work 
> and the original annotation would be the only option, but that not 
> being the case, this is a much lighter one.
> 
> Compiles and boots on a 2-way x86_64.

applied to tip/sched/urgent - thanks Peter!

	Ingo
