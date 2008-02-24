Return-Path: <linux-kernel-owner+w=401wt.eu-S1754787AbYBXQP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbYBXQP3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 11:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbYBXQPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 11:15:14 -0500
Received: from wr-out-0506.google.com ([64.233.184.225]:32864 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbYBXQPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 11:15:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:sender;
        b=V6y5oekmNO4dNoEp2RkgEJ8o31xFZa+1hqCJZ+FlpCA/rC16M86UyhRKMypcgXnerm60SlBebH8Kqx9GDEdn8Lj/IRbtpuuYHKmqOh6Kg8e+zDg4m01Eic3U0R6T2dARWOwks4yEhMeEVirsd+7uvSaPBuMipPnF+/6YHUn+1LI=
Message-ID: <47C1980C.4050800@panasas.com>
Date: Sun, 24 Feb 2008 08:15:08 -0800
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Richard Knutsson <ricknu-0@student.ltu.se>
CC: Krzysztof Halasa <khc@pm.waw.pl>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Tabs, spaces, indent and 80 character lines
References: <47C0BEE7.4040409@student.ltu.se> <m3ejb2bdxx.fsf@maximus.localdomain> <47C19001.7010609@student.ltu.se>
In-Reply-To: <47C19001.7010609@student.ltu.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb. 24, 2008, 7:40 -0800, Richard Knutsson <ricknu-0@student.ltu.se> wrote:
> Krzysztof Halasa wrote:
>> Richard Knutsson <ricknu-0@student.ltu.se> writes:
>>
>>   
>>> Why hinder a developer who prefer
>>> 2, 4, 6 or any other != 8 width?
>>>     
>> I guess we could use tabs only at the line start, for indentation
>> only. Rather hard to implement, most text editors can't do that yet.
>>   
> You mean for split lines? Hopefully there won't be that many, so there 
> is just to delete the tabs it added and replace it with spaces.

IMO, tabs SHOULD be used for syntactic indentation and spaces for
decoration purpose only.  I.e. a line should start with a number of tabs
equal to its nesting level and after that only spaces should be used.
for example, the following code

for (i = 0; i < n; i++) printk("a very long format string", some, parameters);

should be formatted like this:

<tabs...>for (i = 0; i < n; i++)
<tabs...><tab>printk("a very long format string",
<tabs...><tab>       some, parameters);

this will show exactly right regardless of your editor's tab expansion setting
as long as you use fixed-width fonts - where the screen width of the space character
is equal to all other characters.  Once you start using tabs instead of spaces
to push text right so it appears exactly below some other text on the line above
you make a dependency on *your* editor's tab expansion policy and that's not very
considerate for folks who prefer a different one.


>>   
>>> By only using tabs as indents, and
>>> changing the CodeStyle to be something like "maximum 80
>>> characters-wide lines, with a tab-setting of 8 spaces",
>>>     
>> This changes nothing.
>>   
> Exactly! But then we can remove the "we use 8 wide tabs in the kernel" 
> in CodeStyle.
>>   
>>> that is
>>> possible + easier to write code-checkers [2].
>>>     
>> I doubt it.
>>   
> Easier to write code-checkers? OK, maybe not. Just that I got hit by 
> this problem at a time when I wrote a simple checker (don't remember its 
> purpose).
>>   
>>> Or are we really that concerned about the disk-space? ;)
>>>     
>> Unpacked sources will be much bigger with not tabs, sure.
>>   
> Without no tabs at all, you mean? Don't want to think about that 
> scenario, but with this suggestion, I would estimate maybe 0,5 - 1% bigger.
> 
> Thanks for your input
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

