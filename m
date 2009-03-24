Return-Path: <linux-kernel-owner+w=401wt.eu-S1760318AbZCXOKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760318AbZCXOKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 10:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756892AbZCXOEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 10:04:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39276 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757468AbZCXOEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:04:32 -0400
Date: Tue, 24 Mar 2009 15:04:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Luis Henriques <henrix@sapo.pt>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 -tip] sched: Clean unused fields from struct rq
Message-ID: <20090324140419.GD32043@elte.hu>
References: <20090318225137.GA3766@hades.domain.com> <20090323175224.GA3938@hades.domain.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090323175224.GA3938@hades.domain.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Luis Henriques <henrix@sapo.pt> wrote:

> On Wed, Mar 18, 2009 at 10:51:37PM +0000, Luis Henriques wrote:
> > Since they are used on in statistics and are always set to zero, the following
> > fields from struct rq have been removed: yld_exp_empty, yld_act_empty and
> > yld_both_empty.
> > 
> > Both Sched Debug and SCHEDSTAT_VERSION versions has also been incremented since
> > ABIs have been changed.
> > 
> 
> Hi Ingo,
> 
> Sorry to bother you but I can not find this patch in -tip.  Just 
> would like to confirm with you that it was NACK'ed or you just 
> forgot to merge it to the tree.

Was held up by the schedstat tool discussions. Please resend the 
patch with a link to the updated tool in the commit log perhaps (if 
such a link exists), and with Gregory's ack in place.

Thanks,

	Ingo
