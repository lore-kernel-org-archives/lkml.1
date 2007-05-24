Return-Path: <linux-kernel-owner+w=401wt.eu-S1760963AbXEXFFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760963AbXEXFFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 01:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757985AbXEXFEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 01:04:55 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:50273 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757945AbXEXFEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 01:04:54 -0400
Message-ID: <46551DCC.1070104@oracle.com>
Date: Wed, 23 May 2007 22:08:28 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Rene Herman <rene.herman@gmail.com>
CC: Michael Tokarev <mjt@tls.msk.ru>, lkml <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] add "notime" boot option
References: <20070522120938.db67f1e9.randy.dunlap@oracle.com>	<46541F65.9060507@msgid.tls.msk.ru>	<20070523100416.93835196.randy.dunlap@oracle.com>	<465492C8.9060003@gmail.com> <20070523135513.b3573f52.randy.dunlap@oracle.com> <46551A93.6050801@gmail.com>
In-Reply-To: <46551A93.6050801@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> On 05/23/2007 10:55 PM, Randy Dunlap wrote:
> 
>>>>> That's a good source of confusion.  To me, "notime" means something
>>>>>  like "don't bother calculating time", instead of the proposed 
>>>>> behavior.  Can't it be something like 'nologts' (no log timestamps)
>>>>>  or nots or notimestamps or nologtime instead
>>>>
>>>> "nologtime" is OK with me.  or does it confuse people in a different
>>>> way?  Anyone else?
>>>
>>> The CONFIG option is called CONFIG_PRINTK_TIME. How about 
>>> "noprintktime"? At least nicely to the point...
>>
>> Actually I'm concerned about total kernel command line length,
>> so using option names that are "long" when short will do is not good IMO.
>>
>> I.e., I can easily overflow a 255-byte command line length buffer,
>> so Shorter is Better.
> 
> Okay. I would by the way not be against turning the timestamping off by 
> default and turning it _on_ with a "timestamps" or "logtime" or whatever 
> option. The information is sometimes handy for seeing the (clustering 
> of) event times so I've been compiling it in for a while on some boxes 
> but in the majority case for me it's noise taking up printk real estate...

But CONFIG_PRINTK_TIME is what controls its "default" (build-time) value.
I.e., users can control that.

I would be OK with removing that config option and only being able to
enable it, but I doubt that this would have much support.  ;)

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
