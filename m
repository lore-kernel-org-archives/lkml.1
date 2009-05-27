Return-Path: <linux-kernel-owner+w=401wt.eu-S1757461AbZE0WoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbZE0WoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 18:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755582AbZE0WoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 18:44:15 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:52761 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158AbZE0WoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 18:44:15 -0400
Date: Wed, 27 May 2009 18:34:54 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Joe Perches <joe@perches.com>
Cc: Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acpi-cpufreq.c - Fix typo and indentation
In-reply-to: <1243097445.3506.4.camel@Joe-Laptop.home>
Message-id: <alpine.LFD.2.00.0905271834320.25587@localhost.localdomain>
References: <1243097445.3506.4.camel@Joe-Laptop.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied

thanks,
Len Brown, Intel Open Source Technology Center

On Sat, 23 May 2009, Joe Perches wrote:

> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> index 208ecf6..54b6de2 100644
> --- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> +++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> @@ -693,8 +693,8 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
>  	if (perf->control_register.space_id == ACPI_ADR_SPACE_FIXED_HARDWARE &&
>  	    policy->cpuinfo.transition_latency > 20 * 1000) {
>  		policy->cpuinfo.transition_latency = 20 * 1000;
> -			printk_once(KERN_INFO "Capping off P-state tranision"
> -				    " latency at 20 uS\n");
> +		printk_once(KERN_INFO
> +			    "P-state transition latency capped at 20 uS\n");
>  	}
>  
>  	/* table init */
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
