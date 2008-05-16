Return-Path: <linux-kernel-owner+w=401wt.eu-S1755816AbYEPNU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbYEPNU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 09:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754655AbYEPNUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 09:20:19 -0400
Received: from relay1.sgi.com ([192.48.171.29]:43996 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751888AbYEPNUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 09:20:18 -0400
Message-ID: <482D8A0D.7020902@sgi.com>
Date: Fri, 16 May 2008 06:20:13 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       "Huang, Ying" <ying.huang@intel.com>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/10] x86 boot: include missing smp.h header
References: <20080514151504.148486.32236.sendpatchset@jackhammer.engr.sgi.com>
In-Reply-To: <20080514151504.148486.32236.sendpatchset@jackhammer.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-By: Mike Travis <travis@sgi.com>

Paul Jackson wrote:
> From: Paul Jackson <pj@sgi.com>
> 
> The patch:
>     x86: convert cpu_to_apicid to be a per cpu variable
> introduced a dependency of ipi.h on smp.h in x86
> builds with an allnoconfig.  Including smp.h in ipi.h
> fixes the build error:
>     In file included from arch/x86/kernel/traps_64.c:48:
>     include/asm/ipi.h: In function 'send_IPI_mask_sequence':
>     include/asm/ipi.h:114: error: 'per_cpu__x86_cpu_to_apicid' undeclared (first use in this function)
> 
> Signed-off-by: Paul Jackson <pj@sgi.com>
> Cc: Mike Travis <travis@sgi.com>
> 
> ---
>  include/asm-x86/ipi.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux.orig/include/asm-x86/ipi.h	2008-05-13 10:44:39.000000000 -0700
> +++ linux/include/asm-x86/ipi.h	2008-05-13 10:56:37.431506774 -0700
> @@ -20,6 +20,7 @@
>  
>  #include <asm/hw_irq.h>
>  #include <asm/apic.h>
> +#include <asm/smp.h>
>  
>  /*
>   * the following functions deal with sending IPIs between CPUs.
> 

