Return-Path: <linux-kernel-owner+w=401wt.eu-S1753488AbXE3Mn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbXE3Mn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 08:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbXE3Mnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 08:43:50 -0400
Received: from linux.dunaweb.hu ([62.77.196.1]:39301 "EHLO linux.dunaweb.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513AbXE3Mnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 08:43:49 -0400
Message-ID: <465D7177.4000804@dunaweb.hu>
Date: Wed, 30 May 2007 14:43:35 +0200
From: Zoltan Boszormenyi <zboszor@dunaweb.hu>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, support@mailbox.cps.intel.com
Subject: Re: Kernel 2.6.21.3 does not work with 8GB of RAM on Intel 965WH
References: <465D43C0.60609@dunaweb.hu> <Pine.LNX.4.64.0705300712230.5844@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0705300712230.5844@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz írta:
>
>
> On Wed, 30 May 2007, Zoltan Boszormenyi wrote:
>
>> Hi,
>>
>>> Look at how slow the raid benchmarks are in dmesg with 8GB of memory!
>>>
>>> [   59.592560] raid6: using algorithm sse2x4 (476 MB/s)
>>> [   59.597558] raid5: using function: generic_sse (56.000 MB/sec)
>>>
>>> Yikes!
>>>
>>> With mem=4096M:
>>> [   60.336352] raid6: using algorithm sse2x4 (6804 MB/s)
>>> [   60.341345] raid5: using function: generic_sse (8552.000 MB/sec)
>>>
>>> What is going on here?
>>>
>>> Justin.
>>
>> I saw a similar effect on a P5 board that could
>> only cache 64MB of memory a long time ago.
>> Putting more memory into it made the machine slower
>> and e.g. made the sym2 driver giving up at initialization.
>> Maybe it's a modern reincarnation of the problem?
>>
>> Best regards,
>> Zoltán Böszörményi
>>
>
> I see, so Intel 965 motherboards do not work with 8GB of memory?  Or 
> is this a Linux issue?

It was certainly a mainboard problem, the same system worked well
on another board with a more capable L2 cache controller.
Or on PPro/P-II boards.

> I have an Intel Case ID open 225446 but so far we have not gotten 
> anywhere with this problem.  Currently I have 8GB in the machine and 
> boot with mem=4096M.  Was there any type of fix?  Any recommendations 
> as to what I can do?  Continue to speak with Intel?  Or perhaps 
> someone with more knowledge of the kernel and chime in as to what 
> exactly is happening here?
>
> Justin.

I think continue to talk Intel and with the kernel guys,
I don't have experience with machines with so much memory (yet).

Best regards,
Zoltán Böszörményi

