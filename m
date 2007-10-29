Return-Path: <linux-kernel-owner+w=401wt.eu-S1756571AbXJ2XYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571AbXJ2XYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 19:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbXJ2XYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 19:24:39 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:53474 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbXJ2XYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 19:24:38 -0400
Message-ID: <47266BAB.2000406@linux.vnet.ibm.com>
Date: Tue, 30 Oct 2007 04:54:27 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: Ingo Molnar <mingo@elte.hu>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Chuck Ebbert <cebbert@redhat.com>, Greg KH <greg@kroah.com>,
       stable@kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [stable] 2.6.23 regression: top displaying 9999% CPU usage
References: <200710122231.50739.elendil@planet.nl> <20071029200425.GA830@elte.hu> <20071029214321.GA25669@linux.vnet.ibm.com> <200710300019.28871.elendil@planet.nl>
In-Reply-To: <200710300019.28871.elendil@planet.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> On Monday 29 October 2007, Balbir Singh wrote:
>> We'll also need this additional patch (untested),
> 
> OK. Both patches together do the trick. Gave it a nice long test run and got 
> no more weirdness.
> Tested-by: Frans Pop <elendil@planet.nl>
> 

Thanks for testing it

Ingo, I think this fix needs to be picked as well.

>> but in the long run I think the approach needs to be
>>
>> 1. Update stime and utime at the time of context switching -- keep it
>>    in sync with p->sum_exec_runtime
>> 2. Keep track of system/user context at system call entry points
> 
> Feel free to send me a patch for testing when you have one.
> 

I hope to find some free time soon and get to it.

> Cheers,
> Frans


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
