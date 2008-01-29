Return-Path: <linux-kernel-owner+w=401wt.eu-S1762312AbYA2U5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762312AbYA2U5F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 15:57:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbYA2U4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 15:56:54 -0500
Received: from relay1.sgi.com ([192.48.171.29]:47002 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750987AbYA2U4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 15:56:54 -0500
Date: Tue, 29 Jan 2008 14:56:47 -0600
From: Paul Jackson <pj@sgi.com>
To: "Gregory Haskins" <ghaskins@novell.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, dmitry.adamushko@gmail.com,
       rostedt@goodmis.org, menage@google.com, rientjes@google.com,
       tong.n.li@intel.com, tglx@linutronix.de, akpm@linux-foundation.org,
       dhaval@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com, sgrubb@redhat.com,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com,
       nickpiggin@yahoo.com.au
Subject: Re: scheduler scalability - cgroups, cpusets and load-balancing
Message-Id: <20080129145647.579b7d53.pj@sgi.com>
In-Reply-To: <479F4631.BA47.005A.0@novell.com>
References: <1201600428.28547.87.camel@lappy>
	<1201604243.28547.101.camel@lappy>
	<20080129053005.bc7a11d7.pj@sgi.com>
	<479F01AF.BA47.005A.0@novell.com>
	<20080129102836.be614579.pj@sgi.com>
	<479F1118.BA47.005A.0@novell.com>
	<20080129133700.7f1ab444.pj@sgi.com>
	<479F4631.BA47.005A.0@novell.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory wrote:
> By moving it into the root_domain structure, there is now an instance
> per (um, for lack of a better, more up to date word) "exclusive"
> cpuset.   That way, disparate cpusets will not bother each other with
> overload notifications, etc.

So the root_domain structure is meant to be the portions of the
sched_domains that are shared across all CPUs in that sched_domain ?

And the word 'cpuset', occurring in the above quote twice, should
be 'sched_domain', right ?  Surely these aren't cpuset's ;).

And 'exclusive cpuset' really means 'non-overlapping sched_domain' ?

Or am I still confused ?

I would like to get our concepts clear, and terms consistent.  That's
important for those others who would try to understand this.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
