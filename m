Return-Path: <linux-kernel-owner+w=401wt.eu-S1759470AbZLJCJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759470AbZLJCJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 21:09:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759447AbZLJCJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 21:09:24 -0500
Received: from mga14.intel.com ([143.182.124.37]:20611 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759416AbZLJCJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 21:09:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="220884049"
Date: Thu, 10 Dec 2009 10:09:27 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Matt Mackall <mpm@selenic.com>, "npiggin@suse.de" <npiggin@suse.de>,
       "cl@linux-foundation.org" <cl@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] [19/31] mm: export stable page flags
Message-ID: <20091210020927.GA11017@localhost>
References: <200912081016.198135742@firstfloor.org> <20091208211635.7965AB151F@basil.firstfloor.org> <1260311251.31323.129.camel@calx> <20091209020042.GA7751@localhost> <20091210015014.GK18989@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091210015014.GK18989@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 09:50:14AM +0800, Andi Kleen wrote:
> > Sorry the stable_page_flags() will be undefined on
> > !CONFIG_PROC_PAGE_MONITOR (it is almost always on,
> > except for some embedded systems).
> > 
> > Currently the easy solution is to add a Kconfig dependency to
> > CONFIG_PROC_PAGE_MONITOR.  When there comes more users (ie. some
> > ftrace event), we can then always compile in stable_page_flags().
> 
> I decided to turn it into select instead.

OK, that would be good.

> Your original patch didn't handle hwpoison as module btw.

Yes I realized it later..

Thanks,
Fengguang
