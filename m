Return-Path: <linux-kernel-owner+w=401wt.eu-S1755557AbYAHUDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbYAHUDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 15:03:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbYAHUDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 15:03:01 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:37316 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbYAHUDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 15:03:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=Uj1TETEX52w3Cs5t3jMgRuq5qg8vzLk/luO2FC+HLlSsEoo1cRYTHLpp+MXRmkXpW2AeYTUg6xpymqXBpzrg0EEh5iucKFC6xkOxGj/xi5NeYYJBERwrdRO3+2BVR8VQUoB2rPLOypyH5wvED3rak3gMZ5OrkJcUr+TgYACNoU0=
Date: Tue, 8 Jan 2008 23:02:50 +0300
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, trivial@kernel.org
Subject: Re: [PATCH 4/5] x86: coding style fixes in arch/x86/ia32/ia32_binfmt.c
Message-ID: <20080108200250.GC4627@martell.zuzino.mipt.ru>
References: <20080108203242.5e033d97@paolo-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108203242.5e033d97@paolo-desktop>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  static void elf32_init(struct pt_regs *regs)
>  {
> -	struct task_struct *me = current; 
> +	struct task_struct *me = current;
>  	regs->rdi = 0;
>  	regs->rsi = 0;
>  	regs->rdx = 0;
>  	regs->rcx = 0;
>  	regs->rax = 0;
> -	regs->rbx = 0; 
> -	regs->rbp = 0; 
> +	regs->rbx = 0;
> +	regs->rbp = 0;
>  	regs->r8 = regs->r9 = regs->r10 = regs->r11 = regs->r12 =
> -		regs->r13 = regs->r14 = regs->r15 = 0; 
> -    me->thread.fs = 0; 
> +		regs->r13 = regs->r14 = regs->r15 = 0;
> +    me->thread.fs = 0;
>  	me->thread.gs = 0;
> -	me->thread.fsindex = 0; 
> +	me->thread.fsindex = 0;
>  	me->thread.gsindex = 0;
> -    me->thread.ds = __USER_DS; 
> +    me->thread.ds = __USER_DS;

No re-indenting those 4-spaced lines? I mean if you're in CodindStyle
compliance business driving from 99 to 99.9 percents please do it well
at least.
