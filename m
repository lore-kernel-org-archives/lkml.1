Return-Path: <linux-kernel-owner+w=401wt.eu-S933825AbXIUXBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933825AbXIUXBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 19:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762519AbXIUXBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 19:01:04 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58920 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963AbXIUXBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 19:01:01 -0400
Message-ID: <46F44D27.4050704@garzik.org>
Date: Fri, 21 Sep 2007 19:00:55 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: patches@x86-64.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] [50/50] x86_64: Remove fpu io port resource
References: <200709221231.836138000@suse.de> <20070921223251.1312913DCD@wotan.suse.de>
In-Reply-To: <20070921223251.1312913DCD@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Not needed on modern systems without external FPU
> 
> TBD on i386 it is only needed for true 386s. Could remove it there
> TBD for >= 486
> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> ---
>  arch/x86_64/kernel/setup.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> Index: linux/arch/x86_64/kernel/setup.c
> ===================================================================
> --- linux.orig/arch/x86_64/kernel/setup.c
> +++ linux/arch/x86_64/kernel/setup.c
> @@ -121,8 +121,6 @@ struct resource standard_io_resources[] 
>  		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
>  	{ .name = "dma2", .start = 0xc0, .end = 0xdf,
>  		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
> -	{ .name = "fpu", .start = 0xf0, .end = 0xff,
> -		.flags = IORESOURCE_BUSY | IORESOURCE_IO }

Since we are merging x86 and x86-64, I think it would be nice at least 
to CC Thomas on patches that increase 32/64-bit differences...  because 
won't this patch have to be partial un-done when we merge i386 and x86-64?

	Jeff


