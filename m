Return-Path: <linux-kernel-owner+w=401wt.eu-S1751778AbXCYQZD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778AbXCYQZD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 12:25:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbXCYQZC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 12:25:02 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:34117 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751778AbXCYQZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 12:25:01 -0400
Date: Sun, 25 Mar 2007 18:25:05 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Parag Warudkar <parag.warudkar@gmail.com>
Cc: linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: apm.c: get rid of unused variables
Message-ID: <20070325162505.GN16477@stusta.de>
References: <Pine.LNX.4.64.0703251158400.17623@paragw-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703251158400.17623@paragw-desktop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 25, 2007 at 12:06:19PM -0400, Parag Warudkar wrote:
> 
> The patch below (against latest git) gets rid of following unused 
> variables - clock_cmos_diff and got_clock_diff.
> 
> 2 less compiler warnings.
> 
> Compile tested on i386.
> 
> Signed-off-by: Parag Warudkar <parag.warudkar@gmail.com>
> 
> --- linux-2.6/arch/i386/kernel/apm.c	2007-03-24 21:43:35.000000000 -0400
> +++ linux-2.6-wk/arch/i386/kernel/apm.c	2007-03-25 
> 11:50:16.000000000 -0400
> @@ -384,13 +384,6 @@
>  static int			ignore_normal_resume;
>  static int			bounce_interval __read_mostly = 
>  DEFAULT_BOUNCE_INTERVAL;
> 
> -#ifdef CONFIG_APM_RTC_IS_GMT
> -#	define	clock_cmos_diff	0
> -#	define	got_clock_diff	1
> -#else
> -static long			clock_cmos_diff;
> -static int			got_clock_diff;
> -#endif
>  static int			debug __read_mostly;
>  static int			smp __read_mostly;
>  static int			apm_disabled = -1;

You could also remove the APM_RTC_IS_GMT config option.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

