Return-Path: <linux-kernel-owner+w=401wt.eu-S1759301AbZJIBqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301AbZJIBqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 21:46:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757109AbZJIBqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 21:46:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:57758 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755018AbZJIBqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 21:46:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,529,1249282800"; 
   d="scan'208";a="501307444"
Subject: Re: [PATCH 06/10] x86, mce: make mce_log buffer to per-CPU
From: Huang Ying <ying.huang@intel.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4AC9A534.6080704@jp.fujitsu.com>
References: <1253269241.15717.525.camel@yhuang-dev.sh.intel.com>
	 <4AC990E1.7030708@jp.fujitsu.com> <4AC99483.7020100@jp.fujitsu.com>
	 <4AC99AEC.3000504@linux.intel.com>  <4AC9A534.6080704@jp.fujitsu.com>
Content-Type: text/plain
Date: Fri, 09 Oct 2009 09:45:30 +0800
Message-Id: <1255052730.5228.22.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-05 at 15:50 +0800, Hidetoshi Seto wrote: 
> Andi Kleen wrote:
> >> (This piece originates from Huang's patch, titled:
> >>  "x86, MCE: Fix bugs and issues of MCE log ring buffer")
> > 
> > You should use proper From: headers then for correct attribution.
> > 
> > -Andi
> 
> I just referred following commit we already have: 
> 
> > commit 77e26cca20013e9352a8df86a54640543304a23a
> > Author: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> > Date:   Thu Jun 11 16:04:35 2009 +0900
> > 
> >     x86, mce: Fix mce printing
> > 
> >     This patch:
> > 
> >      - Adds print_mce_head() instead of first flag
> >      - Makes the header to be printed always
> >      - Stops double printing of corrected errors
> > 
> >     [ This portion originates from Huang Ying's patch ]
> > 
> >     Originally-From: Huang Ying <ying.huang@intel.com>
> >     Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> >     LKML-Reference: <4A30AC83.5010708@jp.fujitsu.com>
> >     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> You mean s/Originally-From/From/, right?
> 
> I'll update attributes if this set need to be revised or if maintainer
> (who expected to be able to set proper attributes) request me to do so.

I don't think it is a good collaboration style to copy others' patches,
do some modification and send it out, instead:

- comment on original patches
- communicate with the original author firstly
- provide another patch on top of original patches

Best Regards,
Huang Ying


