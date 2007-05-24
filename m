Return-Path: <linux-kernel-owner+w=401wt.eu-S1755680AbXEXVbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680AbXEXVbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 17:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbXEXVbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 17:31:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:60625 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbXEXVbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 17:31:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,575,1170662400"; 
   d="scan'208";a="231821216"
Date: Thu, 24 May 2007 14:28:06 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Andi Kleen <ak@suse.de>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <len.brown@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Display Intel Dynamic Acceleration feature in /proc/cpuinfo
Message-ID: <20070524212806.GA5249@linux-os.sc.intel.com>
References: <20070523224637.GB15887@linux-os.sc.intel.com> <200705242308.38360.ak@suse.de> <20070524211337.GB3692@linux-os.sc.intel.com> <200705242325.28011.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705242325.28011.ak@suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 11:25:27PM +0200, Andi Kleen wrote:
> On Thursday 24 May 2007 23:13:37 Venki Pallipadi wrote:
> > On Thu, May 24, 2007 at 11:08:38PM +0200, Andi Kleen wrote:
> > > 
> > > I think it's generally a good idea to push cpuinfo flags in earliest
> > > as possible; just make sure we actually use the final name (so that we don't get
> > > into a pni->sse3 mess again) 
> > >  
> > 
> > ida is official name as in the Software Developer's Manual now. So, should
> > not be a issue unless marketing folks change their mind in future :-)
> 
> Well they did sometimes in the past.
> 
> But actually reading the patch: it seems weird to detect the flag 
> in acpi-cpufreq and essentially change /proc/cpuinfo when a
> module is loaded. Why not in the intel setup function? And why is it 
> not in the standard CPUID 1 features mask anyways?
> 

I can do it in intel setup function. But, the feature may not be activated
unless the driver is loaded. Going by the hardware capability point
of view, we can do it in setup function.

The feature appears in CPUID 6 (called Power Management Leaf) instead of
regular CPUID 1 features.

Thanks,
Venki
