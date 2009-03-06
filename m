Return-Path: <linux-kernel-owner+w=401wt.eu-S1757346AbZCFXBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbZCFXBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 18:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754424AbZCFXBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 18:01:19 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:52252 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435AbZCFXBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 18:01:18 -0500
Message-ID: <49B1AB3A.2050303@us.ibm.com>
Date: Fri, 06 Mar 2009 15:01:14 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Sitsofe Wheeler <sitsofe@yahoo.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "lkml, " <linux-kernel@vger.kernel.org>
Subject: Re: Dynamically determine if kernel includes CFS Scheduler
References: <49B18B2E.606@us.ibm.com> <20090306225312.GA25593@silver.sucs.org>
In-Reply-To: <20090306225312.GA25593@silver.sucs.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sitsofe Wheeler wrote:
> On Fri, Mar 06, 2009 at 12:44:30PM -0800, Darren Hart wrote:
>> I've received an internal request for a means to determine at run-time 
>> if the CFS scheduler is included in the running kernel.  Looking through 
>> the git commit log and the /proc/sys/kernel filesystem, I think I see 
>> two approaches:
> 
> Sounds dangerous (you are dependent on scheduler beahviour) but if it
> exists you could check /proc/config.gz (or the config file in the /boot
> directory)...
> 

So I am of course in agreement with both you and Peter.  In this case, 
the development team of an existing product is trying to move away from 
heavy use of sched_yield(), and the CFS scheduler provides some 
motivation for that as the behavior of sched_yield() changed (again). 
As we know, this behavior should not be depended upon, but lots of 
applications do it unfortunately.  So, in this case the development team 
would like to move to becoming less dependent on it, but unfortunately 
do not feel it is feasible to make the change unconditionally as it has 
the potential to destabilize the existing installations, etc.  They 
would like to be able to say, use this new approach using fewer 
sched_yield() calls on kernels with CFS.

I understand it isn't ideal, and I have of course provided that 
feedback, but I would like to provide them with all the information I can.

Thanks,

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
