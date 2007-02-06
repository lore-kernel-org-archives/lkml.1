Return-Path: <linux-kernel-owner+w=401wt.eu-S932617AbXBFPlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617AbXBFPlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 10:41:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932085AbXBFPlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 10:41:32 -0500
Received: from mail.tmr.com ([64.65.253.246]:35113 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932617AbXBFPlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 10:41:32 -0500
Message-ID: <45C8A18F.3010604@tmr.com>
Date: Tue, 06 Feb 2007 10:41:03 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org>  <20070205084523.GA21858@elte.hu>  <1170682488.29759.795.camel@pmac.infradead.org>  <20070205155627.GA8354@elte.hu>  <1170692539.29759.856.camel@pmac.infradead.org>  <20070205162635.GA755@elte.hu> <20070205163152.GA2464@elte.hu>  <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org>  <1170710272.29759.894.camel@pmac.infradead.org>  <Pine.LNX.4.64.0702051322580.8424@woody.linux-foundation.org>  <1170711587.29759.909.camel@pmac.infradead.org>  <Pine.LNX.4.64.0702051345380.8424@woody.linux-foundation.org> <1170712393.29759.925.camel@pmac.infradead.org> <Pine.LNX.4.64.0702051409110.8424@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0702051409110.8424@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 5 Feb 2007, David Woodhouse wrote:
>> Ten years ago, people used 'depends on' to fix the tools, so that then
>> you want to enable something like USB_STORAGE, it can automatically turn
>> SCSI on for you.
>>
>> Isn't that what you wanted?
> 
> Try it. It's not what it does. 
> 
> If you have a 
> 
> 	depends on SCSI
> 
> and you did not say you wanted SCSI, you'll never even *see* the question.
> 
> It will *not* turn on SCSI automatically for you. Quite the reverse. It 
> will not even show you the option.

My favorite example of this is selinux, which you don't see unless you 
enable other unobvious things first. I say unobvious because until you 
do it the first few times you don't see the option, you ask menuconfig 
where it is, and it isn't there. So you go use your favorite tool to 
search the Kconfig until you find out why.

Now that's in part a failure of the menuconfig tool I use, which may not 
be in xconfig (I'll try that later today when I build a new kernel), but 
it seem odd that a major feature would not show unless something obscure 
were selected, and that the crypto features needed for selinux would be 
good candidates for SELECT.

Just because config is something mostly done by advanced user doesn't 
mean it should be difficult or time-consuming.

And why say "should have done" for the SCSI mess, it's correctable, if 
everyone agrees that you are right (who would dare disagree ;-) then it 
can be fixed.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
