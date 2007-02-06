Return-Path: <linux-kernel-owner+w=401wt.eu-S933187AbXBFSpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187AbXBFSpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 13:45:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933195AbXBFSpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 13:45:12 -0500
Received: from rtr.ca ([64.26.128.89]:3623 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933187AbXBFSpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 13:45:11 -0500
Message-ID: <45C8CCB2.4030508@rtr.ca>
Date: Tue, 06 Feb 2007 13:45:06 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
Cc: Robert Hancock <hancockr@shaw.ca>, Stephen.Clark@seclark.us,
       Patrick Ale <patrick.ale@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: hdparm for lib_pata
References: <fa.L/RjDlo6Njb5Jt7/9ENZuiASoV0@ifi.uio.no> <45C4DF2A.1070501@shaw.ca> <45C5178A.1000501@seclark.us> <45C51A80.3050308@shaw.ca> <45C8BE89.9000705@tmr.com>
In-Reply-To: <45C8BE89.9000705@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

re: hdparm -d

>> Support for that ioctl could likely be added, but these days I don't 
>> think there's much use for it. I can't see how anybody in their right 
>> mind would want to disable DMA on a modern drive, and if libata turns 
>> it off automatically then there's likely some serious hardware or 
>> driver problem that will end up biting you some other way if you force 
>> it back on.
>>
> I think deciding to turn off DMA which works fine in old kernels 
> qualifies as a "serious driver problem," which is why it should be under 
> user control.

Fair enough.

The original reason for that functionality in the drivers/ide stuff,
was that I wanted a way to be able to continue to test the IDE driver
in PIO mode, despite all of my own devices having good DMA support.

If there's no way to force the driver to use a particular transfer
method, then it becomes difficult to (re)test the driver over time.

Cheers
 

