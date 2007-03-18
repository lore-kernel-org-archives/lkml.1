Return-Path: <linux-kernel-owner+w=401wt.eu-S932098AbXCRDkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098AbXCRDkg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 23:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932112AbXCRDkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 23:40:35 -0400
Received: from mail.tmr.com ([64.65.253.246]:42066 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932098AbXCRDkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 23:40:35 -0400
Message-ID: <45FCB5A1.2020702@tmr.com>
Date: Sat, 17 Mar 2007 22:44:33 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: David Lang <david.lang@digitalinsight.com>
CC: Al Boldi <a1426z@gawab.com>, William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Pluggable Schedulers (was: [ANNOUNCE] RSDL completely fair  
  starvation free interactive cpu scheduler)
References: <200703091625.55361.a1426z@gawab.com>  <20070309135751.GE2986@holomorphy.com> <200703092343.46276.a1426z@gawab.com> <Pine.LNX.4.63.0703091604180.31392@qynat.qvtvafvgr.pbz>
In-Reply-To: <Pine.LNX.4.63.0703091604180.31392@qynat.qvtvafvgr.pbz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Lang wrote:
> On Fri, 9 Mar 2007, Al Boldi wrote:
> 
>>
>>> My preferred sphere of operation is the Manichean domain of faster vs.
>>> slower, functionality vs. non-functionality, and the like. For me, such
>>> design concerns are like the need for a kernel to format pagetables so
>>> the x86 MMU decodes what was intended, or for a compiler to emit valid
>>> assembly instructions, or for a programmer to write C the compiler
>>> won't reject with parse errors.
>>
>> Sure, but I think, even from a technical point of view, competition is 
>> a good
>> thing to have.  Pluggable schedulers give us this kind of competition, 
>> that
>> forces each scheduler to refine or become obsolete.  Think evolution.
> 
> The point Linus is makeing is that with pluggable schedulers there isn't 
> competition between them, the various developer teams would go off in 
> their own direction and any drawbacks to their scheduler could be 
> answered with "that's not what we are good at, use a different 
> scheduler", with the very real possibility that a person could get this 
> answer from ALL schedulers, leaving them with nothing good to use.
> 
Have you noticed that currently that is exactly what happens? If the 
default scheduler doesn't handle your load well you have the option of 
rewriting it and maintaining it, or doing without, or tying to fix your 
case without breaking others, or patching in some other, non-mainline, 
scheduler.

The default scheduler has been around long enough that I don't see it 
being tuned for any A without making some B perform worse. Thus multiple 
schedulers are a possible solution.

They don't need to be available as runtime choices, boot time selection 
would still allow reasonable testing. I can see myself using a compile 
time option and building multiple kernels, but not the average user.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
