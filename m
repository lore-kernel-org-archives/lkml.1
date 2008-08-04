Return-Path: <linux-kernel-owner+w=401wt.eu-S1760208AbYHDGUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760208AbYHDGUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 02:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754668AbYHDGUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 02:20:12 -0400
Received: from smtp.movial.fi ([62.236.91.34]:56942 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754733AbYHDGUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 02:20:11 -0400
Message-ID: <48969F99.1060301@movial.fi>
Date: Mon, 04 Aug 2008 09:20:09 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Organization: Movial Creative Technologies
User-Agent: Icedove 1.5.0.14eol (X11/20080509)
MIME-Version: 1.0
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, hpa <hpa@zytor.com>,
       tglx <tglx@linutronix.de>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] x86: Coding style fixes to arch/x86/lib/strstr_32.c
References: <20080802212445.72fb1d77@paolo-desktop>
In-Reply-To: <20080802212445.72fb1d77@paolo-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Ciarrocchi wrote:
> Before:
> total: 3 errors, 0 warnings, 31 lines checked
> 
> After:
> total: 0 errors, 0 warnings, 31 lines checked
> 
> paolo@paolo-desktop:~/linux.trees.git$ md5sum /tmp/strstr_32.o.*

It seems very tempting to merge this file with arch/x86/lib/string_32.c, or is there any compelling reason to keep these two separate?

> c96006ec3387862e5bacb139207a3098  /tmp/strstr_32.o.after
> c96006ec3387862e5bacb139207a3098  /tmp/strstr_32.o.before
> 
> Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
> ---
>  arch/x86/lib/strstr_32.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/lib/strstr_32.c b/arch/x86/lib/strstr_32.c
> index 42e8a50..8e2d55f 100644
> --- a/arch/x86/lib/strstr_32.c
> +++ b/arch/x86/lib/strstr_32.c
> @@ -23,9 +23,9 @@ __asm__ __volatile__(
>  	"jne 1b\n\t"
>  	"xorl %%eax,%%eax\n\t"
>  	"2:"
> -	:"=a" (__res), "=&c" (d0), "=&S" (d1)
> -	:"0" (0), "1" (0xffffffff), "2" (cs), "g" (ct)
> -	:"dx", "di");
> +	: "=a" (__res), "=&c" (d0), "=&S" (d1)
> +	: "0" (0), "1" (0xffffffff), "2" (cs), "g" (ct)
> +	: "dx", "di");
>  return __res;

It's strange that checkpatch.pl does not cater for such an obvious style violation as this last line.

Dmitri

>  }
>  

