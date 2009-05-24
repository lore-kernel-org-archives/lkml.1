Return-Path: <linux-kernel-owner+w=401wt.eu-S1755763AbZEXA70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763AbZEXA70 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 20:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753582AbZEXA7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 20:59:18 -0400
Received: from mail.tmr.com ([64.65.253.246]:51053 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753508AbZEXA7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 20:59:17 -0400
Message-ID: <4A189BDA.5050002@tmr.com>
Date: Sat, 23 May 2009 20:59:06 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Jon <jg@jguk.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: dd if=/dev/random of=data.bin bs=512 count=1
References: <19ac3f7a0905170822q28255239nea01b56d52e3ddf8@mail.gmail.com> <2f11576a0905170901x41e15f65sf10bb5ee36050d14@mail.gmail.com> <4A184ABB.1070902@jguk.org>
In-Reply-To: <4A184ABB.1070902@jguk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon wrote:
> Hello KOSAKI,
> 
> Thank you for your reply.
> 
> KOSAKI Motohiro wrote:
>>> Hello
>>>
>>> Issuing this command, I expected to get a file 4096 bytes in size.
>>> Could someone let me know if I have missed something..? Or is there a
>>> problem with using /dev/random this way?
>>>
>>> if I have a count=10 it hangs forever (several hours).
>>>
>>> Changing to use /dev/urandom and it generates the file ok.
>>
>> you already have the answer. /dev/random might blocked, /dev/urandom 
>> doesn't.
> 
> Is this a "feature" of /dev/random ? ..it does not seem very useful to 
> have it able to block for so long.
> 
Of course. /dev/random generates better random numbers (in the sense of less 
predictable), while /dev/urandom gives you some pseudo-random bits, which mat or 
may not be appropriate for your task. For timing disk speed /dev/zero is faster 
and less overhead.

> Please include my email address in replies,  as I'm not a member of this 
> list.
> 
> Best regards, Jon


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
