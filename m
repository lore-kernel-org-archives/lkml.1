Return-Path: <linux-kernel-owner+w=401wt.eu-S1758386AbXGQNon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758386AbXGQNon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 09:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbXGQNoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 09:44:37 -0400
Received: from il.qumranet.com ([82.166.9.18]:34697 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689AbXGQNog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 09:44:36 -0400
Message-ID: <469CC7CC.7050102@qumranet.com>
Date: Tue, 17 Jul 2007 16:44:44 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 10/10] Use standard CR8 flags, and fix TPR definition
References: <1184677946.10380.4.camel@localhost.localdomain>	 <1184678060.10380.7.camel@localhost.localdomain>	 <1184678129.10380.10.camel@localhost.localdomain>	 <1184678171.10380.12.camel@localhost.localdomain>	 <1184678216.10380.14.camel@localhost.localdomain>	 <1184678275.10380.16.camel@localhost.localdomain>	 <1184678348.10380.19.camel@localhost.localdomain>	 <1184679175.10380.25.camel@localhost.localdomain>	 <1184679256.10380.27.camel@localhost.localdomain> <1184679437.10380.31.camel@localhost.localdomain>
In-Reply-To: <1184679437.10380.31.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> Intel manual (and KVM definition) say it's TPR is 4 bits wide.  Also fix
> CR8_RESEVED_BITS typo.
>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> diff -r 6ef0b4c0d6f7 include/asm-i386/processor-flags.h
> --- a/include/asm-i386/processor-flags.h	Tue Jul 17 18:07:48 2007 +1000
> +++ b/include/asm-i386/processor-flags.h	Tue Jul 17 18:12:54 2007 +1000
> @@ -63,7 +63,7 @@
>  /*
>   * x86-64 Task Priority Register, CR8
>   */
> -#define X86_CR8_TPR	0x00000007 /* task priority register */
> +#define X86_CR8_TPR	0x0000000F /* task priority register */
>  
>  /*
>   * AMD and Transmeta use MSRs for configuration; see <asm/msr-index.h>
>
>
>   


X86_CR8_TPR is not used in the kernel.  But is this meant to be a mask, 
or something else?

-- 
error compiling committee.c: too many arguments to function

