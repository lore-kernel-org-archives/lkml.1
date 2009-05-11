Return-Path: <linux-kernel-owner+w=401wt.eu-S1759267AbZEKUKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759267AbZEKUKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 16:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755332AbZEKUKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 16:10:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62686 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204AbZEKUKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 16:10:45 -0400
Message-ID: <4A088640.2030701@vlnb.net>
Date: Tue, 12 May 2009 00:10:40 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Shannon McMackin <smcmackin@gmail.com>, linux-kernel@vger.kernel.org,
       tuxonice-devel@lists.tuxonice.net
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <20090507120948.GA1531@ucw.cz> <200905080037.19722@centrum.cz> <gu017d$g2s$1@ger.gmane.org> <20090510053820.GF1363@ucw.cz>
In-Reply-To: <20090510053820.GF1363@ucw.cz>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18Ud62Aky/kDkxFaC4JCAO+5egUHm8JCZaAYyl
 +td1wNI+CPLM2FdcP939DNevhq61nK3eR+MVV0lLT9JP7J1JmP
 KaOh3qjujX/Wk+UV5cpHA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Pavel Machek, on 05/10/2009 09:38 AM wrote:
> Hi!
> 
>>>> To summarise disadvantages:
>>>>
>>>> - only core has 8000 LoC
>>>> - it does stuff that can be easily done in userspace
>>>>     (and that todays distros _do_ in userspace).
>>>> - it duplicates uswsusp functionality.
>>>> - compared to [u]swsusp, it received little testing
>>>>
>>> To summarise advatages - for me tuxonice is the only hibernation method that works.
>>> (Till now I've had 3 machines - no one of them able to resume with in-kernel swsusp.)
>>>
>> Just to add my 2 cents as a user of TOI.  Every distro and release I've  
>> tried has one major issue with kernel hibernation.  Upon resume when  
>> hibernating large images, there's a residual footprint in swap.  Every  
>> further hibernation creates a larger footprint, to the order of an  
>> additional 5-7% each time.  Nobody has ever cared in any forum to  
>> explain why or how I might change that.
> 
> Maybe you should explain why it is a 'major issue'?
> 
> (Use swapoff -a; swapon -a to 'cure' it).

Great advice if you have used memory > physical memory!

Just run two firefox's and thunderbird and you will get that pretty quickly:

# free
              total       used       free     shared    buffers     cached
Mem:       2060560    2040656      19904          0      31452     360580
Swap:      5358296    1475504    3882792



> 								Pavel
