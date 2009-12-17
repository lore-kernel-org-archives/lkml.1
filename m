Return-Path: <linux-kernel-owner+w=401wt.eu-S1764170AbZLQJEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764170AbZLQJEX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 04:04:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbZLQJEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 04:04:16 -0500
Received: from mail-qy0-f194.google.com ([209.85.221.194]:55883 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbZLQJED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 04:04:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=NFSdz/d0xU2xxudNOxiRYpR8zsPkVJWkoZze0U5yK9qpl5CW46nidRDruO39OKRmQE
         LktU8hd5mtLbEXbwCZJJnDLf7cOcCf/FbGbwSGRD7VKcf3FOPhJOVCAAz6hsBTQ4QM6p
         LTmC3L343RXBeWaw9j9G6eKf7ISlOKrncrTCg=
MIME-Version: 1.0
In-Reply-To: <hfvo0q$pvp$1@ger.gmane.org>
References: <4B215007.4030703@compro.net> <hfvo0q$pvp$1@ger.gmane.org>
Date: Thu, 17 Dec 2009 17:04:01 +0800
Message-ID: <2375c9f90912170104s522f0b1bqe0ae76f42e8abf51@mail.gmail.com>
Subject: Re: Unable to format or use floppies since 2.6.28
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: law_ence.dev@ntlworld.com, Mark Hounschell <markh@compro.net>,
       Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 12, 2009 at 5:33 PM, ael <ael@none.none> wrote:
> Mark Hounschell wrote:
>>
>> I have many boxes. They all do the same thing. Running different versions
>> of SuSE, 10.3-11.2. Any kernel at or above 2.6.28 fails to fdformat a
>> floppy. These same machines, using the same floppies and drives, running
>> kernels older than 2.6.28 work just fine. I googled and found other such
>> reports but no solution. I know better than to just assume it's a kernel bug
>> but it sure looks like it could be so I'm inquiring about it here.
>>
>> # fdformat /dev/fd0u1440
>> Double-sided, 80 tracks, 18 sec/track. Total capacity 1440 kB.
>> Formatting ... done
>> Verifying ... Problem reading cylinder 1, expected 18432, read 2048
>
> Similar problems on debian testing: see
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=548434
>
> However, fdformat is ok on Gentoo under 2.6.31 and also on Ubuntu
> 2.6.32-rc6, so it seems it is not just the kernel version in any
> simplistic way.
>
> A git-bisect seems the obvious next step?
>

Wait...

There are only 13 changes related to floppy since 2.6.28, kick out 2 changes
which just did some constifying, there are 11 only.

The most suspicious one should be commit 1011c1b9f2e from Tejun.

Mark, reverting that patch can help?
