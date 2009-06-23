Return-Path: <linux-kernel-owner+w=401wt.eu-S1758589AbZFWIwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589AbZFWIwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 04:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757960AbZFWIwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 04:52:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53790 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757418AbZFWIwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 04:52:16 -0400
Date: Tue, 23 Jun 2009 10:52:18 +0200 (CEST)
From: Jiri Kosina <trivial@kernel.org>
X-X-Sender: jkosina@wotan.suse.de
To: Markus Heidelberg <markus.heidelberg@web.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: remove references to non-existent
 include/linux/config.h
In-Reply-To: <1244761355-1099-2-git-send-email-markus.heidelberg@web.de>
Message-ID: <alpine.LNX.2.00.0906231051530.7457@wotan.suse.de>
References: <1244761355-1099-2-git-send-email-markus.heidelberg@web.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009, Markus Heidelberg wrote:

> Ignore drivers/staging/ since it is very likely that new drivers
> introduce it again.
> 
> Signed-off-by: Markus Heidelberg <markus.heidelberg@web.de>
> ---
>  arch/h8300/kernel/timer/tpu.c |    1 -
>  scripts/basic/fixdep.c        |    3 +--
>  scripts/mod/sumversion.c      |    2 --
>  3 files changed, 1 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/h8300/kernel/timer/tpu.c b/arch/h8300/kernel/timer/tpu.c
> index e7c6e61..2193a2e 100644
> --- a/arch/h8300/kernel/timer/tpu.c
> +++ b/arch/h8300/kernel/timer/tpu.c
> @@ -7,7 +7,6 @@
>   *
>   */
>  
> -#include <linux/config.h>
>  #include <linux/errno.h>
>  #include <linux/sched.h>
>  #include <linux/kernel.h>
> diff --git a/scripts/basic/fixdep.c b/scripts/basic/fixdep.c
> index 8912c0f..1f5e628 100644
> --- a/scripts/basic/fixdep.c
> +++ b/scripts/basic/fixdep.c
> @@ -16,8 +16,7 @@
>   * tells make when to remake a file.
>   *
>   * To use this list as-is however has the drawback that virtually
> - * every file in the kernel includes <linux/config.h> which then again
> - * includes <linux/autoconf.h>
> + * every file in the kernel includes <linux/autoconf.h>.
>   *
>   * If the user re-runs make *config, linux/autoconf.h will be
>   * regenerated.  make notices that and will rebuild every file which
> diff --git a/scripts/mod/sumversion.c b/scripts/mod/sumversion.c
> index aadc522..ecf9c7d 100644
> --- a/scripts/mod/sumversion.c
> +++ b/scripts/mod/sumversion.c
> @@ -334,8 +334,6 @@ static int parse_source_files(const char *objfile, struct md4_ctx *md)
>  		deps_drivers/net/dummy.o := \
>  		  drivers/net/dummy.c \
>  		    $(wildcard include/config/net/fastroute.h) \
> -		  include/linux/config.h \
> -		    $(wildcard include/config/h.h) \
>  		  include/linux/module.h \
>  
>  	   Sum all files in the same dir or subdirs.

Applied, thanks Markus.

-- 
Jiri Kosina
SUSE Labs

