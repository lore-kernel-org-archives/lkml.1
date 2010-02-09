Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab0BIOzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 09:55:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754267Ab0BIOze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 09:55:34 -0500
Date: Tue, 9 Feb 2010 09:54:27 -0500
From: Jason Baron <jbaron@redhat.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com,
       rostedt@goodmis.org, fweisbec@gmail.com, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, mhiramat@redhat.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 4/6] tracing: add tracing support for compat syscalls
Message-ID: <20100209145427.GA30309@redhat.com>
References: <cover.1265142153.git.jbaron@redhat.com> <bec426992cb9ab8f8abe07efb2baa785577a3855.1265142153.git.jbaron@redhat.com> <20100203125251.GA30003@osiris.boeblingen.de.ibm.com> <20100208154325.GB2688@redhat.com> <20100209102100.GA23838@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100209102100.GA23838@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 09, 2010 at 11:21:00AM +0100, Heiko Carstens wrote:
> > is there a way for s390 to use the common include/linux/compat.h file?
> > what other arch defs are required? 
> 
> The patch below is the smallest solution so that s390 still compiles
> and probably even works:
> 
> Subject: [PATCH] compat: have generic is_compat_task for !CONFIG_COMPAT
> 
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> ..instead of an arch specific one.
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  arch/s390/include/asm/compat.h  |    7 -------
>  arch/s390/kernel/ptrace.c       |    2 +-
>  arch/s390/kernel/setup.c        |    2 +-
>  arch/s390/mm/mmap.c             |    2 +-
>  drivers/s390/block/dasd_eckd.c  |    2 +-
>  drivers/s390/block/dasd_ioctl.c |    1 +
>  drivers/s390/char/fs3270.c      |    1 +
>  drivers/s390/char/vmcp.c        |    1 +
>  drivers/s390/cio/chsc_sch.c     |    1 +
>  drivers/s390/scsi/zfcp_cfdc.c   |    1 +
>  include/linux/compat.h          |    7 +++++++
>  11 files changed, 16 insertions(+), 11 deletions(-)
> 

looks good. I'll include this patch when I repost the revised series.

thanks!

-Jason
