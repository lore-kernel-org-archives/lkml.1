Return-Path: <linux-kernel-owner+w=401wt.eu-S933167AbXBFSDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167AbXBFSDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 13:03:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933159AbXBFSDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 13:03:31 -0500
Received: from mail.tmr.com ([64.65.253.246]:35233 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933167AbXBFSDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 13:03:30 -0500
Message-ID: <45C8BE89.9000705@tmr.com>
Date: Tue, 06 Feb 2007 12:44:41 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Stephen.Clark@seclark.us, Patrick Ale <patrick.ale@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: hdparm for lib_pata
References: <fa.L/RjDlo6Njb5Jt7/9ENZuiASoV0@ifi.uio.no> <45C4DF2A.1070501@shaw.ca> <45C5178A.1000501@seclark.us> <45C51A80.3050308@shaw.ca>
In-Reply-To: <45C51A80.3050308@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Stephen Clark wrote:
>>> Only some of the hdparm functionality is supported in libata, which 
>>> is partially by design. Presently there's no way to override the DMA 
>>> settings in libata, it starts out at the fastest supported settings 
>>> and falls back if it gets too many errors of certain types.
>>>
>>> You shouldn't be seeing errors like this unless you have bad IDE 
>>> cables or are using 40-wire cables with high UDMA modes. Can you post 
>>> the output you're seeing?
>>>
>> Ok,
>>
>> But why are we taking away the users capability to control his/her own 
>> hardware. Sounds like windows.
>>
>> My $.02
>> Steve Clark


> Support for that ioctl could likely be added, but these days I don't 
> think there's much use for it. I can't see how anybody in their right 
> mind would want to disable DMA on a modern drive, and if libata turns it 
> off automatically then there's likely some serious hardware or driver 
> problem that will end up biting you some other way if you force it back on.
> 
I think deciding to turn off DMA which works fine in old kernels 
qualifies as a "serious driver problem," which is why it should be under 
user control.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

