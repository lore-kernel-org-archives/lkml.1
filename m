Return-Path: <linux-kernel-owner+w=401wt.eu-S1755872AbXFUOQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbXFUOQp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 10:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbXFUOQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 10:16:36 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:55108 "EHLO
	outbound4-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751751AbXFUOQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 10:16:35 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Thu, 21 Jun 2007 16:00:39 +0200
From: "Robert Richter" <robert.richter@amd.com>
To: "David Rientjes" <rientjes@google.com>
cc: "Stephane Eranian" <eranian@hpl.hp.com>,
       "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 7/8] 2.6.22-rc3 perfmon2 : Renaming *_k8_* symbols
 to *_amd64_*
Message-ID: <20070621140039.GX24544@erda.amd.com>
References: <20070620182126.248753000@amd.com>
 <20070620184154.GH5874@erda.amd.com>
 <alpine.DEB.0.99.0706201243330.4562@chino.kir.corp.google.com>
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.0.99.0706201243330.4562@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 21 Jun 2007 14:00:39.0648 (UTC)
 FILETIME=[8CB2BE00:01C7B40C]
X-WSS-ID: 6A645B011S41035443-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.06.07 12:43:59, David Rientjes wrote:
> On Wed, 20 Jun 2007, Robert Richter wrote:
> 
> > This patch renames *_k8_* symbols to *_amd64_*.
> > 
> > Signed-off-by: Robert Richter <robert.richter@amd.com>
> > 
> > Index: linux-2.6.22-rc3/arch/x86_64/perfmon/perfmon_k8.c
> > ===================================================================
> > --- linux-2.6.22-rc3.orig/arch/x86_64/perfmon/perfmon_k8.c
> > +++ linux-2.6.22-rc3/arch/x86_64/perfmon/perfmon_k8.c
> > @@ -36,7 +36,7 @@ static int force_nmi;
> >  MODULE_PARM_DESC(force_nmi, "bool: force use of NMI for PMU interrupt");
> >  module_param(force_nmi, bool, 0600);
> >  
> > -static struct pfm_arch_pmu_info pfm_k8_pmu_info = {
> > +static struct pfm_arch_pmu_info pfm_amd64_pmu_info = {
> >  	.pmc_addrs = {
> >  /* pmc0  */	{{MSR_K7_EVNTSEL0, 0}, 0, PFM_REGT_EN},
> >  /* pmc1  */	{{MSR_K7_EVNTSEL1, 0}, 1, PFM_REGT_EN},
> > @@ -96,7 +96,7 @@ static struct pfm_arch_pmu_info pfm_k8_p
> >  #define PFM_AMD64_IBSOPCTL_NO64		PFM_AMD64_IBSOPEN
> >  #define PFM_AMD64_IBSOPCTL_RSVD		(~((1ULL<<16)-1))
> >  
> > -static struct pfm_reg_desc pfm_k8_pmc_desc[]={
> > +static struct pfm_reg_desc pfm_amd64_pmc_desc[]={
> >  /* pmc0  */ PMC_D(PFM_REG_I64, "PERFSEL0", PFM_K8_VAL, PFM_K8_RSVD, PFM_K8_NO64, MSR_K7_EVNTSEL0),
> >  /* pmc1  */ PMC_D(PFM_REG_I64, "PERFSEL1", PFM_K8_VAL, PFM_K8_RSVD, PFM_K8_NO64, MSR_K7_EVNTSEL1),
> >  /* pmc2  */ PMC_D(PFM_REG_I64, "PERFSEL2", PFM_K8_VAL, PFM_K8_RSVD, PFM_K8_NO64, MSR_K7_EVNTSEL2),
> 
> Please fix the spacing here while you're at it.  Thanks for doing it in 
> the other patches in this series.
> 
> 

Fixed in patch version 3.

-Robert

-- 
AMD Saxony, Dresden, Germany
Operating System Research Center
email: robert.richter@amd.com



