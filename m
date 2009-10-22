Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271AbZJVWto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbZJVWto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 18:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753949AbZJVWtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 18:49:43 -0400
Received: from lucidpixels.com ([75.144.35.66]:56519 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbZJVWtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 18:49:42 -0400
Date: Thu, 22 Oct 2009 18:49:46 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Dave Chinner <david@fromorbit.com>
cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com,
       Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.31+2.6.31.4: XFS - All I/O locks up to D-state after 24-48
 hours (sysrq-t+w available)
In-Reply-To: <alpine.DEB.2.00.0910210618210.10288@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.0910221849001.24576@p34.internal.lan>
References: <alpine.DEB.2.00.0910171825270.16781@p34.internal.lan> <alpine.DEB.2.00.0910181607040.27363@p34.internal.lan> <20091019030456.GS9464@discord.disaster> <alpine.DEB.2.00.0910190431180.23395@p34.internal.lan> <20091020003358.GW9464@discord.disaster>
 <alpine.DEB.2.00.0910200431290.21878@p34.internal.lan> <alpine.DEB.2.00.0910210618210.10288@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 21 Oct 2009, Justin Piszcz wrote:

>
>
> On Tue, 20 Oct 2009, Justin Piszcz wrote:
>
>
>> 
>> 
>> On Tue, 20 Oct 2009, Dave Chinner wrote:
>> 
>>> On Mon, Oct 19, 2009 at 06:18:58AM -0400, Justin Piszcz wrote:
>>>> On Mon, 19 Oct 2009, Dave Chinner wrote:
>>>>> On Sun, Oct 18, 2009 at 04:17:42PM -0400, Justin Piszcz wrote:
>>>>>> It has happened again, all sysrq-X output was saved this time.
>>>>> .....
>>>>> 
>>>>> All pointing to log IO not completing.
>>>>> 
>>> ....
>>>> So far I do not have a reproducible test case,
>>> 
>>> Ok. What sort of load is being placed on the machine?
>> Hello, generally the load is low, it mainly serves out some samba shares.
>> 
>>> 
>>> It appears that both the xfslogd and the xfsdatad on CPU 0 are in
>>> the running state but don't appear to be consuming any significant
>>> CPU time. If they remain like this then I think that means they are
>>> stuck waiting on the run queue.  Do these XFS threads always appear
>>> like this when the hang occurs? If so, is there something else that
>>> is hogging CPU 0 preventing these threads from getting the CPU?
>> Yes, the XFS threads show up like this on each time the kernel crashed.  So 
>> far
>> with 2.6.30.9 after ~48hrs+ it has not crashed.  So it appears to be some 
>> issue
>> between 2.6.30.9 and 2.6.31.x when this began happening.  Any 
>> recommendations
>> on how to catch this bug w/certain options enabled/etc?
>> 
>> 
>>> 
>>> Cheers,
>>> 
>>> Dave.
>>> -- 
>>> Dave Chinner
>>> david@fromorbit.com
>>> 
>> 
>
> Uptime with 2.6.30.9:
>
> 06:18:41 up 2 days, 14:10, 14 users,  load average: 0.41, 0.21, 0.07
>
> No issues yet, so it first started happening in 2.6.(31).(x).
>
> Any further recommendations on how to debug this issue?  BTW: Do you view 
> this
> as an XFS bug or MD/VFS layer issue based on the logs/output thus far?
>
> Justin.
>
>

Any other ideas?

Currently stuck on 2.6.30.9.. (no issues, no lockups)-- Box normally has 
no load at all either.. Has anyone else reported similar problems?

Justin.
