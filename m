Return-Path: <linux-kernel-owner+w=401wt.eu-S1760095AbZENPnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760095AbZENPnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 11:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbZENPno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 11:43:44 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:46103 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbZENPno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 11:43:44 -0400
Date: Thu, 14 May 2009 21:13:16 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v2 0/2] Saving power by cpu evacuation
	sched_max_capacity_pct=n
Message-ID: <20090514154316.GJ4853@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20090513130541.21440.33364.stgit@drishya.in.ibm.com> <20090513143550.GU19296@one.firstfloor.org> <1242225402.26820.23.camel@twins> <20090513144659.GV19296@one.firstfloor.org> <1242226219.26820.26.camel@twins> <20090513150100.GW19296@one.firstfloor.org> <1242226927.26820.30.camel@twins> <20090513151054.GY19296@one.firstfloor.org> <20090514145045.GH4853@dirshya.in.ibm.com> <20090514150632.GG10933@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090514150632.GG10933@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen <andi@firstfloor.org> [2009-05-14 17:06:32]:

> > I think 'scheduler throttling' is good so that we avoid the term 'CPU
> > throttling' or core throttling.  I had named this cpu evacuation or
> > core evacuation just to avoid confusion with hardware throttling.
> 
> Evacuation sounds good, although shouldn't it be package or 
> socket evacuation?

Lets start with 'core evacuation' since that seems to be the lowest
granularity on a threaded system.  We certainly want the framework to
provide socket/package and node evacuation on much larger systems.

--Vaidy
