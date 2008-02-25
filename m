Return-Path: <linux-kernel-owner+w=401wt.eu-S1760087AbYBYV4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760087AbYBYV4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 16:56:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759890AbYBYV4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 16:56:23 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:45734 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759849AbYBYV4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 16:56:22 -0500
Message-ID: <47C33982.8030902@student.ltu.se>
Date: Mon, 25 Feb 2008 22:56:18 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Tabs, spaces, indent and 80 character lines
References: <47C0BEE7.4040409@student.ltu.se>	<m3ejb2bdxx.fsf@maximus.localdomain> <47C19001.7010609@student.ltu.se> <m3ablqb6jl.fsf@maximus.localdomain>
In-Reply-To: <m3ablqb6jl.fsf@maximus.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> Richard Knutsson <ricknu-0@student.ltu.se> writes:
>
>   
>>> I guess we could use tabs only at the line start, for indentation
>>> only. Rather hard to implement, most text editors can't do that yet.
>>>   
>>>       
>> You mean for split lines?
>>     
>
> Syntactic indentation vs alignment (including comments after
> non-blank, values for struct initialization etc, split lines too).
>
>   
'alignment', that's the word, thanks!
>> Hopefully there won't be that many, so there
>> is just to delete the tabs it added and replace it with spaces.
>>     
>
> Actually tabs "should" be used for indentation at start of the
> line, then spaces. "Ideally" :-)
>
> I.e., something like
> <TAB>	if (cond && (cond2 ||
> <TAB>	_____________cond3))
> <TAB>	<TAB>	do_something();
>
> Underline = space.
>
> Perhaps some day...
>
>   
>> Exactly! But then we can remove the "we use 8 wide tabs in the kernel"
>> in CodeStyle.
>>     
>
> I'm not sure it's practically possible now.
>   
Well, can always patch CodeStyle and checkpatch.pl and then see what the 
rest thinks.

Think checkpatch is fairly easy to "fix". It seems to have all the lines 
in an array so there is only a need to check the indent-depth of the 
line above and see if the current is the same with only spaces afterwards.

The idea was to reply with a patch, but it is bit late now.
>   
>>> Unpacked sources will be much bigger with not tabs, sure.
>>>   
>>>       
>> Without no tabs at all, you mean?
>>     
>
> With spaces in place of all tabs.
>
> All tabs converted to spaces = 20% more?
> "Alignment" tabs converted to spaces? How cares how much more would it
> take if it's the correct thing. Except that it's not very practical at
> this point.
>   
Would guess more...
The reason I reacted were because checkpatch.pl complained about a:
<tab><tab>foo(int a,
<tab><tab>____int b)
with the "use tabs not spaces". There is little point in patching this 
stuff but lets not make it worse (IMHO).

