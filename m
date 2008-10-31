Return-Path: <linux-kernel-owner+w=401wt.eu-S1752803AbYJaT1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbYJaT1W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 15:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbYJaT1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 15:27:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51965 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbYJaT1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 15:27:14 -0400
Date: Fri, 31 Oct 2008 15:28:35 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Maciej W. Rozycki" <macro@linux-mips.org>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: nmi - document lapic and ioapic parameters
Message-ID: <20081031192834.GD771@redhat.com>
References: <20081031192358.GC20803@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081031192358.GC20803@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
> 
> On top of -tip dda51106620c328b50007c259b9ef8cea2b7c3d2
> 
> Index: linux-2.6.git/Documentation/kernel-parameters.txt
> ===================================================================
> --- linux-2.6.git.orig/Documentation/kernel-parameters.txt	2008-10-27 21:35:08.000000000 +0300
> +++ linux-2.6.git/Documentation/kernel-parameters.txt	2008-10-31 22:21:59.000000000 +0300
> @@ -1404,6 +1404,14 @@ and is between 256 and 4096 characters. 
>  			Format: [state][,regs][,debounce][,die]
>  
>  	nmi_watchdog=	[KNL,BUGS=X86-32] Debugging features for SMP kernels
> +			Format: [panic,][num]
> +			Valid num: 0,1,2
> +			0 - turn nmi_watchdog off
> +			1 - use IO-APIC
> +			2 - use local APIC
> +			Instead of 1 and 2 it is possible to use the following
> +			symbolic names: lapic and ioapic
> +			Example: nmi_watchdog=2 or nmi_watchdog=panic,lapic
>  
>  	no387		[BUGS=X86-32] Tells the kernel to use the 387 maths
>  			emulation library even if a 387 maths coprocessor

Acked-by: Aristeu Rozanski <aris@ruivo.org>

-- 
Aristeu

