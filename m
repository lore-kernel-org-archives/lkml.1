Return-Path: <linux-kernel-owner+w=401wt.eu-S1754126AbXEXVN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbXEXVN5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 17:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbXEXVNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 17:13:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:54356 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbXEXVNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 17:13:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,575,1170662400"; 
   d="scan'208";a="249413751"
Date: Thu, 24 May 2007 14:10:41 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Dave Jones <davej@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Len Brown <len.brown@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] Display Intel Dynamic Acceleration feature in /proc/cpuinfo
Message-ID: <20070524211041.GA3692@linux-os.sc.intel.com>
References: <20070523224637.GB15887@linux-os.sc.intel.com> <20070524135513.b6efacbf.akpm@linux-foundation.org> <20070524210103.GA5380@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070524210103.GA5380@redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 05:01:04PM -0400, Dave Jones wrote:
> On Thu, May 24, 2007 at 01:55:13PM -0700, Andrew Morton wrote:
>  > On Wed, 23 May 2007 15:46:37 -0700
>  > Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:
>  > 
>  > > Display Intel Dynamic Acceleration feature in /proc/cpuinfo. This feature
>  > > will be enabled automatically by current acpi-cpufreq driver and cpufreq.
>  > 
>  > So you're saying that the cpufreq code in Linus's tree aleady supports IDA?
>  > If so, this is a 2.6.22 patch, isn't it?
> 
> From my limited understanding[*], ida is the "We're single threaded,
> disable the 2nd core, and clock the first core faster" magic.
> It doesn't need code-changes, as its all done in hardware afaik.

IDA state will appear as a new highest freq P-state (P0) and when software
requests that frequency, hardware can provide a higher frequency than that
oppurtunistically and transparently.

The current cpufreq code will detect this new state and enter that state
when CPU is busy.

> 
> identifying & exporting the flags on earlier kernels should be harmless,
> but not really 'mustfix'.
> 

Agree with Dave that it is not a mustfix. As the patch is pretty harmless
would be nice to have in 2.6.22.

Thanks,
Venki
