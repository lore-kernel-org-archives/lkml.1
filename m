Return-Path: <linux-kernel-owner+w=401wt.eu-S1758869AbXFTTrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869AbXFTTrc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 15:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbXFTTrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 15:47:25 -0400
Received: from smtp-out.google.com ([216.239.45.13]:36567 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbXFTTrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 15:47:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=EmDfd6mvotmQr1y9KBtnbjSXVpGawd9v7bMioVzqe5QO3ENjgI/XhdnpjRDkuSYwM
	bb1fNy1pgSTewcUqvb0fQ==
Date: Wed, 20 Jun 2007 12:43:59 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Robert Richter <robert.richter@amd.com>
cc: Stephane Eranian <eranian@hpl.hp.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 7/8] 2.6.22-rc3 perfmon2 : Renaming *_k8_* symbols to
 *_amd64_*
In-Reply-To: <20070620184154.GH5874@erda.amd.com>
Message-ID: <alpine.DEB.0.99.0706201243330.4562@chino.kir.corp.google.com>
References: <20070620182126.248753000@amd.com>
 <20070620184154.GH5874@erda.amd.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2007, Robert Richter wrote:

> This patch renames *_k8_* symbols to *_amd64_*.
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> 
> Index: linux-2.6.22-rc3/arch/x86_64/perfmon/perfmon_k8.c
> ===================================================================
> --- linux-2.6.22-rc3.orig/arch/x86_64/perfmon/perfmon_k8.c
> +++ linux-2.6.22-rc3/arch/x86_64/perfmon/perfmon_k8.c
> @@ -36,7 +36,7 @@ static int force_nmi;
>  MODULE_PARM_DESC(force_nmi, "bool: force use of NMI for PMU interrupt");
>  module_param(force_nmi, bool, 0600);
>  
> -static struct pfm_arch_pmu_info pfm_k8_pmu_info = {
> +static struct pfm_arch_pmu_info pfm_amd64_pmu_info = {
>  	.pmc_addrs = {
>  /* pmc0  */	{{MSR_K7_EVNTSEL0, 0}, 0, PFM_REGT_EN},
>  /* pmc1  */	{{MSR_K7_EVNTSEL1, 0}, 1, PFM_REGT_EN},
> @@ -96,7 +96,7 @@ static struct pfm_arch_pmu_info pfm_k8_p
>  #define PFM_AMD64_IBSOPCTL_NO64		PFM_AMD64_IBSOPEN
>  #define PFM_AMD64_IBSOPCTL_RSVD		(~((1ULL<<16)-1))
>  
> -static struct pfm_reg_desc pfm_k8_pmc_desc[]={
> +static struct pfm_reg_desc pfm_amd64_pmc_desc[]={
>  /* pmc0  */ PMC_D(PFM_REG_I64, "PERFSEL0", PFM_K8_VAL, PFM_K8_RSVD, PFM_K8_NO64, MSR_K7_EVNTSEL0),
>  /* pmc1  */ PMC_D(PFM_REG_I64, "PERFSEL1", PFM_K8_VAL, PFM_K8_RSVD, PFM_K8_NO64, MSR_K7_EVNTSEL1),
>  /* pmc2  */ PMC_D(PFM_REG_I64, "PERFSEL2", PFM_K8_VAL, PFM_K8_RSVD, PFM_K8_NO64, MSR_K7_EVNTSEL2),

Please fix the spacing here while you're at it.  Thanks for doing it in 
the other patches in this series.
