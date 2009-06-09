Return-Path: <linux-kernel-owner+w=401wt.eu-S1759345AbZFITSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345AbZFITSZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 15:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756003AbZFITSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 15:18:15 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:41151 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098AbZFITSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 15:18:14 -0400
Date: Tue, 9 Jun 2009 21:20:32 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: liqin.chen@sunplusct.com
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
Subject: Re: Subject: [PATCH 27/27] score: create mm files Makefile pgtable.c tlb-miss.S tlb-score.c MAINTAINERS
Message-ID: <20090609192032.GE7181@uranus.ravnborg.org>
References: <OF3FCD7D17.46B74348-ON482575D0.00247D15-482575D0.0024EF46@sunplusct.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF3FCD7D17.46B74348-ON482575D0.00247D15-482575D0.0024EF46@sunplusct.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 02:39:08PM +0800, liqin.chen@sunplusct.com wrote:
> >From d6d79cbcf39cd522208231ed717e1c12e5401b33 Mon Sep 17 00:00:00 2001
> From: Chen Liqin <liqin.chen@sunplusct.com>
> Date: Tue, 9 Jun 2009 13:43:20 +0800
> Subject: [PATCH 27/27] score: create mm files Makefile pgtable.c 
> tlb-miss.S tlb-score.c MAINTAINERS
> 
> 
> Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
> ---
>  MAINTAINERS               |    8 ++
>  arch/score/mm/Makefile    |    8 ++
>  arch/score/mm/pgtable.c   |   60 +++++++++++
>  arch/score/mm/tlb-miss.S  |  204 ++++++++++++++++++++++++++++++++++++
>  arch/score/mm/tlb-score.c |  251 
> +++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 531 insertions(+), 0 deletions(-)
>  create mode 100644 arch/score/mm/Makefile
>  create mode 100644 arch/score/mm/pgtable.c
>  create mode 100644 arch/score/mm/tlb-miss.S
>  create mode 100644 arch/score/mm/tlb-score.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2b349ba..d6993a1 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4881,6 +4881,14 @@ S:       Maintained
>  F:     kernel/sched*
>  F:     include/linux/sched.h
>  
> +SCORE ARCHITECTURE
> +P:     Chen Liqin
> +M:     liqin.chen@sunplusct.com
> +P:     Lennox Wu
> +M:     lennox.wu@sunplusct.com
> +W:     http://www.sunplusct.com
> +S:     Supported
> +
>  SCSI CDROM DRIVER
>  P:     Jens Axboe
>  M:     axboe@kernel.dk
> diff --git a/arch/score/mm/Makefile b/arch/score/mm/Makefile
> new file mode 100644
> index 0000000..6da8ce5
> --- /dev/null
> +++ b/arch/score/mm/Makefile
> @@ -0,0 +1,8 @@
> +#
> +# Makefile for the Linux/SCORE-specific parts of the memory manager.
> +#
> +
> +obj-y += cache.o extable.o fault.o init.o \
> +       tlb-miss.o tlb-score.o pgtable.o
> +
> +EXTRA_CFLAGS +=

Please remove this redundant line.
If you need to add extra options to cc use: ccflags-y := ...

	Sam
