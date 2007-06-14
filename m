Return-Path: <linux-kernel-owner+w=401wt.eu-S1755230AbXFNRjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbXFNRjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 13:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbXFNRji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 13:39:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42829 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751443AbXFNRjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 13:39:37 -0400
Date: Thu, 14 Jun 2007 10:38:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org, dcbw@redhat.com,
       hs4233@mail.mn-solutions.de, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: libertas (private) ioctls vs. nl80211
Message-Id: <20070614103836.23b07a72.akpm@linux-foundation.org>
In-Reply-To: <20070614170901.GA13384@infradead.org>
References: <1181757483.29767.99.camel@johannes.berg>
	<20070614170901.GA13384@infradead.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 14 Jun 2007 18:09:01 +0100 Christoph Hellwig <hch@infradead.org> wrote:
> Independent of any nl80211 status the private libertas ioctls have to
> go.  Not only don't we want private ioctls for mesh networking but rather
> have it as driver-independent interface, but the actual libertas interface
> is the worst possible choice.  It uses the absolutely broken iwpriv interface
> instead of plain ioctls, and has a cmpletely confusing forest of sub ioctls.
> 
> I strongly recommend ripping out all the ioctls for 2.6.22 and waiting for
> a proper interface to appear.

If we're going to change the interface in the future (and it sounds like
we should) then yes, we should strenuously avoid releasing the current interface
in 2.6.22.

>  The olpc people can patch the ioctls back
> in for their use, but we should not put in interface like this into the
> upstream kernel.  All NIC vendors get pushed back badly when they try
> to put in less crappy ioctls, there is no reason to make a exception for
> libtertas just because it's used by a project that some of the involved
> maintainers like a lot.

I suspect that the probability of your proposal succeeding would be increased
if you could prepare a patch...
