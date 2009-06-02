Return-Path: <linux-kernel-owner+w=401wt.eu-S1757435AbZFBOVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435AbZFBOVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 10:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbZFBOVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 10:21:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37009 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbZFBOVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:21:45 -0400
Date: Tue, 2 Jun 2009 16:21:43 +0200
From: Nick Piggin <npiggin@suse.de>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, "hugh@veritas.com" <hugh@veritas.com>,
       "riel@redhat.com" <riel@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] [13/16] HWPOISON: The high level memory error handler in the VM v3
Message-ID: <20090602142143.GD26982@wotan.suse.de>
References: <20090601183225.GS1065@one.firstfloor.org> <20090602120042.GB1392@wotan.suse.de> <20090602124757.GG1065@one.firstfloor.org> <20090602125713.GG1392@wotan.suse.de> <20090602132538.GK1065@one.firstfloor.org> <20090602132441.GC6262@wotan.suse.de> <20090602134126.GM1065@one.firstfloor.org> <20090602135324.GB21338@localhost> <20090602140639.GQ1065@one.firstfloor.org> <20090602141222.GD21338@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090602141222.GD21338@localhost>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 10:12:22PM +0800, Wu Fengguang wrote:
> On Tue, Jun 02, 2009 at 10:06:39PM +0800, Andi Kleen wrote:
> > > > Ok you're right. That one is not needed. I will remove it.
> > > 
> > > No! Please read the comment. In fact __remove_from_page_cache() has a
> > > 
> > >                 BUG_ON(page_mapped(page));
> > > 
> > > Or, at least correct that BUG_ON() line together.
> > 
> > Yes, but we already have them unmapped earlier and the poison check
> 
> But you commented "try_to_unmap can fail temporarily due to races."
> 
> That's self-contradictory.

If you use the bloody code I posted (and suggested from the start),
then you DON'T HAVE TO WORRY ABOUT THIS, because it is handled by
the subsystem that knows about it.

How anybody can say it will make your code overcomplicated or "is
not much improvement" is just totally beyond me.

