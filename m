Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbXJFFyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbXJFFyE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 01:54:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251AbXJFFxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 01:53:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56878 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbXJFFxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 01:53:53 -0400
Date: Sat, 6 Oct 2007 07:53:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Jackson <pj@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, nickpiggin@yahoo.com.au,
       randy.dunlap@oracle.com, menage@google.com,
       linux-kernel@vger.kernel.org, dino@in.ibm.com, cpw@sgi.com
Subject: Re: [PATCH] cpuset and sched domains: sched_load_balance flag fixes
Message-ID: <20071006055324.GC23397@elte.hu>
References: <20071003114401.32194.73464.sendpatchset@jackhammer.engr.sgi.com> <20071005161305.af27f452.akpm@linux-foundation.org> <20071005163918.46d40fed.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071005163918.46d40fed.pj@sgi.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Jackson <pj@sgi.com> wrote:

> Yup - so far as I can tell, you didn't pick up the base patch that 
> this current patch fixes.  So, no, I wouldn't expect this patch to 
> make any sense.
> 
> As I stated in this current patch in the diffstat section after the 
> '---' marker, this current patch applies to the base patch of Subject:
> 
>   [PATCH] cpuset and sched domains: sched_load_balance flag
> 
> You probably didn't pick up that base patch because Nick and I are 
> still haggling over it.  Well ... we've agreed, but I can't get the 
> scheduler to work as I thought Nick wanted, and I'm still waiting to 
> hear from Nick again.

please resend the base patch to Andrew (or better yet, a combo patch 
that Andrew can apply and which just does it all).

We've agreed on the external API and that is what matters for now. The 
internal interfacing between the scheduler and cpusets can/could be 
improved later on - and your original patch is reasonable to begin with. 
So lets just move on and do this.

	Ingo
