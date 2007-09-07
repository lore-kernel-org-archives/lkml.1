Return-Path: <linux-kernel-owner+w=401wt.eu-S965827AbXIGO0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965827AbXIGO0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 10:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965565AbXIGOZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 10:25:56 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:32101 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965537AbXIGOZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 10:25:55 -0400
Message-ID: <46E15F2B.3080607@oracle.com>
Date: Fri, 07 Sep 2007 07:24:43 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 8/8] Immediate Values - Documentation
References: <20070906200228.086651361@polymtl.ca> <20070906200316.343198308@polymtl.ca> <20070906142033.c0047718.randy.dunlap@oracle.com> <20070907122353.GB9735@Krystal>
In-Reply-To: <20070907122353.GB9735@Krystal>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Randy Dunlap (randy.dunlap@oracle.com) wrote:
> [fixing the rest of the comments in the patch]
>> What character is this that I cannot read (not displayed properly
>> by my email client maybe)?  <something> after 644.09 and before the
>> +- symbol, repeated just before all of the +- symbols.
>>
> 
> This file seems to be UTF-8 and the mail has been send by quilt. Is it
> ok or should I change this to +/- just to make sure ?

I think that most people on lkml say that UTF-8 is OK in text doc files.


>>> +Getppid without memory pressure:
>>> +1462.09±18.87 - 150.92±1.01 = 1311.17±18.90 cycles
>>> +
>>> +Getppid with memory pressure:
>>> +17113.33±1655.92 - 578.22±269.51 = 16535.11±1677.71 cycles
>>> +
>>> +Therefore, if we add 2 markers not based on immediate values to the getppid
>>> +code, which would add 2 memory reads, we would add
>>> +2 * 555.93±12.74 = 1111.86±25.48 cycles
>>> +
>>> +Therefore,
>>> +
>>> +1111.86±25.48 / 16535.11±1677.71 = 0.0672
>>> + relative error: sqrt(((25.48/1111.86)^2)+((1677.71/16535.11)^2))
>>> +                     = 0.1040
>>> + absolute error: 0.1040 * 0.0672 = 0.0070
>>> +
>>> +Therefore: 0.0672±0.0070 * 100% = 6.72±0.70 %
>>> +
>>> +We can therefore affirm that adding 2 markers to getppid, on a system with high
>>> +memory pressure, would have a performance hit of at least 6.0% on the system
>>> +call time, all within the uncertainty limits of these tests. The same applies to
>>> +other kernel code paths. The smaller those code paths are, the highest the
>>> +impact ratio will be.
>>> +
>>> +Therefore, not only is it interesting to use the immediate values to dynamically
>>> +activate dormant code such as the markers, but I think it should also be
>>> +considered as a replacement for many of the "read mostly" static variables.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
