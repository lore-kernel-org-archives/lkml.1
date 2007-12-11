Return-Path: <linux-kernel-owner+w=401wt.eu-S1753893AbXLKWLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbXLKWLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:11:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbXLKWLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:11:23 -0500
Received: from ccs17.jlab.org ([129.57.35.82]:46039 "EHLO ccs17.jlab.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbXLKWLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:11:23 -0500
Message-ID: <475F0B07.2060303@jlab.org>
Date: Tue, 11 Dec 2007 17:11:19 -0500
From: Jie Chen <chen@jlab.org>
Organization: Jefferson Lab
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Possible bug from kernel 2.6.22 and above, 2.6.24-rc4
References: <20071205210222.GA30089@elte.hu> <47572353.4040606@jlab.org> <20071206104318.GB30838@elte.hu> <47582367.6060602@jlab.org> <20071210105943.GA5370@elte.hu> <475D9BB5.20808@jlab.org> <20071211105149.GA24250@elte.hu> <475EAC81.1020408@jlab.org> <20071211155226.GA1056@elte.hu> <475EBD30.1010506@jlab.org> <20071211212352.GF6902@elte.hu>
In-Reply-To: <20071211212352.GF6902@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jie Chen <chen@jlab.org> wrote:
> 
>> The following is pthread_sync output for 2.6.21.7-cfs-v24 #1 SMP 
>> kernel.
> 
>> 2 threads:
> 
>> PARALLEL time =       11.106580 microseconds +/- 0.002460
>> PARALLEL overhead =    0.617590 microseconds +/- 0.003409
> 
>> Output for Kernel 2.6.24-rc4 #1 SMP
> 
>> PARALLEL time =              19.668450 microseconds +/- 0.015782
>> PARALLEL overhead =           9.157945 microseconds +/- 0.018217
> 
> ok, so the problem is that this PARALLEL time has an additional +9 usecs 
> overhead, right? I dont see this myself on a Core2 CPU:
> 
> PARALLEL time =                           10.446933 microseconds +/- 0.078849
> PARALLEL overhead =                       0.751732 microseconds +/- 0.177446
> 
> 	Ingo
Hi, Ingo:

Yes, the extra 9 usecs overhead for running two threads in the 2.6.24 
kernel when there are total of 8 cores (2 quad opterons). What is the 
total number of cores do you have? I do not have machines that have dual 
quad Xeons here for direct comparisons. Thank you.

-- 
#############################################################################
# Jie Chen
# Scientific Computing Group
# Thomas Jefferson National Accelerator Facility
# Newport News, VA 23606
#
# chen@jlab.org
# (757)269-5046 (office)
# (757)269-6248 (fax)
#############################################################################
