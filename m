Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbYLITwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbYLITwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 14:52:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbYLITwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 14:52:06 -0500
Received: from zcars04e.nortel.com ([47.129.242.56]:57903 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841AbYLITwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 14:52:05 -0500
Message-ID: <493ECC48.6060107@nortel.com>
Date: Tue, 09 Dec 2008 13:51:36 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: eranian@gmail.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>, Paul Mackerras <paulus@samba.org>,
       Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Subject: Re: [patch] Performance Counters for Linux, v2
References: <20081208012211.GA23106@elte.hu> <7c86c4470812082237ne58c814s7218cc663f3b49e9@mail.gmail.com> <20081209134636.GA1926@elte.hu> <493E9F3E.3020902@nortel.com> <20081209190254.GA27833@elte.hu>
In-Reply-To: <20081209190254.GA27833@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Dec 2008 19:51:39.0309 (UTC) FILETIME=[8D0FBDD0:01C95A37]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Chris Friesen <cfriesen@nortel.com> wrote:

>> Regardless of sampling method, don't you still want some way to 
>> enable/disable the various counters as close to simultaneously as 
>> possible?
> 
> If it's about counter control for the monitored task, then we sure could 
> do something about that. (apps/libraries could thus select a subset of 
> functions to profile/measure, runtime, etc.)
> 
> If it's about counter control for the profiler/debugger, i'm not sure how 
> useful that is - do you have a good usecase for it?

I'm sure that others could give more usecases, but I was thinking about 
cases like "I want to test _these_ multiple metrics simultaneously over 
_this_ specific section of code".  In a case like this, it seems 
desirable to start/stop the various performance counters as close 
together as possible, especially if the section of code being tested is 
short.

Chris
