Return-Path: <linux-kernel-owner+w=401wt.eu-S1757880AbYBYVpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880AbYBYVpI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 16:45:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbYBYVo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 16:44:57 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:45496 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbYBYVo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 16:44:57 -0500
Message-ID: <47C335D9.3010803@student.ltu.se>
Date: Mon, 25 Feb 2008 22:40:41 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Benny Halevy <bhalevy@panasas.com>
CC: Krzysztof Halasa <khc@pm.waw.pl>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Tabs, spaces, indent and 80 character lines
References: <47C0BEE7.4040409@student.ltu.se> <m3ejb2bdxx.fsf@maximus.localdomain> <47C19001.7010609@student.ltu.se> <47C1980C.4050800@panasas.com>
In-Reply-To: <47C1980C.4050800@panasas.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benny Halevy wrote:
> On Feb. 24, 2008, 7:40 -0800, Richard Knutsson <ricknu-0@student.ltu.se> wrote:
>   
>> Krzysztof Halasa wrote:
>>     
>>> Richard Knutsson <ricknu-0@student.ltu.se> writes:
>>>
>>>   
>>>       
>>>> Why hinder a developer who prefer
>>>> 2, 4, 6 or any other != 8 width?
>>>>     
>>>>         
>>> I guess we could use tabs only at the line start, for indentation
>>> only. Rather hard to implement, most text editors can't do that yet.
>>>   
>>>       
>> You mean for split lines? Hopefully there won't be that many, so there 
>> is just to delete the tabs it added and replace it with spaces.
>>     
>
> IMO, tabs SHOULD be used for syntactic indentation and spaces for
> decoration purpose only.  I.e. a line should start with a number of tabs
> equal to its nesting level and after that only spaces should be used.
> for example, the following code
>
> for (i = 0; i < n; i++) printk("a very long format string", some, parameters);
>
> should be formatted like this:
>
> <tabs...>for (i = 0; i < n; i++)
> <tabs...><tab>printk("a very long format string",
> <tabs...><tab>       some, parameters);
>
> this will show exactly right regardless of your editor's tab expansion setting
> as long as you use fixed-width fonts - where the screen width of the space character
> is equal to all other characters.  Once you start using tabs instead of spaces
> to push text right so it appears exactly below some other text on the line above
> you make a dependency on *your* editor's tab expansion policy and that's not very
> considerate for folks who prefer a different one.
>   
Don't know what to say more then: Yup! :)

But the CodeStyle-document and checkpatch.pl does not agree with that.

