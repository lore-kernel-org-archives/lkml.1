Return-Path: <linux-kernel-owner+w=401wt.eu-S1763644AbXFTSqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763644AbXFTSqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761170AbXFTSg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:36:59 -0400
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:41767 "EHLO
	outbound2-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760477AbXFTSg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:36:57 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Wed, 20 Jun 2007 20:36:05 +0200
From: "Robert Richter" <robert.richter@amd.com>
To: "David Rientjes" <rientjes@google.com>
cc: "Stephane Eranian" <eranian@hpl.hp.com>,
       "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/8] 2.6.22-rc3 perfmon2 : IBS implementation for
 AMD64
Message-ID: <20070620183605.GF24544@erda.amd.com>
References: <20070614215818.509851000@localhost>
 <20070615093330.845322000@localhost>
 <alpine.DEB.0.99.0706151153280.10812@chino.kir.corp.google.com>
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.0.99.0706151153280.10812@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 20 Jun 2007 18:36:05.0620 (UTC)
 FILETIME=[DC883340:01C7B369]
X-WSS-ID: 6A67AC361S4957085-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David,

thanks for your comments.

On 15.06.07 11:54:24, David Rientjes wrote:
> On Fri, 15 Jun 2007, Robert Richter wrote:
> 
> > Index: linux-2.6.22-rc3/arch/i386/perfmon/perfmon.c
> > ===================================================================
> > --- linux-2.6.22-rc3.orig/arch/i386/perfmon/perfmon.c
> > +++ linux-2.6.22-rc3/arch/i386/perfmon/perfmon.c
> > @@ -1059,6 +1059,7 @@ char *pfm_arch_get_pmu_module_name(void)
> >  			goto try_arch;
> >  		}
> >  	case 15:
> > +	case 16:
> >  		/* All Opteron processors */
> >  		if (cpu_data->x86_vendor == X86_VENDOR_AMD)
> >  			return "perfmon_k8";
> 
> Constants like these should be #define'd in a header file but, admittedly, 
> it might become a rather intrusive change at this point for the above 
> case.

All current x86 CPU detection code in the kernel is using hard coded
numbers. Introducing new defines for family and model numbers would
not be suitable here.

Thanks,
-Robert

-- 
AMD Saxony, Dresden, Germany
Operating System Research Center
email: robert.richter@amd.com



