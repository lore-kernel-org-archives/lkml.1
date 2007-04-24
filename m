Return-Path: <linux-kernel-owner+w=401wt.eu-S1422822AbXDXRjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422822AbXDXRjv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 13:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422838AbXDXRjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 13:39:51 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:36957 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422822AbXDXRju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 13:39:50 -0400
Date: Tue, 24 Apr 2007 10:39:48 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
cc: William Lee Irwin III <wli@holomorphy.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [patch] CFS scheduler, v3
In-Reply-To: <20070420201101.GC5475@linux-os.sc.intel.com>
Message-ID: <Pine.LNX.4.64.0704241039110.8341@schroedinger.engr.sgi.com>
References: <20070418175017.GA5250@elte.hu> <20070418212645.GU2986@holomorphy.com>
 <Pine.LNX.4.64.0704201223280.21417@schroedinger.engr.sgi.com>
 <20070420192906.GB2986@holomorphy.com> <Pine.LNX.4.64.0704201231250.21514@schroedinger.engr.sgi.com>
 <20070420193856.GC2986@holomorphy.com> <Pine.LNX.4.64.0704201243280.21514@schroedinger.engr.sgi.com>
 <20070420200322.GD2986@holomorphy.com> <20070420201101.GC5475@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007, Siddha, Suresh B wrote:

> > Last I checked it was workload-dependent, but there were things that
> > hammer it. I mostly know of the remote wakeup issue, but there could
> > be other things besides wakeups that do it, too.
> 
> remote wakeup was the main issue and the 0.5% improvement was seen
> on a two node platform. Aligning it reduces the number of remote
> cachelines that needs to be touched as part of this wakeup.

.5% is usually in the noise ratio. Are you consistently seeing an 
improvement or is that sporadic?

