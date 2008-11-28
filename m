Return-Path: <linux-kernel-owner+w=401wt.eu-S1752882AbYK1M4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbYK1M4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 07:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbYK1M4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 07:56:06 -0500
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:55408 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750895AbYK1M4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 07:56:05 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAAd0L0lMROB9/2dsb2JhbACBbc8zgn0
Date: Fri, 28 Nov 2008 07:56:02 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>, ltt-dev@lists.casi.polymtl.ca,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ltt-dev] LTTng kernel integration roadmap, update
Message-ID: <20081128125602.GA10401@Krystal>
References: <20081124112842.GA15615@Krystal> <20081124114124.GA32459@infradead.org> <20081124122055.GA18626@Krystal> <alpine.DEB.1.10.0811241156030.20122@gandalf.stny.rr.com> <20081125055744.c3377164.akpm@linux-foundation.org> <20081125154011.GA4883@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081125154011.GA4883@uranus.ravnborg.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 07:54:47 up 11 days, 13:35,  2 users,  load average: 0.12, 0.53,
	0.71
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sam Ravnborg (sam@ravnborg.org) wrote:
> > 
> > Mathieu, if you're feeling keen I'd suggest that you just type `mkdir
> > -p userspace/lttng' and build your userspace tools in there.
> 
> Maybe this can help...
> 

Hi Sam,

Thanks for the code snipped, I'll start from there for my kernel-tree
integrated userspace tools when I come back from travelling around
Europe.

Mathieu

> 	Sam
> 
> diff --git a/usr/Makefile b/usr/Makefile
> index 201f27f..627fafc 100644
> --- a/usr/Makefile
> +++ b/usr/Makefile
> @@ -2,6 +2,8 @@
>  # kbuild file for usr/ - including initramfs image
>  #
>  
> +subdir-y := lttng
> +
>  klibcdirs:;
>  PHONY += klibcdirs
>  
> diff --git a/usr/lttng/Makefile b/usr/lttng/Makefile
> new file mode 100644
> index 0000000..8667998
> --- /dev/null
> +++ b/usr/lttng/Makefile
> @@ -0,0 +1,4 @@
> +
> +always := ltt
> +
> +hostprogs-y := ltt
> diff --git a/usr/lttng/ltt.c b/usr/lttng/ltt.c
> new file mode 100644
> index 0000000..9eca2ed
> --- /dev/null
> +++ b/usr/lttng/ltt.c
> @@ -0,0 +1,7 @@
> +#include <stdio.h>
> +
> +int main(int ac, char *argv[])
> +{
> +	printf("lttng\n");
> +	return 0;
> +}
> 
> _______________________________________________
> ltt-dev mailing list
> ltt-dev@lists.casi.polymtl.ca
> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
