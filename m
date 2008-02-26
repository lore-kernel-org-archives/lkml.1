Return-Path: <linux-kernel-owner+w=401wt.eu-S1759053AbYBZAsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759053AbYBZAsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 19:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750907AbYBZAsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 19:48:04 -0500
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:16645 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750771AbYBZAsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 19:48:03 -0500
Message-ID: <47C361B9.7010304@panasas.com>
Date: Mon, 25 Feb 2008 16:47:53 -0800
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Richard Knutsson <ricknu-0@student.ltu.se>
CC: Krzysztof Halasa <khc@pm.waw.pl>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Tabs, spaces, indent and 80 character lines
References: <47C0BEE7.4040409@student.ltu.se> <m3ejb2bdxx.fsf@maximus.localdomain> <47C19001.7010609@student.ltu.se> <47C1980C.4050800@panasas.com> <47C335D9.3010803@student.ltu.se>
In-Reply-To: <47C335D9.3010803@student.ltu.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Feb 2008 00:47:54.0358 (UTC) FILETIME=[38D8F960:01C87811]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb. 25, 2008, 13:40 -0800, Richard Knutsson <ricknu-0@student.ltu.se> wrote:
> Benny Halevy wrote:
>> On Feb. 24, 2008, 7:40 -0800, Richard Knutsson <ricknu-0@student.ltu.se> wrote:
>>   
>>> Krzysztof Halasa wrote:
>>>     
>>>> Richard Knutsson <ricknu-0@student.ltu.se> writes:
>>>>
>>>>   
>>>>       
>>>>> Why hinder a developer who prefer
>>>>> 2, 4, 6 or any other != 8 width?
>>>>>     
>>>>>         
>>>> I guess we could use tabs only at the line start, for indentation
>>>> only. Rather hard to implement, most text editors can't do that yet.
>>>>   
>>>>       
>>> You mean for split lines? Hopefully there won't be that many, so there 
>>> is just to delete the tabs it added and replace it with spaces.
>>>     
>> IMO, tabs SHOULD be used for syntactic indentation and spaces for
>> decoration purpose only.  I.e. a line should start with a number of tabs
>> equal to its nesting level and after that only spaces should be used.
>> for example, the following code
>>
>> for (i = 0; i < n; i++) printk("a very long format string", some, parameters);
>>
>> should be formatted like this:
>>
>> <tabs...>for (i = 0; i < n; i++)
>> <tabs...><tab>printk("a very long format string",
>> <tabs...><tab>       some, parameters);
>>
>> this will show exactly right regardless of your editor's tab expansion setting
>> as long as you use fixed-width fonts - where the screen width of the space character
>> is equal to all other characters.  Once you start using tabs instead of spaces
>> to push text right so it appears exactly below some other text on the line above
>> you make a dependency on *your* editor's tab expansion policy and that's not very
>> considerate for folks who prefer a different one.
>>   
> Don't know what to say more then: Yup! :)
> 
> But the CodeStyle-document and checkpatch.pl does not agree with that.
> 

I know :(
If there's enough interest I can take a stab at seeing what it'd
take to implement such a check in checkpatch.pl

Benny

