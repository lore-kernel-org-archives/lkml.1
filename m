Return-Path: <linux-kernel-owner+w=401wt.eu-S1757451AbYAVVH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451AbYAVVH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 16:07:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbYAVVHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 16:07:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52561 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642AbYAVVHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 16:07:09 -0500
Date: Tue, 22 Jan 2008 22:06:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] sched: Keep total / count stats in addition to the max
	for wait time
Message-ID: <20080122210659.GA26764@elte.hu>
References: <20080121110809.1b584998@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080121110809.1b584998@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0008]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> From: Arjan van de Ven <arjan@linux.intel.com>
> Subject: sched: Keep total / count stats in addition to the max for wait time
> 
> Right now, the linux kernel (with scheduler statistics enabled) keeps 
> track of the maximum time a process is waiting to be scheduled. While 
> the maximum is a very useful metric, tracking average and total is 
> equally useful (at least for latencytop) to figure out the accumulated 
> effect of scheduler delays. The accumulated effect is important to 
> judge the performance impact of scheduler tuning/behavior.

thanks, applied to sched-devel.git.

	Ingo
