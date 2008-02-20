Return-Path: <linux-kernel-owner+w=401wt.eu-S933670AbYBTPlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933670AbYBTPlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 10:41:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757714AbYBTPlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 10:41:06 -0500
Received: from vms046pub.verizon.net ([206.46.252.46]:46168 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757602AbYBTPlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 10:41:04 -0500
Date: Wed, 20 Feb 2008 09:20:35 -0600
From: Corey Minyard <minyard@acm.org>
Subject: Re: [Openipmi-developer] [PATCH 3/4] IPMI: convert locked counters to
 atomics
In-reply-to: <20080216164434.GC13922@auslistsprd01.us.dell.com>
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: Andrew Morton <akpm@osdl.org>,
       Konstantin Baydarov <kbaidarov@ru.mvista.com>,
       OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Message-id: <47BC4543.2050503@acm.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <20080214183051.GC20148@minyard.local>
 <20080216164434.GC13922@auslistsprd01.us.dell.com>
User-Agent: Icedove 1.5.0.14pre (X11/20080208)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Domsch wrote:
> On Thu, Feb 14, 2008 at 12:30:51PM -0600, Corey Minyard wrote:
>   
>> From: Konstantin Baydarov <kbaidarov@ru.mvista.com>
>>
>> Atomics are a lot more efficient and neat than using a lock.
>>     
>
> per_cpu variables are a lot more efficient and neat than using locks
> for simple statistics.  no cache line bouncing to increment the
> counter.  Are these read so often that atomics are really better?
>   
I agree, I'll put this in the plan for the future.  I don't have time to 
do it at this point, but the changes made in these patches should make 
it easy to change in the future.

Thanks,

-corey
