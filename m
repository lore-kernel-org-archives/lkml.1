Return-Path: <linux-kernel-owner+w=401wt.eu-S1754384AbYKHMG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbYKHMG1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 07:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbYKHMGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 07:06:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34629 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125AbYKHMGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 07:06:19 -0500
Date: Sat, 8 Nov 2008 13:06:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ken Chen <kenchen@google.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] add /proc/pid/stack to dump task's stack trace
Message-ID: <20081108120601.GF8354@elte.hu>
References: <20081107074147.GA26607@elte.hu> <20081107075925.GA1825@elte.hu> <20081107082003.GA15800@x200.localdomain> <20081107083249.GD4435@elte.hu> <20081107084943.GA16147@x200.localdomain> <20081107085352.GA27245@elte.hu> <20081107090304.GA30540@elte.hu> <20081107011659.98d3788a.akpm@linux-foundation.org> <20081107092902.GB7787@elte.hu> <20081107175157.GB3469@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081107175157.GB3469@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0021]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> >  1) only root should be allowed to do this - i.e. file needs to be 
> >     root-owned.
> >
> >  2) there also needs to be a .config entry for folks to be able to
> >     turn it off altogether - just like folks can turn off sysrq-t 
> >     dumping via the .config.
> 
> In the name of everything holy, don't add another config option. 
> It's a _tiny_ piece of code and you have select STACKTRACE via fault 
> injection, latencytop or lockdep before that.

We could make it depend on DEBUG_KERNEL or so, and always select 
STACKTRACE infrastructure when DEBUG_KERNEL is enabled? There's no 
reason not to get high quality backtraces via /proc when one debugs 
the kernel.

	Ingo
