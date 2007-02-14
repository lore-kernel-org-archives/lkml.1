Return-Path: <linux-kernel-owner+w=401wt.eu-S932155AbXBNH2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155AbXBNH2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 02:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932158AbXBNH2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 02:28:18 -0500
Received: from comtv.ru ([217.10.32.17]:62887 "EHLO comtv.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932155AbXBNH2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 02:28:17 -0500
X-UCL: actv
Date: Wed, 14 Feb 2007 10:28:46 +0300 (MSK)
From: malc <av1474@comtv.ru>
X-X-Sender: malc@home.oyster.ru
To: Con Kolivas <kernel@kolivas.org>
cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: CPU load
In-Reply-To: <200702140908.44934.kernel@kolivas.org>
Message-ID: <Pine.LNX.4.64.0702141023000.672@home.oyster.ru>
References: <loom.20070212T063225-663@post.gmane.org> <20070212143219.GB5226@ucw.cz>
 <Pine.LNX.4.64.0702140059390.727@home.oyster.ru> <200702140908.44934.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Feb 2007, Con Kolivas wrote:

> On Wednesday 14 February 2007 09:01, malc wrote:
>> On Mon, 12 Feb 2007, Pavel Machek wrote:
>>> Hi!

[..snip..]

>>> I have (had?) code that 'exploits' this. I believe I could eat 90% of cpu
>>> without being noticed.
>>
>> Slightly changed version of hog(around 3 lines in total changed) does that
>> easily on 2.6.18.3 on PPC.
>>
>> http://www.boblycat.org/~malc/apc/load-hog-ppc.png
>
> I guess it's worth mentioning this is _only_ about displaying the cpu usage to
> userspace, as the cpu scheduler knows the accounting of each task in
> different ways. This behaviour can not be used to exploit the cpu scheduler
> into a starvation situation. Using the discrete per process accounting to
> accumulate the displayed values to userspace would fix this problem, but
> would be expensive.

Guess you are right, but, once again, the problem is not so much about
fooling the system to do something or other, but confusing the user:

a. Everything is fine - the load is 0%, the fact that the system is
    overheating and/or that some processes do not do as much as they
    could is probably due to the bad hardware.

b. The weird load pattern must be the result of bugs in my code.
    (And then a whole lot of time/effort is poured into fixing the
     problem which is simply not there)

The current situation ought to be documented. Better yet some flag can
be introduced somewhere in the system so that it exports realy values to
/proc, not the estimations that are innacurate in some cases (like hog)

-- 
vale
