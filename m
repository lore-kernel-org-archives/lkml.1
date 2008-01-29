Return-Path: <linux-kernel-owner+w=401wt.eu-S1756281AbYA2MM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281AbYA2MM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 07:12:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751273AbYA2MMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 07:12:16 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43998 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750727AbYA2MMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 07:12:15 -0500
Date: Tue, 29 Jan 2008 06:12:02 -0600
From: Paul Jackson <pj@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, vatsa@linux.vnet.ibm.com,
       dhaval@linux.vnet.ibm.com, nickpiggin@yahoo.com.au,
       ebiederm@xmission.com, akpm@linux-foundation.org, sgrubb@redhat.com,
       rostedt@goodmis.org, ghaskins@novell.com, dmitry.adamushko@gmail.com,
       tong.n.li@intel.com, tglx@linutronix.de, menage@google.com,
       rientjes@google.com
Subject: Re: scheduler scalability - cgroups, cpusets and load-balancing
Message-Id: <20080129061202.95b66041.pj@sgi.com>
In-Reply-To: <1201607401.28547.124.camel@lappy>
References: <1201600428.28547.87.camel@lappy>
	<1201604243.28547.101.camel@lappy>
	<20080129053005.bc7a11d7.pj@sgi.com>
	<1201607401.28547.124.camel@lappy>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter, replying to Paul:
> >  3) you turn off sched_load_balance in that realtime cpuset.
> 
> Ah, I don't think 3 is needed. Quite to the contrary, there is quite a
> large body of research work covering the scheduling of (hard and soft)
> realtime tasks on multiple cpus.

Well, the way it's coded now, the user space code needs to do (3),
because that's the only way they get the system to have anything
other than one big fat sched domain covering the all the CPUs in
the system.

Actually ... I need a picture of a bunny with a pancake hat here,
as I have no idea what you just said ;).

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
