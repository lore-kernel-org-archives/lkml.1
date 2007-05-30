Return-Path: <linux-kernel-owner+w=401wt.eu-S1758087AbXE3Tj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087AbXE3Tj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 15:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754282AbXE3TjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 15:39:20 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:49248 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbXE3TjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 15:39:19 -0400
Subject: Re: [PATCH 5/6] lockstat: human readability tweaks
From: Matthew Helsley <matthltc@us.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Bill Huey <billh@gnuppy.monkey.org>,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20070530125336.322824180@chello.nl>
References: <20070530124903.882133089@chello.nl>
	 <20070530125336.322824180@chello.nl>
Content-Type: text/plain
Date: Wed, 30 May 2007 12:39:05 -0700
Message-Id: <1180553945.4738.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-30 at 14:49 +0200, Peter Zijlstra wrote:
> plain text document attachment (lockstat-output.patch)
> Present all this fancy new lock statistics information:
> 
> *warning, _wide_ output ahead*
> 
> (output edited for purpose of brevity)
> 
>  # cat /proc/lock_stat
> lock_stat version 0.1
> -----------------------------------------------------------------------------------------------------------------------------------------------------------------
>                               class name    contentions   waittime-min   waittime-max waittime-total   acquisitions   holdtime-min   holdtime-max holdtime-total
> -----------------------------------------------------------------------------------------------------------------------------------------------------------------

<snip>

> 'contentions' and 'acquisitions' are the number of such events measured (since 
> the last reset). The waittime- and holdtime- (min, max, total) numbers are 
> presented in microseconds.

I think it would make sense to actually mention the time scale in the
output header someplace. Then a tool written to analyze this file will
have a way of determining the time scale without using error-prone
heuristics (like "kernel version foo uses microseconds while kernel foo
+ 100 uses nanoseconds").

<snip>

Cheers,
	-Matt Helsley

