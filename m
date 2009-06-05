Return-Path: <linux-kernel-owner+w=401wt.eu-S1753248AbZFELce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbZFELce (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 07:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbZFELc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 07:32:26 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54829 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088AbZFELcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 07:32:25 -0400
Date: Fri, 5 Jun 2009 17:02:17 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Paul Menage <menage@google.com>
Cc: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>, Avi Kivity <avi@redhat.com>,
       kvm@vger.kernel.org,
       Linux Containers <containers@lists.linux-foundation.org>,
       Herbert Poetzl <herbert@13thfloor.at>
Subject: Re: [RFC] CPU hard limits
Message-ID: <20090605113217.GA20786@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20090604053649.GA3701@in.ibm.com> <6599ad830906050153i1afd104fqe70f681317349142@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830906050153i1afd104fqe70f681317349142@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 01:53:15AM -0700, Paul Menage wrote:
> This claim (and the subsequent long thread it generated on how limits
> can provide guarantees) confused me a bit.
> 
> Why do we need limits to provide guarantees when we can already
> provide guarantees via shares?

I think the interval over which we need guarantee matters here. Shares
can generally provide guaranteed share of resource over longer (sometimes
minutes) intervals. For high-priority bursty workloads, the latency in 
achieving guaranteed resource usage matters. By having hard-limits, we are 
"reserving" (potentially idle) slots where the high-priority group can run and 
claim its guaranteed share almost immediately.

- vatsa
