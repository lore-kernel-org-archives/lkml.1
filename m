Return-Path: <linux-kernel-owner+w=401wt.eu-S1765798AbZFQNxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765798AbZFQNxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 09:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbZFQNxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 09:53:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:36152 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796AbZFQNxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 09:53:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,236,1243839600"; 
   d="scan'208";a="423091453"
Subject: Re: [RFD PATCH 0/4] cpu: Bulk CPU Hotplug support.
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Balbir Singh <balbir@in.ibm.com>, Rusty Russel <rusty@rustcorp.com.au>,
       Paul E McKenney <paulmck@us.ibm.com>, Nathan Lynch <ntl@pobox.com>,
       Ingo Molnar <mingo@elte.hu>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Shoahua Li <shaohua.li@linux.com>
In-Reply-To: <20090616053431.30891.18682.stgit@sofia.in.ibm.com>
References: <20090616053431.30891.18682.stgit@sofia.in.ibm.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 17 Jun 2009 06:50:28 -0700
Message-Id: <1245246628.27006.10556.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-15 at 22:38 -0700, Gautham R Shenoy wrote:
> So, of the accounted time, a major chunk of time is consumed by
> cpuset_track_online_cpus() while handling CPU_DEAD and CPU_ONLINE
> notifications.
> 
>         11.320205 ms: cpuset_track_online_cpus      : CPU_DEAD
>         12.767882 ms: cpuset_track_online_cpus      : CPU_ONLINE
> 
> cpuset_trace_online_cpus() among other things performs the task of rebuilding
> the sched_domains for every online CPU in the system.

Are the above numbers with CONFIG_SCHED_DEBUG turned on/off?

thanks,
suresh

