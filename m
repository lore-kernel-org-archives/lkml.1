Return-Path: <linux-kernel-owner+w=401wt.eu-S1422856AbXDXRoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422856AbXDXRoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 13:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422857AbXDXRoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 13:44:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:20508 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422856AbXDXRoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 13:44:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,448,1170662400"; 
   d="scan'208"; a="218801254:sNHT16594536"
Date: Tue, 24 Apr 2007 10:42:27 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       William Lee Irwin III <wli@holomorphy.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [patch] CFS scheduler, v3
Message-ID: <20070424174226.GE5475@linux-os.sc.intel.com>
References: <20070418175017.GA5250@elte.hu> <20070418212645.GU2986@holomorphy.com> <Pine.LNX.4.64.0704201223280.21417@schroedinger.engr.sgi.com> <20070420192906.GB2986@holomorphy.com> <Pine.LNX.4.64.0704201231250.21514@schroedinger.engr.sgi.com> <20070420193856.GC2986@holomorphy.com> <Pine.LNX.4.64.0704201243280.21514@schroedinger.engr.sgi.com> <20070420200322.GD2986@holomorphy.com> <20070420201101.GC5475@linux-os.sc.intel.com> <Pine.LNX.4.64.0704241039110.8341@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704241039110.8341@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2007 at 10:39:48AM -0700, Christoph Lameter wrote:
> On Fri, 20 Apr 2007, Siddha, Suresh B wrote:
> 
> > > Last I checked it was workload-dependent, but there were things that
> > > hammer it. I mostly know of the remote wakeup issue, but there could
> > > be other things besides wakeups that do it, too.
> > 
> > remote wakeup was the main issue and the 0.5% improvement was seen
> > on a two node platform. Aligning it reduces the number of remote
> > cachelines that needs to be touched as part of this wakeup.
> 
> .5% is usually in the noise ratio. Are you consistently seeing an 
> improvement or is that sporadic?

No. This is consistent. I am waiting for the perf data on a much much bigger
NUMA box.

Anyhow, this is a straight forward optimization and needs to be done. Do you
have any specific concerns?

thanks,
suresh
