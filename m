Return-Path: <linux-kernel-owner+w=401wt.eu-S1764181AbZLQJQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764181AbZLQJQq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 04:16:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759325AbZLQJQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 04:16:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:44663 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756435AbZLQJQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 04:16:43 -0500
Message-ID: <4B29F78B.4080908@kernel.org>
Date: Thu, 17 Dec 2009 18:19:07 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>
CC: law_ence.dev@ntlworld.com, Mark Hounschell <markh@compro.net>,
       linux-kernel@vger.kernel.org
Subject: Re: Unable to format or use floppies since 2.6.28
References: <4B215007.4030703@compro.net> <hfvo0q$pvp$1@ger.gmane.org> <2375c9f90912170104s522f0b1bqe0ae76f42e8abf51@mail.gmail.com>
In-Reply-To: <2375c9f90912170104s522f0b1bqe0ae76f42e8abf51@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/17/2009 06:04 PM, Américo Wang wrote:
> On Sat, Dec 12, 2009 at 5:33 PM, ael <ael@none.none> wrote:
>> Mark Hounschell wrote:
>>>
>>> I have many boxes. They all do the same thing. Running different versions
>>> of SuSE, 10.3-11.2. Any kernel at or above 2.6.28 fails to fdformat a
>>> floppy. These same machines, using the same floppies and drives, running
>>> kernels older than 2.6.28 work just fine. I googled and found other such
>>> reports but no solution. I know better than to just assume it's a kernel bug
>>> but it sure looks like it could be so I'm inquiring about it here.

Hmmm... Strange.

>>> # fdformat /dev/fd0u1440
>>> Double-sided, 80 tracks, 18 sec/track. Total capacity 1440 kB.
>>> Formatting ... done
>>> Verifying ... Problem reading cylinder 1, expected 18432, read 2048
>>
>> Similar problems on debian testing: see
>> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=548434
>>
>> However, fdformat is ok on Gentoo under 2.6.31 and also on Ubuntu
>> 2.6.32-rc6, so it seems it is not just the kernel version in any
>> simplistic way.

Double strange.

>> A git-bisect seems the obvious next step?
> 
> Wait...
> 
> There are only 13 changes related to floppy since 2.6.28, kick out 2 changes
> which just did some constifying, there are 11 only.
> 
> The most suspicious one should be commit 1011c1b9f2e from Tejun.
> 
> Mark, reverting that patch can help?

I don't think you can back that single patch out.  There were a lot of
cleanups in request handling after that.  How about trying 2.6.32
vanilla kernel?  Does it work?  How about copying fdformat from suse
to gentoo?

Thanks.

-- 
tejun
