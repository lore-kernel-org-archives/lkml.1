Return-Path: <linux-kernel-owner+w=401wt.eu-S1760585AbZDSGe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760585AbZDSGe5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 02:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756096AbZDSGet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 02:34:49 -0400
Received: from gir.skynet.ie ([193.1.99.77]:35769 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755126AbZDSGes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 02:34:48 -0400
Date: Sun, 19 Apr 2009 07:34:44 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: David Miller <davem@davemloft.net>
cc: eric@anholt.net, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] Fixes to 2.6.30rc2
In-Reply-To: <20090418.211643.248446717.davem@davemloft.net>
Message-ID: <alpine.DEB.2.00.0904190723210.17914@skynet.skynet.ie>
References: <1240001399.11172.121.camel@gaiman.anholt.net> <20090418.015905.92829818.davem@davemloft.net> <1240086216.11172.2954.camel@gaiman.anholt.net> <20090418.211643.248446717.davem@davemloft.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On Sat, 2009-04-18 at 01:59 -0700, David Miller wrote:
> >> Eric, any plans to ever push your work through David Airlie's DRM
> >> tree?  I've been watching this for a few weeks and I'm mystified why
> >> the Intel DRM drier stuff is so special that is always goes seperate.
> >> 
> >> It's seems foolish for David to manage the infrastructure and core DRM
> >> changes, as well as those for radeon and the other drivers other than
> >> Intel, which could potentially cause merge issues and conflicts with
> >> your driver changes.
> >> 
> >> Why not do Intel DRM driver development via his tree?  I just don't
> >> get it. :-/
> > 
> > Inside of the merge window, I am going through Dave again because he
> > requested it (though delays meant that I didn't get a major cleanup in
> > this merge window).  However, Dave is also quite busy, and not stealing
> > his time every few days to pull my tree for just forwarding bugfixes on
> > seems to be a win.
> 
> So you're essentially claiming that Dave isn't being a responsive
> enough maintainer of the DRM subsystem?

I'd believe that, its never been the primary focus of my job, the thing is 
the kernel portion of the stuff we work is still quite miniscule compare 
to the time it takes to maintain all the userspace bits we also take care 
off, so I still end up with 3-4 hrs a week max to do DRM maintainer jobs, 
this works out okay when we have merge windows and I can plan for it, but 
when Eric has a lot of fixes outside of merge windows I do get in the way.

The thing is the situation really hasn't changed in the 3-4 years I've 
done this, nobody want this job, Eric could probably do it, but when the 
work balance moves over to merging AMD or nvidia code and fixes, which 
will be happening at some point soon, I'd suspect he'd have an equally bad time 
justifying the time to the managers in Intel.

So yes at the moment outside of merge windows having Eric request pulls 
direct is fine as a) he generally only has non-conflicting Intel code, b)
we don't normally have much other driver changes outside the merge window,
For the merge window I really have to make him go via me as generally we
end up with a lot more conflicts. 

Maybe I can talk Eric into co-maintainers job :)

Dave.
