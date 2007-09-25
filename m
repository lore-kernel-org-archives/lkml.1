Return-Path: <linux-kernel-owner+w=401wt.eu-S1759809AbXIYFgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759809AbXIYFgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 01:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbXIYFgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 01:36:40 -0400
Received: from canuck.infradead.org ([209.217.80.40]:35341 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408AbXIYFgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 01:36:39 -0400
Date: Mon, 24 Sep 2007 22:35:47 -0700
From: Greg KH <greg@kroah.com>
To: Satyam Sharma <satyam@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1
Message-ID: <20070925053547.GA6211@kroah.com>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <46EF96CC.1080807@linux.vnet.ibm.com> <20070918022739.f25c2846.akpm@linux-foundation.org> <alpine.LFD.0.999.0709181504030.21091@enigma.security.iitk.ac.in> <20070918191740.GC11083@kroah.com> <alpine.LFD.0.999.0709221433160.28693@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0709221433160.28693@enigma.security.iitk.ac.in>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2007 at 02:51:54PM +0530, Satyam Sharma wrote:
> Hi Greg,
> 
> 
> On Tue, 18 Sep 2007, Greg KH wrote:
> > 
> > On Tue, Sep 18, 2007 at 03:04:48PM +0530, Satyam Sharma wrote:
> > > 
> > > But wait ... isn't that a statically-allocated kobject, which were
> > > supposed to be "naughty" in the first place?
> > 
> > Yes it is, if you want to dynamically create it, please do.
> 
> Sorry for being late to reply, but do you still want such a patch (i.e.
> convert static to dynamic allocation)?

Yes, I'll gladly take such patches.

> I read elsewhere on this thread that you'd merge Kamalesh's patch and
> fix it up to also use kobject_name() yourself. But it's a small/trivial
> driver, so I think just converting it to dynamic allocation right now
> itself (when we've noticed it already) is probably better (?)

Sure that would be great to have.

> [ BTW I don't see the fix in your git trees or quilt queue. So I'll
>   make a patch on top of 2.6.23-rc6-mm1 itself. ]

I'm behind in updating my patch queue, sorry, other things came up :(

thanks,

greg k-h
