Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757827Ab0BMSup (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 13:50:45 -0500
Received: from mga11.intel.com ([192.55.52.93]:27258 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757690Ab0BMSuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 13:50:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,468,1262592000"; 
   d="scan'208";a="540542249"
Subject: Re: change in sched cpu_power causing regressions with SCHED_MC
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, "Ma, Ling" <ling.ma@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       "ego@in.ibm.com" <ego@in.ibm.com>
In-Reply-To: <20100213183735.GD5882@dirshya.in.ibm.com>
References: <1266023662.2808.118.camel@sbs-t61.sc.intel.com>
	 <1266024679.2808.153.camel@sbs-t61.sc.intel.com>
	 <1266057388.557.59599.camel@twins> <1266057724.557.59610.camel@twins>
	 <20100213183735.GD5882@dirshya.in.ibm.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Sat, 13 Feb 2010 10:49:40 -0800
Message-Id: <1266086980.2677.52.camel@sbs-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-02-13 at 10:37 -0800, Vaidyanathan Srinivasan wrote:
> * Peter Zijlstra <peterz@infradead.org> [2010-02-13 11:42:04]:
> > BTW, do you think its possible to automate such test cases and put them
> > in a test-suite?
> 
> Linux Test Project (LTP) has some test cases for sched_mc/smt
> balancing. 

It is very unfortunate that neither this nor Linux-kernel performance
tests that Yanmin and co tracks has caught these problems much before.
Ling Ma's focused tests/analysis for something else started showing
these basic issues.

> They can be improved and generalized to include all basic
> scheduler task placement checks.  

Probably it is best if we can include the very basic checks/tests in the
kernel itself. More focused and extensive tests can be done outside the
kernel.

thanks,
suresh

