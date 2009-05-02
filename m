Return-Path: <linux-kernel-owner+w=401wt.eu-S1753118AbZEBDQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbZEBDQi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 23:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbZEBDQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 23:16:30 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:51372 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbZEBDQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 23:16:29 -0400
Date: Fri, 1 May 2009 23:06:28 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, thomas.pi@arcor.dea,
       Yuriy Lalym <ylalym@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ltt-dev@lists.casi.polymtl.ca, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Fix dirty page accounting in
 redirty_page_for_writepage()
In-Reply-To: <20090501210724.GB11095@elte.hu>
Message-ID: <alpine.DEB.1.10.0905012234480.32364@qirst.com>
References: <20090430150142.GC20580@elte.hu> <alpine.DEB.1.10.0904301114440.4028@qirst.com> <20090430154255.GA3714@elte.hu> <alpine.DEB.1.10.0904301142140.4028@qirst.com> <20090430160606.GA5913@elte.hu> <alpine.LFD.2.00.0904300914110.3395@localhost.localdomain>
 <20090430172341.GA11865@elte.hu> <alpine.DEB.1.10.0904301406210.11923@qirst.com> <20090501195941.GA28264@elte.hu> <alpine.DEB.1.10.0905011632440.16255@qirst.com> <20090501210724.GB11095@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 May 2009, Ingo Molnar wrote:

> > I see but it may take some time for me to get that finished
> > (probably 2 weeks or so). Dont feel that you have to merge my old
> > patches or a variant thereof.
>
> it's your baby really and i dont want to interfere in any negative
> way. The patches look fairly complete and you did all the hard work
> with them already.

Ah I remember, you drowned that baby when you asked me to do lowercase
macros. That plus the job change made me to lose most of my drive for the
patchset. No employer anymore that wants the stuff... Then there is the
scheduler regression and the network latency issues that prevent my new
project from running kernels after 2.6.22. Time that I have will be mostly
spend on that in the coming weeks. Cannot really push much into newer
kernels until we are able to run upstream kernels without significant loss
in performance.

We just tried 2.6.9. And hey performance is better. Looks like going back
in kernel versions is a way to improve performance. Simpler kernel,
lower cache footprint and it becomes faster. And the app is simply
doing network I/O and some number crunching. Sigh.

> Can help out with review and testing (as always) but i suspect it's
> more appropriate for -mm to carry them in the end, because of the MM
> and tree-wide impact, and because the fine differences between those
> APIs will only be truly visible on non-x86.

I'd be glad to review. But this is not far up in the priority list given
the unresolved regressions.

> ( There's also Tejun's latest improvements of the dynamic allocator
>   that he made based on your feedback - are those in any tree yet? )

No idea. Do not see them upstream.
