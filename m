Return-Path: <linux-kernel-owner+w=401wt.eu-S1757472AbYAYMfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbYAYMfi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 07:35:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754609AbYAYMfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 07:35:30 -0500
Received: from orion2.pixelized.ch ([195.190.190.13]:44408 "EHLO
	mail.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627AbYAYMf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 07:35:29 -0500
Message-ID: <4799D770.2070203@cateee.net>
Date: Fri, 25 Jan 2008 13:34:56 +0100
From: "Giacomo A. Catenazzi" <cate@cateee.net>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Valdis.Kletnieks@vt.edu, Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.24
References: <alpine.LFD.1.00.0801241506500.15329@hp.linux-foundation.org> <4799A773.2030702@cateee.net> <22000.1201255093@turing-police.cc.vt.edu> <200801251258.08707.rjw@sisk.pl>
In-Reply-To: <200801251258.08707.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Friday, 25 of January 2008, Valdis.Kletnieks@vt.edu wrote:
>> On Fri, 25 Jan 2008 10:10:11 +0100, "Giacomo A. Catenazzi" said:
>>
>>> - you will introduce a new step on git management:
>>>    Every changeset is compile-tested before going out to the world.
>>>    I think this can be done automatically, and I think that one or
>>>    two configurations are enough to find most of the problems.
>> It's true that a compile on x86 and a compile on PowerPC
> 
> Please add IA-64 and ARM at the very least.

My point was about "obvious" errors, and I really think that one
or two configuration will found most of these, doing in an
automatic way, and without delay the process.
Anyway more test are surely better.
BTW, IIRC there are already few "testing farms" which tests
automatically  a lot of environment and configuration (IIRC,
also run time tests).

>> should flush out 
>> most of the truly stupid mistakes, but those are usually found and fixed
>> literally within hours.  Anyhow, the proper time for test compiles is *before*
>> it goes into the git trees at all - it should have been tested before it
>> gets sent to a maintainer for inclusion.

few hours, but a lot of changeset will broke bisect (few doc tell
us how to continue bisecting on compile errors).
But I agree with you.

> 
> That's correct, but I'm not sure how to enforce it.

As usual, "One level more indirections" ;-) . Along a spamfilter,
we (or Linus) need a patch filter.

ciao
	cate

PS: I don't want to be pessimistic. I only want to raise the problem,
to see if it is possible to improve testing environment without
affecting the development of Linux.
