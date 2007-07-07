Return-Path: <linux-kernel-owner+w=401wt.eu-S1753740AbXGGR40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbXGGR40 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 13:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbXGGR4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 13:56:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbXGGR4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 13:56:20 -0400
Date: Sat, 7 Jul 2007 13:55:03 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Dave Jones <davej@redhat.com>, Chuck Ebbert <cebbert@redhat.com>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 10/10] Scheduler profiling - Use immediate values
Message-ID: <20070707175503.GI24475@redhat.com>
References: <20070703181151.GB5800@martell.zuzino.mipt.ru> <20070703185748.GA4047@Krystal> <20070705132120.8edbc1f3.akpm@linux-foundation.org> <p73vecx21um.fsf@bingen.suse.de> <468EBEB2.4070605@redhat.com> <20070706232843.GT3492@stusta.de> <20070706233827.GC13125@redhat.com> <20070707001008.GV3492@stusta.de> <y0mvecwusj3.fsf@ton.toronto.redhat.com> <20070707170157.GH3492@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070707170157.GH3492@stusta.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Adrian -

On Sat, Jul 07, 2007 at 07:01:57PM +0200, Adrian Bunk wrote:
> [...]
> > Things are not so simple.  One might not know that one has a
> > performance problem until one tries some analysis tools.  Rebooting
> > into different kernels just to investigate does not work generally [...]
> 
> I'm not getting this:
>
> You'll only start looking into an analysis tool if you have a
> performance problem, IOW if you are not satisfied with the
> performance.

There may be people whose jobs entail continually suspecting
performance problems.  Or one may run instrumentation code on a
long-term basis specifically to locate performance spikes.

> And the debug code will not have been tested on this machine no matter 
> whether it's enabled through a compile option or at runtime.

There is a big difference in favour of the former.  The additional
instrumentation code may be small enough to inspect carefully.  The
rest of the kernel would be unaffected.

> [...]  If you might be able to get a big part of tracing and other
> debug code enabled with a performance penalty of a few percent of
> _kernel_ performance, then you might get much debugging aid without
> any effective impact on application performance.

Agreed.


- FChE
