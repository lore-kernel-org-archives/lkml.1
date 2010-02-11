Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479Ab0BKF2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 00:28:38 -0500
Received: from mga11.intel.com ([192.55.52.93]:40041 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783Ab0BKF2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 00:28:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,449,1262592000"; 
   d="scan'208";a="539767049"
Date: Thu, 11 Feb 2010 13:28:30 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] Remove references to CTL_UNNUMBERED which has been
	removed
Message-ID: <20100211052830.GB15392@localhost>
References: <201002091659.24421.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002091659.24421.knikanth@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 09, 2010 at 04:59:24PM +0530, Nikanth Karthikesan wrote:
> Remove references to CTL_UNNUMBERED which has been removed.
> 

Acked-by: Wu Fengguang <fengguang.wu@intel.com>

CTL_UNNUMBERED is removed in 86926d00 by Eric W. Biederman.

Thanks,
Fengguang

> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> 
> ---
> 
> Index: linux-2.6/kernel/sysctl.c
> ===================================================================
> --- linux-2.6.orig/kernel/sysctl.c
> +++ linux-2.6/kernel/sysctl.c
> @@ -232,10 +232,6 @@ static struct ctl_table root_table[] = {
>  		.mode		= 0555,
>  		.child		= dev_table,
>  	},
> -/*
> - * NOTE: do not add new entries to this table unless you have read
> - * Documentation/sysctl/ctl_unnumbered.txt
> - */
>  	{ }
>  };
>  
> @@ -936,10 +932,6 @@ static struct ctl_table kern_table[] = {
>  		.proc_handler	= proc_dointvec,
>  	},
>  #endif
> -/*
> - * NOTE: do not add new entries to this table unless you have read
> - * Documentation/sysctl/ctl_unnumbered.txt
> - */
>  	{ }
>  };
>  
> @@ -1282,10 +1274,6 @@ static struct ctl_table vm_table[] = {
>  	},
>  #endif
>  
> -/*
> - * NOTE: do not add new entries to this table unless you have read
> - * Documentation/sysctl/ctl_unnumbered.txt
> - */
>  	{ }
>  };
>  
> @@ -1433,10 +1421,6 @@ static struct ctl_table fs_table[] = {
>  		.child		= binfmt_misc_table,
>  	},
>  #endif
> -/*
> - * NOTE: do not add new entries to this table unless you have read
> - * Documentation/sysctl/ctl_unnumbered.txt
> - */
>  	{ }
>  };
>  
> Index: linux-2.6/Documentation/sysctl/00-INDEX
> ===================================================================
> --- linux-2.6.orig/Documentation/sysctl/00-INDEX
> +++ linux-2.6/Documentation/sysctl/00-INDEX
> @@ -4,8 +4,6 @@ README
>  	- general information about /proc/sys/ sysctl files.
>  abi.txt
>  	- documentation for /proc/sys/abi/*.
> -ctl_unnumbered.txt
> -	- explanation of why one should not add new binary sysctl numbers.
>  fs.txt
>  	- documentation for /proc/sys/fs/*.
>  kernel.txt
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
