Return-Path: <linux-kernel-owner+w=401wt.eu-S1751153AbZITLXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751153AbZITLXs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 07:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbZITLXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 07:23:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43018 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbZITLXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 07:23:47 -0400
Subject: Re: [PATCH] trace: export trace_profile_buf symbols
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1253442878.7542.3.camel@laptop>
References: <1253442878.7542.3.camel@laptop>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Sun, 20 Sep 2009 07:23:49 -0400
Message-Id: <1253445829.20020.626.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-09-20 at 12:34 +0200, Peter Zijlstra wrote:
> ERROR: "trace_profile_buf_nmi" [fs/jbd2/jbd2.ko] undefined!                                                                        
> ERROR: "trace_profile_buf" [fs/jbd2/jbd2.ko] undefined!
> ERROR: "trace_profile_buf_nmi" [fs/ext4/ext4.ko] undefined!
> ERROR: "trace_profile_buf" [fs/ext4/ext4.ko] undefined!
> ERROR: "trace_profile_buf_nmi" [arch/x86/kvm/kvm.ko] undefined!
> ERROR: "trace_profile_buf" [arch/x86/kvm/kvm.ko] undefined!
> 

Peter, I thought you never use modules.

> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> ---
>  kernel/trace/trace_event_profile.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/trace/trace_event_profile.c b/kernel/trace/trace_event_profile.c
> index 3aaa77c..f65e966 100644
> --- a/kernel/trace/trace_event_profile.c
> +++ b/kernel/trace/trace_event_profile.c
> @@ -17,6 +17,9 @@ typedef struct {char buf[FTRACE_MAX_PROFILE_SIZE];} profile_buf_t;
>  char		*trace_profile_buf;
>  char 		*trace_profile_buf_nmi;
>  
> +EXPORT_SYMBOL_GPL(trace_profile_buf);
> +EXPORT_SYMBOL_GPL(trace_profile_buf_nmi);
> +
>  /* Count the events in use (per event id, not per instance) */
>  static int	total_profile_count;
>  
> 
> 

