Return-Path: <linux-kernel-owner+w=401wt.eu-S1757892AbYF2SFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892AbYF2SFq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 14:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755747AbYF2SFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 14:05:37 -0400
Received: from brmea-mail-4.Sun.COM ([192.18.98.36]:49879 "EHLO
	brmea-mail-4.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096AbYF2SFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 14:05:36 -0400
Date: Sun, 29 Jun 2008 14:02:58 -0400
From: David Collier-Brown <davecb@sun.com>
Subject: Re: [RFC v1] Tunable sched_mc_power_savings=n
In-reply-to: <12146282628495-twc@hexane.ssi.swin.edu.au>
To: Tim Connors <tconnors@astro.swin.edu.au>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
       dipankar@in.ibm.com, balbir@linux.vnet.ibm.com,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>
Reply-to: davecb@sun.com
Message-id: <4867CE52.8040204@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=us-ascii
Content-transfer-encoding: 7BIT
X-Accept-Language: en-us, en
References: <20080625191100.GI21892@dirshya.in.ibm.com>
 <87k5gcqpbm.fsf@basil.nowhere.org> <4863AF57.3040005@linux.vnet.ibm.com>
 <4863DB29.1020304@firstfloor.org> <20080626185254.GA12416@dirshya.in.ibm.com>
 <4863F93C.9040102@firstfloor.org> <20080626210025.GB26167@in.ibm.com>
 <48640C04.9020600@firstfloor.org>
 <1214516584.12265.10.camel@twins.programming.kicks-ass.net>
 <48641A7D.6080204@firstfloor.org> <12146282628495-twc@hexane.ssi.swin.edu.au>
User-Agent: Mozilla/5.0 (X11; U; SunOS sun4u; en-US; rv:1.7) Gecko/20041221
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> said on Fri, 27 Jun 2008 00:38:53 +0200:
>>Peter Zijlstra wrote:
>>>>And your workload manager could just nice processes. It should probably
>>>>do that anyways to tell ondemand you don't need full frequency.
>>>
>>>Except that I want my nice 19 distcc processes to utilize as much cpu as
>>>possible, but just not bother any other stuff I might be doing...
>>
>>They already won't do that if you run ondemand and cpufreq. It won't
>>crank up the frequency for niced processes.


Tim Connors then wrote:
> Shouldn't there be a powernice, just as there is an ionice and a nice?
Hmmn, how about:

User Commands                                             nice(1)

NAME
     nice - invoke a command with an altered  priority

SYNOPSIS
     /usr/bin/nice [-increment | -n increment]  [-s|-i|-e|-p] command  [argu-
     ment...]

DESCRIPTION
     The nice utility invokes command, requesting that it be  run
     with a different  priority.  If -i is specified, the priority
     of (disk) I/O is modified. If -e is specified, ethernet (or
     other networking) priority is changed. If -p is specified, power
     usage priority is changed and if  -s is specified, or none 
     of -1, -e or -p  is specified, then system scheduling priority
     is modified...

--dave
-- 
David Collier-Brown            | Always do right. This will gratify
Sun Microsystems, Toronto      | some people and astonish the rest
davecb@sun.com                 |                      -- Mark Twain
(905) 943-1983, cell: (647) 833-9377, (800) 555-9786 x56583
bridge: (877) 385-4099 code: 506 9191#
