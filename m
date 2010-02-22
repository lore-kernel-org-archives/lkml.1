Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab0BVSgz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:36:55 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:46122 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355Ab0BVSgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:36:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OnCF8QzEiCg0RikR0Q+Vl3WKnim0/KPiADoHi8n7RrhsFOxvzHORtgr5rDgnItsqUY
         08bMar5QJYl1OgcHTCpqTAp/rZFk2MWzaNMTojWCcrlzUL2Y5wZLCQnfAhjpsffrdj/J
         ibREZEZqkoVfUv0PVV5pNx0CbSDMHEB3g6b00=
Date: Mon, 22 Feb 2010 19:36:48 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 01/10] ARM: ftrace: clean up mcount assembly indentation
Message-ID: <20100222183646.GH5055@nowhere>
References: <1266090518-31120-1-git-send-email-rabin@rab.in> <1266090518-31120-2-git-send-email-rabin@rab.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266090518-31120-2-git-send-email-rabin@rab.in>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 14, 2010 at 01:18:29AM +0530, Rabin Vincent wrote:
> The mcount implementation currently uses a different indentation style
> from the rest of the file (and the rest of the ARM assembly in the
> kernel).  Clean it up.
> 
> Signed-off-by: Rabin Vincent <rabin@rab.in>
> ---


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>



>  arch/arm/kernel/entry-common.S |   88 ++++++++++++++++++++--------------------
>  1 files changed, 44 insertions(+), 44 deletions(-)
> 
> diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
> index 2c1db77..0b042bd 100644
> --- a/arch/arm/kernel/entry-common.S
> +++ b/arch/arm/kernel/entry-common.S
> @@ -94,73 +94,73 @@ ENDPROC(ret_from_fork)
>  #ifdef CONFIG_FUNCTION_TRACER
>  #ifdef CONFIG_DYNAMIC_FTRACE
>  ENTRY(mcount)
> -	stmdb sp!, {r0-r3, lr}
> -	mov r0, lr
> -	sub r0, r0, #MCOUNT_INSN_SIZE
> +	stmdb	sp!, {r0-r3, lr}
> +	mov	r0, lr
> +	sub	r0, r0, #MCOUNT_INSN_SIZE
>  
>  	.globl mcount_call
>  mcount_call:
> -	bl ftrace_stub
> -	ldr lr, [fp, #-4]			@ restore lr
> -	ldmia sp!, {r0-r3, pc}
> +	bl	ftrace_stub
> +	ldr	lr, [fp, #-4]			@ restore lr
> +	ldmia	sp!, {r0-r3, pc}
>  
>  ENTRY(ftrace_caller)
> -	stmdb sp!, {r0-r3, lr}
> -	ldr r1, [fp, #-4]
> -	mov r0, lr
> -	sub r0, r0, #MCOUNT_INSN_SIZE
> +	stmdb	sp!, {r0-r3, lr}
> +	ldr	r1, [fp, #-4]
> +	mov	r0, lr
> +	sub	r0, r0, #MCOUNT_INSN_SIZE
>  
>  	.globl ftrace_call
>  ftrace_call:
> -	bl ftrace_stub
> -	ldr lr, [fp, #-4]			@ restore lr
> -	ldmia sp!, {r0-r3, pc}
> +	bl	ftrace_stub
> +	ldr	lr, [fp, #-4]			@ restore lr
> +	ldmia	sp!, {r0-r3, pc}
>  
>  #else
>  
>  ENTRY(__gnu_mcount_nc)
> -	stmdb sp!, {r0-r3, lr}
> -	ldr r0, =ftrace_trace_function
> -	ldr r2, [r0]
> -	adr r0, ftrace_stub
> -	cmp r0, r2
> -	bne gnu_trace
> -	ldmia sp!, {r0-r3, ip, lr}
> -	mov pc, ip
> +	stmdb	sp!, {r0-r3, lr}
> +	ldr	r0, =ftrace_trace_function
> +	ldr	r2, [r0]
> +	adr	r0, ftrace_stub
> +	cmp	r0, r2
> +	bne	gnu_trace
> +	ldmia	sp!, {r0-r3, ip, lr}
> +	mov	pc, ip
>  
>  gnu_trace:
> -	ldr r1, [sp, #20]			@ lr of instrumented routine
> -	mov r0, lr
> -	sub r0, r0, #MCOUNT_INSN_SIZE
> -	mov lr, pc
> -	mov pc, r2
> -	ldmia sp!, {r0-r3, ip, lr}
> -	mov pc, ip
> +	ldr	r1, [sp, #20]			@ lr of instrumented routine
> +	mov	r0, lr
> +	sub	r0, r0, #MCOUNT_INSN_SIZE
> +	mov	lr, pc
> +	mov	pc, r2
> +	ldmia	sp!, {r0-r3, ip, lr}
> +	mov	pc, ip
>  
>  ENTRY(mcount)
> -	stmdb sp!, {r0-r3, lr}
> -	ldr r0, =ftrace_trace_function
> -	ldr r2, [r0]
> -	adr r0, ftrace_stub
> -	cmp r0, r2
> -	bne trace
> -	ldr lr, [fp, #-4]			@ restore lr
> -	ldmia sp!, {r0-r3, pc}
> +	stmdb	sp!, {r0-r3, lr}
> +	ldr	r0, =ftrace_trace_function
> +	ldr	r2, [r0]
> +	adr	r0, ftrace_stub
> +	cmp	r0, r2
> +	bne	trace
> +	ldr	lr, [fp, #-4]			@ restore lr
> +	ldmia	sp!, {r0-r3, pc}
>  
>  trace:
> -	ldr r1, [fp, #-4]			@ lr of instrumented routine
> -	mov r0, lr
> -	sub r0, r0, #MCOUNT_INSN_SIZE
> -	mov lr, pc
> -	mov pc, r2
> -	ldr lr, [fp, #-4]			@ restore lr
> -	ldmia sp!, {r0-r3, pc}
> +	ldr	r1, [fp, #-4]			@ lr of instrumented routine
> +	mov	r0, lr
> +	sub	r0, r0, #MCOUNT_INSN_SIZE
> +	mov	lr, pc
> +	mov	pc, r2
> +	ldr	lr, [fp, #-4]			@ restore lr
> +	ldmia	sp!, {r0-r3, pc}
>  
>  #endif /* CONFIG_DYNAMIC_FTRACE */
>  
>  	.globl ftrace_stub
>  ftrace_stub:
> -	mov pc, lr
> +	mov	pc, lr
>  
>  #endif /* CONFIG_FUNCTION_TRACER */
>  
> -- 
> 1.6.6
> 

