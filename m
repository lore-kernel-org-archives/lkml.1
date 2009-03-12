Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbZCLE3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbZCLE3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 00:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750821AbZCLE3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 00:29:31 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:60296 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbZCLE3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 00:29:30 -0400
Date: Thu, 12 Mar 2009 09:59:51 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH] cpuacct: per-cgroup utime/stime statistics - v1
Message-ID: <20090312042951.GA3344@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20090310124208.GC3902@in.ibm.com> <20090311093812.298a0b21.kamezawa.hiroyu@jp.fujitsu.com> <20090311153434.GB16769@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090311153434.GB16769@balbir.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 09:04:34PM +0530, Balbir Singh wrote:
> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-03-11 09:38:12]:
> 
> > BTW, I'm not sure but don't we need special handling if
> > CONFIG_VIRT_CPU_ACCOUNTING=y ?
> 
> Good point. Bharata, with CONFIG_VIRT_CPU_ACCOUNTING, utime and stime
> is accounted for within the architecture.

True, but as I replied to Kamezawa in the other thread, these
architectures are still dependent on generic implementations of
account_{system,user}_time() which feed to per-process and system-wide
accounting. And this is where we have hooks for per-cgroup accounting.
So I don't see why we need to handle these archs specially. Do I miss
something ?

Regards,
Bharata.
