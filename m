Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256AbYKGJj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbYKGJj6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 04:39:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbYKGJjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 04:39:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52488 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485AbYKGJjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 04:39:45 -0500
Date: Fri, 7 Nov 2008 10:39:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpumask: introduce new API, without changing anything
Message-ID: <20081107093911.GD7787@elte.hu>
References: <20081029152849.3883d072.sfr@canb.auug.org.au> <200811021229.16061.rusty@rustcorp.com.au> <alpine.LFD.2.00.0811011834360.3483@nehalem.linux-foundation.org> <200811070949.02914.rusty@rustcorp.com.au> <20081107084016.GF4435@elte.hu> <20081107201139.196fa52b.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081107201139.196fa52b.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Ingo,
> 
> On Fri, 7 Nov 2008 09:40:16 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> >
> > if this is equal to the patch that you sent me (see the git 
> > coordinates below), it was also stess-tested and build-coverage tested 
> > by me on a healthy range of x86 systems, in a range of build 
> > environments.
> 
> It isn't identical.  See my message about a small merge conflict 
> between the cpus4096 tree and the rr tree in linux-next today.

but the change was not due to some merge conflict, it was a change 
done to the patch itself.

The merge conflict happened because Rusty iterated the patch in a 
non-append manner so two versions of the same patch collided in 
linux-next.

So ... what was the change, was it _really_ tested as-is in the 
linux-next tree for a longer time, or just merged a couple of hours 
ago?

Rusty, i pointed it out before, this kind of workflow you use in the 
rr tree is really inefficient for such types of changes. You destroy 
testing results by rebasing all the time, you make changes harder to 
review and as an end result you make it harder to achieve a better end 
result.

	Ingo
