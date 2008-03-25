Return-Path: <linux-kernel-owner+w=401wt.eu-S1759693AbYCYTRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759693AbYCYTRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 15:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757955AbYCYTRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 15:17:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:60003 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754686AbYCYTRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 15:17:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,553,1199692800"; 
   d="scan'208";a="539822452"
Date: Tue, 25 Mar 2008 12:08:52 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       kernel list <linux-kernel@vger.kernel.org>, suresh.b.siddha@intel.com
Subject: Re: [PATCH] x86: pat cpu feature bit setting for known cpus
Message-ID: <20080325190851.GC30998@linux-os.sc.intel.com>
References: <200803242324.35357.yhlu.kernel@gmail.com> <47E9003B.5010002@zytor.com> <86802c440803251103taf4c8f2mb674c3d17f3c2345@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440803251103taf4c8f2mb674c3d17f3c2345@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 11:03:37AM -0700, Yinghai Lu wrote:
> On Tue, Mar 25, 2008 at 6:38 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> > Yinghai Lu wrote:
> >  > [PATCH] x86: pat cpu feature bit setting for known cpus
> >  >
> >  > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> >
> >  OK, note previous question: what is the motivation for having this as a
> >  whitelist (as opposed to a blacklist)?
> 
> Venkatesh could tell?

Main reason for white-list at this point is not to be side-tracked by
real or potential erratas on older CPUs. Focussing on getting the support for
this feature on current and future CPUs. If older CPUs have survived all these
days without this feature, they should be doing OK.

Other reason being the amount of testing we get on those older systems. I mean,
any regression on some specific CPU is hard to find unless it is being tested
or someone audits all the errata documents to prepare the blacklist (Unless
we want to have big blacklist which is just !current_whitelist). We do not
have any self test that can detect and report any problematic CPUs that we
can add to the blacklist.

Having said that, if there is a need for this on older CPUs, I am OK with
having this as a blacklist.
 
Thanks,
Venki

