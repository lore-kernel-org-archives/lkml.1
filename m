Return-Path: <linux-kernel-owner+w=401wt.eu-S1758478AbYHNIqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758478AbYHNIqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 04:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbYHNIqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 04:46:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59712 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644AbYHNIqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 04:46:21 -0400
Date: Thu, 14 Aug 2008 10:46:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix the race between walk_tg_tree and
	sched_create_group
Message-ID: <20080814084606.GB1650@elte.hu>
References: <1912924600.25608.298.camel@ymzhang> <1218702968.10800.199.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218702968.10800.199.camel@twins>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Wed, 2030-08-14 at 15:56 +0800, Zhang, Yanmin wrote:
> > With 2.6.27-rc3, I hit a kernel panic when running volanoMark on my
> > new x86_64 machine. I also hit it with other 2.6.27-rc kernels.
> > See below log.
> > 
> > Basically, function walk_tg_tree and sched_create_group have a race between
> > accessing and initiating tg->children. Below patch fixes it by moving 
> > tg->children initiation to the front of linking tg->siblings to parent->children.
> > 
> > Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>
> 
> Nice catch
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

applied to tip/sched/urgent - thanks.

	Ingo
