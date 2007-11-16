Return-Path: <linux-kernel-owner+w=401wt.eu-S933837AbXKPPOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933837AbXKPPOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 10:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbXKPPOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 10:14:11 -0500
Received: from [198.99.130.12] ([198.99.130.12]:58022 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbXKPPOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 10:14:10 -0500
Date: Fri, 16 Nov 2007 10:12:57 -0500
From: Jeff Dike <jdike@addtoit.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Greg KH <greg@kroah.com>, Rob Landley <rob@landley.net>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [Patch] Fix UML broken (was Re: User Mode Linux still broken in 2.6.23.1)
Message-ID: <20071116151257.GA5291@c2.user-mode-linux.org>
References: <200711032351.52977.rob@landley.net> <200711142358.16072.rob@landley.net> <20071115060255.GA4837@kroah.com> <200711151457.22395.rob@landley.net> <20071115210608.GA12213@kroah.com> <20071116030832.GB2563@hacking>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071116030832.GB2563@hacking>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2007 at 11:08:32AM +0800, WANG Cong wrote:
> Could you please try this patch? Can it fix the error?
> 
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> 
> ---
> 
> diff --git a/Makefile b/Makefile
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 4f3838a..2c3ce4c 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -6,6 +6,7 @@
>  #include <linux/mmzone.h>
>  #include <linux/list.h>
>  #include <linux/sched.h>
> +#include <linux/pagemap.h>
>  
>  #include <asm/atomic.h>
>  #include <asm/page.h>

If you look further down the file, you see a comment to the effect that this
will break sparc.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
