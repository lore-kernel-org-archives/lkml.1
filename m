Return-Path: <linux-kernel-owner+w=401wt.eu-S1765840AbZAOOrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765840AbZAOOrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 09:47:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765366AbZAOOq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 09:46:59 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:50368 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762919AbZAOOq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 09:46:57 -0500
Message-ID: <496F4B63.6070609@cs.helsinki.fi>
Date: Thu, 15 Jan 2009 16:42:43 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, chinang.ma@intel.com,
       linux-kernel@vger.kernel.org, sharad.c.tripathi@intel.com,
       arjan@linux.intel.com, andi.kleen@intel.com, suresh.b.siddha@intel.com,
       harita.chilukuri@intel.com, douglas.w.styner@intel.com,
       peter.xihong.wang@intel.com, hubert.nueckel@intel.com,
       chris.mason@oracle.com, srostedt@redhat.com, linux-scsi@vger.kernel.org,
       Andrew Vasquez <andrew.vasquez@qlogic.com>,
       Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Subject: Re: Mainline kernel OLTP performance update
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com> <20090115012147.GW29283@parisc-linux.org> <20090114180431.f4a96543.akpm@linux-foundation.org> <200901151824.38658.nickpiggin@yahoo.com.au> <84144f020901150146x72402ec4p7636d583cfd55b3e@mail.gmail.com> <20090115135236.GB29283@parisc-linux.org>
In-Reply-To: <20090115135236.GB29283@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Thu, Jan 15, 2009 at 11:46:09AM +0200, Pekka Enberg wrote:
>> It would also be nice if someone could do the performance analysis on
>> the SLUB bug. I ran sysbench in oltp mode here and the results look
>> like this:
>>
>>   [ number of transactions per second from 10 runs. ]
>>
>>                    min      max      avg      sd
>>   2.6.29-rc1-slab  833.77   852.32   845.10   4.72
>>   2.6.29-rc1-slub  823.61   851.94   836.74   8.57
>>
>> And no, the numbers are not flipped, SLUB beats SLAB here. :(
> 
> Um.  More transactions per second is good.  Your numbers show SLAB
> beating SLUB (even on your dual-CPU system).  And SLAB shows a lower
> standard deviation, which is also good.

*blush*

Will do oprofile tomorrow. Thanks Matthew.
