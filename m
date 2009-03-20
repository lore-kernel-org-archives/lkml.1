Return-Path: <linux-kernel-owner+w=401wt.eu-S1758346AbZCTIyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758346AbZCTIyu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 04:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755607AbZCTIyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 04:54:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33124 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754790AbZCTIyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 04:54:39 -0400
Date: Fri, 20 Mar 2009 09:54:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/10] perf_counter: powerpc: clean up
	perc_counter_interrupt
Message-ID: <20090320085422.GC16021@elte.hu>
References: <20090319192610.660857280@chello.nl> <20090319194234.024464535@chello.nl> <18882.50291.118201.148297@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18882.50291.118201.148297@cargo.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> Peter Zijlstra writes:
> 
> > From: Paul Mackerras <paulus@samba.org>
> > 
> > > Nice cleanup, and thanks for updating powerpc too.  With this, I think
> > > we'll need to update the powerpc perf_counter_interrupt a bit: we
> > > might as well use get_perf_counter_pending() instead of the wakeup
> > > variable now.  I'll send an extra patch once I have done some testing.
> > 
> > This seems to work OK.
> > 
> > Signed-off-by: Paul Mackerras <paulus@samba.org>
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Let's have a better patch description (my fault for not providing a
> decent one in the first place):

thanks - picked up your changelog.

	Ingo
