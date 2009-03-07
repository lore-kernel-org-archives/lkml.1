Return-Path: <linux-kernel-owner+w=401wt.eu-S1756758AbZCGASB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbZCGASB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 19:18:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755517AbZCGARw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 19:17:52 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:51047 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755138AbZCGARv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 19:17:51 -0500
Message-ID: <49B1BD2B.1040500@us.ibm.com>
Date: Fri, 06 Mar 2009 16:17:47 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Sitsofe Wheeler <sitsofe@yahoo.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "lkml, " <linux-kernel@vger.kernel.org>
Subject: Re: Dynamically determine if kernel includes CFS Scheduler
References: <49B18B2E.606@us.ibm.com> <20090306225312.GA25593@silver.sucs.org> <49B1AB3A.2050303@us.ibm.com> <20090306230804.GA963@silver.sucs.org>
In-Reply-To: <20090306230804.GA963@silver.sucs.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sitsofe Wheeler wrote:
> On Fri, Mar 06, 2009 at 03:01:14PM -0800, Darren Hart wrote:
>> So I am of course in agreement with both you and Peter.  In this case, 
>> the development team of an existing product is trying to move away from 
>> heavy use of sched_yield(), and the CFS scheduler provides some 
> 
> Hmm. The only thing I'll say about checking kernel versions is: do some
> tests/checks with the different enterprise distro kernels. I don't think
> they tend to do big backports any more but if they have that kernel
> version check could become tricky...

Right, excellent point.  Regardless of how thing are right now, relying 
on the kernel revision is a bad idea for this reason.

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
