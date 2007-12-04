Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388AbXLDW25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbXLDW25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 17:28:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbXLDW2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 17:28:49 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbXLDW2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 17:28:48 -0500
Message-ID: <4755D350.1080801@redhat.com>
Date: Tue, 04 Dec 2007 16:23:12 -0600
From: Mike McGrath <mmcgrath@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Ray Lee <ray@madrabbit.org>, Adrian Bunk <bunk@kernel.org>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
References: <20071204114125.GA17310@torres.zugschlus.de> <20071204161811.GB15974@stusta.de> <2c0942db0712040854u17a830b9see663742b2716457@mail.gmail.com> <20071204165502.0a8f695e@the-village.bc.nu> <20071204180237.GU19691@waste.org> <20071204195021.GB7259@thunk.org> <20071204204036.484f11ac@the-village.bc.nu> <20071204210827.GE19691@waste.org> <4755C423.60907@redhat.com> <20071204221525.GG19691@waste.org>
In-Reply-To: <20071204221525.GG19691@waste.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Tue, Dec 04, 2007 at 03:18:27PM -0600, Mike McGrath wrote:
>   
>> Matt Mackall wrote:
>>     
>>> which would have been in v2.6.22-rc4 through the normal CVE process.
>>> The only other bits in there are wall time and utsname, so systems
>>> with no CMOS clock would behave repeatably. Can we find out what
>>> kernels are affected?
>>>
>>>  
>>>       
>> We can but it will likely take a few weeks to get a good sampling. UUID 
>> is unique in the db so when someone checks in with the same UUID, the 
>> old one gets overwritten.
>>     
>
> We can probably assume that for whatever reason the two things with
> duplicate UUID had the same seed. If not, we've got -much- bigger
> problems.
>   

Ok, I think I see whats going on here. I have some further investigation 
to do but it seems that the way our Live CD installer works is causing 
these issues. I'm going to try to grab some live CD's and hardware to 
confirm but at this point it seems thats whats going on.

-Mike
