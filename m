Return-Path: <linux-kernel-owner+w=401wt.eu-S932090AbXGNXBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090AbXGNXBz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 19:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbXGNXBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 19:01:48 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:40049 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751365AbXGNXBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 19:01:48 -0400
Date: Sat, 14 Jul 2007 19:01:46 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: prasanna@in.ibm.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com,
       davem@davemloft.net, Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 5/8] Immediate Values - kprobe header fix
Message-ID: <20070714230146.GE18674@Krystal>
References: <20070714012439.285079881@polymtl.ca> <20070714012624.150971859@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070714012624.150971859@polymtl.ca>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:01:25 up 7 days, 13:06,  3 users,  load average: 0.69, 0.64, 0.38
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Should be dropped, following Christoph's advice.

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> Since the immediate values depend on the same int3 handler as kprobes implements
> for i386, we have to get architecture specific defines available for the kprobes
> trap handler (especially restore_interrupts()) wven when CONFIG_KPROBES is not
> selected.
> 
> That kind of ifdef around a whole header does not make sense in the first place
> anyway.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: prasanna@in.ibm.com
> CC: ananth@in.ibm.com
> CC: anil.s.keshavamurthy@intel.com
> CC: davem@davemloft.net
> ---
>  include/linux/kprobes.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6-lttng/include/linux/kprobes.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/linux/kprobes.h	2007-07-13 18:47:57.000000000 -0400
> +++ linux-2.6-lttng/include/linux/kprobes.h	2007-07-13 18:48:45.000000000 -0400
> @@ -36,9 +36,9 @@
>  #include <linux/spinlock.h>
>  #include <linux/rcupdate.h>
>  
> -#ifdef CONFIG_KPROBES
>  #include <asm/kprobes.h>
>  
> +#ifdef CONFIG_KPROBES
>  /* kprobe_status settings */
>  #define KPROBE_HIT_ACTIVE	0x00000001
>  #define KPROBE_HIT_SS		0x00000002
> 
> -- 
> Mathieu Desnoyers
> Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
