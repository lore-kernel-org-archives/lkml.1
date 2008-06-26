Return-Path: <linux-kernel-owner+w=401wt.eu-S1761436AbYFZSJC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761436AbYFZSJC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 14:09:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755494AbYFZSIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 14:08:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55353 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935AbYFZSIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 14:08:47 -0400
Message-ID: <4863DB29.1020304@firstfloor.org>
Date: Thu, 26 Jun 2008 20:08:41 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: Linux Kernel <linux-kernel@vger.kernel.org>, svaidy@linux.vnet.ibm.com,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dipankar Sarma <dipankar@in.ibm.com>, Vatsa <vatsa@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [RFC v1] Tunable sched_mc_power_savings=n
References: <20080625191100.GI21892@dirshya.in.ibm.com> <87k5gcqpbm.fsf@basil.nowhere.org> <4863AF57.3040005@linux.vnet.ibm.com>
In-Reply-To: <4863AF57.3040005@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> A user could be an application and certain applications can predict their
> workload.

So you expect the applications to run suid root and change a sysctl?
And what happens when two applications run that do that and they have differing
requirements? Will they fight over the sysctl?

> For example, a database, a file indexer, etc can predict their workload.


A file indexer should run with a high nice level and low priority would ideally always
prefer power saving. But it doesn't currently. Perhaps it should?

> 
> Policies are best known in user land and the best controlled from there.
> Consider a case where the end user might select a performance based policy or a
> policy to aggressively save power (during peak tariff times). With

How many users are going to do that? Seems like a unrealistic case to me.

-Andi
