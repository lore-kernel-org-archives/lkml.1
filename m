Return-Path: <linux-kernel-owner+w=401wt.eu-S965407AbXEWTTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965407AbXEWTTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 15:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbXEWTTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 15:19:32 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:58452 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450AbXEWTTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 15:19:31 -0400
Date: Wed, 23 May 2007 12:20:05 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, clameter@sgi.com,
       rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Subject: Re: [PATCH 1/2] Define new percpu interface for shared data -- version 3
Message-ID: <20070523192005.GB4072@localhost.localdomain>
References: <20070523185748.GA4072@localhost.localdomain> <79E93560F4A5FD42BB769DAAF8BEF62A01AA8CF8@scsmsx411.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79E93560F4A5FD42BB769DAAF8BEF62A01AA8CF8@scsmsx411.amr.corp.intel.com>
User-Agent: Mutt/1.4.2.1i
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 12:09:56PM -0700, Yu, Fenghua wrote:
> 
> >Has there been any measurable benefit yet due to tail padding?
> 
> We don't have data that tail padding actually helps. It all
> depends on what data the linker lays out in the cachelines.
> 
> As of now we just want to create the infrastructure (so that
> more and more people who need it, can use it).

So what we have now is space wastage on some architectures, space savings on
some, but with no measurable performance benefit due to the infrastructure
itself.  Why not push the infrastructure when we really need it, as against
pushing it now when we are not sure if it benefits?

Thanks,
Kiran 
