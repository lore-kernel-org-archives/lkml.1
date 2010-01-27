Return-Path: <linux-kernel-owner+w=401wt.eu-S1754960Ab0A0Cpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab0A0Cpm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 21:45:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754889Ab0A0Cpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 21:45:41 -0500
Received: from mga09.intel.com ([134.134.136.24]:41364 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754874Ab0A0Cpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 21:45:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,350,1262592000"; 
   d="scan'208";a="590707090"
Date: Wed, 27 Jan 2010 10:45:19 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, "stable@kernel.org" <stable@kernel.org>,
       Andi Kleen <andi@firstfloor.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 0/4] devmem and readahead fixes for 2.6.33
Message-ID: <20100127024519.GC8132@localhost>
References: <20100122045914.993668874@intel.com> <20100122053157.GA8312@suse.de> <20100126165050.6ab7977b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100126165050.6ab7977b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 05:50:50PM -0700, Andrew Morton wrote:
> On Thu, 21 Jan 2010 21:31:57 -0800
> Greg KH <gregkh@suse.de> wrote:
> 
> > On Fri, Jan 22, 2010 at 12:59:14PM +0800, Wu Fengguang wrote:
> > > Andrew,
> > > 
> > > Here are some good fixes for 2.6.33, they have been floating around
> > > with other patches for some time. I should really seperate them out
> > > earlier..
> > > 
> > > Greg,
> > > 
> > > The first two patches are on devmem. 2.6.32 also needs fixing, however
> > > the patches can only apply cleanly to 2.6.33. I can do backporting if
> > > necessary.
> > > 
> > > 	[PATCH 1/4] devmem: check vmalloc address on kmem read/write
> > > 	[PATCH 2/4] devmem: fix kmem write bug on memory holes
> > 
> > After these hit Linus's tree, please send the backport to
> > stable@kernel.org and I will be glad to queue them up.
> > 
> 
> I tagged the first two patches for -stable and shall send them in for 2.6.33.
> 
> The second two patches aren't quite as obvious - perhaps a risk of
> weird regressions.  So I'm thinking I'll send them in for 2.6.34-rc1
> and I tagged them as "[2.6.33.x]" for -stable, so you can feed them
> into 2.6.33.x once 2.6.34-rcX has had a bit of testing time, OK?

OK, I'll send the patches to stable kernel once they hit mainline.

Thanks,
Fengguang
