Return-Path: <linux-kernel-owner+w=401wt.eu-S1762432AbZEONZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762432AbZEONZx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 09:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757446AbZEONZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 09:25:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56763 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756863AbZEONZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 09:25:44 -0400
Date: Fri, 15 May 2009 10:25:11 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: <akpm@linux-foundation.org>, <greg@kroah.com>, <mingo@elte.hu>,
       <norsk5@yahoo.com>, <tglx@linutronix.de>, <hpa@zytor.com>,
       <aris@redhat.com>, edt@aei.ca, <linux-kernel@vger.kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 02/22] edac: fold __func__ into edac_debug_printk
Message-ID: <20090515102511.7339bf9a@pedra.chehab.org>
In-Reply-To: <1242390153-24493-3-git-send-email-borislav.petkov@amd.com>
References: <1242390153-24493-1-git-send-email-borislav.petkov@amd.com>
	<1242390153-24493-3-git-send-email-borislav.petkov@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, 15 May 2009 14:22:13 +0200
Borislav Petkov <borislav.petkov@amd.com> escreveu:

> This shortens debugfX() calls a bit.
> 
> CC: Doug Thompson <norsk5@yahoo.com>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

Reviewed-by: Mauro Carvalho Chehab <mchehab@redhat.com>

> ---
>  drivers/edac/edac_core.h |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
> index 6ad95c8..48d3b14 100644
> --- a/drivers/edac/edac_core.h
> +++ b/drivers/edac/edac_core.h
> @@ -76,10 +76,11 @@
>  extern int edac_debug_level;
>  
>  #ifndef CONFIG_EDAC_DEBUG_VERBOSE
> -#define edac_debug_printk(level, fmt, arg...)                            \
> -	do {                                                             \
> -		if (level <= edac_debug_level)                           \
> -			edac_printk(KERN_DEBUG, EDAC_DEBUG, fmt, ##arg); \
> +#define edac_debug_printk(level, fmt, arg...)                           \
> +	do {                                                            \
> +		if (level <= edac_debug_level)                          \
> +			edac_printk(KERN_DEBUG, EDAC_DEBUG,		\
> +				    "%s: " fmt, __func__, ##arg);	\
>  	} while (0)
>  #else  /* CONFIG_EDAC_DEBUG_VERBOSE */
>  #define edac_debug_printk(level, fmt, arg...)                            \


-- 

Cheers,
Mauro
