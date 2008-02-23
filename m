Return-Path: <linux-kernel-owner+w=401wt.eu-S1765054AbYBWLVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765054AbYBWLVV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 06:21:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbYBWLVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 06:21:10 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:64267 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbYBWLVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 06:21:08 -0500
Message-ID: <47C00091.8000404@cfl.rr.com>
Date: Sat, 23 Feb 2008 06:16:33 -0500
From: Mark Hounschell <dmarkh@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Mike Christie <michaelc@cs.wisc.edu>
CC: markh@compro.net, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tony Battersby <tonyb@cybernetics.com>
Subject: Re: New 2.6.24.2 SG_IO SCSI problems
References: <47BD9588.9080803@compro.net> <47BEFD4B.9060803@cs.wisc.edu> <47BEFF5F.9020002@cs.wisc.edu> <47BF0CE2.306@compro.net> <47BF40D7.5050301@compro.net> <47BF4BD0.7080008@cs.wisc.edu>
In-Reply-To: <47BF4BD0.7080008@cs.wisc.edu>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Christie wrote:
> Mark Hounschell wrote:
>> Mark Hounschell wrote:
>>> Mike Christie wrote:
>>>> Mike Christie wrote:
>>>>> Mark Hounschell wrote:
>>>>>> I seem to have run into some sort of regression in the SG_IO
>>>>>> interface of 2.6.24.2. I have an application that up until 2.6.24
>>>>>> worked fine. The 2.6.23.16 kernel works fine.
>>>>>>
>>>>>> During reads I get these kernel messages. Writes and other functions
>>>>>> _seem_ OK. Actually basic
>>>>>> reads  are working. Its with large BC reads using an io_vec list that
>>>>>> the problem shows up.
>>>>>>
>>>>> Are you doing SG_IO to the sg device (/dev/sg*) or to the block device
>>>>> (/dev/sdX)?
>>>> If you are doing SG_IO to the sg device, then I know of one regression
>>>> (well not regression exactly, but I fixed a bug but the patch got
>>>> partially overwritten by another patch and that caused a new bug). Both
>>>> bugs are fixed in 2.6.25-rc2. Could you try that out if you are doing
>>>> SG_IO to the sg device.
>>>>
>>> Yes, I'm using /dev/sg*. And yes again I'll checkout 2.6.25-rc2 ASIC.
>>>
>>> Thanks
>>> Mark
>>> -
>>  
>> 2.6.25-rc2 does fix the problem I'm having. I don't suppose there is a
>> patch
>> lying around for 2.6.24.2??
>>
> 
> I attached a backport of the patch from Tony (added as cc) that is in
> 2.6.25-rc2. Could you try it out against 2.6.24.2 just to make sure it
> was this patch, then we can send it to stable.
> 

Sorry it took so long. This does fix my problem. I hope it's not to late
for 2.6.24.3

Regards
Mark
