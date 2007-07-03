Return-Path: <linux-kernel-owner+w=401wt.eu-S1761639AbXGCVa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761639AbXGCVa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 17:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755133AbXGCVaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 17:30:20 -0400
Received: from terminus.zytor.com ([192.83.249.54]:49116 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942AbXGCVaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 17:30:19 -0400
Message-ID: <468ABFE0.5090902@zytor.com>
Date: Tue, 03 Jul 2007 14:30:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 06/10] Immediate Value - i386 Optimization
References: <20070703164046.645090494@polymtl.ca> <20070703164515.071300768@polymtl.ca> <468A9956.9050903@zytor.com> <20070703191605.GB4047@Krystal> <468AAF1F.6010909@zytor.com> <20070703204347.GA8876@Krystal>
In-Reply-To: <20070703204347.GA8876@Krystal>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> 
> If we can change the compiler, here is what we could do:
> 
> Tell GCC to put NOPs that could be altered by a branch alternative to
> some specified code. We should be able to get the instruction pointers
> (think of inlines) to these nop/branch instructions so we can change
> them dynamically.
> 

Changing the compiler should be perfectly feasible, *BUT* I think we
need a transitional solution that works on existing compilers.

> I suspect this would be inherently tricky. If someone is ready to do
> this and tells me "yes, it will be there in 1 month", I am more than
> ready to switch my markers to this and help, but since the core of my
> work is kernel tracing, I don't have the time nor the ressources to
> tackle this problem.
> 
> In the event that someone answers "we'll do this in the following 3
> years", I might consider to change the if (immediate(var)) into an
> immediate_if (var) so we can later proceed to the change with simple
> ifdefs without rewriting all the kernel code that would use it.

This is much more of "we'll do that in the following 1-2 years", since
we have to deal with a full gcc development cycle.  However, I really
want to see this being implemented in a way that would let us DTRT in
the long run.

	-hpa
