Return-Path: <linux-kernel-owner+w=401wt.eu-S1755868AbZFEOob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbZFEOob (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 10:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbZFEOoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 10:44:23 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:44863 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbZFEOoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 10:44:22 -0400
Message-ID: <4A292F3F.8010402@nortel.com>
Date: Fri, 05 Jun 2009 08:44:15 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: vatsa@in.ibm.com
CC: Paul Menage <menage@google.com>, bharata@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>, Avi Kivity <avi@redhat.com>,
       kvm@vger.kernel.org,
       Linux Containers <containers@lists.linux-foundation.org>,
       Herbert Poetzl <herbert@13thfloor.at>
Subject: Re: [RFC] CPU hard limits
References: <20090604053649.GA3701@in.ibm.com> <6599ad830906050153i1afd104fqe70f681317349142@mail.gmail.com> <20090605113217.GA20786@in.ibm.com>
In-Reply-To: <20090605113217.GA20786@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Jun 2009 14:44:18.0672 (UTC) FILETIME=[1B1D5700:01C9E5EC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Srivatsa Vaddagiri wrote:
> On Fri, Jun 05, 2009 at 01:53:15AM -0700, Paul Menage wrote:
>> This claim (and the subsequent long thread it generated on how limits
>> can provide guarantees) confused me a bit.
>>
>> Why do we need limits to provide guarantees when we can already
>> provide guarantees via shares?
> 
> I think the interval over which we need guarantee matters here. Shares
> can generally provide guaranteed share of resource over longer (sometimes
> minutes) intervals. For high-priority bursty workloads, the latency in 
> achieving guaranteed resource usage matters. By having hard-limits, we are 
> "reserving" (potentially idle) slots where the high-priority group can run and 
> claim its guaranteed share almost immediately.

Why do you need to "reserve" it though?  By definition, if it's
high-priority then it should be able to interrupt the currently running
task.

Chris


