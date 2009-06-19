Return-Path: <linux-kernel-owner+w=401wt.eu-S1759312AbZFSCO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759312AbZFSCO1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 22:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbZFSCOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 22:14:20 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:63439 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbZFSCOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 22:14:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pUPpH4MTgEd7osvsj0GWCw/ElhYJfnObuxvpUxy2R2TP1hfpE+XzAWdjIcGa4+o5Ra
         kKdr0S3jeICc9/P/7903lsNMum5afmnGJVH/d6FqZ/tSV01W/PTdLOM/PM0uOC6lXRyH
         HGdE778LWJQgRO7n+LZm6uJn9RPIR2zZNasHQ=
Date: Fri, 19 Jun 2009 04:14:18 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, bligh@google.com, roland@redhat.com,
       fche@redhat.com
Subject: Re: [PATCH 5/7] add syscall tracepoints
Message-ID: <20090619021418.GC7903@nowhere>
References: <cover.1244837725.git.jbaron@redhat.com> <51b4e9aff767dac4933ebb7835dee7068b158db8.1244837725.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51b4e9aff767dac4933ebb7835dee7068b158db8.1244837725.git.jbaron@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 05:24:59PM -0400, Jason Baron wrote:
> update FTRACE_SYSCALL_MAX to the current number of syscalls
> 
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> 
> ---
>  arch/x86/include/asm/ftrace.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
> index bd2c651..d16d195 100644
> --- a/arch/x86/include/asm/ftrace.h
> +++ b/arch/x86/include/asm/ftrace.h
> @@ -30,9 +30,9 @@
>  
>  /* FIXME: I don't want to stay hardcoded */


BTW, is there a way to know this size dynamically?
Or is there already a hardcoded number of syscalls somewhere
in x86?

Frederic.


>  #ifdef CONFIG_X86_64
> -# define FTRACE_SYSCALL_MAX     296
> +# define FTRACE_SYSCALL_MAX     298
>  #else
> -# define FTRACE_SYSCALL_MAX     333
> +# define FTRACE_SYSCALL_MAX     336
>  #endif
>  
>  #ifdef CONFIG_FUNCTION_TRACER
> -- 
> 1.6.0.6
> 

