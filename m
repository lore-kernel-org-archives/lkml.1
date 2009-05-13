Return-Path: <linux-kernel-owner+w=401wt.eu-S1760086AbZEMPFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760086AbZEMPFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 11:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754942AbZEMPFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 11:05:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53163 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587AbZEMPFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 11:05:31 -0400
Date: Wed, 13 May 2009 17:10:54 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
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
Subject: Re: [RFC PATCH v2 0/2] Saving power by cpu evacuation sched_max_capacity_pct=n
Message-ID: <20090513151054.GY19296@one.firstfloor.org>
References: <20090513130541.21440.33364.stgit@drishya.in.ibm.com> <20090513143550.GU19296@one.firstfloor.org> <1242225402.26820.23.camel@twins> <20090513144659.GV19296@one.firstfloor.org> <1242226219.26820.26.camel@twins> <20090513150100.GW19296@one.firstfloor.org> <1242226927.26820.30.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242226927.26820.30.camel@twins>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Yes that's fine and common, but you actually need to save power for this,
> > which throttling doesn't do.
> > 
> > My understanding this work is a extension of the existing
> > sched_mc_power_savings features that tries to be optionally more 
> > aggressive to keep complete package idle so that package level
> > power saving kicks in.
> > 
> > I'm just requesting that they don't call that throttling.
> 
> Ah no, this work differs in that regard in that it actually 'generates'
> idle time, instead of optimizing idle time.

That is what i meant with "more aggressive to keep complete packages idle"
above.

> 
> Therefore it takes actual cpu time away from real work, which is
> throttling. Granted, one could call it limiting or similar, but
> throttling is a correct name.

That will be always ongoing confusion with the existing established
term. 

If you really need to call it throttling use "scheduler throttling"
or something like that, but a different word would be better.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
