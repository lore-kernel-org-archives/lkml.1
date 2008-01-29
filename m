Return-Path: <linux-kernel-owner+w=401wt.eu-S1765196AbYA2QER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765196AbYA2QER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 11:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759162AbYA2QD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 11:03:59 -0500
Received: from sinclair.provo.novell.com ([137.65.248.137]:28033 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759082AbYA2QD6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 11:03:58 -0500
Message-Id: <479F06A4.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 29 Jan 2008 08:57:40 -0700
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, "Paul Jackson" <pj@sgi.com>
Cc: <mingo@elte.hu>, <dmitry.adamushko@gmail.com>, <rostedt@goodmis.org>,
       <menage@google.com>, <rientjes@google.com>, <tong.n.li@intel.com>,
       <tglx@linutronix.de>, <akpm@linux-foundation.org>,
       <dhaval@linux.vnet.ibm.com>, <vatsa@linux.vnet.ibm.com>,
       <sgrubb@redhat.com>, <linux-kernel@vger.kernel.org>,
       <ebiederm@xmission.com>, <nickpiggin@yahoo.com.au>
Subject: Re: scheduler scalability - cgroups, cpusets and
	load-balancing
References: <1201600428.28547.87.camel@lappy>
 <1201604243.28547.101.camel@lappy> <20080129053005.bc7a11d7.pj@sgi.com>
 <1201607401.28547.124.camel@lappy> <20080129061202.95b66041.pj@sgi.com>
In-Reply-To: <20080129061202.95b66041.pj@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Tue, Jan 29, 2008 at  7:12 AM, in message
<20080129061202.95b66041.pj@sgi.com>, Paul Jackson <pj@sgi.com> wrote: 
> Peter, replying to Paul:
>> >  3) you turn off sched_load_balance in that realtime cpuset.
>> 
>> Ah, I don't think 3 is needed. Quite to the contrary, there is quite a
>> large body of research work covering the scheduling of (hard and soft)
>> realtime tasks on multiple cpus.
> 
> Well, the way it's coded now, the user space code needs to do (3),
> because that's the only way they get the system to have anything
> other than one big fat sched domain covering the all the CPUs in
> the system.

What about exclusive cpusets?  Don't they create a new sched-domain or did I misunderstand there?

-Greg

> 
> Actually ... I need a picture of a bunny with a pancake hat here,
> as I have no idea what you just said ;).




