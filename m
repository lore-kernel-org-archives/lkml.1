Return-Path: <linux-kernel-owner+w=401wt.eu-S1756908AbYLDNQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbYLDNQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 08:16:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294AbYLDNQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 08:16:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63881 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbYLDNQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 08:16:17 -0500
Date: Thu, 4 Dec 2008 08:16:15 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, containers@lists.osdl.org,
       Eric Biederman <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH] tracing: fix typo and missing inline function
In-Reply-To: <20081204083419.GA8918@elte.hu>
Message-ID: <alpine.DEB.1.10.0812040815350.5240@gandalf.stny.rr.com>
References: <20081204052638.425740534@goodmis.org> <20081204081008.GC32594@elte.hu> <20081204083059.GA8131@elte.hu> <20081204083419.GA8918@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 4 Dec 2008, Ingo Molnar wrote:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > small fixlet below.
> 
> updated.
> 
> --------------->
> >From 6b2539302bee8e88c99e3c7d80c16a04dbe5e2ad Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Thu, 4 Dec 2008 09:18:28 +0100
> Subject: [PATCH] tracing: fix typo and missing inline function
> 
> Impact: fix build bugs
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/trace/trace.h |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 8b81b4d..b4b7b73 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -529,7 +529,11 @@ static inline int ftrace_graph_addr(unsigned long addr)
>  #else
>  static inline int ftrace_trace_addr(unsigned long addr)
>  {
> -	return 1
> +	return 1;
> +}
> +static inline int ftrace_graph_addr(unsigned long addr)
> +{
> +	return 1;
>  }
>  #endif /* CONFIG_DYNAMIC_FTRACE */

Thanks! I guess I need to test the "off" cases ;-)

-- Steve

