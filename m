Return-Path: <linux-kernel-owner+w=401wt.eu-S1753321AbZA1ADe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbZA1ADe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 19:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751262AbZA1ADZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 19:03:25 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:56656 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbZA1ADZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 19:03:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=C9uasKusxHjP79P/rLjqfPY/daBb65EK1xmAhi76704xXsqQxR6GVz+iZbzIT3aiSS
         cHqErl87hMVNwQp+OjSg69bMsNgEQe7iga0jSnbp+79j8M2/zbivweefW/LNr/LCvNpa
         Pq7XyN6p2S3wYEkjk10t36q1pS9V5QEvNRwkU=
Subject: Re: [mingo@elte.hu: [git pull] headers_check fixes]
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0901271441280.3123@localhost.localdomain>
References: <20090127222825.GA27097@elte.hu>
	 <alpine.LFD.2.00.0901271441280.3123@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 27 Jan 2009 16:03:21 -0800
Message-Id: <1233101001.6717.5.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-27 at 14:57 -0800, Linus Torvalds wrote:
> 
> On Tue, 27 Jan 2009, Ingo Molnar wrote:
> > 
> > Should i perhaps not bother with the stuff below? Cannot turn off 
> > CONFIG_HEADERS_CHECK in my builds because it can cause build failures.

> So I think it makes our headers worse. Code like
> 
> 	> +#ifdef __KERNEL__
> 	> +# ifdef CONFIG_X86_BSWAP
> 	> +# define __X86_BSWAP  
> 	> +# endif /* CONFIG_X86_BSWAP */
> 	> +#endif /* __KERNEL__ */
> 
> just doesn't make sense. It doesn't make sense _inside_ the kernel, and it 
> doesn't make sense _outside_ it either.
> 

Or just wrap all of asm/swab.h in #ifdef __KERNEL__.

Harvey



