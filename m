Return-Path: <linux-kernel-owner+w=401wt.eu-S1760157AbZEMOg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760157AbZEMOg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 10:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757791AbZEMOgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 10:36:46 -0400
Received: from viefep12-int.chello.at ([62.179.121.32]:46834 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757703AbZEMOgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 10:36:45 -0400
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
In-Reply-To: <20090513143550.GU19296@one.firstfloor.org>
References: <20090513130541.21440.33364.stgit@drishya.in.ibm.com>
	 <20090513143550.GU19296@one.firstfloor.org>
Content-Type: text/plain
Date: Wed, 13 May 2009 16:36:42 +0200
Message-Id: <1242225402.26820.23.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-13 at 16:35 +0200, Andi Kleen wrote:
> On Wed, May 13, 2009 at 06:41:00PM +0530, Vaidyanathan Srinivasan wrote:
> > * Using sched_mc=3,4,5 to evacuate 1,2,4 cores is completely
> >   non-intuitive and broken interface.  Ingo wanted to see if we can
> >   model a global percentile tunable that would map to core throttling.
> 
> I have one request. CPU throttling is already a very well established
> term in the x86 world, refering to thermal throttling when the CPU
> overheats. This is implemented by ACPI and the CPU. It's always
> a very bad thing that should be avoided at all costs.

Its about avoiding that.

