Return-Path: <linux-kernel-owner+w=401wt.eu-S1761565AbZAOMbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761565AbZAOMbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 07:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753630AbZAOMbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 07:31:01 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40007 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753542AbZAOMbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 07:31:00 -0500
Date: Thu, 15 Jan 2009 13:30:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>
Cc: rostedt@home.goodmis.org, peterz@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] fixes for tip/sched/rt
Message-ID: <20090115123051.GA21096@elte.hu>
References: <496DE6E4.1010209@novell.com> <20090114144317.11627.69111.stgit@dev.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114144317.11627.69111.stgit@dev.haskins.net>
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


* Gregory Haskins <ghaskins@novell.com> wrote:

> Hi Ingo,
> 
> Here is the latest iteration of the patch.  V3 is identical to v2 except
> I converted all the CPP violations to static-inlines.  I also included
> a new patch (1/2) to fix a previous CPP macro that I introduced to the tree.
> 
> I verified that this builds for both SMP and UP.
> 
> As before, you can also find these patches in my git tree:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/ghaskins/linux-2.6-hacks.git sched/latest
> 
> -Greg
> 
> ---
> 
> Gregory Haskins (2):
>       sched: fix build error in kernel/sched_rt.c when RT_GROUP_SCHED && !SMP
>       sched: de CPP-ify the scheduler code
> 
> 
>  kernel/sched.c    |    4 +
>  kernel/sched_rt.c |  270 ++++++++++++++++++++++++++++++++++-------------------
>  2 files changed, 178 insertions(+), 96 deletions(-)

pulled into tip/sched/rt, thanks Greg!

	Ingo
