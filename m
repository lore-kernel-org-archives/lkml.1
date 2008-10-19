Return-Path: <linux-kernel-owner+w=401wt.eu-S1752606AbYJSBus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbYJSBus (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 21:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbYJSBuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 21:50:40 -0400
Received: from mail.lang.hm ([64.81.33.126]:56521 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbYJSBuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 21:50:40 -0400
Date: Sat, 18 Oct 2008 18:50:27 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Jiri Kosina <jkosina@suse.cz>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Steven Noonan <steven@uplinklabs.net>, Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
In-Reply-To: <alpine.LRH.1.10.0810190108160.2000@twin.jikos.cz>
Message-ID: <alpine.DEB.1.10.0810181848430.11267@asgard.lang.hm>
References: <20081016002509.GA25868@kroah.com> <20081017204723.15114eaa@lxorguk.ukuu.org.uk> <20081017214409.GB3585@kroah.com> <200810180049.19014.rjw@sisk.pl> <alpine.DEB.1.10.0810171821500.11079@asgard.lang.hm>
 <alpine.LRH.1.10.0810190108160.2000@twin.jikos.cz>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Oct 2008, Jiri Kosina wrote:

> On Fri, 17 Oct 2008, david@lang.hm wrote:
>
>>> Surely some scripts will start to break as soon as the third number gets
>>> three digits.
>> we've had three digit numbers in the third position before (2.3 and 2.5
>> went well past three digits IIRC)
>
> Did we? I only recall 2.5.7[something] and 2.3.5[something] (plus special
> 2.3.99 release).

I know some versions have (I remember deploying 2.1.116 on a box across 
the country with no way to get at it afterwords)

>>> Actually, I thought we could continue to use a w.x.y.z numbering
>>> scheme, but in such a way that:
>>> w = ($year - 2000) / 10 + 2 (so that we start from 2)
>>> x = $year % 10
>>> y = (number of major release in $year)
>>> z = (number of stable version for major release w.x.y)
>>> Then, the first major release in 2009 would be 2.9.1 and its first
>>> -stable "child" would become 2.9.1.1.  In turn, the first major
>>> release in 2010 could be 3.0.1 and so on.
>> if you want the part of the version number to increment based on the year,
>> just make it the year and don't complicate things.
>
> In addition to that, having the kernel version dependent on year doesn't
> really seem to make much sense to me. Simply said, I don't see any
> relation of kernel source code contents to the current date in whatever
> calendar system.

it does give an indication of how out of date the kernel you are using is.

> And 2.x+1.y-rcZ+1 immediately following 2.x.y-rcZ really hurts my eyes :)

that I agree with.

David Lang
