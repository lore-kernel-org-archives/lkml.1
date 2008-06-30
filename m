Return-Path: <linux-kernel-owner+w=401wt.eu-S1758944AbYF3OVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944AbYF3OVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 10:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbYF3OVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 10:21:16 -0400
Received: from brmea-mail-2.Sun.COM ([192.18.98.43]:61029 "EHLO
	brmea-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbYF3OVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 10:21:16 -0400
Date: Mon, 30 Jun 2008 10:18:35 -0400
From: David Collier-Brown <davecb@sun.com>
Subject: Re: [RFC v1] Tunable sched_mc_power_savings=n
In-reply-to: <20080630043327.GA6276@dirshya.in.ibm.com>
To: svaidy@linux.vnet.ibm.com
Cc: Tim Connors <tconnors@astro.swin.edu.au>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <peterz@infradead.org>, dipankar@in.ibm.com,
       balbir@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>
Reply-to: davecb@sun.com
Message-id: <4868EB3B.1030608@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=us-ascii
Content-transfer-encoding: 7BIT
X-Accept-Language: en-us, en
References: <4863AF57.3040005@linux.vnet.ibm.com>
 <4863DB29.1020304@firstfloor.org> <20080626185254.GA12416@dirshya.in.ibm.com>
 <4863F93C.9040102@firstfloor.org> <20080626210025.GB26167@in.ibm.com>
 <48640C04.9020600@firstfloor.org>
 <1214516584.12265.10.camel@twins.programming.kicks-ass.net>
 <48641A7D.6080204@firstfloor.org> <12146282628495-twc@hexane.ssi.swin.edu.au>
 <4867CE52.8040204@sun.com> <20080630043327.GA6276@dirshya.in.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; SunOS sun4u; en-US; rv:1.7) Gecko/20041221
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vaidyanathan Srinivasan wrote:
> I am trying to find answer to the question: Should we have the power
> saving tunable as 'nice' value per process or system wide?
> 
> How should we interpret the POWER parameter in a datacenter with power
> constraint as mentioned in this thread?  Or in a simple case of AC vs
> battery in a laptop.

I agree with Tim re setting them all independently, and suggest that 
they're all really per-process values: setting power saving 
system-wide is meaningful, but so are individual settings.
There is therefor an argument for making them subsets of
a higher-level nice program.

Mind you, the order in which one *implements* the capability,
and whether one does powernice first and adds it to nice later
is your call!  I have no idea of how hard what I suggested is (;-))

--dave
-- 
David Collier-Brown            | Always do right. This will gratify
Sun Microsystems, Toronto      | some people and astonish the rest
davecb@sun.com                 |                      -- Mark Twain
(905) 943-1983, cell: (647) 833-9377, (800) 555-9786 x56583
bridge: (877) 385-4099 code: 506 9191#
