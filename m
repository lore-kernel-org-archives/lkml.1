Return-Path: <linux-kernel-owner+w=401wt.eu-S1752413AbZHKL5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413AbZHKL5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 07:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbZHKL5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 07:57:32 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:58421 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbZHKL51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 07:57:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=m4Xj4i92vLiKGo3jWgQsHb6qfZIFccDYPCpEPQmjy3xUm4e8OU+AiJWsE4sUYsL8l1
         SgRAPdFV+KtGghHIIxhx9g6vqyiEiP5Any1hBRikXEsMtM8AlG0EKzri1Bdcp6er8jaV
         m1Q/NDAZWP/fQRcKboKhmb2i7G8O6CAyqMCpY=
Date: Tue, 11 Aug 2009 13:00:25 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, lizf@cn.fujitsu.com
Subject: Re: [PATCH 05/12] update FTRACE_SYSCALL_MAX
Message-ID: <20090811110023.GC4938@nowhere>
References: <cover.1249932670.git.jbaron@redhat.com> <7fca984182691041c0d139eccd080f82045f86f7.1249932670.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fca984182691041c0d139eccd080f82045f86f7.1249932670.git.jbaron@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 04:52:35PM -0400, Jason Baron wrote:
> update FTRACE_SYSCALL_MAX to the current number of syscalls
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> 
> ---
>  arch/x86/include/asm/ftrace.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
> index bd2c651..7113654 100644
> --- a/arch/x86/include/asm/ftrace.h
> +++ b/arch/x86/include/asm/ftrace.h
> @@ -30,9 +30,9 @@
>  
>  /* FIXME: I don't want to stay hardcoded */
>  #ifdef CONFIG_X86_64
> -# define FTRACE_SYSCALL_MAX     296
> +# define FTRACE_SYSCALL_MAX     299
>  #else
> -# define FTRACE_SYSCALL_MAX     333
> +# define FTRACE_SYSCALL_MAX     337
>  #endif


I don't remember why we had to use a hardcoded number.
Is there no way to keep being sync with the current number of
syscalls? We dwant to avoid patching the kernel each time we
have a new syscall :-)

  
>  #ifdef CONFIG_FUNCTION_TRACER
> -- 
> 1.6.2.5
> 

