Return-Path: <linux-kernel-owner+w=401wt.eu-S966007AbYEBP7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966007AbYEBP7Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 11:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934394AbYEBPzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 11:55:23 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:54039 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934286AbYEBPzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 11:55:21 -0400
Message-ID: <481B395E.5070505@krogh.cc>
Date: Fri, 02 May 2008 17:55:10 +0200
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Many open/close on same files yeilds "No such file or directory".
References: <4819E316.7000607@krogh.cc>	 <20080501223938.921f7cd2.akpm@linux-foundation.org>	 <481ACEC4.2040205@krogh.cc> <481B3115.30705@krogh.cc> <2c0942db0805020847q2fdc0480m3eb892bf2bd0b3a@mail.gmail.com>
In-Reply-To: <2c0942db0805020847q2fdc0480m3eb892bf2bd0b3a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ray Lee wrote:
> On Fri, May 2, 2008 at 8:19 AM, Jesper Krogh <jesper@krogh.cc> wrote:
>> Jesper Krogh wrote:
>>
>>>> I'd suspect that after 1e8 loops your CPU got too hot and started to
>>>> misbehave.
>>>>
>>> Hardware is an Sun Fire X4600 (8xdual-core AMD64 processors). The
>>> problem seem to be tied to this filesystem. (I cannot havent been able
>>> to reproduce it on the /-mounted disk of the same system. So if a cpu
>>> problem.. then it shouldn't be tied to a specific filesystem?
>>>
>>> This is the only activity on the system .. so a load of 1 / 16cpus.
>>>
>>  I've tried to explore this suggestion (the best I could).
>>
>>  There are 2 ext3 filesystems locally mounted. / and this one. Running 16
>> parallel runs of this program on a file on the /-mounted filesystem cannot
>> reproduce the problem. If it was linked to hot hardware, I believe I should
>> be able to reproduce it this way. The servers are in a 17 degress
>> serverroom.
>>
>>  It changes alot when.. it actually happens. The "earliest ones" has been
>> from 200000 cycles.
> 
> Run 16 in parallel on /, and another 16 simultaneously on the trouble
> filesystem? If you continue to get errors only on the 'trouble'
> filesystem, and no errors start occurring on / coincident, then it
> sounds pretty localized.

That test has been done. I can only reproduce it on this filesystem. But 
I cannot really conclude that it is only present there.. since sometimes 
my testprogram just goes on .. and dies past 1 billion cycles. But I 
have never gotten errors from the / filesystem on the same installation.

> BTW, I may have missed this earlier, but does it happen *anywhere* on
> the troublesome filesystem (ie, in a newly created subdirectory)?

I'll run that test now.

-- 
Jesper
