Return-Path: <linux-kernel-owner+w=401wt.eu-S1762375AbXEJVT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762375AbXEJVT3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 17:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755080AbXEJVTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 17:19:23 -0400
Received: from mail.tmr.com ([64.65.253.246]:33067 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754015AbXEJVTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 17:19:22 -0400
Message-ID: <46438C54.20101@tmr.com>
Date: Thu, 10 May 2007 17:19:16 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Lee Revell <rlrevell@joe-job.com>
CC: Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Preempt of BKL and with tickless systems
References: <4640E64D.3070304@tmr.com> <75b66ecd0705081701n414c29f7r74b0e4836798393a@mail.gmail.com>
In-Reply-To: <75b66ecd0705081701n414c29f7r74b0e4836798393a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lee Revell wrote:
> On 5/8/07, Bill Davidsen <davidsen@tmr.com> wrote:
>> I think I have a reasonable grip on the voluntary and full preempt
>> models, can anyone give me any wisdom on the preempt of the BKL? I know
>> what it does, the question is where it might make a difference under
>> normal loads. Define normal as servers and desktops.
> 
> This was introduced by Ingo to solve a real problem that I found,
> where some codepath would hold the BKL for long enough to introduce
> excessive scheduling latencies - search list archive for details.  But
> I don't remember the code path (scrolling the FB console?  VT
> switching? reiser3?  misc. ioctl()s?).  Basically, taking the BKL
> disabled preemption which caused long latencies.
> 
> It's certainly possible that whatever issue led to this was solved in
> another way since.
> 
Anything is possible. I feel that using voluntary + bkl is probably good 
for most servers, forced preempt for desktop, although it really doesn't 
seem to do much beyond voluntary.

Thanks for the clarification.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
