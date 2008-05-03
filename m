Return-Path: <linux-kernel-owner+w=401wt.eu-S1755051AbYECVEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051AbYECVEo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 17:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752997AbYECVEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 17:04:31 -0400
Received: from www.tglx.de ([62.245.132.106]:48171 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925AbYECVE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 17:04:29 -0400
Date: Sat, 3 May 2008 23:04:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH] x86: fix up bootparam.h for userspace inclusion
In-Reply-To: <200805022114.20672.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.1.10.0805032303410.6003@apollo.tec.linutronix.de>
References: <200805022114.20672.rusty@rustcorp.com.au>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2008, Rusty Russell wrote:

> commit 8b664aa66e824a0ddf4ec56d41fa0cf7bb374de6 (x86, boot: add linked
> list of struct setup_data) put a new struct in bootparam.h, but didn't
> use the userspace-safe types.
> 
> CC: Huang, Ying <ying.huang@intel.com>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> diff -r 3b015cd747e0 include/asm-x86/bootparam.h
> --- a/include/asm-x86/bootparam.h	Fri May 02 09:32:30 2008 +1000
> +++ b/include/asm-x86/bootparam.h	Fri May 02 18:35:11 2008 +1000
> @@ -14,10 +14,10 @@
>  
>  /* extensible setup data list node */
>  struct setup_data {
> -	u64 next;
> -	u32 type;
> -	u32 len;
> -	u8 data[0];
> +	__u64 next;
> +	__u32 type;
> +	__u32 len;
> +	__u8 data[0];
>  };
>  
>  struct setup_header {

Applied, thanks

	 tglx
