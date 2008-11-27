Return-Path: <linux-kernel-owner+w=401wt.eu-S1754853AbYK0Xbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbYK0Xbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 18:31:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbYK0Xbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 18:31:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:44873 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbYK0Xbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 18:31:36 -0500
Date: Thu, 27 Nov 2008 18:31:34 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Hugh Dickins <hugh@veritas.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Miles Lane <miles.lane@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Tejun Heo <htejun@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: 2.6.28-rc6-git1 -- BUG: unable to handle kernel paging request
 at ffff8800be8b0019
In-Reply-To: <Pine.LNX.4.64.0811271643250.9618@blonde.site>
Message-ID: <alpine.DEB.1.10.0811271827490.7113@gandalf.stny.rr.com>
References: <a44ae5cd0811250850g725a5a5nd7d93a23ffd2fce6@mail.gmail.com>  <200811270026.37941.rjw@sisk.pl>  <84144f020811270537l3798b2f5ka63caacbee43b075@mail.gmail.com>  <Pine.LNX.4.64.0811271349040.21910@blonde.site> <84144f020811270613t3f0258ddxac52abb9a447bf40@mail.gmail.com>
 <Pine.LNX.4.64.0811271643250.9618@blonde.site>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ Added Frederic ]

On Thu, 27 Nov 2008, Hugh Dickins wrote:
>  					break;
> --- 2.6.28-rc6/include/linux/ftrace.h	2008-11-02 23:17:56.000000000 +0000
> +++ linux/include/linux/ftrace.h	2008-11-27 16:39:26.000000000 +0000
> @@ -231,7 +231,7 @@ ftrace_init_module(unsigned long *start,
>  
>  struct boot_trace {
>  	pid_t			caller;
> -	char			func[KSYM_NAME_LEN];
> +	char			func[KSYM_SYMBOL_LEN];
>  	int			result;
>  	unsigned long long	duration;		/* usecs */
>  	ktime_t			calltime;

Acked-by: Steven Rostedt <srostedt@redhat.com>

The boot tracer was written by Frederic.

-- Steve

