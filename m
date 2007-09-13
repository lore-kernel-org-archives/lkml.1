Return-Path: <linux-kernel-owner+w=401wt.eu-S1754223AbXIMIHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbXIMIHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 04:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbXIMIHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 04:07:17 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:38278 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022AbXIMIHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 04:07:15 -0400
Date: Thu, 13 Sep 2007 17:07:01 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Bryan Wu <bryan.wu@analog.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] Blackfin arch: add some missing syscall
Message-ID: <20070913080701.GB27871@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Bryan Wu <bryan.wu@analog.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	uclinux-dist-devel@blackfin.uclinux.org, linux-arch@vger.kernel.org
References: <1189670203.30686.15.camel@roc-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1189670203.30686.15.camel@roc-desktop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007 at 03:56:43PM +0800, Bryan Wu wrote:
> @@ -352,9 +353,54 @@
>  #define __NR_shmdt		340
>  #define __NR_shmget		341
>  
> -#define __NR_syscall		342
> +#define __NR_splice		342
> +#define __NR_sync_file_range	343
> +#define __NR_tee		344
> +#define __NR_vmsplice		345
> +
> +#define __NR_epoll_pwait	346
> +#define __NR_utimensat		347
> +#define __NR_signalfd		348
> +#define __NR_timerfd		349
> +#define __NR_eventfd		350
> +#define __NR_pread64		351
> +#define __NR_pwrite64		352
> +#define __NR_fadvise64		353
> +
> +#define __NR_syscall		354
>  #define NR_syscalls		__NR_syscall
>  
Err, why did you change __NR_syscall? This is going to break the ABI for
anything using it, which is generally bad form.

You also missed sys_fallocate(), another reason to be using git, rather
than some silly subversion tree ;-)
