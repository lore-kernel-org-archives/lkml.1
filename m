Return-Path: <linux-kernel-owner+w=401wt.eu-S935807AbXGRAiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935807AbXGRAiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 20:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760173AbXGRAiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 20:38:46 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40165 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760031AbXGRAip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 20:38:45 -0400
Date: Tue, 17 Jul 2007 17:38:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, clameter@sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>
Subject: Re: 2.6.23 compile failure - slab/slob interspanking
Message-Id: <20070717173823.2e0de83f.akpm@linux-foundation.org>
In-Reply-To: <20070718001836.GA30154@linux-sh.org>
References: <Pine.LNX.4.64.0707172148310.27468@fbirervta.pbzchgretzou.qr>
	<20070718001836.GA30154@linux-sh.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2007 09:18:36 +0900
Paul Mundt <lethal@linux-sh.org> wrote:

> --- a/include/linux/slob_def.h
> +++ b/include/linux/slob_def.h
> @@ -33,14 +33,4 @@ static inline void *__kmalloc(size_t size, gfp_t flags)
>  	return kmalloc(size, flags);
>  }
>  
> -/**
> - * kzalloc - allocate memory. The memory is set to zero.
> - * @size: how many bytes of memory are required.
> - * @flags: the type of memory to allocate (see kcalloc).
> - */
> -static inline void *kzalloc(size_t size, gfp_t flags)
> -{
> -	return __kzalloc(size, flags);
> -}

yeah, that might well have got lost somewhere in the past month's mayhem.

