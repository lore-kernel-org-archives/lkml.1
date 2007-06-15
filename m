Return-Path: <linux-kernel-owner+w=401wt.eu-S1757406AbXFOS5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406AbXFOS5v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 14:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbXFOS5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 14:57:43 -0400
Received: from smtp-out.google.com ([216.239.45.13]:40045 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbXFOS5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 14:57:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=c5S6mDI94nYkpc2AAsLpe+PIJS3RfW//Hz5LBHUZM1YCuN5izFX8iq+FJX8uSLtY5
	GOEqqA2zHV4Z6l8KHXUuA==
Date: Fri, 15 Jun 2007 11:54:24 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Robert Richter <robert.richter@amd.com>
cc: Stephane Eranian <eranian@hpl.hp.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/8] 2.6.22-rc3 perfmon2 : IBS implementation for AMD64
In-Reply-To: <20070615093330.845322000@localhost>
Message-ID: <alpine.DEB.0.99.0706151153280.10812@chino.kir.corp.google.com>
References: <20070614215818.509851000@localhost>
 <20070615093330.845322000@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2007, Robert Richter wrote:

> Index: linux-2.6.22-rc3/arch/i386/perfmon/perfmon.c
> ===================================================================
> --- linux-2.6.22-rc3.orig/arch/i386/perfmon/perfmon.c
> +++ linux-2.6.22-rc3/arch/i386/perfmon/perfmon.c
> @@ -1059,6 +1059,7 @@ char *pfm_arch_get_pmu_module_name(void)
>  			goto try_arch;
>  		}
>  	case 15:
> +	case 16:
>  		/* All Opteron processors */
>  		if (cpu_data->x86_vendor == X86_VENDOR_AMD)
>  			return "perfmon_k8";

Constants like these should be #define'd in a header file but, admittedly, 
it might become a rather intrusive change at this point for the above 
case.
