Return-Path: <linux-kernel-owner+w=401wt.eu-S1753443AbZIAIui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbZIAIui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 04:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbZIAIuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 04:50:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:43213 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409AbZIAIuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 04:50:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="182702897"
Date: Tue, 1 Sep 2009 15:58:50 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Chris Wright <chrisw@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Josh Triplett <josh@joshtriplett.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Izik Eidus <ieidus@redhat.com>
Subject: Re: [PATCH] pagemap: document KPF_KSM and show it in page-types
Message-ID: <20090901075850.GB1446@localhost>
References: <20090808173900.GA21009@feather> <20090812065107.GA16363@localhost> <20090831135720.5E53.A69D9226@jp.fujitsu.com> <20090831065659.GA18039@localhost> <20090831071425.GA26634@localhost> <20090831071702.GB26634@localhost> <20090831164151.GB22649@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090831164151.GB22649@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 01, 2009 at 12:41:51AM +0800, Chris Wright wrote:
> * Wu Fengguang (fengguang.wu@intel.com) wrote:
> > It indicates to the system admin that processes mapping such pages may be
> > eating less physical memory than the reported numbers by legacy tools.
> > 
> > CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> > CC: Chris Wright <chrisw@redhat.com>
> > CC: Izik Eidus <ieidus@redhat.com>
> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> 
> Acked-by: Chris Wright <chrisw@redhat.com>

Thanks.

> > --- linux-mm.orig/tools/vm/page-types.c	2009-08-31 15:00:24.000000000 +0800
> > +++ linux-mm/tools/vm/page-types.c	2009-08-31 15:02:10.000000000 +0800
> > @@ -49,6 +49,7 @@
> >  #define KPF_UNEVICTABLE		18
> >  #define KPF_HWPOISON		19
> >  #define KPF_NOPAGE		20
> > +#define KPF_KSM			21
> 
> Doesn't this highlight the trouble w/ maintaining two copies of same info?

Yes, I even had patch to move these numbers to page-flags.h.
however given that we have to update the flag name strings anyway,
this is not a big extra burden?

Thanks,
Fengguang

