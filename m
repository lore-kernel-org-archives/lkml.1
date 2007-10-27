Return-Path: <linux-kernel-owner+w=401wt.eu-S1756833AbXJ0Rra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833AbXJ0Rra (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 13:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757150AbXJ0RrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 13:47:18 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46416 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757120AbXJ0RrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 13:47:17 -0400
Date: Sat, 27 Oct 2007 10:47:16 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Paul Jackson <pj@sgi.com>
cc: rientjes@google.com, Lee.Schermerhorn@hp.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
In-Reply-To: <20071027013656.4ffadb87.pj@sgi.com>
Message-ID: <Pine.LNX.4.64.0710271044410.524@schroedinger.engr.sgi.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
 <20071025185506.8c373aa8.pj@sgi.com> <alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com>
 <1193412644.5032.13.camel@localhost> <alpine.DEB.0.9999.0710261145400.11674@chino.kir.corp.google.com>
 <20071026120037.7b95a136.pj@sgi.com> <alpine.DEB.0.9999.0710261344180.6249@chino.kir.corp.google.com>
 <1193433239.5032.95.camel@localhost> <alpine.DEB.0.9999.0710261416160.11594@chino.kir.corp.google.com>
 <1193434278.5032.106.camel@localhost> <alpine.DEB.0.9999.0710261436140.16966@chino.kir.corp.google.com>
 <20071026180713.aeedfac2.pj@sgi.com> <Pine.LNX.4.64.0710261823210.30012@schroedinger.engr.sgi.com>
 <20071026194144.6042316a.pj@sgi.com> <Pine.LNX.4.64.0710261949360.30293@schroedinger.engr.sgi.com>
 <20071026221624.cec512da.pj@sgi.com> <Pine.LNX.4.64.0710262303410.30785@schroedinger.engr.sgi.com>
 <20071027013656.4ffadb87.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Oct 2007, Paul Jackson wrote:

> > Tough. The API needs to remain stable. 
> 
> Good - that I understand.  Your position is clear now.
> 
> You have chosen (1) above, which keeps Choice A as the default.

There can be different defaults for the user space API via libnuma that 
are indepdent from the kernel API which needs to remain stable. The kernel 
API can be extended but not changed.
 
> > Hmmm.. The alternative is to add new set/get mempolicy functions.
> 
> Other alternatives include a per-system, per-cpuset or per-process
> flag, in addition to the per-system call flag you suggested earlier
> (MPOL_MF_RELATIVE), or whatever you mean by "new set/get mempolicy
> functions" ... could you elaborate on that one?

None of those sound appealing. Multiple processes may run in one cpuset. 
Some of those may be linked to older libnumas and therefore depend on old 
behavior.
