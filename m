Return-Path: <linux-kernel-owner+w=401wt.eu-S1755524AbYJRBX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbYJRBX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 21:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbYJRBXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 21:23:50 -0400
Received: from mail.lang.hm ([64.81.33.126]:38568 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbYJRBXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 21:23:50 -0400
Date: Fri, 17 Oct 2008 18:23:59 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Steven Noonan <steven@uplinklabs.net>, Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
In-Reply-To: <200810180049.19014.rjw@sisk.pl>
Message-ID: <alpine.DEB.1.10.0810171821500.11079@asgard.lang.hm>
References: <20081016002509.GA25868@kroah.com> <20081017204723.15114eaa@lxorguk.ukuu.org.uk> <20081017214409.GB3585@kroah.com> <200810180049.19014.rjw@sisk.pl>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Oct 2008, Rafael J. Wysocki wrote:

> On Friday, 17 of October 2008, Greg KH wrote:
>> On Fri, Oct 17, 2008 at 08:47:23PM +0100, Alan Cox wrote:
>>>> And that's my point here, do we want to change the current numbering
>>>> scheme as people have expressed annoyances of the current one.
>>>
>>> But any new scheme will be just as annoying to someone and it messes up
>>> existing documentation, understanding and risks breaking third party
>>> tools.
>>>
>>> Is it really worth the hassle, plus we'll have to change again if we use
>>> date/times because once we are shipping Linux out to Alpha Centauri with
>>> colonists there will be serious problems trying to compute the effect of
>>> tau on release numbering ...
>>
>> Sure, but by then, the 2.6.521 release will be out and we could fix it
>> up by finally going to 3.0 :)
>
> Surely some scripts will start to break as soon as the third number gets
> three digits.

we've had three digit numbers in the third position before (2.3 and 2.5 
went well past three digits IIRC)

>> Seriously, am I the only one that is getting annoyed by our version
>> numbers?  If so, I can live with it, but I got the feeling that I wasn't
>> alone here.
>
> Actually, I thought we could continue to use a w.x.y.z numbering scheme, but
> in such a way that:
>
> w = ($year - 2000) / 10 + 2 (so that we start from 2)
> x = $year % 10
> y = (number of major release in $year)
> z = (number of stable version for major release w.x.y)
>
> Then, the first major release in 2009 would be 2.9.1 and its first -stable
> "child" would become 2.9.1.1.  In turn, the first major release in 2010 could
> be 3.0.1 and so on.

if you want the part of the version number to increment based on the year, 
just make it the year and don't complicate things.

David Lang
