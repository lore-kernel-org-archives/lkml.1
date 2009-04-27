Return-Path: <linux-kernel-owner+w=401wt.eu-S1756627AbZD0FzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbZD0FzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 01:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753753AbZD0FzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 01:55:04 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:37816 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbZD0FzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 01:55:02 -0400
Date: Mon, 27 Apr 2009 11:24:51 +0530
From: Dipankar Sarma <dipankar@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v1 0/3] Saving power by cpu evacuation using
	sched_mc=n
Message-ID: <20090427055451.GF13342@in.ibm.com>
Reply-To: dipankar@in.ibm.com
References: <20090426204029.17495.46609.stgit@drishya.in.ibm.com> <20090427035216.GD10087@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090427035216.GD10087@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 05:52:16AM +0200, Ingo Molnar wrote:
> 
> Regarding the values for 2...5 - is the AvgPower column time 
> normalized or workload normalized?
> 
> If it's time normalized then it appears there's no power win here at 
> all: we'd be better off by throttling the workload directly (by 
> injecting sleeps or something like that), right?

Energy savings with this will depend on the workload running. We have 
seen transactional workloads where taking off a few cores has almost 
no impact on throughput or response time.

Thanks
Dipankar
