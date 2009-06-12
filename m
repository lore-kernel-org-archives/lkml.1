Return-Path: <linux-kernel-owner+w=401wt.eu-S932352AbZFLDNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352AbZFLDNs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 23:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757489AbZFLDNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 23:13:41 -0400
Received: from mga14.intel.com ([143.182.124.37]:31260 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756232AbZFLDNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 23:13:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,206,1243839600"; 
   d="scan'208";a="153423116"
Subject: Re: [PATCH 3/3] ring-buffer: add design document
From: Huang Ying <ying.huang@intel.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       Christoph Hellwig <hch@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
In-Reply-To: <20090611023807.GA12407@Krystal>
References: <20090610195311.767699959@goodmis.org>
	 <20090610195525.429316815@goodmis.org>
	 <1244681467.8361.654.camel@yhuang-dev.sh.intel.com>
	 <alpine.DEB.2.00.0906102155420.30552@gandalf.stny.rr.com>
	 <1244687581.8361.703.camel@yhuang-dev.sh.intel.com>
	 <20090611023807.GA12407@Krystal>
Content-Type: text/plain
Date: Fri, 12 Jun 2009 11:13:37 +0800
Message-Id: <1244776417.5320.160.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-11 at 10:38 +0800, Mathieu Desnoyers wrote:
> > > Are these archs without cmpxchg and NMIs, a concern for you?
> > 
> > ARM has no cmpxchg until ARM v6, but it has NMI like mechanism named
> > FIQ.
> > 
> 
> One could probably adapt the cmpxchg for earlier ARM so it disables
> FIQs. Note that the current limitation is that there is only a
> fiq disable, not a fiq save/restore.

Yes. It seems that ARM is OK after FIQ save/restore issue is fixed.
Another machine with NMI but no NMI-safe cmpxchg is "real" 386. That is
very old machine, does that matter?

Best Regards,
Huang Ying


