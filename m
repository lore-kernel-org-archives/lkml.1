Return-Path: <linux-kernel-owner+w=401wt.eu-S1756749AbYJIWfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbYJIWfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 18:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753858AbYJIWfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 18:35:16 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:41409 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623AbYJIWfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 18:35:14 -0400
Message-ID: <48EE871A.2030302@nortel.com>
Date: Thu, 09 Oct 2008 16:35:06 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Building a tracing userspace tool in the kernel tree
References: <20081009191626.GA29344@Krystal> <1223590513.7382.45.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1223590513.7382.45.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Oct 2008 22:35:09.0628 (UTC) FILETIME=[4944DFC0:01C92A5F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2008-10-09 at 15:16 -0400, Mathieu Desnoyers wrote:
> 
>>Hi Sam,
>>
>>At the kernel summit, people seemed to be interested to have the basic
>>userspace tools required to extract and pretty-print a trace available
>>within the kernel tree. Therefore, what I am trying to do is something
>>along the lines of
>>
>>ltt/usr/
>>ltt/usr/tracectl/    (control tracing)
>>ltt/usr/tracesplice/ (splice buffers to disk)
>>ltt/usr/tracecat/    (merge sort and format the binary buffers into
>>                      human-readable text)
> 
> 
> I'd rather have you provide that interface from the kernel much like
> ftrace does. So we can do:
> 
> # cat /debug/tracing/lttng/trace
> 

Do we really want to reserve memory in the kernel to store all the data? 
  Assuming not, do we really want to have to deal with filesystem 
namespaces in the kernel when interpreting which file we want to log to?

Chris
