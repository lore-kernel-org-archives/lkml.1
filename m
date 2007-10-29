Return-Path: <linux-kernel-owner+w=401wt.eu-S1754197AbXJ2UHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbXJ2UHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 16:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbXJ2UH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 16:07:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbXJ2UH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 16:07:26 -0400
Date: Mon, 29 Oct 2007 16:06:56 -0400
From: Dave Jones <davej@redhat.com>
To: Andi Kleen <ak@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Martin Ebourne <fedora@ebourne.me.uk>,
       Zou Nan hai <nanhai.zou@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.23 boot failures on x86-64.
Message-ID: <20071029200656.GG1650@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Andi Kleen <ak@suse.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Martin Ebourne <fedora@ebourne.me.uk>,
	Zou Nan hai <nanhai.zou@intel.com>,
	Suresh Siddha <suresh.b.siddha@intel.com>, stable@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20071029175014.GH7793@redhat.com> <200710291918.43869.ak@suse.de> <20071029184747.GB1650@redhat.com> <200710292003.09317.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710292003.09317.ak@suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 08:03:09PM +0100, Andi Kleen wrote:
 > On Monday 29 October 2007 19:47:47 Dave Jones wrote:
 > > On Mon, Oct 29, 2007 at 07:18:43PM +0100, Andi Kleen wrote:
 > >  > On Monday 29 October 2007 18:50:14 Dave Jones wrote:
 > >  > > We've had a number of people reporting that their x86-64s stopped booting
 > >  > > when they moved to 2.6.23.  It rebooted just after discovering the AGP bridge
 > >  > > as a result of the IOMMU init.
 > >  > 
 > >  > It's probably the usual "nobody tests sparsemem at all" issue.
 > > 
 > > We've been using SPARSEMEM in Fedora for a *long* time.
 > > So long in fact, I forget why we moved away from DISCONTIGMEM, so there's
 > > a significant number of users using that configuration for some time.
 > 
 > Supposedly you wanted a slower kernel that needs more memory? 

Actually if what you say is true, the Kconfig entry for sparsemem
could use changing as it suggests the opposite...

	This option provides some potential
          performance benefits, along with decreased code complexity,
          but it is newer, and more experimental.

I'm still unclear why exactly we enabled it.  The other comment
in the Kconfig..

	This will be the only option for some systems, including
          memory hotplug systems.  This is normal.

Sounds unlikely to be the reason, but maybe.
Maybe benchmarking at some point in history showed sparsemem
actually beat out discontigmem.  I'm at a loss to explain it
thanks to a particularly unhelpful changelog entry I wrote
at the time.

	Dave

-- 
http://www.codemonkey.org.uk
