Return-Path: <linux-kernel-owner+w=401wt.eu-S1759839AbZFIJz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759839AbZFIJz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 05:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759195AbZFIJzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 05:55:16 -0400
Received: from relay3.sgi.com ([192.48.156.57]:44023 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754390AbZFIJzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 05:55:14 -0400
Date: Tue, 9 Jun 2009 04:55:07 -0500
From: Robin Holt <holt@sgi.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Robin Holt <holt@sgi.com>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       Wu Fengguang <fengguang.wu@intel.com>, linux-ia64@vger.kernel.org,
       linuxppc-dev@ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v4] zone_reclaim is always 0 by default
Message-ID: <20090609095507.GA9851@attica.americas.sgi.com>
References: <20090604192236.9761.A69D9226@jp.fujitsu.com> <20090608115048.GA15070@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090608115048.GA15070@csn.ul.ie>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 12:50:48PM +0100, Mel Gorman wrote:

Let me start by saying I agree completely with everything you wrote and
still disagree with this patch, but was willing to compromise and work
around this for our upcoming x86_64 machine by putting a "value add"
into our packaging of adding a sysctl that turns reclaim back on.

...
> > Index: b/arch/powerpc/include/asm/topology.h
> > ===================================================================
> > --- a/arch/powerpc/include/asm/topology.h
> > +++ b/arch/powerpc/include/asm/topology.h
> > @@ -10,6 +10,12 @@ struct device_node;
> >  
> >  #include <asm/mmzone.h>
> >  
> > +/*
> > + * Distance above which we begin to use zone reclaim
> > + */
> > +#define RECLAIM_DISTANCE 20
> > +
> > +
> 
> Where is the ia-64-specific modifier to RECAIM_DISTANCE?

It was already defined as 15 in arch/ia64/include/asm/topology.h

Thanks,
Robin
