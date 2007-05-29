Return-Path: <linux-kernel-owner+w=401wt.eu-S1761093AbXE2N2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761093AbXE2N2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 09:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762675AbXE2N0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 09:26:39 -0400
Received: from mail.tmr.com ([64.65.253.246]:33344 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762734AbXE2N0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 09:26:38 -0400
Message-ID: <465C2A11.5070208@tmr.com>
Date: Tue, 29 May 2007 09:26:41 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Subject: Re: What causes iowait other than waiting for i/o?
References: <465B4B75.2040602@tmr.com> <a781481a0705282328u54a14143jc60194fcf7b5aa23@mail.gmail.com>
In-Reply-To: <a781481a0705282328u54a14143jc60194fcf7b5aa23@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> Hi Bill,
>
> On 5/29/07, Bill Davidsen <davidsen@tmr.com> wrote:
>> I recently noted that my system was spending a lot of time in i/o wait
>> when doing some tasks which I thought didn't involve i/o, as noted by
>> the lack of disk light activity most of the time. I thought of network,
>> certainly the NIC had no activity for this job. So I set up a little
>> loop to capture all disk i/o and network activity (including loopback).
>> That was no obvious help, and the program doesn't use pipes.
>>
>> At this point I'm really curious, does someone have a good clue?
>>
>> Note: I don't think this is a bug or performance issue, unless the
>> kernel is doing something and charging time to iowait instead of system
>> I don't see anything to fix, but I would like to understand.
>
> What tool / kernel instrumentation / mechanism are you using to
> determine that some task(s) are indeed blocked waiting for i/o? Perhaps
> some userspace process accounting tools could be "broken" in the sense
> that they generalize all uninterruptible sleep as waiting for i/o ...

I wouldn't expect /proc/stat and similar to be broken in that way, but 
If no one has a better idea I guess I will assume there's a check needed 
of where time is added to iowait. I was hoping to avoid a full kernel 
search. Never thought of /proc data as a user space tool, but I guess.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

