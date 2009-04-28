Return-Path: <linux-kernel-owner+w=401wt.eu-S1760897AbZD1HvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760897AbZD1HvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 03:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758893AbZD1HvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 03:51:13 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:54922 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbZD1HvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 03:51:12 -0400
Date: Tue, 28 Apr 2009 13:20:55 +0530
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
Message-ID: <20090428075055.GD3825@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20090428153611.EBC6.A69D9226@jp.fujitsu.com> <20090428073151.GC3825@in.ibm.com> <20090428163509.EBCF.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428163509.EBCF.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 04:38:51PM +0900, KOSAKI Motohiro wrote:
> > On Tue, Apr 28, 2009 at 03:53:32PM +0900, KOSAKI Motohiro wrote:
> 
> > BTW, did you observe any real problem with the percpu counter spinlock ?
> 
> No.
> I review percpu_counter() caller recently and it seems stragen usage.
> 

I should have phrased the question better ...

So have you found any performance degradation with any benchmarks/workloads
on archs which define VIRT_CPU_ACCOUNTING due to percpu_counter spinlock
being taken on every tick ? If the answer is no, don't you think we could
wait before making the kind of change you are proposing ?

Regards,
Bharata.
