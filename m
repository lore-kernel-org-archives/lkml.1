Return-Path: <linux-kernel-owner+w=401wt.eu-S1755675AbZCCFgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675AbZCCFgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 00:36:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750855AbZCCFf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 00:35:59 -0500
Received: from lemon.ertos.nicta.com.au ([203.143.174.143]:40699 "EHLO
	lemon.gelato.unsw.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbZCCFf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 00:35:58 -0500
X-Greylist: delayed 2248 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Mar 2009 00:35:58 EST
Message-ID: <49ACB8EF.4000600@cse.unsw.edu.au>
Date: Tue, 03 Mar 2009 15:58:23 +1100
From: Aaron Carroll <aaronc@cse.unsw.edu.au>
User-Agent: Thunderbird 2.0.0.19 (X11/20090213)
MIME-Version: 1.0
To: =?UTF-8?B?6LCi57qy?= <xiegang112@gmail.com>
CC: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: The difference of request dir between AS and Deadline I/O 	scheduler?
References: <d364733c0903012106g2625d433o4cdbbbcc5a9ff19a@mail.gmail.com>	 <49ACB02D.8070300@cse.unsw.edu.au> <d364733c0903022052g671a07ayf4ded2014d085fdf@mail.gmail.com>
In-Reply-To: <d364733c0903022052g671a07ayf4ded2014d085fdf@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 203.143.161.65
X-SA-Exim-Mail-From: aaronc@cse.unsw.edu.au
X-SA-Exim-Scanned: No (on lemon.gelato.unsw.edu.au); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

谢纲 wrote:
> On Tue, Mar 3, 2009 at 12:21 PM, Aaron Carroll <aaronc@cse.unsw.edu.au> wrote:
>> � wrote:
>>> Hi,
>>>
>>> I'm little confused about the defination of request dir in AS and
>>> Deadline I/O scheduler.
>>> In AS, the request dir is defined by wheher it's sync:
>>>
>>> data_dir = rq_is_sync(rq);
>>>
>>> But in Deadline, the requests are grouped by read and write.
>>>
>>> Why is there the difference since AS is an extension of Deadline?
>>> what's the consideration?
>> I also thought it was silly to have different behaviours, so I tried
>> the following patch that makes deadline use sync/async instead of
>> read/write.  All the benchmarks I tried showed that performance
>> dropped or remained constant at best, so I didn't propose it.
>> Maybe you will have more luck...
> Hello,
> Which benchmark tool do you use? I'd like to have a try. I think the
> I/O behavior is an important factor which can affect the performance.

I can't find the original results, but from memory I tried FIO (many
random readers with various I/O sizes), postmark, and compilebench
on a single-disk and 10-disk hardware RAID system.


    -- Aaron
