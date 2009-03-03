Return-Path: <linux-kernel-owner+w=401wt.eu-S1756870AbZCCP3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870AbZCCP3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 10:29:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbZCCP2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 10:28:49 -0500
Received: from casper.infradead.org ([85.118.1.10]:41821 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200AbZCCP2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 10:28:48 -0500
Subject: Re: [PATCH v2 0/3] sched: Extend sched_mc/smt_power_savings
 framework
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: svaidy@linux.vnet.ibm.com
Cc: Gautham R Shenoy <ego@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, efault@gmx.de,
       andi@firstfloor.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090303152504.GH4708@dirshya.in.ibm.com>
References: <20090303114648.605.86920.stgit@sofia.in.ibm.com>
	 <1236082917.5330.4195.camel@laptop>
	 <20090303152504.GH4708@dirshya.in.ibm.com>
Content-Type: text/plain
Date: Tue, 03 Mar 2009 16:28:30 +0100
Message-Id: <1236094110.5330.4733.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-03 at 20:55 +0530, Vaidyanathan Srinivasan wrote:
>  
> > It would be good to mention something about how power usage is measured.
> 
> Power usage is measured by computing the energy consumed over the
> benchmark duration and then finding average power by dividing
> energy/time.  The relative power consumption is for the entire system.

Is this measured using an external (indepedent) power monitor, or
looking at system internal power usage stats?

Have you compared these two methods, if so, do they give comparable
results?

> > Furthermore, do we really need those separate mc/smt power savings
> > settings? -- It appears to me we ought to consolidate some of that and
> > provide a single knob to save power.
> 
> Yes, having one sched_power_savings will definitely help.  However,
> mapping the various combination of settings to a single knob that will
> provide consistent behavior across workloads and system configuration
> is a challenge.

Would it be an option to provide a single knob for users and have some
fine grained feature set for developing/debugging, much like we have
sched_features?

