Return-Path: <linux-kernel-owner+w=401wt.eu-S1754373AbZLXMHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbZLXMHv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 07:07:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbZLXMHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 07:07:50 -0500
Received: from mail.klingt.org ([86.59.21.178]:59420 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286AbZLXMHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 07:07:49 -0500
Message-ID: <4B335964.6040202@klingt.org>
Date: Thu, 24 Dec 2009 13:07:00 +0100
From: Tim Blechmann <tim@klingt.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7pre) Gecko/20091219 Shredder/3.0.1pre
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, stern@rowland.harvard.edu, x86@kernel.org
Subject: Re: 2.6.32 regression: unable to handle kernel paging request
References: <4B269765.1070703@klingt.org> <4B2A2A7D.1050506@klingt.org> <4B2A93F2.3070407@klingt.org> <4B2AFBB1.3040609@kernel.org> <4B2B4838.6080509@klingt.org> <4B2F20E0.30804@kernel.org> <4B2F40C0.5020407@klingt.org> <4B33592B.6000107@kernel.org>
In-Reply-To: <4B33592B.6000107@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.4 (klingt.org [127.0.0.1]); Thu, 24 Dec 2009 13:07:01 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>>> removing module-common.lds from LDFLAGS_MODULE, my machine boots fine
>>>>>> and without any error messages:
>>>>>
>>>>> Looks like some necessary part of module image ends up in discarded
>>>>> sections.  Before the commit, the build process kept those sections so
>>>>> it worked.  The code has been there for some time now and you're the
>>>>> first one to report it, so I suppose your .config is a bit different
>>>>> from more usual ones.  Can you please attach it?
>>>>
>>>> it is not too different ... it is based on the .config file of the
>>>> ubuntu kernel with a few tweaks ...
>>>> one odd thing is, that i once was able to boot 2.6.32-rcX kernels, at
>>>> one point, i kept getting these bug messages ... i didn't (knowingly)
>>>> change the configuration, though ...
>>>
>>> Hmmm... weirdly I can't reproduce the problem here with the same
>>> config.  Can you please attach "readelf -a lp.ko" with and without the
>>> module-common.lds struck out?
>>
>> as i said before, the configuration is not really uncommon ... the
>> readelf output is attached.
>
> Hmmm.... I think it's more convoluted than I originally thought.  I
> was expecting a missing section but in the broken case the linker has
> assigned addresses to sections even though it was a relocatable link.
> That's just strange.
>
> Can you please post the output of "ld --version"?  Also, what distro
> are you on?

i am not at that specific machine, but the distribution is the same as 
on my laptop, ubuntu 9.10, x86-64. i don't have any issues, running 
2.6.32.2 on my laptop, though ...

GNU ld (GNU Binutils for Ubuntu) 2.20

hth, tim

-- 
tim@klingt.org
http://tim.klingt.org

Bill Gates left his university to start Micro$oft.
Steve Jobs sold his Wolkswagen bus to start Apple.
Linus Torvalds made a new thread in a forum and put a file on a ftp server.
