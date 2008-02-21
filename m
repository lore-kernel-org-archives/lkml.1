Return-Path: <linux-kernel-owner+w=401wt.eu-S1760425AbYBUJtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760425AbYBUJtb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 04:49:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752556AbYBUJtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 04:49:21 -0500
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:60988 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbYBUJtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 04:49:20 -0500
Message-ID: <47BD4812.9040407@linux.vnet.ibm.com>
Date: Thu, 21 Feb 2008 15:14:50 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: Make yield_task_fair more efficient
References: <20080221053321.GA26918@balbir.in.ibm.com> <20080221060427.GA9159@elte.hu> <47BD1F75.5030506@linux.vnet.ibm.com> <20080221070733.GA13694@elte.hu> <47BD2A99.3010608@linux.vnet.ibm.com> <1203583439.6243.119.camel@lappy> <47BD3B56.3090404@linux.vnet.ibm.com> <20080221090430.GA20055@elte.hu> <47BD44FF.7070104@linux.vnet.ibm.com> <20080221094217.GA24162@elte.hu>
In-Reply-To: <20080221094217.GA24162@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 

You did not answer some of my earlier questions.

>> I have an alternate approach in mind (that I need to find time for), 
>> threaded-rbtrees. Walking the tree is really efficient, specially 
>> finding successor of a node.
> 
> sure, feel free to experiment with those details.
> 
> But if you want to improve Java workloads then you should probably start 
> by converting them to futexes instead of sched_yield(), that will 
> probably give far more performance than micro-optimizing the 
> sys_sched_yield() codepath. (especially when it happens at the expense 
> of other workloads, which is not acceptable for mainline) You can 
> rebuild your JVM easily and re-test with its locking fixed, right?

No.. I don't want to optimize the JVM or rebuild it. I don't have access to any
JVM code either. I wanted to do the threaded rb-trees for the case where we use
spend time finding the successor using rb_next() (walking the tree).

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
