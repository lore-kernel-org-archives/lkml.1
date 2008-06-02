Return-Path: <linux-kernel-owner+w=401wt.eu-S1757436AbYFBGJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436AbYFBGJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 02:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbYFBGJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 02:09:43 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:47662 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbYFBGJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 02:09:43 -0400
Message-ID: <48438E54.1000404@linux.vnet.ibm.com>
Date: Mon, 02 Jun 2008 11:38:20 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Arjan van de Ven <arjan@infradead.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       Michael Neuling <mikey@neuling.org>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v1 0/3] Scaled statistics using APERF/MPERF in x86
References: <20080526142513.24680.97164.stgit@drishya.in.ibm.com> <20080526085000.33787eac@infradead.org> <20080531211306.GM5405@ucw.cz>
In-Reply-To: <20080531211306.GM5405@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>>> entitlement for the process as per the current CPU frequency.  This
>>> technique is used in powerpc architecture with the help of hardware
>>> registers that accurately capture the entitlement.
>>>
>> there are some issues with this unfortunately, and these make it
>> a very complex thing to do. 
>> Just to mention a few:
>> 1) What if the BIOS no longer allows us to go to the max frequency for
>> a period (for example as a result of overheating); with the approach
>> above, the admin would THINK he can go faster, but he cannot in reality,
>> so there's misleading information (the system looks half busy, while in
> 
> Plus time one-second-computation-job returning anything else is just
> wrong. Even when it only happens when overheated... or only on battery
> power.
> 
> If you want scaled utime, you need new interface.

We do have a new interface, two new parameters per-task utimescaled and
stimescaled. They already exist in task_struct. Ditto for the delay accounting
pieces. Did I misunderstand your need for a new interface? We still keep utime
and stime around.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
