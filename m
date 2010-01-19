Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322Ab0ASTD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab0ASTD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 14:03:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754952Ab0ASTD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 14:03:58 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:45702 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913Ab0ASTD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 14:03:56 -0500
Message-ID: <4B560213.2020707@linux.vnet.ibm.com>
Date: Wed, 20 Jan 2010 00:33:47 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0b1 Thunderbird/3.0
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Alexey Dobriyan <adobriyan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] delay-accounting: Re-implement -c for getdelays.c to
 report information on a target command
References: <20100119180027.GA5154@csn.ul.ie> <4B55F657.9000009@linux.vnet.ibm.com> <20100119185213.GB5154@csn.ul.ie>
In-Reply-To: <20100119185213.GB5154@csn.ul.ie>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 January 2010 12:22 AM, Mel Gorman wrote:
>>
>> That is an oversight and not intentional. I've not gotten around to
>> reimplementing the -c option due to lack for people asking for it.
>>
> 
> Consider this a request then. Man, I'd really like if someone
> implemented that -c switch thing :P
> 

:)

>>> This patch reimplements -c for getdelays.c to act as documented. Unlike the
>>> original version, it waits until the command completes before printing any
>>> information on it. An example of it being used looks like
>>>
>>
>> Looks good, could you please keep the original sign-offs as well?
>>
> 
> Well, the reimplementation is significantly different to what was there
> so I'm not sure that's appropriate. Look at the differences yourself.
> 

Fair enough

>>> $ ./getdelays -d -c find /home/mel -name mel
>>> print delayacct stats ON
>>> /home/mel
>>> /home/mel/.notes-wine/drive_c/windows/profiles/mel
>>> /home/mel/.wine/drive_c/windows/profiles/mel
>>> /home/mel/git-configs/dot.kde/share/apps/konqueror/home/mel
>>> PID	5923
>>>
>>> CPU             count     real total  virtual total    delay total
>>>                 42779     5051232096     5164722692      564207988
>>> IO              count    delay total
>>>                 41727    97804147758
>>> SWAP            count    delay total
>>>                     0              0
>>> RECLAIM         count    delay total
>>>                     0              0
>>>
>>> It's not clear how or if this subsystem is being maintained. If the
>>> authors agree on it but do not pick it up for merging, I'll go bug
>>> Andrew with it.
>>>
>>
>> I am maintaining it, please do let me know if you have an issue with the
>> subsystem or utilities.
>>
> 
> If you're happy with the patch then, can you pick it up, add your
> signed-off-by and go with whatever submission path you use for this
> subsystem?
> 

Absolutely!

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>

Andrew, could you please pick this up?

Thanks,
Balbir Singh.
