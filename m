Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822AbYIWXr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbYIWXr1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 19:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150AbYIWXq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 19:46:59 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:43234 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753106AbYIWXq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 19:46:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgsFAEsa2UhMQWq+/2dsb2JhbACBXrUUgWc
Date: Tue, 23 Sep 2008 19:46:56 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>,
       Harvey Harrison <harvey.harrison@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: suppress trivial sparse signedness warnings
Message-ID: <20080923234656.GA26986@Krystal>
References: <1222207546.16003.21.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1222207546.16003.21.camel@brick>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:46:40 up 111 days,  4:27,  7 users,  load average: 0.30, 0.28,
	0.27
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should probably go to Steven...

* Harvey Harrison (harvey.harrison@gmail.com) wrote:
> Could just as easily change the three casts to cast to the correct
> type...this patch changes the type of ftrace_nop instead.
> 
> Supresses sparse warnings:
> arch/x86/kernel/ftrace.c:157:14: warning: incorrect type in assignment (different signedness)
> arch/x86/kernel/ftrace.c:157:14:    expected long *static [toplevel] ftrace_nop
> arch/x86/kernel/ftrace.c:157:14:    got unsigned long *<noident>
> arch/x86/kernel/ftrace.c:161:14: warning: incorrect type in assignment (different signedness)
> arch/x86/kernel/ftrace.c:161:14:    expected long *static [toplevel] ftrace_nop
> arch/x86/kernel/ftrace.c:161:14:    got unsigned long *<noident>
> arch/x86/kernel/ftrace.c:165:14: warning: incorrect type in assignment (different signedness)
> arch/x86/kernel/ftrace.c:165:14:    expected long *static [toplevel] ftrace_nop
> arch/x86/kernel/ftrace.c:165:14:    got unsigned long *<noident>
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  arch/x86/kernel/ftrace.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index 082d996..66d9002 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -22,7 +22,7 @@
>  
>  
>  /* Long is fine, even if it is only 4 bytes ;-) */
> -static long *ftrace_nop;
> +static unsigned long *ftrace_nop;
>  
>  union ftrace_code_union {
>  	char code[MCOUNT_INSN_SIZE];
> -- 
> 1.6.0.2.471.g47a76
> 
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
