Return-Path: <linux-kernel-owner+w=401wt.eu-S1757938AbZBTNap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938AbZBTNap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 08:30:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754353AbZBTNaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 08:30:35 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51742 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862AbZBTNae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 08:30:34 -0500
Date: Fri, 20 Feb 2009 10:30:11 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, Jason Baron <jbaron@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [rfd] function-graph augmentation
Message-ID: <20090220133011.GB16897@ghostprotocols.net>
References: <1235077304.4612.662.camel@laptop> <20090219212807.GA5084@nowhere> <20090220085627.GE24555@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220085627.GE24555@elte.hu>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Feb 20, 2009 at 09:56:27AM +0100, Ingo Molnar escreveu:
> 2)
> 
> Another, entirely different, and i think complementary approach, 
> which exciting new possibilities would be to (also) 
> automatically pick up arguments from the stack, on function 
> entry.
> 
> If there's a (read-mostly, lockless-to-read and scalable) 
> function attributes hash, then we could encode the parameters 
> signature of functions (or at least, of certain functions) in 
> the attributes hash. Then the tracer will know how many 
> arguments to pick up from the stack.
> 
> This approach has the advantage that we could reconstruct the 
> parameters of _arbitrary_ functions, without having to touch 
> those functions. We already enumerate all functions during build 
> time, it would take some more dwarf2 magic to recover the 
> call/parameter signature. Oh, and at that time we could also 
> record the _return type_ - easing the return value.
> 
> Note that it does not take a full, bloated DEBUG_INFO build - we 
> can build a -g object to get the dwarf2 data and then strip out 
> the dwarf2 data.
> 
> Arnaldo, what do you think about this, how feasible would it be 
> to put dwarf2 magic into scripts/recordmcount.pl?

/me reading scripts/recordmcount.pl...

- Arnaldo
