Return-Path: <linux-kernel-owner+w=401wt.eu-S1754300AbYKJIlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbYKJIlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 03:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbYKJIlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 03:41:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38296 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbYKJIlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 03:41:35 -0500
Date: Mon, 10 Nov 2008 09:41:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ken Chen <kenchen@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] add /proc/pid/stack to dump task's stack trace
Message-ID: <20081110084123.GE22392@elte.hu>
References: <20081106203520.GD3578@elte.hu> <20081107003021.GA18666@google.com> <20081107004824.GA28780@x200.localdomain> <20081107074147.GA26607@elte.hu> <20081107075925.GA1825@elte.hu> <20081107082003.GA15800@x200.localdomain> <20081107083249.GD4435@elte.hu> <b040c32a0811071038g5e6faba6n55b22e52e1d2ea98@mail.gmail.com> <20081108121054.GG8354@elte.hu> <20081109180841.GB3127@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081109180841.GB3127@x200.localdomain>
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


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Sat, Nov 08, 2008 at 01:10:54PM +0100, Ingo Molnar wrote:
> > Sidenote: it would still be nice if the procfs folks converted the 
> > old-style code there to the new seqfile APIs, before requiring 
> > everyone _else_ to follow those guidelines?
> 
> For every existing non seqfile /proc file, there may be (and was 
> demonstrated) some userspace which is doing pread(2) on it and 
> seqfiles don't support pread currently. Obviously, no such userspace 
> exist for /proc/*/stack.

ok, i then dont understand why we are advocating seqfile use, while 
seqfiles are inferior replacements in certain aspects (no pread(2) 
support). Adding pread(2) support would remove all doubt, and it could 
be converted all across the spectrum, eliminating any confusion about 
which facility to use, right?

	Ingo
