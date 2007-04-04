Return-Path: <linux-kernel-owner+w=401wt.eu-S2992833AbXDDKl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992833AbXDDKl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 06:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992839AbXDDKl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 06:41:29 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49274 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992833AbXDDKl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 06:41:28 -0400
Date: Wed, 4 Apr 2007 16:11:23 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>, akpm@linux-foundation.org,
       paulmck@us.ibm.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, dipankar@in.ibm.com, dino@in.ibm.com,
       masami.hiramatsu.pt@hitachi.com
Subject: Re: [RFC] Cpu-hotplug: Using the Process Freezer (try2)
Message-ID: <20070404104123.GA14825@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070402053457.GA9076@in.ibm.com> <20070402061612.GA7072@elte.hu> <20070402092818.GE2456@in.ibm.com> <20070402111828.GA14771@elte.hu> <20070402124200.GA9566@in.ibm.com> <20070402185607.GA2081@elte.hu> <20070403125619.GA32444@in.ibm.com> <20070403141516.GB14900@in.ibm.com> <20070404031502.GA23591@in.ibm.com> <20070404100431.GB19120@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070404100431.GB19120@elte.hu>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2007 at 12:04:31PM +0200, Ingo Molnar wrote:
> 
> yeah, i think you are right - and the TASK_UNINTERRUPTIBLE thing is not 
> only quite complex, it also breaks the symmetry of freezer use 
> (sw-suspend obviously cannot freeze uninterruptible tasks). We should 
> watch whether the current latency of freezing is good enough in 
> practice.

Ok. Do you have any specific tests in mind which I can run and post the
numbers? 

As of now, I've been stressing the system with (kernbench + ondemand governor)
and timing the hotplug operation. 

> 
> 	Ingo

Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
