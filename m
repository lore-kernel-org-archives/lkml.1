Return-Path: <linux-kernel-owner+w=401wt.eu-S1756237AbZJVVdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbZJVVdz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 17:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754853AbZJVVdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 17:33:54 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:21173 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbZJVVdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 17:33:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hqt7iM8IGgJkAMRCWDEFbXLhI1GdUh/zZEaIyOwRHxv/91q6m0FY5QtbXULOlc4wND
         0EQWqql5UgijtXZObb4zc+cMH3/vMePtK2FW2yK7H7yEXkMg8b+MGL0yVcWYsQdHfN81
         Tycqq3CCdDzAH5Lj5tTXlQT5JB8AG1ywu99fo=
Date: Thu, 22 Oct 2009 23:33:53 +0200
From: Karol Lewandowski <karol.k.lewandowski@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       David Rientjes <rientjes@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Frans Pop <elendil@planet.nl>, Pekka Enberg <penberg@cs.helsinki.fi>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Mohamed Abbas <mohamed.abbas@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>, linux-mm@kvack.org,
       jens.axboe@oracle.com, Tobias Oetiker <tobi@oetiker.ch>
Subject: Re: [PATCH] SLUB: Don't drop __GFP_NOFAIL completely from
	allocate_slab() (was: Re: [Bug #14265] ifconfig: page allocation
	failure. order:5,ode:0x8020 w/ e100)
Message-ID: <20091022213353.GA7137@bizet.domek.prywatny>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <COE24pZSBH.A.rP.2MTxKB@chimera> <20091021200442.GA2987@bizet.domek.prywatny> <alpine.DEB.2.00.0910211400140.20010@chino.kir.corp.google.com> <20091021212034.GB2987@bizet.domek.prywatny> <20091022102014.GL11778@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091022102014.GL11778@csn.ul.ie>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22, 2009 at 11:20:14AM +0100, Mel Gorman wrote:
> On Wed, Oct 21, 2009 at 11:20:34PM +0200, Karol Lewandowski wrote:
> > > Note: slub isn't going to be a culprit in order 5 allocation failures 
> > > since they have kmalloc passthrough to the page allocator.
> > 
> > However, it might change fragmentation somewhat I guess.  This might
> > make problem more/less visible.
> > 
> 
> Did you have CONFIG_KMEMCHECK set by any chance?

No, kmemcheck (and kmemleak) was always disabled.

It's likely that's possible to trigger allocation failures with slab,
I just haven't been successful at it.  Lack of good testcase is really
problem here -- even if I can't trigger failures I can never be sure
that these wont appear in some strange moment.

BTW I'll test your patches (from another thread) shortly.

Thanks.
