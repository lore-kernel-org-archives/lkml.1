Return-Path: <linux-kernel-owner+w=401wt.eu-S1756991AbZF0Q67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991AbZF0Q67 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 12:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756052AbZF0Q6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 12:58:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35454 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755603AbZF0Q6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 12:58:51 -0400
Date: Sat, 27 Jun 2009 18:58:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2/2] perf_counter: powerpc: Add callchain support
Message-ID: <20090627165845.GA20794@elte.hu>
References: <19013.44646.549261.100582@cargo.ozlabs.ibm.com> <19013.44722.893263.275594@cargo.ozlabs.ibm.com> <1246091684.31755.210.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246091684.31755.210.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0080]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Sat, 2009-06-27 at 15:31 +1000, Paul Mackerras wrote:
> > +       if (regs) {
> > +               if (current_is_64bit())
> > +                       perf_callchain_user_64(regs, entry);
> > +               else
> > +                       perf_callchain_user_32(regs, entry);
> > +       }
> 
> Ingo do we need 32 on 64 stuff like that too?

hm, indeed.

	Ingo
