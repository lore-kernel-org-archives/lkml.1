Return-Path: <linux-kernel-owner+w=401wt.eu-S934995AbZLPQYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934995AbZLPQYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 11:24:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934890AbZLPQYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 11:24:13 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:39477 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933741AbZLPQYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 11:24:10 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArMEAHOUKEuuWOl3/2dsb2JhbACBS9UKhCsEhWM
Date: Wed, 16 Dec 2009 11:24:07 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] [RELEASE] LTTng 0.181 for Linux kernel 2.6.32
Message-ID: <20091216162406.GA12113@Krystal>
References: <20091204160633.GA29864@Krystal> <20091213184842.GA16448@hansolo.jdub.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20091213184842.GA16448@hansolo.jdub.homelinux.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 11:23:40 up 42 min,  4 users,  load average: 0.08, 0.13, 0.23
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Josh Boyer (jwboyer@linux.vnet.ibm.com) wrote:
> On Fri, Dec 04, 2009 at 11:06:33AM -0500, Mathieu Desnoyers wrote:
> >Hi,
> >
> >I just released LTTng 0.181 for Linux kernel 2.6.32. All packages and
> >links to the git tree can be found at:
> >
> >http://www.lttng.org
> >
> >Comment and feedback are always welcome.
> 
> This fails to build for PowerPC 44x.  The following trivial patch fixes it.

Merged, will be in LTTng 0.182.

Thanks !

Mathieu

> 
> josh
> 
> From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
> Subject: Fix LTTng 0.181 compilation on PowerPC
> 
> LTTng fails to build on powerpc due to a missing #include in the instrumented
> arch/powerpc/kernel/timer.c file.  Fix it.
> 
> Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
> 
> ---
> 
> diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
> index 5465ab2..3e7f6e4 100644
> --- a/arch/powerpc/kernel/time.c
> +++ b/arch/powerpc/kernel/time.c
> @@ -54,6 +54,7 @@
>  #include <linux/irq.h>
>  #include <linux/delay.h>
>  #include <linux/perf_event.h>
> +#include <trace/trap.h>
>  
>  #include <asm/io.h>
>  #include <asm/processor.h>
> 
> 
> _______________________________________________
> ltt-dev mailing list
> ltt-dev@lists.casi.polymtl.ca
> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
