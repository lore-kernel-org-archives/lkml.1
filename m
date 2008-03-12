Return-Path: <linux-kernel-owner+w=401wt.eu-S1753639AbYCLVL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639AbYCLVL0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 17:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbYCLVLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 17:11:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34335 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbYCLVLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 17:11:16 -0400
Message-ID: <47D846CE.1020005@zytor.com>
Date: Wed, 12 Mar 2008 22:10:38 +0100
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: parocessor.h - use PAGE_SIZE instead of numeric
 constant
References: <20080312201405.GA9591@cvg>
In-Reply-To: <20080312201405.GA9591@cvg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> This patch replaces numeric constant with an appropriate macro
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> 
> ---
> 
> Index: linux-2.6.git/include/asm-x86/processor.h
> ===================================================================
> --- linux-2.6.git.orig/include/asm-x86/processor.h	2008-02-20 19:14:57.000000000 +0300
> +++ linux-2.6.git/include/asm-x86/processor.h	2008-03-12 23:10:02.000000000 +0300
> @@ -786,7 +786,7 @@ extern unsigned long thread_saved_pc(str
>  /*
>   * User space process size. 47bits minus one guard page.
>   */
> -#define TASK_SIZE64	(0x800000000000UL - 4096)
> +#define TASK_SIZE64	(0x800000000000UL - PAGE_SIZE)
>  
>  /* This decides where the kernel will search for a free chunk of vm
>   * space during mmap's.

Although I'd personally prefer ((1UL << 47) - PAGE_SIZE)

	-hpa
