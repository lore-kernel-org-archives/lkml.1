Return-Path: <linux-kernel-owner+w=401wt.eu-S1756714AbZEMOax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714AbZEMOax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 10:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756922AbZEMOad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 10:30:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47129 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756388AbZEMOac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 10:30:32 -0400
Date: Wed, 13 May 2009 16:35:50 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v2 0/2] Saving power by cpu evacuation sched_max_capacity_pct=n
Message-ID: <20090513143550.GU19296@one.firstfloor.org>
References: <20090513130541.21440.33364.stgit@drishya.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090513130541.21440.33364.stgit@drishya.in.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 06:41:00PM +0530, Vaidyanathan Srinivasan wrote:
> * Using sched_mc=3,4,5 to evacuate 1,2,4 cores is completely
>   non-intuitive and broken interface.  Ingo wanted to see if we can
>   model a global percentile tunable that would map to core throttling.

I have one request. CPU throttling is already a very well established
term in the x86 world, refering to thermal throttling when the CPU
overheats. This is implemented by ACPI and the CPU. It's always
a very bad thing that should be avoided at all costs.

You seem to use it for something else. Can you please use a different
term for that? Reusing the same word for something else is confusing.

Thanks,

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
