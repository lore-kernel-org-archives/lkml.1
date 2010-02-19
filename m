Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab0BSTwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 14:52:22 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46984 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab0BSTwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 14:52:21 -0500
Subject: Re: change in sched cpu_power causing regressions with SCHED_MC
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       "Ma, Ling" <ling.ma@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       "ego@in.ibm.com" <ego@in.ibm.com>,
       "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>
In-Reply-To: <1266604594.2814.37.camel@sbs-t61.sc.intel.com>
References: <1266023662.2808.118.camel@sbs-t61.sc.intel.com>
	 <1266024679.2808.153.camel@sbs-t61.sc.intel.com>
	 <1266057388.557.59599.camel@twins>
	 <1266545807.2909.46.camel@sbs-t61.sc.intel.com>
	 <1266588316.1529.370.camel@laptop>
	 <1266604594.2814.37.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Feb 2010 20:52:12 +0100
Message-ID: <1266609132.1529.756.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-19 at 10:36 -0800, Suresh Siddha wrote:
> > About the ping-pong for the statically infeasible scenario, the problem
> > with that is that we actually want to ping-pong a little [*], so we
> > might want to look at maybe doing a sd->next_pingpong jiffy measure to
> > allow some of that.
> > 
> > [*] I've seen people pretty upset about the fact that when they start 6
> > similar loads on a quad cpu the tasks will not finish in roughly similar
> > times.
> 
> I thought we were doing this (ping-ping a little) already. Unless
> something broke here also. I thought fix_small_imbalance() takes care of
> this too. 

I'm not sure we do, when I test on the patched kernel I see two distinct
groups of runtime appear (haven't checked the unpatched one, but I doubt
it'll be better).



