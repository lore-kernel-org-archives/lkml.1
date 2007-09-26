Return-Path: <linux-kernel-owner+w=401wt.eu-S1757678AbXIZLDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678AbXIZLDr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 07:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbXIZLDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 07:03:39 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:55045 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbXIZLDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 07:03:38 -0400
Message-ID: <46FA3C14.6000407@linux.vnet.ibm.com>
Date: Wed, 26 Sep 2007 16:31:40 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Maxim Uvarov <muvarov@ru.mvista.com>
CC: LKML <linux-kernel@vger.kernel.org>, balbir@in.ibm.com, jlan@engr.sgi.com
Subject: Re: [PATCH] Since we have counters in __u64 format we have to print
 themwith %llu macros.
References: <20070926143918.6749.53939.stgit@localhost.localdomain>
In-Reply-To: <20070926143918.6749.53939.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim Uvarov wrote:
> Small fix for documentation.
> 
> 
>                                                       
> ---
> 
>  Documentation/accounting/getdelays.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/accounting/getdelays.c b/Documentation/accounting/getdelays.c
> index cbee3a2..73924df 100644
> --- a/Documentation/accounting/getdelays.c
> +++ b/Documentation/accounting/getdelays.c
> @@ -208,7 +208,7 @@ void print_delayacct(struct taskstats *t)
>  void task_context_switch_counts(struct taskstats *t)
>  {
>  	printf("\n\nTask   %15s%15s\n"
> -	       "       %15lu%15lu\n",
> +	       "       %15llu%15llu\n",
>  	       "voluntary", "nonvoluntary",
>  	       t->nvcsw, t->nivcsw);
>  }
> 

Looks good!

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
