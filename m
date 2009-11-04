Return-Path: <linux-kernel-owner+w=401wt.eu-S1756252AbZKDNbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252AbZKDNbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 08:31:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756196AbZKDNbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 08:31:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51482 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755600AbZKDNbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 08:31:08 -0500
Date: Wed, 4 Nov 2009 14:31:13 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] trivial: add missing comments in sysctl kernel names
In-Reply-To: <1256933019-6687-1-git-send-email-cascardo@holoscopio.com>
Message-ID: <alpine.LSU.2.00.0911041430410.9988@wotan.suse.de>
References: <1256933019-6687-1-git-send-email-cascardo@holoscopio.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Oct 2009, Thadeu Lima de Souza Cascardo wrote:

> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> ---
>  include/linux/sysctl.h |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
> index 1e4743e..9a3c8f7 100644
> --- a/include/linux/sysctl.h
> +++ b/include/linux/sysctl.h
> @@ -98,8 +98,8 @@ enum
>  	KERN_VERSION=4,		/* string: compile time info */
>  	KERN_SECUREMASK=5,	/* struct: maximum rights mask */
>  	KERN_PROF=6,		/* table: profiling information */
> -	KERN_NODENAME=7,
> -	KERN_DOMAINNAME=8,
> +	KERN_NODENAME=7,	/* string: hostname */
> +	KERN_DOMAINNAME=8,	/* string: domainname */
>  
>  	KERN_PANIC=15,		/* int: panic timeout */
>  	KERN_REALROOTDEV=16,	/* real root device to mount after initrd */
> @@ -111,8 +111,8 @@ enum
>  	KERN_PPC_HTABRECLAIM=25, /* turn htab reclaimation on/off on PPC */
>  	KERN_PPC_ZEROPAGED=26,	/* turn idle page zeroing on/off on PPC */
>  	KERN_PPC_POWERSAVE_NAP=27, /* use nap mode for power saving */
> -	KERN_MODPROBE=28,
> -	KERN_SG_BIG_BUFF=29,
> +	KERN_MODPROBE=28,	/* string: modprobe path */
> +	KERN_SG_BIG_BUFF=29,	/* int: sg driver reserved buffer size */
>  	KERN_ACCT=30,		/* BSD process accounting parameters */
>  	KERN_PPC_L2CR=31,	/* l2cr register on PPC */
>  
> @@ -159,7 +159,7 @@ enum
>  	KERN_ACPI_VIDEO_FLAGS=71, /* int: flags for setting up video after ACPI sleep */
>  	KERN_IA64_UNALIGNED=72, /* int: ia64 unaligned userland trap enable */
>  	KERN_COMPAT_LOG=73,	/* int: print compat layer  messages */
> -	KERN_MAX_LOCK_DEPTH=74,
> +	KERN_MAX_LOCK_DEPTH=74, /* int: rtmutex's maximum lock depth */
>  	KERN_NMI_WATCHDOG=75, /* int: enable/disable nmi watchdog */
>  	KERN_PANIC_ON_NMI=76, /* int: whether we will panic on an unrecovered */
>  };

This doesn't seem to be present in today's linux-next, so I have merged it 
to my queue.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
