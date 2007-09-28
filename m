Return-Path: <linux-kernel-owner+w=401wt.eu-S1758434AbXI1Nia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434AbXI1Nia (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 09:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754624AbXI1NiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 09:38:20 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:4698 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbXI1NiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 09:38:19 -0400
Date: Fri, 28 Sep 2007 09:28:47 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       tomas.winkler@intel.com
Subject: Re: iwl4965 and driver merging policy
Message-ID: <20070928132847.GA4989@tuxdriver.com>
References: <1190943567.6158.50.camel@pasglop> <20070928023055.GI7991@tuxdriver.com> <1190949323.6158.66.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190949323.6158.66.camel@pasglop>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 01:15:23PM +1000, Benjamin Herrenschmidt wrote:
> On Thu, 2007-09-27 at 22:30 -0400, John W. Linville wrote:

> > I'm sure there are still some wireless developers that are less than
> > happy about merging it now.

> Out of curiosity, what's the main source of opposition ? Since it's
> being shipped by distro or built out of tree by most users -anyway-, I
> think it's pretty clear that we'd be better off having it merged asap
> rather than trying to figure out what random version was included by
> users/distros and try to support it, in addition to wider exposure & all
> the yadada of being upstream in the first place.

There have been a lot of spats about how functionality has been
partitioned between the driver and the firmware, issues with how the
driver tries to do things that either ought to be in mac80211 or not
done at all, and some random complaints about ugliness like '#include
"../../../net/mac80211/blah.h"', etc.  There is still plenty of work
to be done on this driver, but as you point out we are better-off
with it in the kernel than with it out.

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
