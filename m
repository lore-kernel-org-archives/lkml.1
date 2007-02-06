Return-Path: <linux-kernel-owner+w=401wt.eu-S1030599AbXBFXqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030599AbXBFXqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:46:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030602AbXBFXqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:46:12 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:52208 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030599AbXBFXqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:46:12 -0500
Date: Tue, 06 Feb 2007 17:45:22 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: hdparm for lib_pata
In-reply-to: <45C8BE89.9000705@tmr.com>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Stephen.Clark@seclark.us, Patrick Ale <patrick.ale@gmail.com>,
       linux-kernel@vger.kernel.org
Message-id: <45C91312.2030403@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.L/RjDlo6Njb5Jt7/9ENZuiASoV0@ifi.uio.no>
 <45C4DF2A.1070501@shaw.ca> <45C5178A.1000501@seclark.us>
 <45C51A80.3050308@shaw.ca> <45C8BE89.9000705@tmr.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote:
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

Point is, if the DMA's not working such that the system decides to turn 
it off, it's obviously having some issues, and thus turning it back on 
without fixing the problem could cause problems or even cause data 
corruption.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

