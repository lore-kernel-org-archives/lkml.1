Return-Path: <linux-kernel-owner+w=401wt.eu-S1755986AbZCDLFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbZCDLFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 06:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750810AbZCDLFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 06:05:10 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:59090 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbZCDLFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 06:05:09 -0500
Date: Wed, 4 Mar 2009 16:36:43 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Gautham R Shenoy <ego@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, efault@gmx.de,
       andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] sched: Extend sched_mc/smt_power_savings
	framework
Message-ID: <20090304110643.GM4708@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20090303114648.605.86920.stgit@sofia.in.ibm.com> <1236082917.5330.4195.camel@laptop> <20090303152504.GH4708@dirshya.in.ibm.com> <1236094110.5330.4733.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1236094110.5330.4733.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2009-03-03 16:28:30]:

> On Tue, 2009-03-03 at 20:55 +0530, Vaidyanathan Srinivasan wrote:
> >  
> > > It would be good to mention something about how power usage is measured.
> > 
> > Power usage is measured by computing the energy consumed over the
> > benchmark duration and then finding average power by dividing
> > energy/time.  The relative power consumption is for the entire system.
> 
> Is this measured using an external (indepedent) power monitor, or
> looking at system internal power usage stats?
> 
> Have you compared these two methods, if so, do they give comparable
> results?

Since we are doing relative power comparison, the absolute power value
and the method would not affect the results.

Your question is more relevant for SPECPower type of benchmarks where
the score depends on the average power consumed and accuracy or method
of measurement can affect the score.
 
> > > Furthermore, do we really need those separate mc/smt power savings
> > > settings? -- It appears to me we ought to consolidate some of that and
> > > provide a single knob to save power.
> > 
> > Yes, having one sched_power_savings will definitely help.  However,
> > mapping the various combination of settings to a single knob that will
> > provide consistent behavior across workloads and system configuration
> > is a challenge.
> 
> Would it be an option to provide a single knob for users and have some
> fine grained feature set for developing/debugging, much like we have
> sched_features?

Yes, that will be very good.  Let me explore if sched_features can
include the power saving attributes while the sched_power_savings can
be a simple and coarse control for end-users.

--Vaidy

