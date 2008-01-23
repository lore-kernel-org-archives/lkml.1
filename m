Return-Path: <linux-kernel-owner+w=401wt.eu-S1754907AbYAWOSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbYAWOSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 09:18:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbYAWOSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 09:18:45 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45850 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754088AbYAWOSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 09:18:44 -0500
Message-ID: <47974CC3.4060203@sgi.com>
Date: Wed, 23 Jan 2008 06:18:43 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
CC: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <clameter@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: should use array directly for early_ptr
References: <200801230056.16424.yinghai.lu@sun.com> <200801230127.32113.yinghai.lu@sun.com>
In-Reply-To: <200801230127.32113.yinghai.lu@sun.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> [PATCH] x86_64: should use array directly for early_ptr
> 
> Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
> 
> --- a/arch/x86/kernel/setup_64.c	2008-01-23 01:21:06.000000000 -0800
> +++ b/arch/x86/kernel/setup_64.c	2008-01-23 01:21:24.000000000 -0800
> @@ -344,10 +344,10 @@
>  
>  #ifdef CONFIG_SMP
>  	/* setup to use the early static init tables during kernel startup */
> -	x86_cpu_to_apicid_early_ptr = (void *)&x86_cpu_to_apicid_init;
> -	x86_bios_cpu_apicid_early_ptr = (void *)&x86_bios_cpu_apicid_init;
> +	x86_cpu_to_apicid_early_ptr = (void *)x86_cpu_to_apicid_init;
> +	x86_bios_cpu_apicid_early_ptr = (void *)x86_bios_cpu_apicid_init;
>  #ifdef CONFIG_NUMA
> -	x86_cpu_to_node_map_early_ptr = (void *)&x86_cpu_to_node_map_init;
> +	x86_cpu_to_node_map_early_ptr = (void *)x86_cpu_to_node_map_init;
>  #endif
>  #endif
>  


Also Thanks!

-Mike
