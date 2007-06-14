Return-Path: <linux-kernel-owner+w=401wt.eu-S1758580AbXFNWTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580AbXFNWTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 18:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757963AbXFNWTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 18:19:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753891AbXFNWTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 18:19:13 -0400
Subject: Re: libertas (private) ioctls vs. nl80211
From: Dan Williams <dcbw@redhat.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, johannes@sipsolutions.net,
       linux-wireless@vger.kernel.org, hs4233@mail.mn-solutions.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <46718D81.9080402@garzik.org>
References: <1181757483.29767.99.camel@johannes.berg>
	 <20070614170901.GA13384@infradead.org>
	 <20070614103836.23b07a72.akpm@linux-foundation.org>
	 <20070614181307.GA16856@infradead.org>
	 <alpine.LFD.0.98.0706141121080.14121@woody.linux-foundation.org>
	 <46718D81.9080402@garzik.org>
Content-Type: text/plain
Date: Thu, 14 Jun 2007 18:22:35 -0400
Message-Id: <1181859755.23567.3.camel@xo-28-0B-88.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-14 at 14:48 -0400, Jeff Garzik wrote:
> Linus Torvalds wrote:
> > 
> > On Thu, 14 Jun 2007, Christoph Hellwig wrote:
> >>> I suspect that the probability of your proposal succeeding would be increased
> >>> if you could prepare a patch...
> >> Here we go:
> > 
> > I don't mind ripping them out, but it makes sense only if people are 
> > actually signed up to implementing this on a higher layer. As such, I'd 
> > need to get a sign-off from somebody actually involved in wireless mesh 
> > stuff etc.
> 
> Correct me if I'm wrong, linux-wireless, but AFAIK there has never been 
> a single post or line of code written for a generic wireless _mesh_ 
> interface.
> 
> My general sentiment is -- remove the pointless and iw-duplicated 
> ioctls, but leave the mesh ones that won't see generic counterparts for 
> years.

And that's what I did in the last pull you got from John; all pointless
and duplicated ioctls were removed.  The only ones left are mesh
tweakables, an LED GPIO control ioctl, and a regulatory region/domain
thing.  I agree the interface is somewhat ugly (like the
char-128/char-128 ones that return information from the mesh forwarding
table), and I also agree that we need to move to using netlink for this
sort of stuff in the future.  There are _no_ ioctls that duplicate WEXT
functionality.

Dan


