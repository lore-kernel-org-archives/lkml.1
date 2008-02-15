Return-Path: <linux-kernel-owner+w=401wt.eu-S1757615AbYBOOIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615AbYBOOIY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 09:08:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933677AbYBOOIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 09:08:09 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:40384 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756612AbYBOOIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 09:08:07 -0500
Date: Fri, 15 Feb 2008 08:08:02 -0600
From: Corey Minyard <minyard@acm.org>
Subject: Re: [Openipmi-developer] [PATCH 3/4] IPMI: convert locked counters to
 atomics
In-reply-to: <1203083843.6855.44.camel@twins>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@osdl.org>,
       Konstantin Baydarov <kbaidarov@ru.mvista.com>,
       OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Message-id: <47B59CC2.20404@acm.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <20080214183051.GC20148@minyard.local>
 <1203083843.6855.44.camel@twins>
User-Agent: Icedove 1.5.0.14pre (X11/20071018)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2008-02-14 at 12:30 -0600, Corey Minyard wrote:
>
>   
>> +/* The command didn't have anyone waiting for it. */
>> +#define IPMI_STAT_unhandled_commands			23
>> +
>> +/* Invalid data in an event. */
>> +#define IPMI_STAT_invalid_events			24
>> +
>> +/* Events that were received with the proper format. */
>> +#define IPMI_STAT_events				25
>> +
>> +/* When you add a statistic, you must update this value. */
>> +#define IPMI_NUM_STATS					26
>>     
>
> This shouts enum to me..
>   
Someone else asked about this, and I wasn't too sure.  It seems from the 
CodingStyle document that enums are preferred for things like this, but 
I current kernel code seems a mixed bag.  An enum is cleaner and more 
reliable, IMHO.  I'll convert it, I think.

Thanks,

-corey
