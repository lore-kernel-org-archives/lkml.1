Return-Path: <linux-kernel-owner+w=401wt.eu-S1757431AbXGPSU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431AbXGPSU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 14:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbXGPSUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 14:20:19 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:38628 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbXGPSUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 14:20:18 -0400
Date: Mon, 16 Jul 2007 11:23:05 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, torvalds <torvalds@linux-foundation.org>
Subject: Re: sysctl.c: add text telling people to use CTL_UNNUMBERED
Message-Id: <20070716112305.6308686f.randy.dunlap@oracle.com>
In-Reply-To: <200707161802.l6GI2h6J006803@hera.kernel.org>
References: <200707161802.l6GI2h6J006803@hera.kernel.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007 18:02:43 GMT Linux Kernel Mailing List wrote:

> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=2be7fe075af8f8ba9c8b8ab0feec4ba4fff04979
> Commit:     2be7fe075af8f8ba9c8b8ab0feec4ba4fff04979
> Parent:     97d8f83cb734525f96992fd61e4f7323ab3d549c
> Author:     Andrew Morton <akpm@linux-foundation.org>
> AuthorDate: Sun Jul 15 23:41:21 2007 -0700
> Committer:  Linus Torvalds <torvalds@woody.linux-foundation.org>
> CommitDate: Mon Jul 16 09:05:49 2007 -0700
> 
>     sysctl.c: add text telling people to use CTL_UNNUMBERED
>     
>     Hopefully this will help people to understand the new regime.
>     
>     Cc: "Eric W. Biederman" <ebiederm@xmission.com>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---
>  kernel/sysctl.c |   21 ++++++++++++++++++++-
>  1 files changed, 20 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 2cce228..7dca326 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -203,7 +203,10 @@ static ctl_table root_table[] = {
>  		.mode		= 0555,
>  		.child		= dev_table,
>  	},
> -
> +/*
> + * NOTE: do not add new entries to this table unless you have read
> + * Documentation/sysctl/ctl_unnumbered.txt
> + */
>  	{ .ctl_name = 0 }
>  };
>  
> @@ -992,6 +995,14 @@ static ctl_table vm_table[] = {
>  		.extra1		= &zero,
>  	},
>  #endif
> +/*
> + * NOTE: do not add new entries to this table unless you have read
> + * Documentation/sysctl/ctl_unnumbered.txt
> + */
> +/*
> + * NOTE: do not add new entries to this table unless you have read
> + * Documentation/sysctl/ctl_unnumbered.txt
> + */
>  	{ .ctl_name = 0 }
>  };

Are these comments above &  below doubled up for Emphasis??

> @@ -1132,6 +1143,14 @@ static ctl_table fs_table[] = {
>  		.child		= binfmt_misc_table,
>  	},
>  #endif
> +/*
> + * NOTE: do not add new entries to this table unless you have read
> + * Documentation/sysctl/ctl_unnumbered.txt
> + */
> +/*
> + * NOTE: do not add new entries to this table unless you have read
> + * Documentation/sysctl/ctl_unnumbered.txt
> + */
>  	{ .ctl_name = 0 }
>  };


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
