Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184Ab0A0Bsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab0A0Bsj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 20:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753755Ab0A0Bsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 20:48:30 -0500
Received: from cantor.suse.de ([195.135.220.2]:34263 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897Ab0A0Bs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 20:48:28 -0500
Date: Tue, 26 Jan 2010 17:39:13 -0800
From: Greg KH <gregkh@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, stable@kernel.org,
       Andi Kleen <andi@firstfloor.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/4] devmem and readahead fixes for 2.6.33
Message-ID: <20100127013913.GA926@suse.de>
References: <20100122045914.993668874@intel.com>
 <20100122053157.GA8312@suse.de>
 <20100126165050.6ab7977b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100126165050.6ab7977b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 04:50:50PM -0800, Andrew Morton wrote:
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

Sounds good to me.

thanks,

greg k-h
