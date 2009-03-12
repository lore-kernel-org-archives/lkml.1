Return-Path: <linux-kernel-owner+w=401wt.eu-S1755973AbZCLEfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbZCLEfi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 00:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbZCLEf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 00:35:29 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:44275 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbZCLEf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 00:35:28 -0400
Date: Thu, 12 Mar 2009 10:05:18 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH] cpuacct: per-cgroup utime/stime statistics - v1
Message-ID: <20090312043518.GH23583@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090310124208.GC3902@in.ibm.com> <20090311093812.298a0b21.kamezawa.hiroyu@jp.fujitsu.com> <20090311153434.GB16769@balbir.in.ibm.com> <20090312042951.GA3344@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090312042951.GA3344@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Bharata B Rao <bharata@linux.vnet.ibm.com> [2009-03-12 09:59:51]:

> On Wed, Mar 11, 2009 at 09:04:34PM +0530, Balbir Singh wrote:
> > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-03-11 09:38:12]:
> > 
> > > BTW, I'm not sure but don't we need special handling if
> > > CONFIG_VIRT_CPU_ACCOUNTING=y ?
> > 
> > Good point. Bharata, with CONFIG_VIRT_CPU_ACCOUNTING, utime and stime
> > is accounted for within the architecture.
> 
> True, but as I replied to Kamezawa in the other thread, these
> architectures are still dependent on generic implementations of
> account_{system,user}_time() which feed to per-process and system-wide
> accounting. And this is where we have hooks for per-cgroup accounting.

Fair enough...

> So I don't see why we need to handle these archs specially. Do I miss
> something ?

May be we should cc the patch to linux-arch as well to make sure
we handled all architectures correctly.

-- 
	Balbir
