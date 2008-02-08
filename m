Return-Path: <linux-kernel-owner+w=401wt.eu-S1756499AbYBHVOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbYBHVOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 16:14:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117AbYBHVNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 16:13:55 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:57298 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbYBHVNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 16:13:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=Ni6SQt0HvrEqfddxSeXH/+a7hPy1czY4U2vA0XG6gMS31+xZ4pdFfRah205/5JAwzi4a+32FWK65ic6KMpivns7RKgkVoF5wP724LRV1o82E2zaYV09l+iLdDaIMRmqkrOrZnlY7aj5RIxiA5dBJhHHP4fjvBPD006e1N1RA8d0=
Date: Sat, 9 Feb 2008 00:13:44 +0300
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/9] x86: change most X86_32 pt_regs members to unsigned long
Message-ID: <20080208211344.GB15571@martell.zuzino.mipt.ru>
References: <1202501396.12966.20.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202501396.12966.20.camel@brick>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 12:09:56PM -0800, Harvey Harrison wrote:
> All but ax and orig_ax can move with no changes.

> --- a/include/asm-x86/ptrace.h
> +++ b/include/asm-x86/ptrace.h
> @@ -36,23 +36,23 @@ struct pt_regs {
>  #else /* __KERNEL__ */
>  
>  struct pt_regs {
> -	long bx;
> -	long cx;
> -	long dx;
> -	long si;
> -	long di;
> -	long bp;
> +	unsigned long bx;
> +	unsigned long cx;
> +	unsigned long dx;
> +	unsigned long si;
> +	unsigned long di;
> +	unsigned long bp;
>  	long ax;
> -	int  ds;
> -	int  es;
> -	int  fs;
> +	unsigned long ds;
> +	unsigned long es;
> +	unsigned long fs;
>  	/* int  gs; */
>  	long orig_ax;
> -	long ip;
> -	int  cs;
> -	long flags;
> -	long sp;
> -	int  ss;
> +	unsigned long ip;
> +	unsigned long cs;
> +	unsigned long flags;
> +	unsigned long sp;
> +	unsigned long ss;

Why?! You don't have even minimal chances to unify pt_regs for i386 and
x86_64.
