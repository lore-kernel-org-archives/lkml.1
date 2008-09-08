Return-Path: <linux-kernel-owner+w=401wt.eu-S1754219AbYIHN4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbYIHN4o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 09:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752452AbYIHN4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 09:56:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38949 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbYIHN4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 09:56:35 -0400
Subject: Re: [RFC PATCH v2 0/7] Tunable sched_mc_power_savings=n
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: svaidy@linux.vnet.ibm.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>
In-Reply-To: <20080908134843.GA4053@dirshya.in.ibm.com>
References: <20080908131334.3221.61302.stgit@drishya.in.ibm.com>
	 <1220880346.12278.17.camel@twins.programming.kicks-ass.net>
	 <20080908134843.GA4053@dirshya.in.ibm.com>
Content-Type: text/plain
Date: Mon, 08 Sep 2008 15:56:09 +0200
Message-Id: <1220882169.12278.23.camel@twins.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.91 (2.23.91-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-08 at 19:18 +0530, Vaidyanathan Srinivasan wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> [2008-09-08 15:25:46]:
> 
> > May I again ask to first clean up the current power saving code before
> > stacking more on top of it?
> 
> :) I understand that you have asked for two things with respect to the
> current power save balance code:
> 
> 1. Detailed documentation

Preferably in the form of in-code comments and code structure, this
Documentation/* stuff always gets lost on me.

> 2. Cleanup the group_min and group_leader stuff in
>    find_busiest_group()
> 
> Did I get the requirements correct?

That would be much appreciated. 

But I also prefer to get rid of that power savings tweak in
cpu_coregroup_map(). 

But above all, readable code ;-)

find_busiest_group() is the stuff of nightmares.

