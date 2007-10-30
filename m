Return-Path: <linux-kernel-owner+w=401wt.eu-S1755276AbXJ3GA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbXJ3GA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 02:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119AbXJ3GAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 02:00:17 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:53659 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093AbXJ3GAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 02:00:16 -0400
Message-ID: <4726C863.2070105@linux.vnet.ibm.com>
Date: Tue, 30 Oct 2007 11:30:03 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, Frans Pop <elendil@planet.nl>,
       Chuck Ebbert <cebbert@redhat.com>, Greg KH <greg@kroah.com>,
       stable@kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [stable] 2.6.23 regression: top displaying 9999% CPU usage
References: <200710122231.50739.elendil@planet.nl> <20071029200425.GA830@elte.hu> <20071029214321.GA25669@linux.vnet.ibm.com> <200710300656.38220.borntraeger@de.ibm.com>
In-Reply-To: <200710300656.38220.borntraeger@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger wrote:
> Am Montag, 29. Oktober 2007 schrieb Balbir Singh:
>> We'll also need this additional patch (untested), but in the long run
>> I think the approach needs to be
>>
>> 1. Update stime and utime at the time of context switching -- keep it
>>    in sync with p->sum_exec_runtime
>> 2. Keep track of system/user context at system call entry points
> 
> This is similar to what s390 and ppc64 do when CONFIG_VIRT_CPU_ACCOUNTING is 
> set. Whenever you do a patch, please make sure to not break the already 
> precise values for utime and stime on s390 and ppc. Feel free to CC me 
> whenever you have a patch for this.
> 

Yes, true. I'll cc everyone on this list and send out the patch as RFC.
Much of this code will be architecture specific and as you rightly
pointed out, needs to happen under !CONFIG_VIRT_CPU_ACCOUNTING

> Christian


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
