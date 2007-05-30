Return-Path: <linux-kernel-owner+w=401wt.eu-S1752516AbXE3Epv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbXE3Epv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 00:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbXE3EpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 00:45:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:26865 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969AbXE3EpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 00:45:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,590,1170662400"; 
   d="scan'208";a="233435704"
Date: Tue, 29 May 2007 21:42:01 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Con Kolivas <kernel@kolivas.org>, Christoph Lameter <clameter@sgi.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] CFS scheduler, -v12
Message-ID: <20070530044201.GF3693@linux-os.sc.intel.com>
References: <46523081.6050007@bigpond.net.au> <465275EF.8060905@bigpond.net.au> <4652DC03.60801@bigpond.net.au> <4655423E.6000202@bigpond.net.au> <20070524164538.GA13301@linux-os.sc.intel.com> <46561E67.3030207@bigpond.net.au> <20070529204557.GB3693@linux-os.sc.intel.com> <465CBD35.2000109@bigpond.net.au> <20070530005052.GE3693@linux-os.sc.intel.com> <465CDEEA.9060507@bigpond.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465CDEEA.9060507@bigpond.net.au>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 07:18:18PM -0700, Peter Williams wrote:
> Siddha, Suresh B wrote:
> > I can try 32-bit kernel to check.
> 
> Don't bother.  I just checked 2.6.22-rc3 and the problem is not present
> which means something between rc2 and rc3 has fixed the problem.  I hate
> it when problems (appear to) fix themselves as it usually means they're
> just hiding.
> 
> I didn't see any patches between rc2 and rc3 that were likely to have
> fixed this (but doesn't mean there wasn't one).  I'm wondering whether I
> should do a git bisect to see if I can find where it got fixed?
> 
> Could you see if you can reproduce it on 2.6.22-rc2?

No. Just tried 2.6.22-rc2 64-bit version at runlevel 3 on my remote
system at office. 15 attempts didn't show the issue.

Sure that nothing changed in your test setup?

More experiments tomorrow morning..

thanks,
suresh
