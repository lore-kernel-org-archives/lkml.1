Return-Path: <linux-kernel-owner+w=401wt.eu-S1756550AbYLPMW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550AbYLPMW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 07:22:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbYLPMWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 07:22:47 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:42956 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbYLPMWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 07:22:47 -0500
Date: Tue, 16 Dec 2008 13:22:29 +0100
From: Pavel Machek <pavel@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       perfctr-devel@lists.sourceforge.net
Subject: Re: [patch] Performance Counters for Linux, v4
Message-ID: <20081216122229.GA1430@ucw.cz>
References: <20081214212829.GA9435@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081214212829.GA9435@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-12-14 22:28:29, Ingo Molnar wrote:
> We are pleased to announce the v4 release of our performance counters 
> subsystem implementation. The kernel changes can be picked up from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perfcounters/core
> 
>   (also in the master branch. There's also a kernel patch attached 
>    below.)
> 
> The biggest new feature in this release is the implementation of 
> "performance counter inheritance" for the per task counters: the ability 
> to extend performance counters to cover the execution of child tasks 
> too, transparently and automatically - following them to other CPUs.
> 
> This can be used to monitor a hierarchy of tasks without stopping them 
> (or impacting them in any observable way), and extending that monitoring 
> to all child tasks as well.
> 
> We've written a new utility: 'timec', which takes advantage of this new 
> kernel capability:
> 
>      http://redhat.com/~mingo/perfcounters/timec.c
> 
> 'timec' works like /usr/bin/time, but it extends the dimension of "time" 
> with all the metrics that hardware and software performance counters are 
> able to capture.

Hmm, if I timec some setuid program, what happens?

Performance counters seem like great tool to pull secret keys out of
other processes :-).
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
