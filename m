Return-Path: <linux-kernel-owner+w=401wt.eu-S1759974AbXKMTbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759974AbXKMTbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 14:31:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755918AbXKMTbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 14:31:00 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:49807 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753678AbXKMTa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 14:30:58 -0500
Date: Tue, 13 Nov 2007 20:30:35 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Mark Lord <liml@rtr.ca>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, protasnb@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       alsa-devel@alsa-project.org, linux-ide@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-input@atrey.karlin.mff.cuni.cz,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [BUG] New Kernel Bugs
Message-ID: <20071113193035.GI4250@stusta.de>
References: <20071113134029.GA30978@elte.hu> <4739AFE0.20705@rtr.ca> <20071113164650.GA28493@elte.hu> <4739E3D0.10201@rtr.ca> <20071113181228.GF4250@stusta.de> <4739EA83.5040006@rtr.ca> <20071113183605.GG4250@stusta.de> <4739F12E.5020807@rtr.ca> <20071113190428.GH4250@stusta.de> <4739F739.5040708@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4739F739.5040708@rtr.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 02:12:57PM -0500, Mark Lord wrote:
> Adrian Bunk wrote:
>> On Tue, Nov 13, 2007 at 01:47:10PM -0500, Mark Lord wrote:
>>> Adrian Bunk wrote:
>>> ...
>>>> I did bisecting myself, and I know that it costs time and work.
>>>>
>>>> But the first point is the above one that it makes otherwise nearly 
>>>> undebuggable problems debuggable and fixable.
>>> ..
>>>
>>> Definitely useful, no question.
>>>
>>> But the problem is now that kernel devs are addicted to it,
>>> many won't even consider resolving a problem any other way.
>>>
>>> That's not "maintaining" (or supporting) one's code.
>>
>> What you replaced with two dots contained the answer to this:
>>
>> Another point is that it shifts the work from the few experienced 
>> developers to the many users. Users (and voluntary testers) we have
>> many, but developer time for debugging bug reports is a quite scarce 
>> resource.
>>
>>> And when a "maintainer" is too busy to find/fix their own bugs,
>>> that could be a sign that they've bitten off too big of a chunk
>>> of the kernel, and it's time for them to distribute code maintainership.
>>
>> The problem is: Maintainers don't grow on trees.
>>
>> You need people who are both technically capable and willing to spend time 
>> on the non-sexy task of debugging problems.
>>
>> Where do you plan to find them?
>>
>> If you don't believe me, please find a maintainer for the currently 
>> unmaintained parallel port support.
>>
>> Or if you want a harder task, find a maintainer for the floppy driver...
> ..
>
> Again, the problem is:
>
>> But the problem is now that kernel devs are addicted to it,
>> many won't even consider resolving a problem any other way.
>
> And that's simply not good enough.

There is this silly limit that noone can work more than 168 hours per 
week on the Linux kernel, and some kernel developers seem to take the 
liberty of spending even less time on kernel development...

Considering our problems to cope with the amount of incoming bug 
reports, everything that would require a kernel developer to spend more 
time for getting a bug fixed would be a horrible mistake.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

