Return-Path: <linux-kernel-owner+w=401wt.eu-S1759215AbYHNNvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759215AbYHNNvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 09:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbYHNNve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 09:51:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35658 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbYHNNve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 09:51:34 -0400
Date: Thu, 14 Aug 2008 15:51:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alex Nixon <alex.nixon@citrix.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: fix rt-bandwidth hotplug race
Message-ID: <20080814135122.GB14333@elte.hu>
References: <1218721740.10800.230.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218721740.10800.230.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> Subject: sched: fix rt-bandwidth hotplug race
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Thu Aug 14 15:42:44 CEST 2008
> 
> When we hot-unplug a cpu and rebuild the sched-domain, all cpus will be
> detatched. Alex observed the case where a runqueue was stealing bandwidth
> from an already disabled runqueue to satisfy its own needs.
> 
> Stop this by skipping over already disabled runqueues.
> 
> Reported-by: Alex Nixon <alex.nixon@citrix.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Tested-by: Alex Nixon <alex.nixon@citrix.com>

applied to tip/sched/urgent - thanks!

	Ingo
