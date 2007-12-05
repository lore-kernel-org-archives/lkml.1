Return-Path: <linux-kernel-owner+w=401wt.eu-S1752776AbXLEOby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbXLEOby (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 09:31:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbXLEObr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 09:31:47 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbXLEObq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 09:31:46 -0500
Message-ID: <4756B50B.3060100@redhat.com>
Date: Wed, 05 Dec 2007 08:26:19 -0600
From: Mike McGrath <mmcgrath@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Ray Lee <ray@madrabbit.org>, Adrian Bunk <bunk@kernel.org>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
References: <20071204161811.GB15974@stusta.de> <2c0942db0712040854u17a830b9see663742b2716457@mail.gmail.com> <20071204165502.0a8f695e@the-village.bc.nu> <20071204180237.GU19691@waste.org> <20071204195021.GB7259@thunk.org> <20071204204036.484f11ac@the-village.bc.nu> <20071204210827.GE19691@waste.org> <4755C423.60907@redhat.com> <20071204221525.GG19691@waste.org> <4755D350.1080801@redhat.com> <20071204223345.GJ19691@waste.org>
In-Reply-To: <20071204223345.GJ19691@waste.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Tue, Dec 04, 2007 at 04:23:12PM -0600, Mike McGrath wrote:
>   
>> Matt Mackall wrote:
>>     
>>> On Tue, Dec 04, 2007 at 03:18:27PM -0600, Mike McGrath wrote:
>>>  
>>>       
>>>> Matt Mackall wrote:
>>>>    
>>>>         
>>>>> which would have been in v2.6.22-rc4 through the normal CVE process.
>>>>> The only other bits in there are wall time and utsname, so systems
>>>>> with no CMOS clock would behave repeatably. Can we find out what
>>>>> kernels are affected?
>>>>>
>>>>>
>>>>>      
>>>>>           
>>>> We can but it will likely take a few weeks to get a good sampling. UUID 
>>>> is unique in the db so when someone checks in with the same UUID, the 
>>>> old one gets overwritten.
>>>>    
>>>>         
>>> We can probably assume that for whatever reason the two things with
>>> duplicate UUID had the same seed. If not, we've got -much- bigger
>>> problems.
>>>  
>>>       
>> Ok, I think I see whats going on here. I have some further investigation 
>> to do but it seems that the way our Live CD installer works is causing 
>> these issues. I'm going to try to grab some live CD's and hardware to 
>> confirm but at this point it seems thats whats going on.
>>     
>
> Alright, keep me posted. We probably need a scheme to make the initial
> seed more robust regardless of what you find out

Ok, whats going on here is an issue with how the smolt RPM installs the 
UUID and how Fedora's Live CD does an install.  It's a complete false 
alarm on the kernel side, sorry for the confusion.

    -Mike

