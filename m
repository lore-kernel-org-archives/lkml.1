Return-Path: <linux-kernel-owner+w=401wt.eu-S1752579AbZILJDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbZILJDu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 05:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbZILJDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 05:03:49 -0400
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:41321 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751097AbZILJDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 05:03:49 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-17.arcor-online.net DA9033B25AE
Message-ID: <4AAB63F8.1060301@arcor.de>
Date: Sat, 12 Sep 2009 12:03:52 +0300
From: Nikos Chantziaras <realnc@arcor.de>
Organization: Lucas Barks
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090826 Thunderbird/3.0b3
MIME-Version: 1.0
To: Volker Armin Hemmann <volkerarmin@googlemail.com>
CC: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Con Kolivas <kernel@kolivas.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
References: <200909112033.34445.volkerarmin@googlemail.com> <4AAB4FC9.4060402@arcor.de> <200909121027.08244.volkerarmin@googlemail.com>
In-Reply-To: <200909121027.08244.volkerarmin@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2009 11:27 AM, Volker Armin Hemmann wrote:
> Hi,
>
> On Samstag 12 September 2009, Nikos Chantziaras wrote:
>>
>> On 09/11/2009 09:33 PM, Volker Armin Hemmann wrote:
>>>
>>> this is with 2.6.31+reiser4+fglrx
>>> Phenom II X4 955
>>>
>>> KDE 4.3.1, composite temporary disabled.
>>> tvtime running.
>>>
>>> load:
>>> fat emerge with make -j5 running in one konsole tab (xulrunner being
>>> compiled).
>>>
>>> without NO_NEW_FAIR_SLEEPERS:
>>>
>>> tvtime is smooth most of the time
>>>
>>> with NO_NEW_FAIR_SLEEPERS:
>>>
>>> tvtime is more jerky. Very visible in scenes with movement.
>>
>> Is the make -j5 running niced 0?
>
> yes. It always is.
>
>> If yes, that would be actually the
>> correct behavior.
>
> maybe. But I do not complain about jerks at all. I have
>
> [ 3618.305918] hpet1: lost 1 rtc interrupts
>
> with tvtime running since I switched cpus - so something is wrong anyway.

Seeing the "lost 1 rtc interrupts" message makes me wonder if this could 
possibly relate to problems with the C1E state on AMD systems (missing 
timer interrupts):

   http://lkml.org/lkml/2008/6/12/127

That thread is one year old though and your Phenom II CPU was released 7 
months later.
