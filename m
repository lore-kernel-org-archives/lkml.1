Return-Path: <linux-kernel-owner+w=401wt.eu-S1757248AbXI1DQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248AbXI1DQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 23:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754651AbXI1DQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 23:16:03 -0400
Received: from gate.crashing.org ([63.228.1.57]:59498 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575AbXI1DQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 23:16:01 -0400
Subject: Re: iwl4965 and driver merging policy
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       tomas.winkler@intel.com
In-Reply-To: <20070928023055.GI7991@tuxdriver.com>
References: <1190943567.6158.50.camel@pasglop>
	 <20070928023055.GI7991@tuxdriver.com>
Content-Type: text/plain
Date: Fri, 28 Sep 2007 13:15:23 +1000
Message-Id: <1190949323.6158.66.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-09-27 at 22:30 -0400, John W. Linville wrote:
> > It doesn't seem to pull any depedency nor affect any other external
> > piece of code unless I'm missing something, so it's a perfect
> example of
> > what we've been discussing back then: there is just no point not
> merging
> > it at any time right ? :-)
> 
> It is queued for 2.6.24.  I'm not even sure it was originally posted
> in time for the 2.6.23 merge window, but even if it was there was
> a lot of opposition to merging it until fairly recently.  In fact,
> I'm sure there are still some wireless developers that are less than
> happy about merging it now.
> 
> Anyway, coming soon to a kernel near you...

Allright, thanks. I was mostly trying to figure out where we standed
with this whole idea that driver additions were not necessarily
constrainted by the merge window (which I think is fair to do) and this
looked like a good example to pick since it affects my new laptop :-)

Out of curiosity, what's the main source of opposition ? Since it's
being shipped by distro or built out of tree by most users -anyway-, I
think it's pretty clear that we'd be better off having it merged asap
rather than trying to figure out what random version was included by
users/distros and try to support it, in addition to wider exposure & all
the yadada of being upstream in the first place.

Ben.

