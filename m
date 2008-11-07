Return-Path: <linux-kernel-owner+w=401wt.eu-S1752985AbYKGBfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985AbYKGBfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 20:35:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750772AbYKGBfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 20:35:44 -0500
Received: from vms042pub.verizon.net ([206.46.252.42]:55479 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbYKGBfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 20:35:43 -0500
Date: Thu, 06 Nov 2008 20:35:41 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH]1/3 intel_menlow:Adding comment for GTHS legal values
In-reply-to: <7D0189F5BE1DF549A570B212D1D5612182AF02@bgsmsx412.gar.corp.intel.com>
X-X-Sender: lenb@localhost.localdomain
To: "Thomas, Sujith" <sujith.thomas@intel.com>
Cc: "Zhang, Rui" <rui.zhang@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Message-id: <alpine.LFD.2.00.0811062030280.3106@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <7D0189F5BE1DF549A570B212D1D5612182AF02@bgsmsx412.gar.corp.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sujith,

I applied 1/3 and 2/3.
I had to hand-edit them because they were line wrapped
by your mailer.

This is only a minor waste of my time for a trivial patch,
but for a longer patch, I'm not going to do that for you.

Please read Documentation/SubmittingPatches

note that it is [PATCH 1/3], not [PATCH] 1/3 -- as future
generations don't need the '1/3' in the commit message...

thanks,
-Len

ps. also, don't bother sending a copy of patches to my intel.com
address, that goes to exchange, which destroys patches.
I apply all patches from my kernel.org account, which is
subscribed to the lists.

On Wed, 5 Nov 2008, Thomas, Sujith wrote:

> Documentation of legal values for GTHS
> To be patched over Rui's 09/11 bug fix patch
> 
> Signed-off-by: Sujith Thomas <sujith.thomas@intel.com>
> ---
>  drivers/misc/intel_menlow.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> Index: linux-2.6.27/drivers/misc/intel_menlow.c
> ===================================================================
> --- linux-2.6.27.orig/drivers/misc/intel_menlow.c
> +++ linux-2.6.27/drivers/misc/intel_menlow.c
> @@ -52,6 +52,11 @@ MODULE_LICENSE("GPL");
>  #define MEMORY_ARG_CUR_BANDWIDTH 1
>  #define MEMORY_ARG_MAX_BANDWIDTH 0
>  
> +/*
> + * GTHS returning 'n' would mean that [0,n-1] states are supported
> + * In that case max_cstate would be n-1
> + * GTHS returning '0' would mean that no bandwidth control states are
> supported
> + */
>  static int memory_get_int_max_bandwidth(struct thermal_cooling_device
> *cdev,
>  					unsigned long *max_state)
>  {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
