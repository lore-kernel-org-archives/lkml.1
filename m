Return-Path: <linux-kernel-owner+w=401wt.eu-S1753414AbZIBVJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbZIBVJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 17:09:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbZIBVJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 17:09:12 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:47013 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbZIBVJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 17:09:11 -0400
Message-ID: <4A9EDEF6.2000002@us.ibm.com>
Date: Wed, 02 Sep 2009 14:09:10 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-rt-users <linux-rt-users@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       "lkml, " <linux-kernel@vger.kernel.org>
Subject: Re: RFC: methods of sched event tracing and my assumptions
References: <4A9C1371.6050101@us.ibm.com> <4A9C5600.8060007@us.ibm.com>
In-Reply-To: <4A9C5600.8060007@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Darren Hart wrote:
> 
> After some gentle resistance to CVS and non-single-file testcases, I 
> prepared a standalone prio-wake-min.c.  It ran to completion on linus 
> with slightly fewer wakeups than the LTP version (I removed a number of 
> things that weren't strictly necessary for this specific exercise), png 
> attached.  It's hung part way through the scripts on rt though.  I'll be 
> looking into that, but in case you prefer to look at this version, it is 
> available here:
> 
> http://dvhart.com/darren/linux/prio-wake-min.c

I have just now updated this test to fix a possible race when using a 
requeue PI enabled glibc (likely a bug in glibc) which also reduces the 
tests runtime from 1s to about 15ms (yeah, the sleep loops were rather 
stupid in the original version :/).

Thanks,

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
