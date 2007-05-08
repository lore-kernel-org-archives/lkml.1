Return-Path: <linux-kernel-owner+w=401wt.eu-S967699AbXEHDIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967699AbXEHDIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 23:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967645AbXEHDIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 23:08:04 -0400
Received: from ozlabs.org ([203.10.76.45]:42940 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967631AbXEHDIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 23:08:01 -0400
Subject: Re: [BUG] cpu-hotplug: Can't offline the CPU with naughty
	realtime	processes
From: Rusty Russell <rusty@rustcorp.com.au>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Nathan Lynch <nathanl@austin.ibm.com>,
       Joel Schopp <jschopp@austin.ibm.com>, Ashok Raj <ashok.raj@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <877irkrq8a.wl%takeuchi_satoru@jp.fujitsu.com>
References: <87bqgxrlky.wl%takeuchi_satoru@jp.fujitsu.com>
	 <1178545373.28438.7.camel@localhost.localdomain>
	 <877irkrq8a.wl%takeuchi_satoru@jp.fujitsu.com>
Content-Type: text/plain
Date: Tue, 08 May 2007 13:02:25 +1000
Message-Id: <1178593345.28438.29.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-08 at 11:41 +0900, Satoru Takeuchi wrote:
> At Mon, 07 May 2007 23:42:53 +1000,
> Rusty Russell wrote:
> > I look forward to your patch!
> > Rusty.
> 
> Thanks, I'll do. Maybe this work will take several days including test.

Excellent.

> BTW, how should I manage rt process having max priority as Gautham said?
> He said that it's OK unless such kernel thread exists. However, currently
> MAX_USER_RT_PRIORITY is equal to MAX_RT_PRIO, so user process also be able
> to cause this problem. Is Srivatsa's idea 2 acceptable? Or just apply
> "Shouldn't abuse highest rt proority" rule?

We used to be able to create kernel threads higher than any userspace
priority.  If this is no longer true, I think that's OK: equal priority
still means we'll get scheduled, right?

Cheers,
Rusty.


