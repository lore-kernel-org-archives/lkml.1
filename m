Return-Path: <linux-kernel-owner+w=401wt.eu-S1751214Ab0AVFh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751214Ab0AVFh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 00:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750941Ab0AVFh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 00:37:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:32936 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866Ab0AVFh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 00:37:58 -0500
Date: Thu, 21 Jan 2010 21:31:57 -0800
From: Greg KH <gregkh@suse.de>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       Andi Kleen <andi@firstfloor.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/4] devmem and readahead fixes for 2.6.33
Message-ID: <20100122053157.GA8312@suse.de>
References: <20100122045914.993668874@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100122045914.993668874@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 22, 2010 at 12:59:14PM +0800, Wu Fengguang wrote:
> Andrew,
> 
> Here are some good fixes for 2.6.33, they have been floating around
> with other patches for some time. I should really seperate them out
> earlier..
> 
> Greg,
> 
> The first two patches are on devmem. 2.6.32 also needs fixing, however
> the patches can only apply cleanly to 2.6.33. I can do backporting if
> necessary.
> 
> 	[PATCH 1/4] devmem: check vmalloc address on kmem read/write
> 	[PATCH 2/4] devmem: fix kmem write bug on memory holes

After these hit Linus's tree, please send the backport to
stable@kernel.org and I will be glad to queue them up.

thanks,

greg k-h
