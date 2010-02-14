Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073Ab0BNVGQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 16:06:16 -0500
Received: from mail.lang.hm ([64.81.33.126]:59820 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543Ab0BNVGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 16:06:15 -0500
Date: Sun, 14 Feb 2010 13:04:45 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Pavel Machek <pavel@ucw.cz>, Jean Delvare <khali@linux-fr.org>,
       Willy Tarreau <w@1wt.eu>, mirrors@kernel.org, lasse.collin@tukaani.org,
       linux-kernel <linux-kernel@vger.kernel.org>, users@kernel.org,
       "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [kernel.org users] XZ Migration discussion
In-Reply-To: <4B784378.8070309@s5r6.in-berlin.de>
Message-ID: <alpine.DEB.2.00.1002141302210.5135@asgard.lang.hm>
References: <4B744E13.8040004@kernel.org> <20100212150137.648dca7c@hyperion.delvare> <alpine.LFD.2.00.1002120714320.7792@localhost.localdomain> <4B75A5DC.3060803@kernel.org> <20100212202357.6363d5af@hyperion.delvare> <20100212230702.GA10266@1wt.eu>
 <20100213091748.276821e1@hyperion.delvare> <20100214170724.GE1578@ucw.cz> <4B784378.8070309@s5r6.in-berlin.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Feb 2010, Stefan Richter wrote:

> Pavel Machek wrote:
> [Jean Delvare wrote]
>>> I have an old, slow machine here which I am going to use to perform
>>> some real world testing, and I'll post the results when I'm done. But I
>>> suspect that building a kernel on this machine, even a small one with
>>> just the drivers it needs, will take much longer than unpacking the
>>> sources. So anyone worrying about performance would rather rely on
>>> cross-compilation, and in turn can afford whatever decompression tool
>>> is needed.
>>
>> On zaurus, kernel compilation takes 4 hours. (I.e. "one night"). So
>> that one is ... well ... done overnight.
>>
>> Untar is something I normally wait for, since you need to run
>> (interactive) oldconfig after that.
>
> If the download takes m minutes and unpacking and unarchiving tar.gz
> takes another n minutes, what difference does it make for this workflow
> when instead m + p minutes are spent for download + unpacking and
> unarchiving tar.bz2 or tar.xz?

The difference is that the user is waiting for the n or m minutes, but 
goes off and does something else for the p minutes.

So it doesn't really matter if the compile takes 1 hour or 6 hours. As 
Pavel noted, this is done overnight and it doesn't matter if it gets done 
at 2am or 6am.

But the uncompression has a user waiting for it (to do the config step), 
so here it makes a big difference if it takes 6 minutes ot 8 minutes.

David Lang
