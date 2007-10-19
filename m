Return-Path: <linux-kernel-owner+w=401wt.eu-S936414AbXJSTx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936414AbXJSTx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 15:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937002AbXJSTw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 15:52:58 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:53113 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936822AbXJSTw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 15:52:56 -0400
Message-ID: <47190B28.6070405@cfl.rr.com>
Date: Fri, 19 Oct 2007 15:53:12 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH 0/2 -mm] kexec based hibernation -v5
References: <1192068833.27482.13.camel@caritas-dev.intel.com>
In-Reply-To: <1192068833.27482.13.camel@caritas-dev.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Oct 2007 19:53:08.0159 (UTC) FILETIME=[ABC36CF0:01C81289]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1023-15494.000
X-TM-AS-Result: No--8.325400-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
> The hibernation procedure with the patch set is as follow:
> 
> 1. Boot a kernel A
> 
> 2. Work under kernel A
> 
> 3. Kexec another kernel B (crash dump enabled) in kernel A.
> 
> 4. Save the memory image of kernel A through crash dump (such as "cp
>    /proc/vmcore ~"). Save the "jump back entry".

Doesn't this also save the memory of kernel B?

> 5. Shutdown or reboot
> 
> 
> The restore process with the patch set is as follow:
> 
> 1. Boot a kernel C (crash dump enabled), the memory area used by
>    kernel C must be a subset of memory area used by kernel B.

Why is a third kernel needed?  Why can't kernel B be used for this as 
well?  In fact, if kernel A has been compiled to be relocatable and 
crash dump enabled, why wouldn't it suffice for all 3 instances?


