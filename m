Return-Path: <linux-kernel-owner+w=401wt.eu-S1761802AbZFMR6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761802AbZFMR6R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 13:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbZFMR6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 13:58:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33920 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbZFMR6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 13:58:03 -0400
Message-ID: <4A33E892.6010704@zytor.com>
Date: Sat, 13 Jun 2009 10:57:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asm-generic: hard_irqs: handle NR_IRQS > 256 automatically
References: <1244903447-23579-1-git-send-email-vapier@gentoo.org> <1244903447-23579-2-git-send-email-vapier@gentoo.org>
In-Reply-To: <1244903447-23579-2-git-send-email-vapier@gentoo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> If we're going to automatically set HARDIRQ_BITS for the arch, might as
> well be a little bit smart about it and set it to 9 automatically if
> NR_IRQS is larger than 8 bits.
> 

Why would the only possible values be 8 or 9?

>  
>  #ifndef HARDIRQ_BITS
> -#define HARDIRQ_BITS	8
> +# if NR_IRQS > 256
> +#  define HARDIRQ_BITS	9
> +# else
> +#  define HARDIRQ_BITS	8
> +# endif
>  #endif
>  
>  /*


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

