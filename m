Return-Path: <linux-kernel-owner+w=401wt.eu-S1752344AbYJDF1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344AbYJDF1j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 01:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751059AbYJDF1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 01:27:31 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:54874 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbYJDF1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 01:27:30 -0400
Message-ID: <48E6FEB9.8070603@nortel.com>
Date: Fri, 03 Oct 2008 23:27:21 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, Linux kernel <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [bug report] sched: stop_machine() usage causes load balancer
 to misbehave
References: <48E55FE5.40108@nortel.com> <alpine.DEB.1.10.0810022001250.26504@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0810022001250.26504@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Oct 2008 05:27:26.0291 (UTC) FILETIME=[E2FD9A30:01C925E1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Thu, 2 Oct 2008, Chris Friesen wrote:
> 
> 
>>I mentioned before that ftrace (specifically the ftraced daemon) seems to be
>>interfering with the load balancer.  After some experimenting, it appears that
>>any regular calls to stop_machine() will end up confusing the load balancer.
>>
>>As an experiment, I disabled ftraced (which would normally result in correct
>>load balancing) but added a single kernel thread which simply runs the
>>following loop, where "chrisd2" is a dummy function.
> 
> 
> 
> Chris,
> 
> Thanks for looking into this. I don't have an answer for your question, 
> but I'll work harder to get the MCOUNT_REC working in PPC.
> 
> Does this happen with x86 too?

Unfortunately I don't have an x86 box handy for testing...I could 
probably get some time on a lab machine next week.

Chris
