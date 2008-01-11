Return-Path: <linux-kernel-owner+w=401wt.eu-S1759855AbYAKKvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759855AbYAKKvg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 05:51:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755637AbYAKKv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 05:51:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38260 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266AbYAKKv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 05:51:27 -0500
Date: Fri, 11 Jan 2008 11:50:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Jens Axboe <jens.axboe@oracle.com>, David Dillow <dillowda@ornl.gov>,
       linux-kernel@vger.kernel.org, linux-btrace@vger.kernel.org,
       mingo@redhat.com, tglx@linutronix.de
Subject: Re: [patch] block: fix blktrace timestamps
Message-ID: <20080111105059.GB1589@elte.hu>
References: <1199996752.9159.46.camel@lap75545.ornl.gov> <20080110234438.4826f658@inria.fr> <1200020661.5099.3.camel@obelisk.thedillows.org> <20080111090723.GI6258@kernel.dk> <20080111092334.GA8143@elte.hu> <20080111092513.GO6258@kernel.dk> <20080111094205.GE8143@elte.hu> <20080111095654.GR6258@kernel.dk> <20080111102953.GA27223@elte.hu> <20080111114713.0a2df9ee@cheypa.inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080111114713.0a2df9ee@cheypa.inria.fr>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Guillaume Chazarain <guichaz@yahoo.fr> wrote:

> > Correction: it was not a high res time source, it was "the 
> > scheduler's per-cpu, non-exported, non-coherent, 
> > warps-and-jumps-like-hell high-res timesource that was intentionally 
> > called the _sched_ clock" ;-)
> 
> I think the warts of cpu_clock() are fixable, except maybe 
> unsynchronization on SMP which is harder.

yes - but in terms of v2.6.24, the bkltrace patch i sent is a lot less 
risky.

	Ingo
