Return-Path: <linux-kernel-owner+w=401wt.eu-S1759598AbYA2Lex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759598AbYA2Lex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 06:34:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755601AbYA2Len
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 06:34:43 -0500
Received: from relay2.sgi.com ([192.48.171.30]:59033 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754278AbYA2Lem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 06:34:42 -0500
Date: Tue, 29 Jan 2008 05:34:36 -0600
From: Paul Jackson <pj@sgi.com>
To: Paul Jackson <pj@sgi.com>
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, mingo@elte.hu,
       vatsa@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com,
       nickpiggin@yahoo.com.au, ebiederm@xmission.com,
       akpm@linux-foundation.org, sgrubb@redhat.com, rostedt@goodmis.org,
       ghaskins@novell.com, dmitry.adamushko@gmail.com, tong.n.li@intel.com,
       tglx@linutronix.de, menage@google.com, rientjes@google.com
Subject: Re: scheduler scalability - cgroups, cpusets and load-balancing
Message-Id: <20080129053436.e9522a30.pj@sgi.com>
In-Reply-To: <20080129053005.bc7a11d7.pj@sgi.com>
References: <1201600428.28547.87.camel@lappy>
	<1201604243.28547.101.camel@lappy>
	<20080129053005.bc7a11d7.pj@sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul, talking to himself:
> At that point, sched domains are rebuilt, including providing a
> sched domain that just contains the CPUs in that realtime cpuset, and
> normal scheduler load balancing ceases on the CPUs in that realtime
> cpuset.

Oops - correction - at that point sched domains are rebuilt, and
the CPUs in that realtime cpuset are not included in any sched
domain at all.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
