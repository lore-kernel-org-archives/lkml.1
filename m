Return-Path: <linux-kernel-owner+w=401wt.eu-S932512AbZACV7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512AbZACV7y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 16:59:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbZACV7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 16:59:45 -0500
Received: from mail.lang.hm ([64.81.33.126]:39445 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbZACV7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 16:59:45 -0500
Date: Sat, 3 Jan 2009 15:01:48 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Pavel Machek <pavel@suse.cz>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: atomics: document that linux expects certain atomic behaviour
 from unsigned long
In-Reply-To: <20090103205628.GE1666@elf.ucw.cz>
Message-ID: <alpine.DEB.1.10.0901031459010.23262@asgard.lang.hm>
References: <20090103124400.GA1572@ucw.cz> <20090103201955.186974bb@lxorguk.ukuu.org.uk> <20090103202740.GC1666@elf.ucw.cz> <20090103203044.0166b561@lxorguk.ukuu.org.uk> <20090103205628.GE1666@elf.ucw.cz>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Jan 2009, Pavel Machek wrote:

> On Sat 2009-01-03 20:30:44, Alan Cox wrote:
>>> If it is okay and linux relies on it, it should be documented.
>>>
>>> If it is not okay, I guess we should document it, too -- it seems to
>>> be common mistake.
>>
>> A lot of old code did it knowing it was under the BKL, outside of the BKL
>> its a very bad idea. There were lots of them in the tty layer and I don't
>> doubt there are some left I missed too 8(
>
> I have seen this in new code (some LED driver last time), definitely
> no BKL.
>
> Is there concrete architecture where it breaks? I'd expect i386/x86-64
> to be safe, and pretty much everyone to be safe as long as that long
> is aligned.... or that was the result of arch-maintainers
> discussion...
>
> I'd really like to document if it is right or not, so that I can point
> people to documentation...

you may want to take a look at the new C/C++/POSIX standards (some just 
standardized, some still in development), they explicitly address this 
area.

David Lang
