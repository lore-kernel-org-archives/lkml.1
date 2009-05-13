Return-Path: <linux-kernel-owner+w=401wt.eu-S1759555AbZEMNnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759555AbZEMNnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 09:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbZEMNnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 09:43:06 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:54927 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbZEMNnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 09:43:04 -0400
Date: Wed, 13 May 2009 19:12:51 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v2 0/2] Saving power by cpu
	evacuationsched_max_capacity_pct=n
Message-ID: <20090513134251.GF4853@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20090513130541.21440.33364.stgit@drishya.in.ibm.com> <1242220497.26820.21.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1242220497.26820.21.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2009-05-13 15:14:57]:

> On Wed, 2009-05-13 at 18:41 +0530, Vaidyanathan Srinivasan wrote:
> 
> > * Peter Zijlstra wanted more justifications for throttling at the core
> >   level.  Throttling may be a resource management problem rather than
> >   scheduler/load balancer
> 
> No, I mandate that it be thermal management. Any other reason and you've
> got a NAK.

Hi Peter,

Yes, I understand your objection.  Your want throttling to be done for
the purpose of thermal management only.  The primary purpose for
throttling should be thermal management (power savings may be
a side-effect)

What I meant in the above comment was that the implementation for
throttling could be solved using resource management framework,
cpuset/cgroup rather than biasing the load balancer to avoid work on
a particular core.

I am open to ideas for a clean and easy framework for core level
throttling.

Thanks,
Vaidy


