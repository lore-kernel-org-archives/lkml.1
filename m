Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371AbZD2Dai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbZD2Dai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 23:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbZD2Da3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 23:30:29 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59680 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbZD2Da2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 23:30:28 -0400
Date: Wed, 29 Apr 2009 09:00:20 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       seto.hidetoshi@jp.fujitsu.com
Subject: Re: [PATCH] cpuacct: VIRT_CPU_ACCOUNTING don't prevent percpu
	cputime count
Message-ID: <20090429033020.GB3408@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20090428165203.EBD5.A69D9226@jp.fujitsu.com> <20090428103701.GE3825@in.ibm.com> <20090429110629.4B05.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429110629.4B05.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 11:31:14AM +0900, KOSAKI Motohiro wrote:
> > > > > > BTW, did you observe any real problem with the percpu counter spinlock ?
> > > > > 
> > > > > No.
> > > > > I review percpu_counter() caller recently and it seems stragen usage.
> > > > > 
> > > > 
> > > > I should have phrased the question better ...
> > > > 
> > > > So have you found any performance degradation with any benchmarks/workloads
> > > > on archs which define VIRT_CPU_ACCOUNTING due to percpu_counter spinlock
> > > > being taken on every tick ? If the answer is no, don't you think we could
> > > > wait before making the kind of change you are proposing ?
> > > 
> > > maybe, I don't understand your point.
> > 
> > My point is, let us not make this change if it is not a real problem that
> > has been observed on archs which define VIRT_CPU_ACCOUNTING.
> 
> It's nice joke. but not constructive.

I was only asking you if you have seen any real life problem with this
and you said no. In that context, if I re-read my above point, I think
I should have a pretty good sense of humour to consider it as joke :)

Regards,
Bharata.
