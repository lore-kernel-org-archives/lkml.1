Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822AbXLGPju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbXLGPju (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 10:39:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbXLGPjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 10:39:40 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:36282 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbXLGPjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 10:39:39 -0500
Message-ID: <475969AB.6040907@student.ltu.se>
Date: Fri, 07 Dec 2007 16:41:31 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: xiyou.wangcong@gmail.com, linux-kernel@vger.kernel.org,
       herbert@gondor.apana.org.au, akpm@osdl.org, netdev@vger.kernel.org
Subject: Re: [Patch] net/xfrm/xfrm_policy.c: Some small improvements
References: <20071206110123.GB2469@hacking>	<20071206.031434.179419183.davem@davemloft.net>	<4758093A.7010608@student.ltu.se> <20071206.192249.193354742.davem@davemloft.net>
In-Reply-To: <20071206.192249.193354742.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Richard Knutsson <ricknu-0@student.ltu.se>
> Date: Thu, 06 Dec 2007 15:37:46 +0100
>
>   
>> David Miller wrote:
>>     
>>> But this time I'll just let you know up front that I
>>> don't see much value in this patch.  It is not a clear
>>> improvement to replace int's with bool's in my mind and
>>> the other changes are just whitespace changes.
>>>   
>>>       
>> Is it not an improvement to distinct booleans from actual values? Do you 
>> use integers for ASCII characters too? It can also avoid some potential 
>> bugs like the 'if (i == TRUE)'...
>> What is wrong with 'size_t' (since it is unsigned, compared to (some) 
>> 'int')?
>>     
>
> When you say "int found;" is there any doubt in your mind that
> this integer is going to hold a 1 or a 0 depending upon whether
> we "found" something?
>
> That's the problem I have with these kinds of patches, they do
> not increase clarity, it's just pure mindless edits.
>   
But is there not a good thing if also the compiler knows + names are 
sometime not as clear as that one?
> In new code, fine, use booleans if you want.
>
> I would even accept that it helps to change to boolean for
> arguments to functions that are global in scope.
>
> But not for function local variables in cases like this.
>   
Oh, I see your point now. Believed it to be yet another 'booleans is not 
C idiom'.

Sorry about the noise
Richard Knutsson

