Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbZBFHE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbZBFHE6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 02:04:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbZBFHEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 02:04:50 -0500
Received: from gate.crashing.org ([63.228.1.57]:49183 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbZBFHEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 02:04:50 -0500
Subject: Re: [PATCH 0/2] ftrace: updates for powerpc
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Michael Neuling <mikey@neuling.org>
In-Reply-To: <20090206060328.181057235@goodmis.org>
References: <20090206060328.181057235@goodmis.org>
Content-Type: text/plain
Date: Fri, 06 Feb 2009 18:04:19 +1100
Message-Id: <1233903859.4612.119.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-06 at 01:03 -0500, Steven Rostedt wrote:
> Paul,
> 
> The first patch is a ftrace clean up to use the proper pr_debug macro.
> 
> The second patch is to fix a compile error when dynamic ftrace
> is compiled in, but modules are not.

Did you find out the problem with the large USB module ?

Cheers,
Ben.

> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: ppc/ftrace
> 
> 
> Steven Rostedt (2):
>       ftrace, powerpc: replace debug macro with proper pr_deug
>       powerpc, ftrace: fix compile error when modules not configured
> 
> ----
>  arch/powerpc/kernel/ftrace.c |   42 +++++++++++++++++++++++++-----------------
>  1 files changed, 25 insertions(+), 17 deletions(-)

