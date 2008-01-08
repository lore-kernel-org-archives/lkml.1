Return-Path: <linux-kernel-owner+w=401wt.eu-S1756072AbYAHUGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbYAHUGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 15:06:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbYAHUGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 15:06:16 -0500
Received: from hu-out-0506.google.com ([72.14.214.232]:41462 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbYAHUGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 15:06:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=WzT9Uk1vZ+hzzGXdGbtfQgna6HvIfoQP0NUk+IinEO1fpCN07zVOXOsR48q6JM31RpKoVgz/+JN13td6beb8rj0V3j4fzuk+5bJmx6kmuviDNrqhbmdckg8vZNyJ/n/hL91Tj7zT6vQZl39TVTPcQVKG39DOUZjbQgsRqFKwlV4=
Date: Tue, 8 Jan 2008 23:06:07 +0300
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, trivial@kernel.org
Subject: Re: [PATCH 5/5] x86: coding style fixes in arch/x86/ia32/ia32_signal.c
Message-ID: <20080108200607.GD4627@martell.zuzino.mipt.ru>
References: <20080108203254.621a22ae@paolo-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108203254.621a22ae@paolo-desktop>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  #define RELOAD_SEG(seg,mask)						\
>  	{ unsigned int cur; 						\
> -	  unsigned short pre;						\
> -	  err |= __get_user(pre, &sc->seg);				\
> -    	  asm volatile("movl %%" #seg ",%0" : "=r" (cur));		\
> -	  pre |= mask; 							\
> -	  if (pre != cur) loadsegment(seg,pre); }
> +	unsigned short pre;						\
> +	err |= __get_user(pre, &sc->seg);				\
> +	asm volatile("movl %%" #seg ",%0" : "=r" (cur));		\
> +	  pre |= mask;
> +	  if (pre != cur) loadsegment(seg, pre); }

No comments.
