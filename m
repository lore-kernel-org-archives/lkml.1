Return-Path: <linux-kernel-owner+w=401wt.eu-S1761722AbZEGCIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761722AbZEGCIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 22:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755366AbZEGCIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 22:08:00 -0400
Received: from mga14.intel.com ([143.182.124.37]:13702 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753795AbZEGCIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 22:08:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,305,1239001200"; 
   d="scan'208";a="140045983"
Date: Thu, 7 May 2009 10:07:36 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, Matt Mackall <mpm@selenic.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 4/7] proc: export more page flags in /proc/kpageflags
Message-ID: <20090507020736.GB12281@localhost>
References: <20090507012116.996644836@intel.com> <20090507014914.364045992@intel.com> <20090507110431.b6a10746.minchan.kim@barrios-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507110431.b6a10746.minchan.kim@barrios-desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 10:04:31AM +0800, Minchan Kim wrote:
> 
> Hi, 
> 
> > +#ifdef CONFIG_MEMORY_FAILURE
> > +	u |= kpf_copy_bit(k, KPF_HWPOISON,	PG_hwpoison);
> > +#endif
> 
> Did mmtom merge memory failure feature?

Maybe not yet.. but the #ifdef makes it safe :-)
