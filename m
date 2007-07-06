Return-Path: <linux-kernel-owner+w=401wt.eu-S932129AbXGFVED@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129AbXGFVED (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 17:04:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760067AbXGFVDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 17:03:54 -0400
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:53801 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759907AbXGFVDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 17:03:53 -0400
Date: Fri, 6 Jul 2007 17:03:51 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Li, Tong N" <tong.n.li@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 10/10] Scheduler profiling - Use immediate values
Message-ID: <20070706210351.GA13491@Krystal>
References: <20070706200325.GD8174@one.firstfloor.org> <5FD5754DDBA0B1499B5A0B4BB5419485015CC9E1@fmsmsx411.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <5FD5754DDBA0B1499B5A0B4BB5419485015CC9E1@fmsmsx411.amr.corp.intel.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:03:27 up 5 days, 15:46,  4 users,  load average: 0.03, 0.20, 0.24
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Li, Tong N (tong.n.li@intel.com) wrote:
> > I found that memory latency is difficult to measure in modern x86
> > CPUs because they have very clever prefetchers that can often
> > outwit benchmarks.
> 
> A pointer-chasing program that accesses a random sequence of addresses
> usually can produce a good estimate on memory latency. Also, prefetching
> can be turned off in BIOS or by modifying the MSRs.
>  
> > Another trap on P4 is that RDTSC is actually quite slow and
> synchronizes
> > the CPU; that can add large measurement errors.
> > 
> > -Andi
> 
> The cost can be amortized if the portion of memory accesses is long
> enough.
> 
>   tong
> 

That's what I am currently doing.. the results are coming in a few
moments... :)


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
