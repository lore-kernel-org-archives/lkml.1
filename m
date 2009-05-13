Return-Path: <linux-kernel-owner+w=401wt.eu-S1760681AbZEMOui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760681AbZEMOui (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 10:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758358AbZEMOuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 10:50:25 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:46487 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756645AbZEMOuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 10:50:24 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [RFC PATCH v2 0/2] Saving power by cpu evacuation
 sched_max_capacity_pct=n
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
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
In-Reply-To: <20090513144659.GV19296@one.firstfloor.org>
References: <20090513130541.21440.33364.stgit@drishya.in.ibm.com>
	 <20090513143550.GU19296@one.firstfloor.org>
	 <1242225402.26820.23.camel@twins>
	 <20090513144659.GV19296@one.firstfloor.org>
Content-Type: text/plain
Date: Wed, 13 May 2009 16:50:19 +0200
Message-Id: <1242226219.26820.26.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-13 at 16:46 +0200, Andi Kleen wrote:
> On Wed, May 13, 2009 at 04:36:42PM +0200, Peter Zijlstra wrote:
> > On Wed, 2009-05-13 at 16:35 +0200, Andi Kleen wrote:
> > > On Wed, May 13, 2009 at 06:41:00PM +0530, Vaidyanathan Srinivasan wrote:
> > > > * Using sched_mc=3,4,5 to evacuate 1,2,4 cores is completely
> > > >   non-intuitive and broken interface.  Ingo wanted to see if we can
> > > >   model a global percentile tunable that would map to core throttling.
> > > 
> > > I have one request. CPU throttling is already a very well established
> > > term in the x86 world, refering to thermal throttling when the CPU
> > > overheats. This is implemented by ACPI and the CPU. It's always
> > > a very bad thing that should be avoided at all costs.
> > 
> > Its about avoiding that.
> 
> Hmm? Can you explain please? CPU throttling should only happen when your
> cooling system is broken in some way.
> 
> It's not a power saving feature, just a "don't make CPU melt" feature.

>From what I've been told its popular to over-commit the cooling capacity
in a rack, so that a number of servers can run at full thermal capacity
but not all.

I've also been told that hardware sucks at throttling, therefore people
want to fix the OS so as to limit the thermal capacity and avoid the
hardware throttle from kicking in, whilst still not exceeding the rack
capacity or similar nonsense.



