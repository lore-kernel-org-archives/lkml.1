Return-Path: <linux-kernel-owner+w=401wt.eu-S1757352AbZDUKNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352AbZDUKNz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 06:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755290AbZDUKNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 06:13:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52541 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752852AbZDUKNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 06:13:45 -0400
Message-ID: <49ED9C91.4070201@cn.fujitsu.com>
Date: Tue, 21 Apr 2009 18:14:41 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tracing/filters: disallow newline as delimeter
References: <49ED8DD2.2070700@cn.fujitsu.com> <49ED8DFD.9070909@cn.fujitsu.com> <20090421095705.GA15448@elte.hu> <49ED9AC2.9000507@cn.fujitsu.com> <20090421100722.GA18486@elte.hu>
In-Reply-To: <20090421100722.GA18486@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>> Ingo Molnar wrote:
>>> * Li Zefan <lizf@cn.fujitsu.com> wrote:
>>>
>>>> I guess because user input is often ended with '\n' (like "echo 
>>>> xxx"), thus '\n' is used as a delimeter besides ' ', but we can 
>>>> just strip tailing spaces.
>>> Hm, how about:
>>>
>>> ( echo 'x'
>>>   echo '|| y' ) > filter
>>>
>>> type of scripts? Shouldnt the parser be permissive in general?
>>>
>> This patch doesn't forbid this usage: ;)
>>
>> ( echo 'parent_comm == a'
>>   echo '|| parent_comm == b' ) > filter
>>
>> This patch does forbid this usage:
>>
>> ( echo 'parent_comm'
>>   echo '=='
>>   echo 'a' ) > filter
> 
> Same argument though, no?
> 

Then I have no strong opinion on this. I'm fine to drop this patch.


