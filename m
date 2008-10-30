Return-Path: <linux-kernel-owner+w=401wt.eu-S1758540AbYJ3SIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540AbYJ3SIw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 14:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757595AbYJ3SIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 14:08:40 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:57955 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600AbYJ3SIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 14:08:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nl0G4/meLlBINjR6NoZc5ge+7JFLxhIp5AUjxK6UbUAXNQxna6O3Br3kN2cDCJTNUr
         GaTO2nnklLyKnkIeDKVYm0XQfMedWD0j1DXc6by8quFtI+lvdmNAf+O6rjjFiGoeY+3h
         mBRRxXXcQH46YhX7cU8wN43haFq4XHPQEfrqU=
Date: Thu, 30 Oct 2008 21:05:48 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: next-20081029: arch/ia64/include/asm/smp.h:60: error: expected
	')' before '*' token
Message-ID: <20081030180548.GB13399@x200.localdomain>
References: <20081029145150.GA8668@x200.localdomain> <200810301656.m9UGuQUQ007129@agluck-lia64.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810301656.m9UGuQUQ007129@agluck-lia64.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 09:56:27AM -0700, Luck, Tony wrote:
> > On ia64-bigsur (and other ia64 defconfigs):
> > 
> >   CC      arch/ia64/kernel/asm-offsets.s
> > In file included from include/linux/smp.h:30,
> >                  from include/linux/sched.h:68,
> >                  from arch/ia64/kernel/asm-offsets.c:9:
> > arch/ia64/include/asm/smp.h:60: error: expected ')' before '*' token
> > arch/ia64/include/asm/smp.h:60: error: expected ')' before 'cpu_online_mask'

> --- a/arch/ia64/include/asm/smp.h
> +++ b/arch/ia64/include/asm/smp.h
> @@ -57,7 +57,6 @@ extern struct smp_boot_data {
>  
>  extern char no_int_routing __devinitdata;
>  
> -extern cpumask_t cpu_online_map;

This definitely helps.
