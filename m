Return-Path: <linux-kernel-owner+w=401wt.eu-S1753419AbYIKAH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbYIKAH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 20:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbYIKAHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 20:07:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:49082 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313AbYIKAHs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 20:07:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,375,1217833200"; 
   d="scan'208";a="438062927"
From: "Ma, Chinang" <chinang.ma@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
       "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>,
       "Chilukuri, Harita" <harita.chilukuri@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 10 Sep 2008 17:07:32 -0700
Subject: RE: 2.6.27-rc5 OLTP performance regression
Thread-Topic: 2.6.27-rc5 OLTP performance regression
Thread-Index: AckTbJNRtFcyH+QFRlCY2aaqKI5uqAANOdUg
Message-ID: <BC02C49EEB98354DBA7F5DD76F2A9E8002FE7540F9@azsmsx501.amr.corp.intel.com>
References: <BC02C49EEB98354DBA7F5DD76F2A9E8002FE60F751@azsmsx501.amr.corp.intel.com>
 <1220896833.18239.141.camel@twins.programming.kicks-ass.net>
 <1220897052.18239.147.camel@twins.programming.kicks-ass.net>
 <BC02C49EEB98354DBA7F5DD76F2A9E8002FE6E71C7@azsmsx501.amr.corp.intel.com>
 <20080910122622.GG14757@elte.hu>
 <BC02C49EEB98354DBA7F5DD76F2A9E8002FE6E7B62@azsmsx501.amr.corp.intel.com>
 <20080910173442.GB31942@elte.hu>
In-Reply-To: <20080910173442.GB31942@elte.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When set to 10 ms the regression is about 0.4%. We get most of the 2%.

Chinang
-----Original Message-----
From: Ingo Molnar [mailto:mingo@elte.hu]
Sent: Wednesday, September 10, 2008 10:35 AM
To: Ma, Chinang
Cc: Peter Zijlstra; Srivatsa Vaddagiri; Mike Galbraith; Gregory Haskins; Steven Rostedt; Nick Piggin; Siddha, Suresh B; Wilcox, Matthew R; Tripathi, Sharad C; Chilukuri, Harita; linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc5 OLTP performance regression


* Ma, Chinang <chinang.ma@intel.com> wrote:

> I increased the /proc/sys/kernel/sched_shares_ratelimit from 1
> millisecond to one second to reduce the frequency of shares update.
> That was okay for OLTP workload. As Peter mentioned, a larger value
> will reduce the accuracy of SMP fairness for group scheduler and the
> ratelimit and using a larger default value may not be good for general
> case.

does 10 msecs already get you most of the 2%? 1000 millisecond sounds
very (and probably unacceptable) coarse.

        Ingo
