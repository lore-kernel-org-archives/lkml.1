Return-Path: <linux-kernel-owner+w=401wt.eu-S943209AbXHNGGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943209AbXHNGGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 02:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757535AbXHNGGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 02:06:19 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:47641 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757887AbXHNGGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 02:06:18 -0400
Message-ID: <46C145D2.6020309@linux.vnet.ibm.com>
Date: Tue, 14 Aug 2007 11:34:02 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Maxim Uvarov <muvarov@ru.mvista.com>
CC: LKML <linux-kernel@vger.kernel.org>, balbir@in.ibm.com, jlan@engr.sgi.com
Subject: Re: [PATCH] Missed "," character in printf in print_delayacct().
References: <20070810181647.30167.94665.stgit@localhost.localdomain>
In-Reply-To: <20070810181647.30167.94665.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim Uvarov wrote:
> Sorry I've removed "," character from Documentation/accounting/getdelays.c
> with taskstats-add-context-switch-counters.patch.
> 
> It is needed to turn it back.	
> 
> 
> Signed-off-by: Maxim Uvarov <muvarov@ru.mvista.com>
>                                                       
> ---
> 
>  Documentation/accounting/getdelays.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/accounting/getdelays.c b/Documentation/accounting/getdelays.c
> index 24c5aad..cbee3a2 100644
> --- a/Documentation/accounting/getdelays.c
> +++ b/Documentation/accounting/getdelays.c
> @@ -196,7 +196,7 @@ void print_delayacct(struct taskstats *t)
>  	       "IO    %15s%15s\n"
>  	       "      %15llu%15llu\n"
>  	       "MEM   %15s%15s\n"
> -	       "      %15llu%15llu\n"
> +	       "      %15llu%15llu\n",
>  	       "count", "real total", "virtual total", "delay total",
>  	       t->cpu_count, t->cpu_run_real_total, t->cpu_run_virtual_total,
>  	       t->cpu_delay_total,
> 

Michael Neuling, sent this fix along with his fix for fixing the -l option.


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
