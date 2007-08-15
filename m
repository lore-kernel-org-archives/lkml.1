Return-Path: <linux-kernel-owner+w=401wt.eu-S1760945AbXHONQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760945AbXHONQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 09:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbXHONQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 09:16:09 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:35470 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbXHONQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 09:16:06 -0400
Message-ID: <46C2FC87.7060306@linux.vnet.ibm.com>
Date: Wed, 15 Aug 2007 18:45:51 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Michael Neuling <mikey@neuling.org>
CC: linux-kernel@vger.kernel.org, akpm@osdl.org,
       Maxim Uvarov <muvarov@ru.mvista.com>
Subject: Re: [PATCH] Documentation: fix getdelays.c printf bug
References: <18240.1186734285@neuling.org> <46C2A505.7040008@linux.vnet.ibm.com> <11201.1187165591@neuling.org> <46C2E189.7040504@linux.vnet.ibm.com> <29652.1187179715@neuling.org>
In-Reply-To: <29652.1187179715@neuling.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Neuling wrote:
> b663a79c191508f27cd885224b592a878c0ba0f6 incorrectly removed a comma
> from a printf statement.  This causes corruption in the output printing
> or a seg fault.
> 
> Signed-off-by: Michael Neuling <mikey@ozlabs.org>
> ---
>  Documentation/accounting/getdelays.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> akpm: please replace
> documentation-fix-getdelaysc-example-l-option-and-segv.patch with this.
> 
> Index: linux-2.6-ozlabs/Documentation/accounting/getdelays.c
> ===================================================================
> --- linux-2.6-ozlabs.orig/Documentation/accounting/getdelays.c
> +++ linux-2.6-ozlabs/Documentation/accounting/getdelays.c
> @@ -196,7 +196,7 @@ void print_delayacct(struct taskstats *t
>  	       "IO    %15s%15s\n"
>  	       "      %15llu%15llu\n"
>  	       "MEM   %15s%15s\n"
> -	       "      %15llu%15llu\n"
> +	       "      %15llu%15llu\n",
>  	       "count", "real total", "virtual total", "delay total",
>  	       t->cpu_count, t->cpu_run_real_total, t->cpu_run_virtual_total,
>  	       t->cpu_delay_total,

This is exactly what Maxim had sent as well.

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
